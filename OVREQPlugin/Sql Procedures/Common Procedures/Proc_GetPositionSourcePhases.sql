IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPositionSourcePhases]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetPositionSourcePhases]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GetPositionSourcePhases]
--描    述：得到一个阶段每个签位参赛者，可能的Phase来源，以及起始的Phase来源
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2009年10月5日

CREATE PROCEDURE [dbo].[Proc_GetPositionSourcePhases](
				 @EventID			INT,
				 @PhaseID			INT,
                 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	IF @EventID IS NULL OR @EventID = 0
	BEGIN
		SELECT @EventID = F_EventID FROM TS_Phase WHERE F_PhaseID = @PhaseID
	END

	CREATE TABLE #Temp_Table(
									F_LongName			NVARCHAR(1000),
									F_ID				INT,
									F_FatherID			INT,
									F_Level				INT
									)

	DECLARE @CurLevel AS INT
	SET @CurLevel = 0

	INSERT INTO #Temp_Table (F_LongName, F_ID, F_FatherID, F_Level) SELECT B.F_PhaseLongName AS F_LongName, A.F_PhaseID AS F_ID, F_FatherPhaseID AS F_FatherID, 0 AS F_Level 
		from TS_Phase AS A LEFT JOIN TS_Phase_Des AS B 
			ON A.F_PhaseID = B.F_PhaseID WHERE B.F_LanguageCode = @LanguageCode AND A.F_EventID = @EventID AND A.F_FatherPhaseID = 0

	WHILE EXISTS (SELECT F_ID FROM #Temp_Table WHERE F_Level = 0)
	BEGIN
		SET @CurLevel = @CurLevel + 1
		UPDATE #Temp_Table SET F_Level = @CurLevel WHERE F_Level = 0
		
		INSERT INTO #Temp_Table (F_LongName, F_ID, F_FatherID, F_Level) SELECT A.F_LongName + '\' + C.F_PhaseLongName AS F_LongName, B.F_PhaseID AS F_ID, B.F_FatherPhaseID AS F_FatherID, 0 AS F_Level 
			from #Temp_Table AS A RIGHT JOIN TS_Phase AS B ON A.F_ID = B.F_FatherPhaseID LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
				WHERE A.F_Level = @CurLevel 
	END

	INSERT INTO #Temp_Table (F_LongName, F_ID) VALUES ('NONE',-1)
	SELECT F_LongName, F_ID FROM #Temp_Table
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


