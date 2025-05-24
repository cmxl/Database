-- Look at UDF execution statistics (Query 49) (UDF Statistics)
SELECT OBJECT_NAME(object_id) AS [Function Name], total_worker_time,
       execution_count, total_elapsed_time,  
       total_elapsed_time/execution_count AS [avg_elapsed_time],  
       last_elapsed_time, last_execution_time, cached_time 
FROM sys.dm_exec_function_stats WITH (NOLOCK) 
WHERE database_id = DB_ID()
ORDER BY total_worker_time DESC OPTION (RECOMPILE); 
------


-- Helps you investigate scalar UDF performance issues

-- sys.dm_exec_function_stats (Transact-SQL)
-- https://bit.ly/2q1Q6BM

