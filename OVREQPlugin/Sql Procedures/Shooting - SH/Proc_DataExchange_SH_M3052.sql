IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_SH_M3052]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_SH_M3052]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_DataExchange_SH_M3052]
----功		  能：阶段成绩（团体）
----作		  者：穆学峰
----日		  期: 2010-11-29 
----修改	记录:


CREATE PROCEDURE [dbo].[Proc_DataExchange_SH_M3052]
		@MatchID			INT,
		@LanguageCode		AS CHAR(3)
AS
BEGIN
	
SET NOCOUNT ON
	
	-- IF the match is NOT team match  then not send to INFO
	DECLARE @IS_TEAM_MATCH INT
	SELECT @IS_TEAM_MATCH = [dbo].[Func_SH_IsTeamMatch](@MatchID)
	
	IF (@IS_TEAM_MATCH = 0)
	RETURN	
	
	CREATE TABLE #TMP_Result(MatchID INT,
							Reg_ID INT,
							Reg_no VARCHAR(20),
							Total VARCHAR(20),
							[Rank] nvarchar(10), 
							Record VARCHAR(10),
							Record_Type VARCHAR(10),
							Qualification VARCHAR(10),
							[Order] INT)

	CREATE TABLE #TMP_Athlete(
							TeamID INT,
							RegisterID INT,
							Reg_no VARCHAR(20),
							Total_Score VARCHAR(20),
							Current_Rank nvarchar(10),
							[Order] INT)


	DECLARE @StatusID INT
	SELECT @StatusID = F_MatchStatusID
	FROM TS_Match WHERE F_MatchID = @MatchID
	
	IF @StatusID NOT IN( 50,100,110 ) RETURN

	DECLARE @TeamMatchId INT
	SELECT @TeamMatchId = @MatchID

	INSERT #TMP_Result(MatchID, Reg_ID, Reg_no, Total, [Rank], Record, Record_Type, Qualification, [Order])
	SELECT @MatchID, TeamID, TeamNO, Total, [Rank], Record, Record_Type, IRM_CODE ,
	RANK() OVER(ORDER BY [Rank])
	FROM dbo.[Func_SH_GetTeamResult] (@TeamMatchId)
										
	DECLARE @QualifyMatchID INT
	SELECT @QualifyMatchID = F_MatchId FROM dbo.Func_SH_GetTeamSourceMatchID(@TeamMatchId)

	DECLARE @PhaseID INT
	SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @QualifyMatchID
	
	DECLARE @PhaseCode nvarchar(10)
	SELECT @PhaseCode = F_PhaseCode FROM TS_Phase WHERE F_PhaseID = @PhaseID
	
	--IF @PhaseCode = '9'
	--BEGIN							
	--	INSERT #TMP_Athlete(TeamID, RegisterID, Reg_no, Total_Score, Current_Rank)
	--	SELECT TR.F_RegisterID, TM.F_MemberRegisterID, R.F_RegisterCode, PR.F_PhasePoints/10, PR.F_PhaseRank
	--	FROM TR_Register_Member AS TM
	--	LEFT JOIN TS_Match_Result AS TR ON TM.F_RegisterID = TR.F_RegisterID
	--	LEFT JOIN TS_Phase_Result AS PR ON PR.F_RegisterID = TM.F_MemberRegisterID
	--	LEFT JOIN TR_Register AS R ON R.F_RegisterID = TM.F_MemberRegisterID
	--	LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = R.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	--	LEFT JOIN TC_Delegation E ON E.F_DelegationID = R.F_DelegationID
	--	WHERE TR.F_MatchID = @TeamMatchId AND PR.F_PhaseID = @PhaseID
	--END

	IF @PhaseCode IN( 'A', '9' )
	BEGIN							
		INSERT #TMP_Athlete(TeamID, RegisterID, Reg_no, Total_Score, Current_Rank)
		SELECT TR.F_RegisterID, TM.F_MemberRegisterID, R.F_RegisterCode, PR.F_Points/10, PR.F_Rank
		FROM TR_Register_Member AS TM
		LEFT JOIN TS_Match_Result AS TR ON TM.F_RegisterID = TR.F_RegisterID
		LEFT JOIN TS_Match_Result AS PR ON PR.F_RegisterID = TM.F_MemberRegisterID
		LEFT JOIN TR_Register AS R ON R.F_RegisterID = TM.F_MemberRegisterID
		LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = R.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Delegation E ON E.F_DelegationID = R.F_DelegationID
		WHERE TR.F_MatchID = @TeamMatchId AND PR.F_MatchID IN (SELECT F_MatchID FROM dbo.Func_SH_GetTeamSourceMatchID(@MatchID))
	END
		
	UPDATE #TMP_Athlete 
	SET Current_Rank = NULL
	WHERE Current_Rank IN('998','999','0')
	
	UPDATE #TMP_Athlete SET Total_Score = Total_Score + '-' + CAST(B.F_RealScore as NVARCHAR(10)) + 'x' 
	FROM #TMP_Athlete AS A
	LEFT JOIN TS_Match_Result AS B ON A.RegisterID = B.F_RegisterID
	WHERE B.F_MatchID IN (SELECT F_MatchId FROM dbo.Func_SH_GetTeamSourceMatchID(@TeamMatchId))
	
	
	UPDATE #TMP_Result 
	SET [Rank] = NULL
	WHERE [Rank] IN('998','999','0')
			
	--test
	--select * from #TMP_Athlete
			
			
	DECLARE @COUNT INT
	SELECT @COUNT = COUNT(*) FROM #TMP_Athlete
	IF @COUNT <=0 RETURN
			
	SELECT @COUNT = COUNT(*) FROM #TMP_Result
	IF @COUNT <=0 RETURN
			
	DECLARE @OutputXML AS NVARCHAR(MAX)
	DECLARE @OutputHeader AS NVARCHAR(MAX)

	SET  @OutputHeader = (
	SELECT [Version],
	 Category,
	 Origin,
	 RSC,
	 Discipline,
	 Gender,
	 [Event],
	 [Phase],
	 [Unit],
	 [Venue],
	 [Code],
	 [Type],
	 [Language],
	 [Date],
	 [Time],
	 Team_Result.Reg_no Reg_ID,
	 Total,
	 ISNULL([Rank],'') Rank,
	 ISNULL(Record,'') Record,
	 ISNULL(Record_Type,'') Record_Type,
	 ISNULL(Qualification,'') Qualification,
	 Team_Result.[Order],
	 
	 Athlete.Reg_no Registration,
	 ISNULL(Total_Score, '') Total_Score,
	 ISNULL(Current_Rank, '') Current_Rank,
	 ROW_NUMBER() OVER(PARTITION BY Team_Result.Reg_ID ORDER BY Athlete.Total_Score DESC) [Order]
	 
	 FROM dbo.[Func_DataExchange_GetMessageHeader] ('SH', '1.0', 'VRS-001', 'M3052', @MatchID, 'ENG', 0) AS [Message]
	 LEFT JOIN #TMP_Result AS Team_Result ON Team_Result.MatchID = [Message].MatchID
	 LEFT JOIN #TMP_Athlete as Athlete ON Team_Result.Reg_ID = Athlete.TeamID
	 ORDER BY Team_Result.[Order]
	 FOR XML AUTO )
	
	 
	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>'
			+ @OutputHeader


	SELECT @OutputXML AS MessageXML
	

SET NOCOUNT OFF
END

GO

/*

EXEC [Proc_DataExchange_SH_M3052]  132, 'ENG'
EXEC [Proc_DataExchange_SH_M3052]  2190, 'ENG'

*/

 
