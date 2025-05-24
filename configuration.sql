-- Get logical instance-level configuration values for instance  (Query 2) (Configuration Values)
SELECT name, value, value_in_use, minimum, maximum, [description], is_dynamic, is_advanced
FROM sys.configurations WITH (NOLOCK)
ORDER BY name OPTION (RECOMPILE);
------
-- All of these settings are read-only in Azure SQL Database, so they are informational only