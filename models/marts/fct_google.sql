{{ config(
    materialized='table',
    schema='marts',
    partition_by={"field": "date", "data_type": "date"},
    cluster_by=["campaign_name"]
) }}

SELECT
    m.campaign_id,
    m.date,
    dd.date_week,
    dd.date_month,
    SUM(m.cost) AS cost,
    SUM(m.clicks) AS clicks,
    SUM(m.impressions) AS impressions,
    d.campaign_name,
    d.category_cost,
    d.campaign_type
FROM {{ ref('int_google_metrics') }} AS m
LEFT JOIN {{ ref('dim_campaigns_gl') }} AS d
    ON m.campaign_id = d.campaign_id
LEFT JOIN {{ ref('dim_dates') }} AS dd
    ON m.date = dd.date
GROUP BY
    m.campaign_id,
    m.date,
    dd.date_week,
    dd.date_month,
    d.campaign_name,
    d.category_cost,
    d.campaign_type
