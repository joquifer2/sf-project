-- Consulta para listar los parámetros disponibles en event_params para eventos de sesión
SELECT DISTINCT param.key
FROM `datamart-sf.analytics_343805932.events_*`, UNNEST(event_params) AS param
WHERE event_name = 'session_start'
ORDER BY param.key;
