fct_reviews.sql


{{
    config(
    materialized = 'incremental',
    on_schema_change='fail'
    )
}}
SELECT 
{{dbt_utils.generate_surrogate_key(['listing_id','review_date', 'reviewer_name', 'review_text','review_sentiment'])}} as review_id,
* FROM {{ ref('src_reviews') }}
WHERE review_text is not null
{% if is_incremental() %}
  {% if var("start_date", False) and var("end_date", False) %}
    {{ log('Loading ' ~ this ~ ' incrementally (start_date: ' ~ var("start_date") ~ ', end_date: ' ~ var("end_date") ~ ')', info=True) }}
    AND review_date >= '{{ var("start_date") }}'
    AND review_date < '{{ var("end_date") }}'
  {% else %}
    AND review_date > (select max(review_date) from {{ this }})
    {{ log('Loading ' ~ this ~ ' incrementally (all missing dates)', info=True)}}
  {% endif %}
{% endif %}



--------------------------------
dbt run -m fct_reviews  --vars "{start_date: '2021-09-15 00:00:00', end_date: '2021-10-15 23:59:59'}"
-----------------------------------

