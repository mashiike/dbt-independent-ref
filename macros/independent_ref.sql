{#
-- Copyright 2022 mashiike (ikeda-masashi).
--
-- This dbt package is released under the MIT License.
-- license that can be found in the LICENSE file.
-- https://github.com/mashiike/dbt-independent-ref/blob/main/LICENSE
#}

{%- macro independent_ref() %}
    {%- if execute %}
        {%- if (varargs | length) == 1 %}
            {%- set package_name = none %}
            {%- set model_name = varargs[0] %}
        {%- else %}
            {%- set package_name = varargs[0] %}
            {%- set model_name = varargs[1] %}
        {%- endif %}
        {%- set nodes = graph.nodes.values()
            | selectattr("resource_type", "in", ["model", "seed", "snapshot"]) %}
        {%- if package_name is not none %}
            {%- set nodes = nodes | selectattr("package_name", "equalto", package_name) %}
        {%- endif %}
        {%- for node in nodes %}
            {%- if node.name == model_name %}
                {{ return(api.Relation.create(database=node.database,schema=node.schema,identifier=node.alias)) }}
            {%- endif %}
        {%- endfor %}
        {%- set message =  "Model '"~model['unique_id'] ~ "' ("~ model['original_file_path']~")  independent references on a node named '" ~ model_name ~"'" %}
        {% if package_name is not none %}
            {%- set message = message ~ " in package '" ~ package_name ~ "'" %}
        {% endif %}
        {%- set message = message ~ " witch was not found" %}
        {{ exceptions.raise_compiler_error(message)}}
    {%- endif %}
{%- endmacro %}
