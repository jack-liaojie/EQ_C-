IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_GetMatchGroupInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_GetMatchGroupInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--��    �ƣ�[Proc_GF_GetMatchGroupInfo]
--��    �����õ���ǰ�����е�ǰѡ��������Ϣ
--����˵���� 
--˵    ����
--�� �� �ˣ��Ŵ�ϼ
--��    �ڣ�2010��10��10��


CREATE PROCEDURE [dbo].[Proc_GF_GetMatchGroupInfo](
												@MatchID		    INT,
												@Group              INT
)
As
Begin
SET NOCOUNT ON				
	
	SELECT TOP 1 F_CompetitionPositionDes2 AS [Group], F_StartTimeNumDes AS Tee, F_StartTimeCharDes AS StartTime FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes2 = @Group

Set NOCOUNT OFF
End

GO


