-- generates a sql script to drop foreign keys of the specified table
-- neat if you want to drop/change the primary key of the specified table
declare @SQL varchar(max) = '',
	@table varchar(255) = 'fsmkunde';
	
with ReferencingFK as (
	select fk.Name as 'FKName',
		OBJECT_NAME(fk.parent_object_id) 'ParentTable',
		cpa.name 'ParentColumnName',
		OBJECT_NAME(fk.referenced_object_id) 'ReferencedTable',
		cref.name 'ReferencedColumnName'
	from sys.foreign_keys fk
		inner join sys.foreign_key_columns fkc on fkc.constraint_object_id = fk.object_id
		inner join sys.columns cpa on fkc.parent_object_id = cpa.object_id
		and fkc.parent_column_id = cpa.column_id
		inner join sys.columns cref on fkc.referenced_object_id = cref.object_id
		and fkc.referenced_column_id = cref.column_id
)
select @SQL = @SQL + 'ALTER TABLE ' + ParentTable + ' DROP CONSTRAINT [' + RTRIM(FKName) + '];' + CHAR(13)
from ReferencingFK
where ReferencedTable = @table
order by ParentTable,
	ReferencedTable,
	FKName 
	
PRINT @SQL