
Syntax:


{% snapshot listings_snapshot%}
{{
config
	(
	 target_database = '',
	 target_schema = '',
	 unique_key = 'id',
	 strategy = 'check/timestamp'
	 updated_at/checked_cols = '',
	 invalidate_hard_deletes = true/false
	)
}}


{% endsnapshot %}


	
--------------------------------------strategy = 'check'; invalidate_hard_deletes = false -------------------
{% snapshot listings_snapshot %}
	{{
	config(
		schema = 'snapshot',
		unique_key = 'listing_id',
		strategy = 'check',
		check_cols = ['listing_url','room_type','minimum_nights','price_str'],
		invalidate_hard_deletes =False
		)
	}}

SELECT
listing_id, 
listing_name, 
listing_url, 
room_type, 
minimum_nights, 
host_id,
price_str, 
created_at, 
updated_at
FROM
{{ref('src_listings')}}

{% endsnapshot %}


-- lab steps
---------------strategy = 'check'; invalidate_hard_deletes = false -------------------
{% snapshot listings_snapshot %}
	{{
	config(
		database = 'int',
		schema = 'snapshot',
		unique_key = 'listing_id',
		strategy = 'check',
		check_cols = ['listing_url','room_type','minimum_nights','price_str'],
		invalidate_hard_deletes =True
		)
	}}

SELECT
listing_id, 
listing_name, 
listing_url, 
room_type, 
minimum_nights, 
host_id,
price_str, 
created_at, 
updated_at
FROM
{{ref('src_listings')}}

{% endsnapshot %}

------------------------strategy = 'timestamp'; invalidate_hard_deletes = false -------------------
{% snapshot listings_snapshot %}
	{{
	config(
		schema = 'snapshot',
		unique_key = 'listing_id',
		strategy = 'timestamp',
		updated_at='updated_at',
		invalidate_hard_deletes =True
		)
	}}

SELECT
listing_id, 
listing_name, 
listing_url, 
room_type, 
minimum_nights, 
host_id,
price_str, 
created_at, 
updated_at
FROM
{{ref('src_listings')}}

{% endsnapshot %}


---- Add dbt_valid_to_current:

{% snapshot listings_snapshot %}
	{{
	config(
		database = 'int',
		schema = 'snapshot',
		unique_key = 'listing_id',
		strategy = 'timestamp',
		updated_at='updated_at',
		dbt_valid_to_current = 'to_date('9999-12-31')'
		invalidate_hard_deletes =True
		)
	}}

SELECT
listing_id, 
listing_name, 
listing_url, 
room_type, 
minimum_nights, 
host_id,
price_str, 
created_at, 
updated_at
FROM
{{ref('src_listings')}}

{% endsnapshot %}