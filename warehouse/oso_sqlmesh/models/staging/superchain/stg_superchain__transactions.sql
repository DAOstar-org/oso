MODEL (
  name oso.stg_superchain__transactions,
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column block_timestamp,
    batch_size 90,
    batch_concurrency 1,
    lookback 7
  ),
  start '2021-10-01',
  cron '@daily',
  partitioned_by (DAY("block_timestamp"), "chain"),
  grain (block_timestamp, chain, transaction_hash, from_address, to_address),
  dialect duckdb,
);

SELECT
  @from_unix_timestamp(block_timestamp) AS block_timestamp,
  "hash" AS transaction_hash,
  from_address,
  to_address,
  gas AS gas_used,
  gas_price,
  value_lossless,
  @chain_name(chain) AS chain
FROM @oso_source('bigquery.optimism_superchain_raw_onchain_data.transactions')
WHERE
  network = 'mainnet'
  AND receipt_status = 1
  AND gas > 0
  AND /* Bigquery requires we specify partitions to filter for this data source */ dt BETWEEN @start_dt AND @end_dt