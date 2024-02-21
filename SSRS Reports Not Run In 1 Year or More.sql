--================================================================

-- Displays SSRS reports which are not in a Dev, Test, or Archived folder and have not been run in 1 year or more.

-- Created By: Kedric Woods
-- Create Date: 09/17/2021

--================================================================

SELECT
	c.[Name] AS ReportName,
	ISNULL(c.[Path], 'Unknown') AS ReportPath
FROM ReportServer.dbo.[Catalog] c
INNER JOIN ReportServer.dbo.ExecutionLogStorage els ON c.ItemID = els.ReportID
WHERE LEFT(c.[Path], 4) <> '/DEV' AND LEFT(c.[Path],5) <> '/TEST' AND LEFT(c.[Path],10) <> '/Z_Archive' -- Exlcude "Dev", "Test", and "Archived" reports
	AND c.[Type] = '2' -- SSRS Reports
	AND (0 + CONVERT(VARCHAR(8), GETDATE(), 112) - CONVERT(VARCHAR(8),els.TimeStart,112)) / 10000 >= 1 