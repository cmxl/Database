-- Get database scoped configuration values for current database (Query 20) (Database-scoped Configurations)
SELECT configuration_id, [name], [value] AS [value_for_primary]
FROM sys.database_scoped_configurations WITH (NOLOCK) OPTION (RECOMPILE);
------

-- This lets you see the value of these new properties for the current database

-- Clear plan cache for current database
-- ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE;

-- ALTER DATABASE SCOPED CONFIGURATION (Transact-SQL)
-- https://bit.ly/2sOH7nb
