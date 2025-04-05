MODEL (
  name oso.stg_superchain__deployers,
  kind INCREMENTAL_BY_TIME_RANGE (
    time_column block_timestamp,
    batch_size 180,
    batch_concurrency 1,
    lookback 7
  ),
  start @blockchain_incremental_start,
  cron '@daily',
  partitioned_by (DAY("block_timestamp"), "chain"),
  grain (block_timestamp, chain_id, transaction_hash, deployer_address, contract_address),
  dialect duckdb,
);

@transactions_with_receipts_deployers(
  @start_dt,
  @end_dt,
  @oso_source('bigquery.optimism_superchain_raw_onchain_data.transactions'),
  @chain_name(transactions.chain) AS chain,
  block_timestamp_column := @from_unix_timestamp(transactions.block_timestamp),
  time_partition_column := transactions.dt
)