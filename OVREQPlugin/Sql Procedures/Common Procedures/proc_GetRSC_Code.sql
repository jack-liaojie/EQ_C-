IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetRSC_Code]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_GetRSC_Code]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--描    述: 报表获取RSC Code。
--参数说明: 
--说    明: 
--创 建 人: 余远华
--日    期: 2011年03月27日

CREATE PROCEDURE [dbo].[proc_GetRSC_Code]
	@DisciplineID	int,
	@EventID	int,
	@PhaseID	int,
	@MatchId	int,
	@DateId		int = -1,
	@ReportType nvarchar(100) = ''
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #RSC_Code
	(
		[DISCIPLINE]				CHAR(2),
		[SEX]						CHAR(1),
		[EVENT]						CHAR(3),
		[PHASE]						CHAR(1),
		[EVENT_UNIT]				CHAR(2)
	)

	INSERT #RSC_Code
	([DISCIPLINE], [SEX], [EVENT], [PHASE], [EVENT_UNIT])
	VALUES
	('00', '0', '000', '0', '00')

	-- 参数 @MatchID 有效
	IF @MatchID > 0
	BEGIN
		UPDATE #RSC_Code
		SET [DISCIPLINE] = D.F_DisciplineCode
			, [SEX] = E.F_GenderCode
			, [EVENT] = C.F_EventCode
			, [PHASE] = B.F_PhaseCode
			, [EVENT_UNIT] = Right('00' + CAST(A.F_MatchCode AS NVARCHAR(10)), 2)
		FROM TS_Match AS A
		LEFT JOIN TS_Phase AS B
			ON A.F_PhaseID = B.F_PhaseID
		LEFT JOIN TS_Event AS C
			ON B.F_EventID = C.F_EventID
		LEFT JOIN TS_Discipline AS D
			ON C.F_DisciplineID = D.F_DisciplineID
		LEFT JOIN TC_Sex AS E
			ON C.F_SexCode = E.F_SexCode
		WHERE A.F_MatchID = @MatchID
	END

	-- 参数 @PhaseID 有效
	ELSE IF @PhaseID > 0
	BEGIN
		UPDATE #RSC_Code
		SET [DISCIPLINE] = C.F_DisciplineCode
			, [SEX] = D.F_GenderCode
			, [EVENT] = B.F_EventCode
			, [PHASE] = A.F_PhaseCode
		FROM TS_Phase AS A
		LEFT JOIN TS_Event AS B
			ON A.F_EventID = B.F_EventID
		LEFT JOIN TS_Discipline AS C
			ON B.F_DisciplineID = C.F_DisciplineID
		LEFT JOIN TC_Sex AS D
			ON B.F_SexCode = D.F_SexCode
		WHERE A.F_PhaseID = @PhaseID
	END

	-- 参数 @EventID 有效
	ELSE IF @EventID > 0
	BEGIN
		UPDATE #RSC_Code
		SET [DISCIPLINE] = B.F_DisciplineCode
			, [SEX] = C.F_GenderCode
			, [EVENT] = A.F_EventCode
		FROM TS_Event AS A
		LEFT JOIN TS_Discipline AS B
			ON A.F_DisciplineID = B.F_DisciplineID
		LEFT JOIN TC_Sex AS C
			ON A.F_SexCode = C.F_SexCode
		WHERE A.F_EventID = @EventID
	END

	-- 参数 @DisciplineID 有效
	ELSE IF @DisciplineID > 0
	BEGIN
		UPDATE #RSC_Code
		SET [DISCIPLINE] = A.F_DisciplineCode
		FROM TS_Discipline AS A
		WHERE A.F_DisciplineID = @DisciplineID
	END

	--崔凯：举重比赛Unit只取抓举比赛MatchCode
	DECLARE @DisciplineCode		varchar(5)
	DECLARE @EventUnit			varchar(5)
	SELECT @DisciplineCode= D.F_DisciplineCode 
		FROM TS_Match AS A
		LEFT JOIN TS_Phase AS B
			ON A.F_PhaseID = B.F_PhaseID
		LEFT JOIN TS_Event AS C
			ON B.F_EventID = C.F_EventID
		LEFT JOIN TS_Discipline AS D
			ON C.F_DisciplineID = D.F_DisciplineID
		LEFT JOIN TC_Sex AS E
			ON C.F_SexCode = E.F_SexCode
		WHERE A.F_MatchID = @MatchID
	IF @DisciplineCode ='WL'
	BEGIN
		SET @EventUnit = '01'
		SELECT [DISCIPLINE] + [SEX] + [EVENT] + [PHASE] + @EventUnit AS [KEY]
		FROM #RSC_Code
	END
	ELSE
	BEGIN	
		SELECT [DISCIPLINE] + [SEX] + [EVENT] + [PHASE] + [EVENT_UNIT] AS [KEY]
		FROM #RSC_Code
	END


SET NOCOUNT OFF
END



GO


