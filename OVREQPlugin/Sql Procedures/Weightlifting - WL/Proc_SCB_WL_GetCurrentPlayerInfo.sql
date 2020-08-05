IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_WL_GetCurrentPlayerInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_WL_GetCurrentPlayerInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[Proc_SCB_WL_GetCurrentPlayerInfo]
----功		  能：SCB得到当前运动员信息
----作		  者：崔凯
----日		  期: 2011-02-28 

CREATE PROCEDURE [dbo].[Proc_SCB_WL_GetCurrentPlayerInfo]
             @MatchID         INT,
             @RegisterID      INT

AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @SQL		    NVARCHAR(max)
    DECLARE @DisciplineCode NVARCHAR(10)	
	DECLARE @EventCode		NVARCHAR(10)
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @MatchCode		NVARCHAR(10)
    DECLARE @SexCode        INT
	DECLARE @PhaseID   INT


	SELECT @DisciplineCode = D.F_DisciplineCode,
	@EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @PhaseCode = P.F_PhaseCode, 
    @MatchCode = M.F_MatchCode FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    WHERE F_MatchID = @MatchID

    SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID
	
	SELECT 
	RDE.F_SBLongName AS LongName_ENG,
	RDC.F_SBLongName AS LongName_CHN,
	R.F_Weight,
	MR.F_Points,	
	CASE WHEN MR.F_Points =1 OR MR.F_Points =0 THEN MR.F_PointsCharDes1
		 WHEN MR.F_Points =2 THEN MR.F_PointsCharDes2
		 WHEN MR.F_Points =3 THEN MR.F_PointsCharDes1
		 ELSE MR.F_PointsCharDes3  END AttemptWeight,
	CASE WHEN MR.F_Points =1 OR MR.F_Points =0 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes1,1)
		 WHEN MR.F_Points =2 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes2,1)
		 WHEN MR.F_Points =3 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes3,1)
		 ELSE dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes3,1)  END Light1,
	CASE WHEN MR.F_Points =1 OR MR.F_Points =0 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes1,2)
		 WHEN MR.F_Points =2 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes2,2)
		 WHEN MR.F_Points =3 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes3,2)
		 ELSE dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes3,2)  END Light2,
	CASE WHEN MR.F_Points =1 OR MR.F_Points =0 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes1,1)
		 WHEN MR.F_Points =2 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes2,2)
		 WHEN MR.F_Points =3 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes3,2)
		 ELSE dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes3,3)  END Light3
	FROM TS_Match_Result AS MR
	LEFT JOIN TR_Register AS R ON R.F_RegisterID = MR.F_RegisterID
	LEFT JOIN TR_Register_Des AS RDE ON RDE.F_RegisterID = MR.F_RegisterID AND RDE.F_LanguageCode='ENG'
	LEFT JOIN TR_Register_Des AS RDC ON RDC.F_RegisterID = MR.F_RegisterID AND RDC.F_LanguageCode='CHN'
	WHERE MR.F_RegisterID=@RegisterID AND MR.F_MatchID=@MatchID
	
SET NOCOUNT OFF
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO


/*

-- Just for test
EXEC [Proc_SCB_WL_GetCurrentPlayerInfo] 62,17

*/
