USE Hermes
GO


-- 1. Găsește numărul de participanți pentru fiecare activitate din evenimente care au loc după 1 decembrie 2023
-- (3+ tabele, WHERE, GROUP BY, HAVING)
SELECT e.nume_eveniment, a.nume_activitate, COUNT(p.id_participant) as numar_participanti
FROM Evenimente e 
JOIN Activitati a ON e.id_eveniment = a.id_eveniment
JOIN Participanti p ON a.id_activitate = p.id_activitate
WHERE e.data_eveniment > '2023-12-01'
GROUP BY e.nume_eveniment, a.nume_activitate
HAVING COUNT(p.id_participant) > 2;

-- 2. Lista distinctă a departamentelor care au voluntari implicați în evenimente
-- (3+ tabele, DISTINCT)
SELECT DISTINCT d.nume_departament
FROM Departamente d
JOIN Voluntari v ON d.id_departament = v.id_departament
JOIN Sarcini s ON v.id_voluntar = s.id_voluntar
JOIN Evenimente e ON s.id_eveniment = e.id_eveniment;

-- 3. Voluntarii și sarcinile lor pentru fiecare eveniment, împreună cu departamentul de care aparțin
-- (3+ tabele, WHERE)
SELECT v.nume_voluntar, d.nume_departament, e.nume_eveniment, s.descriere_sarcina
FROM Voluntari v
JOIN Departamente d ON v.id_departament = d.id_departament
JOIN Sarcini s ON v.id_voluntar = s.id_voluntar
JOIN Evenimente e ON s.id_eveniment = e.id_eveniment
WHERE s.status_sarcina = 'În progres';

-- 4. Lista distinctă a sălilor care găzduiesc ședințe pentru departamente cu divizii
-- (3+ tabele, DISTINCT)
SELECT DISTINCT s.nume_sala, s.capacitate
FROM Sali s
JOIN Sedinte sed ON s.id_sala = sed.id_sedinta
JOIN Departamente d ON sed.id_departament = d.id_departament
JOIN Divizi div ON d.id_departament = div.id_departament;

-- 5. Numărul de activități și participanți pentru fiecare eveniment
-- (3+ tabele, GROUP BY)
SELECT e.nume_eveniment, COUNT(DISTINCT a.id_activitate) as numar_activitati, 
       COUNT(p.id_participant) as numar_participanti
FROM Evenimente e
JOIN Activitati a ON e.id_eveniment = a.id_eveniment
JOIN Participanti p ON a.id_activitate = p.id_activitate
GROUP BY e.nume_eveniment;

-- 6. Departamentele care au mai mult de 2 voluntari implicați în evenimente
-- (3+ tabele, GROUP BY, HAVING)
SELECT d.nume_departament, COUNT(DISTINCT v.id_voluntar) as numar_voluntari
FROM Departamente d
JOIN Voluntari v ON d.id_departament = v.id_departament
JOIN Sarcini s ON v.id_voluntar = s.id_voluntar
GROUP BY d.nume_departament
HAVING COUNT(DISTINCT v.id_voluntar) > 2;

-- 7. Toate sălile și inventarul lor folosite pentru ședințe facute pana acum
-- (3+ tabele, WHERE)
SELECT s.nume_sala, i.nume_item, i.cantitate, sed.data_sedinta
FROM Sali s
JOIN Inventare i ON s.id_sala = i.id_sala
JOIN Sedinte sed ON s.id_sala = sed.id_sedinta
WHERE sed.data_sedinta <= GETDATE();

-- 8. Lista voluntarilor și activităților la care participă
-- (M-N: Voluntari-Evenimente prin Sarcini, 3 tabele)
SELECT v.nume_voluntar, e.nume_eveniment, s.descriere_sarcina
FROM Voluntari v
JOIN Sarcini s ON v.id_voluntar = s.id_voluntar
JOIN Evenimente e ON s.id_eveniment = e.id_eveniment
WHERE s.status_sarcina = 'Finalizat';

-- 9. Lista participanților și evenimentelor la care participă
-- (M-N: Participanti-Evenimente prin Activitati, 3 tabele)
SELECT p.nume_participant, e.nume_eveniment, a.nume_activitate
FROM Participanti p
JOIN Activitati a ON p.id_activitate = a.id_activitate
JOIN Evenimente e ON a.id_eveniment = e.id_eveniment;

-- 10. Departamentele și numărul de divizii pentru fiecare
-- (3+ tabele, WHERE)
SELECT d.nume_departament, COUNT(div.id_divizie) as numar_divizii
FROM Departamente d
LEFT JOIN Divizi div ON d.id_departament = div.id_departament
JOIN Voluntari v ON d.id_departament = v.id_departament
WHERE v.email_voluntar IS NOT NULL
GROUP BY d.nume_departament;