create database ParcDistractii
go

use ParcDistractii

create table Sectiuni
(cod_s INT PRIMARY KEY IDENTITY(1,1),
 nume NVARCHAR(30),
 descriere NVARCHAR(100)
);



create table CategoriiViziatori
( cod_cv INT PRIMARY KEY IDENTITY(1,1),
  nume_categorie VARCHAR(100)
);

drop table CategoriiViziatori

create table CategoriiVizitatori
( cod_cv INT PRIMARY KEY IDENTITY(1,1),
  nume_categorie VARCHAR(100)
);


create table Atractii
(
cod_a int primary key identity,
nume_a nvarchar(30),
descriere_a nvarchar(100),
varsta_min int,
cod_s int foreign key references Sectiuni(cod_s) on update cascade on delete cascade

);
drop table Atractii


create table Vizitatori
(
cod_v int primary key identity,
nume_v nvarchar(30),
email_v nvarchar(100),
cod_cv int foreign key references CategoriiVizitatori(cod_cv) on update cascade on delete cascade
);

create table Note
(
cod_v int foreign key references Vizitatori(cod_v),
cod_a int foreign key references Atractii(cod_a),
nota int,
constraint pf_Note primary key (cod_v,cod_a)
);

alter table note
add constraint ck_nota check(nota>=1 and nota<=10)

