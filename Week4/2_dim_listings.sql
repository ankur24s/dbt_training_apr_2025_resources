SELECT 
  a.listing_id,
  a.listing_name,
  a.room_type,
  CASE WHEN a.minimum_nights = 0 THEN 1  ELSE a.minimum_nights END AS minimum_nights,
  a.host_id,
  REPLACE( a.price_str, '$') :: NUMBER(10,2) AS price,
  a.created_at,
  a.updated_at
FROM
  {{ ref('stg_listings') }} a  inner join  {{ ref('listings_snapshot') }} b
    on a.listing_id = b.listing_id
    and current_date() between b.DBT_VALID_FROM and nvl(b.DBT_VALID_TO,'9999-12-31')