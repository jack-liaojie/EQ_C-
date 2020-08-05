IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_AR_GetMatchNumbersString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_AR_GetMatchNumbersString]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Fun_AR_GetMatchNumbersString]
--描    述: 将 同Session，同时进行的比赛 RaceNum 转化成字符串
--创 建 人: 崔凯
--日    期: 2011-10-17
--修改记录：

CREATE FUNCTION [dbo].[Fun_AR_GetMatchNumbersString]
								(
									@EventID					INT,
									@PhaseID					INT,
									@SessionID					INT,
									@StartTime					DateTime
								)
RETURNS NVARCHAR(100)
AS
BEGIN

	DECLARE @MatchNumbers NVARCHAR(200)
	
	SET @MatchNumbers = ''

	DECLARE One_Cursor CURSOR FOR 
			SELECT F_RaceNum,MD.F_MatchLongName,P.F_PhaseCode FROM TS_Match AS M
			LEFT JOIN TS_Match_Des AS MD ON MD.F_MatchID = M.F_MatchID AND MD.F_LanguageCode = 'ENG'
			LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID
			LEFT JOIN TS_Event AS E ON E.F_EventID = P.F_EventID 
			 WHERE M.F_SessionID = @SessionID AND M.F_StartTime=@StartTime AND E.F_EventID = @EventID  AND P.F_PhaseID = @PhaseID

	OPEN One_Cursor
	DECLARE @RaceNum varchar(20) ,@MatchName varchar(50) ,@PhaseCode varchar(10) 
	FETCH NEXT FROM One_Cursor INTO @RaceNum,@MatchName,@PhaseCode

	WHILE @@FETCH_STATUS = 0
	BEGIN
	    IF @RaceNum IS NOT NULL AND @PhaseCode <>'1'
	    BEGIN
	        IF @MatchNumbers = ''
	            SET @MatchNumbers = @RaceNum
	        ELSE    
				SET @MatchNumbers = @MatchNumbers + ', ' + @RaceNum
		END
		ELSE IF @PhaseCode ='1'
		BEGIN
			SET @MatchNumbers = @MatchName
			Break
		END
		FETCH NEXT FROM One_Cursor INTO @RaceNum,@MatchName,@PhaseCode

	END

	CLOSE One_Cursor
	DEALLOCATE One_Cursor
	
	RETURN @MatchNumbers

END



GO


