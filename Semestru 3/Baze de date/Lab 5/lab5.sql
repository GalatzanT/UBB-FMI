USE Hermes
GO

-- Validation functions
CREATE FUNCTION dbo.ValidateEmail(@email VARCHAR(100))
RETURNS BIT
AS
BEGIN
    DECLARE @isValid BIT = 0
    IF @email LIKE '%@%.%' 
        SET @isValid = 1
    RETURN @isValid
END
GO

CREATE FUNCTION dbo.ValidateName(@name VARCHAR(100))
RETURNS BIT
AS
BEGIN
    DECLARE @isValid BIT = 0
    IF LEN(@name) >= 2 AND @name NOT LIKE '%[0-9]%'
        SET @isValid = 1
    RETURN @isValid
END
GO

-- 1. CRUD for Voluntari
CREATE PROCEDURE CRUD_Voluntari
    @Operation VARCHAR(10),
    @id_voluntar INT = NULL,
    @nume_voluntar VARCHAR(100) = NULL,
    @email_voluntar VARCHAR(100) = NULL,
    @id_departament INT = NULL,
    @ResponseMessage VARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate input based on operation
    IF @Operation = 'CREATE' OR @Operation = 'UPDATE'
    BEGIN
        IF dbo.ValidateName(@nume_voluntar) = 0
        BEGIN
            SET @ResponseMessage = 'Invalid volunteer name'
            RETURN
        END
        
        IF dbo.ValidateEmail(@email_voluntar) = 0
        BEGIN
            SET @ResponseMessage = 'Invalid email format'
            RETURN
        END
        
        -- Validate department exists
        IF NOT EXISTS (SELECT 1 FROM Departamente WHERE id_departament = @id_departament)
        BEGIN
            SET @ResponseMessage = 'Department does not exist'
            RETURN
        END
    END

    -- Perform the requested operation
    BEGIN TRY
        IF @Operation = 'CREATE'
        BEGIN
            INSERT INTO Voluntari (nume_voluntar, email_voluntar, id_departament)
            VALUES (@nume_voluntar, @email_voluntar, @id_departament)
            SET @ResponseMessage = 'Volunteer created successfully'
        END
        
        ELSE IF @Operation = 'READ'
        BEGIN
            SELECT * FROM Voluntari 
            WHERE id_voluntar = @id_voluntar OR @id_voluntar IS NULL
            SET @ResponseMessage = 'Read operation completed'
        END
        
        ELSE IF @Operation = 'UPDATE'
        BEGIN
            UPDATE Voluntari
            SET nume_voluntar = @nume_voluntar,
                email_voluntar = @email_voluntar,
                id_departament = @id_departament
            WHERE id_voluntar = @id_voluntar
            SET @ResponseMessage = 'Volunteer updated successfully'
        END
        
        ELSE IF @Operation = 'DELETE'
        BEGIN
            -- First delete related records in Sarcini
            DELETE FROM Sarcini WHERE id_voluntar = @id_voluntar
            -- Then delete the volunteer
            DELETE FROM Voluntari WHERE id_voluntar = @id_voluntar
            SET @ResponseMessage = 'Volunteer and related tasks deleted successfully'
        END
        
        ELSE
        BEGIN
            SET @ResponseMessage = 'Invalid operation'
            RETURN
        END
    END TRY
    BEGIN CATCH
        SET @ResponseMessage = ERROR_MESSAGE()
    END CATCH
END
GO

-- Create the first view combining Voluntari and Departamente
CREATE VIEW vw_VoluntariDepartamente
AS
SELECT 
    v.id_voluntar,
    v.nume_voluntar,
    v.email_voluntar,
    d.nume_departament,
    d.descriere as descriere_departament
FROM Voluntari v
INNER JOIN Departamente d ON v.id_departament = d.id_departament
GO

-- Create non-clustered index for the view
CREATE NONCLUSTERED INDEX IX_Voluntari_Email 
ON Voluntari(email_voluntar)
GO



