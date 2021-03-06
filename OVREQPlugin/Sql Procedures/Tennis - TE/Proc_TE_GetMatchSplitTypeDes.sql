
GO

/****** Object:  StoredProcedure [dbo].[Proc_BD_GetMatchSplitTypeDes]    Script Date: 10/15/2010 11:28:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchSplitTypeDes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchSplitTypeDes]
GO


GO

/****** Object:  StoredProcedure [dbo].[Proc_TE_GetMatchSplitTypeDes]    Script Date: 10/15/2010 11:28:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_BD_GetMatchSplitTypeDes]
--描    述：得到MatchSplit的所有类型及描述
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2011年7月04日


CREATE PROCEDURE [dbo].[Proc_TE_GetMatchSplitTypeDes] (
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
		(1, '单打', 'CHN'),
		(2, '双打', 'CHN'),
		
		(1, 'Single', 'ENG'),
		(2, 'Double', 'ENG')

	SELECT F_MatchSplitType, F_MatchSplitTypeName FROM #Tmp_MatchSplitType_Des WHERE F_LanguageCode=@LanguageCode
	
Set NOCOUNT OFF
End	
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

