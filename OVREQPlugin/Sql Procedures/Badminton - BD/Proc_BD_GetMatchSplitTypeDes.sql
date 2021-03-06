IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_GetMatchSplitTypeDes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_GetMatchSplitTypeDes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_BD_GetMatchSplitTypeDes]
--描    述：得到MatchSplit的所有类型及描述
--参数说明： 
--说    明：
--创 建 人：管仁良
--日    期：2010年10月07日


CREATE PROCEDURE [dbo].[Proc_BD_GetMatchSplitTypeDes] (
														@LanguageCode	NVARCHAR(10)
														)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	
	CREATE TABLE #Tmp_MatchSplitType_Des (
											F_MatchSplitType		INT,
											F_MatchSplitTypeName	NVARCHAR(100),
											F_LanguageCode			NVARCHAR(10)
											)

	INSERT INTO #Tmp_MatchSplitType_Des
	VALUES
		(1, '男子单打', 'CHN'),
		(2, '女子单打', 'CHN'),
		(3, '男子双打', 'CHN'),
		(4, '女子双打', 'CHN'),
		(5, '混合双打', 'CHN'),
		
		(1, 'Men''s Single', 'ENG'),
		(2, 'Women''s Single', 'ENG'),
		(3, 'Men''s Double', 'ENG'),
		(4, 'Women''s Double', 'ENG'),
		(5, 'Mixed''s Double', 'ENG')


	SELECT F_MatchSplitType, F_MatchSplitTypeName FROM #Tmp_MatchSplitType_Des WHERE F_LanguageCode=@LanguageCode
	
Set NOCOUNT OFF
End	
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

