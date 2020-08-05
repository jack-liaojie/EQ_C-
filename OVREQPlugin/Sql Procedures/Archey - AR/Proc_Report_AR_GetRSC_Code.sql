IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_GetRSC_Code]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_GetRSC_Code]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_Report_AR_GetRSC_Code]
--描    述: 射箭项目报表获取 RSC Code, 即 DISCIPLINE(2), SEX(1), EVENT(3), EVENT_PARENT(3), PHASE(1), POOL(2), EVENT_UNIT(5) 等连接起来的字符串. 
--参数说明: 
--说    明: 
--创 建 人: 崔凯	
--日    期: 2011年10月18日
--修改记录：
/*			
			时间				修改人		修改内容
			2010年01月11日		邓年彩		初版, 添加公用模板的情况.
*/



CREATE PROCEDURE [dbo].[Proc_Report_AR_GetRSC_Code]
	@DisciplineID					INT,
	@EventID						INT,
	@PhaseID						INT,
	@MatchID						INT,
	@DateID							INT,
	@SessionID						INT,
	@ReportType						NVARCHAR(20),
	@DelegationID					INT = -1
AS
BEGIN
SET NOCOUNT ON

	DECLARE @DisciplineCode			CHAR(2)
	DECLARE @Gender					CHAR(1)
	DECLARE @EventCode				CHAR(3)
	DECLARE @Phase					CHAR(1)
	DECLARE @EventUnit				CHAR(2)
	DECLARE @KEY					NVARCHAR(50)
	DECLARE @MatchDate				DATETIME
	DECLARE @Date					NVARCHAR(20)
	
	SET @DisciplineCode = '00'
	SET @Gender = '0'
	SET @EventCode = '000'
	SET @Phase = '0'
	SET @EventUnit = '00'
	SET @KEY = N''
	SET @Date = N''
	SELECT @MatchDate= A.F_MatchDate FROM TS_Match AS A 
        LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_Event AS D ON B.F_EventID = D.F_EventID 
        WHERE D.F_EventID = @EventID AND A.F_MatchCode !='QR'
	
	------------------------------------------------------------------------------------------------------
	-- 对 @DisciplineID, @EventID, @PhaseID, @MatchID 进行预处理
	------------------------------------------------------------------------------------------------------
	IF @MatchID > 0
		SELECT @PhaseID = M.F_PhaseID FROM TS_Match AS M WHERE M.F_MatchID = @MatchID
	
	IF @PhaseID > 0
		SELECT @EventID = P.F_EventID FROM TS_Phase AS P WHERE P.F_PhaseID = @PhaseID
	
	IF @EventID > 0
		SELECT @DisciplineID = E.F_DisciplineID FROM TS_Event AS E WHERE E.F_EventID = @EventID
	
	IF @DisciplineID = -1
		SELECT @DisciplineID = D.F_DisciplineID FROM TS_Discipline AS D WHERE D.F_Active = 1
	
	------------------------------------------------------------------------------------------------------
	-- 根据 @ReportType 调整 @DisciplineID, @EventID, @PhaseID, @MatchID
	------------------------------------------------------------------------------------------------------
	/*	AR - Archery (射箭) 所需报表
		(1) C08 - Competition Schedule
		(2) C30 - Number of Entries by NOC
	    (3) C32B - Entry List by Name
		(4) C32E - Entry List by NOC
		(5) C38 - Entry Data Checklist
		(6) C51A - Start List by Target
		(7) C51B - Start List by NOC
		(8) C51C - Start Brackets(Individual)
		(9) C51D - Start Brackets(Team)
		(10) C58 - Detailed Daily Competition Schedule
		(11) C73A - Results(Individual - Ranking Round)
		(12) C73B - Results(Team - Ranking Round)
		(13) C74A - Results Summary(Individual)
		(14) C74B - Results Summary(Team)
		(15) C75A - Results Brackets(Individual Elimination Rounds)
		(16) C75B - Results Brackets(Individual Finals Rounds)
		(17) C75C - Results Brackets(Team)
		(18) C92A - Medallists(Individual)
		(19) C92A - Medallists(Team)
		(20) C93 - Medallists by Event
		(21) C95 - Medal Standings
		(22) C67 - Official Communication
	*/		
	
	-- 参数 @DisciplineID 有效
	-- (1) C08 - Competition Schedule
	-- (2) C30 - Number of Entries by NOC
	-- (3) C32B - Entry List by Name					(4) C32E - Entry List by NOC			(5) C38 - Entry Data Checklist
	--(10) C58 - Detailed Daily Competition Schedule
	--(22) C67 (Official Communication),				(20) C93 - Medallists by Event,			(21) C95 - Medal Standings
	IF @ReportType = N'C08' OR @ReportType = N'C30'  
		OR @ReportType = N'C32B' OR @ReportType = N'C32E'
		OR @ReportType = N'C38'  OR @ReportType = N'C39' 
		OR @ReportType = N'C67'  OR @ReportType = N'C93' OR @ReportType = N'C95'
	BEGIN
		SET @EventID = NULL
		SET @PhaseID = NULL
		SET @MatchID = NULL
	END	
	
	-- 参数 @DisciplineID, @EventID 有效	
	--(11) C73A - Results(Individual - Ranking Round)					(12) C73B - Results(Team - Ranking Round)
	--(13) C74A - Results Summary(Individual)							(14) C74B - Results Summary(Team)
	--(15) C75A - Results Brackets(Individual Elimination Rounds)		(16) C75B - Results Brackets(Individual Finals Rounds)
	--(17) C75C - Results Brackets(Team) 
	--(18)  C92A - Medallists(Individual)								(19) C92A - Medallists(Team)
	
	ELSE IF  @ReportType = N'C73A'  OR @ReportType = N'C73B' 
		  OR @ReportType = N'C74A'  OR @ReportType = N'C74B'  OR @ReportType = N'C58' 
		  OR @ReportType = N'C75A'  OR @ReportType = N'C75B'  OR @ReportType = N'C75C' 
		  OR @ReportType = N'C92A'  OR @ReportType = N'C92B' 
	BEGIN
		SET @PhaseID = NULL
		SET @MatchID = NULL
	END
	
	------------------------------------------------------------------------------------------------------
	-- 获取 @DisciplineCode(2), @Gender(1), @EventCode(3), @Phase(1), @EventUnit(2)
	------------------------------------------------------------------------------------------------------
	SELECT @DisciplineCode = RIGHT(D.F_DisciplineCode, 2)
	FROM TS_Discipline AS D
	WHERE D.F_DisciplineID = @DisciplineID
	
	SELECT @Gender = RIGHT(S.F_GenderCode, 1)
		, @EventCode = RIGHT(E.F_EventCode, 3)
	FROM TS_Event AS E
	LEFT JOIN TC_Sex AS S
		ON E.F_SexCode = S.F_SexCode
	WHERE E.F_EventID = @EventID
	
	SELECT @Phase = RIGHT(P.F_PhaseCode, 1)
	FROM TS_Phase AS P
	WHERE P.F_PhaseID = @PhaseID
	
	SELECT @EventUnit = RIGHT('00' + M.F_MatchCode, 2)
	FROM TS_Match AS M
	WHERE M.F_MatchID = @MatchID
	
	------------------------------------------------------------------------------------------------------
	-- 获取 RSC Code + '.'
	------------------------------------------------------------------------------------------------------
	SET @KEY = @DisciplineCode + @Gender + @EventCode + @Phase + @EventUnit
		
	IF(@ReportType = N'C58')
	BEGIN		
		SET @Date = N'.D_' + CONVERT(varchar(100), @MatchDate, 112)
		SET @KEY = @KEY + @Date
	END
	------------------------------------------------------------------------------------------------------
	-- 获取相关参数
	------------------------------------------------------------------------------------------------------
	--IF (@ReportType = N'C32A' OR @ReportType = N'C38') AND @DelegationID <> -1
	--BEGIN
	--	SELECT @KEY = @KEY + N'C_' + D.F_DelegationCode
	--	FROM TC_Delegation AS D
	--	WHERE D.F_DelegationID = @DelegationID
	--END

	------------------------------------------------------------------------------------------------------
	-- 返回数据集
	------------------------------------------------------------------------------------------------------
	SELECT @KEY AS [KEY],@Date

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_AR_GetRSC_Code] NULL, NULL, NULL, NULL, NULL, NULL, N'ALL'
EXEC [Proc_Report_AR_GetRSC_Code] 1, 1, 1, 1, 1, NULL, N'C73A'

*/
GO


