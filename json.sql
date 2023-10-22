

create or alter procedure noobit.GetWeatherInYearAsJson (@year int, @city varchar(20)) as
begin
	create table #tmp(
		city varchar(10),
		[min] float,
		[d] date,
		[max] float,
		[avg] float,
		samples int
	);

	insert into #tmp(city, d, [min], [max], [avg], samples)
	exec noobit.GetWeatherInYear @year, @city

	select (select 
		[Min] = (select d as [Date], [min] as Temperature, Samples FROM #tmp for json path),
		[Max] = (select d as [Date], [max] as Temperature, Samples FROM #tmp for json path),
		[Avg] = (select d as [Date], [avg] as Temperature, Samples FROM #tmp for json path)
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER, INCLUDE_NULL_VALUES) as [json]
end

exec noobit.GetWeatherInYearAsJson 2023, 'Regensburg'