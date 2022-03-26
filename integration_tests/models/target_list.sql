{{
    config(
        materialized='table',
    )
}}

select *
from {{ ref('source_data') }} t
{%- set r = independent_ref('processed_list') %}
{%- if adapter.get_relation(database=r.database,schema=r.schema,identifier=r.identifier) is not none %}
where not exists (
    select 1
    from {{ r }} p
    where t.id = p.id
)
{%- endif %}
limit 2
