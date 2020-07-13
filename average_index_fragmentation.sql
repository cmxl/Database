SELECT DB_NAME(ips.database_id) as [Database]
 ,OBJECT_NAME(ips.OBJECT_ID) as [Table]
 ,i.NAME as [Index]
 ,ips.index_id as [Index ID]
 ,index_type_desc as [Index Type]
 ,avg_fragmentation_in_percent as [AVG Fragmentation (%)]
 ,avg_page_space_used_in_percent as [AVG Page Space Used (%)]
 ,page_count as [Pages]
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'SAMPLED') ips
INNER JOIN sys.indexes i ON (ips.object_id = i.object_id)
 AND (ips.index_id = i.index_id)
where ips.database_id > 4
ORDER BY avg_fragmentation_in_percent DESC
