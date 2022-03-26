{%- macro independent_ref() %}
    {{ return(dbt_independent_ref.independent_ref(*varargs)) }}
{%- endmacro %}
