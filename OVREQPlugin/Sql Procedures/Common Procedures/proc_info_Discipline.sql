IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_info_Discipline]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_info_Discipline]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[proc_info_Discipline]
----功		  能：为Info系统服务，获取当前Discipline信息
----作		  者：郑金勇
----日		  期: 2009-11-29

CREATE PROCEDURE [dbo].[proc_info_Discipline]
	@DisciplineCode			CHAR(2)
AS
BEGIN
	
SET NOCOUNT ON
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @DisciplineID AS INT
	DECLARE @VenueCode AS NVARCHAR(50)
	DECLARE @GroupType AS NCHAR(1)
	DECLARE @HasRecords AS TINYINT
	DECLARE @VenueCount AS INT

	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode
	SELECT @VenueCount = COUNT(F_VenueID) FROM TD_Discipline_Venue WHERE F_DisciplineID = @DisciplineID
	
	IF (@VenueCount = 1)
	BEGIN
		SELECT @VenueCode = B.F_VenueCode FROM TD_Discipline_Venue AS A LEFT JOIN TC_Venue AS B ON A.F_VenueID = B.F_VenueID WHERE A.F_DisciplineID = @DisciplineID
	END
	ELSE
	BEGIN
		SET @VenueCode = ''
	END

	SET @GroupType = 'C'
	SET @HasRecords = 0

	SELECT CAST(F_DisciplineCode AS NCHAR(2)) AS [KEY]
			,CAST(F_DisciplineCode AS NCHAR(2)) AS [DISCIPLINE]
			, CAST(@VenueCode AS NCHAR(3)) AS [VENUE]
			, @GroupType AS GROUP_TYPE
			, @HasRecords AS HAS_RECORDS
				 FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode

	RETURN

SET NOCOUNT OFF
END
GO
--
--EXEC proc_info_Discipline 'CR'
--
--EXEC proc_info_Discipline 'SP'
--EXEC proc_info_Discipline 'RO'