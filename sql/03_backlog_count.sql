SELECT COUNT(*) AS bad_first_response
FROM tickets
WHERE first_response_at < created_at;

SELECT COUNT(*) AS bad_resolution
FROM tickets
WHERE resolved_at < created_at;

SELECT COUNT(*) AS resolved_without_time
FROM tickets
WHERE status = 'Resolved'
AND resolved_at IS NULL;

SELECT status, COUNT(*) AS count_unresolved
FROM tickets
WHERE status != 'Resolved'
group by 1;



-- part 2

select t.priority, count(*) as responded_P, 
sum(case when t.first_response_mins <= s.target_first_response_mins then 1 else 0 end) as responed_intime,
round(
	(sum(case when t.first_response_mins <= s.target_first_response_mins then 1 else 0 end)*100)/count(*),2)  as first_res_perc
from tickets t
join sla_policies s
on t.priority = s.priority
WHERE t.first_response_at IS NOT NULL
group by t.priority;

SELECT
    t.priority,
    COUNT(*) AS responded_tickets,
    SUM(
        CASE
            WHEN t.first_response_mins <= s.target_first_response_mins
            THEN 1 ELSE 0
        END
    ) AS sla_met_count,
    ROUND(
        SUM(
            CASE
                WHEN t.first_response_mins <= s.target_first_response_mins
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS first_response_sla_pct
FROM tickets t
JOIN sla_policies s
    ON t.sla_policy_id = s.sla_policy_id
WHERE t.first_response_at IS NOT NULL
GROUP BY t.priority
ORDER BY t.priority;


select t.priority,
count(*) as total_Resolved_tickets,
sum(
	case when t.resolution_mins <= s.target_resolution_mins then 1 else 0 end) as resolved_tickets_SLA,
round(sum(
	case when t.resolution_mins <= s.target_resolution_mins then 1 else 0 end)*100/count(*),2) as Percentage_resolved_tickets
from tickets t
join sla_policies s
on t.sla_policy_id = s.sla_policy_id
where status != 'Resolved'
group by t.priority;


select count(*) as backlog_count
from tickets
where status != 'Resolved';


with newtab as (select priority, timestampdiff(day, created_at, now()) as backlog_age_days
from tickets
where status != 'Resolved')
select priority,
sum(case when backlog_age_days between 0 and 1 then 1 end) as '0 to 1 Days',
sum(case when backlog_age_days between 2 and 3 then 1 end) as '2 to 3 Days',
sum(case when backlog_age_days between 4 and 7 then 1 end) as '4 to 7 Days',
sum(case when backlog_age_days >= 8 then 1 end) as '>=8 days' 
from newtab
group by priority;

WITH backlog AS (
    SELECT
        TIMESTAMPDIFF(DAY, created_at, NOW()) AS backlog_age_days
    FROM tickets
    WHERE status <> 'Resolved'
)
SELECT
    CASE
        WHEN backlog_age_days <= 1 THEN '0–1 days'
        WHEN backlog_age_days <= 3 THEN '1–3 days'
        WHEN backlog_age_days <= 7 THEN '3–7 days'
        ELSE '7+ days'
    END AS aging_bucket,
    COUNT(*) AS ticket_count
FROM backlog
GROUP BY aging_bucket
ORDER BY
    CASE aging_bucket
        WHEN '0–1 days' THEN 1
        WHEN '1–3 days' THEN 2
        WHEN '3–7 days' THEN 3
        ELSE 4
    END;
