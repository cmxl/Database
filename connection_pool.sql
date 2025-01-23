declare @database varchar(40) = 'DatabaseName';
with cte as (
	select DB_NAME (dbid) as DBName,
		   COUNT(dbid) as NumberOfConnections,
		   hostname
	from sys.sysprocesses
	where dbid > 0
	group by dbid,
			 hostname
)
select
	top 10 NumberOfConnections,
	hostname
from cte
where DBName = @database
order by NumberOfConnections desc
