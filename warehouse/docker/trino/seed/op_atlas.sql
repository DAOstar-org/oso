CREATE SCHEMA IF NOT EXISTS bigquery.op_atlas;

CREATE TABLE IF NOT EXISTS bigquery.op_atlas.application (
   id varchar NOT NULL,
   status varchar NOT NULL,
   attestation_id varchar NOT NULL,
   created_at timestamp(6) with time zone NOT NULL,
   updated_at timestamp(6) with time zone NOT NULL,
   round_id varchar NOT NULL,
   project_id varchar NOT NULL,
   category_id varchar,
   _dlt_load_id varchar NOT NULL,
   _dlt_id varchar NOT NULL
);

INSERT INTO
   bigquery.op_atlas.application (
      id,
      status,
      attestation_id,
      created_at,
      updated_at,
      round_id,
      project_id,
      category_id,
      _dlt_load_id,
      _dlt_id
   )
VALUES
   (
      '1',
      'active',
      'att1',
      current_timestamp - interval '2' day,
      current_timestamp - interval '2' day,
      'round1',
      'proj1',
      'cat1',
      'load1',
      'dlt1'
   ),
   (
      '2',
      'inactive',
      'att2',
      current_timestamp - interval '1' day,
      current_timestamp - interval '1' day,
      'round2',
      'proj2',
      'cat2',
      'load2',
      'dlt2'
   );

CREATE TABLE IF NOT EXISTS bigquery.op_atlas.project (
   id varchar NOT NULL,
   name varchar NOT NULL,
   description varchar,
   category varchar,
   thumbnail_url varchar,
   banner_url varchar,
   twitter varchar,
   mirror varchar,
   open_source_observer_slug varchar,
   added_team_members boolean NOT NULL,
   added_funding boolean NOT NULL,
   last_metadata_update timestamp(6) with time zone NOT NULL,
   created_at timestamp(6) with time zone NOT NULL,
   updated_at timestamp(6) with time zone NOT NULL,
   deleted_at timestamp(6) with time zone,
   has_code_repositories boolean NOT NULL,
   is_on_chain_contract boolean NOT NULL,
   pricing_model varchar,
   pricing_model_details varchar,
   is_submitted_to_oso boolean NOT NULL,
   _dlt_load_id varchar NOT NULL,
   _dlt_id varchar NOT NULL
);

INSERT INTO
   bigquery.op_atlas.project (
      id,
      name,
      description,
      category,
      thumbnail_url,
      banner_url,
      twitter,
      mirror,
      open_source_observer_slug,
      added_team_members,
      added_funding,
      last_metadata_update,
      created_at,
      updated_at,
      deleted_at,
      has_code_repositories,
      is_on_chain_contract,
      pricing_model,
      pricing_model_details,
      is_submitted_to_oso,
      _dlt_load_id,
      _dlt_id
   )
VALUES
   (
      '1',
      'Project One',
      'Description One',
      'Category One',
      'http://thumbnail1.com',
      'http://banner1.com',
      'twitter1',
      'mirror1',
      'slug1',
      true,
      true,
      current_timestamp - interval '2' day,
      current_timestamp - interval '2' day,
      current_timestamp - interval '2' day,
      NULL,
      true,
      true,
      'model1',
      'details1',
      true,
      'load1',
      'dlt1'
   ),
   (
      '2',
      'Project Two',
      'Description Two',
      'Category Two',
      'http://thumbnail2.com',
      'http://banner2.com',
      'twitter2',
      'mirror2',
      'slug2',
      false,
      false,
      current_timestamp - interval '1' day,
      current_timestamp - interval '1' day,
      current_timestamp - interval '1' day,
      NULL,
      false,
      false,
      'model2',
      'details2',
      false,
      'load2',
      'dlt2'
   );

CREATE TABLE IF NOT EXISTS bigquery.op_atlas.project__defi_llama_slug (
   value varchar,
   _dlt_parent_id varchar NOT NULL,
   _dlt_list_idx bigint NOT NULL,
   _dlt_id varchar NOT NULL
);

INSERT INTO
   bigquery.op_atlas.project__defi_llama_slug (value, _dlt_parent_id, _dlt_list_idx, _dlt_id)
VALUES
   ('slug1', 'parent1', 1, 'dlt1'),
   ('slug2', 'parent2', 2, 'dlt2');

