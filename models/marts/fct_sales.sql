{{ config(
    materialized='table',
    schema='marts'
) }}

WITH sales as (
    SELECT
        date,
        service,    
        sales,
        sales_amount
    FROM {{ ref('stg_servicios_diario') }}
),

dim_dates as (
    SELECT
        date,
        date_week,
        date_month,
        year,
        month_name,
        weekday,
        is_weekend
    FROM {{ ref('dim_dates') }}
),

dim_servicios as (
    SELECT
        id,
        service,
        service_category
    FROM {{ ref('dim_services') }}
)

SELECT
    dim_dates.date,
    dim_dates.date_week,
    dim_dates.date_month,
    dim_dates.year,
    dim_dates.month_name,
    dim_dates.weekday,
    dim_dates.is_weekend,
    dim_servicios.service,
    dim_servicios.service_category,
    sales.sales,
    sales.sales_amount
FROM sales
LEFT JOIN dim_dates ON sales.date = dim_dates.date
LEFT JOIN dim_servicios ON sales.service = dim_servicios.service
