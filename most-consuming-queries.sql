
-- Get top total worker time queries for this database (Query 26) (Top Worker Time Queries)		
SELECT TOP(50) DB_NAME(t.[dbid]) AS [Database Name], 
REPLACE(REPLACE(LEFT(t.[text], 1000), CHAR(10),''), CHAR(13),'') AS [Short Query Text],  
qs.total_worker_time AS [Total Worker Time], qs.min_worker_time AS [Min Worker Time],
qs.total_worker_time/qs.execution_count AS [Avg Worker Time], 
qs.max_worker_time AS [Max Worker Time], 
qs.min_elapsed_time AS [Min Elapsed Time], 
qs.total_elapsed_time/qs.execution_count AS [Avg Elapsed Time], 
qs.max_elapsed_time AS [Max Elapsed Time],
qs.min_logical_reads AS [Min Logical Reads],
qs.total_logical_reads/qs.execution_count AS [Avg Logical Reads],
qs.max_logical_reads AS [Max Logical Reads], 
qs.execution_count AS [Execution Count],
CASE WHEN CONVERT(nvarchar(max), qp.query_plan) LIKE N'%<MissingIndexes>%' THEN 1 ELSE 0 END AS [Has Missing Index],  
qs.creation_time AS [Creation Time]
--,t.[text] AS [Query Text], qp.query_plan AS [Query Plan] -- uncomment out these columns if not copying results to Excel
FROM sys.dm_exec_query_stats AS qs WITH (NOLOCK)
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t 
CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp
WHERE t.dbid = DB_ID() 
ORDER BY qs.total_worker_time DESC OPTION (RECOMPILE);
------

-- Helps you find the most expensive queries from a CPU perspective for this database
-- Can also help track down parameter sniffing issues