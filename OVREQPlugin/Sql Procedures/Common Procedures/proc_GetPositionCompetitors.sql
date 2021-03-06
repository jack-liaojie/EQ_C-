IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetPositionCompetitors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_GetPositionCompetitors]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：proc_GetPositionCompetitors
----功		  能：得到Phase中有位置的运动员
----作		  者：张翠霞
----日		  期: 2009-09-07

CREATE PROCEDURE [dbo].[proc_GetPositionCompetitors]
	@EventID				INT,
    @PhaseID                INT,
    @NodeType				INT,
    @LanguageCode           NVARCHAR(3)        
AS
BEGIN
	
SET NOCOUNT ON

    CREATE TABLE #table_PositionCompetitors(
                                     DrawNumber             INT,
                                     LongName               NVARCHAR(100),   
                                     Delegation			    NVARCHAR(10),
                                     RegisterCode			NVARCHAR(20),
                                     Seed					INT,
                                     InscriptionResult		NVARCHAR(100),
                                     InscriptionRank		INT,
                                     StartPhaseName         NVARCHAR(100),
                                     StartPhasePosition     INT,
                                     SourcePhaseName        NVARCHAR(100),
                                     SourcePhaseRank        INT,
                                     SourceMatchName        NVARCHAR(100),
                                     SourceMatchRank        INT,
                                     StartPhaseID           INT,
                                     SourcePhaseID          INT,
									 SourceMatchID          INT,
                                     RegisterID             INT,
                                     ItemID                 INT
                                     )

	IF @NodeType = -1
	BEGIN
		INSERT INTO #table_PositionCompetitors(DrawNumber, LongName, Delegation, RegisterCode, RegisterID, ItemID)
			   SELECT A.F_EventPosition, C.F_PrintLongName, D.F_DelegationCode, B.F_RegisterCode, A.F_RegisterID, A.F_ItemID
			   FROM TS_Event_Position AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TR_Register_Des AS C ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
			   LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
			   WHERE A.F_EventID = @EventID
	
		UPDATE #table_PositionCompetitors SET LongName = 'BYE' WHERE RegisterID = -1
			   
		UPDATE A SET A.Seed =B.F_Seed, A.InscriptionResult = B.F_InscriptionResult, A.InscriptionRank = B.F_InscriptionRank
			FROM #table_PositionCompetitors AS A LEFT JOIN TR_Inscription AS B 
				ON A.RegisterID = B.F_RegisterID AND B.F_EventID = @EventID
			
		SELECT DrawNumber, LongName, Delegation, RegisterCode, Seed, InscriptionResult, InscriptionRank, RegisterID, ItemID
			FROM #table_PositionCompetitors 
				ORDER BY (CASE WHEN DrawNumber IS NULL THEN 1 ELSE 0 END),DrawNumber
	END
	ELSE IF @NodeType = 0
	BEGIN
		INSERT INTO #table_PositionCompetitors(DrawNumber, LongName, Delegation, RegisterCode, StartPhaseID, StartPhasePosition, SourcePhaseID, SourcePhaseRank, SourceMatchID, SourceMatchRank, RegisterID, ItemID)
			   SELECT A.F_PhasePosition, C.F_PrintLongName, D.F_DelegationCode, B.F_RegisterCode, A.F_StartPhaseID, A.F_StartPhasePosition, A.F_SourcePhaseID, A.F_SourcePhaseRank, A.F_SourceMatchID, A.F_SourceMatchRank, A.F_RegisterID, A.F_ItemID
			   FROM TS_Phase_Position AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TR_Register_Des AS C ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
			   LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
			   WHERE A.F_PhaseID = @PhaseID

		UPDATE #table_PositionCompetitors SET LongName = 'BYE' WHERE RegisterID = -1
	    
		UPDATE #table_PositionCompetitors SET StartPhaseName = F_PhaseLongName FROM TS_Phase_Des AS B WHERE StartPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
		UPDATE #table_PositionCompetitors SET SourcePhaseName = F_PhaseLongName FROM TS_Phase_Des AS B WHERE SourcePhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
		UPDATE #table_PositionCompetitors SET SourceMatchName = F_MatchLongName FROM TS_Match_Des AS B WHERE SourceMatchID = B.F_MatchID AND B.F_LanguageCode = @LanguageCode
		
		UPDATE A SET A.Seed =B.F_Seed, A.InscriptionResult = B.F_InscriptionResult, A.InscriptionRank = B.F_InscriptionRank
			FROM #table_PositionCompetitors AS A LEFT JOIN TR_Inscription AS B 
				ON A.RegisterID = B.F_RegisterID AND B.F_EventID = @EventID
			
		SELECT * FROM #table_PositionCompetitors 
			ORDER BY (CASE WHEN DrawNumber IS NULL THEN 1 ELSE 0 END),DrawNumber
	END



SET NOCOUNT OFF
END

set QUOTED_IDENTIFIER OFF
SET ANSI_NULLS OFF

GO