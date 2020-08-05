IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetTeamResult]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetTeamResult]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

----author£ºMU XUEFENG
----date: 2010-12-22 
----modifed by:


CREATE FUNCTION [Func_SH_GetTeamResult]
(
		@MatchID			INT --TEAM'S matchid
)
RETURNS @retTable TABLE	(
							TeamID		INT PRIMARY KEY NOT NULL,
							TeamNO		NVARCHAR(50),
							NOC			NVARCHAR(50),
							NOC_DES		NVARCHAR(100),
							Total		NVARCHAR(50),
							Display_Rank VARCHAR(50),
							[RANK]		INT,
							Record		VARCHAR(50),--y/n
							Record_Type VARCHAR(50),
							IRM_CODE	VARCHAR(50)
							)
AS
BEGIN

	DECLARE @TT TABLE(F_TeamID INT, F_RealScore INT, F_S12 INT, F_S11 INT, F_S10 INT, F_S9 INT, F_S8 INT, F_S7 INT
	, F_S6 INT, F_S5 INT, F_S4 INT, F_S3 INT, F_S2 INT, F_S1 INT)
	
	DECLARE @RegType NVARCHAR(10)
	SELECT @RegType = RegType FROM DBO.Func_SH_GetEventCommonCodeInfo(@MatchID)
	
	IF ( @RegType <> 3 )
	RETURN
	
	
	--Get qualificaiton's matchid, because the team result according to qualificaiton's result
	DECLARE @SourceMatchID INT
	DECLARE @PhaseID INT

	SELECT  @SourceMatchID = F_MatchID FROM DBO.Func_SH_GetTeamSourceMatchID(@MatchID)
	SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @SourceMatchID
	
	DECLARE @PhaseCode NVARCHAR(10)
	SELECT @PhaseCode = F_PhaseCode FROM TS_Phase WHERE F_PhaseID = @PhaseID

	IF @PhaseCode = 'A'	--50M, from ellimination match, others from qualification match
	BEGIN
	INSERT @retTable(TeamID, NOC, Total)
		SELECT TR.F_RegisterID, E.F_DelegationCode, SUM(ISNULL(PR.F_Points,0))/10
		FROM TR_Register_Member AS TM
		LEFT JOIN TS_Match_Result AS TR ON TM.F_RegisterID = TR.F_RegisterID
		LEFT JOIN TS_Match_Result AS PR ON PR.F_RegisterID = TM.F_MemberRegisterID
		LEFT JOIN TR_Register AS R ON R.F_RegisterID = TM.F_MemberRegisterID
		LEFT JOIN TC_Delegation E ON E.F_DelegationID = R.F_DelegationID
		WHERE TR.F_MatchID = @MatchID AND PR.F_MatchID IN (SELECT F_MatchID FROM DBO.Func_SH_GetTeamSourceMatchID(@MatchID))
		GROUP BY TR.F_RegisterID, E.F_DelegationCode
	END
	ELSE
	BEGIN
		INSERT @retTable(TeamID, NOC, Total)
		SELECT TR.F_RegisterID, E.F_DelegationCode, SUM(PR.F_PhasePoints)/10
		FROM TR_Register_Member AS TM
		LEFT JOIN TS_Match_Result AS TR ON TM.F_RegisterID = TR.F_RegisterID
		LEFT JOIN TS_Phase_Result AS PR ON PR.F_RegisterID = TM.F_MemberRegisterID
		LEFT JOIN TR_Register AS R ON R.F_RegisterID = TM.F_MemberRegisterID
		LEFT JOIN TC_Delegation E ON E.F_DelegationID = R.F_DelegationID
		WHERE TR.F_MatchID = @MatchID AND PR.F_PhaseID = @PhaseID
		GROUP BY TR.F_RegisterID, E.F_DelegationCode
	END	
		
	UPDATE @retTable
	SET TeamNO = B.F_RegisterCode FROM @retTable A
	LEFT JOIN TR_Register B ON A.TeamID = B.F_RegisterID
	
	UPDATE @retTable
	SET IRM_CODE = C.F_IRMCODE, NOC_DES = D.F_CountryLongName
	FROM @retTable A
	LEFT JOIN TS_Match_Result B ON A.TeamID = B.F_RegisterID
	LEFT JOIN TC_IRM C ON C.F_IRMID = B.F_IRMID
	LEFT JOIN TC_Country_Des D ON D.F_NOC = A.NOC AND D.F_LanguageCode = 'ENG'
	WHERE B.F_MatchID = @MatchID


	--IF @EventCode = '006' -- 25m rapid
	--BEGIN
	--	INSERT INTO @TT(F_TeamID, F_RealScore)
	--	SELECT TR.F_RegisterID, CAST(SUM(PR.F_RealScore) AS NVARCHAR(10))AS XX
	--	FROM TR_Register_Member AS TM
	--	LEFT JOIN TS_Match_Result AS TR ON TM.F_RegisterID = TR.F_RegisterID
	--	LEFT JOIN TS_Match_Result AS PR ON PR.F_RegisterID = TM.F_MemberRegisterID
	--	LEFT JOIN TS_Match AS M ON M.F_MatchID = PR.F_MatchID
	--	LEFT JOIN TR_Register AS R ON R.F_RegisterID = TM.F_MemberRegisterID
	--	WHERE TR.F_MatchID = @MatchID AND PR.F_MatchID IN (SELECT  F_MatchID FROM DBO.Func_SH_GetTeamSourceMatchID(@MatchID))
	--		AND M.F_MatchCode = '02'
	--	GROUP BY TR.F_RegisterID
	--END
	--ELSE
	--BEGIN
	--	INSERT INTO @TT(F_TeamID, F_RealScore)
	--	SELECT TR.F_RegisterID, CAST(SUM(PR.F_RealScore) AS NVARCHAR(10))AS XX
	--	FROM TR_Register_Member AS TM
	--	LEFT JOIN TS_Match_Result AS TR ON TM.F_RegisterID = TR.F_RegisterID
	--	LEFT JOIN TS_Match_Result AS PR ON PR.F_RegisterID = TM.F_MemberRegisterID
	--	LEFT JOIN TR_Register AS R ON R.F_RegisterID = TM.F_MemberRegisterID
	--	WHERE TR.F_MatchID = @MatchID AND PR.F_MatchID IN (SELECT  F_MatchID FROM DBO.Func_SH_GetTeamSourceMatchID(@MatchID))
	--	GROUP BY TR.F_RegisterID
	--END		


	INSERT INTO @TT(F_TeamID, F_RealScore, F_S12, F_S11, F_S10, F_S9, F_S8, F_S7, F_S6, F_S5, F_S4, F_S3, F_S2, F_S1)
	SELECT REG_ID, sx, S12, S11, S10, S9, S7, S8, S6, S5, S4, S3, S2, S1
	FROM Func_SH_GetTeamDetailResult(@MatchID)


	
	--SELECT * FROM @TT
	-- set 'N', First

	UPDATE A
	SET Display_Rank = B.t, 
	[RANK] = B.t,
	Record = 'N' 
	FROM @retTable AS A
	RIGHT JOIN (
		SELECT TeamID, RANK() OVER (ORDER BY CAST(Total AS INT) Desc, 
		XB.F_RealScore DESC,
		XB.F_S12 DESC,
		XB.F_S11 DESC,
		XB.F_S10 DESC,
		XB.F_S9 DESC,
		XB.F_S8 DESC,
		XB.F_S7 DESC,
		XB.F_S6 DESC,
		XB.F_S5 DESC,
		XB.F_S4 DESC,
		XB.F_S3 DESC,
		XB.F_S2 DESC,
		XB.F_S1 DESC) t 
		FROM @retTable AS XA
		LEFT JOIN @TT AS XB ON XA.TeamID = XB.F_TeamID
		WHERE XA.IRM_CODE  NOT IN('DSQ') OR XA.IRM_CODE IS NULL
	 ) AS B ON A.TeamID = B.TeamID

	UPDATE A
	SET [Rank] = R.F_Rank
	FROM @retTable AS A
	LEFT JOIN TS_Match_Result AS R ON A.TeamID = R.F_RegisterID
	WHERE R.F_MatchID = @MatchID
		
		
	--UPDATE A
	--SET Display_Rank = B.F_Rank, 
	--[RANK] = B.F_Rank,
	--Record = 'N' 
	--FROM @retTable AS A
	--LEFT JOIN (SELECT * FROM Func_SH_GetTeamDetailResult(@MatchID)) AS B ON A.TeamID = B.REG_ID
--	WHERE A.IRM_CODE  NOT IN('DSQ') OR A.IRM_CODE IS NULL
	


	UPDATE A SET Total = A.Total + '-' + ISNULL(cast(B.F_RealScore as nvarchar(10)),'0')  + 'x' 
	FROM @retTable AS A
	LEFT JOIN @TT AS B ON A.TeamID = B.F_TeamID

	--
		
	RETURN
	
END

GO

/*

SELECT * FROM dbo.[Func_SH_GetTeamResult] (347) order by rank

*/

