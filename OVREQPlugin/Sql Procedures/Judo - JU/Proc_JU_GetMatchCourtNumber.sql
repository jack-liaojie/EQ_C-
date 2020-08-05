IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetMatchCourtNumber]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetMatchCourtNumber]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--��    ��: [Proc_JU_GetMatchCourtNumber]
--��    ��: ��ȡ�����Ŀ���غ�
--�� �� ��: ��˳��
--��    ��: 2011��7��4�� ����1
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_JU_GetMatchCourtNumber]
	@MatchID						INT,
	@MatchCourtNumber				INT OUTPUT,
	@LanguageCode					CHAR(3) = NULL
AS
BEGIN
SET NOCOUNT ON

	IF @LanguageCode IS NULL
	BEGIN
		SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1
	END
	
	SELECT @MatchCourtNumber=Convert(int,RIght(ISNULL(C.F_CourtCode,N'0'),1))
	FROM TS_Match AS M
	LEFT JOIN TC_Court AS C
		ON C.F_CourtID=m.F_CourtID
	where m.F_MatchID=@MatchID

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetDataEntryTitle] 
select * from TS_Session
*/


GO


