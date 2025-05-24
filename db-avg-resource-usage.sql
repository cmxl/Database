-- Get avg-max resource usage (Query 23) (Avg-Max Resource Usage)
SELECT CAST(AVG(avg_cpu_percent) AS DECIMAL(10,2)) AS [Average CPU Utilization In Percent],   
       CAST(MAX(avg_cpu_percent) AS DECIMAL(10,2)) AS [Maximum CPU Utilization In Percent],   
       CAST(AVG(avg_data_io_percent) AS DECIMAL(10,2)) AS [Average Data IO In Percent],   
       CAST(MAX(avg_data_io_percent) AS DECIMAL(10,2)) AS [Maximum Data IO In Percent],   
       CAST(AVG(avg_log_write_percent) AS DECIMAL(10,2)) AS [Average Log Write Utilization In Percent],   
       CAST(MAX(avg_log_write_percent) AS DECIMAL(10,2)) AS [Maximum Log Write Utilization In Percent],   
       CAST(AVG(avg_memory_usage_percent) AS DECIMAL(10,2)) AS [Average Memory Usage In Percent],   
       CAST(MAX(avg_memory_usage_percent) AS DECIMAL(10,2)) AS [Maximum Memory Usage In Percent]   
FROM sys.dm_db_resource_stats WITH (NOLOCK) OPTION (RECOMPILE); 
------