-- Additional validation functions
CREATE FUNCTION dbo.ValidateDate(@date DATE)
RETURNS BIT
AS
BEGIN
    DECLARE @isValid BIT = 0
    IF @date >= GETDATE()
        SET @isValid = 1
    RETURN @isValid
END
GO

-- 2. CRUD for Evenimente
CREATE PROCEDURE CRUD_Evenimente
    @Operation VARCHAR(10),
    @id_eveniment INT = NULL,
    @nume_eveniment VARCHAR(100) = NULL,
    @data_eveniment DATE = NULL,
    @ResponseMessage VARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate input based on operation
    IF @Operation = 'CREATE' OR @Operation = 'UPDATE'
    BEGIN
        IF dbo.ValidateName(@nume_eveniment) = 0
        BEGIN
            SET @ResponseMessage = 'Invalid event name'
            RETURN
        END
        
        IF dbo.ValidateDate(@data_eveniment) = 0
        BEGIN
            SET @ResponseMessage = 'Event date must be in the future'
            RETURN
        END
    END

    BEGIN TRY
        IF @Operation = 'CREATE'
        BEGIN
            INSERT INTO Evenimente (nume_eveniment, data_eveniment)
            VALUES (@nume_eveniment, @data_eveniment)
            SET @ResponseMessage = 'Event created successfully'
        END
        
        ELSE IF @Operation = 'READ'
        BEGIN
            SELECT * FROM Evenimente 
            WHERE id_eveniment = @id_eveniment OR @id_eveniment IS NULL
            SET @ResponseMessage = 'Read operation completed'
        END
        
        ELSE IF @Operation = 'UPDATE'
        BEGIN
            UPDATE Evenimente
            SET nume_eveniment = @nume_eveniment,
                data_eveniment = @data_eveniment
            WHERE id_eveniment = @id_eveniment
            SET @ResponseMessage = 'Event updated successfully'
        END
        
        ELSE IF @Operation = 'DELETE'
        BEGIN
            -- First delete related records in Sarcini and Activitati
            DELETE FROM Sarcini WHERE id_eveniment = @id_eveniment
            DELETE FROM Activitati WHERE id_eveniment = @id_eveniment
            -- Then delete the event
            DELETE FROM Evenimente WHERE id_eveniment = @id_eveniment
            SET @ResponseMessage = 'Event and related records deleted successfully'
        END
        
        ELSE
        BEGIN
            SET @ResponseMessage = 'Invalid operation'
            RETURN
        END
    END TRY
    BEGIN CATCH
        SET @ResponseMessage = ERROR_MESSAGE()
    END CATCH
END
GO

