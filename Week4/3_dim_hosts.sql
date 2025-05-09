
{{config(materialized = 'table')}}

SELECT
    a.host_id,
    NVL( a.host_name, 'Anonymous') AS host_name,
    a.is_superhost,
    a.created_at,
    a.updated_at
FROM
    {{ ref('stg_hosts') }} a inner join  {{ ref('hosts_snapshot') }} b
    on a.host_id = b.id
    and current_date() between b.DBT_VALID_FROM and nvl(b.DBT_VALID_TO,'9999-12-31')