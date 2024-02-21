--==============================================================================
-- Created By: Kedric Woods
-- Create Date: 4/4/2022

-- Description:
	-- Creates 2 tables and inserts dates along with their respective day of the week name based on the following:
		-- Dates_Selected_Date_Range: Dates are inserted into the Dates_Selected_Date_Range table for every date between a selected date range.
		-- Dates_Next_Year: Dates are inserted into the Dates_Next_Year table for every date in the following year. (January 1 - December 31)
--==============================================================================


USE DEV
GO


-- Table: Dates_Selected_Date_Range

DROP TABLE IF EXISTS Dates_Selected_Date_Range -- "DROP TABLE IF EXISTS" Works starting with SQL Server Version 2016


CREATE TABLE Dates_Selected_Date_Range
	(
		ID INT IDENTITY(1,1),
		[Date] DATE NOT NULL,
		Day_Name VARCHAR(15), -- Day of the week name
		Day_Int INT -- Integer value for the day of the week: DATEPART(WEEKDAY,Date)
	)

ALTER TABLE Dates_Selected_Date_Range
ADD CONSTRAINT PK_Date1 PRIMARY KEY ([Date])


-- Dynamically Insert dates that are between selected start dates and end dates

DECLARE @Date_To_Insert1 DATE = '1/1/2020'
DECLARE @Start_Date1 DATE = '1/1/2020'
DECLARE @End_Date1 DATE = '12/31/2025'


WHILE @Date_To_Insert1 BETWEEN @Start_Date1 AND @End_Date1 
	BEGIN
		INSERT INTO Dates_Selected_Date_Range ([Date], Day_Name, Day_Int)
			SELECT @Date_To_Insert1, DATENAME(WEEKDAY,@Date_To_Insert1), DATEPART(WEEKDAY,@Date_To_Insert1)
		SET @Date_To_Insert1 = DATEADD(d,1,@Date_To_Insert1)
	END


SELECT *
FROM Dates_Selected_Date_Range




-- Table: Dates_Next_Year

DROP TABLE IF EXISTS Dates_Next_Year -- "DROP TABLE IF EXISTS" Works starting with SQL Server Version 2016

CREATE TABLE Dates_Next_Year
	(
		ID INT IDENTITY(1,1),
		[Date] DATE NOT NULL,
		Day_Name VARCHAR(15), -- Day of the week
		Day_Int INT -- Integer value for the day of the week: DATEPART(WEEKDAY,Date)
	)

ALTER TABLE Dates_Next_Year
ADD CONSTRAINT PK_Date2 PRIMARY KEY ([Date])



-- Dynamically Insert dates into table for every date in the following year. (January 1 - December 31)


DECLARE @Date_To_Insert2 DATE = DATEADD(M,-1,DATEADD(YEAR,1,DATEADD(D,1-DAY(GETDATE()),GETDATE()))) -- First Day of Next Year
DECLARE @End_Date2 DATE = DATEADD(yy,1,DATEADD(yy, DATEDIFF(yy,0,GETDATE()) + 1, -1)) -- Last Day of Next Year


WHILE @Date_To_Insert2 <= @End_Date2
	BEGIN
		INSERT INTO Dates_Next_Year ([Date], Day_Name, Day_Int)
			SELECT @Date_To_Insert2, DATENAME(WEEKDAY,@Date_To_Insert2), DATEPART(WEEKDAY,@Date_To_Insert2)
		SET @Date_To_Insert2 = DATEADD(d,1,@Date_To_Insert2)
	END



SELECT *
FROM Dates_Next_Year