-- 3. CRUD for Sarcini (Many-to-Many relationship)
CREATE PROCEDURE CRUD_Sarcini
    @Operation VARCHAR(10),
    @id_voluntar INT = NULL,
    @id_eveniment INT = NULL,
    @descriere_sarcina VARCHAR(255) = NULL,
    @status_sarcina VARCHAR(50) = NULL,
    @ResponseMessage VARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate input based on operation
    IF @Operation = 'CREATE' OR @Operation = 'UPDATE'
    BEGIN
        -- Validate volunteer exists
        IF NOT EXISTS (SELECT 1 FROM Voluntari WHERE id_voluntar = @id_voluntar)
        BEGIN
            SET @ResponseMessage = 'Volunteer does not exist'
            RETURN
        END
        
        -- Validate event exists
        IF NOT EXISTS (SELECT 1 FROM Evenimente WHERE id_eveniment = @id_eveniment)
        BEGIN
            SET @ResponseMessage = 'Event does not exist'
            RETURN
        END
        
        -- Validate status
        IF @status_sarcina NOT IN ('New', 'In Progress', 'Completed', 'Cancelled')
        BEGIN
            SET @ResponseMessage = 'Invalid status'
            RETURN
        END
    END

    BEGIN TRY
        IF @Operation = 'CREATE'
        BEGIN
            INSERT INTO Sarcini (id_voluntar, id_eveniment, descriere_sarcina, status_sarcina)
            VALUES (@id_voluntar, @id_eveniment, @descriere_sarcina, @status_sarcina)
            SET @ResponseMessage = 'Task created successfully'
        END
        
        ELSE IF @Operation = 'READ'
        BEGIN
            SELECT s.*, v.nume_voluntar, e.nume_eveniment 
            FROM Sarcini s
            JOIN Voluntari v ON s.id_voluntar = v.id_voluntar
            JOIN Evenimente e ON s.id_eveniment = e.id_eveniment
            WHERE (s.id_voluntar = @id_voluntar OR @id_voluntar IS NULL)
            AND (s.id_eveniment = @id_eveniment OR @id_eveniment IS NULL)
            SET @ResponseMessage = 'Read operation completed'
        END
        
        ELSE IF @Operation = 'UPDATE'
        BEGIN
            UPDATE Sarcini
            SET descriere_sarcina = @descriere_sarcina,
                status_sarcina = @status_sarcina
            WHERE id_voluntar = @id_voluntar AND id_eveniment = @id_eveniment
            SET @ResponseMessage = 'Task updated successfully'
        END
        
        ELSE IF @Operation = 'DELETE'
        BEGIN
            DELETE FROM Sarcini 
            WHERE id_voluntar = @id_voluntar AND id_eveniment = @id_eveniment
            SET @ResponseMessage = 'Task deleted successfully'
        END
        
        ELSE
        BEGIN
            SET @ResponseMessage = 'Invalid operation'
            RETURN
        END
    END TRY
    BEGIN CATCH
        SET @ResponseMessage = ERROR_MESSAGE()
    END CATCH
END
GO

-- 4. CRUD for Departamente
CREATE PROCEDURE CRUD_Departamente
    @Operation VARCHAR(10),
    @id_departament INT = NULL,
    @nume_departament VARCHAR(100) = NULL,
    @descriere VARCHAR(100) = NULL,
    @ResponseMessage VARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate input based on operation
    IF @Operation = 'CREATE' OR @Operation = 'UPDATE'
    BEGIN
        IF dbo.ValidateName(@nume_departament) = 0
        BEGIN
            SET @ResponseMessage = 'Invalid department name'
            RETURN
        END
    END

    BEGIN TRY
        IF @Operation = 'CREATE'
        BEGIN
            INSERT INTO Departamente (nume_departament, descriere)
            VALUES (@nume_departament, @descriere)
            SET @ResponseMessage = 'Department created successfully'
        END
        
        ELSE IF @Operation = 'READ'
        BEGIN
            SELECT d.*, COUNT(v.id_voluntar) as numar_voluntari
            FROM Departamente d
            LEFT JOIN Voluntari v ON d.id_departament = v.id_departament
            WHERE d.id_departament = @id_departament OR @id_departament IS NULL
            GROUP BY d.id_departament, d.nume_departament, d.descriere
            SET @ResponseMessage = 'Read operation completed'
        END
        
        ELSE IF @Operation = 'UPDATE'
        BEGIN
            UPDATE Departamente
            SET nume_departament = @nume_departament,
                descriere = @descriere
            WHERE id_departament = @id_departament
            SET @ResponseMessage = 'Department updated successfully'
        END
        
        ELSE IF @Operation = 'DELETE'
        BEGIN
            -- Check if department has volunteers
            IF EXISTS (SELECT 1 FROM Voluntari WHERE id_departament = @id_departament)
            BEGIN
                SET @ResponseMessage = 'Cannot delete department with assigned volunteers'
                RETURN
            END
            
            -- Delete related records in Divizi and Sedinte
            DELETE FROM Divizi WHERE id_departament = @id_departament
            DELETE FROM Sedinte WHERE id_departament = @id_departament
            -- Then delete the department
            DELETE FROM Departamente WHERE id_departament = @id_departament
            SET @ResponseMessage = 'Department and related records deleted successfully'
        END
        
        ELSE
        BEGIN
            SET @ResponseMessage = 'Invalid operation'
            RETURN
        END
    END TRY
    BEGIN CATCH
        SET @ResponseMessage = ERROR_MESSAGE()
    END CATCH
