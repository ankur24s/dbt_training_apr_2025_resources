
-- dim_listings.sql
{{config(materialized = 'table')}}

SELECT 
  listing_id,
  listing_name,
  room_type,
  CASE
    WHEN minimum_nights = 0 THEN 1
    ELSE minimum_nights
  END AS minimum_nights,
  host_id,
  REPLACE( price_str, '$') :: NUMBER(10,2) AS price,
  created_at,
  updated_at
FROM
  {{ ref('stg_listings') }}

---------------------------------------------------------------------
-- dim_hosts.sql


{{config(materialized = 'table')}}

SELECT
    host_id,
    NVL( host_name, 'Anonymous') AS host_name,
    is_superhost,
    created_at,
    updated_at
FROM
    {{ ref('stg_hosts') }}

------------------------------------------------------------------------
--fact_reviews.sql

{{config(materialized='table')}}


select * from {{ref('stg_reviews')}}

---------------------------------------------------------------------------

-- dim_listings_w_hosts.sql

{{config(materialized = 'table')}}

SELECT 
    l.listing_id,
    l.listing_name,
    l.room_type,
    l.minimum_nights,
    l.price,
    l.host_id,
    h.host_name,
    h.is_superhost as host_is_superhost,
    l.created_at,
    GREATEST(l.updated_at, h.updated_at) as updated_at
FROM {{ ref('dim_listings')}} l
LEFT JOIN {{ref('dim_hosts')}} h ON (h.host_id = l.host_id)

-------------------------------------