IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BDTT_GetTeamSubEventOrder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BDTT_GetTeamSubEventOrder]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_BDTT_GetTeamSubEventOrder]
--描    述：获取团体赛小场顺序
--参数说明： 
--说    明：
--创 建 人：王强
--日    期：2012年06月06日

CREATE PROCEDURE [dbo].[Proc_BDTT_GetTeamSubEventOrder]
As
Begin
SET NOCOUNT ON 
	
	DECLARE @DisCode NVARCHAR(10)
	
	SELECT @DisCode = F_DisciplineCode FROM TS_Discipline WHERE F_Active = 1
	
	DECLARE @Lang NVARCHAR(10)
	SELECT @Lang = F_LanguageCode FROM TC_Language WHERE F_Active = 1
	
	--判断是否已经填写
	IF NOT EXISTS (SELECT F_EventID FROM TS_Event WHERE F_PlayerRegTypeID = 3 AND F_SexCode = 1 AND F_EventInfo IS NOT NULL)
	BEGIN
		IF @DisCode = 'BD'
			UPDATE TS_Event SET F_EventInfo = 'MS,MD,MS,MD,MS' WHERE F_PlayerRegTypeID = 3 AND F_SexCode = 1
		ELSE IF @DisCode = 'TT'
			UPDATE TS_Event SET F_EventInfo = 'MS,MS,MD,MS,MS' WHERE F_PlayerRegTypeID = 3 AND F_SexCode = 1
	END
	
	IF NOT EXISTS (SELECT F_EventID FROM TS_Event WHERE F_PlayerRegTypeID = 3 AND F_SexCode = 2 AND F_EventInfo IS NOT NULL)
	BEGIN
		IF @DisCode = 'BD'
			UPDATE TS_Event SET F_EventInfo = 'WS,WD,WS,WD,WS' WHERE F_PlayerRegTypeID = 3 AND F_SexCode = 2
		ELSE IF @DisCode = 'TT'
			UPDATE TS_Event SET F_EventInfo = 'WS,WS,WD,WS,WS' WHERE F_PlayerRegTypeID = 3 AND F_SexCode = 2
	END
	
	IF NOT EXISTS (SELECT F_EventID FROM TS_Event WHERE F_PlayerRegTypeID = 3 AND F_SexCode = 3 AND F_EventInfo IS NOT NULL)
	BEGIN
		UPDATE TS_Event SET F_EventInfo = 'MS,WS,MD,WD,XD' WHERE F_PlayerRegTypeID = 3 AND F_SexCode = 3
	END
	
	SELECT A.F_EventID AS EventID, A.F_EventInfo AS SubMatchOrder,B.F_SexShortName AS Gender 
	FROM TS_Event AS A 
	LEFT JOIN TC_Sex_Des AS B ON B.F_SexCode = A.F_SexCode AND B.F_LanguageCode = @Lang
	WHERE F_PlayerRegTypeID = 3 ORDER BY A.F_SexCode 

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



GO

