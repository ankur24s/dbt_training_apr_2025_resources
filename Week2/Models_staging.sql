WITH src_listings AS 
( SELECT
*
FROM
DEV.BRONZE_AIRBNB.src_listings
)
SELECT
id AS listing_id, name AS listing_name, listing_url, room_type, minimum_nights, host_id,
price AS price_str, created_at, updated_at
FROM
src_listings


---------------

WITH src_reviews AS ( SELECT
*
FROM DEV.BRONZE_AIRBNB.src_reviews
)
SELECT
listing_id,
date AS review_date, 
reviewer_name,
comments AS review_text, 
sentiment AS review_sentiment
FROM
src_reviews

------------------

WITH src_hosts AS ( 
    SELECT
*
FROM
       DEV.BRONZE_AIRBNB.SRC_HOSTS
)
SELECT
id AS host_id,
NAME AS host_name, is_superhost, created_at, updated_at
FROM
src_hosts
