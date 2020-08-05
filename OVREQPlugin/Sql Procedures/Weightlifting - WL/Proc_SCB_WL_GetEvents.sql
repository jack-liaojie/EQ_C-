IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_WL_GetEvents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_WL_GetEvents]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--��    ��: [Proc_SCB_WL_GetEvents]
--��    ��: SCB ��ȡ Event �����б�.
--�� �� ��: �����
--��    ��: 2010��7��7�� ������
--�޸ļ�¼��
/*			
			����					�޸���		�޸�����
			2010��7��8�� ������		�����		��Ӳ��� SessionID, ����ѡ��һ�� Session ���б����� Session.
			2010��7��12�� ����һ	�����		�������ж�Ӧ�Ĵ洢����ʱ, ���õ���Ĵ洢����.
*/



CREATE PROCEDURE [dbo].[Proc_SCB_WL_GetEvents]
	@DisciplineCode						CHAR(2),
	@SessionID							INT = -1
AS
BEGIN
SET NOCOUNT ON

	IF @SessionID = -1
	BEGIN
		SELECT ED1.F_EventShortName + N' (' + ED2.F_EventShortName+ N')' AS [Event]
			, ED2.F_EventShortName AS [Event_CHN]
			, E.F_EventID
			, ED1.F_EventShortName
		FROM TS_Event AS E
		LEFT JOIN TS_Event_Des AS ED1
			ON E.F_EventID = ED1.F_EventID AND ED1.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Event_Des AS ED2
			ON E.F_EventID = ED2.F_EventID AND ED2.F_LanguageCode = 'CHN'
		INNER JOIN TS_Discipline AS D
			ON E.F_DisciplineID = D.F_DisciplineID
		WHERE D.F_DisciplineCode = @DisciplineCode
		ORDER BY ED1.F_EventShortName
	END
	ELSE
	BEGIN
		SELECT distinct (ED1.F_EventShortName + N' (' + ED2.F_EventShortName+ N')')  AS [Event]
			, ED2.F_EventShortName AS [Event_CHN]
			, P.F_EventID
			, ED1.F_EventShortName
		FROM TS_Match AS M
		LEFT JOIN TS_Phase AS P
			ON M.F_PhaseID = P.F_PhaseID
		LEFT JOIN TS_Event_Des AS ED1
			ON P.F_EventID = ED1.F_EventID AND ED1.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Event_Des AS ED2
			ON P.F_EventID = ED2.F_EventID AND ED2.F_LanguageCode = 'CHN'
		WHERE M.F_SessionID = @SessionID
		ORDER BY ED1.F_EventShortName
	END

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_SCB_GetEvents] 'WL', 1

*/
GO


