IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetTeamClassification_Event]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetTeamClassification_Event]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Report_WL_GetTeamClassification_Event]
--��    ��: ��ȡ C76 - Unofficial Team Classification ����Ŀ��Ϣ, ���Ա�.
--�� �� ��: �����
--��    ��: 2011��3��26�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_Report_WL_GetTeamClassification_Event]
	@DisciplineID					INT,
	@LanguageCode					CHAR(3) = 'ENG'
AS
BEGIN
SET NOCOUNT ON

	IF @DisciplineID = -1
	BEGIN
		SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_Active = 1
	END
	
	SELECT E.F_SexCode
		, E.F_EventID
		, REPLACE(REPLACE(ED.F_EventLongName, N'Women''s ', N''), N'Men''s ', N'') AS [Event]
		, COUNT(I.F_RegisterID) AS TotalParticipants
	FROM TS_Event AS E
	LEFT JOIN TS_Event_Des AS ED
		ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Inscription AS I
		ON E.F_EventID = I.F_EventID
	WHERE E.F_DisciplineID = @DisciplineID
	GROUP BY E.F_SexCode, E.F_EventID, E.F_EventCode, ED.F_EventLongName
	ORDER BY E.F_SexCode, E.F_EventCode

SET NOCOUNT OFF
END
GO

/*

-- Just for test
EXEC [Proc_Report_WL_GetTeamClassification_Event] -1

*/