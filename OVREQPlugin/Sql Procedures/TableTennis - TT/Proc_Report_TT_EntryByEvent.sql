IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TT_EntryByEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TT_EntryByEvent]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称: [Proc_Report_TT_EntryByEvent]
--描    述: 获取 Entry By Event 的主要内容, 用于 Karate 的 Entry By Event 的报表
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年09月08日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月15日		邓年彩		添加 EventID 参数, 打印报表时可以打印所有小项或单个小项
			2009年11月10日		邓年彩		根据条件不同构造 SQL 语句简化存储过程
			2009年11月24日		邓年彩		NOCCode 不从 Delegation 中取, 从 Delegation 中取, 取出 NOC 长名和短命
			2010年1月12日		邓年彩		添加参数@DisciplineID; NOC 从 TC_Country 中取; 添加字段 Height; 
											详细信息统一最后去除, 方便以后维护查询; 条件添加运动员的限制.
			2010年1月13日		邓年彩		根据 Sport 的 GroupType 来选择 NOC 的来源.
			2010年1月15日		邓年彩		添加字段 [DrawPosition].
			2010年1月28日		邓年彩		日期取大写.
			2010年2月4日		邓年彩		取日期使用统一的函数 [Func_Report_KR_GetDateTime], 日期不以 0 开头.
			2010年6月9日		邓年彩		出生日期均取英文的日期.
			2010年9月27日		邓年彩		不使用组合 SQL; 由于 TR_Register.F_Height 由 INT 改为 DECIMAL 型, 故修改转化.
			2011年3月9日        李燕        增加F_InscriptionRank字段
*/


CREATE PROCEDURE [dbo].[Proc_Report_TT_EntryByEvent]
	@DisciplineID				INT,
	@EventID					INT,		-- EventID <= 0 时打印所有小项
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @GroupType			INT
	
	-- 确定 @GroupType 
	-- GroupType: 1 - Federation, 2 - NOC, 3 - Club, 4 - Delegation. 
	-- 目前只考虑 2 - NOC 和 4 - Delegation 这两种情况, 优先考虑 4 - Delegation.
	SELECT @GroupType = SC.F_ConfigValue
	FROM TS_Sport_Config AS SC
	INNER JOIN TS_Discipline AS D
		ON SC.F_SportID = D.F_SportID
	WHERE D.F_DisciplineID = @DisciplineID
		AND SC.F_ConfigType = 1 AND SC.F_ConfigName = N'GroupType'
	
	SELECT X.F_EventID AS [EventID]
			, [NOC] = CASE @GroupType WHEN 2 THEN R.F_NOC ELSE D.F_DelegationCode END
			, [NOCLongName] = CASE @GroupType WHEN 2 THEN CD.F_CountryLongName ELSE DD.F_DelegationLongName END
			, MR.F_Bib AS [Bib]
			, RD.F_LongName AS [Name]
			, dbo.[Func_Report_TE_GetDateTime](MR.F_Birth_Date, 1, 'ENG') AS [BirthDate]
			, LEFT(CONVERT(INT, ROUND(MR.F_Height, 0)) / 100.0, 4) + ' / ' 
				+ CONVERT(NVARCHAR(2), CONVERT(INT, ROUND(MR.F_Height, 0)) * 100 / 3048) + '''' 
				+ CONVERT(NVARCHAR(2), (CONVERT(INT, ROUND(MR.F_Height, 0)) * 100 / 254) % 12) + '"' AS [Height]
			, CONVERT(NVARCHAR(3), CONVERT(INT, ROUND(MR.F_Weight, 0))) + ' / ' 
			  + CONVERT(NVARCHAR(5), CONVERT(INT, ROUND(MR.F_Weight, 0)) * 22 / 10) AS [Weight]
			, X.F_InscriptionRank AS [TechOrder]
			, X.F_RegisterID AS [RegisterID]
			, S.F_GenderCode AS [Gender]
		FROM 
		(
			-- 单人项目
			SELECT I.F_EventID
				, I.F_RegisterID
				, I.F_RegisterID AS F_MemberRegisterID
				, I.F_InscriptionRank
			FROM TR_Inscription AS I
			LEFT JOIN TS_Event AS E
				ON I.F_EventID = E.F_EventID
			LEFT JOIN TR_Register AS R
				ON I.F_RegisterID = R.F_RegisterID
			WHERE E.F_PlayerRegTypeID = 1 
				AND E.F_DisciplineID = @DisciplineID
				AND R.F_RegTypeID = 1
				AND (@EventID = -1 OR I.F_EventID = @EventID)
				
			UNION
			
			-- 多人项目
			SELECT I.F_EventID
				, I.F_RegisterID
				, RM.F_MemberRegisterID
				, TR1.F_InscriptionRank
			FROM TR_Inscription AS I
			LEFT JOIN TS_Event AS E
				ON I.F_EventID = E.F_EventID
			LEFT JOIN TR_Register_Member AS RM
				ON I.F_RegisterID = RM.F_RegisterID
			LEFT JOIN TR_Register AS R
				ON RM.F_MemberRegisterID = R.F_RegisterID
			LEFT JOIN TR_Inscription AS TR1 ON TR1.F_RegisterID = R.F_RegisterID
			WHERE E.F_PlayerRegTypeID IN (2, 3) 
				AND E.F_DisciplineID = @DisciplineID
				AND R.F_RegTypeID = 1
				AND (@EventID = -1 OR I.F_EventID = @EventID)
		) AS X
		LEFT JOIN TR_Register AS R
			ON X.F_RegisterID = R.F_RegisterID
		LEFT JOIN TC_Country_Des AS CD
			ON R.F_NOC = CD.F_NOC AND CD.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register AS MR	
			ON X.F_MemberRegisterID = MR.F_RegisterID
		LEFT JOIN TR_Register_Des AS RD
			ON X.F_MemberRegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Delegation AS D
			ON R.F_DelegationID = D.F_DelegationID
		LEFT JOIN TC_Delegation_Des AS DD
			ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode	
		LEFT JOIN TC_Sex AS S 
		    ON MR.F_SexCode = S.F_SexCode
		ORDER BY D.F_DelegationCode, X.F_InscriptionRank 

SET NOCOUNT OFF
END


GO


