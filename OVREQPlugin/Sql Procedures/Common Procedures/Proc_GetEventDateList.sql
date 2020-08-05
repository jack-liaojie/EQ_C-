IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEventDateList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetEventDateList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_GetEventDateList]
--描    述：得到一个Event下面的比赛日期列表
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年04月29日

CREATE PROCEDURE [dbo].Proc_GetEventDateList(
				 @DisciplineCode	CHAR(2),
				 @EventID			INT
)
As
Begin
SET NOCOUNT ON 

	DECLARE @DisciplineID AS INT

	IF @EventID = -1
	BEGIN
		SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode
	END
	ELSE
	BEGIN
		SELECT @DisciplineID = F_DisciplineID FROM TS_Event WHERE F_EventID = @EventID
	END

	
	DECLARE @LanguageCode AS CHAR(3)
	SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1

	
	CREATE TABLE #Tmp_Dates(
								F_Date			NVARCHAR(100),
								F_Order			INT
							)

	DECLARE @AllDes AS NVARCHAR(50)
	SET @AllDes = ' 全部'

	IF @LanguageCode = 'CHN'
	BEGIN
		SET @AllDes = ' 全部'
	END
	ELSE
	BEGIN
		IF @LanguageCode = 'ENG'
		BEGIN
			SET @AllDes = ' ALL'
		END
	END

	INSERT INTO #Tmp_Dates (F_Date) VALUES (@AllDes)

--	INSERT INTO #Tmp_Dates (F_Date) SELECT DISTINCT LEFT(CONVERT (NVARCHAR(100), F_SessionDate, 120), 10)
--		FROM TS_Session WHERE F_DisciplineID = @DisciplineID

	IF @EventID = -1
	BEGIN
		INSERT INTO #Tmp_Dates (F_Date) SELECT DISTINCT LEFT(CONVERT (NVARCHAR(100), F_MatchDate, 120), 10) 
			FROM TS_Match WHERE F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID IN (SELECT F_EventID FROM TS_Event WHERE @DisciplineID = F_DisciplineID))
	END
	ELSE
	BEGIN
		INSERT INTO #Tmp_Dates (F_Date) SELECT DISTINCT LEFT(CONVERT (NVARCHAR(100), F_MatchDate, 120), 10) 
			FROM TS_Match WHERE F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID)
	END

	DELETE FROM #Tmp_Dates WHERE F_Date IS NULL
	SELECT DISTINCT F_Date FROM #Tmp_Dates ORDER BY  F_Date

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

--exec Proc_GetEventDateList 'BD',-1
