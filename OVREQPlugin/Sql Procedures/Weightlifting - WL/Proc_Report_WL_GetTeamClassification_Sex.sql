IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetTeamClassification_Sex]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetTeamClassification_Sex]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Report_WL_GetTeamClassification_Sex]
--��    ��: ��ȡ C76 - Unofficial Team Classification �� �Ա���Ϣ.
--�� �� ��: �����
--��    ��: 2011��3��26�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_Report_WL_GetTeamClassification_Sex]
	@DisciplineID					INT
AS
BEGIN
SET NOCOUNT ON

	IF @DisciplineID = -1
	BEGIN
		SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_Active = 1
	END
	
	SELECT S.F_SexCode
		, UPPER(SD1.F_SexLongName) AS Sex_ENG
		, SD2.F_SexLongName AS Sex_CHN
		, (
			SELECT COUNT(E.F_EventID)
			FROM TS_Event AS E
			WHERE E.F_DisciplineID = @DisciplineID
				AND E.F_SexCode = S.F_SexCode
		) AS EventCount
	FROM TC_Sex AS S
	LEFT JOIN TC_Sex_Des AS SD1
		ON S.F_SexCode = SD1.F_SexCode AND SD1.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Sex_Des AS SD2
		ON S.F_SexCode = SD2.F_SexCode AND SD2.F_LanguageCode = 'CHN'
	WHERE S.F_SexCode IN (1, 2)
	ORDER BY S.F_SexCode

SET NOCOUNT OFF
END
GO

/*

-- Just for test
EXEC [Proc_Report_WL_GetTeamClassification_Sex] -1

*/