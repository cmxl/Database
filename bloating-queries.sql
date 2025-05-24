-- Find single-use, ad-hoc and prepared queries that are bloating the plan cache  (Query 13) (Ad hoc Queries)   
SELECT TOP(50) DB_NAME(t.[dbid]) AS [Database Name], t.[text] AS [Query Text], 
cp.objtype AS [Object Type], cp.cacheobjtype AS [Cache Object Type],  
cp.size_in_bytes/1024 AS [Plan Size in KB]
FROM sys.dm_exec_cached_plans AS cp WITH (NOLOCK)
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t
WHERE cp.cacheobjtype = N'Compiled Plan' 
AND cp.objtype IN (N'Adhoc', N'Prepared') 
AND cp.usecounts = 1
ORDER BY cp.size_in_bytes DESC, DB_NAME(t.[dbid]) OPTION (RECOMPILE);
------

-- Gives you the text, type and size of single-use ad-hoc and prepared queries that waste space in the plan cache
-- Enabling forced parameterization for the database can help, but test first!

-- Plan cache, adhoc workloads and clearing the single-use plan cache bloat
-- https://bit.ly/2EfYOkl