END
GO

-- 5. CRUD for Activitati
CREATE PROCEDURE CRUD_Activitati
    @Operation VARCHAR(10),
    @id_activitate INT = NULL,
    @nume_activitate VARCHAR(100) = NULL,
    @descriere_activitate VARCHAR(255) = NULL,
    @id_eveniment INT = NULL,
    @ResponseMessage VARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate input based on operation
    IF @Operation = 'CREATE' OR @Operation = 'UPDATE'
    BEGIN
        IF dbo.ValidateName(@nume_activitate) = 0
        BEGIN
            SET @ResponseMessage = 'Invalid activity name'
            RETURN
        END
        
        -- Validate event exists
        IF NOT EXISTS (SELECT 1 FROM Evenimente WHERE id_eveniment = @id_eveniment)
        BEGIN
            SET @ResponseMessage = 'Event does not exist'
            RETURN
        END
    END

    BEGIN TRY
        IF @Operation = 'CREATE'
        BEGIN
            INSERT INTO Activitati (nume_activitate, descriere_activitate, id_eveniment)
            VALUES (@nume_activitate, @descriere_activitate, @id_eveniment)
            SET @ResponseMessage = 'Activity created successfully'
        END
        
        ELSE IF @Operation = 'READ'
        BEGIN
            SELECT a.*, e.nume_eveniment, COUNT(p.id_participant) as numar_participanti
            FROM Activitati a
            JOIN Evenimente e ON a.id_eveniment = e.id_eveniment
            LEFT JOIN Participanti p ON a.id_activitate = p.id_activitate
            WHERE a.id_activitate = @id_activitate OR @id_activitate IS NULL
            GROUP BY a.id_activitate, a.nume_activitate, a.descriere_activitate, 
                     a.id_eveniment, e.nume_eveniment
            SET @ResponseMessage = 'Read operation completed'
        END
        
        ELSE IF @Operation = 'UPDATE'
        BEGIN
            UPDATE Activitati
            SET nume_activitate = @nume_activitate,
                descriere_activitate = @descriere_activitate,
                id_eveniment = @id_eveniment
            WHERE id_activitate = @id_activitate
            SET @ResponseMessage = 'Activity updated successfully'
        END
        
        ELSE IF @Operation = 'DELETE'
        BEGIN
            -- First delete related records in Participanti
            DELETE FROM Participanti WHERE id_activitate = @id_activitate
            -- Then delete the activity
            DELETE FROM Activitati WHERE id_activitate = @id_activitate
            SET @ResponseMessage = 'Activity and related participants deleted successfully'
        END
        
        ELSE
        BEGIN
            SET @ResponseMessage = 'Invalid operation'
            RETURN
        END
    END TRY
    BEGIN CATCH
        SET @ResponseMessage = ERROR_MESSAGE()
    END CATCH
END
GO

-- Create second view combining Evenimente, Activitati, and Participanti
CREATE VIEW vw_EventActivitiesParticipants
AS
SELECT 
    e.id_eveniment,
    e.nume_eveniment,
    e.data_eveniment,
    a.id_activitate,
    a.nume_activitate,
    COUNT(p.id_participant) as numar_participanti
FROM Evenimente e
LEFT JOIN Activitati a ON e.id_eveniment = a.id_eveniment
LEFT JOIN Participanti p ON a.id_activitate = p.id_activitate
GROUP BY 
    e.id_eveniment,
    e.nume_eveniment,
    e.data_eveniment,
    a.id_activitate,
    a.nume_activitate
GO

-- Create additional non-clustered indexes
CREATE NONCLUSTERED INDEX IX_Evenimente_Data 
ON Evenimente(data_eveniment)
GO

CREATE NONCLUSTERED INDEX IX_Activitati_Event 
ON Activitati(id_eveniment)
GO

