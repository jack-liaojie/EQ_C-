IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_GetInscriptionInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_GetInscriptionInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_AR_GetInscriptionInfo]
--描    述：根据查询条件查询符合的运动员列表，用于抽签
--参数说明： 
--说    明：
--创 建 人：崔凯
--日    期：2009年05月30日
--修改记录：
/*			
			时间				修改人		修改内容
*/

CREATE PROCEDURE [dbo].[Proc_AR_GetInscriptionInfo](
				 @DisciplineID		INT, 
				 @EventID			INT,
				 @GroupID			INT,
				 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON  
	--SET @RegTypeID = 1
	CREATE TABLE #Temp_Table(
								F_RegisterID		INT,
								F_RegTypeID			INT,
								F_SexCode			INT,
								F_DelegationID		INT,
								F_Bib				NVARCHAR(20),
								F_InscriptionResult				NVARCHAR(20),
								F_InscriptionRank				NVARCHAR(20),
								F_EventID			INT,
								F_Seed				INT,
								F_PhaseID			INT,
								F_MatchID			INT,
								F_CompetitionPosition	INT,
								F_Rank				INT,
								F_Target			NVARCHAR(20)
				)
	INSERT INTO #Temp_Table (F_RegisterID, F_RegTypeID, F_SexCode, F_DelegationID, 
				F_Bib,F_InscriptionResult,F_EventID,F_Seed,F_InscriptionRank,F_PhaseID,F_Target,F_MatchID,F_CompetitionPosition,F_Rank)
			SELECT I.F_RegisterID, R.F_RegTypeID, R.F_SexCode, R.F_DelegationID, 
					I.F_InscriptionRank,I.F_InscriptionResult,I.F_EventID,I.F_Seed,i.F_InscriptionRank,
					P.F_PhaseID,MR.F_Comment,MR.F_MatchID,MR.F_CompetitionPosition,MR.F_Rank
			FROM TS_Match_Result AS MR
			INNER JOIN TR_Inscription AS I ON I.F_RegisterID = MR.F_RegisterID
			INNER JOIN TR_Register AS R ON R.F_RegisterID = I.F_RegisterID 
			INNER JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
			INNER JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID 
			 WHERE R.F_DisciplineID = @DisciplineID


	IF (@EventID != -1)
	BEGIN
		DELETE FROM #Temp_Table WHERE F_EventID <> @EventID 
	END
	
	IF (@GroupID != -1)
	BEGIN
		DELETE FROM #Temp_Table WHERE (F_PhaseID != @GroupID OR F_PhaseID IS NULL)
	END
	
	SELECT 
		row_number() over(order by A.F_MatchID,A.F_CompetitionPosition) AS [Order]
		,ED.F_EventLongName +PD.F_PhaseShortName AS [Event]
		,CASE WHEN A.F_RegTypeID = 1 THEN CAST(G.F_Rank AS NVARCHAR) 
			  WHEN A.F_RegTypeID = 3 THEN CAST(A.F_InscriptionRank AS NVARCHAR) END AS [QRank]
		, A.F_Target AS [Target]
		, C.F_LongName AS [Long Name]
		, A.F_Bib AS [BackNo] 
        , A.F_InscriptionResult AS [QRResult] 
		, E.F_SexLongName AS [Sex]  
		, D.F_DelegationLongName AS [Delegation] 
        , A.F_RegisterID AS [RegisterID]
        , A.F_EventID AS [EventID]
        , A.F_PhaseID AS [GroupID]
        , A.F_MatchID AS MatchID 
        , A.F_CompetitionPosition AS Position
		, A.F_Rank AS [Rank]
	FROM #Temp_Table AS A 
	LEFT JOIN TR_Register AS B 
		ON A.F_RegisterID = B.F_RegisterID 
	INNER JOIN TS_Event_Des AS ED ON ED.F_EventID = A.F_EventID AND ED.F_LanguageCode = @LanguageCode
	INNER JOIN TS_Phase_Des AS PD ON PD.F_PhaseID = A.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register_Des AS C 
		ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation_Des AS D 
		ON A.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Sex_Des AS E 
		ON A.F_SexCode = E.F_SexCode AND E.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_RegType_Des AS F 
		ON A.F_RegTypeID = F.F_RegTypeID AND F.F_LanguageCode = @LanguageCode
	LEFT JOIN ( SELECT F_RegisterID,F_Rank,P.F_EventID,F_Comment FROM TS_Match_Result AS MR 
					LEFT JOIN TS_Match AS M 
						ON M.F_MatchID = MR.F_MatchID AND M.F_MatchCode = 'QR'
					LEFT JOIN TS_Phase AS P 
						ON M.F_PhaseID = P.F_PhaseID AND P.F_PhaseCode IN ('A','B','C','D')
			 ) AS G ON A.F_RegisterID = G.F_RegisterID AND G.F_EventID = A.F_EventID

	drop table #Temp_Table
     
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



GO

/*
exec Proc_AR_GetInscriptionInfo 1,1,2,'CHN'
*/
