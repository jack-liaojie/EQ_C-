IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetAvailbleCompetitorsForPhase]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_GetAvailbleCompetitorsForPhase]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：proc_GetAvailbleCompetitorsForPhase
----功		  能：得到当前阶段可选择的队员
----作		  者：张翠霞
----日		  期: 2009-09-07
----修        改：2011-01-17 修改小组赛阶段，可选择队伍不能多组出现。

CREATE PROCEDURE [dbo].[proc_GetAvailbleCompetitorsForPhase]
	@EventID			    INT,
    @PhaseID                INT,
    @NodeType				INT,
    @LanguageCode           NVARCHAR(3)        
AS
BEGIN
	
SET NOCOUNT ON

    CREATE TABLE #table_avaibleCompetitors(
                                     F_RegisterID			INT,
                                     F_LongName				NVARCHAR(100),   
                                     F_DelegationCode		NVARCHAR(10),
                                     F_RegisterCode			NVARCHAR(20),
                                     F_Seed					INT,
                                     F_InscriptionResult	NVARCHAR(100),
                                     F_InscriptionRank		INT
                                     )
                                     
    DECLARE @PhaseType AS INT
    DECLARE @FatherPhaseID AS INT
    
    SELECT @PhaseType = F_PhaseType, @FatherPhaseID = F_FatherPhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID

	IF @NodeType = -1
	BEGIN
		INSERT INTO #table_avaibleCompetitors(F_RegisterID, F_LongName, F_DelegationCode, F_RegisterCode, F_Seed, F_InscriptionResult, F_InscriptionRank)
			   SELECT B.F_RegisterID, C.F_PrintLongName, D.F_DelegationCode, B.F_RegisterCode, A.F_Seed, A.F_InscriptionResult, A.F_InscriptionRank
			   FROM TR_Inscription AS A
			   LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
			   LEFT JOIN TR_Register_Des AS C ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
			   LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
			   WHERE A.F_EventID = @EventID AND A.F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Event_Competitors WHERE F_EventID = @EventID) AND B.F_RegTypeID IN (1, 2, 3)
	END
	ELSE IF @NodeType = 0
	BEGIN
		INSERT INTO #table_avaibleCompetitors(F_RegisterID, F_LongName, F_DelegationCode, F_RegisterCode, F_Seed, F_InscriptionResult, F_InscriptionRank)
			   SELECT B.F_RegisterID, C.F_PrintLongName, D.F_DelegationCode, B.F_RegisterCode, A.F_Seed, A.F_InscriptionResult, A.F_InscriptionRank
			   FROM TR_Inscription AS A
			   LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
			   LEFT JOIN TR_Register_Des AS C ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
			   LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
			   WHERE A.F_EventID = @EventID AND A.F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Phase_Competitors WHERE F_PhaseID = @PhaseID) AND B.F_RegTypeID IN (1, 2, 3)
			   
	    IF @PhaseType = 2
	    BEGIN
	        DELETE FROM #table_avaibleCompetitors WHERE F_RegisterID IN (SELECT F_RegisterID FROM TS_Phase_Competitors AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE B.F_FatherPhaseID = @FatherPhaseID AND B.F_EventID = @EventID)
	    END
	END
	
    SELECT F_LongName AS LongName
			, F_DelegationCode AS Delegation
			, F_RegisterCode AS RegisterCode
			, F_Seed AS Seed
			, F_InscriptionResult AS InscriptionResult
			, F_InscriptionRank AS InscriptionRank
			, F_RegisterID AS RegisterID 
		FROM #table_avaibleCompetitors

SET NOCOUNT OFF
END

GO



