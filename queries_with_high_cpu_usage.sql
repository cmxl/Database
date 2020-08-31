SELECT TOP 50 Convert(varchar, qs.creation_time, 109) as Plan_Compiled_On,
    qs.execution_count as 'Total Executions',
    qs.total_worker_time as 'Overall CPU Time Since Compiled',
    Convert(Varchar, qs.last_execution_time, 109) as 'Last Execution Date/Time',
    cast(qs.last_worker_time as varchar) + '   (' + cast(qs.max_worker_time as Varchar) + ' Highest ever)' as 'CPU Time for Last Execution (Milliseconds)',
    Convert(varchar,(qs.last_worker_time /(1000)) /(60 * 60)) + ' Hrs (i.e. ' + convert(varchar,(qs.last_worker_time /(1000)) / 60) + ' Mins & ' + convert(varchar,(qs.last_worker_time /(1000)) %60) + ' Seconds)' as 'Last Execution Duration',
    qs.last_rows as 'Rows returned',
    qs.total_logical_reads / 128 as 'Overall Logical Reads (MB)',
    qs.max_logical_reads / 128 'Highest Logical Reads (MB)',
    qs.last_logical_reads / 128 'Logical Reads from Last Execution (MB)',
    qs.total_physical_reads / 128 'Total Physical Reads Since Compiled (MB)',
    qs.last_dop as 'Last DOP used',
    qs.last_physical_reads / 128 'Physical Reads from Last Execution (MB)',
    t.[text] 'Query Text',
    qp.query_plan as 'Query Execution Plan',
    DB_Name(t.dbid) as 'Database Name',
    t.objectid as 'Object ID',
    t.encrypted as 'Is Query Encrypted' --qs.plan_handle --Uncomment this if you want query plan handle
FROM sys.dm_exec_query_stats qs
    CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t
    CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp
ORDER BY qs.last_worker_time DESC
