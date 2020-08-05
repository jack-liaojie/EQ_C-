if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_AddCompetitionPosition]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_AddCompetitionPosition]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[proc_AddCompetitionPosition]
----��		  �ܣ����һ��������λ��
----��		  �ߣ�֣���� 
----��		  ��: 2009-11-11 

CREATE PROCEDURE [dbo].[proc_AddCompetitionPosition] 
	@MatchID						INT,
	@Result 						AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	���һ��������λ��ʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	���һ��������λ�óɹ���
					-- @Result=-1; 	���һ��������λ��ʧ�ܣ�@MatchID��Ч

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	DECLARE @CompetitionPosition AS INT
	SELECT @CompetitionPosition = (CASE WHEN MAX(F_CompetitionPosition) IS NULL THEN 0 ELSE MAX(F_CompetitionPosition) END) + 1 FROM TS_Match_Result WHERE F_MatchID = @MatchID

	DECLARE @CompetitionPositionDes1 AS INT
	SELECT @CompetitionPositionDes1 = (CASE WHEN MAX(F_CompetitionPositionDes1) IS NULL THEN 0 ELSE MAX(F_CompetitionPositionDes1) END) + 1 FROM TS_Match_Result WHERE F_MatchID = @MatchID

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		INSERT INTO TS_Match_Result (F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1) VALUES (@MatchID, @CompetitionPosition, @CompetitionPositionDes1)
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		INSERT INTO TS_Match_Split_Result (F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_CompetitionPosition)
			SELECT F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, @CompetitionPosition AS F_CompetitionPosition
				FROM TS_Match_Split_info WHERE F_MatchID = @MatchID

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--exec proc_AddCompetitionPosition 750, 1
--select * from TS_Match_Result where F_MatchID = 1075
--select * from TS_Match_Result where F_MatchID = 750
--
--select * from TS_Match_Split_Result where F_MatchID = 1075
--select * from TS_Match_Split_Result where F_MatchID = 750