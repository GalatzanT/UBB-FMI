USE Hermes
go

-- Step 1: Populate Tables
INSERT INTO Tables ([Name])
VALUES ('Sali'), ('Inventare'), ('Sedinte');

-- Step 2: Populate Views
INSERT INTO Views ([Name])
VALUES 
('SaliView'), 
('SaliWithInventory'), 
('GroupedInventories');
GO


-- View: SELECT on one table
CREATE OR ALTER VIEW SaliView AS
SELECT id_sala, nume_sala, capacitate
FROM Sali;

-- View: SELECT on two tables
CREATE OR ALTER VIEW SaliWithInventory AS
SELECT s.id_sala, s.nume_sala, i.nume_item, i.cantitate
FROM Sali s
LEFT JOIN Inventare i ON s.id_sala = i.id_sala;

-- View: SELECT with GROUP BY
CREATE OR ALTER VIEW GroupedInventories AS
SELECT i.id_sala, COUNT(i.id_inventar) AS TotalItems
FROM Inventare i
GROUP BY i.id_sala;
GO



-- Populate Tests
INSERT INTO Tests ([Name])
VALUES 
('Test_Insert_Delete_Sali'),
('Test_Insert_Delete_Inventare'),
('Test_Select_Views');

-- Populate TestTables
INSERT INTO TestTables (TestID, TableID, NoOfRows, Position)
SELECT t.TestID, tb.TableID, 
    CASE 
        WHEN t.Name LIKE 'Test_Insert%' THEN 1000
        ELSE 0
    END AS NoOfRows,
    ROW_NUMBER() OVER (ORDER BY tb.Name) AS Position
FROM Tests t
CROSS JOIN Tables tb
WHERE t.Name LIKE 'Test_Insert%';

-- Populate TestViews
INSERT INTO TestViews (TestID, ViewID)
SELECT t.TestID, v.ViewID
FROM Tests t, Views v
WHERE t.Name = 'Test_Select_Views';
GO


-- Procedure to Delete from Tables
CREATE OR ALTER PROCEDURE DeleteData
    @TableName NVARCHAR(50), 
    @NoOfRows INT
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = 'DELETE TOP (' + CAST(@NoOfRows AS NVARCHAR) + ') FROM ' + @TableName;
    EXEC(@SQL);
END;
GO

-- Procedure to Insert Data into Tables
CREATE OR ALTER PROCEDURE InsertData
    @TableName NVARCHAR(50), 
    @NoOfRows INT
AS
BEGIN
    IF @TableName = 'Sali'
    BEGIN
        EXEC TestInsertSali @NoOfRows;
    END
    ELSE IF @TableName = 'Inventare'
    BEGIN
        EXEC TestInsertInventare @NoOfRows;
    END
END;
GO


CREATE OR ALTER PROCEDURE RunPerformanceTests
AS
BEGIN
    DECLARE @TestRunID INT;
    DECLARE @StartTime DATETIME;
    DECLARE @EndTime DATETIME;

    -- Start Test Run
    INSERT INTO TestRuns (Description, StartAt)
    VALUES ('Performance Test Run', GETDATE());
    SET @TestRunID = SCOPE_IDENTITY();

    -- Delete and Insert Data
    DECLARE @TableID INT, @TableName NVARCHAR(50), @NoOfRows INT;

    -- Deletion in `Position` Order
    DECLARE DeleteCursor CURSOR FOR 
    SELECT t.Name, tt.NoOfRows
    FROM TestTables tt
    JOIN Tables t ON tt.TableID = t.TableID
    ORDER BY tt.Position;

    OPEN DeleteCursor;
    FETCH NEXT FROM DeleteCursor INTO @TableName, @NoOfRows;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC DeleteData @TableName, @NoOfRows;
        FETCH NEXT FROM DeleteCursor INTO @TableName, @NoOfRows;
    END;

    CLOSE DeleteCursor;
    DEALLOCATE DeleteCursor;

    -- Insertion in Reverse `Position` Order
    DECLARE InsertCursor CURSOR FOR 
    SELECT t.Name, tt.NoOfRows
    FROM TestTables tt
    JOIN Tables t ON tt.TableID = t.TableID
    ORDER BY tt.Position DESC;

    OPEN InsertCursor;
    FETCH NEXT FROM InsertCursor INTO @TableName, @NoOfRows;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC InsertData @TableName, @NoOfRows;
        FETCH NEXT FROM InsertCursor INTO @TableName, @NoOfRows;
    END;

    CLOSE InsertCursor;
    DEALLOCATE InsertCursor;

    -- Evaluate Views
    DECLARE @ViewName NVARCHAR(50);

    DECLARE ViewCursor CURSOR FOR 
    SELECT v.Name
    FROM TestViews tv
    JOIN Views v ON tv.ViewID = v.ViewID;

    OPEN ViewCursor;
    FETCH NEXT FROM ViewCursor INTO @ViewName;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @StartTime = GETDATE();
        EXEC('SELECT * FROM ' + @ViewName);
        SET @EndTime = GETDATE();

        INSERT INTO TestRunViews (TestRunID, ViewID, StartAt, EndAt)
        SELECT @TestRunID, ViewID, @StartTime, @EndTime
        FROM Views
        WHERE Name = @ViewName;

        FETCH NEXT FROM ViewCursor INTO @ViewName;
    END;

    CLOSE ViewCursor;
    DEALLOCATE ViewCursor;

    -- Finalize Test Run
    UPDATE TestRuns 
    SET EndAt = GETDATE()
    WHERE TestRunID = @TestRunID;
END;
GO

EXEC RunPerformanceTests;