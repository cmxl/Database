-- Look at Columnstore index physical statistics (Query 47) (Columnstore Index Physical Stat)
SELECT OBJECT_NAME(ps.object_id) AS [TableName],  
	i.[name] AS [IndexName], ps.index_id, ps.partition_number,
	ps.delta_store_hobt_id, ps.state_desc, ps.total_rows, ps.size_in_bytes,
	ps.trim_reason_desc, ps.generation, ps.transition_to_compressed_state_desc,
	ps.has_vertipaq_optimization, ps.deleted_rows,
	100 * (ISNULL(ps.deleted_rows, 0))/ps.total_rows AS [Fragmentation]
FROM sys.dm_db_column_store_row_group_physical_stats AS ps WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON ps.object_id = i.object_id 
AND ps.index_id = i.index_id
ORDER BY ps.object_id, ps.partition_number, ps.row_group_id OPTION (RECOMPILE);
------

-- sys.dm_db_column_store_row_group_physical_stats (Transact-SQL)
-- https://bit.ly/2q276XQ