IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_WR_Promotion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_WR_Promotion]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称: [Proc_TVG_JU_Promotion]
--描    述: 8To4  or  4To2(晋级）
--创 建 人: 宁顺泽
--日    期: 2011年05月9日 星期一
--修改记录：
/*			
	时间					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_TVG_WR_Promotion]
	@EventID						INT,
	@PhaseCode						NVARCHAR(50),
	@LanguageCode					CHAR(3) = N'ENG'		-- 默认取当前激活的语言
AS
BEGIN
SET NOCOUNT ON
		
		select 
			ED.F_EventLongName
			,N'[Image]'+D1.F_DelegationCode AS [Flag1]
			,N'[Image]'+D2.F_DelegationCode AS [Flag2]
			,N'[Image]'+D3.F_DelegationCode AS [Flag3]
			,RD1.F_TvLongName AS [Name1]
			,RD2.F_TvLongName AS [Name2]
			,RD3.F_TvLongName AS [Name3]
			,case when MR1.F_ResultID=2 then '1' else '' end as [mark1]
			,case when MR2.F_ResultID=2 then '1' else '' end as [mark2]
			,RD1.F_TvShortName AS Name1_Short
			,RD2.F_TvShortName AS Name2_Short
			,RD3.F_TvShortName AS Name3_Short
		from TS_Match AS M
		LEFT JOIN TS_Phase AS P 
			ON P.F_PhaseID=M.F_PhaseID
		LEFT JOIN TS_Phase_Des AS PD
			ON PD.F_PhaseID=P.F_PhaseID AND PD.F_LanguageCode=@LanguageCode
		LEFT JOIN TS_Event AS E
			ON E.F_EventID=P.F_EventID
		LEFT JOIN TS_Event_Des AS ED
			ON E.F_EventID=ED.F_EventID AND ED.F_LanguageCode=@LanguageCode
		LEFT JOIN TS_Match_Result AS MR1
			ON M.F_MatchID=MR1.F_MatchID AND MR1.F_CompetitionPosition=1
		LEFT JOIN TR_Register AS R1
			ON R1.F_RegisterID=MR1.F_RegisterID
		LEFT JOIN TC_Delegation AS D1
			ON D1.F_DelegationID=R1.F_DelegationID
		LEFT JOIN TR_Register_Des AS RD1
			ON RD1.F_RegisterID=R1.F_RegisterID AND RD1.F_LanguageCode=@LanguageCode
		
		LEFT JOIN TS_Match_Result AS MR2
			ON M.F_MatchID=MR2.F_MatchID AND MR2.F_CompetitionPosition=2
		LEFT JOIN TR_Register AS R2
			ON R2.F_RegisterID=MR2.F_RegisterID
		LEFT JOIN TC_Delegation AS D2
			ON D2.F_DelegationID=R2.F_DelegationID
		LEFT JOIN TR_Register_Des AS RD2
			ON RD2.F_RegisterID=R2.F_RegisterID AND RD2.F_LanguageCode=@LanguageCode
		
		LEFT JOIN TS_Match_Result AS MR3
			ON M.F_MatchID=MR3.F_MatchID AND MR3.F_ResultID=1
		LEFT JOIN TR_Register AS R3
			ON R3.F_RegisterID=MR3.F_RegisterID
		LEFT JOIN TC_Delegation AS D3
			ON D3.F_DelegationID=R3.F_DelegationID
		LEFT JOIN TR_Register_Des AS RD3
			ON RD3.F_RegisterID=R3.F_RegisterID AND RD3.F_LanguageCode=@LanguageCode
				
		WHERE E.F_EventID=@EventID AND PD.F_PhaseLongName=@PhaseCode
		
		
SET NOCOUNT OFF
END


/*

-- Just for test
EXEC [Proc_TVG_JU_Promotion] 6,N'Quarterfinal'
*/