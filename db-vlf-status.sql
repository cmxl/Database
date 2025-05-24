-- Status of last VLF for current database  (Query 18) (Last VLF Status)
SELECT TOP(1) DB_NAME(li.database_id) AS [Database Name], li.[file_id],
               li.vlf_size_mb, li.vlf_sequence_number, li.vlf_active, li.vlf_status
FROM sys.dm_db_log_info(DB_ID()) AS li 
ORDER BY vlf_sequence_number DESC OPTION (RECOMPILE);
------

-- Determine whether you will be able to shrink the transaction log file

-- vlf_status Values
-- 0 is inactive 
-- 1 is initialized but unused 
-- 2 is active
