IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_JU_GetMatchWinner]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_JU_GetMatchWinner]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    ��: [Proc_TVG_JU_GetMatchWinner]
--��    ��: �����Ŀ��ȡһ�� Match ��Winner  
--�� �� ��: ��˳��
--��    ��: 2011��05��9�� ����һ
--�޸ļ�¼��
/*			
	ʱ��					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_TVG_JU_GetMatchWinner]
	@MatchID						INT,
	@LanguageCode					CHAR(3) = N'ENG'		-- Ĭ��ȡ��ǰ���������
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @PlayerRegTypeID		INT	
	SELECT @PlayerRegTypeID = E.F_PlayerRegTypeID
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	WHERE M.F_MatchID = @MatchID
	
		select 
				ED.F_EventLongName AS [EventName]
				,case when @PlayerRegTypeID=3 then N'Winner-'+ PD.F_PhaseLongName else  PD.F_PhaseLongName end AS [PhaseName]
				,N'[Image]'+D.F_DelegationCode AS [Noc]
				,RD.F_TvLongName AS [Name]
				,case when MR.F_CompetitionPosition=1 then N'[Image]Card_Blue'
					when MR.F_CompetitionPosition=2 then N'[Image]Card_White'
					else N'' end AS Color
				, N'Winner by '+DD.F_DecisionLongName AS WinnerType
				,RD.F_TvShortName AS [Name_Short]
		from TS_Match AS M
		LEFT JOIN TC_Decision_Des AS DD
			ON DD.F_DecisionID=M.F_DecisionID AND DD.F_LanguageCode=N'ENG'
		LEFT JOIN TS_Phase AS P
			ON M.F_PhaseID=P.F_PhaseID
		LEFT JOIN TS_Phase_Des as PD
			ON PD.F_PhaseID=P.F_PhaseID AND PD.F_LanguageCode=N'ENG'
		LEFT JOIN TS_Event_Des AS ED
			ON ED.F_EventID=P.F_EventID AND ED.F_LanguageCode=N'ENG'
		LEFT JOIN TS_Match_Result AS MR 
			ON M.F_MatchID=MR.F_MatchID AND MR.F_ResultID=1
		LEFT JOIN TR_Register AS R
			ON R.F_RegisterID=MR.F_RegisterID 
		LEFT JOIN TC_Delegation AS D
			ON D.F_DelegationID=R.F_DelegationID
		LEFT JOIN TR_Register_Des AS RD
			ON RD.F_RegisterID=R.F_RegisterID AND RD.F_LanguageCode=N'ENG'
		where M.F_MatchID=@MatchID
SET NOCOUNT OFF
END


/*

-- Just for test
EXEC [Proc_TVG_JU_GetMatchWinner] 433
*/