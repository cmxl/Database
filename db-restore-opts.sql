-- Important database properties for current database   (Query 19) (Database Properties)
SELECT db.[name] AS [Database Name], db.recovery_model_desc AS [Recovery Model], 
db.state_desc, db.containment_desc, db.log_reuse_wait_desc AS [Log Reuse Wait Description], 
db.[compatibility_level] AS [DB Compatibility Level], 
db.is_mixed_page_allocation_on, db.page_verify_option_desc AS [Page Verify Option], 
db.is_auto_create_stats_on, db.is_auto_update_stats_on, db.is_auto_update_stats_async_on, db.is_parameterization_forced, 
db.snapshot_isolation_state_desc, db.is_read_committed_snapshot_on, db.is_auto_close_on, db.is_auto_shrink_on, 
db.target_recovery_time_in_seconds, db.is_cdc_enabled, db.is_memory_optimized_elevate_to_snapshot_on, 
db.delayed_durability_desc, db.is_query_store_on, db.is_temporal_history_retention_enabled,
db.is_accelerated_database_recovery_on, db.is_memory_optimized_enabled  
FROM sys.databases AS db WITH (NOLOCK)
WHERE db.[name] <> N'master'
ORDER BY db.[name] OPTION (RECOMPILE);
------

-- sys.databases (Transact-SQL)
-- https://bit.ly/2G5wqaX

-- Things to look at:
-- What recovery model are you using?
-- What is the log reuse wait description?
-- What compatibility level is the database on? 
-- What is the Page Verify Option? (should be CHECKSUM)
-- Is Auto Update Statistics Asynchronously enabled?
-- Is Delayed Durability enabled?