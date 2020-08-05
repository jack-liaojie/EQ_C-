if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_AddPhase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_AddPhase]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

----��   �ƣ�[proc_AddPhase]
----��   �ܣ����һ��Phase����Ҫ��Ϊ���ŷ���
----��	 �ߣ�֣����
----��   �ڣ�2009-04-08 

/*
	����˵����
	���	��������				����˵��

*/

/*
	�������������һ��Phase����Ҫ��Ϊ���ŷ���
			  
*/

/*
�޸ļ�¼��
	���	����			�޸���		�޸�����
	1		2012-08-24		֣����		���@PhaseType�����������Ҹ���Phase�ĸ��ڵ��PhaseType���;��������PhaseType����Ҫ��21��31��				

*/

CREATE PROCEDURE proc_AddPhase 
	@EventID			INT,
	@FatherPhaseID		INT,
	@PhaseCode			NVARCHAR(10),
	@OpenDate			DATETIME,
	@CloseDate			DATETIME,
	@PhaseStatusID		INT,
	@PhaseNodeType		INT,
	@Order				INT,
	@PhaseType			INT,--1��ʾָʾ�Ե�Phase�ڵ㣬2��ʾС������Phase�ڵ�, 21��ʾС�����µ�ÿһ�ֵ�phase�ڵ㣬3��ʾ��̭���ĸ�Phase�ڵ㣬31��ʾ��̭����ÿһ�ֵ���̭����Phase�ڵ㡣
	@PhaseSize			INT,
	@PhaseRankSize		INT,
	@PhaseIsQual		INT,
	@PhaseInfo			NVARCHAR(50),
	@languageCode		CHAR(3),
	@PhaseLongName		NVARCHAR(100),
	@PhaseShortName		NVARCHAR(50),
	@PhaseComment		NVARCHAR(100),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	���Phaseʧ�ܣ���ʾû�����κβ�����
					-- @Result>=1; 	���Phase�ɹ�����ֵ��ΪPhaseID
					-- @Result=-1; 	���Phaseʧ�ܣ�@EventID��Ч��@FatherPhaseID��Ч
					-- @Result=-2; 	���Phaseʧ�ܣ��ýڵ��״̬���������Phase
	DECLARE @NewPhaseID AS INT	

	IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF @FatherPhaseID != 0
	BEGIN
		IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseID = @FatherPhaseID)
		BEGIN
			SET @Result = -1
			RETURN
		END
	END

	DECLARE @ParentStatusID AS INT
	
	IF @FatherPhaseID = 0
	BEGIN
		SELECT @ParentStatusID = F_EventStatusID FROM TS_Event WHERE F_EventID = @EventID
	END
	ELSE 
	BEGIN
		SELECT @ParentStatusID = F_PhaseStatusID FROM TS_Phase WHERE F_PhaseID = @FatherPhaseID 
	END

	IF @ParentStatusID > 10 
	BEGIN
		SET @Result = -2
		RETURN
	END


	IF @Order = 0 OR @Order IS NULL
	BEGIN
		SELECT @Order = (CASE WHEN MAX(F_Order) IS NULL THEN 0 ELSE MAX(F_Order) END) + 1 FROM TS_Phase WHERE F_EventID = @EventID AND F_FatherPhaseID = @FatherPhaseID
	END

	IF @PhaseStatusID IS NULL
	BEGIN
		SET @PhaseStatusID = 10
	END

	DECLARE @FatherPhaseType AS INT
	IF @FatherPhaseID != 0
	BEGIN
		SELECT @FatherPhaseType = F_PhaseType FROM TS_Phase WHERE F_PhaseID = @FatherPhaseID
	END

	IF(@PhaseType=1 AND @FatherPhaseID != 0)
	BEGIN
		IF @FatherPhaseType = 2
		BEGIN
			SET @PhaseType = 21
		END
		ELSE IF @FatherPhaseType = 3
		BEGIN
			SET @PhaseType = 31
		END
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		INSERT INTO TS_PHASE (F_EventID, F_FatherPhaseID, F_PhaseCode, F_OpenDate, F_CloseDate, F_PhaseStatusID, F_PhaseNodeType, F_Order, F_PhaseType, F_PhaseSize, F_PhaseRankSize, F_PhaseIsQual, F_PhaseInfo)
    		VALUES (@EventID, @FatherPhaseID, @PhaseCode, @OpenDate, @CloseDate, @PhaseStatusID, @PhaseNodeType, @Order, @PhaseType, @PhaseSize, @PhaseRankSize, @PhaseIsQual, @PhaseInfo)

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		SET @NewPhaseID = @@IDENTITY

		insert into TS_PHASE_DES (F_PhaseID, F_LanguageCode, F_PhaseLongName, F_PhaseShortName, F_PhaseComment)
			VALUES (@NewPhaseID, @languageCode, @PhaseLongName, @PhaseShortName, @PhaseComment)

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = @NewPhaseID
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

