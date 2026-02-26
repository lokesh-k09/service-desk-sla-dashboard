Project 1: Service Desk SLA Triage and KPI Reporting (Synthetic Data)

Files:
- tickets.csv
- agents.csv
- sla_policies.csv

Row counts:
- tickets: 2500
- agents: 15
- sla_policies: 4

Notes:
- Dates are synthetic and do not represent real events.
- Some tickets are intentionally left unresolved (status != Resolved).
- first_response_mins and resolution_mins are precomputed for convenience.
- sla_*_met flags are derived using sla_policies targets.
