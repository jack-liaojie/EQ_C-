IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_AR_GetMatchTiedString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_AR_GetMatchTiedString]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Fun_AR_GetMatchTiedString]
--描    述: 将 同Session，同时进行的比赛 RaceNum 转化成字符串
--创 建 人: 崔凯
--日    期: 2011-10-17
--修改记录：

CREATE FUNCTION [dbo].[Fun_AR_GetMatchTiedString]
								(
									@MatchID					INT,
									@CompetitionPosition		INT
								)
RETURNS NVARCHAR(100)
AS
BEGIN

	DECLARE @MatchTied NVARCHAR(200)
	DECLARE @TiedComment varchar(10)  
	SET @MatchTied =N''
	SET @TiedComment = ' '
	
	DECLARE One_Cursor CURSOR FOR 
			SELECT CAST(MSR.F_Points AS NVARCHAR),MSRF.F_Comment 
				FROM TS_Match_Split_Result AS MSR
					 LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchID = MSR.F_MatchID AND MSI.F_MatchSplitID = MSR.F_MatchSplitID 
					 LEFT JOIN TS_Match_Split_Info AS MSIF ON MSIF.F_MatchID = MSR.F_MatchID AND MSIF.F_MatchSplitID = MSI.F_FatherMatchSplitID AND MSIF.F_MatchSplitType =2 
					 INNER JOIN TS_Match_Split_Result AS MSRF ON MSRF.F_MatchID = MSR.F_MatchID 
						AND MSIF.F_MatchSplitID = MSRF.F_MatchSplitID AND MSIF.F_MatchSplitType =2  AND MSRF.F_CompetitionPosition =@CompetitionPosition
					 WHERE MSI.F_MatchSplitType =3  AND MSR.F_MatchID =@MatchID AND MSR.F_CompetitionPosition =@CompetitionPosition

	OPEN One_Cursor
	DECLARE @Point varchar(20) ,@Comment varchar(10) 
	FETCH NEXT FROM One_Cursor INTO @Point,@Comment

	WHILE @@FETCH_STATUS = 0
	BEGIN
	    IF @Point IS NOT NULL 
	    BEGIN
	        IF @MatchTied = ''
	            SET @MatchTied = N'T' +@Point
	        ELSE    
				SET @MatchTied = @MatchTied + ';' + @Point
		END
		IF @Comment IS NOT NULL AND @Comment <>''
		BEGIN
			SET @TiedComment = @Comment
		END
		
		FETCH NEXT FROM One_Cursor INTO @Point,@Comment

	END
	
	SET @MatchTied = @MatchTied + @TiedComment
	
	CLOSE One_Cursor
	DEALLOCATE One_Cursor
	
	RETURN @MatchTied

END



GO


