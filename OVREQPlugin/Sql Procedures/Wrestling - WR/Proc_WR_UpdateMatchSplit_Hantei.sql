IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_UpdateMatchSplit_Hantei]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_UpdateMatchSplit_Hantei]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_WR_UpdateMatchSplit_Hantei]
--��    ��: ���������Ŀ��ȡһ����������Ϣ.
--�� �� ��: �����
--��    ��: 2010��11��5�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WR_UpdateMatchSplit_Hantei]
	@MatchID						INT,
	@MatchSplitID					INT,
	@HanteiSplitIDA					INT,
	@HanteiSplitIDB					INT,
	@LanguageCode					CHAR(3) = NULL
AS
BEGIN
SET NOCOUNT ON
	
	IF @LanguageCode IS NULL
	BEGIN
		SELECT @LanguageCode = L.F_LanguageCode
		FROM TC_Language AS L
		WHERE L.F_Active = 1
	END
	
	Update TS_Match_Split_Result set F_PointsNumDes1=@HanteiSplitIDA where F_MatchID=@MatchID and F_MatchSplitID=@MatchSplitID and F_CompetitionPosition=1
	
	Update TS_Match_Split_Result set F_PointsNumDes1=@HanteiSplitIDB where F_MatchID=@MatchID and F_MatchSplitID=@MatchSplitID and F_CompetitionPosition=2
			
SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetMatch_Individual] 2

*/