IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_RPDS_GetEventList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_RPDS_GetEventList]
GO

/****** Object:  StoredProcedure [dbo].[Proc_RPDS_GetEventList]    Script Date: 04/22/2010 11:27:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--名    称：[Proc_RPDS_GetEventList]
--描    述：获得小项列表
--参数说明： 
--说    明：
--创 建 人：余远华
--日    期：2010年05月04日


CREATE PROCEDURE [dbo].[Proc_RPDS_GetEventList](
												@DisciplineCode	    CHAR(2),
												@GenderCode		    NVARCHAR(10),
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SELECT N'000' AS F_EventCode, N'ALL' AS [F_EventName], 0 AS F_Order
	UNION 
	SELECT SE.F_EventCode, SED.F_EventLongName AS [F_EventName], SE.F_Order
		FROM TS_Event AS SE
			LEFT JOIN TS_Event_Des AS SED ON SED.F_EventID = SE.F_EventID  AND SED.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Discipline AS SD ON SD.F_DisciplineID = SE.F_DisciplineID
			LEFT JOIN TC_Sex AS CS ON CS.F_SexCode = SE.F_SexCode
		WHERE SD.F_DisciplineCode = @DisciplineCode 
			AND CS.F_GenderCode = @GenderCode 
		ORDER BY F_Order

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


