IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DrawDisplay_GetResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DrawDisplay_GetResults]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_DrawDisplay_GetResults]
--描    述：得到一个Phase里面的所有结果
--参数说明： 
--说    明：
--创 建 人：吴定昉
--日    期：2009年04月21日

CREATE PROCEDURE [dbo].[Proc_DrawDisplay_GetResults](
				 @PhaseID			INT,--对应类型的ID，与Type相关
				 @PhaseType			INT,--注释: 3表示淘汰，2表示小组循环
                 @PhaseSize         INT,--注释：主要用于处理过滤淘汰中的排名赛
                 @LanguageCode  char(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #table_Results (
								F_PhaseID				INT,
                                F_DisplayPosition		INT,
                                F_Rank					INT,
								F_RegisterID			INT,
								F_RegisterName			NVARCHAR(100),
								F_Points				INT,
								F_IRM					INT
							 )
	INSERT INTO #table_Results (F_PhaseID, F_DisplayPosition, F_Rank, F_RegisterID, F_RegisterName, F_Points, F_IRM)
		SELECT  A.F_PhaseID, A.F_PhaseDisplayPosition, A.F_PhaseRank, A.F_RegisterID, B.F_LongName, A.F_PhasePoints, NULL
			FROM TS_Phase_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_Languagecode = @LanguageCode 
				WHERE A.F_PhaseID = @PhaseID 
		
	
	SELECT F_PhaseID, F_DisplayPosition, F_Rank, F_RegisterID, F_RegisterName, F_Points, F_IRM,
		DBO.Fun_GetCompetitorInGroupResult(F_PhaseID, F_RegisterID, 1) AS Win, 
		DBO.Fun_GetCompetitorInGroupResult(F_PhaseID, F_RegisterID, 2) AS Lose, 
		DBO.Fun_GetCompetitorInGroupResult(F_PhaseID, F_RegisterID, 3) AS Draw
			FROM #table_Results WHERE F_RegisterID <> -1 ORDER BY F_Rank, F_DisplayPosition

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


