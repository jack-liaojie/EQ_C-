
/****** Object:  StoredProcedure [dbo].[Proc_GetDisciplineEventList]    Script Date: 04/25/2011 15:03:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDisciplineEventList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetDisciplineEventList]
GO


/****** Object:  StoredProcedure [dbo].[Proc_GetDisciplineEventList]    Script Date: 04/25/2011 15:03:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GetDisciplineEventList]
--描    述：得到一个Discipline下面的Event列表
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年04月29日

CREATE PROCEDURE [dbo].[Proc_GetDisciplineEventList](
				 @DisciplineCode	CHAR(2),
				 @DateTime          NVARCHAR(50)
)
As
Begin
SET NOCOUNT ON 

	DECLARE @DisciplineID AS INT
	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode
	
	DECLARE @LanguageCode AS CHAR(3)
	SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1

	CREATE TABLE #Tmp_Events(
								F_EventLongName			NVARCHAR(100),
								F_EventID				INT
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
	INSERT INTO #Tmp_Events (F_EventLongName, F_EventID) VALUES (@AllDes,-1)
    
    IF ((@DateTime != ' ALL') AND (@DateTime != ' 全部'))
    BEGIN
		 INSERT INTO #Tmp_Events (F_EventLongName, F_EventID)
	      SELECT DISTINCT ED.F_EventLongName, E.F_EventID
	        FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	            LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	            LEFT JOIN TS_Event_Des AS ED ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
	       WHERE  LEFT(CONVERT (NVARCHAR(100), M.F_MatchDate, 120), 10) = LTRIM(RTRIM(@DateTime)) AND E.F_DisciplineID = @DisciplineID
	END
	ELSE 
	BEGIN
		INSERT INTO #Tmp_Events (F_EventLongName, F_EventID) 
			SELECT B.F_EventLongName, A.F_EventID 
			FROM TS_Event AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @LanguageCode 
					WHERE A.F_DisciplineID = @DisciplineID ORDER BY A.F_Order
	   
	END

	SELECT * FROM #Tmp_Events 

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


