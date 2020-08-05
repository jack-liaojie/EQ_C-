IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEventByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetEventByID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetEventByID]
--描    述: 根据 EventID 获取 Event
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月18日



CREATE PROCEDURE [dbo].[Proc_GetEventByID]
	@EventID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT * FROM TS_Event AS A 
			left join TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode=@LanguageCode 
			left join TC_Sex_Des AS C ON A.F_SexCode = C.F_SexCode AND C.F_LanguageCode=@LanguageCode
			left join TC_RegType_Des AS D ON A.F_PlayerRegTypeID = D.F_RegTypeID AND D.F_LanguageCode=@LanguageCode
			LEFT JOIN TC_CompetitionType_Des AS E ON A.F_CompetitionTypeID = E.F_CompetitionTypeID AND E.F_LanguageCode=@LanguageCode
				WHERE A.F_EventID = @EventID

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetEventByID] 13, 'CHN'
--exec [Proc_GetEventByID] 13, 'ENG'