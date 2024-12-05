USE Hermes
GO

INSERT INTO Sali(nume_sala,capacitate)
VALUES ('H001',30), ('H002',50),('H003',100),
('H004',150)

INSERT INTO Inventare(nume_item, cantitate,	id_sala)
VALUES ('Videoproiector', 1, 1),('Scaune',30,1),('Mese',10,2)


INSERT INTO Departamente(nume_departament, descriere)
VALUES ('Evenimente', 'cel mai tare departament'),('Resurse Umane', 'se ocupa de buna starea voluntariilor'),
('IMPR', 'maestrii in poze si postari'),('Externe', 'sponsori si relatii')

INSERT INTO Sedinte(id_sedinta,data_sedinta,durata,id_departament)
VALUES (1, '2024-11-10', '02:00', 1),
(2, '2024-11-11', '01:30', 2),
(3, '2024-11-12', '03:00', 1);

INSERT INTO Divizi(nume_divizie, descriere_divizie, id_departament)
VALUES ('Echipa de organizare Halloween', 'çoncurs de costume',1),('Echipa de organizare Training', 'Time mastering Training',1),
('Echipa de organizare Bal', 'Balul bobocilor', 1), ('Recrutari','interviuri',2)

INSERT INTO Voluntari (nume_voluntar, email_voluntar, id_departament)
VALUES 
   ('Ana Popescu', 'ana.popescu@email.com', 1),
   ('Ioan Mihai', 'ioan.mihai@email.com', 2), 
   ('Maria Ionescu', 'maria.ionescu@email.com', 3),
   ('Alexandru Popa', 'alex.popa@email.com', 4),
   ('Elena Radu', 'elena.radu@email.com', 1),
   ('Dan Constantinescu', 'dan.const@email.com', 2),
   ('Laura Stefanescu', 'laura.stef@email.com', 3),
   ('Andrei Dumitru', 'andrei.dumitru@email.com', 4),
   ('Carmen Vasile', 'carmen.vasile@email.com', 1),
   ('Bogdan Marin', 'bogdan.marin@email.com', 2);

INSERT INTO Evenimente (nume_eveniment, data_eveniment)
VALUES
   ('Hackathon', '2024-12-15'),
   ('Târg de Caritate', '2024-11-30'),
   ('Gala Voluntarilor', '2024-12-20');

INSERT INTO Sarcini (id_voluntar, id_eveniment, descriere_sarcina, status_sarcina)
VALUES
    (1, 1, 'Coordonare echipă tehnică', 'În progres'),
    (2, 1, 'Organizare program mentori', 'Finalizat'),
    (3, 1, 'Amenajare sala', 'În așteptare'),
    (4, 1, 'Primire invitați', 'În progres'),
    (5, 2, 'Amenajare standuri', 'În progres'),
    (6, 2, 'Coordonare donații', 'În așteptare'),
    (7, 2, 'Gestionare vânzări', 'În progres'),
    (8, 3, 'Decorare sală', 'În progres'),
    (9, 3, 'Pregătire diplome', 'Finalizat'),
    (10, 3, 'Coordonare catering', 'În așteptare');

INSERT INTO Activitati (nume_activitate, descriere_activitate, id_eveniment)
VALUES
    ('Licitație caritabilă', 'Licitație de obiecte donate pentru strângere de fonduri', 2),
    ('Atelier de creație', 'Crearea de decorațiuni handmade pentru vânzare', 2),
    ('Tombola benefică', 'Tombola cu premii donate de sponsori', 2),
    ('Ceremonia de premiere', 'Înmânarea diplomelor și premiilor pentru voluntari', 3),
    ('Moment artistic', 'Spectacol susținut de voluntari', 3),
    ('Networking', 'Sesiune de socializare și schimb de experiență', 3);

INSERT INTO Participanti (nume_participant, email_participant, id_activitate)
VALUES
    ('Mihai Ionescu', 'mihai.ionescu@email.com', 1),
    ('Elena Dumitrescu', 'elena.d@email.com', 1),
    ('George Popescu', 'george.p@email.com', 1),
    ('Ana Maria Stan', 'ana.stan@email.com', 2),
    ('Tudor Vasilescu', 'tudor.v@email.com', 2),
    ('Diana Pascu', 'diana.p@email.com', 2),
    ('Andreea Munteanu', 'andreea.m@email.com', 3),
    ('Radu Constantin', 'radu.c@email.com', 3),
    ('Cristina Dobre', 'cristina.d@email.com', 4),
    ('Adrian Stancu', 'adrian.s@email.com', 4),
    ('Monica Popa', 'monica.p@email.com', 5),
    ('Daniel Rusu', 'daniel.r@email.com', 5)

SELECT * FROM Sali;
SELECT * FROM Inventare;
SELECT * FROM Departamente;
SELECT * FROM Sedinte;
SELECT * FROM Divizi;
SELECT * FROM Voluntari;
SELECT * FROM Evenimente;
SELECT * FROM Sarcini;
SELECT * FROM Activitati;
SELECT * FROM Participanti;

