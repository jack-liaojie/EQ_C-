IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddClub]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddClub]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_AddClub]
----功		  能：添加一个Club
----作		  者：张翠霞 
----日		  期: 2009-05-20 

CREATE PROCEDURE [dbo].[Proc_AddClub]
    @ClubCode			NVARCHAR(10),
    @LanguageCode		CHAR(3),
	@ClubLongName		NVARCHAR(50),
	@ClubShortName		NVARCHAR(50),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加Club失败，标示没有做任何操作！
					  -- @Result>=1; 	添加Club成功！此值即为ClubID

	DECLARE @NewClubID AS INT

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TC_CLub (F_ClubCode) VALUES (@ClubCode)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewClubID = @@IDENTITY

        INSERT INTO TC_Club_Des (F_CLubID, F_LanguageCode, F_ClubLongName, F_ClubShortName) VALUES(@NewClubID, @LanguageCode, @ClubLongName, @ClubShortName)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewClubID
	RETURN

SET NOCOUNT OFF
END

GO

