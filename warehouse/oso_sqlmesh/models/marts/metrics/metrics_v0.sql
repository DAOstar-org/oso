MODEL (
  name oso.metrics_v0,
  kind FULL,
  dialect trino,
  tags (
    'export',
    'model_type=full',
    'model_category=metrics',
    'model_stage=mart'
  )
);

/* TODO: We currenly hardcode a set of key metrics coming from OP Atlas */
WITH op_atlas_metric_names AS (
  SELECT DISTINCT
    metric
  FROM oso.int_superchain_s7_m1_rewards
),
unioned_metric_names AS (
  SELECT
    *
  FROM oso.int_metric_names_from_artifact
  UNION ALL
  SELECT
    *
  FROM oso.int_metric_names_from_project
  UNION ALL
  SELECT
    *
  FROM oso.int_metric_names_from_collection
  UNION ALL
  SELECT
    *
  FROM oso.int_key_metric_names_from_artifact
  UNION ALL
  SELECT
    *
  FROM oso.int_key_metric_names_from_project
  UNION ALL
  SELECT
    *
  FROM oso.int_key_metric_names_from_collection
  UNION ALL
  SELECT
    *
  FROM op_atlas_metric_names
), 
op_atlas_metrics_metadata AS (
  SELECT
    'S7_M1_devtooling_reward' AS metric,
    'S7 M1 Dev Tooling Reward' AS display_name,
    'Rewards for Retro Funding S7 - Measurement Period 1 (Feb 2025) - Dev Tooling' AS description,
    'warehouse/oso_sqlmesh/models/intermediate/superchain/s7/rewards/int_superchain_s7_m1_rewards.sql' AS sql_source_path,
    ARRAY['SELECT * FROM oso.int_superchain_s7_m1_rewards WHERE metric = ''S7_M1_devtooling_reward'''] AS rendered_sql
  UNION ALL
  SELECT
    'S7_M1_onchain_builder_reward' AS metric,
    'S7 M1 Onchain Builder Reward' AS display_name,
    'Rewards for Retro Funding S7 - Measurement Period 1 (Feb 2025) - Onchain Builder' AS description,
    'warehouse/oso_sqlmesh/models/intermediate/superchain/s7/rewards/int_superchain_s7_m1_rewards.sql' AS sql_source_path,
    ARRAY['SELECT * FROM oso.int_superchain_s7_m1_rewards WHERE metric = ''S7_M1_onchain_builder_reward'''] AS rendered_sql
),
all_timeseries_metric_names AS (
  SELECT DISTINCT
    metric
  FROM unioned_metric_names
), all_metrics_metadata AS (
  SELECT
    metric,
    display_name,
    description,
    sql_source_path,
    rendered_sql
  FROM oso.metrics_metadata
  UNION ALL
  SELECT
    metric,
    display_name,
    description,
    sql_source_path,
    rendered_sql
  FROM op_atlas_metrics_metadata
), metrics_v0_no_casting AS (
  SELECT
    @oso_id('OSO', 'oso', t.metric) AS metric_id,
    'OSO' AS metric_source,
    'oso' AS metric_namespace,
    t.metric AS metric_name,
    COALESCE(m.display_name, t.metric) AS display_name,
    COALESCE(m.description, 'TODO') AS description,
    COALESCE(m.rendered_sql, []) AS rendered_sql,
    COALESCE(m.sql_source_path, 'TODO') AS sql_source_path,
    'UNKNOWN' AS aggregation_function
  FROM all_timeseries_metric_names AS t
  LEFT JOIN all_metrics_metadata AS m
    ON t.metric LIKE '%' || m.metric || '%'
)
SELECT
  metric_id::VARCHAR,
  metric_source::VARCHAR,
  metric_namespace::VARCHAR,
  metric_name::VARCHAR,
  display_name::VARCHAR,
  description::VARCHAR,
  rendered_sql::ARRAY<VARCHAR>,
  sql_source_path::VARCHAR,
  aggregation_function::VARCHAR
FROM metrics_v0_no_casting
