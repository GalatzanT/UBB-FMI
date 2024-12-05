USE  Hermes
go
/*
--alter column table

CREATE PROCEDURE ModificaTipColoana AS
BEGIN
	ALTER TABLE Inventare 
	ALTER COLUMN cantitate VARCHAR(255);
	print 'Am modificat tipul coloanei cantitate din Inventare din INT in CARCHAR(255).'
END;

create procedure UndoModificaTipColoana as
begin	
	alter table Inventare
	alter column cantitate int;
	print 'Am modificat inapoi tipul coloanei cantitate din Inventare din VARCHAR(255) in INT.'
end;


exec ModificaTipColoana
exec UndoModificaTipColoana

--add default constraint

create procedure AdaugaConstraint
as
begin
	alter table Inventare
	add constraint bucata_cantitate default 1 for cantitate
	print 'Am adaugat constraint 1 pentru cantitate	'
end
go

create procedure UndoAdaugaConstraint
as 
begin
	alter table Inventare
	drop constraint bucata_cantitate;
	print 'Am sters constraintul pentru cantitate'
end
go

exec AdaugaConstraint
exec UndoAdaugaConstraint

go

--create and delete table

CREATE PROCEDURE CreazaTabel
AS
BEGIN
    CREATE TABLE Deplasari (
        id_deplasare INT PRIMARY KEY NOT NULL,
        id_voluntar INT NOT NULL,
        perioada DATETIME,
        locatie NVARCHAR(100),
        nr_voluntari INT,
        CONSTRAINT FK_Deplasari_Voluntari 
            FOREIGN KEY (id_voluntar) 
            REFERENCES Voluntari(id_voluntar) 
            ON UPDATE CASCADE 
            ON DELETE CASCADE
    );
    PRINT 'Am creat tabelul Deplasari nou';
END;
GO


CREATE PROCEDURE UndoCreazaTabel
AS
BEGIN
	DROP TABLE Deplasari
	PRINT 'Am sters tabelul deplasari'
END

GO

exec CreazaTabel
exec UndoCreazaTabel

--add column

CREATE PROCEDURE AdaugaColoana
AS 
BEGIN 
	ALTER TABLE Voluntari
    ADD data_nasterii DATE
	PRINT 'Am adaugat in tabelul voluntari coloana data_nasterii'
END
GO

CREATE PROCEDURE UndoAdaugaColoana
AS
BEGIN
	ALTER TABLE VOLUNTARI 
	DROP COLUMN data_nasterii
	PRINT 'Am sters coloana data_nasterii din Voluntari'
END

GO

EXEC  AdaugaColoana
EXEC  UndoAdaugaColoana





--delete foreign key constraint

CREATE PROCEDURE StergeCheieStraina
AS
BEGIN
	ALTER TABLE Divizi 
	DROP CONSTRAINT FK__DIVIZI__id_departament;
	PRINT 'Am sters cheia staina id_departament din Divizi'
END

GO

CREATE PROCEDURE UndoStergeCheieStraina
AS 
BEGIN 
	ALTER TABLE Divizi
	ADD CONSTRAINT FK__DIVIZI__id_departament
	FOREIGN KEY(id_departament) REFERENCES Departamente(id_departament) ON UPDATE CASCADE ON DELETE CASCADE;
	PRINT 'Am adaugat cheia straina id_departament in divizii'
END

GO

--drop procedure StergeCheieStraina
--drop procedure UndoStergeCheieStraina

exec StergeCheieStraina
exec UndoStergeCheieStraina


--tabelul pentru veriunile bazei de date

CREATE TABLE VersionDB(
	id_version int default 0
);

CREATE TABLE Do_Procedure_DB(
	id INT PRIMARY KEY,
	nume_procedure VARCHAR(100)
);


CREATE TABLE Undo_Procedure_DB(
	id INT PRIMARY KEY,
	nume_procedure VARCHAR(100)
);

GO

INSERT INTO VersionDB VALUES(0);

INSERT INTO Do_Procedure_DB VALUES
(1, 'ModificaTipColoana'),
(2, 'AdaugaConstraint'),
(3, 'CreazaTabel'),
(4, 'AdaugaColoana'),
(5, 'StergeCheieStraina');

INSERT INTO Undo_Procedure_DB VALUES
(1, 'UndoModificaTipColoana'),
(2, 'UndoAdaugaConstraint'),
(3, 'UndoCreazaTabel'),
(4, 'UndoAdaugaColoana'),
(5, 'UndoStergeCheieStraina');

*/


--create procedures execution path

CREATE PROCEDURE Main
@Version INT
AS
BEGIN 
    -- Verificare versiune validă
    IF @Version > 5
    BEGIN
        RAISERROR('Avem doar 5 proceduri 1-5', 16, 1);
        RETURN;
    END
    
    -- Preluare versiune actuală
    DECLARE @Actual_Version INT;
    SELECT @Actual_Version = id_version FROM VersionDB;

    PRINT 'Versiunea actuală este: ' + CAST(@Actual_Version AS VARCHAR(10));
    PRINT 'Schimbăm la versiunea: ' + CAST(@Version AS VARCHAR(10));

    -- Verificare dacă deja suntem la versiunea dorită
    IF @Actual_Version = @Version
    BEGIN 
        PRINT 'Baza de date este deja la această versiune!';
        RETURN;
    END

    DECLARE @Function VARCHAR(100);

    -- Upgrade de versiune (creștere)
    IF @Version > @Actual_Version
    BEGIN 
        WHILE @Version != @Actual_Version
        BEGIN
            SET @Actual_Version = @Actual_Version + 1;
            SELECT @Function = nume_procedure 
            FROM Do_Procedure_DB 
            WHERE id = @Actual_Version;
            
            EXEC @Function;
        END
        
        UPDATE VersionDB SET id_version = @Version;
        RETURN;
    END;
    
    -- Downgrade de versiune (scădere)
    WHILE @Version != @Actual_Version
    BEGIN
        SELECT @Function = nume_procedure
        FROM Undo_Procedure_DB
        WHERE id = @Actual_Version;

        EXEC @Function;
        SET @Actual_Version = @Actual_Version - 1;
    END
     
    UPDATE VersionDB SET id_version = @Version;
    RETURN;
END
	 
EXEC Main @Version = 3;




