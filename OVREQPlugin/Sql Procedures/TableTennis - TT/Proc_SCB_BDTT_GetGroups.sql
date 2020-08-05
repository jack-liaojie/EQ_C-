IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_BDTT_GetGroups]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_BDTT_GetGroups]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--��    ��: [Proc_SCB_BDTT_GetGroups]
--��    ��: SCB ��ȡ �����б�
--�� �� ��: ��ǿ
--��    ��: 2011��2��16��



CREATE PROCEDURE [dbo].[Proc_SCB_BDTT_GetGroups]
	@EventID						INT
	
AS
BEGIN
SET NOCOUNT ON
	CREATE TABLE #TMP_TABLE
	(
		Phase NVARCHAR(100),
		[Group] NVARCHAR(10),
		F_PhaseID INT
	)
	
	INSERT INTO #TMP_TABLE VALUES('', '', -1)
	
	INSERT INTO #TMP_TABLE
    SELECT PD.F_PhaseLongName AS Phase, P.F_PhaseCode AS [Group], P.F_PhaseID AS PhaseID
    FROM TS_Phase AS P
    LEFT JOIN TS_Phase_Des AS PD ON P.F_PhaseID = PD.F_PhaseID
    WHERE P.F_EventID = @EventID AND PD.F_LanguageCode = 'ENG' AND P.F_PhaseIsPool = 1 AND P.F_PhaseHasPools = 0
    
    SELECT * FROM #TMP_TABLE

SET NOCOUNT OFF
END


GO


