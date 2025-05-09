{% snapshot hosts_snapshot %}
{{
 config(
 schema='snapshot',
 unique_key='id',
 strategy='timestamp',
 updated_at='updated_at',
 invalidate_hard_deletes=True
 )
}}
select * FROM {{source('bronze_airbnb','hosts')}}
{% endsnapshot %}