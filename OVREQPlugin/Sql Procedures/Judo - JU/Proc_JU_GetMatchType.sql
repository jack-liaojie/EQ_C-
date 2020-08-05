IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetMatchType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetMatchType]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--��    ��: [Proc_JU_GetMatchType]
--��    ��: ��ȡ�����Ŀ������ .
--�� �� ��: ��˳��
--��    ��: 2010��12��26�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_JU_GetMatchType]
	@MatchID						INT,
	@MatchTypeID					    INT OUTPUT,
	@LanguageCode					CHAR(3) = NULL
AS
BEGIN
SET NOCOUNT ON

	IF @LanguageCode IS NULL
	BEGIN
		SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1
	END
	
	SELECT @MatchTypeID=E.F_PlayerRegTypeID
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P
		ON M.F_PhaseID=P.F_PhaseID
	LEFT JOIN TS_Event AS E
		ON P.F_EventID=E.F_EventID
	WHERE M.F_MatchID = @MatchID

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetDataEntryTitle] 

*/


GO