CREATE NONCLUSTERED INDEX IX_Sarcini_Composite 
ON Sarcini(id_voluntar, id_eveniment)
GO

-- Validation functions
CREATE FUNCTION dbo.ValidateEmail(@email VARCHAR(100))
RETURNS BIT
AS
BEGIN
    DECLARE @isValid BIT = 0
    IF @email LIKE '%@%.%' 
        SET @isValid = 1
    RETURN @isValid
END
GO

CREATE FUNCTION dbo.ValidateName(@name VARCHAR(100))
RETURNS BIT
AS
BEGIN
    DECLARE @isValid BIT = 0
    IF LEN(@name) >= 2 AND @name NOT LIKE '%[0-9]%'
        SET @isValid = 1
    RETURN @isValid
END
GO

-- 1. CRUD for Voluntari
CREATE PROCEDURE CRUD_Voluntari
    @Operation VARCHAR(10),
    @id_voluntar INT = NULL,
    @nume_voluntar VARCHAR(100) = NULL,
    @email_voluntar VARCHAR(100) = NULL,
    @id_departament INT = NULL,
    @ResponseMessage VARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validate input based on operation
    IF @Operation = 'CREATE' OR @Operation = 'UPDATE'
    BEGIN
        IF dbo.ValidateName(@nume_voluntar) = 0
        BEGIN
            SET @ResponseMessage = 'Invalid volunteer name'
            RETURN
        END
        
        IF dbo.ValidateEmail(@email_voluntar) = 0
        BEGIN
            SET @ResponseMessage = 'Invalid email format'
            RETURN
        END
        
        -- Validate department exists
        IF NOT EXISTS (SELECT 1 FROM Departamente WHERE id_departament = @id_departament)
        BEGIN
            SET @ResponseMessage = 'Department does not exist'
            RETURN
        END
    END

    -- Perform the requested operation
    BEGIN TRY
        IF @Operation = 'CREATE'
        BEGIN
            INSERT INTO Voluntari (nume_voluntar, email_voluntar, id_departament)
            VALUES (@nume_voluntar, @email_voluntar, @id_departament)
            SET @ResponseMessage = 'Volunteer created successfully'
        END
        
        ELSE IF @Operation = 'READ'
        BEGIN
            SELECT * FROM Voluntari 
            WHERE id_voluntar = @id_voluntar OR @id_voluntar IS NULL
            SET @ResponseMessage = 'Read operation completed'
        END
        
        ELSE IF @Operation = 'UPDATE'
        BEGIN
            UPDATE Voluntari
            SET nume_voluntar = @nume_voluntar,
                email_voluntar = @email_voluntar,
                id_departament = @id_departament
            WHERE id_voluntar = @id_voluntar
            SET @ResponseMessage = 'Volunteer updated successfully'
        END
        
        ELSE IF @Operation = 'DELETE'
        BEGIN
            -- First delete related records in Sarcini
            DELETE FROM Sarcini WHERE id_voluntar = @id_voluntar
            -- Then delete the volunteer
            DELETE FROM Voluntari WHERE id_voluntar = @id_voluntar
            SET @ResponseMessage = 'Volunteer and related tasks deleted successfully'
        END
        
        ELSE
        BEGIN
            SET @ResponseMessage = 'Invalid operation'
            RETURN
        END
    END TRY
    BEGIN CATCH
        SET @ResponseMessage = ERROR_MESSAGE()
    END CATCH
END
GO

-- Create the first view combining Voluntari and Departamente
CREATE VIEW vw_VoluntariDepartamente
AS
SELECT 
    v.id_voluntar,
    v.nume_voluntar,
    v.email_voluntar,
    d.nume_departament,
    d.descriere as descriere_departament
FROM Voluntari v
INNER JOIN Departamente d ON v.id_departament = d.id_departament
GO

-- Create non-clustered index for the view
CREATE NONCLUSTERED INDEX IX_Voluntari_Email 
ON Voluntari(email_voluntar)
GO