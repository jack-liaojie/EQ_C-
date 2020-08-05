IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetMatchRaceNum]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetMatchRaceNum]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--��    ��: [Proc_JU_GetMatchRaceNum]
--��    ��: ��ȡ�����Ŀ������ .
--�� �� ��: ��˳��
--��    ��: 2010��12��26�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_JU_GetMatchRaceNum]
	@MatchID						INT,
	@MatchRaceNum					INT OUTPUT,
	@SessionID						INT OUTPUT,
	@MatchDay						INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	SELECT @MatchRaceNum=
		case when ISNULL(M.F_RaceNum,N'')=N'' then 0
		else CONVERT(INT,M.F_RaceNum) end
		,@SessionID=ISNULL(S.F_SessionNumber,0)
		,@MatchDay=ISNULL(DAY(F_MatchDate)-13+1,0)
	FROM TS_Match AS M
	LEFT JOIN TS_Session AS S
		ON S.F_SessionID=M.F_SessionID
	WHERE M.F_MatchID = @MatchID

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetMatchRaceNum] 

*/


GO


