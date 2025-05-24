-- Azure SQL Database size  (Query 14) (Azure SQL DB Size)
SELECT CAST(SUM(CAST(FILEPROPERTY(name, 'SpaceUsed') AS bigint) * 8192.) / 1024 / 1024 AS DECIMAL(15,2)) AS [Database Size In MB],
       CAST(SUM(CAST(FILEPROPERTY(name, 'SpaceUsed') AS bigint) * 8192.) / 1024 / 1024 / 1024 AS DECIMAL(15,2)) AS [Database Size In GB]
FROM sys.database_files WITH (NOLOCK)
WHERE [type_desc] = N'ROWS' OPTION (RECOMPILE);
------

-- This gives you the actual space usage within the data file only, to match what the Azure portal shows for the database size

-- Determining Database Size in Azure SQL Database V12
-- https://bit.ly/2JjrqNh