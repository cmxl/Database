-- create a versioned table
create table mychangingtable (
	id int primary key identity(1,1),
	changeme varchar(20) not null,
	valid_from datetime2 generated always as row start hidden,
	valid_to datetime2 generated always as row end hidden,
	period for system_time(valid_from, valid_to)
) with (system_versioning = on (history_table = mychangingtablehistory))
-- deletion needs some further steps
alter table mychangingtable SET (SYSTEM_VERSIONING = OFF);
alter table mychangingtable DROP PERIOD FOR SYSTEM_TIME;
-- finally drop the tables
drop table mychangingtable;
drop table mychangingtablehistory;
