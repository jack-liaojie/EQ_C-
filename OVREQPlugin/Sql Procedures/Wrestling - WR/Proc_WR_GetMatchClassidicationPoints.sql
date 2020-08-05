IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetMatchClassidicationPoints]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetMatchClassidicationPoints]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_WR_GetMatchClassidicationPoints]
--��    ��: ˤ����Ŀ������Ŀ�趨һ����������Ϣ.
--�� �� ��: ��˳��
--��    ��: 2011��10��15�� ����6
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WR_GetMatchClassidicationPoints]
	@MatchID						INT,
	@Compos							INT
AS
BEGIN
SET NOCOUNT ON

	select F_PointsNumDes2 as [ClassidicationPoints] from TS_Match_Result where F_MatchID=@MatchID and F_CompetitionPosition=@Compos

	

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatch_Individual] 

*/