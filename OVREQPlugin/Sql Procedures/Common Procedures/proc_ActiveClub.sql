/****** Object:  StoredProcedure [dbo].[proc_ActiveClub]    Script Date: 11/11/2009 11:24:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_ActiveClub]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_ActiveClub]
GO
/****** Object:  StoredProcedure [dbo].[proc_ActiveClub]    Script Date: 11/11/2009 11:24:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_ActiveClub]
----功		  能：激活Club
----作		  者：郑金勇 
----日		  期: 2009-05-12 

CREATE PROCEDURE [dbo].[proc_ActiveClub]
	@ClubID        			INT,
	@DisciplineID			INT,
	@ActiveType				INT, --1表示激活、0表示关闭
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	删除Federation失败，标示没有做任何操作！
					  -- @Result=1; 	删除Federation成功！
					  -- @Result=-1;	删除Federation失败，@FederationID无效！
					  -- @Result=-2;	删除Federation失败，@FederationID被注册人员引用，不允许关闭

	IF NOT EXISTS(SELECT F_ClubID FROM TC_Club WHERE F_ClubID = @ClubID)
	BEGIN
			SET @Result = -1
			RETURN
	END

	IF @ActiveType = 0
	BEGIN
		IF EXISTS( SELECT F_RegisterID FROM TR_Register WHERE F_ClubID = @ClubID AND F_RegisterID IN 
					( SELECT F_RegisterID FROM TR_Inscription WHERE F_EventID IN (SELECT F_EventID FROM TS_Event WHERE F_DisciplineID = @DisciplineID) ) )
		BEGIN
				SET @Result = -2
				RETURN
		END
		ELSE
		BEGIN
			DELETE FROM TS_ActiveClub WHERE F_ClubID = @ClubID AND F_DisciplineID = @DisciplineID
		END
	END
	ELSE
	BEGIN
		IF @ActiveType = 1
		BEGIN
			IF NOT EXISTS (SELECT F_ClubID FROM TS_ActiveClub WHERE F_ClubID = @ClubID AND F_DisciplineID = @DisciplineID)
			BEGIN
				INSERT INTO TS_ActiveClub (F_ClubID, F_DisciplineID) VALUES (@ClubID, @DisciplineID)
			END
		END
	END

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

