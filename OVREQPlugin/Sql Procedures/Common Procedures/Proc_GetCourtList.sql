IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCourtList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCourtList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GetCourtList]
--描    述：得到一个Discipline下的所有的场地信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2009-09-17

CREATE PROCEDURE [dbo].[Proc_GetCourtList]

As
Begin
SET NOCOUNT ON 

	DECLARE @DisciplineID AS INT
	SELECT TOP 1 @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_Active = 1
	
	DECLARE @LanguageCode AS CHAR(3)
	SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1

	
	CREATE TABLE #Tmp_Court(
								F_CourtLongName		NVARCHAR(100),
								F_CourtID			INT
							)

	DECLARE @AllDes AS NVARCHAR(50)
	SET @AllDes = ' 全部'

	IF @LanguageCode = 'CHN'
	BEGIN
		SET @AllDes = ' 全部'
	END
	ELSE IF @LanguageCode = 'ENG'
		BEGIN
			SET @AllDes = ' ALL'
		END

	INSERT INTO #Tmp_Court (F_CourtLongName, F_CourtID) VALUES (@AllDes, -1)


	INSERT INTO #Tmp_Court (F_CourtLongName, F_CourtID) SELECT B.F_CourtLongName, A.F_CourtID FROM
		TC_Court AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID LEFT JOIN TD_Discipline_Venue
        AS C ON A.F_VenueID = C.F_VenueID WHERE C.F_DisciplineID = @DisciplineID AND B.F_LanguageCode = @LanguageCode 

	SELECT * FROM #Tmp_Court ORDER BY F_CourtLongName

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


