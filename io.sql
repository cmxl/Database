-- Get I/O utilization by database (Query 5) (IO Usage By Database)
WITH Aggregate_IO_Statistics
AS (SELECT DB_NAME(database_id) AS [Database Name],
    CAST(SUM(num_of_bytes_read + num_of_bytes_written) / 1048576 AS DECIMAL(12, 2)) AS [ioTotalMB],
    CAST(SUM(num_of_bytes_read ) / 1048576 AS DECIMAL(12, 2)) AS [ioReadMB],
    CAST(SUM(num_of_bytes_written) / 1048576 AS DECIMAL(12, 2)) AS [ioWriteMB]
    FROM sys.dm_io_virtual_file_stats(NULL, NULL) AS [DM_IO_STATS]
    GROUP BY database_id)
SELECT ROW_NUMBER() OVER (ORDER BY ioTotalMB DESC) AS [I/O Rank],
        [Database Name], ioTotalMB AS [Total I/O (MB)],
        CAST(ioTotalMB / SUM(ioTotalMB) OVER () * 100.0 AS DECIMAL(5, 2)) AS [Total I/O %],
        ioReadMB AS [Read I/O (MB)], 
		CAST(ioReadMB / SUM(ioReadMB) OVER () * 100.0 AS DECIMAL(5, 2)) AS [Read I/O %],
        ioWriteMB AS [Write I/O (MB)], 
		CAST(ioWriteMB / SUM(ioWriteMB) OVER () * 100.0 AS DECIMAL(5, 2)) AS [Write I/O %]
FROM Aggregate_IO_Statistics
ORDER BY [I/O Rank] OPTION (RECOMPILE);
------

-- Helps determine which database is using the most I/O resources on the instance