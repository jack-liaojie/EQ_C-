
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetMatchStartList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetMatchStartList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Proc_Report_SH_GetMatchStartList] (	
	@MatchID					INT,
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #TMP(	
						COMPETITION_POS INT,
						Relay NVARCHAR(10),
						FP NVARCHAR(10),
						Bay NVARCHAR(10),
						RegisterID INT,
						StartTime NVARCHAR(10),
						BIB NVARCHAR(50),
						Name NVARCHAR(50),
						NOC NVARCHAR(10),
						DOB NVARCHAR(50),
						IRM NVARCHAR(10),
						StartTime2 NVARCHAR(10)
						
	)

	DECLARE @EventCode NVARCHAR(10)
	DECLARE @PhaseCode NVARCHAR(10)
	DECLARE @MatchCode NVARCHAR(10)
	SELECT @EventCode = Event_Code,
			 @PhaseCode = PHASE_CODE,
			 @MatchCode = Match_Code 
		FROM  dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)

	IF @EventCode = '005'
	BEGIN
		INSERT INTO #TMP(COMPETITION_POS, RegisterID, FP, BAY, Relay, BIB, NAME, NOC, DOB, IRM, StartTime2)
		SELECT A.F_CompetitionPosition, A.F_RegisterID,	 F_CompetitionPositionDes1,  [dbo].[Func_SH_GetBay](F_CompetitionPositionDes1), 
		F_CompetitionPositionDes2, F_Bib, F_PrintLongName, D.F_DelegationCode, dbo.Func_SH_GetChineseDate(E.F_Birth_Date), F_IRMCODE, F_StartTimeCharDes
		FROM TS_Match_Result A
		LEFT JOIN TR_Register AS E ON E.F_RegisterID = A.F_RegisterID
		LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Delegation D ON D.F_DelegationID = E.F_DelegationID
		LEFT JOIN TC_IRM AS I ON I.F_IRMID = A.F_IRMID
		WHERE F_MatchID = @MatchID 
	END
	ELSE
	BEGIN
		INSERT INTO #TMP(COMPETITION_POS, RegisterID, FP, BAY, Relay, BIB, NAME, NOC, DOB, IRM, StartTime2)
		SELECT A.F_CompetitionPosition, A.F_RegisterID,	 F_CompetitionPositionDes1,  F_CompetitionPositionDes1, 
		F_CompetitionPositionDes2, F_Bib, F_PrintLongName, D.F_DelegationCode, dbo.Func_SH_GetChineseDate(E.F_Birth_Date), F_IRMCODE, F_StartTimeCharDes
		FROM TS_Match_Result A
		LEFT JOIN TR_Register AS E ON E.F_RegisterID = A.F_RegisterID
		LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Delegation D ON D.F_DelegationID = E.F_DelegationID
		LEFT JOIN TC_IRM AS I ON I.F_IRMID = A.F_IRMID
		WHERE F_MatchID = @MatchID 
	END
	
	IF @EventCode IN ( '005', '105')
	BEGIN
		SELECT * FROM #TMP ORDER BY CAST(Relay AS INT), CAST(FP AS INT)
	END
	ELSE IF @EventCode IN ( '007')
	BEGIN
		SELECT * FROM #TMP ORDER BY CAST(Relay AS INT), CAST(FP AS INT)
	END
	ELSE
	BEGIN
		SELECT * FROM #TMP ORDER BY CAST(FP AS INT)
	END
SET NOCOUNT OFF
END

GO


-- EXEC Proc_Report_SH_GetMatchStartList 4,'ENG'
-- EXEC Proc_Report_SH_GetMatchStartList 1,'ENG'

