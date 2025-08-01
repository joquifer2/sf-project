{{ config(
    materialized='view',
    schema='stg'
) }}

SELECT
  event_date AS session_date,
  traffic_source.source AS source,
  traffic_source.medium AS medium,
  CASE
    WHEN traffic_source.source IS NULL OR traffic_source.source = 'Data Not Available' THEN 'No identificado'
    WHEN REGEXP_CONTAINS(LOWER(traffic_source.source), r'(facebook|instagram|twitter|linkedin|tiktok|youtube)') THEN 'Organic Social'
    WHEN traffic_source.medium = 'organic' THEN 'Organic Search'
    WHEN traffic_source.medium = 'cpc' THEN 'Paid Search'
    WHEN traffic_source.source LIKE '%direct%' THEN 'Directo'
    WHEN traffic_source.medium = 'referral' THEN 'Referral'
    WHEN traffic_source.medium = 'email' THEN 'Email'
    WHEN traffic_source.medium = 'social' THEN 'Organic Social'
    WHEN traffic_source.medium = 'paid_social' THEN 'Paid Social'
    WHEN traffic_source.medium = 'display' THEN 'Display'
    WHEN traffic_source.medium = 'direct' THEN 'Direct'
    ELSE 'Other'
  END AS channel_group,
  ANY_VALUE((
    SELECT value.string_value
    FROM UNNEST(event_params) AS param
    WHERE param.key = 'gclid'
  )) AS gclid,
  COUNT(DISTINCT (
    SELECT value.int_value
    FROM UNNEST(event_params) AS param
    WHERE param.key = 'ga_session_id'
  )) AS sessions
FROM `datamart-sf.analytics_343805932.events_*`
WHERE event_name = 'session_start'
GROUP BY
  event_date,
  traffic_source.source,
  traffic_source.medium,
  channel_group
