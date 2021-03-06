IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetRSC_Code]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetRSC_Code]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--名    称: [Proc_Report_TE_GetRSC_Code]
--描    述: 网球项目报表获取 RSC Code, 即 DISCIPLINE(2), SEX(1), EVENT(3), EVENT_PARENT(3), PHASE(1), POOL(2), EVENT_UNIT(5) 等连接起来的字符串. 
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2010年01月11日
--修改记录：
/*			
			时间				修改人		修改内容
			2010年01月11日		邓年彩		初版, 添加公用模板的情况.
			2010年1月12日		邓年彩		创建临时表, 简化存储过程;
											先根据 @DisciplineID, @EventID, @PhaseID, @MatchID 确定大致的 RSC_Code, 再根据 @ReportType 微调;
											添加模板 C56 (Weigh-in List), C38 (Entry Data Checklist) 的情况.
			2010年01月14日		邓年彩		添加模板 C30 (Number of Entries by NOC) 的情况.
			2010年01月15日		邓年彩		添加模板 C45 (Number Allocation), C51A (Draw Sheet), C51B (Draw Sheet(without contest data)), C51C (Draw Sheet(with contest data)) 的情况.
			2010年1月18日		邓年彩		添加模板 C67 (Official Communication), C92A (Medallists - Individual) 的情况;
											添加模板 C93 (Medallists by Event), C95 (Medal Standings) 的情况.
			2010年1月19日		邓年彩		添加模板 C08 (Competition Schedule) 的情况.
			2010年1月20日		邓年彩		添加参数 @SessionID.
			2010年1月21日		邓年彩		添加模板 C57 (Judge List) 的情况.
			2010年1月27日		邓年彩		添加模板 C75 (Results) 的情况.
			2010年6月21日		邓年彩		改变逻辑方式, 取消临时表的使用; 
											添加参数 @DelegationID; 
											根据 INFO PDF Naming convention v1.3 在RSC Code 后面加 '.' , 并添加参数信息(如 C32A, C38 等).
*/



CREATE PROCEDURE [dbo].[Proc_Report_TE_GetRSC_Code]
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
	
	SET @DisciplineCode = '00'
	SET @Gender = '0'
	SET @EventCode = '000'
	SET @Phase = '0'
	SET @EventUnit = '00'
	SET @KEY = N''
	
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
	/*	TE - Tennis (网球) 所需报表
		(1) C08 - Competition Schedule
		(2) C30 - Number of Entries by NOC
		(3) C32A - Entry List by NOC
	    (4) C32B - Entry List by Name
		(5) C32C - Entry List by Event
		(6) C35 - Competition Officials
		(7) C38 - Entry Data Checklist
		(8) C39 - Entry Data CheckList - Competition Officials
		(9) C47 - Draw Forms 
		(10) C50 - Draw(Initial Version)
		(11) C58 - Daily Match Information
		(12) C73A - Match Statistics – Singles
		(13) C73B - Match Statistics – Doubles
		(14) C75 - Draw(Final Version)
		(15) C92A - Medallists
		(16) C93 - Medallists by Event
		(17) C95 - Medal Standings
		(18) C67 - Official Communication
	*/		
	
	-- 参数 @DisciplineID 有效
	-- (1) C08 - Competition Schedule, (2) C30 - Number of Entries by NOC, (3) C32A - Entry List by NOC, 
	-- (4) C32B - Entry List by Name,  (6) C35 - Competition Officials (10) C58 - Daily Match Information
	-- (5) C38 - Entry Data Checklist, (8) C39 - Entry Data CheckList - Competition Officials
	-- (12) C67 (Official Communication), (16) C93 - Medallists by Event, (17) C95 - Medal Standings
	IF @ReportType = N'C08' OR @ReportType = N'C30'  OR @ReportType = N'C32A' 
	    OR @ReportType = N'C32B' OR @ReportType = N'C35'
		OR @ReportType = N'C38' OR @ReportType = N'C39'  OR @ReportType = N'C58' 
		OR @ReportType = N'C67' OR @ReportType = N'C93' OR @ReportType = N'C95'
	BEGIN
		SET @EventID = NULL
		SET @PhaseID = NULL
		SET @MatchID = NULL
	END	
	
	-- 参数 @DisciplineID, @EventID 有效
	-- (4) C32C - Entry List by Event, (8) C47 - Draw Forms 
	-- (9) C50 - Draw(Initial Version), (13) C75 - Draw(Final Version),  (15) C92A - Medallists
	ELSE IF @ReportType = N'C32C'
		OR @ReportType = N'C47' OR @ReportType = N'C50' OR @ReportType = N'C75A'  OR @ReportType = N'C75B'OR @ReportType = N'C92A' 
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
	SELECT @KEY AS [KEY]

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_TE_GetRSC_Code] NULL, NULL, NULL, NULL, NULL, NULL, N'ALL'
EXEC [Proc_Report_TE_GetRSC_Code] 1, 1, 1, 1, 1, NULL, N'C73A'

*/
