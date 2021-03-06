
/****** Object:  UserDefinedFunction [dbo].[Fun_TE_GetMatchSplitTypeName]    Script Date: 10/15/2010 11:26:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_TE_GetMatchSplitTypeName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_TE_GetMatchSplitTypeName]
GO


/****** Object:  UserDefinedFunction [dbo].[Fun_TE_GetMatchSplitTypeName]    Script Date: 10/15/2010 11:26:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_TE_GetMatchSplitTypeDes]
--描    述：得到MatchSplit的类型名
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2011年07月04日

CREATE FUNCTION [dbo].[Fun_TE_GetMatchSplitTypeName] (
														@MatchSplitType			INT, --如果无效则返回 ‘NULL’字符串
														@LanguageCode	NVARCHAR(10)
														)
RETURNS NVARCHAR(100)
AS
Begin
		IF @LanguageCode = 'ENG'
		BEGIN
			IF @MatchSplitType = 1
				RETURN 'Single'
			IF @MatchSplitType = 2
				RETURN 'Double'
	   END
		
		IF @LanguageCode = 'CHN'
		BEGIN
			IF @MatchSplitType = 1
				RETURN '单打'
			IF @MatchSplitType = 2
				RETURN '双打'	
		END

		RETURN 'NULL'	
End	
	


GO

