IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_info_BD_GetByeMatchesIDs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_info_BD_GetByeMatchesIDs]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[Proc_info_BD_GetByeMatchesIDs]
----��		  �ܣ���ȡ�ֿյı���ID���ֶ������
----��		  �ߣ���ǿ
----��		  ��: 2011-01-18

CREATE PROCEDURE [dbo].[Proc_info_BD_GetByeMatchesIDs]
		@MatchID  INT, --Phase�ڵ�һ������
		@Type     INT, -- 1������ȡ�Ѿ����͹���Bye Match, 2�����ȡPhase�ڲ�����bye Matches
		@Result   INT OUTPUT -- >0�����Ѿ����͵��ֿձ�������Ŀ�����ַ���
							 -- -1����Phase��û���ֿյı���
							 -- -2���������ֿձ�����Ϣ��δ����
							 -- -3���������ֿձ�����Ϣ���ѷ���
							 
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @PhaseID INT
	SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID
	
	IF @PhaseID IS NULL
		RETURN
	
	DECLARE @ByeCount INT = 0
	DECLARE @ByeSentCount INT = 0
	
	SELECT @ByeCount = COUNT(DISTINCT(F_MatchID)) FROM TS_Match_Result AS A
	WHERE F_RegisterID = -1 AND A.F_MatchID
	IN ( SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID )
	
	IF @ByeCount = 0
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	SELECT @ByeSentCount = COUNT(DISTINCT(F_MatchID)) FROM TS_Match_Result AS A
	WHERE F_RegisterID = -1 AND A.F_MatchID
	IN ( SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID AND F_MatchComment1 = 'Y' )
	
	IF @ByeSentCount = 0
		SET @Result = -2   --�����ֿձ�����δ����
	ELSE IF @ByeSentCount = @ByeCount
		SET @Result = -3   --�����ֿձ������ѷ���
	ELSE      
		SET @Result = @ByeSentCount  --�ֿձ������ַ���
	
	IF @Type = 1
	BEGIN
		SELECT DISTINCT(F_MatchID) FROM TS_Match_Result AS A
		WHERE F_RegisterID = -1 AND A.F_MatchID
		IN ( SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID AND ( F_MatchComment1 IS NULL OR F_MatchComment1 != 'Y'))
	END
	ELSE IF @Type = 2
	BEGIN
		SELECT DISTINCT(F_MatchID) FROM TS_Match_Result AS A
		WHERE F_RegisterID = -1 AND A.F_MatchID
		IN ( SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID )
	END

SET NOCOUNT OFF
END


GO


