IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetMatchSourceMatches]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetMatchSourceMatches]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_GetMatchSourceMatches]
--描    述：得到一场比赛，其两个参赛者，可能的Match来源，关键要有SourcePhaseID
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年04月16日

CREATE PROCEDURE [dbo].[Proc_GetMatchSourceMatches](
				 @EventID			INT,
				 @PhaseID			INT,
				 @MatchID			INT,
				 @SourcePhaseID		INT,
                 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 
	CREATE TABLE #Temp_Table(
									F_LongName			NVARCHAR(100),
									F_ID				INT
									)

	INSERT INTO #Temp_Table (F_LongName, F_ID) VALUES ('NONE',-1)
	INSERT INTO #Temp_Table (F_LongName, F_ID) 
		SELECT B.F_PhaseLongName + C.F_MatchLongName AS F_LongName, A.F_MatchID AS F_ID FROM TS_Match AS A LEFT JOIN TS_Phase_Des AS B 
				ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode LEFT JOIN TS_Match_Des AS C ON A.F_MatchID = C.F_MatchID AND C.F_LanguageCode = @LanguageCode WHERE  A.F_PhaseID = @SourcePhaseID

	SELECT F_LongName, F_ID FROM #Temp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO
