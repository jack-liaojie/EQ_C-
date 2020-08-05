IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetMatchIRMandHantei]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetMatchIRMandHantei]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_WR_GetMatchIRMandHantei]
--��    ��: ˤ����Ŀ.
--�� �� ��: ��˳��
--��    ��: 2011��10��15�� ����6
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WR_GetMatchIRMandHantei]
	@MatchID						INT,
	@Compos							INT
AS
BEGIN
SET NOCOUNT ON
	
	select F_PointsNumDes1 as HanteiID
			,I.F_IRMCODE as IRMCode
	from TS_Match_Result AS MR
	LEFT JOIN TC_IRM AS I
		ON I.F_IRMID=MR.F_IRMID
	where MR.F_MatchID=@MatchID and MR.F_CompetitionPosition=@Compos

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatch_Individual] 

*/