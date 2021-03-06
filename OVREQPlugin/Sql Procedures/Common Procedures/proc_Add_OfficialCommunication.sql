/****** Object:  StoredProcedure [dbo].[proc_Add_OfficialCommunication]    Script Date: 01/25/2010 09:09:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_Add_OfficialCommunication]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_Add_OfficialCommunication]
GO
/****** Object:  StoredProcedure [dbo].[proc_Add_OfficialCommunication]    Script Date: 01/25/2010 09:09:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：proc_Add_OfficialCommunication
----功		  能：为一个Dsicipline添加一个OfficialCommunication
----作		  者：李燕
----日		  期: 2010-1-20 

CREATE PROCEDURE [dbo].[proc_Add_OfficialCommunication]
    @DisciplineiD           INT,	
	@bAddNew				BIT = 1,				-- 1: 添加新纪录，0：修改纪录
	@NewsID 				INT = NULL,				-- 如果 @bAddNew = 0，此参数必须不为空
	@NewsItem			    NVARCHAR(20) = NULL,
	@SubTitle               NVARCHAR(100) = NULL,
    @Heading                NVARCHAR(100) = NULL,
    @Text                   NVARCHAR(max) = NULL,
    @Issuedby               NVARCHAR(100) = NULL,
    @Type                   INT = NULL,
    @Date                   DATETIME = NULL,
    @Note                   NVARCHAR(200) = NULL,
	@Result 			    AS INT = 0 OUTPUT 
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加EventRecord失败，标示没有做任何操作！
					-- @Result>=1; 	添加EventRecord成功！如果是添加新纪录，此值即为NewRecordID
					-- @Result=-1; 	添加EventRecord失败，@DisciplineID无效
					-- @Result=-2;	修改纪录失败，@NewsID无效

	IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineID = @DisciplineiD)
	BEGIN
		SET @Result = -1
		RETURN
	END

	-- 添加新纪录
	IF @bAddNew = 1
	BEGIN
		DECLARE @New_NewsID AS INT	

		SET Implicit_Transactions off
		BEGIN TRANSACTION --设定事务

			INSERT INTO TS_Offical_Communication (F_DisciplineID, F_NewsItem, F_SubTitle, F_Heading, F_Text, F_Issued_by, F_Type, F_Date, F_Note)
					VALUES (@DisciplineiD, @NewsItem, @SubTitle, @Heading, @Text, @Issuedby, @Type, @Date, @Note)

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
			SET @New_NewsID = @@IDENTITY

		COMMIT TRANSACTION --成功提交事务

		SET @Result = @New_NewsID
		RETURN
	END
	
	-- 修改已有纪录信息
	ELSE
	BEGIN

		IF NOT EXISTS(SELECT F_NewsID FROM TS_Offical_Communication WHERE F_DisciplineID = @DisciplineiD AND F_NewsID = @NewsID)
		BEGIN
			SET @Result = -2
			RETURN
		END

		SET Implicit_Transactions off
		BEGIN TRANSACTION --设定事务

			UPDATE TS_Offical_Communication SET 
					F_NewsItem = @NewsItem, 
					F_SubTitle = @SubTitle, 
					F_Heading = @Heading, 
					F_Text = @Text, 
					F_Issued_by = @Issuedby, 
					F_Type = @Type, 
					F_Date = @Date,
                    F_Note = @Note
			WHERE F_DisciplineID = @DisciplineiD AND F_NewsID = @NewsID

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







