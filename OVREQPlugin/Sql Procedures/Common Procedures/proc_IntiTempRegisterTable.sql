IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_IntiTempRegisterTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_IntiTempRegisterTable]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：proc_IntiTempRegisterTable
----功		  能：创建临时表,为人员和报项信息导入做准备
----作		  者：郑金勇 
----日		  期: 2011-06-12

CREATE PROCEDURE [dbo].[proc_IntiTempRegisterTable] 
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0


	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Athletes]') AND type in (N'U'))
	DROP TABLE [dbo].[Temp_Athletes]


	CREATE TABLE [dbo].[Temp_Athletes](
		[F_RegisterNum] [int] IDENTITY(1,1) NOT NULL,
		[运动员编号] [nvarchar](255) COLLATE DATABASE_DEFAULT NULL,
		[姓名] [nvarchar](255)  NULL,
		[性别] [nvarchar](255)  COLLATE DATABASE_DEFAULT NULL,
		[出生日期] [nvarchar](255) NULL,
		[民族] [nvarchar](255)  COLLATE DATABASE_DEFAULT NULL,
		[身高(cm)] [nvarchar](255) NULL,
		[体重(kg)] [nvarchar](255) NULL,
		[注册证号/会员证号] [nvarchar](255)  COLLATE DATABASE_DEFAULT NULL,
		[参赛单位] [nvarchar](255) NULL,
		[参赛单位代码] [nvarchar](255)  COLLATE DATABASE_DEFAULT NULL,
		[分计单位] [nvarchar](255)  NULL,
		[分计单位代码] [nvarchar](255)  COLLATE DATABASE_DEFAULT NULL,
		[体操是否团体] [nvarchar](255) NULL,
		[参赛项目] [nvarchar](255) NULL,
		[参赛项目代码] [nvarchar](255)  COLLATE DATABASE_DEFAULT NULL,
		[报名成绩] [nvarchar](255) NULL,
		[是否预备队员] [nvarchar](255) NULL,
		[组合号码] [nvarchar](255) NULL,
		[参赛子项] [nvarchar](255) NULL,
		[子项代码] [nvarchar](255)  COLLATE DATABASE_DEFAULT NULL,
		[射击团体顺序] [nvarchar](255) NULL,
		[比赛服号码] [nvarchar](255) NULL,
		[F23] [nvarchar](255) NULL,
		F_RegisterID		INT,
		F_DelegationID		INT,
		F_TeamCode			NVARCHAR(255),
		F_TeamID			INT,
		F_EventID			INT,
		F_EventSexCode		INT,
		F_PlayerRegTypeID	INT
	) ON [PRIMARY]



	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END






GO


