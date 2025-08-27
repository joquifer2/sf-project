 {{ config(
    materialized='view',
    schema='stg'
) }}

 SELECT DISTINCT
    campaign_id,
    segments_date AS date,
    metrics_cost_micros / 1000000 AS cost,
    metrics_clicks AS  clicks,
    metrics_impressions AS impressions
FROM `datamart-sf.raw_google.p_ads_CampaignBasicStats_6548973758`
WHERE segments_date IS NOT NULL
