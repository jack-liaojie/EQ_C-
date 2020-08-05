IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_IntiTempRegisterTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_IntiTempRegisterTable]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�proc_IntiTempRegisterTable
----��		  �ܣ�������ʱ��,Ϊ��Ա�ͱ�����Ϣ������׼��
----��		  �ߣ�֣���� 
----��		  ��: 2011-06-12

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
		[�˶�Ա���] [nvarchar](255) COLLATE DATABASE_DEFAULT NULL,
		[����] [nvarchar](255)  NULL,
		[�Ա�] [nvarchar](255)  COLLATE DATABASE_DEFAULT NULL,
		[��������] [nvarchar](255) NULL,
		[����] [nvarchar](255)  COLLATE DATABASE_DEFAULT NULL,
		[���(cm)] [nvarchar](255) NULL,
		[����(kg)] [nvarchar](255) NULL,
		[ע��֤��/��Ա֤��] [nvarchar](255)  COLLATE DATABASE_DEFAULT NULL,
		[������λ] [nvarchar](255) NULL,
		[������λ����] [nvarchar](255)  COLLATE DATABASE_DEFAULT NULL,
		[�ּƵ�λ] [nvarchar](255)  NULL,
		[�ּƵ�λ����] [nvarchar](255)  COLLATE DATABASE_DEFAULT NULL,
		[����Ƿ�����] [nvarchar](255) NULL,
		[������Ŀ] [nvarchar](255) NULL,
		[������Ŀ����] [nvarchar](255)  COLLATE DATABASE_DEFAULT NULL,
		[�����ɼ�] [nvarchar](255) NULL,
		[�Ƿ�Ԥ����Ա] [nvarchar](255) NULL,
		[��Ϻ���] [nvarchar](255) NULL,
		[��������] [nvarchar](255) NULL,
		[�������] [nvarchar](255)  COLLATE DATABASE_DEFAULT NULL,
		[�������˳��] [nvarchar](255) NULL,
		[����������] [nvarchar](255) NULL,
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


