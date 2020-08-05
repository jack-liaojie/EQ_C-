IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchActionList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchActionList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_TE_GetMatchActionList]
----功		  能：得到一场比赛的动作列表
----作		  者：郑金勇 
----日		  期: 2009-08-12
----修 改  记 录：
/*
                   李燕   2011-2-17   增加ResultDes描述 F_ActionDetail7表示GamePoint，SetPoint，MatchPoint
                   李燕   2011-6-28   增加SubMatchCode，用于团体赛
                   
*/

CREATE PROCEDURE [dbo].[Proc_TE_GetMatchActionList] (	
	@MatchID					INT,
	@SubMatchCode               INT,   ---- -1，个人赛
	@ActionType					INT,
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
SET NOCOUNT ON

	DECLARE @DisciplineID AS INT
	SELECT @DisciplineID = C.F_DisciplineID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
		LEFT JOIN TS_Event AS C ON B.F_EventID= C.F_EventID WHERE A.F_MatchID = @MatchID
		
	DECLARE @SplitMatchID  INT
	SET @SplitMatchID = 0
	SELECT @SplitMatchID = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SubMatchCode AND F_FatherMatchSplitID = 0
		
	CREATE TABLE #Temp_ActionList(F_ActionNumberID		INT,
								  F_MatchID				INT,
								  F_ActionOrder			INT,
								  F_SetNum				INT,
								  F_GameNum				INT,
								  F_ServerRegister		NVARCHAR(100),
								  F_PointRegister		NVARCHAR(100),
								  F_Stroke				NVARCHAR(100),
								  F_ActionDetail3		INT,
								  F_ActionDetail4		INT,
								  F_ActionDetail5		INT,
								  F_ActionDetail6		INT,
								  F_ActionDetail7       INT,
								  F_Fault				NVARCHAR(50),
								  F_ScoreDes			NVARCHAR(50),
								  F_ResultDes           NVARCHAR(50),
								  F_CriticalPoint			NVARCHAR(50),
								  F_CriticalPointPosition	INT,
								  F_ServerRegisterID		INT,
								  F_PointRegisterID			INT
								  )
	
	IF(@SubMatchCode = -1)
	BEGIN							  
		INSERT INTO #Temp_ActionList(F_ActionNumberID, F_MatchID, F_ActionOrder, F_SetNum, F_GameNum, F_ActionDetail3, F_ActionDetail4, F_ActionDetail5, F_ActionDetail6, F_ScoreDes, F_ActionDetail7, F_CriticalPointPosition, F_CriticalPoint, F_ServerRegisterID, F_PointRegisterID)
			SELECT A.F_ActionNumberID, A.F_MatchID, A.F_ActionOrder, A.F_ActionDetail1 AS F_SetNum, A.F_ActionDetail2 AS F_GameNum, A.F_ActionDetail3, A.F_ActionDetail4, A.F_ActionDetail5, A.F_ActionDetail6, A.F_ScoreDes, A.F_ActionDetail7, A.F_CriticalPointPosition, A.F_CriticalPoint, B.F_RegisterID AS F_ServerRegisterID, C.F_RegisterID AS F_PointRegisterID 
				FROM TS_Match_ActionList AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_ServerPosition = B.F_CompetitionPosition
				LEFT JOIN TS_Match_Result AS C ON A.F_MatchID = C.F_MatchID AND A.F_PointPosition = C.F_CompetitionPosition  
				WHERE A.F_MatchID = @MatchID AND F_MatchSplitID = @SplitMatchID  AND A.F_ActionTypeID = @ActionType 
   END
   ELSE
   BEGIN
       INSERT INTO #Temp_ActionList(F_ActionNumberID, F_MatchID, F_ActionOrder, F_SetNum, F_GameNum, F_ActionDetail3, F_ActionDetail4, F_ActionDetail5, F_ActionDetail6, F_ScoreDes, F_ActionDetail7, F_CriticalPointPosition, F_CriticalPoint, F_ServerRegisterID, F_PointRegisterID)
			SELECT A.F_ActionNumberID, A.F_MatchID, A.F_ActionOrder, A.F_ActionDetail1 AS F_SetNum, A.F_ActionDetail2 AS F_GameNum, A.F_ActionDetail3, A.F_ActionDetail4, A.F_ActionDetail5, A.F_ActionDetail6, A.F_ScoreDes, A.F_ActionDetail7, A.F_CriticalPointPosition, A.F_CriticalPoint, B.F_RegisterID AS F_ServerRegisterID, C.F_RegisterID AS F_PointRegisterID 
				FROM TS_Match_ActionList AS A 
				LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_ServerPosition = B.F_CompetitionPosition AND A.F_MatchSplitID = B.F_MatchSplitID
				LEFT JOIN TS_Match_Split_Result AS C ON A.F_MatchID = C.F_MatchID AND A.F_PointPosition = C.F_CompetitionPosition  AND A.F_MatchSplitID = C.F_MatchSplitID
				WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @SplitMatchID  AND A.F_ActionTypeID = @ActionType 
   END
	
	UPDATE A SET A.F_ServerRegister = B.F_LongName FROM #Temp_ActionList AS A LEFT JOIN TR_Register_Des AS B ON A.F_ServerRegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	UPDATE A SET A.F_PointRegister = B.F_LongName FROM #Temp_ActionList AS A LEFT JOIN TR_Register_Des AS B ON A.F_PointRegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	UPDATE A SET F_Stroke = ISNULL(B.F_ActionCode, '') + ' ' +ISNULL(C.F_ActionCode, '') + ' ' +ISNULL(D.F_ActionCode, '')
		FROM #Temp_ActionList AS A LEFT JOIN TD_ActionType AS B ON A.F_ActionDetail3 = B.F_ActionTypeID AND B.F_DisciplineID = @DisciplineID
		LEFT JOIN TD_ActionType AS C ON A.F_ActionDetail4 = C.F_ActionTypeID AND C.F_DisciplineID = @DisciplineID
		LEFT JOIN TD_ActionType AS D ON A.F_ActionDetail5 = D.F_ActionTypeID AND D.F_DisciplineID = @DisciplineID
	UPDATE #Temp_ActionList SET F_CriticalPoint = CASE F_CriticalPoint WHEN 0 THEN NULL WHEN 1 THEN 'Game Point' WHEN 2 THEN 'Set Point' WHEN 3 THEN 'Match Point' ELSE NULL END
	UPDATE #Temp_ActionList SET F_Fault = CASE F_ActionDetail6 WHEN 0 THEN NULL WHEN 1 THEN 'Fault' WHEN 2 THEN 'Double Fault' ELSE NULL END
	
	UPDATE #Temp_ActionList SET F_ResultDes = CASE F_ActionDetail7 WHEN 1 THEN 'Game Over' WHEN 2 THEN 'Set Over' WHEN 3 THEN 'Match Over' ELSE F_ScoreDes END
	
	SELECT F_ActionNumberID, F_MatchID, F_ActionOrder, F_SetNum AS [Set], F_GameNum AS Game, F_ServerRegister AS [Server], F_Fault AS [Fault], F_PointRegister AS [Point], F_Stroke AS Stroke, F_ResultDes AS Score, F_CriticalPoint AS CriticalPoint
		FROM #Temp_ActionList ORDER BY F_ActionOrder
		
SET NOCOUNT OFF
END






GO

 --EXEC [Proc_TE_GetMatchActionList] 1, -1, 'ENG'
 --EXEC [Proc_TE_GetMatchActionList] 1, 1, -2, 'ENG'
