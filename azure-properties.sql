-- Retrieve some Azure SQL Database properties (Query 56) (Azure SQL DB Properties)
SELECT DATABASEPROPERTYEX (DB_NAME(DB_ID()), 'Edition') AS [Database Edition],
	   DATABASEPROPERTYEX (DB_NAME(DB_ID()), 'ServiceObjective') AS [Service Objective],
	   DATABASEPROPERTYEX (DB_NAME(DB_ID()), 'MaxSizeInBytes') AS [Max Size In Bytes],
	   DATABASEPROPERTYEX (DB_NAME(DB_ID()), 'IsXTPSupported') AS [Is XTP Supported]
	   OPTION (RECOMPILE);   
------  

-- DATABASEPROPERTYEX (Transact-SQL)
-- https://bit.ly/2ItexPg


-- Microsoft Visual Studio Dev Essentials
-- https://bit.ly/2qjNRxi

-- Microsoft Azure Learn
-- https://bit.ly/2O0Hacc
