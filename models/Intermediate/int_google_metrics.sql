 {{ config(
    materialized='table',
    schema='int'
) }}

 SELECT DISTINCT
    campaign_id,
    date,
    sum(cost) as cost,
    sum(clicks) AS clicks,
    sum(impressions) AS impressions
FROM {{ ref('stg_google_metrics') }}
GROUP BY campaign_id, date
