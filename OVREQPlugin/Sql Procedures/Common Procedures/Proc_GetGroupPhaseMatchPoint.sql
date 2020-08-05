if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_GetGroupPhaseMatchPoint]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_GetGroupPhaseMatchPoint]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_GetGroupPhaseMatchPoint]
----��		  �ܣ��õ�С������ÿ��������ʤ��ƽ�ĵ÷����
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-28

CREATE PROCEDURE [dbo].[Proc_GetGroupPhaseMatchPoint] (	
	@PhaseID					INT
)	
AS
BEGIN
	
SET NOCOUNT ON
	DECLARE @PhaseType AS INT
	SELECT @PhaseType = F_PhaseType FROM TS_Phase WHERE F_PhaseID = @PhaseID

	IF (@PhaseType = 2)--ȷ����С����
	BEGIN
		IF NOT EXISTS (SELECT F_PhaseID FROM TS_Phase_MatchPoint WHERE F_PhaseID = @PhaseID)
		BEGIN
			INSERT INTO TS_Phase_MatchPoint (F_PhaseID, F_WonMatchPoint, F_DrawMatchPoint, F_LostMatchPoint)
				VALUES (@PhaseID, 2, 1, 0)
		END
	END
	
	SELECT * FROM TS_Phase_MatchPoint WHERE F_PhaseID = @PhaseID

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

