IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_Report_BD_GetRSCCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_Report_BD_GetRSCCode]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----作		  者：张翠霞 
----日		  期: 2010-7-7
----修改:2011-1-20王强：改为大运会要求的RSC

CREATE PROCEDURE [dbo].[proc_Report_BD_GetRSCCode]
	@DisciplineID INT,
	@EventID	  INT = -1,
	@PhaseID	  INT = -1,
	@MatchId	  INT = -1,
	@DateId		  INT = -1,
	@DelegationID INT = -1
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @RscCode NVARCHAR(50)
	DECLARE @DiscCode NVARCHAR(10) = '00'
	DECLARE @GenderCode NVARCHAR(10) = '0'
	DECLARE @EventCode NVARCHAR(10) = '000'
	DECLARE @PhaseCode NVARCHAR(10) = '0'
	DECLARE @MatchCode NVARCHAR(10) = '00'
	
	DECLARE @LDiscID INT
	DECLARE @LEventID INT
	DECLARE @LPhaseID INT
	
	IF @MatchId != -1
	BEGIN
		SELECT @LPhaseID = F_PhaseID, @MatchCode = F_MatchCode FROM TS_Match WHERE F_MatchID = @MatchId
		SELECT @LEventID = F_EventID, @PhaseCode = F_PhaseCode FROM TS_Phase WHERE F_PhaseID = @LPhaseID
		SELECT @LDiscID = A.F_DisciplineID, @EventCode = A.F_EventCode, @GenderCode = B.F_GenderCode
		FROM TS_Event AS A 
		LEFT JOIN TC_Sex AS B ON B.F_SexCode = A.F_SexCode
		WHERE A.F_EventID = @LEventID
		
		SELECT @DiscCode = F_DisciplineCode FROM TS_Discipline WHERE F_DisciplineID = @LDiscID
	END
	
	IF @PhaseID != -1
	BEGIN
		SELECT @LEventID = F_EventID, @PhaseCode = F_PhaseCode FROM TS_Phase WHERE F_PhaseID = @PhaseID
		SELECT @LDiscID = A.F_DisciplineID, @EventCode = A.F_EventCode, @GenderCode = B.F_GenderCode
		FROM TS_Event AS A 
		LEFT JOIN TC_Sex AS B ON B.F_SexCode = A.F_SexCode
		WHERE A.F_EventID = @LEventID
		
		SELECT @DiscCode = F_DisciplineCode FROM TS_Discipline WHERE F_DisciplineID = @LDiscID
	END
	
	IF @EventID != -1
	BEGIN
		SELECT @LDiscID = A.F_DisciplineID, @EventCode = A.F_EventCode, @GenderCode = B.F_GenderCode
		FROM TS_Event AS A 
		LEFT JOIN TC_Sex AS B ON B.F_SexCode = A.F_SexCode
		WHERE A.F_EventID = @EventID
		
		SELECT @DiscCode = F_DisciplineCode FROM TS_Discipline WHERE F_DisciplineID = @LDiscID
	END
	
	IF @DisciplineID != -1
	BEGIN
		SELECT @DiscCode = F_DisciplineCode FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID
	END
	
	SET @RscCode = @DiscCode + @GenderCode + @EventCode + @PhaseCode + @MatchCode
	
	SELECT @RscCode
SET NOCOUNT OFF
END


GO
/*
test:  exec proc_Report_BD_GetRSCCode 1
*/

