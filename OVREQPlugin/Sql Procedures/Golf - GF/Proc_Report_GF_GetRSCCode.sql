IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_GetRSCCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_GetRSCCode]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----作    者：张翠霞 
----日	  期: 2010-7-7
----修改记录：
/*			
			时间				修改人		修改内容	
			2012年09月13日      吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/


CREATE PROCEDURE [dbo].[Proc_Report_GF_GetRSCCode]
	@DisciplineID INT,
	@EventID	  INT,
	@PhaseID	  INT,
	@MatchID	  INT,
	@DateID		  INT = -1,
	@DelegationID INT = -1,
	@ReportType   NVARCHAR(10) = 'NONE'
AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH

	CREATE TABLE #table_tmp(
			[KEY]	NVARCHAR(40),
			F_DisciplineID	int,
			DISCIPLINE	nchar(2),
			SEX	nchar(1),
			F_EventID	int,
			[EVENT]	nchar(3),
			EVENT_PARENT	nchar(3),
			PHASE_ID	int,
			PHASE	nchar(1),
			IS_POOL	int,
			POOL nchar(2),
			F_MatchID	int,
			EVENT_UNIT	nchar(2),
			FATHER_PHASE_ID	INT
				)

	INSERT #table_tmp([KEY]) VALUES('')

	DECLARE @tmp_DisciplineID	int
	DECLARE @tmp_EventID	int
	DECLARE @tmp_PhaseID	int
	DECLARE @tmp_phaseIsPool	int
	
	DECLARE @tmp_DisciplineCode Nvarchar(10)
	DECLARE @tmp_SexCode Nvarchar(10)
	DECLARE @tmp_EventCode Nvarchar(10)
	DECLARE @tmp_PhaseCode Nvarchar(10)
	DECLARE @tmp_UnitCode Nvarchar(10)
	DECLARE @tmp_sex int
	
	IF @MatchID <> -1
	BEGIN
		SELECT @tmp_PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchId
		SELECT @tmp_UnitCode = F_MatchCode FROM TS_MATCH WHERE F_MatchID = @MatchId
		UPDATE #table_tmp SET F_MatchID = @MatchId, EVENT_UNIT = @tmp_UnitCode
	END
	ELSE
	BEGIN
		SET @tmp_PhaseID = @PhaseID
	END

	IF @tmp_UnitCode IS NULL
	BEGIN
		SET @tmp_UnitCode = '00'
	END


	IF @tmp_PhaseID <> -1
	BEGIN	
		SELECT @tmp_EventID = F_EventID FROM TS_PHASE WHERE F_PhaseID = @tmp_PhaseID
		SELECT @tmp_phaseIsPool = F_PhaseIsPool FROM TS_PHASE WHERE F_PhaseID = @tmp_PhaseID
		UPDATE #table_tmp SET PHASE_ID = @tmp_PhaseID, IS_POOL = @tmp_phaseIsPool
	END
	ELSE
	BEGIN
		SET @tmp_EventID = @EventID
	END

	IF @tmp_EventID <> -1 
	BEGIN
		SELECT @tmp_DisciplineID = F_DisciplineID FROM TS_EVENT WHERE F_EventID = @tmp_EventID
		UPDATE #table_tmp SET F_EventID = @tmp_EventID, F_DisciplineID = @tmp_DisciplineID
	END
	ELSE
	BEGIN
		SET @tmp_DisciplineID = @DisciplineID
	END

	IF @DateID <> -1  
	BEGIN
		SELECT @tmp_DisciplineID = F_DisciplineID FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DateID
	END	

	SELECT @tmp_DisciplineCode = F_DisciplineCode FROM TS_Discipline WHERE F_DisciplineId = @tmp_DisciplineID
	SELECT @tmp_EventCode = Right('000' + CAST(F_EventCode AS NVARCHAR(3)), 3) FROM TS_Event WHERE F_EventID = @tmp_EventID
	SELECT @tmp_sex = F_Sexcode FROM TS_Event WHERE F_EventID = @tmp_EventID
	SELECT @tmp_SexCode = F_GenderCode FROM TC_SEX WHERE F_Sexcode = @tmp_sex
	SELECT @tmp_PhaseCode = cast(F_PhaseCode as Nchar(1)) FROM TS_Phase WHERE F_PhaseId = @tmp_PhaseID
	
	IF @tmp_PhaseCode IS NULL
	BEGIN
		SET @tmp_PhaseCode = '0'
		UPDATE #table_tmp SET IS_POOL = 0, POOL = '00'
	END

	IF @tmp_EventCode IS NULL
	BEGIN
		SET @tmp_EventCode = '000'
		SET @tmp_SexCode = '0'
	END

	IF @tmp_DisciplineCode IS NULL
	BEGIN
		SET @tmp_DisciplineCode = '00'
	END

	UPDATE #table_tmp SET DISCIPLINE = @tmp_DisciplineCode, SEX = @tmp_SexCode, 
				[EVENT] = @tmp_EventCode, EVENT_PARENT = @tmp_EventCode,
				PHASE = @tmp_PhaseCode, EVENT_UNIT = right('00' + @tmp_UnitCode, 2)

	UPDATE #table_tmp SET FATHER_PHASE_ID = F_FatherPhaseID FROM  #table_tmp AS A LEFT JOIN TS_Phase AS B ON A.PHASE_ID = B.F_PhaseID WHERE A.IS_POOL = 1
	UPDATE #table_tmp SET FATHER_PHASE_ID = PHASE_ID WHERE IS_POOL = 1 AND (FATHER_PHASE_ID = 0 OR FATHER_PHASE_ID IS NULL)
	UPDATE #table_tmp SET PHASE = left(B.F_PhaseCode,1) FROM  #table_tmp AS A LEFT JOIN TS_Phase AS B ON A.FATHER_PHASE_ID = B.F_PhaseID WHERE A.IS_POOL = 1
	UPDATE #table_tmp SET POOL = (CASE B.F_PhaseCode WHEN 'A' THEN '01' WHEN 'B' THEN '02' WHEN 'C' THEN '03' WHEN 'D' THEN '04' WHEN 'E' THEN '05' WHEN 'F' THEN '06' ELSE '00' END) FROM  #table_tmp AS A LEFT JOIN TS_Phase AS B ON A.PHASE_ID = B.F_PhaseID WHERE A.IS_POOL = 1
	UPDATE #table_tmp SET POOL = '00' WHERE IS_POOL = 0


	DECLARE @MatchDate AS NVARCHAR(10)
	DECLARE @DelegationCode AS NVARCHAR(10)
	SET @MatchDate = ''
	SET @DelegationCode = ''

	IF @DateID <> -1  
	BEGIN
		SELECT @MatchDate = 'D_' + CONVERT(NVARCHAR(8), F_Date, 112) FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DateID
	END	
	
	IF @DelegationID <> -1
	BEGIN
	    SELECT @DelegationCode = 'C_' + F_DelegationCode FROM TC_Delegation WHERE F_DelegationID = @DelegationID
	END
	
	IF @ReportType IN ('C73B', 'C74B', 'C84B') AND @MatchID <> -1
	BEGIN
	    DECLARE @SexCode AS INT
		DECLARE @TeamEventID AS INT

		SELECT @SexCode = E.F_SexCode FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID WHERE M.F_MatchID = @MatchID
	    
		SELECT TOP 1 @TeamEventID = F_EventID FROM TS_Event WHERE F_SexCode = @SexCode AND F_PlayerRegTypeID = 3
		
		UPDATE #table_tmp SET [EVENT] = B.F_EventCode, EVENT_PARENT = B.F_EventCode FROM TS_Event AS B WHERE B.F_EventID = @TeamEventID
	END
	
	UPDATE #table_tmp SET [KEY] = N'GO' + SEX + [dbo].[Func_GF_GetOutputEventCode](SEX, [EVENT]) + PHASE + EVENT_UNIT

	SELECT [KEY] FROM #table_tmp

SET NOCOUNT OFF
END



GO



