IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPhasePositionStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetPhasePositionStatus]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称: [Proc_GetPhasePositionStatus]
--描    述: 空手道比赛，得到当前Phase下签位是否有人存在
--参数说明: 
--说    明: 
--创 建 人: 张翠霞
--日    期: 2009-09-11
--修改说明：
/*	
		序号	日期		修改者		修改描述
		1.		2010-04-30	郑金勇		签位有一个人为空就是表明可以抽签。允许用户部分签位手动指定，部分签位自动抽签。

*/
CREATE PROCEDURE [dbo].[Proc_GetPhasePositionStatus]
	@EventID					INT,
	@PhaseID					INT,
	@NodeType					INT,
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	表示所有签位没有人存在
					  -- @Result = 1; 	表示有的签位存在人

	IF @NodeType = -1
	BEGIN
		IF EXISTS(SELECT F_RegisterID FROM TS_Event_Position WHERE F_EventID = @EventID AND (F_RegisterID IS NULL OR F_RegisterID = ''))
		BEGIN
			SET @Result = 0
		RETURN
		END
		ELSE
		BEGIN
			SET @Result = 1
		RETURN
		END
	END
	ELSE IF @NodeType = 0
	BEGIN
		IF EXISTS(SELECT F_RegisterID FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID AND (F_RegisterID IS NULL OR F_RegisterID = ''))
		BEGIN
			SET @Result = 0
			RETURN
		END
		ELSE
		BEGIN
			SET @Result = 1
			RETURN
		END
	END	
	SET @Result = 0
	RETURN

SET NOCOUNT OFF
END

GO


