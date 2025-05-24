-- Get recent resource usage (Query 22) (Recent Resource Usage)
SELECT end_time, dtu_limit, cpu_limit, avg_cpu_percent, avg_memory_usage_percent, 
       avg_data_io_percent, avg_log_write_percent,  xtp_storage_percent,
       max_worker_percent, max_session_percent,  avg_login_rate_percent,  
	   avg_instance_cpu_percent, avg_instance_memory_percent
FROM sys.dm_db_resource_stats WITH (NOLOCK) 
ORDER BY end_time DESC OPTION (RECOMPILE);
------

-- Returns a row of usage metrics every 15 seconds, going back 64 minutes
-- The end_time column is UTC time

-- sys.dm_db_resource_stats (Azure SQL Database)
-- https://bit.ly/2HaSpKn