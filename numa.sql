-- SQL Server NUMA Node information  (Query 3) (SQL Server NUMA Info)
SELECT osn.node_id, osn.node_state_desc, osn.memory_node_id, osn.processor_group, osn.cpu_count, osn.online_scheduler_count, 
       osn.idle_scheduler_count, osn.active_worker_count, 
	   osmn.pages_kb/1024 AS [Committed Memory (MB)], 
	   osmn.locked_page_allocations_kb/1024 AS [Locked Physical (MB)],
	   CONVERT(DECIMAL(18,2), osmn.foreign_committed_kb/1024.0) AS [Foreign Commited (MB)],
	   osmn.target_kb/1024 AS [Target Memory Goal (MB)],
	   osn.avg_load_balance, osn.resource_monitor_state
FROM sys.dm_os_nodes AS osn WITH (NOLOCK)
INNER JOIN sys.dm_os_memory_nodes AS osmn WITH (NOLOCK)
ON osn.memory_node_id = osmn.memory_node_id
WHERE osn.node_state_desc <> N'ONLINE DAC' OPTION (RECOMPILE);
------

-- Gives you some useful information about the composition and relative load on your NUMA nodes
-- You want to see an equal number of schedulers on each NUMA node
-- You don't have any control over this in Azure SQL Database