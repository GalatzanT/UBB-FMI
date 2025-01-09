create table echipe
(
	id serial primary key,
	nume varchar(100)
);

create table jucatori
(
	id serial primary key,
	nume varchar(100),
	scoala varchar(100),
	echipa varchar(100)
);

create table meciuri
(

	id serial primary key,
	id_echipa1 int,
	id_echipa2 int,
	data timestamp
);

create table jucatoriactivi
(
	id serial primary key,
	id_jucator int,
	id_echipa int,
	tip varchar(100)
);