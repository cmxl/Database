-- Get QueryStore Options for this database (Query 50) (QueryStore Options)
SELECT actual_state_desc, desired_state_desc,
       current_storage_size_mb, [max_storage_size_mb], 
	   query_capture_mode_desc, size_based_cleanup_mode_desc, 
	   wait_stats_capture_mode_desc, [flush_interval_seconds]
FROM sys.database_query_store_options WITH (NOLOCK) OPTION (RECOMPILE);
------

-- Added in SQL Server 2016
-- Requires that QueryStore is enabled for this database

-- Tuning Workload Performance with Query Store
-- https://bit.ly/1kHSl7w