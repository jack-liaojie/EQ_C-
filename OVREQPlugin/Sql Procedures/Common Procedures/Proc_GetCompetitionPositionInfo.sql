IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCompetitionPositionInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCompetitionPositionInfo]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[Proc_GetCompetitionPositionInfo]
----��		  �ܣ��õ�һ��������ĳ������λ�õ���ϸ��Ϣ
----��		  �ߣ�֣����
----��		  ��: 2009-11-11 

CREATE PROCEDURE [dbo].[Proc_GetCompetitionPositionInfo](
@MatchID				INT,
@CompetitionPosition	INT,
@LanguageCode			CHAR(3)
)  	

AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @SourceType	AS INT
	set @SourceType = 0 --0��ʾδ֪��1��ʾPhasePosition��2��ʾPhaseRank��3��ʾMatchRank��4��ʾMatchHistory
	
	IF EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition 
		AND F_StartPhaseID IS NOT NULL AND F_StartPhasePosition IS NOT NULL AND F_StartPhasePosition != 0)
	BEGIN
		SET @SourceType = 1
	END

	IF EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition 
		AND F_SourcePhaseID IS NOT NULL AND F_SourcePhaseRank IS NOT NULL AND F_SourcePhaseRank != 0)
	BEGIN
		SET @SourceType = 2
	END

	IF EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition 
		AND F_SourceMatchID IS NOT NULL AND F_SourceMatchRank IS NOT NULL AND F_SourceMatchRank != 0)
	BEGIN
		SET @SourceType = 3
	END

	IF EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition 
		AND F_HistoryMatchID IS NOT NULL AND F_HistoryMatchRank IS NOT NULL AND F_HistoryMatchRank != 0 AND F_HistoryLevel IS NOT NULL)
	BEGIN
		SET @SourceType = 4
	END

	SELECT *, @SourceType AS PositionSourceType FROM TS_Match_Result AS A LEFT JOIN TS_Match_Result_Des AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TS_Match_Des AS C ON A.F_MatchID = C.F_MatchID AND C.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register_Des AS D ON A.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
--		LEFT JOIN 
			WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = @CompetitionPosition


Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF
GO

SET ANSI_NULLS OFF
GO


