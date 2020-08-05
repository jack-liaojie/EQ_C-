IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetMatchJudgeTitle]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetMatchJudgeTitle]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    ��: [Proc_JU_GetMatchJudgeTitle]
--��    ��: �����Ŀ��ȡһ�� Match �Ĳ���  
--�� �� ��: �����
--��    ��: 2010��11��8�� ����һ
--�޸ļ�¼��
/*			
	ʱ��					�޸���		�޸�����
*/


CREATE PROCEDURE [dbo].[Proc_JU_GetMatchJudgeTitle]
	@MatchID						INT,
	@Title							NVARCHAR(200) OUTPUT,
	@LanguageCode					CHAR(3) = 'ANY'		-- Ĭ��ȡ��ǰ���������
AS
BEGIN
SET NOCOUNT ON

	IF @LanguageCode = 'ANY'
	BEGIN
		SELECT @LanguageCode = F_LanguageCode
		FROM TC_Language
		WHERE F_Active = 1
	END

	SELECT @Title
		= N'Race ' 
		+ CASE
			WHEN A.F_RaceNum IS NOT NULL THEN A.F_RaceNum
			ELSE N''
		END
		+ ' / '
		+ CASE
			WHEN A.F_StartTime IS NOT NULL THEN LEFT(CONVERT(NVARCHAR(20), A.F_StartTime, 108), 5)
			ELSE N''
		END
		+ ' / '
		+ CASE
			WHEN D.F_EventLongName IS NOT NULL THEN D.F_EventLongName
			ELSE N''
		END
		+ ' - ' 
		+ CASE 
			WHEN B.F_MatchLongName IS NOT NULL THEN B.F_MatchLongName
			ELSE N''
		END
	FROM TS_Match AS A
	LEFT JOIN TS_Match_Des AS B
		ON A.F_MatchID = B.F_MatchID AND B.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Phase AS C
		ON A.F_PhaseID = C.F_PhaseID
	LEFT JOIN TS_Event_Des AS D
		ON C.F_EventID = D.F_EventID AND D.F_LanguageCode = @LanguageCode
	WHERE A.F_MatchID = @MatchID

SET NOCOUNT OFF
END


/*

-- Just for test
DECLARE @Title NVARCHAR(200)
EXEC [Proc_JU_GetMatchJudgeTitle] 1611, @Title OUTPUT, 'ENG'
SELECT @Title

*/