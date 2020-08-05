IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_SetRecordRegister]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_SetRecordRegister]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [proc_SetRecordRegister]
--描    述: 指定记录的创造者和记录的保持者
--参数说明: 
--说    明: 
--创 建 人: 郑金勇
--日    期: 2010年12月30日
--修改记录：



CREATE PROCEDURE [dbo].[proc_SetRecordRegister]
	@RecordID			INT,
	@RegisterID			INT,
	@Result				INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	指定失败，标示没有做任何操作！
					-- @Result = 1; 	指定成功！

	
	IF NOT EXISTS(SELECT F_RecordID FROM TS_Event_Record WHERE F_RecordID = @RecordID)
	BEGIN
		SET @Result = 0
		RETURN
	END
	
	IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = 0
		RETURN
	END

	UPDATE TS_Event_Record SET F_RegisterID = @RegisterID WHERE F_RecordID = @RecordID
	SET @Result = 1

	RETURN
SET NOCOUNT OFF
END

GO


