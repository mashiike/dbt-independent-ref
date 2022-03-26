{% snapshot source_data_snapshot %}
{{
    config(
        target_schema=target.schema,
        unique_key='id',
        strategy='check',
        check_cols=['name'],
    )
}}
select * from {{ ref('source_data') }}

{% endsnapshot %}
