IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_JU_GetTeamMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_JU_GetTeamMatchResult]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    ��: [Proc_TVG_JU_GetTeamMatchResult]
--��    ��: �����Ŀ��ȡһ���������� Match ��result  
--�� �� ��: ��˳��
--��    ��: 2011��05��31�� ���ڶ�
--�޸ļ�¼��
/*			
	ʱ��					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_TVG_JU_GetTeamMatchResult]
	@MatchID						INT,
	@LanguageCode					CHAR(3) = N'ENG'		-- Ĭ��ȡ��ǰ���������
AS
BEGIN
SET NOCOUNT ON

	
	select 
		ED.F_EventLongName AS EventName
		,case when MRA.F_ResultID=1 OR MRA.F_ResultID=2 then N'Result - ' else N'' end +
		PD.F_PhaseLongName+' Match '+CONVERT(NVARCHAR(10),Convert(int,M.F_MatchCode)) 	AS PhaseName
		,N'[Image]'+DA.F_DelegationCode AS flag
		,RDa.F_TvLongName AS Name
		,MRA.F_WinSets AS Score
		,case when MRa.F_CompetitionPosition=1 then N'[Image]Card_Blue' else N'[Image]Card_White' END AS Image_Color 
		,RDA.F_TvShortName AS Name_Short
	from TS_Match AS M
	LEFT JOIN TS_Phase AS P
		ON P.F_PhaseID=M.F_PhaseID 
	LEFT JOIN TS_Phase_Des AS PD 
		ON P.F_PhaseID=PD.F_PhaseID AND PD.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Event_Des AS ED
		ON P.F_EventID=Ed.F_EventID AND Ed.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Match_Result AS MRA
		ON M.F_MatchID=MRA.F_MatchID 
	LEFT JOIN TR_Register AS RA
		ON RA.F_RegisterID=MRA.F_RegisterID
	LEFT JOIN TC_Delegation AS DA
		ON RA.F_DelegationID=DA.F_DelegationID
	LEFT JOIN TR_Register_Des AS RDA
		ON RA.F_RegisterID=RDA.F_RegisterID AND RDA.F_LanguageCode=N'ENG'
		

		
	
	WHERE M.F_MatchID=@MatchID
	
	

SET NOCOUNT OFF
END


/*

-- Just for test
EXEC [Proc_TVG_JU_GetTeamMatchResult] 2
*/