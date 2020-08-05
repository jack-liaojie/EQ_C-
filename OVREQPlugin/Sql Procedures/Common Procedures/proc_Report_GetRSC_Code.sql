
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_Report_GetRSC_Code]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_Report_GetRSC_Code]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----作		  者：穆学峰 
----日		  期: 2010-1-28 
/*
	修改	日期			内容
	zj		2010-06-04		@tmp_UnitCode = Right(F_MatchCode,2) @tmp_DisciplineCode = Right(F_DisciplineCode,2) 
							@tmp_EventCode = Right(F_EventCode, 3)
	ZJ		2010/10/19		ADD IF Z74A	Z74B
	dnc		2011-1-6		改变 Event Unit 的位数.
*/

CREATE PROCEDURE [dbo].[proc_Report_GetRSC_Code]
	@DisciplineID	int,
	@EventID	int,
	@PhaseID	int,
	@MatchId	int,
	@reportType nvarchar(100) = ''
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #table_tmp(
			[KEY]	nvarchar(100),
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

	DECLARE @tmp_DisciplineCode Nchar(2)
	DECLARE @tmp_SexCode Nchar(1)
	DECLARE @tmp_EventCode Nchar(3)
	DECLARE @tmp_PhaseCode Nchar(1)
	DECLARE @tmp_UnitCode Nchar(5)
	DECLARE @tmp_sex int


	IF @MatchID <> -1
	BEGIN
		SELECT @tmp_PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchId
		SELECT @tmp_UnitCode = Right(F_MatchCode,2) FROM TS_MATCH WHERE F_MATCHID = @MatchId
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

	SELECT @tmp_DisciplineCode = Right(F_DisciplineCode,2) FROM TS_Discipline WHERE F_DisciplineId = @tmp_DisciplineID
	SELECT @tmp_EventCode = Right(F_EventCode, 3) FROM TS_Event WHERE F_EventID = @tmp_EventID
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
				PHASE = @tmp_PhaseCode, EVENT_UNIT = @tmp_UnitCode

	UPDATE #table_tmp SET FATHER_PHASE_ID = F_FatherPhaseID FROM  #table_tmp AS A LEFT JOIN TS_Phase AS B ON A.PHASE_ID = B.F_PhaseID WHERE A.IS_POOL = 1
	UPDATE #table_tmp SET FATHER_PHASE_ID = PHASE_ID WHERE IS_POOL = 1 AND (FATHER_PHASE_ID = 0 OR FATHER_PHASE_ID IS NULL)
	UPDATE #table_tmp SET PHASE = left(B.F_PhaseCode,1) FROM  #table_tmp AS A LEFT JOIN TS_Phase AS B ON A.FATHER_PHASE_ID = B.F_PhaseID WHERE A.IS_POOL = 1
	UPDATE #table_tmp SET POOL = cast(ltrim(B.F_PhaseCode) as nchar(2)) FROM  #table_tmp AS A LEFT JOIN TS_Phase AS B ON A.PHASE_ID = B.F_PhaseID WHERE A.IS_POOL = 1
	UPDATE #table_tmp SET POOL = '00' WHERE IS_POOL = 0


	IF SUBSTRING(@reportType,1,4) = 'C74B' OR SUBSTRING(@reportType,1,4) = 'Z74B'
	BEGIN
		UPDATE #table_tmp SET PHASE = '0', EVENT_UNIT = '00'
	END
	
	IF SUBSTRING(@reportType,1,4) = 'C74A' OR SUBSTRING(@reportType,1,4) = 'Z74A'
	BEGIN
		DECLARE @matchDate AS DATETIME
		SELECT @matchDate = F_MatchDate FROM TS_MATCH WHERE F_MatchID = @MatchId
		UPDATE #table_tmp SET PHASE = 'Y', EVENT_UNIT = datename(d, @matchDate)
	END

	UPDATE #table_tmp SET [KEY] = DISCIPLINE + SEX + [EVENT] + PHASE + EVENT_UNIT 
	
	IF @reportType <> '' AND @reportType IS NOT NULL
	BEGIN
		UPDATE #table_tmp SET [KEY] = [KEY] + '_' + @reportType
	END

	SELECT [KEY] FROM #table_tmp


SET NOCOUNT OFF
END

GO

-- exec proc_Report_GetRSC_Code -1,-1,-1,128,'C74A 1.0'