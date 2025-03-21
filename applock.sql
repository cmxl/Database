begin tran

DECLARE @result INT,
		@resource varchar(4) = 'Test'

--EXEC @result = sp_getapplock
--    @Resource = @resource,
--    @LockMode = 'Shared';

EXEC @result = sp_getapplock
    @Resource = @resource,
    @LockMode = 'Exclusive';
	
SELECT 
    request_session_id AS SessionID,
    resource_type AS ResourceType,
    resource_database_id AS DatabaseID,
    resource_associated_entity_id AS EntityID,
    request_mode AS LockMode,
    request_status AS LockStatus,
    resource_description AS ResourceDescription
FROM 
    sys.dm_tran_locks
WHERE 
    resource_type = 'APPLICATION'


EXEC @result = sp_releaseapplock @Resource = @resource;

commit
