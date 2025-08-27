{{ config(
    materialized='table',  
    schema='dim'
) }}


WITH
basics AS(
    SELECT DISTINCT
    campaign_id
    FROM `datamart-sf.raw_google.p_ads_CampaignBasicStats_6548973758`
),

criterion AS
(
    SELECT DISTINCT
        campaign_id,
        campaign_name
    FROM `datamart-sf.raw_google.p_ads_CampaignCriterion_6548973758`
)

SELECT
    b.campaign_id,
    c.campaign_name,
    CASE
      WHEN REGEXP_CONTAINS(c.campaign_name, r' RESTAURANTE - \(LV\)') THEN "Menú degustación"
      WHEN REGEXP_CONTAINS(c.campaign_name, r' RESTAURANTE - \(SD\)') THEN "Menú degustación"
      WHEN REGEXP_CONTAINS(c.campaign_name, r' EMPRESA') THEN "Evento de empresa"
      ELSE "Marca/Restaurante"
    END AS category_cost,
    CASE
      WHEN REGEXP_CONTAINS(c.campaign_name, r'^S') THEN "Search"
      WHEN REGEXP_CONTAINS(c.campaign_name, r'^GMAPS') THEN "GMAPS"
      WHEN REGEXP_CONTAINS(c.campaign_name, r'^PMAX') THEN "PMAX"
      ELSE "Other"
    END AS campaign_type
FROM basics b
LEFT JOIN criterion c
ON b.campaign_id = c.campaign_id


