
declare @dbName varchar(40) = '',
		@progName varchar(50) = '',
		@hostName varchar(20) = '';
declare @now    datetime
set     @now    = getdate()
set nocount off
select  p.spid                      as  spid
    ,   rtrim(p.loginame)           as  SQLUser
    ,   rtrim(p.nt_username)        as  NTUser
    ,   rtrim(p.nt_domain)          as  NTDomain
    ,   rtrim(case
        when p.blocked <> 0 then 'BLOCKED'
        else p.status
        end)                        as status
    ,   case 
        when p.blocked is null or p.blocked = 0 then ''     
        else convert(varchar(10),p.blocked)
        end                         as  BlockedBySpid
    ,   rtrim(p.cmd)                as  CurrentCommand
    ,   case when p.dbid = 0 then '' else rtrim(db_name(p.dbid)) end    as  'DBName'
    ,   isnull(rtrim(p.program_name),'')        as  ProgramName
    ,   cast( cast(p.waittype as int) as nvarchar(10)) as  CurrentWaitType
    ,   p.waittime              as  CurrentWaitTime
    ,   p.lastwaittype              as  LastWaitType
    ,   rtrim(p.waitresource)       as  LastWaitResource
    ,   p.open_tran                 as  OpenTransactionCnt
    ,   p.cpu                       as  CPUTime
    ,   convert(bigint, p.physical_io) as   DiskIO
    ,   p.memusage                  as  MemoryUsage
    ,   p.hostprocess               as  HostProcess
    ,   rtrim(p.hostname)           as  HostName
    ,   p.login_time                as  LoginTime
    ,   p.last_batch                as  LastBatchTime
    ,   p.net_address               as  NetAddress
    ,   ltrim(rtrim(p.net_library)) as  NetLibrary
    ,   case 
        when    lower(p.status) not in ('sleeping', 'background', 'dormant', 'suspended') 
        or      p.open_tran > 0
        or      p.blocked   > 0
        or      upper(ltrim(rtrim(p.cmd))) like 'WAITFOR%'
        then    'Y'
        else    'N'
        end                         as  Active
    ,   case
        when    p.net_address <> '' --  Non system processes
        and     p.program_name not like 'SQLAgent - %'
        then 'N'
        else 'Y'
        end                         as  SystemProcess
    ,   case 
        when p.last_batch = '19000101'      then 'n/a'
        when datediff(day,      p.last_batch, @now) >   2   then convert(varchar(10),datediff(day,      p.last_batch, @now)) + ' days'
        when datediff(hour,     p.last_batch, @now) >=  4   then convert(varchar(10),datediff(hour,     p.last_batch, @now)) + ' hrs'
        when datediff(minute,   p.last_batch, @now) >=  10  then convert(varchar(10),datediff(minute,   p.last_batch, @now)) + ' min'
        else convert(varchar(10),datediff(second, p.last_batch, @now)) + ' sec'
        end                         as  TimeSinceLastBatch
    ,   p.kpid                      as  InternalKPID
    ,   case    
        when    (lower(p.status) in ('background', 'dormant') 
        and     p.open_tran <= 0
        and     p.blocked   <= 0
        and     upper(ltrim(rtrim(p.cmd))) not like 'WAITFOR%'
        ) or (
        lower(p.status) like '%sleeping%'
        )
        then    0
        else    p.kpid
        end                         as  kpid
    , (convert(nvarchar,p.spid) + '.' + case    
                                        when    (lower(p.status) in ('background', 'dormant') 
                                        and     p.open_tran <= 0
                                        and     p.blocked   <= 0
                                        and     upper(ltrim(rtrim(p.cmd))) not like 'WAITFOR%'
                                        ) or (
                                        lower(p.status) like '%sleeping%'
                                        )
                                        then    '0'
                                        else    convert(nvarchar,p.kpid)
                                        end) + '.' + convert(nvarchar,convert(float, p.login_time)) as SessionLifeTimeKey                
    ,   convert(float, p.login_time) as 'LoginTimeFloatDiff'
from    sys.sysprocesses            p   with (readpast)
where 1 = 1
--and case when p.dbid = 0 then '' else rtrim(db_name(p.dbid)) end = @dbName
--and isnull(rtrim(p.program_name),'') = @progName
--and rtrim(p.hostname) = @hostName


;


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
