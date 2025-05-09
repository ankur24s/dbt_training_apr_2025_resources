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