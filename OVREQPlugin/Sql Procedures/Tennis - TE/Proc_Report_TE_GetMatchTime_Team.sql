IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetMatchTime_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetMatchTime_Team]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_Report_TE_GetMatchTime_Team]
----功		  能：得到一场比赛的详细成绩信息,网球项目
----作		  者：郑金勇 
----日		  期: 2009-08-12

CREATE PROCEDURE [dbo].[Proc_Report_TE_GetMatchTime_Team] (	
	@MatchID					INT,
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
SET NOCOUNT ON


	SELECT F_MatchID, F_FatherMatchSplitID AS F_MatchSplitID, NULL AS Total, Set1, Set2, Set3, Set4, Set5 INTO #Temp_Table FROM
			(SELECT F_MatchID, F_FatherMatchSplitID, 'Set' + CAST(F_MatchSplitCode AS NVARCHAR(10)) AS F_SetPoints, F_SpendTime FROM TS_Match_Split_Info 
				WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID IN 
				(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0)
			) AS A
			PIVOT (MIN(F_SpendTime) FOR F_SetPoints IN (Set1, Set2, Set3, Set4, Set5)) AS B
			
	 
	UPDATE A SET A.Total = B.F_SpendTime FROM #Temp_Table AS A LEFT JOIN TS_Match_Split_Info AS B 
		ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
	
	UPDATE #Temp_Table SET Set1 = NULL WHERE Set1 = 0
	UPDATE #Temp_Table SET Set2 = NULL WHERE Set2 = 0
	UPDATE #Temp_Table SET Set3 = NULL WHERE Set3 = 0
	UPDATE #Temp_Table SET Set4 = NULL WHERE Set4 = 0
	UPDATE #Temp_Table SET Set5 = NULL WHERE Set5 = 0
	
	DECLARE @hourDes AS NVARCHAR(10)
	DECLARE @MinuteDes AS NVARCHAR(10)
	IF @LanguageCode = 'CHN'
	BEGIN
		SET @hourDes = '小时'
		SET @MinuteDes = '分钟'
	END
	ELSE IF @LanguageCode = 'ENG'
	BEGIN
		SET @hourDes = 'h'
		SET @MinuteDes = 'min'
	END				
	SELECT F_MatchID, F_MatchSplitID, CASE WHEN Total >= 3600 THEN CAST(Total/3600 AS NVARCHAR(50))+@hourDes+CAST((Total % 3600 )/60 AS NVARCHAR(50))+@MinuteDes ELSE CAST((Total % 3600 )/60 AS NVARCHAR(50))+@MinuteDes END AS Total 
			, CASE WHEN Set1 >= 3600 THEN CAST(Set1/3600 AS NVARCHAR(50))+@hourDes+CAST((Set1 % 3600 )/60 AS NVARCHAR(50))+@MinuteDes ELSE CAST((Set1 % 3600 )/60 AS NVARCHAR(50))+@MinuteDes END AS Set1
			, CASE WHEN Set2 >= 3600 THEN CAST(Set2/3600 AS NVARCHAR(50))+@hourDes+CAST((Set2 % 3600 )/60 AS NVARCHAR(50))+@MinuteDes ELSE CAST((Set2 % 3600 )/60 AS NVARCHAR(50))+@MinuteDes END AS Set2
			, CASE WHEN Set3 >= 3600 THEN CAST(Set3/3600 AS NVARCHAR(50))+@hourDes+CAST((Set3 % 3600 )/60 AS NVARCHAR(50))+@MinuteDes ELSE CAST((Set3 % 3600 )/60 AS NVARCHAR(50))+@MinuteDes END AS Set3
			, CASE WHEN Set4 >= 3600 THEN CAST(Set4/3600 AS NVARCHAR(50))+@hourDes+CAST((Set4 % 3600 )/60 AS NVARCHAR(50))+@MinuteDes ELSE CAST((Set4 % 3600 )/60 AS NVARCHAR(50))+@MinuteDes END AS Set4
			, CASE WHEN Set5 >= 3600 THEN CAST(Set5/3600 AS NVARCHAR(50))+@hourDes+CAST((Set5 % 3600 )/60 AS NVARCHAR(50))+@MinuteDes ELSE CAST((Set5 % 3600 )/60 AS NVARCHAR(50))+@MinuteDes END AS Set5 FROM #Temp_Table
	
SET NOCOUNT OFF
END
GO



--EXEC Proc_Report_TE_GetMatchTime_Team 284, 'CHN'

