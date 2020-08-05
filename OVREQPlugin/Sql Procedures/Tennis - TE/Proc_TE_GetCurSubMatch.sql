IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetCurSubMatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetCurSubMatch]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--��    �ƣ�[Proc_TE_GetCurSubMatch]
--��    �����õ��������ĵ�ǰSubMatch
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2011��09��10��


CREATE PROCEDURE [dbo].[Proc_TE_GetCurSubMatch](
												@MatchID		    INT
)
As
Begin
SET NOCOUNT ON 

	SELECT TOP 1 F_MatchSplitCode, F_MatchSplitStatusID 
		FROM TS_Match_Split_Info 
			WHERE F_MatchID = @MatchID AND F_MatchSplitType = 3 AND F_MatchSplitStatusID IN(50, 110) 
				ORDER BY CASE WHEN F_MatchSplitStatusID = 50 THEN 2 ELSE 1 END DESC
					, CAST( F_MatchSplitCode AS INT) DESC

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

