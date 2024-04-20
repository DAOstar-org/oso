{# 
  This model calculates the total man-months of developer activity
  for each project in various time ranges.

  The model uses the active_devs_monthly_to_project model to segment
  developers based on monthly activity using the Electric Capital
  Developer Report taxonomy.
#}
{{ 
  config(meta = {
    'sync_to_cloudsql': True
  }) 
}}

SELECT
  e.project_id,
  e.repository_source AS namespace,
  tr.time_interval,
  CONCAT(e.user_segment_type, '_TOTAL') AS impact_metric,
  SUM(e.amount) AS amount
FROM {{ ref('active_devs_monthly_to_project') }} AS e
CROSS JOIN {{ ref('time_ranges') }} AS tr
WHERE
  DATE(e.bucket_month) >= DATE_TRUNC(tr.start_date, MONTH)
  AND DATE(e.bucket_month) < DATE_TRUNC(CURRENT_DATE(), MONTH)
GROUP BY
  e.project_id,
  e.repository_source,
  tr.time_interval,
  e.user_segment_type
