IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_UpdateMatchWeighinTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_UpdateMatchWeighinTime]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--��    ��: [Proc_WL_UpdateMatchWeighinTime]
--��    ��: ������Ŀ,���³���ʱ��
--����˵��: 
--˵    ��: 
--�� �� ��: �޿�
--��    ��: 2011��2��21��
--�޸ļ�¼��
/*			
			����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WL_UpdateMatchWeighinTime]
	@MatchID				INT,
	@Time					VARCHAR(100),
	@Return  			    AS INT OUTPUT

AS
BEGIN
SET NOCOUNT ON

	SET @Return=0;  -- @Return=0; 	���³���ʱ��ʧ�ܣ���ʾû�����κβ�����
					-- @Return=1; 	���³���ʱ��ɹ������أ�
					-- @Return=-1; 	���³���ʱ��ʧ�ܣ�@MatchID��Ч
					
	DECLARE @PhaseID  INT
	DECLARE @TMatchID INT
	SET @PhaseID = (SELECT F_PhaseID FROM TS_Match WHERE F_MatchID=@MatchID)
	SET @TMatchID = (SELECT TOP 1 F_MatchID FROM TS_Match WHERE F_PhaseID=@PhaseID AND F_MatchCode='01')
	
	UPDATE TS_Match SET F_MatchComment6 =@Time WHERE F_MatchID = @TMatchID AND F_PhaseID=@PhaseID

	DECLARE @WTIME VARCHAR(100)
	SET @WTIME = (SELECT F_MatchComment6 FROM TS_Match WHERE F_MatchID = @TMatchID AND F_PhaseID=@PhaseID)
	
	IF @WTIME IS NOT NULL
		BEGIN 		
           SET @Return = 1 
           RETURN
		END
SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

-- Just for test
EXEC [Proc_WL_UpdateMatchWeighinTime] 62,'18:49:39:550'

SELECT CONVERT(varchar(100), GETDATE(), 14)

*/



