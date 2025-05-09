{{
    config(
    materialized = 'incremental',
    on_schema_change='fail'
    )
}}
SELECT 
{{generate_hash_key_args(['listing_id','review_date', 'reviewer_name', 'review_text','review_sentiment'])}} as review_id,
 * FROM {{ ref('stg_reviews') }}
WHERE review_text is not null
{% if is_incremental() %}
and review_date > (select DATEADD('day', -7, max(review_date)) from {{this}})
{% endif %}