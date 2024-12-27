Use ParcDistractii
go
/*

-- 1

insert into Sectiuni (nume,descriere) values
('sectiunea 1','cea mai mare'),
('sectiunea 2','cea mai veche'),
('sectiunea 3','cea mai noua'),
('sectiunea 4','cea mai frumoasa'),
('sectiunea 5','cea mai mirobolanta'),
('sectiunea 6','cea mai luxoasa'),
('sectiunea 7','cea mai ingusta');

select * from Sectiuni

insert into Atractii (nume_a,descriere_a,cod_s) values
('piscina','apa calda',1),
('dinozauri','fiorosi',1),
('castel','mare',2),
('parc','plin de banci',2),
('magazin de apa','contine boresc si dorna',2),
('autonomat chipsuri','unhealthy',4),
('trambulina','pentru profesionisti',7);

select nume_a, descriere_a, cod_s from Atractii

insert into CategoriiVizitatori (nume_categorie) values
('bebelusi'),
('copii'),
('adolescenti'),
('studenti'),
('adulti'),
('bunici'),
('pensionari');

select * from CategoriiVizitatori 

insert into Vizitatori (nume_v, email_v, cod_cv) values
('a','a@',4),
('b','b@',4),
('c','c@',4),
('d','d@',4),
('e','e@',5),
('f','f@',5),
('g','g@',1);

insert into Note (cod_a, cod_v) values
(7,1),
(7,2),
(7,3),
(4,5),
(6,6),
(2,5),
(5,3);

-- 2

update Sectiuni SET descriere='yolo'
where nume='sectiunea 1';

update Note set cod_a=7
where cod_a=1

update CategoriiVizitatori set nume_categorie='epermientati'
where nume_categorie='bunici';

update Vizitatori set nume_v='tudor', email_v='sefu@'
where nume_v='a';

update Atractii set nume_a='Concert', varsta_min=21
where nume_a='trambulina';


update Note set nota=10
where cod_a<>0;


-- 3

delete from Atractii where nume_a='piscina';

delete from Sectiuni where cod_s=4;

delete from Note where cod_a<>0;

delete from Vizitatori where nume_v='b';

delete from CategoriiVizitatori where cod_cv=1;



-- 4
Select * from CategoriiVizitatori where nume_categorie in('pensionari','copii')

-- 5
select * from Sectiuni where nume like 's%'




-- 6

update Sectiuni set descriere='un'
where cod_s=1;

select * from Sectiuni where descriere like '%_n'

-- 7

select * from Vizitatori where cod_v not in (select cod_v from Note);

select v.* from Vizitatori v left join Note n on v.cod_v=n.cod_v 
where n.cod_v is NULL;

-- 9

select * from Vizitatori

select v.nume_v, count(n.cod_v) as numar_note
from Vizitatori v
left join Note n on v.cod_v=n.cod_v
group by v.nume_v;


select * from Note


-- 8

select v.nume_v as nume, n.nota as nota, a.nume_a as la_atractia 
from Vizitatori v 
join Note n on v.cod_v=n.cod_v  
join Atractii a on n.cod_a=a.cod_a;

--10
select distinct nota from Note
*/


