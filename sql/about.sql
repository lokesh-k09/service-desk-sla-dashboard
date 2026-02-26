-- ticket id 1 is created on jan 12, 2026 at 13:00. Assigned to agent A013 with priority P4. Agent sends first response on jan 12, 2026 at 20:08. It is worked till jan 14,2026 at 14:02 and took 2942 minutes to resolve.alter
-- The ticket is resolved.
-- Correct ans: Ticket T000001 (P4) took 2,942 minutes to resolve. Based on the P4 SLA resolution target (5,760 minutes), this ticket met the SLA despite a delayed first response. This shows that long resolution time alone does not imply SLA breach.

-- Who creates the ticket? Customer creates the ticket
-- Who assigns priority? Triage agent
-- When does SLA clock start? When ticket is raised.
-- When does it stop? First response SLA clock stops at first_response_at, Resolution SLA clock stops at resolved_at

-- 3 places where first response can be delayed. 1> High volume of tickets. 2> New issue in the system other than the ones in categoreis. 3 >Ticket with invalid info
-- Delay between ticket creation and assignment during peak volume, Manual reclassification when category does not match predefined options, Back-and-forth clarification when required information is missing /

-- 3 places where resolution can be delayed. 1> Ticket stuck in pending. 2> Escalatiing to senior. 
-- Ticket remains in “Pending” state awaiting customer response while SLA clock continues, Escalation to Tier 2 or senior support increases resolution time due to queue handoff, Reassignment or ownership changes cause delays and loss of context