IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_BD_GetCurrentSetAndGameID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_BD_GetCurrentSetAndGameID]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		王强
-- Create date: 2011/5/5
-- Description:	获取当前正在进行的比赛的盘ID和局ID
-- =============================================

CREATE FUNCTION [dbo].[Fun_BD_GetCurrentSetAndGameID]
								(
									@MatchID INT,
									@Type   INT  --1代表获取盘ID,--2代表获取局ID
								)
RETURNS INT
AS
BEGIN

	DECLARE @Res INT = 0
	IF @Type = 1
	BEGIN
		SELECT @Res = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID 
						AND F_MatchSplitComment IS NOT NULL AND F_FatherMatchSplitID = 0
		IF @Res IS NULL 
			RETURN 0
	END
	ELSE IF @Type = 2
	BEGIN
		SELECT @Res = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID 
						AND F_MatchSplitComment IS NOT NULL AND F_FatherMatchSplitID != 0
		IF @Res IS NULL
			RETURN 0
	END
	
	RETURN @Res
END

GO

