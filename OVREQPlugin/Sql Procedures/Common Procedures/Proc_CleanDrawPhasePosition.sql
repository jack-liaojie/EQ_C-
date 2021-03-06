IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CleanDrawPhasePosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CleanDrawPhasePosition]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称: [Proc_CleanDrawPhasePosition]
--描    述: 空手道比赛，清除签位信息
--参数说明: 
--说    明: 
--创 建 人: 张翠霞
--日    期: 2009-09-08



CREATE PROCEDURE [dbo].[Proc_CleanDrawPhasePosition]
	@EventID					INT,
	@PhaseID					INT,
	@NodeType					INT,
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	表示生成初始比赛签位失败，什么动作也没有
					  -- @Result = 1; 	表示生成初始比赛签位


	IF @NodeType = -1
	BEGIN
		UPDATE TS_Event_Position SET F_RegisterID = NULL WHERE F_EventID = @EventID
	END
	ELSE
	BEGIN
	    UPDATE TS_Phase_Position SET F_RegisterID = NULL WHERE F_PhaseID = @PhaseID
	END
	
	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO

