SELECT * FROM sys.dm_db_resource_stats order by end_time desc 

-- Wie groß sind die Dateien aktuell
SELECT file_id,
       name,
       CAST(FILEPROPERTY(name, 'SpaceUsed') AS bigint) * 8 / 1024. AS space_used_mb,
       CAST(size AS bigint) * 8 / 1024. AS space_allocated_mb,
       CAST(max_size AS bigint) * 8 / 1024. AS max_file_size_mb
FROM sys.database_files
WHERE type_desc IN ('ROWS','LOG');

-- Dateien einzeln verkleinern
DBCC SHRINKFILE('log')
-- DBCC SHRINKFILE('log', 500) (auf 500 MB)
 
-- Datenbank verkleinern
DBCC SHRINKDATABASE (N'FSMCloudDataCustomerDemo');

-- Fortschritt: Datenbank verkleinern
SELECT command,
       percent_complete,
       status,
       wait_resource,
       session_id,
       wait_type,
       blocking_session_id,
       cpu_time,
       reads,
       CAST(((DATEDIFF(s,start_time, GETDATE()))/3600) AS varchar) + ' hour(s), '
                     + CAST((DATEDIFF(s,start_time, GETDATE())%3600)/60 AS varchar) + 'min, '
                     + CAST((DATEDIFF(s,start_time, GETDATE())%60) AS varchar) + ' sec' AS running_time
FROM sys.dm_exec_requests AS r
LEFT JOIN sys.databases AS d
ON r.database_id = d.database_id
WHERE r.command IN ('DbccSpaceReclaim','DbccFilesCompact','DbccLOBCompact','DBCC');

-- Files Häppchenweise verkleinern (Denn erst wenn die Zielgrößer erreicht ist, wird der Truncate ausgeführt)
-- Sprich bei großen Datenbanken kann das sehr lange dauern
-- Randinfo: Skript stürzt hin und wieder ab
DECLARE @FileName sysname = N'Log';
DECLARE @TargetSize INT = (SELECT 1 + size*8./1024 FROM sys.database_files WHERE name = @FileName);
DECLARE @Factor FLOAT = .999;
 
WHILE @TargetSize > 0
BEGIN
    SET @TargetSize *= @Factor;
    DBCC SHRINKFILE(@FileName, @TargetSize);
    DECLARE @msg VARCHAR(200) = CONCAT('Shrink file completed. Target Size: ', 
         @TargetSize, ' MB. Timestamp: ', CURRENT_TIMESTAMP);
    RAISERROR(@msg, 1, 1) WITH NOWAIT;
    WAITFOR DELAY '00:00:01';
END;
