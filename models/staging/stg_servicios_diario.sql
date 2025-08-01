
{{ config(
    materialized='view',
    schema='stg'
) }}

SELECT
  Fecha as date,
  Servicio as service,
  Ventas as sales,
  Importe as sales_amount
FROM `datamart-sf.raw_sheets.raw_servicios_diario`