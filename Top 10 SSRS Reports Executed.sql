-- A query I written to view the Top 10 SSRS Reports Executed on an SSRS server (By Number of times run)


SELECT
	Report_Execution_Ranking,
	Report_Name,
	Report_Path,
	Execution_Type
	Report_Execution_Count
FROM
	(
		SELECT
			c.[Name] AS Report_Name,
			ISNULL(c.[Path], 'Unknown') AS Report_Path,
			CASE
				WHEN el.RequestType = 0 THEN 'User' -- 'Manual', 'Interactive'
				WHEN el.RequestType = 1 THEN 'Subscription'
				WHEN el.RequestType = 2 THEN 'Refresh Cache'
				ELSE 'Unknown'
			END AS Execution_Type,
			COUNT(*) AS Report_Execution_Count,
			DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS Report_Execution_Ranking
		FROM ReportServer.dbo.[Catalog] c
		INNER JOIN ReportServer.dbo.ExecutionLogStorage el ON c.ItemID = el.ReportID
		INNER JOIN ReportServer.dbo.Users u ON el.UserName = u.UserName
		WHERE LEFT(c.[Path], 4) <> '/DEV' AND LEFT(c.[Path], 5) <> '/TEST' -- Exclude Dev and Test reports
			AND el.RequestType = @Execution_Type
			AND CAST(el.TimeStart AS DATE) BETWEEN @Start_Date AND @End_Date
		GROUP BY 
			CASE 
				WHEN el.RequestType = 0 THEN 'User' -- 'Manual', 'Interactive'
				WHEN el.RequestType = 1 THEN 'Subscription'
				WHEN el.RequestType = 2 THEN 'Refresh Cache'
				ELSE 'Unknown'
			END
		) t
WHERE Report_Execution_Ranking <= 10
ORDER BY Report_Execution_Count DESC



