
GO

/****** Object:  UserDefinedFunction [dbo].[Fun_BD_GetMatchSplitTypeName]    Script Date: 10/15/2010 11:26:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_BD_GetMatchSplitTypeName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_BD_GetMatchSplitTypeName]
GO


GO

/****** Object:  UserDefinedFunction [dbo].[Fun_BD_GetMatchSplitTypeName]    Script Date: 10/15/2010 11:26:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_BD_GetMatchSplitTypeDes]
--描    述：得到MatchSplit的类型名
--参数说明： 
--说    明：
--创 建 人：管仁良
--日    期：2010年10月07日

CREATE FUNCTION [dbo].[Fun_BD_GetMatchSplitTypeName] (
														@MatchSplitType			INT, --如果无效则返回 ‘NULL’字符串
														@LanguageCode	NVARCHAR(10)
														)
RETURNS NVARCHAR(100)
AS
Begin
		IF @LanguageCode = 'ENG'
		BEGIN
			IF @MatchSplitType = 1
				RETURN 'Men''s Single'
			IF @MatchSplitType = 2
				RETURN 'Women''s Single'
			IF @MatchSplitType = 3
				RETURN 'Men''s Double'
			IF @MatchSplitType = 4
				RETURN 'Women''s Double'
			IF @MatchSplitType = 5
				RETURN 'Mixed''s Double'	
		END
		
		IF @LanguageCode = 'CHN'
		BEGIN
			IF @MatchSplitType = 1
				RETURN '男子单打'
			IF @MatchSplitType = 2
				RETURN '女子单打'	
			IF @MatchSplitType = 3
				RETURN '男子双打'
			IF @MatchSplitType = 4
				RETURN '女子双打'
			IF @MatchSplitType = 5
				RETURN '混合双打'
		END

		RETURN 'NULL'	
End	
	


GO

