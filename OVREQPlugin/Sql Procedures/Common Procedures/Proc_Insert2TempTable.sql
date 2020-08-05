IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert2TempTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Insert2TempTable]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：Proc_Insert2TempTable
----功		  能：将人员和报项信息导入到数据库的临时表中
----作		  者：郑金勇 
----日		  期: 2011-06-12

CREATE PROCEDURE [dbo].[Proc_Insert2TempTable]( 
	@DisciplineCode NVARCHAR(50),
	@Field1			NVARCHAR(255),
	@Field2			NVARCHAR(255),
	@Field3			NVARCHAR(255),
	@Field4			NVARCHAR(255),
	@Field5			NVARCHAR(255),
	@Field6			NVARCHAR(255),
	@Field7			NVARCHAR(255),
	@Field8			NVARCHAR(255),
	@Field9			NVARCHAR(255),
	@Field10		NVARCHAR(255),
	@Field11		NVARCHAR(255),
	@Field12		NVARCHAR(255),
	@Field13		NVARCHAR(255),
	@Field14		NVARCHAR(255),
	@Field15		NVARCHAR(255),
	@Field16		NVARCHAR(255),
	@Field17		NVARCHAR(255),
	@Field18		NVARCHAR(255),
	@Field19		NVARCHAR(255),
	@Field20		NVARCHAR(255),
	@Field21		NVARCHAR(255),
	@Field22		NVARCHAR(255),
	@Field23		NVARCHAR(255),
	@Result 		AS INT OUTPUT)
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0


	INSERT INTO Temp_Athletes (运动员编号, 姓名, 性别, 出生日期, 民族, [身高(cm)], [体重(kg)], [注册证号/会员证号], 参赛单位, 参赛单位代码, 分计单位, 分计单位代码, 体操是否团体, 参赛项目, 参赛项目代码, 报名成绩, 是否预备队员, 组合号码, 参赛子项, 子项代码, 射击团体顺序, 比赛服号码, F23)
		VALUES (@Field1, @Field2, @Field3, @Field4, @Field5, @Field6, @Field7, @Field8, @Field9, @Field10, @Field11, @Field12, @Field13, @Field14, @Field15, @Field16, @Field17, @Field18, @Field19, @Field20, @Field21, @Field22, @Field23)


	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END






GO


