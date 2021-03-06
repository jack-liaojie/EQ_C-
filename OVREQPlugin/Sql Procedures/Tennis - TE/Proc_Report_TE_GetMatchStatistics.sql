IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetMatchStatistics]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetMatchStatistics]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称: [Proc_Report_TE_GetMatchStatistics]
--描    述: 网球比赛的技术统计
--参数说明: 
--说    明: 
--创 建 人: 郑金勇
--日    期: 2010年10月14日

Create Procedure [dbo].[Proc_Report_TE_GetMatchStatistics](
	@MatchID		INT,
	@Type			INT, --1表示是Single、2表示是Double
	@LanguageCode	CHAR(3)
)
As
Begin
Set Nocount On 

	create table #temp_MatchSta(
					StaId		int,
					StaOrder	smallint,
					StaName		nvarchar(50),
					StaCode     nvarchar(50),
					H_1			nvarchar(50),
					H_2			nvarchar(50),
					H_3			nvarchar(50),
					H_4			nvarchar(50),
					H_5			nvarchar(50),
					H_Total		nvarchar(50),
					A_1			nvarchar(50),
					A_2			nvarchar(50),
					A_3			nvarchar(50),
					A_4			nvarchar(50),
					A_5			nvarchar(50),
					A_Total		nvarchar(50)
				)

	
	--INSERT INTO #temp_MatchSta EXEC [Proc_TE_GetMatchStatistics] @MatchID, @LanguageCode
	
	CREATE TABLE #TempStaOut(F_Order	INT IDENTITY(1,1),
							 StaId		INT,
					    	 GroupID	INT)
					    	 
	IF @Type = 1
	BEGIN
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (2, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (4, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (26, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (5, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (21, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (22, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (7, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (23, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (24, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (10, 1)
		
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (27, 2)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (28, 2)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (18, 2)

		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (29, 3)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (30, 3)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (31, 3)
		
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (20, 4)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (12, 4)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (13, 4)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (32, 4)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (33, 4)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (34, 4)
	END
	ELSE IF @Type = 2
	BEGIN
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (2, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (4, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (26, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (5, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (21, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (22, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (7, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (23, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (24, 1)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (10, 1)
		
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (27, 2)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (28, 2)
		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (18, 2)


		INSERT INTO #TempStaOut(StaId, GroupID) VALUES (20, 4)

	END
	
	INSERT INTO #temp_MatchSta (StaId)
	   SELECT StaID FROM #TempStaOut 
	   
	UPDATE #temp_MatchSta SET StaName = C.F_StatisticLongName, StaCode = B.F_StatisticCode	
	   FROM #temp_MatchSta AS A LEFT JOIN TD_Statistic AS B ON A.StaID = B.F_StatisticID
	        LEFT JOIN TD_Statistic_Des AS C ON B.F_StatisticID = C.F_StatisticID AND C.F_LanguageCode = @LanguageCode  
	        
	UPDATE #temp_MatchSta SET H_1 = dbo.Fun_TE_GetMatchStatistic(@MatchID,1,1,StaCode)
	                        ,H_2 = dbo.Fun_Te_GetMatchStatistic(@MatchID,2,1,StaCode)
	                        ,H_3 = dbo.Fun_TE_GetMatchStatistic(@MatchID,3,1,StaCode)
	                        ,H_4 = dbo.Fun_Te_GetMatchStatistic(@MatchID,4,1,StaCode)
	                        ,H_5 = dbo.Fun_Te_GetMatchStatistic(@MatchID,5,1,StaCode)
	                        ,H_Total = dbo.Fun_Te_GetMatchStatistic(@MatchID,0,1,StaCode)
	                        ,A_1 = dbo.Fun_TE_GetMatchStatistic(@MatchID,1,2,StaCode)
	                        ,A_2 = dbo.Fun_Te_GetMatchStatistic(@MatchID,2,2,StaCode)
	                        ,A_3 = dbo.Fun_TE_GetMatchStatistic(@MatchID,3,2,StaCode)
	                        ,A_4 = dbo.Fun_Te_GetMatchStatistic(@MatchID,4,2,StaCode)
	                        ,A_5 = dbo.Fun_Te_GetMatchStatistic(@MatchID,5,2,StaCode)
	                        ,A_Total = dbo.Fun_Te_GetMatchStatistic(@MatchID,0,2,StaCode)
	 
	 	BEGIN--进行无效的Set的内容的置空处理
		CREATE TABLE #TempValidSets(F_Set	INT)
		INSERT INTO #TempValidSets (F_Set) VALUES (1)
		INSERT INTO #TempValidSets (F_Set) VALUES (2)
		INSERT INTO #TempValidSets (F_Set) VALUES (3)
		INSERT INTO #TempValidSets (F_Set) VALUES (4)
		INSERT INTO #TempValidSets (F_Set) VALUES (5)
		
		DELETE FROM #TempValidSets WHERE F_Set IN (SELECT F_MatchSplitCode FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND ( F_MatchSplitStatusID IS NOT NULL OR F_MatchSplitStatusID <> 0))
		DECLARE @StrSQL  NVARCHAR(500)
		SET @StrSQL = ''
		SELECT @StrSQL = @StrSQL + ' UPDATE #temp_MatchSta SET H_' + CAST (F_Set AS NVARCHAR(10)) +' = NULL, A_' + CAST (F_Set AS NVARCHAR(10)) +' = NULL' FROM #TempValidSets
		EXEC (@StrSQL)
	END                       
	
	SELECT A.F_Order, A.GroupID, B.* FROM #TempStaOut AS A LEFT JOIN #temp_MatchSta AS B ON A.StaId = B.StaId


Set Nocount Off
End 




