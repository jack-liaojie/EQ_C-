IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HO_GetMatchActionList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HO_GetMatchActionList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_Report_HO_GetMatchActionList]
--描    述：得到比赛中Action,根据参数取不同的条目
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年8月27日
--修改记录：

CREATE PROCEDURE [dbo].[Proc_Report_HO_GetMatchActionList]
                 @MatchID             INT,
                 @SOrder              INT,
                 @Count               INT,
                 @Type                INT, --1:正常比赛 2:加时赛
                 @LanguageCode        NVARCHAR(3)

AS
BEGIN
   SET NOCOUNT ON
   
   CREATE TABLE #TableAction(
                               F_ActionNumberID           INT,
                               F_MatchID                  INT,
                               F_MatchSplitID             INT,
                               F_RegisterID               INT,
                               F_CompetitionPosition      INT,
                               F_ActionHappenTime         NVARCHAR(100),
                               F_ActionLongName           NVARCHAR(100),
                               F_ActionOrder              INT,
                               F_LongName                 NVARCHAR(150),
                               F_ShirtNumber              INT,
                               F_ActionCode               NVARCHAR(10),
                               F_Comment                  NVARCHAR(10),
                               F_DelegationCode           NVARCHAR(10),
                               F_Score                    NVARCHAR(10),
                               F_Order                    INT
                               )
                               
   CREATE TABLE #Action( 
                               F_DelegationCode           NVARCHAR(10),
                               F_ShirtNumber              INT,
                               F_Comment                  NVARCHAR(10),  
                               F_Score                    NVARCHAR(10), 
                               F_ActionTime               NVARCHAR(10)         
                         )
   INSERT INTO #TableAction(F_ActionNumberID, F_MatchID, F_MatchSplitID, F_RegisterID, F_CompetitionPosition
   , F_ActionHappenTime, F_ActionLongName, F_ActionOrder, F_LongName, F_ShirtNumber, F_ActionCode
   , F_Comment, F_DelegationCode, F_Score, F_Order)                           
   SELECT A.F_ActionNumberID, A.F_MatchID, A.F_MatchSplitID, A.F_RegisterID, A.F_CompetitionPosition,
		CONVERT(NVARCHAR(100),(datePart(HOUR,A.F_ActionHappenTime)*3600+datePart(MINUTE,A.F_ActionHappenTime)*60)/60)
		+':'+
		CASE WHEN LEN(CONVERT(NVARCHAR(100),datePart(SECOND,A.F_ActionHappenTime)%60))=1
        THEN '0'+CONVERT(NVARCHAR(100),datePart(SECOND,A.F_ActionHappenTime)%60)
        ELSE 
		 CONVERT(NVARCHAR(100),datePart(SECOND,A.F_ActionHappenTime)%60)
        END  
          
          AS F_ActionHappenTime
          , AD.F_ActionLongName, A.F_ActionOrder
          , B.F_LongName, C.F_ShirtNumber
          , AC.F_ActionCode, AC.F_Comment, DE.F_DelegationCode
          , CAST(A.F_ActionDetail7 AS NVARCHAR(3)) + ' - ' + CAST(A.F_ActionDetail8 AS NVARCHAR(3))
          , RANK() OVER(ORDER BY CONVERT(INT, D.F_MatchSplitCode), datePart(HOUR,A.F_ActionHappenTime),datePart(MINUTE,A.F_ActionHappenTime),datePart(SECOND,A.F_ActionHappenTime),A.F_ActionOrder) AS F_Order
        FROM TS_Match_Split_Info AS D
                LEFT JOIN TS_Match_ActionList AS A ON A.F_MatchSplitID = D.F_MatchSplitID AND A.F_MatchID = D.F_MatchID
                LEFT JOIN TR_Register as R ON A.F_RegisterID = R.F_RegisterID
                LEFT JOIN TC_Delegation AS DE ON R.F_DelegationID = DE.F_DelegationID
                LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
                LEFT JOIN TS_Match_Member AS C ON A.F_RegisterID = C.F_RegisterID AND A.F_MatchID = C.F_MatchID
                LEFT JOIN TD_ActionType AS AC ON A.F_ActionTypeID = AC.F_ActionTypeID
                LEFT JOIN TD_ActionType_Des AS AD ON AC.F_ActionTypeID = AD.F_ActionTypeID AND AD.F_LanguageCode = @LanguageCode
           WHERE D.F_MatchID = @MatchID AND A.F_MatchSplitID IS NOT NULL AND AC.F_ActionEffect = 1
           ORDER BY CONVERT(INT, D.F_MatchSplitCode), datePart(HOUR,A.F_ActionHappenTime),datePart(MINUTE,A.F_ActionHappenTime),datePart(SECOND,A.F_ActionHappenTime),A.F_ActionOrder  
           
           IF @Type = 1
           BEGIN
			   INSERT INTO #Action(F_DelegationCode, F_Comment, F_ShirtNumber, F_ActionTime, F_Score)
			   SELECT F_DelegationCode, F_Comment, F_ShirtNumber, SUBSTRING(F_ActionHappenTime, 0, LEN(F_ActionHappenTime) - 2) AS F_ActionTime, F_Score FROM #TableAction
			   WHERE F_MatchSplitID IN (1, 2) AND F_Order >= @SOrder AND F_Order < @SOrder + @Count
	           
			   DECLARE @Count1 AS INT
			   SELECT @Count1 = COUNT(F_Score) FROM #Action
	           
			   WHILE ((@Count - @Count1) > 0)
			   BEGIN
				   INSERT INTO #Action(F_DelegationCode)
				   VALUES ('')
				   SET @Count1 = @Count1 + 1
			   END
           END
           ELSE IF @Type = 2
           BEGIN
               INSERT INTO #Action(F_DelegationCode, F_Comment, F_ShirtNumber, F_ActionTime, F_Score)
			   SELECT TOP 1 F_DelegationCode, F_Comment, F_ShirtNumber, SUBSTRING(F_ActionHappenTime, 0, LEN(F_ActionHappenTime) - 2) AS F_ActionTime, F_Score FROM #TableAction
			   WHERE F_MatchSplitID IN (3, 4)
           END
           
           SELECT * FROM #Action
           
Set NOCOUNT OFF
End
	

go
/*exec [Proc_Report_HO_GetMatchActionList] 18, 1, 5,'CHN'*/