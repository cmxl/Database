-- Get Schema names, Table names, object size, row counts, and compression status for clustered index or heap  (Query 40) (Table Sizes)
SELECT SCHEMA_NAME(o.Schema_ID) AS [Schema Name], OBJECT_NAME(p.object_id) AS [Object Name],
CAST(SUM(ps.reserved_page_count) * 8.0 / 1024 AS DECIMAL(19,2)) AS [Object Size (MB)],
SUM(p.Rows) AS [Row Count], 
p.data_compression_desc AS [Compression Type]
FROM sys.objects AS o WITH (NOLOCK)
INNER JOIN sys.partitions AS p WITH (NOLOCK)
ON p.object_id = o.object_id
INNER JOIN sys.dm_db_partition_stats AS ps WITH (NOLOCK)
ON p.object_id = ps.object_id
WHERE ps.index_id < 2 -- ignore the partitions from the non-clustered indexes if any
AND p.index_id < 2    -- ignore the partitions from the non-clustered indexes if any
AND o.type_desc = N'USER_TABLE'
--AND p.data_compression_desc = N'NONE'
GROUP BY  SCHEMA_NAME(o.Schema_ID), p.object_id, ps.reserved_page_count, p.data_compression_desc
ORDER BY SUM(ps.reserved_page_count) DESC, SUM(p.Rows) DESC OPTION (RECOMPILE);
------

-- Gives you an idea of table sizes, and possible data compression opportunities 