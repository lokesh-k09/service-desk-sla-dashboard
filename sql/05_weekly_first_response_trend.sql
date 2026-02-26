SELECT
    DATE_FORMAT(t.first_response_at, '%Y-%u') AS week_year,
    MIN(DATE(t.first_response_at)) AS week_start_date,
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
GROUP BY
    DATE_FORMAT(t.first_response_at, '%Y-%u'),
    t.priority
ORDER BY
    week_start_date,
    t.priority;