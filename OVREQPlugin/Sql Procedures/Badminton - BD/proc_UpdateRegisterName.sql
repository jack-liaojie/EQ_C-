
/****** Object:  StoredProcedure [dbo].[proc_UpdateRegisterName]    Script Date: 08/09/2011 22:01:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_UpdateRegisterName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_UpdateRegisterName]
GO



/****** Object:  StoredProcedure [dbo].[proc_UpdateRegisterName]    Script Date: 08/09/2011 22:01:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----�洢�������ƣ�proc_UpdateRegisterName
----��		  �ܣ��޸�һ��ע����Ա��������Ϣ��������
----��		  �ߣ�����
----��		  ��: 2010-04-14 


CREATE PROCEDURE [dbo].[proc_UpdateRegisterName] 
	@RegisterID			INT,
	@languageCode		CHAR(3),
	@FirstName			NVARCHAR(50),
	@LastName			NVARCHAR(50),
	@LongName			NVARCHAR(100),
	@ShortName			NVARCHAR(100),
	@TvLongName			NVARCHAR(100),
	@TvShortName		NVARCHAR(100),
	@SBLongName			NVARCHAR(100),
	@SBShortName		NVARCHAR(100),
	@PrintLongName		NVARCHAR(100),
	@PrintShortName		NVARCHAR(100),
    @WNPAFirstName      NVARCHAR(50),
    @WNPALastName       NVARCHAR(50),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	�༭Registerʧ�ܣ���ʾû�����κβ�����
					-- @Result>=1; 	�༭Register�ɹ���
					-- @Result=-1; 	�༭Registerʧ�ܣ�@RegisterID��Ч


	IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -1
		RETURN
	END


	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		IF NOT EXISTS (SELECT F_RegisterID FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @languageCode)
		BEGIN
			INSERT INTO TR_Register_Des (F_RegisterID, F_LanguageCode, F_FirstName, F_LastName, F_LongName, F_ShortName, F_TvLongName, F_TvShortName, F_SBLongName, F_SBShortName, F_PrintLongName, F_PrintShortName, F_WNPA_FirstName, F_WNPA_LastName)
				VALUES (@RegisterID, @languageCode, @FirstName, @LastName, @LongName, @ShortName, @TvLongName, @TvShortName, @SBLongName, @SBShortName, @PrintLongName, @PrintShortName, @WNPAFirstName, @WNPALastName)

			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			UPDATE TR_Register_Des SET  F_FirstName = @FirstName, F_LastName = @LastName, F_LongName= @LongName,
										F_ShortName = @ShortName, F_TvLongName = @TvLongName, F_TvShortName = @TvShortName,
										F_SBLongName = @SBLongName, F_SBShortName = @SBShortName, F_PrintLongName = @PrintLongName,
										F_PrintShortName = @PrintShortName, F_WNPA_FirstName = @WNPAFirstName, F_WNPA_LastName = @WNPALastName
					WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @languageCode

			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END
		END
		

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END


GO


