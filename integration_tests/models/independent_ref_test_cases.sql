{%- set model_names = [
    'source_data',
    'target_list',
    'source_data_snapshot'
] %}
{%- set package_name = 'dbt_independent_ref_integration_tests' %}

{%- for model_name in model_names %}
select '{{ package_name }}' as package_name, '{{ model_name }}' as model_name, '{{ ref(package_name, model_name) }}' as expected , '{{ independent_ref(package_name, model_name) }}' as actual
{% if not loop.last %} union all {% endif %}
{%- endfor %}
union all
{%- for model_name in model_names %}
select null as package_name, '{{ model_name }}' as model_name, '{{ ref(model_name) }}' as expected , '{{ independent_ref(model_name) }}' as actual
{% if not loop.last %} union all {% endif %}
{%- endfor %}
