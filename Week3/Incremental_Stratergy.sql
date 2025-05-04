----------------Incremental Models Overview



----------------------merge---------------------------------------

{{
    config(
    materialized = 'incremental',
    unique_key = ['listing_id','reviewer_name'],
    merge_update_columns = ['review_text','REVIEW_DATE']
    )
}}
SELECT * FROM {{ ref('stg_reviews') }}
WHERE review_text is not null
{% if is_incremental() %}
and review_date > (select max(review_date) from {{this}})
{% endif %}

------------------------------append---------------------------------

{{
    config(
    materialized = 'incremental',
    incremental_strategy='append'
    )
}}
SELECT * FROM {{ ref('stg_reviews') }}
WHERE review_text is not null
{% if is_incremental() %}
and review_date > (select max(review_date) from {{this}})
{% endif %}

---------------------------------delete+insert------------------------------
{{
    config(
    materialized = 'incremental',
    unique_key= ['listing_id','reviewer_name'],
    incremental_strategy='delete+insert',
    )
}}
SELECT * FROM {{ ref('stg_reviews') }}
WHERE review_text is not null
{% if is_incremental() %}
and review_date > (select DATEADD('day', -7, max(review_date)) from {{this}})
{% endif %}


---------------------Merge with incremental_predicates-------------------------
{{
  config(
    materialized = 'incremental',
    unique_key = ['listing_id','reviewer_name','review_date'],
    cluster_by = ['review_date'],  
    incremental_strategy = 'merge',
	  incremental_predicates 	= [
      "DBT_INTERNAL_DEST.review_date > dateadd(year, -4, current_date)"
      ]
  )
}}
SELECT * FROM {{ ref('stg_reviews') }}
WHERE review_text is not null
{% if is_incremental() %}
and review_date > (select DATEADD('day', -7, max(review_date)) from {{this}})
{% endif %}

-------------------Try to execute all of them and check the dbt.log file and target>run and target>compiled folder for better understanding---------