CREATE TABLE IF NOT EXISTS bigquery.op_atlas.project__farcaster (
   value varchar,
   _dlt_parent_id varchar NOT NULL,
   _dlt_list_idx bigint NOT NULL,
   _dlt_id varchar NOT NULL
);

INSERT INTO
   bigquery.op_atlas.project__farcaster (value, _dlt_parent_id, _dlt_list_idx, _dlt_id)
VALUES
   ('farcaster1', 'parent1', 1, 'dlt1'),
   ('farcaster2', 'parent2', 2, 'dlt2');

CREATE TABLE IF NOT EXISTS bigquery.op_atlas.project__website (
   value varchar,
   _dlt_parent_id varchar NOT NULL,
   _dlt_list_idx bigint NOT NULL,
   _dlt_id varchar NOT NULL
);

INSERT INTO
   bigquery.op_atlas.project__website (value, _dlt_parent_id, _dlt_list_idx, _dlt_id)
VALUES
   ('http://website1.com', 'parent1', 1, 'dlt1'),
   ('http://website2.com', 'parent2', 2, 'dlt2');

CREATE TABLE IF NOT EXISTS bigquery.op_atlas.project_contract (
   id varchar NOT NULL,
   contract_address varchar NOT NULL,
   deployer_address varchar NOT NULL,
   deployment_hash varchar NOT NULL,
   verification_proof varchar NOT NULL,
   chain_id bigint NOT NULL,
   created_at timestamp(6) with time zone NOT NULL,
   updated_at timestamp(6) with time zone NOT NULL,
   project_id varchar NOT NULL,
   description varchar,
   name varchar,
   _dlt_load_id varchar NOT NULL,
   _dlt_id varchar NOT NULL,
   verification_chain_id bigint
);

INSERT INTO
   bigquery.op_atlas.project_contract (
      id,
      contract_address,
      deployer_address,
      deployment_hash,
      verification_proof,
      chain_id,
      created_at,
      updated_at,
      project_id,
      description,
      name,
      _dlt_load_id,
      _dlt_id,
      verification_chain_id
   )
VALUES
   (
      '1',
      '0x123',
      '0xabc',
      'hash1',
      'proof1',
      1,
      current_timestamp - interval '2' day,
      current_timestamp - interval '2' day,
      'proj1',
      'Description One',
      'Contract One',
      'load1',
      'dlt1',
      1
   ),
   (
      '2',
      '0x456',
      '0xdef',
      'hash2',
      'proof2',
      2,
      current_timestamp - interval '1' day,
      current_timestamp - interval '1' day,
      'proj2',
      'Description Two',
      'Contract Two',
      'load2',
      'dlt2',
      2
   );

CREATE TABLE IF NOT EXISTS bigquery.op_atlas.project_links (
   id varchar NOT NULL,
   url varchar NOT NULL,
   name varchar,
   description varchar,
   created_at timestamp(6) with time zone NOT NULL,
   updated_at timestamp(6) with time zone NOT NULL,
   project_id varchar NOT NULL,
   _dlt_load_id varchar NOT NULL,
   _dlt_id varchar NOT NULL
);

INSERT INTO
   bigquery.op_atlas.project_links (
      id,
      url,
      name,
      description,
      created_at,
      updated_at,
      project_id,
      _dlt_load_id,
      _dlt_id
   )
VALUES
   (
      '1',
      'http://link1.com',
      'Link One',
      'Description One',
      current_timestamp - interval '2' day,
      current_timestamp - interval '2' day,
      'proj1',
      'load1',
      'dlt1'
   ),
   (
      '2',
      'http://link2.com',
      'Link Two',
      'Description Two',
      current_timestamp - interval '1' day,
      current_timestamp - interval '1' day,
      'proj2',
      'load2',
      'dlt2'
   );

CREATE TABLE IF NOT EXISTS bigquery.op_atlas.project_repository (
   id varchar NOT NULL,
   type varchar NOT NULL,
   url varchar NOT NULL,
   verified boolean NOT NULL,
   open_source boolean NOT NULL,
   contains_contracts boolean NOT NULL,
   created_at timestamp(6) with time zone NOT NULL,
   updated_at timestamp(6) with time zone NOT NULL,
   project_id varchar NOT NULL,
   description varchar,
   name varchar,
   crate boolean NOT NULL,
   npm_package boolean NOT NULL,
   _dlt_load_id varchar NOT NULL,
   _dlt_id varchar NOT NULL
);

