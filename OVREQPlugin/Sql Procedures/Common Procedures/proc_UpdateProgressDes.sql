/****** Object:  StoredProcedure [dbo].[proc_UpdateProgressDes]    Script Date: 12/18/2009 15:27:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_UpdateProgressDes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_UpdateProgressDes]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----�洢�������ƣ�[proc_UpdateProgressDes]
----��		  �ܣ����±���λ�ý�������
----��		  �ߣ�����
----��		  ��: 2009-12-18

CREATE PROCEDURE [dbo].[proc_UpdateProgressDes] 
	@MatchID						INT,
	@CompetitionPosition			INT,
	@LanguageCode					CHAR(3),
    @ProgressDes                    NVARCHAR(100),
	@Result 						AS INT OUTPUT
	
AS
BEGIN
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	����ʧ�ܣ�
					-- @Result=1; 	���³ɹ���

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

    IF EXISTS (SELECT F_MatchID FROM TS_Match_Result_Des WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition AND F_LanguageCode = @LanguageCode)
	BEGIN
			
		UPDATE TS_Match_Result_Des SET F_ProgressDes = @ProgressDes
			WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition AND F_LanguageCode = @LanguageCode

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
	END
	ELSE
	BEGIN
		insert into TS_Match_Result_Des (F_MatchID, F_CompetitionPosition, F_LanguageCode, F_ProgressDes)
			VALUES (@MatchID, @CompetitionPosition, @LanguageCode, @ProgressDes)

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