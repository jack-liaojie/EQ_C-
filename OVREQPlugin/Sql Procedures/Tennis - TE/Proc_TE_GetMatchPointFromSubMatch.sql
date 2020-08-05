IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchPointFromSubMatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchPointFromSubMatch]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--��    �ƣ�[Proc_TE_GetMatchPointFromSubMatch]
--��    �����õ��������,������Ŀ
--����˵���� 
--˵    ����
--�� �� �ˣ�����
--��    �ڣ�2011��07��04��


CREATE PROCEDURE [dbo].[Proc_TE_GetMatchPointFromSubMatch](
												@MatchID		    INT,
												@ATotalScore        INT OUTPUT,
												@BTotalScore        INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

	SELECT @ATotalScore = COUNT(TMSR.F_MatchSplitID) 
	   FROM TS_Match_Split_Result AS TMSR LEFT JOIN TS_Match_Split_Info AS TMSI ON TMSR.F_MatchID = TMSI.F_MatchID AND TMSR.F_MatchSplitID = TMSI.F_MatchSplitID
	   WHERE TMSR.F_MatchID = @MatchID AND TMSR.F_CompetitionPosition = 1 AND TMSR.F_Rank = 1 AND TMSI.F_MatchSplitType = 3
	   
	 SELECT @BTotalScore = COUNT(TMSR.F_MatchSplitID) 
	   FROM TS_Match_Split_Result AS TMSR LEFT JOIN TS_Match_Split_Info AS TMSI ON TMSR.F_MatchID = TMSI.F_MatchID AND TMSR.F_MatchSplitID = TMSI.F_MatchSplitID
	   WHERE TMSR.F_MatchID = @MatchID AND TMSR.F_CompetitionPosition = 2 AND TMSR.F_Rank = 1 AND TMSI.F_MatchSplitType = 3  
	
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

