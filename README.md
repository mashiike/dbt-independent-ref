# dbt-independent-ref

a DBT package for niche cases. Extensive use is not recommended.  

When managing SQL execution with DBT, there are times when you really want to write circular references. 
As a solution, this package provides special macros that behave like ref macros but do not build dependencies.

## Installation

### as DBT package 

Add to your packages.yml
```yaml
packages:
  - git: "https://github.com/mashiike/dbt-independent-ref"
    revision: v0.0.0
```

In addition, to simplify the description, if you write a macro in your own project, it will be as follows.
```
{%- macro independent_ref() %}
    {{ return(dbt_independent_ref.independent_ref(*varargs)) }}
{%- endmacro %}
```

### as self project Macro

Copy the following files into your DBT project: [macros/independent_ref.sql](https://github.com/mashiike/dbt-independent-ref/blob/main/macros/independent_ref.sql)

## Usecase 

When defining a list of targets for a process, it is assumed to be used as follows

models/target_list.sql
```sql
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
limit 100
```

models/processed_list.sql
```
{{
    config(
        materialized='incremental',
        unique_key='id',
    )
}}

select *
from {{ ref('target_list') }}
```

 If independent_ref() in models/target_list.sql is a normal ref(), the following error will occur.
 ```
 Found a cycle: model.dbt_independent_ref_integration_tests.target_list --> model.dbt_independent_ref_integration_tests.processed_list
 ```

## LICENSE

MIT 

