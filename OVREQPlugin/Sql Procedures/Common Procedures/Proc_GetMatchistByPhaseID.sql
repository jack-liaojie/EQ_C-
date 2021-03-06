IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetMatchistByPhaseID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetMatchistByPhaseID]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_GetMatchistByPhaseID]
----功		  能：得到Phase节点下的所有的Match
----作		  者：郑金勇
----日		  期: 2009-11-11 
--修改记录：
/*			
			时间				修改人		修改内容	
			2009年12月09日		邓年彩		先按照 MatchNum 排序
*/


CREATE PROCEDURE [dbo].[Proc_GetMatchistByPhaseID](
@PhaseID				INT,
@MatchID				INT,
@LanguageCode			CHAR(3)
)  	

AS
BEGIN
	
SET NOCOUNT ON
	DECLARE @EventID AS INT

	CREATE TABLE #Temp_Matches(F_MatchLongName	NVARCHAR(100),
						 F_MatchID			INT)
	IF @PhaseID IS NULL OR @PhaseID = 0
	BEGIN
		SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID
		SELECT @EventID = F_EventID FROM TS_Phase WHERE F_PhaseID = @PhaseID
		INSERT INTO #Temp_Matches (F_MatchID, F_MatchLongName)
			SELECT A.F_MatchID, B.F_MatchLongName FROM TS_Match AS A LEFT JOIN TS_Match_Des AS B ON A.F_MatchID = B.F_MatchID AND B.F_LanguageCode = @LanguageCode
				LEFT JOIN TS_Phase AS C ON A.F_PhaseID = C.F_PhaseID 
					WHERE C.F_EventID = @EventID ORDER BY A.F_MatchNum, A.F_Order
	END
	ELSE
	BEGIN
		INSERT INTO #Temp_Matches (F_MatchID, F_MatchLongName)
			SELECT A.F_MatchID, B.F_MatchLongName FROM TS_Match AS A LEFT JOIN TS_Match_Des AS B ON A.F_MatchID = B.F_MatchID AND B.F_LanguageCode = @LanguageCode
				WHERE A.F_PhaseID = @PhaseID ORDER BY A.F_MatchNum, A.F_Order
	END
		
	INSERT INTO #Temp_Matches (F_MatchID, F_MatchLongName) VALUES (0, 'NONE')
	SELECT F_MatchLongName, F_MatchID FROM #Temp_Matches

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

GO


