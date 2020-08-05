IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_WL_GetMatchs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_WL_GetMatchs]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--��    ��: [Proc_SCB_WL_GetMatchs]
--��    ��: SCB ��ȡ���������б�.
--�� �� ��: �޿�
--��    ��: 2011��4��13�� ������
--�޸ļ�¼��
/*			
			����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_SCB_WL_GetMatchs]
	@SessionID					INT,
	@EventID					INT,
	@LanguageCode				CHAR(3) = 'ENG'
AS
BEGIN
SET NOCOUNT ON

	DECLARE @ProcName			NVARCHAR(100)
	DECLARE @DisciplineCode		CHAR(2)
	
	SELECT @DisciplineCode = D.F_DisciplineCode
	FROM TS_Event AS E
	LEFT JOIN TS_Discipline AS D
		ON E.F_DisciplineID = D.F_DisciplineID
	WHERE E.F_EventID = @EventID
	
	--SET @ProcName = N'[dbo].[Proc_SCB_' + @DisciplineCode + '_GetMatchs]'
	
	--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@ProcName) AND type in (N'P', N'PC'))
	--BEGIN
	--	DECLARE @SQL			NVARCHAR(4000)
	--	SET @SQL = 'EXEC ' + @ProcName + ' ' + CONVERT(NVARCHAR(10), @SessionID) + ', ' + CONVERT(NVARCHAR(10), @EventID)
	--	EXEC(@SQL)
	--	RETURN
	--END
	
	SELECT ISNULL(PD.F_PhaseLongName, N'') + N' ' + ISNULL(MD.F_MatchLongName, N'') AS Match
		, M.F_MatchID
		, PD.F_PhaseLongName + N' (' + PDC.F_PhaseLongName +')' AS Phase 
	FROM TS_Match AS M
	LEFT JOIN TS_Match_Des AS MD
		ON M.F_MatchID = MD.F_MatchID AND MD.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Match_Des AS MDC
		ON M.F_MatchID = MDC.F_MatchID AND MDC.F_LanguageCode = 'CHN'
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Phase_Des AS PD
		ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Phase_Des AS PDC
		ON P.F_PhaseID = PDC.F_PhaseID AND PDC.F_LanguageCode = 'CHN'
	WHERE (P.F_EventID = @EventID OR @EventID = -1) --AND M.F_MatchCode ='01'
		AND (M.F_SessionID = @SessionID OR @SessionID = -1)
	ORDER BY M.F_MatchNum 

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_SCB_WL_GetMatchs] 1, 1

*/
GO


