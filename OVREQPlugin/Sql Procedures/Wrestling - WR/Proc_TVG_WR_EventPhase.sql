IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_WR_EventPhase]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_WR_EventPhase]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_TVG_WR_EventPhase]
--��    ��: ��ȡ ÿ������TVG��Event��phase
--�� �� ��: ��˳��
--��    ��: 2011��5��9�� ����1
--�޸ļ�¼��
/*			
	
*/



CREATE PROCEDURE [dbo].[Proc_TVG_WR_EventPhase]
	@MatchID							INT
AS
BEGIN
SET NOCOUNT ON

	select ED.F_EventLongName,PD.F_PhaseLongName from TS_Match AS M
Left JOIN TS_Phase AS P
	on P.F_PhaseID=M.F_PhaseID
LEFT JOIN TS_Phase_Des AS PD
	ON P.F_PhaseID=PD.F_PhaseID AND PD.F_LanguageCode=N'ENG'
Left JOIN TS_Event_Des AS ED
	ON P.F_EventID=ED.F_EventID AND ED.F_LanguageCode=N'ENG'
Where M.F_MatchID=@MatchID

SET NOCOUNT OFF
END

------------------
--exec [dbo].[Proc_TVG_JU_EventPhase] 90
------------------------