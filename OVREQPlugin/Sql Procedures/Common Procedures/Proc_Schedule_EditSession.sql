IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_EditSession]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_EditSession]
GO


/****** 对象:  StoredProcedure [dbo].[Proc_Schedule_EditSession]    脚本日期: 11/10/2009 15:32:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_Schedule_EditSession]
----功		  能：编辑一个Session，主要是为编排服务
----作		  者：郑金勇 
----日		  期: 2009-04-16 
--修改记录：
/*			
			时间				修改人		修改内容
			2009年11月10日		邓年彩		添加 F_SessionEnd 字段		
			2009年11月12日		邓年彩		修改存储过程名称, proc_EditSession->Proc_Schedule_EditSession		
*/

CREATE PROCEDURE [dbo].[Proc_Schedule_EditSession]
	@SessionID			INT,
    @DisciplineID       INT,
	@SessionDate		DATETIME,
	@SessionNumber		INT,
	@SessionTime		DATETIME,
	@SessionEndTime		DATETIME,
	@SeesionTypeID		INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	编辑Session失败，标示没有做任何操作！
					-- @Result=1; 	编辑Session成功！
					-- @Result=-1; 	编辑Session失败, @SeesionTypeID 无效
                    -- @Result=-2; 	编辑Session失败, @DisciplineID 无效

    IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID)
	BEGIN
		SET @Result = -2
		RETURN
	END

	IF NOT EXISTS(SELECT F_SessionTypeID FROM TC_SessionType WHERE F_SessionTypeID = @SeesionTypeID)
	BEGIN
		SET @SeesionTypeID = NULL
--		SET @Result = -1
--		RETURN
	END


	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		UPDATE TS_Session SET F_SessionDate = @SessionDate, F_SessionNumber = @SessionNumber,
			 F_SessionTime = @SessionTime, F_SessionEndTime = @SessionEndTime, F_SessionTypeID = @SeesionTypeID
			WHERE F_SessionID = @SessionID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO