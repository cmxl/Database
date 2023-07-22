DECLARE @fragmentation INT = 5
DECLARE @schemaName NVARCHAR(50)
DECLARE @tableName NVARCHAR(500)
DECLARE @indexName NVARCHAR(500)
DECLARE @indexId INT
DECLARE @indexType NVARCHAR(55)
DECLARE @percentFragment DECIMAL(11, 2)
DECLARE @spaceUsed DECIMAL(11, 2)
DECLARE @pageCount BIGINT
DECLARE @maxFragmentation INT = 30

DECLARE FragmentedTableList CURSOR FOR
SELECT 
	s.name as SchemaName,
	OBJECT_NAME(ips.OBJECT_ID) as TableName,
    i.Name as IndexName,
    ips.index_id,
    ips.index_type_desc as IndexType,
    ips.avg_fragmentation_in_percent,
    ips.avg_page_space_used_in_percent,
    ips.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'SAMPLED') ips
    INNER JOIN sys.indexes i ON (ips.object_id = i.object_id)
    AND (ips.index_id = i.index_id)
	join sys.tables t on ips.object_id = t.object_id
	join sys.schemas s on s.schema_id = t.schema_id
WHERE ips.avg_fragmentation_in_percent > @fragmentation
    AND i.Name IS NOT NULL
ORDER BY avg_fragmentation_in_percent DESC 

OPEN FragmentedTableList 

FETCH NEXT
FROM FragmentedTableList INTO 
    @schemaName,
    @tableName,
    @indexName,
    @indexId,
    @indexType,
    @percentFragment,
    @spaceUsed,
    @pageCount 
	
WHILE @@FETCH_STATUS = 0 
BEGIN 
	PRINT 'Processing [' + @indexName + '] on table [' + @schemaName + '].[' + @tableName + '] which is ' + cast(@percentFragment AS NVARCHAR(50)) + '% fragmented' 
	IF (@percentFragment <= @maxFragmentation) 
	BEGIN 
		EXEC ('ALTER INDEX [' + @indexName + '] ON [' + @schemaName + '].[' + @tableName + '] REBUILD; ') 
		PRINT 'Finished rebuilding [' + @indexName + '] on table [' + @schemaName + '].[' + @tableName + ']'
	END
	ELSE 
	BEGIN 
		EXEC ('ALTER INDEX [' + @indexName + '] ON [' + @schemaName + '].[' + @tableName + '] REORGANIZE;') 
		PRINT 'Finished reorganizing [' + @indexName + '] on table [' + @schemaName + '].[' + @tableName + ']'
	END 

	FETCH NEXT
	FROM FragmentedTableList INTO 
		@schemaName,
		@tableName,
		@indexName,
		@indexId,
		@indexType,
		@percentFragment,
		@spaceUsed,
		@pageCount
END 

CLOSE FragmentedTableList 
DEALLOCATE FragmentedTableList
GO 
EXEC sp_updatestats
GO
