IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_TE_UpdateSubMatchStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_TE_UpdateSubMatchStatus]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�[proc_TE_UpdatSubMatchStatus]
----��		  �ܣ�������Ŀ�У�����SubMatch��״̬
----��		  �ߣ�����
----��		  ��: 2011-07-04
----�� �� ��  ¼�� 

CREATE PROCEDURE [dbo].[proc_TE_UpdateSubMatchStatus] (	
	@MatchID						INT,
	@SubMatchCode                   INT,
	@SubMatchStatus                 INT OUTPUT
)	
AS
BEGIN
SET NOCOUNT ON


	SET @SubMatchStatus = 0 
	
	DECLARE @MatchStatus INT
	SELECT @MatchStatus = F_MatchStatusID  FROM TS_Match WHERE F_MatchID = @MatchID
	
	SELECT @SubMatchStatus = F_MatchSplitStatusID  FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SubMatchCode AND F_MatchSplitType = 3
					
	SET Implicit_Transactions off
	BEGIN TRANSACTION
	
	BEGIN TRY
		IF(@MatchStatus = 50)
		BEGIN
		    IF(@SubMatchStatus IS NULL OR @SubMatchStatus = 0)  ---������״̬Ϊ��ʱ����ΪRunning
		    BEGIN
		        SET @SubMatchStatus = 50
		    END
   		    
		    UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = @SubMatchStatus WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SubMatchCode AND F_MatchSplitType = 3
		END
		ELSE
		BEGIN
		    SELECT @SubMatchStatus = ISNULL(F_MatchSplitStatusID, 0) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SubMatchCode AND F_MatchSplitType = 3
		END
			
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
			
		SET @SubMatchStatus = 0
		RETURN 
	
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
		
	RETURN 
	
SET NOCOUNT OFF
END





GO

 --EXEC [Proc_AddCompetitionRule] 1
