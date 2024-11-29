--LAB 1 baze de date

-- Crearea bazei de date
CREATE DATABASE Hermes;
go
USE Hermes;
go

-- Tabelul Sali
CREATE TABLE Sali (
    id_sala INT IDENTITY PRIMARY KEY,
    nume_sala VARCHAR(100) NOT NULL,
    capacitate INT
);

-- Tabelul Inventar (relatie one-to-many cu Sala)
CREATE TABLE Inventare (
    id_inventar INT IDENTITY PRIMARY KEY,
    nume_item VARCHAR(100),
    cantitate INT,
    id_sala INT FOREIGN KEY REFERENCES Sali(id_sala)
);
-- Tabelul Departamente
CREATE TABLE Departamente (
    id_departament INT IDENTITY PRIMARY KEY,
    nume_departament VARCHAR(100),
	descriere VARCHAR(100)
);
-- Tabelul Sedinta (relatie one-to-one cu Sala)
CREATE TABLE Sedinte (
    id_sedinta INT FOREIGN KEY REFERENCES Sali(id_sala),
    data_sedinta DATE,
    durata TIME,
    CONSTRAINT pk_sedinte PRIMARY KEY (id_sedinta), 
	id_departament INT FOREIGN KEY REFERENCES Departamente(id_departament),
);



-- Tabelul Divizi (relatie one-to-many cu Departament)
CREATE TABLE Divizi (
    id_divizie INT IDENTITY PRIMARY KEY,
    nume_divizie VARCHAR(100),
	descriere_divizie VARCHAR(100) NOT NULL,
    id_departament INT FOREIGN KEY REFERENCES Departamente(id_departament)
);

-- Tabelul Voluntar (relatie one-to-many cu Departament)
CREATE TABLE Voluntari (
    id_voluntar INT IDENTITY PRIMARY KEY,
    nume_voluntar VARCHAR(100) NOT NULL,
    email_voluntar VARCHAR(100),
    id_departament INT FOREIGN KEY REFERENCES Departamente(id_departament)
);



-- Tabelul Eveniment
CREATE TABLE Evenimente (
    id_eveniment INT IDENTITY PRIMARY KEY,
    nume_eveniment VARCHAR(100) NOT NULL,
    data_eveniment DATE
);

-- Tabelul Sarcini (relatie one-to-many cu Voluntar si Eveniment)
CREATE TABLE Sarcini (
	id_voluntar INT FOREIGN KEY REFERENCES Voluntari(id_voluntar),
	id_eveniment INT FOREIGN KEY REFERENCES Evenimente(id_eveniment),
	CONSTRAINT id_sarcina PRIMARY KEY (id_voluntar,id_eveniment),
    descriere_sarcina VARCHAR(255),
    status_sarcina VARCHAR(50),
);

-- Tabelul Activitate (relatie one-to-many cu Eveniment)
CREATE TABLE Activitati (
    id_activitate INT IDENTITY PRIMARY KEY,
    nume_activitate VARCHAR(100),
    descriere_activitate VARCHAR(255),
    id_eveniment INT FOREIGN KEY REFERENCES Evenimente(id_eveniment)
);



-- Tabelul Participant (relatie one-to-many cu Activitate)
CREATE TABLE Participanti (
    id_participant INT IDENTITY PRIMARY KEY,
    nume_participant VARCHAR(100),
    email_participant VARCHAR(100),
    id_activitate INT FOREIGN KEY REFERENCES Activitati(id_activitate)
);
