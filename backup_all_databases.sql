DECLARE @path NVARCHAR(max)
DECLARE @timestamp NVARCHAR(max)
DECLARE @disk NVARCHAR(max)
DECLARE @database NVARCHAR(max)
DECLARE @description NVARCHAR(max)
 
SET @path = 'D:\Backup\'
SET @timestamp = replace(replace(replace(replace(convert(VARCHAR, getdate(), 121), '-', ''), ':', ''), '.', ''), ' ', '')
 
DECLARE cur CURSOR
FOR
SELECT NAME
FROM sys.databases
WHERE NAME NOT IN (
        'master'
        ,'tempdb'
        ,'model'
        ,'msdb'
        )
 
OPEN cur
 
FETCH NEXT
FROM cur
INTO @database
 
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @disk = @path + @database + '_' + @timestamp + '.bak'
    SET @description = @database + ' Full Backup'
 
    BACKUP DATABASE @database TO DISK = @disk
    WITH NOFORMAT
        ,NOINIT
        ,NAME = @description
        ,SKIP
        ,NOREWIND
        ,NOUNLOAD
        ,STATS = 10
 
    FETCH NEXT
    FROM cur
    INTO @database
END
 
CLOSE cur
 
DEALLOCATE cur