INSERT INTO
   bigquery.op_atlas.project_repository (
      id,
      type,
      url,
      verified,
      open_source,
      contains_contracts,
      created_at,
      updated_at,
      project_id,
      description,
      name,
      crate,
      npm_package,
      _dlt_load_id,
      _dlt_id
   )
VALUES
   (
      '1',
      'github',
      'http://repo1.com',
      true,
      true,
      true,
      current_timestamp - interval '2' day,
      current_timestamp - interval '2' day,
      'proj1',
      'Description One',
      'Repo One',
      true,
      true,
      'load1',
      'dlt1'
   ),
   (
      '2',
      'gitlab',
      'http://repo2.com',
      false,
      false,
      false,
      current_timestamp - interval '1' day,
      current_timestamp - interval '1' day,
      'proj2',
      'Description Two',
      'Repo Two',
      false,
      false,
      'load2',
      'dlt2'
   );

CREATE TABLE IF NOT EXISTS bigquery.op_atlas.project_organization (
   id varchar NOT NULL,
   created_at timestamp(6) with time zone NOT NULL,
   updated_at timestamp(6) with time zone NOT NULL,
   deleted_at timestamp(6) with time zone,
   project_id varchar NOT NULL,
   organization_id varchar NOT NULL,
   _dlt_load_id varchar NOT NULL,
   _dlt_id varchar NOT NULL
);

INSERT INTO bigquery.op_atlas.project_organization (
   id,
   created_at,
   updated_at,
   deleted_at,
   project_id,
   organization_id,
   _dlt_load_id,
   _dlt_id
)
VALUES
   (
      'b9ee1d25-860e-4aa5-aa80-cf48ff5c2473',
      TIMESTAMP '2025-03-23 17:13:21.416000 UTC',
      TIMESTAMP '2025-03-23 17:13:23.471000 UTC',
      NULL,
      '0x1490a15d46c7707536fc9068da7c7d775f22562b346bf5c95369b03f9e3e7dad',
      '0xdc657d35031ec0b83ab379362609213e7627679e587ecca26b62d3ad628c6535',
      '1742818377.7490938',
      'NdevF1HflHupNg'
   ),
   (
      '31c20a43-96e7-43a2-997c-068980b0402b',
      TIMESTAMP '2025-03-25 05:33:06.102000 UTC',
      TIMESTAMP '2025-03-25 05:33:08.608000 UTC',
      NULL,
      '0x68f3271c77c9fd815707cefabcccb85457cfc820b65785d29356419243919365',
      '0x73d3d11609826f7bf461155891b33e4468925d19968cc7e08c5e1ed7a33dbbdb',
      '1742904671.6629562',
      'CuC7kK33myYchA'
   ),
   (
      'fba0c497-b920-4435-a56d-a35066781844',
      TIMESTAMP '2025-03-25 14:48:04.348000 UTC',
      TIMESTAMP '2025-03-25 14:48:06.420000 UTC',
      NULL,
      '0xd9e0c75338d41d200ebe8d347cdedea7b648b38452aa45c9cd87bdebee726786',
      '0xd644132af288877e2766885b748590155eaebd95239b67d4e64d05ae8adfbfdd',
      '1742991242.7355466',
      '3EakcqUc5oQXUg'
   ),
   (
      'fba0c497-b920-4435-a56d-a35066781844',
      TIMESTAMP '2025-03-25 14:48:04.348000 UTC',
      TIMESTAMP '2025-03-25 14:48:06.420000 UTC',
      NULL,
      '0xd9e0c75338d41d200ebe8d347cdedea7b648b38452aa45c9cd87bdebee726786',
      '0xd644132af288877e2766885b748590155eaebd95239b67d4e64d05ae8adfbfdd',
      '1742992293.7080584',
      'HEgrn+HEOtW6gQ'
   ),
   (
      '5acb646c-4bb9-4e6a-8246-b95f9397773b',
      TIMESTAMP '2025-03-25 19:41:42.653000 UTC',
      TIMESTAMP '2025-03-25 19:41:44.743000 UTC',
      NULL,
      '0x0576376ae9134c25737f66a10f5d1b62c4df03301c876dc00a4ff1e4ea2e7bd3',
      '0x9791b3ca77df18d1968fe55ec0ec33ec764c70712184f199b2f5d18a83f7bee4',
      '1742991242.7355466',
      'xRtzztjE6V3etg'
   );
