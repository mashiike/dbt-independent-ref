{{
    config(
        materialized='table',
    )
}}

select *
from {{ ref('target_list') }}
