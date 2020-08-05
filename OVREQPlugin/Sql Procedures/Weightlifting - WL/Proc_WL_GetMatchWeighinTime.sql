IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_GetMatchWeighinTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_GetMatchWeighinTime]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--��    ��: [Proc_WL_GetMatchWeighinTime]
--��    ��: ������Ŀ,��ó���ʱ��
--����˵��: 
--˵    ��: 
--�� �� ��: �޿�
--��    ��: 2011��2��21��
--�޸ļ�¼��
/*			
			����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WL_GetMatchWeighinTime]
	@MatchID				INT

AS
BEGIN
SET NOCOUNT ON
					
	DECLARE @PhaseID  INT
	DECLARE @TMatchID INT
	SET @PhaseID = (SELECT F_PhaseID FROM TS_Match WHERE F_MatchID=@MatchID)
	SET @TMatchID = (SELECT TOP 1 F_MatchID FROM TS_Match WHERE F_PhaseID=@PhaseID AND F_MatchCode='01')

	SELECT F_MatchComment6 AS WeighinTime FROM TS_Match WHERE F_MatchID = @TMatchID AND F_PhaseID=@PhaseID

SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

-- Just for test
EXEC [Proc_WL_GetMatchWeighinTime] 62

*/



