--- Index Read/Write stats (all tables in current DB) ordered by Reads  (Query 45) (Overall Index Usage - Reads)
SELECT SCHEMA_NAME(t.[schema_id]) AS [SchemaName], OBJECT_NAME(i.[object_id]) AS [ObjectName], 
       i.[name] AS [IndexName], i.index_id, 
       s.user_seeks, s.user_scans, s.user_lookups,
	   s.user_seeks + s.user_scans + s.user_lookups AS [Total Reads], 
	   s.user_updates AS [Writes],  
	   i.[type_desc] AS [Index Type], i.fill_factor AS [Fill Factor], i.has_filter, i.filter_definition, 
	   s.last_user_scan, s.last_user_lookup, s.last_user_seek
FROM sys.indexes AS i WITH (NOLOCK)
LEFT OUTER JOIN sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
ON i.[object_id] = s.[object_id]
AND i.index_id = s.index_id
AND s.database_id = DB_ID()
LEFT OUTER JOIN sys.tables AS t WITH (NOLOCK)
ON t.[object_id] = i.[object_id]
WHERE OBJECTPROPERTY(i.[object_id],'IsUserTable') = 1
ORDER BY s.user_seeks + s.user_scans + s.user_lookups DESC OPTION (RECOMPILE); -- Order by reads
------

-- Show which indexes in the current database are most active for Reads