if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_UpdateGroupPhaseMatchPoint]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_UpdateGroupPhaseMatchPoint]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_UpdateGroupPhaseMatchPoint]
----��		  �ܣ������趨С������ÿ��������ʤ��ƽ�ĵ÷����
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-28

CREATE PROCEDURE [dbo].[Proc_UpdateGroupPhaseMatchPoint] (	
	@PhaseID					INT,
	@WonMatchPoint				INT,
	@DrawMatchPoint				INT,
	@LostMatchPoint				INT,
	@Result						INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON
	SET @Result=0;  -- @Result = 0; 	�����趨ʧ�ܣ���ʾû�����κβ�����
					-- @Result = 1; 	�����趨�ɹ���
					-- @Result = -1��	�����趨ʧ�ܣ���Phase����С������

	DECLARE @PhaseType AS INT
	SELECT @PhaseType = F_PhaseType FROM TS_Phase WHERE F_PhaseID = @PhaseID

	IF (@PhaseType = 2)--ȷ����С����
	BEGIN
		IF NOT EXISTS (SELECT F_PhaseID FROM TS_Phase_MatchPoint WHERE F_PhaseID = @PhaseID)
		BEGIN
			INSERT INTO TS_Phase_MatchPoint (F_PhaseID, F_WonMatchPoint, F_DrawMatchPoint, F_LostMatchPoint)
				VALUES (@PhaseID, @WonMatchPoint, @DrawMatchPoint, @LostMatchPoint)
		END
		ELSE
		BEGIN
			UPDATE TS_Phase_MatchPoint SET F_WonMatchPoint = @WonMatchPoint, F_DrawMatchPoint = @DrawMatchPoint,
					F_LostMatchPoint = @LostMatchPoint WHERE F_PhaseID = @PhaseID
		END

		SET @Result = 1
		RETURN
	END
	ELSE
	BEGIN
		SET @Result = -1
		RETURN
	END

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

