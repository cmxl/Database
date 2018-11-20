SELECT OBJECT_NAME(sm.object_id), o.type_desc
    FROM sys.sql_modules sm
	JOIN sys.objects AS o ON sm.object_id = o.object_id 
    WHERE 1=1
	AND sm.definition LIKE '%fehler%'
	order by o.type_desc