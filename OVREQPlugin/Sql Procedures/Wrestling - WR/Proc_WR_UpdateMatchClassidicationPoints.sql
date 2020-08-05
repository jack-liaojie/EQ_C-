IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_UpdateMatchClassidicationPoints]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_UpdateMatchClassidicationPoints]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_WR_UpdateMatchClassidicationPoints]
--��    ��: ˤ����Ŀ������Ŀ�趨һ����������Ϣ.
--�� �� ��: ��˳��
--��    ��: 2011��10��15�� ����6
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WR_UpdateMatchClassidicationPoints]
	@MatchID						INT,
	@Compos							INT,
	@ClassidicatonPints				INT
AS
BEGIN
SET NOCOUNT ON
	
	Update TS_Match_Result set F_PointsNumDes2=@ClassidicatonPints where F_MatchID=@MatchID and F_CompetitionPosition=@Compos
	

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatch_Individual] 

*/