IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddVenueIntoDiscipline]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddVenueIntoDiscipline]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_AddVenueIntoDiscipline]
----功		  能：添加一个Venue到一个项目之中
----作		  者：郑金勇 
----日		  期: 2009-05-25

CREATE PROCEDURE [dbo].[Proc_AddVenueIntoDiscipline]
	@DisciplineID		INT,
	@VenueID			INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加一个Venue失败，标示没有做任何操作！
					  -- @Result=1; 	添加一个Venue成功！
					  -- @Result=-3; 	添加场馆失败! 该项目的已有该场馆!

	IF EXISTS(SELECT F_DisciplineID FROM TD_Discipline_Venue WHERE F_DisciplineID = @DisciplineID AND F_VenueID = @VenueID)
	BEGIN
		SET @Result = -3
		RETURN
	END

	INSERT INTO TD_Discipline_Venue (F_DisciplineID, F_VenueID) VALUES (@DisciplineID, @VenueID)
	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO

