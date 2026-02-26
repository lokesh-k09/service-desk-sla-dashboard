select *
from tickets;

-- How many tickets exist?
select count(*)
from tickets;

-- What date range do they cover?
SELECT DATEDIFF(MAX(resolved_at), MIN(created_at)) AS total_days_span
FROM tickets;

-- How many are unresolved?
select(
count(case when status != 'Resolved' then 1 end)/count(*)) *100 as per_unres
from tickets;

-- How many priorities exist?
select count(distinct(priority)) as priorities
from tickets;

-- What categories dominate volume?
select category, count(category) as high_vol
from tickets
group by category
order by 2 desc;

-- Are there obvious missing fields?
select count(*)
from tickets
where sla_resolution_met is null;

select (
count(
		case when sla_resolution_met = 1 then 1 end
        )/count(*)) * 100 as sla_met_per
from tickets;

select * from sla_policies;

select ticket_id, TIMESTAMPDIFF(minute,created_at,resolved_at) as res
from tickets
where status = 'Resolved';

with newt as 
(select priority,ticket_id, TIMESTAMPDIFF(minute,created_at,first_response_at) as res
from tickets
where status = 'Resolved')
select (
count(case when res <=  p.target_first_response_mins then 1 end)/count(*))*100 as newres
from newt n
join sla_policies p
on p.priority = n.priority;

with newt as 
(select priority,ticket_id, TIMESTAMPDIFF(minute,first_response_at, resolved_at) as res
from tickets
where status = 'Resolved')
select (
count(case when res <=  p.target_resolution_mins
 then 1 end)/count(*))*100 as newres
from newt n
join sla_policies p
on p.priority = n.priority;
