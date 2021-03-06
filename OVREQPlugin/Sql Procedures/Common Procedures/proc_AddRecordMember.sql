

GO
/****** Object:  StoredProcedure [dbo].[proc_AddRecordMember]    Script Date: 02/01/2010 11:34:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddRecordMember]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddRecordMember]

GO
/****** Object:  StoredProcedure [dbo].[proc_AddRecordMember]    Script Date: 02/01/2010 11:34:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：proc_AddRecordMember
----功		  能：添加RecordMember
----作		  者：张翠霞
----日		  期: 2009-11-10 
----修        改：管仁良 2009-12-14

CREATE PROCEDURE [dbo].[proc_AddRecordMember] 
	@RecordID		    INT,	
	@bAddNew			BIT = 1,			-- 1: 添加，0：修改
	@MemberNum			INT = NULL,			-- 如果 @bAddNew = 0，此参数必须不为空
	@RegisterCode		NCHAR(10) = NULL,
	@FamilyName			NVARCHAR(50) = NULL,
	@GivenName			NVARCHAR(50) = NULL,
	@NOC			    CHAR(3) = NULL,
	@Gender	            NVARCHAR(50) = NULL,
	@Birth_Date			DATETIME = NULL,
    @PositionCode       NVARCHAR(10) = NULL,
	@Result 			AS INT  = 0 OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加RecordMember失败，标示没有做任何操作！
					-- @Result=1; 	添加RecordMember成功！如果是添加 @Result = NewMemberNum
					-- @Result=-1; 	添加RecordMember失败，@RecordID无效	

	IF NOT EXISTS(SELECT F_RecordID FROM TS_Event_Record WHERE F_RecordID = @RecordID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	-- 添加
	IF @bAddNew = 1
	BEGIN
		DECLARE @NewMemberNum INT
		SELECT @NewMemberNum = (CASE WHEN MAX(F_MemberNum) IS NULL THEN 0 ELSE MAX(F_MemberNum) END) + 1 FROM TS_Record_Member WHERE F_RecordID = @RecordID

		SET Implicit_Transactions off
		BEGIN TRANSACTION --设定事务

			INSERT INTO TS_Record_Member (F_RecordID, F_MemberNum, F_RegisterCode, F_FamilyName, F_GivenName, F_NOC, F_Gender, F_Birth_Date, F_PositionCode)
				VALUES (@RecordID, @NewMemberNum, @RegisterCode, @FamilyName, @GivenName, @NOC, @Gender, @Birth_Date, @PositionCode)

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END

		COMMIT TRANSACTION --成功提交事务

		SET @Result = @NewMemberNum
		RETURN	
	END

	-- 修改
	ELSE
	BEGIN

		SET Implicit_Transactions off
		BEGIN TRANSACTION --设定事务

			UPDATE TS_Record_Member SET
				F_RegisterCode = @RegisterCode, 
				F_FamilyName = @FamilyName, 
				F_GivenName = @GivenName, 
				F_NOC = @NOC, 
				F_Gender = @Gender, 
				F_Birth_Date= @Birth_Date, 
				F_PositionCode= @PositionCode
			WHERE F_RecordID = @RecordID AND F_MemberNum = @MemberNum

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END

		COMMIT TRANSACTION --成功提交事务

		SET @Result = 1
		RETURN

	END

SET NOCOUNT OFF
END



