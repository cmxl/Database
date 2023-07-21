DECLARE @StartDate datetime = '2023-01-01'
DECLARE @EndDate datetime = SYSDATETIME()

;WITH days AS
(
  SELECT DATEADD(DAY, n, DATEADD(DAY, DATEDIFF(DAY, 0, @StartDate), 0)) as d
    FROM ( SELECT TOP (DATEDIFF(DAY, @StartDate, @EndDate) + 1)
            n = ROW_NUMBER() OVER (ORDER BY [object_id]) - 1
           FROM sys.all_objects ORDER BY [object_id] ) AS n
)

--select d from days

select days.d as [Day], count(*) as [Logs Per Day]
    FROM days LEFT OUTER JOIN logs as t
    ON t.TimeStamp >= days.d AND t.TimeStamp < DATEADD(DAY, 1, days.d)
GROUP BY days.d
ORDER BY days.d;
