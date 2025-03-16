model(name oso.int_superchain_potential_bots, kind full, enabled false,)
;

with
    union_queries(
        select lower(address) as address, upper(chain_name) as network
        from oso.stg_superchain__potential_bots
    )

select distinct @oso_entity_id(network, '', address) as artifact_id, address, network
from union_queries
