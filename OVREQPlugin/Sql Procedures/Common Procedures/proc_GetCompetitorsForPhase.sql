IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetCompetitorsForPhase]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_GetCompetitorsForPhase]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：proc_GetCompetitorsForPhase
----功		  能：得到当前阶段已选择的队员
----作		  者：张翠霞
----日		  期: 2009-09-07

CREATE PROCEDURE [dbo].[proc_GetCompetitorsForPhase]
	@EventID			    INT,
    @PhaseID                INT,
    @NodeType				INT,
    @LanguageCode           NVARCHAR(3)        
AS
BEGIN
	
SET NOCOUNT ON

    CREATE TABLE #table_Competitors(
                                     F_RegisterID			INT,
                                     F_LongName				NVARCHAR(100),   
                                     F_DelegationCode		NVARCHAR(10),
                                     F_RegisterCode			NVARCHAR(20),
                                     F_Seed					INT,
                                     F_InscriptionResult	NVARCHAR(100),
                                     F_InscriptionRank		INT
                                     )

	IF @NodeType = -1
	BEGIN
		INSERT INTO #table_Competitors(F_RegisterID, F_LongName, F_DelegationCode, F_RegisterCode)
		   SELECT B.F_RegisterID, C.F_PrintLongName, D.F_DelegationCode, B.F_RegisterCode
		   FROM TS_Event_Competitors AS A
		   LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
		   LEFT JOIN TR_Register_Des AS C ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
		   LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
		   WHERE A.F_EventID = @EventID
	END
	ELSE IF @NodeType = 0
	BEGIN
		INSERT INTO #table_Competitors(F_RegisterID, F_LongName, F_DelegationCode, F_RegisterCode)
		   SELECT B.F_RegisterID, C.F_PrintLongName, D.F_DelegationCode, B.F_RegisterCode
		   FROM TS_Phase_Competitors AS A
		   LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
		   LEFT JOIN TR_Register_Des AS C ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
		   LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
		   WHERE A.F_PhaseID = @PhaseID
	END
	UPDATE A SET A.F_Seed =B.F_Seed, A.F_InscriptionResult = B.F_InscriptionResult, A.F_InscriptionRank = B.F_InscriptionRank
		FROM #table_Competitors AS A LEFT JOIN TR_Inscription AS B 
			ON A.F_RegisterID = B.F_RegisterID AND B.F_EventID = @EventID
				
    SELECT F_LongName AS LongName
		, F_DelegationCode AS Delegation
		, F_RegisterCode AS RegisterCode
		, F_Seed AS Seed
		, F_InscriptionResult AS InscriptionResult
		, F_InscriptionRank AS InscriptionRank
		, F_RegisterID AS RegisterID 
    FROM #table_Competitors

SET NOCOUNT OFF
END

set QUOTED_IDENTIFIER OFF
SET ANSI_NULLS OFF

GO

