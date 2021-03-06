/****** Object:  StoredProcedure [dbo].[Proc_GetDisciplineEvents]    Script Date: 11/20/2009 10:41:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDisciplineEvents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetDisciplineEvents]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetDisciplineEvents]    Script Date: 11/20/2009 10:39:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_GetDisciplineEvents]
--描    述：得到所有的Discipline下所有的Events
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年08月13日
--修改记录   修改日期     修改人      修改内容
/*
             2009-11-20    李燕        增加Event状态
*/

CREATE PROCEDURE [dbo].[Proc_GetDisciplineEvents](
				 @DisciplineID		INT,
				 @LanguageCode		CHAR(3)
)
AS
Begin
SET NOCOUNT ON 

	SELECT A.F_Order AS [Order],A.F_EventCode AS Code,
		B.F_EventLongName AS [Long Name],B.F_EventShortName AS [Short Name],F.F_StatusLongName AS[Status],
		CONVERT(VARCHAR(10),A.F_OpenDate,120) AS [Open Date],CONVERT(VARCHAR(10),A.F_CloseDate,120) AS [Close Date],
		C.F_SexLongName AS [Sex] ,D.F_RegTypeLongDescription AS [Register Type], E.F_CompetitionTypeLongName AS [Competition Type], A.F_EventID AS [ID] 
		FROM TS_Event AS A left join TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode=@LanguageCode
			left join TC_Sex_Des AS C ON A.F_SexCode = C.F_SexCode AND C.F_LanguageCode=@LanguageCode
			left join TC_RegType_Des AS D ON A.F_PlayerRegTypeID = D.F_RegTypeID AND D.F_LanguageCode=@LanguageCode
			left join TC_CompetitionType_Des AS E ON A.F_CompetitionTypeID = E.F_CompetitionTypeID AND E.F_LanguageCode=@LanguageCode
            left join TC_Status_Des AS F ON A.F_EventStatusID = F.F_StatusID AND F.F_LanguageCode=@LanguageCode
			WHERE F_DisciplineID = @DisciplineID ORDER BY [Order]

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

