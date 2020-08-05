IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WR_GetEventList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WR_GetEventList]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Report_JU_GetEventList]
--��    ��: �����Ŀ�����ȡ Event �б�.
--�� �� ��: �����
--��    ��: 2010��10��6�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_Report_WR_GetEventList]
	@DisciplineID						INT,
	@EventID							INT		-- <= 0 ��ȡ����С���б�
AS
BEGIN
SET NOCOUNT ON

	IF @EventID > 0
		SELECT @DisciplineID = F_DisciplineID FROM TS_Event WHERE F_EventID = @EventID
	
	IF @DisciplineID <= 0
		SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_Active = 1
		
	SELECT E.F_EventID AS [EventID]
		, UPPER(ED1.F_EventLongName) AS [Event_ENG]
		, UPPER(ED2.F_EventLongName) AS [Event_CHN]
		, E.F_Order AS [Order]
		, E.F_EventCode AS [EventCode]
		, S.F_GenderCode AS [Gender]
	FROM TS_Event AS E
	LEFT JOIN TS_Event_Des AS ED1
		ON E.F_EventID = ED1.F_EventID AND ED1.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Event_Des AS ED2
		ON E.F_EventID = ED2.F_EventID AND ED2.F_LanguageCode = 'CHN'
	LEFT JOIN TC_Sex AS S
		ON E.F_SexCode = S.F_SexCode
	WHERE E.F_DisciplineID = @DisciplineID
		AND (@EventID <= 0 OR E.F_EventID = @EventID)

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetEventList] 

*/