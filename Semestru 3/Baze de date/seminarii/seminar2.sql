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

--11

select s.nume as Numele_sectiuni, a.nume_a as Numele_atractieri, a.descriere_a as Descriere  from Sectiuni s
full join Atractii a on s.cod_s=a.cod_s

--12
select a.nume_a as numele_atractiei, a.varsta_min as varsta_minima, count(n.cod_a) as numarul_de_note 
from Atractii a
left join Note n on a.cod_a=n.cod_a
Group by a.nume_a, a.varsta_min
having count(n.cod_a) >=2;

--13

select 
	c.nume_categorie as Numele_Categoriei,
	v.nume_v as Numele_Vizitatorului,
	n.nota as Nota,
	a.nume_a as Numele_Atractiei,
	a.descriere_a as Descrierea_Atractiei
from CategoriiVizitatori c
inner join Vizitatori v on c.cod_cv=v.cod_cv
inner join Note n on v.cod_v=n.cod_v
inner join Atractii a on a.cod_a =n.cod_a
group by   c.nume_categorie,  v.nume_v, n.nota, a.nume_a, a.descriere_a
having c.nume_categorie<>'adulti' and count(n.cod_v) >=1


--14

select
	max(N.nota) as nota_maxima,
	a.nume_a as numele_atractiei
from Note n
inner join Atractii a on n.cod_a=a.cod_a
group by a.nume_a;

--15
select
	min(N.nota) as nota_maxima,
	a.nume_a as numele_atractiei
from Note n
inner join Atractii a on n.cod_a=a.cod_a
group by a.nume_a;


--16

select
	nume_v,
	email_v
from Vizitatori 
where cod_cv is NULL;

-- 17

select
	nume_a,
	descriere_a
from Atractii
where cod_a is not null;
