USE Hermes
GO

-- Declare variable for storing response messages
DECLARE @ResponseMessage VARCHAR(250)

-- Clean up existing test data (if any)
DELETE FROM Sarcini
DELETE FROM Participanti
DELETE FROM Activitati
DELETE FROM Evenimente
DELETE FROM Voluntari
DELETE FROM Divizi
DELETE FROM Sedinte
DELETE FROM Departamente

PRINT '1. Testing CRUD for Departamente'
PRINT '---------------------------------'

-- CREATE Department
EXEC CRUD_Departamente 
    @Operation = 'CREATE',
    @nume_departament = 'IT Department',
    @descriere = 'Technical Support and Development',
    @ResponseMessage = @ResponseMessage OUTPUT
PRINT 'Create Department Result: ' + @ResponseMessage

-- CREATE another Department
EXEC CRUD_Departamente 
    @Operation = 'CREATE',
    @nume_departament = 'HR Department',
    @descriere = 'Human Resources',
    @ResponseMessage = @ResponseMessage OUTPUT

-- READ Departments
EXEC CRUD_Departamente 
    @Operation = 'READ',
    @ResponseMessage = @ResponseMessage OUTPUT
PRINT 'Read Departments Result: ' + @ResponseMessage

PRINT '2. Testing CRUD for Voluntari'
PRINT '---------------------------------'

-- CREATE Volunteer (Success case)
EXEC CRUD_Voluntari 
    @Operation = 'CREATE',
    @nume_voluntar = 'John Doe',
    @email_voluntar = 'john.doe@email.com',
    @id_departament = 1,
    @ResponseMessage = @ResponseMessage OUTPUT
PRINT 'Create Volunteer Result: ' + @ResponseMessage

-- CREATE another Volunteer
EXEC CRUD_Voluntari 
    @Operation = 'CREATE',
    @nume_voluntar = 'Jane Smith',
    @email_voluntar = 'jane.smith@email.com',
    @id_departament = 1,
    @ResponseMessage = @ResponseMessage OUTPUT

-- Test invalid email (Failure case)
EXEC CRUD_Voluntari 
    @Operation = 'CREATE',
    @nume_voluntar = 'Invalid Email',
    @email_voluntar = 'invalid-email',
    @id_departament = 1,
    @ResponseMessage = @ResponseMessage OUTPUT
PRINT 'Create Volunteer with Invalid Email Result: ' + @ResponseMessage

PRINT '3. Testing CRUD for Evenimente'
PRINT '---------------------------------'

-- CREATE Event
EXEC CRUD_Evenimente 
    @Operation = 'CREATE',
    @nume_eveniment = 'Tech Conference 2024',
    @data_eveniment = '2024-12-25',
    @ResponseMessage = @ResponseMessage OUTPUT
PRINT 'Create Event Result: ' + @ResponseMessage

-- CREATE another Event
EXEC CRUD_Evenimente 
    @Operation = 'CREATE',
    @nume_eveniment = 'Holiday Party',
    @data_eveniment = '2024-12-31',
    @ResponseMessage = @ResponseMessage OUTPUT

-- READ Events
EXEC CRUD_Evenimente 
    @Operation = 'READ',
    @ResponseMessage = @ResponseMessage OUTPUT

PRINT '4. Testing CRUD for Activitati'
PRINT '---------------------------------'

-- CREATE Activity
EXEC CRUD_Activitati 
    @Operation = 'CREATE',
    @nume_activitate = 'Registration',
    @descriere_activitate = 'Register conference participants',
    @id_eveniment = 1,
    @ResponseMessage = @ResponseMessage OUTPUT
PRINT 'Create Activity Result: ' + @ResponseMessage

-- CREATE another Activity
EXEC CRUD_Activitati 
    @Operation = 'CREATE',
    @nume_activitate = 'Workshop',
    @descriere_activitate = 'Technical Workshop',
    @id_eveniment = 1,
    @ResponseMessage = @ResponseMessage OUTPUT

-- UPDATE Activity
EXEC CRUD_Activitati 
    @Operation = 'UPDATE',
    @id_activitate = 1,
    @nume_activitate = 'Check-in and Registration',
    @descriere_activitate = 'Register and check-in conference participants',
    @id_eveniment = 1,
    @ResponseMessage = @ResponseMessage OUTPUT
PRINT 'Update Activity Result: ' + @ResponseMessage

PRINT '5. Testing CRUD for Sarcini (Many-to-Many)'
PRINT '---------------------------------'

-- CREATE Task
EXEC CRUD_Sarcini 
    @Operation = 'CREATE',
    @id_voluntar = 1,
    @id_eveniment = 1,
    @descriere_sarcina = 'Manage registration desk',
    @status_sarcina = 'New',
    @ResponseMessage = @ResponseMessage OUTPUT
PRINT 'Create Task Result: ' + @ResponseMessage

-- CREATE another Task
EXEC CRUD_Sarcini 
    @Operation = 'CREATE',
    @id_voluntar = 2,
    @id_eveniment = 1,
    @descriere_sarcina = 'Handle workshop coordination',
    @status_sarcina = 'In Progress',
    @ResponseMessage = @ResponseMessage OUTPUT

-- UPDATE Task Status
EXEC CRUD_Sarcini 
    @Operation = 'UPDATE',
    @id_voluntar = 1,
    @id_eveniment = 1,
    @descriere_sarcina = 'Manage registration desk',
    @status_sarcina = 'Completed',
    @ResponseMessage = @ResponseMessage OUTPUT
PRINT 'Update Task Result: ' + @ResponseMessage

PRINT '6. Testing Views'
PRINT '---------------------------------'

-- Test first view
PRINT 'Testing vw_VoluntariDepartamente:'
SELECT * FROM vw_VoluntariDepartamente

-- Test second view
PRINT 'Testing vw_EventActivitiesParticipants:'
SELECT * FROM vw_EventActivitiesParticipants

-- Test Deletion (CASCADE)
PRINT '7. Testing Deletion with Relationships'
PRINT '---------------------------------'

-- Try to delete department with volunteers (should fail)
EXEC CRUD_Departamente 
    @Operation = 'DELETE',
    @id_departament = 1,
    @ResponseMessage = @ResponseMessage OUTPUT
PRINT 'Delete Department with Volunteers Result: ' + @ResponseMessage

-- Delete a volunteer and their tasks
EXEC CRUD_Voluntari 
    @Operation = 'DELETE',
    @id_voluntar = 2,
    @ResponseMessage = @ResponseMessage OUTPUT
PRINT 'Delete Volunteer Result: ' + @ResponseMessage

-- Verify deletion by reading all tables
PRINT 'Final State of Database:'
SELECT 'Departments' as TableName, COUNT(*) as RecordCount FROM Departamente
UNION ALL
SELECT 'Volunteers', COUNT(*) FROM Voluntari
UNION ALL
SELECT 'Events', COUNT(*) FROM Evenimente
UNION ALL
SELECT 'Activities', COUNT(*) FROM Activitati
UNION ALL
SELECT 'Tasks', COUNT(*) FROM Sarcini