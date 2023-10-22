-- Index in Benutzung?

SELECT 
       @@SERVERNAME AS [server_name],
       DB_NAME() AS [database_name],
       SCHEMA_NAME(t.[schema_id]) AS [schema_name],
       OBJECT_NAME(t.[object_id]) AS [table_name],
       t.[object_id],
       i.name AS [index_name], 
       i.index_id, 
       i.type_desc,
       ps.partition_number,
       ps.page_count AS [page_count],
       CONVERT(decimal(18,2), ps.page_count * 8 / 1024.0) AS [index_size_in_mb],  
       CONVERT(decimal(18,2), ps.avg_fragmentation_in_percent) AS [fragmentation_in_precent],
       us.user_seeks,
       us.user_scans,
       us.user_updates,
       us.last_user_lookup,
       us.last_user_scan,
       us.last_user_seek,
       us.last_user_update
FROM sys.indexes AS i  
INNER JOIN sys.tables AS t
       ON i.[object_id] = t.[object_id]
CROSS APPLY sys.dm_db_index_physical_stats(DB_ID(), i.[object_id], i.index_id, NULL, NULL) AS ps  
LEFT OUTER JOIN sys.dm_db_index_usage_stats AS us  
       ON i.index_id = us.index_id  
       AND i.[object_id] = us.[object_id]  
WHERE 
       ps.database_id = DB_ID()
	   and OBJECT_NAME(t.[object_id]) like 'history'
ORDER BY 
       SCHEMA_NAME(t.[schema_id]),
       OBJECT_NAME(t.[object_id]),
       i.name;


-- Fehlender Index

SELECT 
        @@SERVERNAME AS [server_name],
        DB_NAME() AS [database_name],
        SCHEMA_NAME(t.[schema_id]) AS [schema_name],
        OBJECT_NAME(mid.[object_id]) AS [table_name],
        mid.[object_id],
        CONVERT (decimal (28,1), migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans)) AS improvement_measure, 
        mid.equality_columns,
        mid.inequality_columns,
        mid.included_columns,
        migs.[user_seeks],
        migs.[user_scans],
        migs.[last_user_seek],
        migs.[last_user_scan],
        migs.[avg_total_user_cost],
        migs.[avg_user_impact],
        migs.[system_seeks],
        migs.[system_scans],
        migs.[last_system_seek],
        migs.[last_system_scan],
        migs.[avg_total_system_cost],
        migs.[avg_system_impact]
FROM sys.dm_db_missing_index_groups AS mig
INNER JOIN sys.dm_db_missing_index_group_stats AS migs 
        ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS mid 
        ON mig.index_handle = mid.index_handle
INNER JOIN sys.tables AS t
        ON mid.[object_id] = t.[object_id]
WHERE mid.database_id = DB_ID()
and OBJECT_NAME(mid.[object_id]) like 'history'
ORDER BY migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) DESC;

-- Missing Index mit Vorschlag
SELECT db.[name] AS [DatabaseName]
    ,id.[object_id] AS [ObjectID]
	,OBJECT_NAME(id.[object_id], db.[database_id]) AS [ObjectName]
    ,id.[statement] AS [FullyQualifiedObjectName]
    ,id.[equality_columns] AS [EqualityColumns]
    ,id.[inequality_columns] AS [InEqualityColumns]
    ,id.[included_columns] AS [IncludedColumns]
    ,gs.[unique_compiles] AS [UniqueCompiles]
    ,gs.[user_seeks] AS [UserSeeks]
    ,gs.[user_scans] AS [UserScans]
    ,gs.[last_user_seek] AS [LastUserSeekTime]
    ,gs.[last_user_scan] AS [LastUserScanTime]
    ,gs.[avg_total_user_cost] AS [AvgTotalUserCost]  -- Average cost of the user queries that could be reduced by the index in the group.
    ,gs.[avg_user_impact] AS [AvgUserImpact]  -- The value means that the query cost would on average drop by this percentage if this missing index group was implemented.
    ,gs.[system_seeks] AS [SystemSeeks]
    ,gs.[system_scans] AS [SystemScans]
    ,gs.[last_system_seek] AS [LastSystemSeekTime]
    ,gs.[last_system_scan] AS [LastSystemScanTime]
    ,gs.[avg_total_system_cost] AS [AvgTotalSystemCost]
    ,gs.[avg_system_impact] AS [AvgSystemImpact]  -- Average percentage benefit that system queries could experience if this missing index group was implemented.
    ,gs.[user_seeks] * gs.[avg_total_user_cost] * (gs.[avg_user_impact] * 0.01) AS [IndexAdvantage]
    ,'CREATE INDEX [IX_' + OBJECT_NAME(id.[object_id], db.[database_id]) + '_' + REPLACE(REPLACE(REPLACE(ISNULL(id.[equality_columns], ''), ', ', '_'), '[', ''), ']', '') + CASE
        WHEN id.[equality_columns] IS NOT NULL
            AND id.[inequality_columns] IS NOT NULL
            THEN '_'
        ELSE ''
        END + REPLACE(REPLACE(REPLACE(ISNULL(id.[inequality_columns], ''), ', ', '_'), '[', ''), ']', '') + '_' + LEFT(CAST(NEWID() AS [nvarchar](64)), 5) + ']' + ' ON ' + id.[statement] + ' (' + ISNULL(id.[equality_columns], '') + CASE
        WHEN id.[equality_columns] IS NOT NULL
            AND id.[inequality_columns] IS NOT NULL
            THEN ','
        ELSE ''
        END + ISNULL(id.[inequality_columns], '') + ')' + ISNULL(' INCLUDE (' + id.[included_columns] + ')', '') AS [ProposedIndex]
    ,CAST(CURRENT_TIMESTAMP AS [smalldatetime]) AS [CollectionDate]
FROM [sys].[dm_db_missing_index_group_stats] gs WITH (NOLOCK)
INNER JOIN [sys].[dm_db_missing_index_groups] ig WITH (NOLOCK) ON gs.[group_handle] = ig.[index_group_handle]
INNER JOIN [sys].[dm_db_missing_index_details] id WITH (NOLOCK) ON ig.[index_handle] = id.[index_handle]
INNER JOIN [sys].[databases] db WITH (NOLOCK) ON db.[database_id] = id.[database_id]
WHERE  db.[database_id] = DB_ID()
AND OBJECT_NAME(id.[object_id], db.[database_id]) like 'history'
ORDER BY ObjectName, [IndexAdvantage] DESC
OPTION (RECOMPILE);

