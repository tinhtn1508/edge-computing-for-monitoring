create or replace function
getWorkers(inpsensor text, inpfactory text) 
returns table(id int, name varchar(50), phone varchar(50), email varchar(50), groupname varchar(50), address varchar(50))
as $$
declare validsensor boolean;
declare wgroup int;
declare ctime time;
begin
	select count(0) > 0 into validsensor from sensors where
	sensor_id = inpsensor and factory_id = inpfactory;
	
	if not validsensor
	then
		raise exception 'invalid sensor';
	end if;
	
	select CURRENT_TIME into ctime;
	return query 
	select workers.id, workers.name, workers.phone, workers.email, worker_groups.name, factories.address
	from workers left join worker_groups on workers.group_id = worker_groups.id
	left join factories on workers.group_id = factories.worker_group
	where factories.id = inpfactory
	and ctime > workers.start_working_hour and ctime < workers.end_working_hour;
end;
$$ language plpgsql;
