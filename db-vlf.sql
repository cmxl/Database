-- Get VLF Count for current database (Query 17) (VLF Counts)
SELECT [name] AS [Database Name], [VLF Count]
FROM sys.databases AS db WITH (NOLOCK)
CROSS APPLY (SELECT file_id, COUNT(*) AS [VLF Count]
		     FROM sys.dm_db_log_info(db.database_id)
			 GROUP BY file_id) AS li
WHERE [name] <> N'master'
ORDER BY [VLF Count] DESC OPTION (RECOMPILE);
------

-- High VLF counts can affect write performance to the log file
-- and they can make full database restores and crash recovery take much longer
-- Try to keep your VLF counts under 200 in most cases (depending on log file size)

-- Important change to VLF creation algorithm in SQL Server 2014
-- https://bit.ly/2Hsjbg4