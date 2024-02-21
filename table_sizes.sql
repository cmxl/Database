-- table sizes
select 
    o.name, 
    max(s.row_count) AS 'Rows',
    sum(s.reserved_page_count) * 8.0 / (1024 * 1024) as 'GB',
    (8 * 1024 * sum(s.reserved_page_count)) / (max(s.row_count)) as 'Bytes/Row'
from sys.dm_db_partition_stats s, sys.objects o
where o.object_id = s.object_id
group by o.name
having max(s.row_count) > 0
order by GB desc

-- index sizes
select  
    o.Name,
    i.Name,
    max(s.row_count) AS 'Rows',
    sum(s.reserved_page_count) * 8.0 / (1024 * 1024) as 'GB',
    (8 * 1024* sum(s.reserved_page_count)) / max(s.row_count) as 'Bytes/Row'
from 
    sys.dm_db_partition_stats s, 
    sys.indexes i, 
    sys.objects o
where 
    s.object_id = i.object_id
    and s.index_id = i.index_id
    and s.index_id >0
    and i.object_id = o.object_id
group by i.Name, o.Name
having SUM(s.row_count) > 0
order by GB desc
