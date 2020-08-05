IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_ListCompetitionOfficials]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_ListCompetitionOfficials]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    ��: [Proc_WR_ListCompetitionOfficials]
--��    ��: �����Ŀ��ȡ������Ա�б�  
--�� �� ��: �����
--��    ��: 2010��11��8�� ����һ
--�޸ļ�¼��
/*			
	ʱ��					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WR_ListCompetitionOfficials]
	@MatchID						INT,
	@LanguageCode					CHAR(3) = 'ANY'		-- Ĭ��ȡ��ǰ���������
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @DisciplineID			INT

	SELECT @DisciplineID = C.F_DisciplineID
	FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B
		ON A.F_PhaseID = B.F_PhaseID
	LEFT JOIN TS_Event AS C
		ON B.F_EventID = C.F_EventID
	WHERE A.F_MatchID = @MatchID

	IF @LanguageCode = 'ANY'
	BEGIN
		SELECT @LanguageCode = F_LanguageCode
		FROM TC_Language
		WHERE F_Active = 1
	END

	SELECT A.F_RegisterID AS [RegisterID]
		, B.F_LongName AS [Name]
		, ISNULL(A.F_Bib,N'')+N'----'+B.F_LongName + ' (' + ISNULL(A.F_NOC,' - ') + ')' AS [NameWithNOC]
	FROM TR_Register AS A
	LEFT JOIN TR_Register_Des AS B
		ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	WHERE A.F_RegTypeID = 4							-- ѡȡ������Ա
		AND A.F_DisciplineID = @DisciplineID
	ORDER BY convert(int,ISNULL(A.F_Bib,N'0'))

SET NOCOUNT OFF
END


/*

-- Just for test
EXEC [Proc_JU_ListCompetitionOfficials] 1611, 'ENG'

*/