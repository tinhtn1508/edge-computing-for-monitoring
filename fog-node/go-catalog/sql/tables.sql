create table if not exists worker_groups (
	id serial not null,
	name varchar(50) not null,
	primary key (id)
);

create table if not exists workers (
	id serial not null,
	group_id int not null,
	name varchar(50) not null,
	email varchar(50) not null,
	phone varchar(20) not null,
	start_working_hour time not null,
	end_working_hour time not null,
	primary key (id),
	constraint fk_group_id foreign key (group_id) references worker_groups (id)
);

create table if not exists factories (
    id varchar(50) not null,
    worker_group int not null,
    address varchar(50) not null,
    primary key (id),
    constraint fk_worker_group_id foreign key (worker_group) references worker_groups (id)
);

create table if not exists sensors (
	sensor_id varchar(50),
	factory_id varchar(50),
	description varchar(100),
	primary key (sensor_id, factory_id),
    constraint fk_factory_id foreign key (factory_id) references factories (id)
);
