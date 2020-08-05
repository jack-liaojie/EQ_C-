IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPhaseCompetitorsList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetPhaseCompetitorsList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_GetPhaseCompetitorsList]
--描    述：得到一个Phase下参赛人员列表，主要为编辑最终结果服务
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年09月07日

CREATE PROCEDURE [dbo].[Proc_GetPhaseCompetitorsList](
				 @PhaseID			INT,
				 @RegisterID		INT,
                 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 
	
	CREATE TABLE #Table_Competitors(
									F_LongName			NVARCHAR(100),
									F_RegisterID		INT
									)

	DECLARE @EventID AS INT
	SELECT @EventID = F_EventID FROM TS_Phase WHERE F_PhaseID = @PhaseID

	DECLARE @PlayerRegTypeID AS INT
	SELECT @PlayerRegTypeID = F_PlayerRegTypeID FROM TS_Event WHERE F_EventID = @EventID 

	INSERT INTO #Table_Competitors (F_LongName, F_RegisterID)
		SELECT C.F_LongName, A.F_RegisterID FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
			LEFT JOIN TR_Register_Des AS C ON A.F_RegisterID = C.F_RegisterID
				WHERE A.F_EventID = @EventID AND B.F_RegTypeID = @PlayerRegTypeID AND C.F_LanguageCode = @LanguageCode

	DELETE FROM #Table_Competitors WHERE F_RegisterID IN (SELECT F_RegisterID FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID AND F_RegisterID <> @RegisterID)

	INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) VALUES ('NONE',-2)
	SELECT * FROM #Table_Competitors
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

