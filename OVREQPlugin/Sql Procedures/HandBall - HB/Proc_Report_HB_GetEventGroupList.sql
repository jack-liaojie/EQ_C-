
/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_GetEventGroupList]    Script Date: 08/29/2012 16:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HB_GetEventGroupList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HB_GetEventGroupList]
GO


/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_GetEventGroupList]    Script Date: 08/29/2012 16:49:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_Report_HB_GetEventGroupList]
----功		  能：得到一个小项的小组信息
----作		  者：邓年彩
----日		  期: 2011-6-9

CREATE PROCEDURE [dbo].[Proc_Report_HB_GetEventGroupList]
                     (
	                   @EventID       INT,
                       @LanguageCode  CHAR(3)
                      )
AS
BEGIN
	
SET NOCOUNT ON

	SELECT P.F_PhaseID
		,p.F_PhaseCode
		, PD.F_PhaseLongName AS [Group]
		, (
			SELECT COUNT(PP.F_PhasePosition)
			FROM TS_Phase_Position AS PP
			WHERE PP.F_PhaseID = P.F_PhaseID
		) AS [Count]
	FROM TS_Phase AS P
	LEFT JOIN TS_Phase_Des AS PD
		ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
	--INNER JOIN TS_Phase AS FP
	--	ON P.F_FatherPhaseID = FP.F_PhaseID
	WHERE P.F_EventID = @EventID
		AND P.F_PhaseIsPool = 1
		--AND FP.F_PhaseCode = N'9'
	ORDER BY P.F_PhaseCode

SET NOCOUNT OFF
END


GO


