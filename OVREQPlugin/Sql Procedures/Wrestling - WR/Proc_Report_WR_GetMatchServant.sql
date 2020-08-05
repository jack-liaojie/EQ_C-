IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WR_GetMatchServant]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WR_GetMatchServant]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_WR_GetMatchServant]
--描    述: 获取一场比赛的裁判.
--创 建 人: 宁顺泽
--日    期: 2011年10月18日 星期2
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Report_WR_GetMatchServant]
	@MatchID						INT,
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	--SELECT MS.F_Order AS [Order] 
	--	, R.F_Bib AS [No]
	--	, FD.F_FunctionLongName AS [Function]
	--	, RD.F_PrintLongName AS [Name]
	--	, R.F_NOC AS [NOC]
	--FROM TS_Match_Servant AS MS
	--LEFT JOIN TR_Register AS R
	--	ON MS.F_RegisterID = R.F_RegisterID
	--LEFT JOIN TR_Register_Des AS RD
	--	ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	--LEFT JOIN TD_Function_Des AS FD
	--	ON MS.F_FunctionID = FD.F_FunctionID AND FD.F_LanguageCode = @LanguageCode
	--WHERE MS.F_MatchID = @MatchID
	--ORDER BY MS.F_Order
	
	select Re.Bib AS RefereeNo
			,Ju.Bib as JudgeNo
			,MC.Bib as MatChairmanNo
	from TS_Match as M
	LEft JOIN 
	(
		select D.F_DelegationCode AS NOC
			,FD.F_FunctionLongName aS FunctionName
			,R.F_RegisterID AS RegisterID
			,R.F_Bib AS Bib
			,MS.F_MatchID
		from TS_Match_Servant AS MS
		LEFT JOIN TR_Register AS R
			ON MS.F_RegisterID=R.F_RegisterID 
		LEFT JOIN TC_Delegation as D
			ON R.F_DelegationID=D.F_DelegationID
		LEFT JOIN TD_Function_Des AS FD
			ON FD.F_FunctionID=MS.F_FunctionID and FD.F_LanguageCode=N'ENG'
		where F_MatchID=@MatchID
	) AS Re
	ON RE.F_MatchID=M.F_MatchID and Re.FunctionName=N'Referee'
	LEFT JOIN 
	(
		select D.F_DelegationCode AS NOC
			,FD.F_FunctionLongName aS FunctionName
			,R.F_RegisterID AS RegisterID
			,R.F_Bib AS Bib
			,MS.F_MatchID
		from TS_Match_Servant AS MS
		LEFT JOIN TR_Register AS R
			ON MS.F_RegisterID=R.F_RegisterID 
		LEFT JOIN TC_Delegation as D
			ON R.F_DelegationID=D.F_DelegationID
		LEFT JOIN TD_Function_Des AS FD
			ON FD.F_FunctionID=MS.F_FunctionID and FD.F_LanguageCode=N'ENG'
		where F_MatchID=@MatchID
	) AS Ju
	ON Ju.F_MatchID=M.F_MatchID and Ju.FunctionName=N'Judge'
	LEFT JOIN 
	(
		select D.F_DelegationCode AS NOC
			,FD.F_FunctionLongName aS FunctionName
			,R.F_RegisterID AS RegisterID
			,R.F_Bib AS Bib
			,MS.F_MatchID
		from TS_Match_Servant AS MS
		LEFT JOIN TR_Register AS R
			ON MS.F_RegisterID=R.F_RegisterID 
		LEFT JOIN TC_Delegation as D
			ON R.F_DelegationID=D.F_DelegationID
		LEFT JOIN TD_Function_Des AS FD
			ON FD.F_FunctionID=MS.F_FunctionID and FD.F_LanguageCode=N'ENG'
		where F_MatchID=@MatchID
	) AS MC
	ON MC.F_MatchID=M.F_MatchID and MC.FunctionName=N'Mat Chairman'
	where m.F_MatchID=@MatchID
	

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_WR_GetMatchServant] 2, 'ENG'

*/