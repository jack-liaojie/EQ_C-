IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_JU_GetTeamMember]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_JU_GetTeamMember]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    ��: [[Proc_TVG_JU_GetTeamMember]]
--��    ��: �����Ŀ��ȡһ���������� Match ��result  
--�� �� ��: ��˳��
--��    ��: 2011��05��31�� ���ڶ�
--�޸ļ�¼��
/*			
	ʱ��					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_TVG_JU_GetTeamMember]
	@MatchID						INT,
	@Compos							INT,
	@LanguageCode					CHAR(3) = N'ENG'		-- Ĭ��ȡ��ǰ���������
AS
BEGIN
SET NOCOUNT ON

	select 
	N'[Image]'+R.F_NOC AS flag,
	dd.F_DelegationLongName aS TeamName,
	Rd.F_TvLongName AS Name,
	MSI.F_Memo,
	case when @Compos=1 then N'[Image]Card_Blue' else N'[Image]Card_White' end AS Color
	,Rd.F_TvShortName AS Name_Short
from TS_Match AS M
LEFT JOIN TS_Match_Result AS MR
	ON M.F_MatchID=MR.F_MatchID AND MR.F_CompetitionPosition=@Compos
LEFT JOIN TS_Match_Split_Result AS MSR
	ON MR.F_MatchID=MSR.F_MatchID AND MSR.F_CompetitionPosition=MR.F_CompetitionPosition AND ISNULL(MSR.F_RegisterID,-1)<>-1
LEFT JOIN TS_Match_Split_Info AS MSI
	ON MSI.F_MatchID=MSR.F_MatchID AND MSI.F_MatchSplitID=MSR.F_MatchSplitID
LEFT JOIN TR_Register AS R
	ON R.F_RegisterID=MSR.F_RegisterID
LEFT JOIN TR_Register_Des AS RD
	ON Rd.F_RegisterID=R.F_RegisterID AND RD.F_LanguageCode=N'ENG'
LEFT JOIN TC_Delegation_Des AS Dd
	ON Dd.F_DelegationID=R.F_DelegationID AND DD.F_LanguageCode=N'ENG'

where M.F_MatchID=@MatchID
		
SET NOCOUNT OFF	
		
		
END	
/*		
-- Just for tes
EXEC [Proc_TVG_JU_GetTeamMatchResult] 2
*/