USE Hermes
GO

SELECT TestRunID, Description, StartAt, EndAt, 
       DATEDIFF(MILLISECOND, StartAt, EndAt) AS DurationMilliseconds
FROM TestRuns;

SELECT * FROM TestRuns;	
SELECT * FROM Tables;
SELECT * FROM Views;
