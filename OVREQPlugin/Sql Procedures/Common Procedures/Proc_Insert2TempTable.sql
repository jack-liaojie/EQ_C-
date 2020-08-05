IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Insert2TempTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Insert2TempTable]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�Proc_Insert2TempTable
----��		  �ܣ�����Ա�ͱ�����Ϣ���뵽���ݿ����ʱ����
----��		  �ߣ�֣���� 
----��		  ��: 2011-06-12

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


	INSERT INTO Temp_Athletes (�˶�Ա���, ����, �Ա�, ��������, ����, [���(cm)], [����(kg)], [ע��֤��/��Ա֤��], ������λ, ������λ����, �ּƵ�λ, �ּƵ�λ����, ����Ƿ�����, ������Ŀ, ������Ŀ����, �����ɼ�, �Ƿ�Ԥ����Ա, ��Ϻ���, ��������, �������, �������˳��, ����������, F23)
		VALUES (@Field1, @Field2, @Field3, @Field4, @Field5, @Field6, @Field7, @Field8, @Field9, @Field10, @Field11, @Field12, @Field13, @Field14, @Field15, @Field16, @Field17, @Field18, @Field19, @Field20, @Field21, @Field22, @Field23)


	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END






GO


