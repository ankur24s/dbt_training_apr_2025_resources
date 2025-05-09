MACROS

CUSTOM GENERIC TESTS

--The contents of macros/positive_value.sql

{% test positive_value(model, column_name) %}
SELECT
 *
FROM
 {{ model }}
WHERE
 {{ column_name}} < 1
{% endtest %}


----------------
models:
  - name: dim_listings
    description: Cleansed table which contains Airbnb listings.
    columns:
		- name: minimum_nights
				description: '{{ doc("dim_listings_minimum_nights") }}'
				tests:
				  - positive_value
				  
				  
				  
----

{% macro generate_hash_key_args(args) %}
      md5(
	  concat_ws('-', 
				{% for arg in args %}
					{{ arg }}
                    {% if not loop.last %}
							, 
					{% endif %}
				{% endfor %}
			)
	)
{% endmacro %}