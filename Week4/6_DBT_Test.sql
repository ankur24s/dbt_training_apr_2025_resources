-- https://docs.getdbt.com/docs/build/data-tests


select * from  gold_airbnb.dim_listings


select distinct room_type from   gold_airbnb.dim_listings
/*
['Entire home/apt',
'Private room',
'Shared room',
'Entire Home',
'Hotel room']
*/

-- schema.yml
version: 2

models:
  - name: dim_listings
    columns:
      
      - name: listing_id
        tests:
          - unique
          - not_null

      - name: host_id
        tests:
          - not_null
          - relationships:
              to: ref('dim_hosts')
              field: host_id

      
      - name: room_type
        tests:
          - accepted_values:
              values: ['Entire home/apt',
                      'Private room',
                      'Shared room',
                      'Entire Home',
                      'Hotel room']
					  
					  
					  
-- dbt test -m dim_listings (running all test associated with that models)
-- dbt test relationships_dim_listings_host_id__host_id__ref_dim_hosts_ (running the single test)
						
-- Generic tests
-- create a test in test>dim_listings_minimum_nights.SQL
select * from 
{{ref('dim_listings')}}
where minimum_nights <1
limit 10

-- dbt test --select dim_listings_minimum_nights
--Assignment instructions

-- consistent_created_at.sql

-- Create a singular test in tests/consistent_created_at.sql that 

checks that there is no review date that is submitted before its listing was created: Make sure that every review_date in fct_reviews is more recent than the associated created_at in dim_listings_cleansed.


--Please provide the source code of the test.


solution:
SELECT * FROM {{ ref('dim_listings') }} l
INNER JOIN {{ ref('fct_reviews') }} r
USING (listing_id)
WHERE l.created_at >= r.review_date