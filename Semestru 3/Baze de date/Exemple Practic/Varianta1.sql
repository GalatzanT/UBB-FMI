create database trenurimodel;
GO
 
use trenurimodel;
GO
 
create table tipuri(
    id int identity primary key,
    descriere varchar(100)
);
go
 
create table trenuri(
    id int identity primary key,
    nume varchar(200),
    id_tip int,
    constraint fk_tip_tren foreign key (id_tip) references tipuri(id)
);
go
 
 
create table rute(
    id int identity primary key,
    nume varchar(90),
    id_tren int,
    constraint fk_tren foreign key (id_tren) references trenuri(id)
);
go
 
create table statii(
    id int identity primary key,
    nume varchar(100)
);
go
 
create table statiirute(
    id_statie int,
    id_rute int,
    ora_sosire time,
    ora_plecare time,
    constraint pk_statiirute primary key (id_statie, id_rute),
    constraint fk_statie foreign key (id_statie) references statii(id),
    constraint fk_rute foreign key (id_rute) references rute(id)
);
go
 
insert into tipuri(descriere) values
('interregio'),
('intercity'),
('regio'),
('interegionational')
 
select * from tipuri;
go
 
insert into trenuri (nume, id_tip) values
('tren1', 1),
('tren2', 2),
('tren3', 3),
('tren12', 4)
 
select * from trenuri;
go
 
insert into rute(nume, id_tren) values
('timisoaranordiasi', 1),
('clujgalati', 2),
('brailagalati', 3),
('brasovbucuresti', 4)
 
select * from rute;
go
 
insert into statii(nume) values
('galati'),
('brailanord'),
('bucuresti nord'),
('batman')
 
select * from statii;
go
 
select * from rute;
go
 
 
insert into statiirute(id_statie ,
    id_rute ,
    ora_sosire ,
    ora_plecare) values
(21, 2, '03:29', '04:10'),
(22, 2, '12:10', '12:20'),
(23, 2, '11:20', '11:25'),
(24, 2, '03:12', '03:40')
 
select * from statiirute;
go
 
create or alter procedure cerinta2(
    @ruta int,
    @statie int,
    @oras time,
    @orap time
)
as
begin
    if exists (select * from statiirute where id_statie = @statie and id_rute = @ruta)
    begin
        update statiirute
        set ora_sosire = @oras,
        ora_plecare = @orap
        where id_statie = @statie and id_rute = @ruta;
    end;
    else
    begin
        insert into statiirute(id_statie ,
                id_rute ,
                ora_sosire ,
                ora_plecare) values
            (@statie, @ruta, @oras, @orap);
    end;
end;
go
 
exec cerinta2 @ruta = 2, @statie = 1, @oras = '03:17', @orap = '03:45';
go
 
exec cerinta2 @ruta = 1, @statie = 22, @oras = '05:15', @orap = '05:45';
go
 
select count(*) from statii;
 
select * from (
select count(*) as cnt, r.nume from statiirute as sr
inner join rute as r
on r.id = sr.id_rute
group by r.nume) as batman
go
 
create view cerinta3
as
select r.nume from statiirute as sr
inner join rute as r
on r.id = sr.id_rute
group by r.id, r.nume
having count(*) = (
    select  count(*) from statii
);
go
 
select * from statiirute;
 
select * from statii;
 
select * from cerinta3;
 