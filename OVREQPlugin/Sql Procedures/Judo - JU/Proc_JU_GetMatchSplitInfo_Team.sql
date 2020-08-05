IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetMatchSplitInfo_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetMatchSplitInfo_Team]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--��    ��: [Proc_JU_GetMatchSplitInfo_Team]
--��    ��: ����������л�ȡÿ��split��������Ϣ.
--�� �� ��: ��˳��
--��    ��: 2010��12��25�� 
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_JU_GetMatchSplitInfo_Team]
	@MatchID						INT,
	@MatchSplitID					INT,
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
	
	SELECT 
		[GoldenScore] = CASE M.F_MatchSplitComment1 WHEN N'1' THEN 1 ELSE 0 END
		,M.F_MatchSplitComment2 AS [ContestTime]
		, M.F_MatchSplitComment3 AS [Technique]
		, M.F_MatchSplitStatusID AS [StatusID]
		, D.F_DecisionCode AS [DecisionCode]
	FROM TS_Match_Split_Info AS M
	LEFT JOIN TC_Decision AS D
		ON M.F_DecisionID = D.F_DecisionID
	WHERE M.F_MatchID = @MatchID AND M.F_MatchSplitID=@MatchSplitID

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetMatchSplitInfo_Team] 45,1

*/
GO


