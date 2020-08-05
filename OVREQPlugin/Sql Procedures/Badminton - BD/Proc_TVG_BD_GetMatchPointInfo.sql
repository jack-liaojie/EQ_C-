IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_BD_GetMatchPointInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_BD_GetMatchPointInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[Proc_TVG_BD_GetMatchPointInfo]
----��		  �ܣ���ȡTVG��Ҫ��������Ϣ
----��		  �ߣ���ǿ
----��		  ��: 2011-04-27

CREATE PROCEDURE [dbo].[Proc_TVG_BD_GetMatchPointInfo]
		@MatchID     INT
AS
BEGIN
	
SET NOCOUNT ON
	
	DECLARE @PointRes NVARCHAR(20)
	DECLARE @PointDes NVARCHAR(30)
	DECLARE @PlayerName NVARCHAR(200)
	DECLARE @PointOrder NVARCHAR(10)
	DECLARE @NOC NVARCHAR(20)
	
	SET @PointRes = [dbo].[Fun_BD_GetMatchPointType](@MatchID)
	IF @PointRes = '0'
	BEGIN
		SELECT '' AS PointDes,'' AS NOC, '' AS PlayerName
		RETURN
	END
		
		
	IF LEFT(@PointRes, 1) = 'A'
	BEGIN
		SELECT @NOC = '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(A.F_RegisterID), @PlayerName = REPLACE(B.F_TvShortName,'/',' / ') FROM TS_Match_Result AS A
		LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 1
	END
	ELSE
	BEGIN
		SELECT @NOC = '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(A.F_RegisterID), @PlayerName = REPLACE(B.F_TvShortName,'/',' / ') FROM TS_Match_Result AS A
		LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 2
	END
	
	SET @PointOrder = RIGHT(@PointRes, 1)
	IF @PointOrder = '1'
		SET @PointDes = '��  ��'
	ELSE IF @PointOrder = '2'
		SET @PointDes = '��  ��'
	ELSE IF @PointOrder = '3'
		SET @PointDes = '��  ��'
	ELSE IF @PointOrder = '4'
		SET @PointDes = '��  ��'
	
	IF @PointOrder IN ('3','4')
	BEGIN
		DECLARE @MatchType INT
		SELECT @MatchType=F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
		IF @MatchType = 3
		BEGIN
			DECLARE @CurrentSetID INT
			SET @CurrentSetID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 1)
			IF @CurrentSetID != 0
			BEGIN
				IF LEFT(@PointRes, 1) = 'A'
				BEGIN
					SET @PlayerName = 
					( 
						SELECT REPLACE(B.F_TvShortName,'/',' / ') FROM TS_Match_Split_Result AS A 
						LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
						WHERE A.F_MatchID = @MatchID AND F_MatchSplitID = @CurrentSetID AND A.F_CompetitionPosition = 1
					)
				END
				ELSE
				BEGIN
					SET @PlayerName = 
					( 
						SELECT REPLACE(B.F_TvShortName,'/',' / ') FROM TS_Match_Split_Result AS A 
						LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
						WHERE A.F_MatchID = @MatchID AND F_MatchSplitID = @CurrentSetID AND A.F_CompetitionPosition = 2
					)
				END
			END
		END
	END
	
	SELECT @PointDes AS PointDes,@NOC AS NOC, @PlayerName AS PlayerName
	
SET NOCOUNT OFF
END


GO


