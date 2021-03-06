IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetPhases]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetPhases]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_Schedule_GetPhases]
--描    述：得到Event下所有的Phase
--参数说明： 
--说    明：
--创 建 人：吴定昉
--日    期：2011年04月25日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_Schedule_GetPhases](
				 @DisciplineID		INT,
				 @EventID			INT,
				 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SELECT ED.F_EventLongName AS [Event]
		, P.F_Order AS [Order]
		, P.F_PhaseCode AS [Code]
		, PD.F_PhaseLongName AS [LongName]
		, PD.F_PhaseShortName AS [ShortName]
		, PD.F_PhaseComment AS [Comment]
		, P.F_PhaseID
		, P.F_EventID
	FROM TS_Phase AS P 
	LEFT JOIN TS_Phase_Des AS PD 
		ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event_Des AS ED 
		ON P.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	WHERE E.F_DisciplineID = @DisciplineID
		AND P.F_EventID = @EventID
		AND P.F_PhaseID NOT IN (SELECT DISTINCT F_FatherPhaseID FROM TS_Phase WHERE F_EventID = @EventID)
	ORDER BY P.F_Order						
	
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

/*
	-- Just from test
	DECLARE @DisciplineID	INT
	DECLARE @EventID		INT
	DECLARE @LanguageCode	CHAR(3)
	
	SET @DisciplineID = 74
	SET @EventID = 1
	SET @LanguageCode = 'CHN'

	EXEC [Proc_Schedule_GetPhases] @DisciplineID, @EventID, @LanguageCode
*/

