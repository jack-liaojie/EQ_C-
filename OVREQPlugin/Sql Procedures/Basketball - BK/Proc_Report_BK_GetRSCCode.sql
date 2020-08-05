IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_GetRSCCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_GetRSCCode]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----作		  者：吴定昉 
----日		  期: 2012-09-21
----

CREATE PROCEDURE [dbo].[Proc_Report_BK_GetRSCCode]
	@DisciplineID INT,
	@EventID	  INT,
	@PhaseID	  INT,
	@RoundID      INT,
	@MatchID	  INT,
	@DateID		  INT = -1,
	@DelegationID INT = -1,
	@ReportType   NVARCHAR(10) = 'NONE'
AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH

	DECLARE @RSCCode Nvarchar(100)

	DECLARE @tmp_DisciplineID	int
	DECLARE @tmp_SexCode	int
	DECLARE @tmp_EventID	int
	DECLARE @tmp_PhaseID	int
	DECLARE @tmp_RoundID	int
	
	DECLARE @tmp_DisciplineCode Nvarchar(10)
	DECLARE @tmp_GenderCode Nvarchar(10)
	DECLARE @tmp_EventCode Nvarchar(10)
	DECLARE @tmp_PhaseCode Nvarchar(10)
	DECLARE @tmp_RoundCode Nvarchar(10)
	DECLARE @tmp_MatchCode Nvarchar(10)
	
	IF @MatchID <> -1
	BEGIN
		SELECT @tmp_DisciplineID = D.F_DisciplineID,@tmp_DisciplineCode=D.F_DisciplineCode,
		@tmp_SexCode = S.F_SexCode,@tmp_GenderCode = S.F_GenderCode,
		@tmp_EventID = E.F_EventID,@tmp_EventCode = E.F_EventCode,
		@tmp_PhaseID = P.F_PhaseID,@tmp_PhaseCode = P.F_PhaseCode,
		@tmp_RoundID = R.F_RoundID,@tmp_RoundCode = R.F_Order,
		@tmp_MatchCode = M.F_MatchCode 
		FROM TS_Match AS M
		LEFT JOIN TS_Round AS R ON M.F_RoundID = R.F_RoundID
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode
		LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
		WHERE F_MatchID = @MatchId
	END
	ELSE IF @RoundID <> -1
	BEGIN	
		SELECT @tmp_DisciplineID = D.F_DisciplineID,@tmp_DisciplineCode=D.F_DisciplineCode,
		@tmp_SexCode = S.F_SexCode,@tmp_GenderCode = S.F_GenderCode,
		@tmp_EventID = E.F_EventID,@tmp_EventCode = E.F_EventCode,
		@tmp_RoundID = R.F_RoundID,@tmp_RoundCode = R.F_Order
		FROM TS_Round AS R
		LEFT JOIN TS_Event AS E ON R.F_EventID = E.F_EventID
		LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode
		LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
		WHERE F_RoundID = @RoundID
	END
	ELSE IF @PhaseID <> -1
	BEGIN
		SELECT @tmp_DisciplineID = D.F_DisciplineID,@tmp_DisciplineCode=D.F_DisciplineCode,
		@tmp_SexCode = S.F_SexCode,@tmp_GenderCode = S.F_GenderCode,
		@tmp_EventID = E.F_EventID,@tmp_EventCode = E.F_EventCode,
		@tmp_PhaseID = P.F_PhaseID,@tmp_PhaseCode = (CASE WHEN P.F_Order = 1 THEN N'P' 
														  WHEN P.F_Order = 2 THEN N'F' END)
		FROM TS_Phase AS P
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode
		LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
		WHERE F_PhaseID = @PhaseID
	END
	ELSE IF @EventID <> -1
	BEGIN	
		SELECT @tmp_DisciplineID = D.F_DisciplineID,@tmp_DisciplineCode=D.F_DisciplineCode,
		@tmp_SexCode = S.F_SexCode,@tmp_GenderCode = S.F_GenderCode,
		@tmp_EventID = E.F_EventID,@tmp_EventCode = E.F_EventCode
		FROM TS_Event AS E
		LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode
		LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
		WHERE F_EventID = @EventID
	END

	SET @tmp_MatchCode = ISNULL(@tmp_MatchCode,'00')
	SET @tmp_RoundCode = ISNULL(@tmp_RoundCode,'0')
	SET @tmp_PhaseCode = ISNULL(@tmp_PhaseCode,'0')

    SET @tmp_EventCode = [dbo].[Func_BK_GetOutputEventCode](@tmp_GenderCode, @tmp_EventCode)
    SET @tmp_EventCode = Right('000' + CAST(@tmp_EventCode AS NVARCHAR(3)), 3)
    SET @tmp_MatchCode = Right('00' + CAST(@tmp_MatchCode AS NVARCHAR(2)), 2)

	IF @ReportType IN ('C08') AND @EventID <> -1
	BEGIN
		SET @RSCCode = @tmp_DisciplineCode + @tmp_GenderCode + @tmp_EventCode + 
		@tmp_PhaseCode + @tmp_MatchCode
		SELECT @RSCCode
		RETURN 
	END

	IF @ReportType IN ('C51', 'C73') AND @MatchID <> -1
	BEGIN
		SET @RSCCode = @tmp_DisciplineCode + @tmp_GenderCode + @tmp_EventCode + 
		@tmp_RoundCode + @tmp_MatchCode
		SELECT @RSCCode
		RETURN 
	END

	IF @ReportType IN ('C58', 'C76') AND @RoundID <> -1
	BEGIN
		SET @RSCCode = @tmp_DisciplineCode + @tmp_GenderCode + @tmp_EventCode + 
		@tmp_RoundCode + @tmp_MatchCode
		SELECT @RSCCode
		RETURN 
	END

	IF @ReportType IN ('C76A', 'C76B') AND @PhaseID <> -1
	BEGIN
		SET @RSCCode = @tmp_DisciplineCode + @tmp_GenderCode + @tmp_EventCode + 
		@tmp_PhaseCode + @tmp_MatchCode
		SELECT @RSCCode
		RETURN 
	END

	IF @ReportType IN ('C92') AND @EventID <> -1
	BEGIN
		SET @RSCCode = @tmp_DisciplineCode + @tmp_GenderCode + @tmp_EventCode + 
		@tmp_PhaseCode + @tmp_MatchCode
		SELECT @RSCCode
		RETURN 
	END

	SELECT @RSCCode

SET NOCOUNT OFF
END



GO



