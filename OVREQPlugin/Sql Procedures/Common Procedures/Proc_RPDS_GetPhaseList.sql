IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_RPDS_GetPhaseList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_RPDS_GetPhaseList]
GO

/****** Object:  StoredProcedure [dbo].[Proc_RPDS_GetPhaseList]    Script Date: 04/22/2010 11:27:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--名    称：[Proc_RPDS_GetPhaseList]
--描    述：获得比赛阶段列表
--参数说明： 
--说    明：
--创 建 人：余远华
--日    期：2010年05月04日


CREATE PROCEDURE [dbo].[Proc_RPDS_GetPhaseList](
												@DisciplineCode	    CHAR(2),
												@GenderCode		    NVARCHAR(10),
												@EventCode		    NVARCHAR(10),
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SELECT N'0' AS F_PhaseCode, N'ALL' AS [F_PhaseName], 0 AS F_Order
	UNION 
	SELECT SP.F_PhaseCode, SPD.F_PhaseLongName AS [F_PhaseName], SP.F_Order
		FROM TS_Phase AS SP
			LEFT JOIN TS_Phase_Des AS SPD ON SPD.F_PhaseID = SP.F_PhaseID  AND SPD.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Event AS SE ON SE.F_EventID = SP.F_EventID 
			LEFT JOIN TS_Discipline AS SD ON SD.F_DisciplineID = SE.F_DisciplineID
			LEFT JOIN TC_Sex AS CS ON CS.F_SexCode = SE.F_SexCode
		WHERE SD.F_DisciplineCode = @DisciplineCode 
			AND CS.F_GenderCode = @GenderCode 
			AND SE.F_EventCode = @EventCode 
		ORDER BY F_Order

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


