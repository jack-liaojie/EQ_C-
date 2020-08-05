IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_MatchsHasData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_MatchsHasData]
GO

/****** Object:  StoredProcedure [dbo].[Proc_JU_GetMatchType]    Script Date: 12/27/2010 13:57:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--��    ��: [[Proc_WR_MatchsHasData]]
--��    ��: ˤ����ĿSplit���Ƿ�������.
--�� �� ��: ��˳��
--��    ��: 2011��10��12�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WR_MatchsHasData]
	@MatchID						INT,
	@ResultID						INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
	
	SELECT @ResultID=MAX(F_MatchID)
	FROM TS_Match_Split_Info
	WHERE F_MatchID=@MatchID;
	
SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetDataEntryTitle] 

*/


GO


