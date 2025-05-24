-- Get Average Task Counts (run multiple times)  (Query 8) (Avg Task Counts)
SELECT AVG(current_tasks_count) AS [Avg Task Count], 
AVG(work_queue_count) AS [Avg Work Queue Count],
AVG(runnable_tasks_count) AS [Avg Runnable Task Count],
AVG(pending_disk_io_count) AS [Avg Pending DiskIO Count],
GETDATE() AS [System Time]
FROM sys.dm_os_schedulers WITH (NOLOCK)
WHERE scheduler_id < 255 OPTION (RECOMPILE);
------

-- Sustained values above 10 suggest further investigation in that area (depending on your Service Tier)
-- Avg Task Counts will be higher with lower service tiers
-- High Avg Task Counts are often caused by blocking/deadlocking or other resource contention

-- Sustained values above 1 suggest further investigation in that area
-- High Avg Runnable Task Counts are a good sign of CPU pressure
-- High Avg Pending DiskIO Counts are a sign of disk pressure
