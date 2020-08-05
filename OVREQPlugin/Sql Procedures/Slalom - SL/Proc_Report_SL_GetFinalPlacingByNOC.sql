IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetFinalPlacingByNOC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetFinalPlacingByNOC]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----名    称: [Proc_Report_SL_GetFinalPlacingByNOC]
----描    述: 激流回旋项目报表获取 NOC 最终排名  
----参数说明: 
----说    明: 
----创 建 人: 吴定昉
----日    期: 2010年01月25日
----修改记录： 
/*			
			时间				修改人		修改内容	
			2012年09月12日       吴定昉      为满足国内运动会的报表要求，数据库结构字段发生变化进行修正。
*/


CREATE PROCEDURE [dbo].[Proc_Report_SL_GetFinalPlacingByNOC]
	@DisciplineID					INT,
    @LanguageCode				CHAR(3)	
AS
BEGIN
SET NOCOUNT ON

	-- 临时表: 存储最终排名
	CREATE TABLE #FinalPlacingByNOC
	(
		[NOC]				CHAR(3) collate database_default,
        [NOCOrder]          INT,
		[NOCLongName]		NVARCHAR(200),
		[NOCShortName]		NVARCHAR(100),
		[MK1]		        NVARCHAR(10),
		[MC1]		        NVARCHAR(10),
		[MC2]		        NVARCHAR(10),
		[WK1]		        NVARCHAR(10)
	)

	INSERT #FinalPlacingByNOC
	([NOC], [NOCOrder], [NOCLongName], [NOCShortName])
	(
		SELECT D.F_DelegationCode AS [NOC]
		    , D.F_DelegationID AS [NOCOrder]
			, DD.F_DelegationLongName AS [NOCLongName]
			, DD.F_DelegationShortName AS [NOCShortName]
		FROM TS_ActiveDelegation AS AD
		LEFT JOIN TC_Delegation AS D
		    ON AD.F_DelegationID = D.F_DelegationID
		LEFT JOIN TC_Delegation_Des AS DD
			ON D.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
		WHERE AD.F_DisciplineID = @DisciplineID
		AND D.F_DelegationType = N'N'
	)

    
	DECLARE @EventID INT
    DECLARE @NOC     CHAR(3)
    DECLARE @Rank    INT
    DECLARE @LastRank    INT
    DECLARE @NewRank    INT
    DECLARE @MaxDisPos    INT
    DECLARE @EventIdx INT
    DECLARE @nDisPos INT
  	SET @EventIdx = 1

    CREATE TABLE #TempRankList
    (
		[NOC] CHAR(3) collate database_default,
        [Rank] INT
    )

    CREATE TABLE #TempResultList
    (
		[NOC] CHAR(3) collate database_default,
        [Rank] INT
    )

	WHILE @EventIdx <= 4
	BEGIN
        IF @EventIdx = 1
			SELECT @EventID = E.F_EventID FROM TS_Event AS E 
			WHERE E.F_DisciplineID = @DisciplineID AND E.F_EventCode = '110' AND E.F_SexCode = '1' 
		ELSE IF @EventIdx = 2
 			SELECT @EventID = E.F_EventID FROM TS_Event AS E 
			WHERE E.F_DisciplineID = @DisciplineID AND E.F_EventCode = '210' AND E.F_SexCode = '1' 
		ELSE IF @EventIdx = 3
 			SELECT @EventID = E.F_EventID FROM TS_Event AS E 
			WHERE E.F_DisciplineID = @DisciplineID AND E.F_EventCode = '220' AND E.F_SexCode = '1' 
		ELSE
 			SELECT @EventID = E.F_EventID FROM TS_Event AS E 
			WHERE E.F_DisciplineID = @DisciplineID AND E.F_EventCode = '110' AND E.F_SexCode = '2' 
		
		SET @MaxDisPos = 0
		SET @MaxDisPos = (SELECT MAX(case when F_EventDisplayPosition IS null then 0 else F_EventDisplayPosition end) FROM TS_Event_Result WHERE f_eventid = @EventID)

        SET @LastRank = -1
        SET @nDisPos = 1
		SET @NewRank = 0
		
        WHILE @nDisPos <= @MaxDisPos
        BEGIN
            SET @Rank = NULL
            SET @NOC = NULL

 			SELECT @Rank = ER.F_EventRank, @NOC = D.F_DelegationCode FROM TS_Event_Result AS ER
			LEFT JOIN TR_Register AS R ON ER.F_RegisterID = R.F_RegisterID 
			LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
			WHERE ER.F_EventID = @EventID 
			AND D.F_DelegationCode IS NOT NULL AND D.F_DelegationCode <> ''
			AND ER.F_EventDisplayPosition = @nDisPos
			
			IF NOT EXISTS(SELECT [NOC] FROM #TempRankList WHERE [NOC] = @NOC)
			BEGIN
			  IF @Rank IS NOT NULL --对于有项目名次的NOC
			  BEGIN
				 IF @Rank <> @LastRank --when @LastRank = -1 @NewRank = 0
					SET @NewRank = @NewRank + 1
				 INSERT #TempRankList([NOC],[Rank]) VALUES(@NOC,@NewRank)
			  END
			  ELSE --对于没有项目名次的NOC
			  BEGIN
			    INSERT #TempRankList([NOC],[Rank]) VALUES(@NOC,NULL)
			  END
			  SET @LastRank = @Rank
			END			
			
			SET @nDisPos = @nDisPos + 1		
       END

	   IF @EventIdx = 1
	   BEGIN
	     UPDATE #FinalPlacingByNOC SET MK1 = '' WHERE NOC NOT IN (SELECT NOC FROM #TempRankList)
	     UPDATE #FinalPlacingByNOC SET MK1 = (
		   case when R.Rank = 1 then cast(R.Rank as NVARCHAR(8)) + 'st'
			    when R.Rank = 2 then cast(R.Rank as NVARCHAR(8)) + 'nd' 
			    when R.Rank = 3 then cast(R.Rank as NVARCHAR(8)) + 'rd'
			    when R.Rank > 3 then cast(R.Rank as NVARCHAR(8)) + 'th'
                else '' end)
		 FROM #FinalPlacingByNOC AS F,#TempRankList AS R
		 WHERE F.NOC = R.NOC
       END
	   ELSE IF @EventIdx = 2
	   BEGIN
		 UPDATE #FinalPlacingByNOC SET MC1 = '' WHERE NOC NOT IN (SELECT NOC FROM #TempRankList)
		 UPDATE #FinalPlacingByNOC SET MC1 = (
		   case when R.Rank = 1 then cast(R.Rank as NVARCHAR(8)) + 'st'
		        when R.Rank = 2 then cast(R.Rank as NVARCHAR(8)) + 'nd' 
			    when R.Rank = 3 then cast(R.Rank as NVARCHAR(8)) + 'rd'
			    when R.Rank > 3 then cast(R.Rank as NVARCHAR(8)) + 'th'
                else '' end)
		 FROM #FinalPlacingByNOC AS F,#TempRankList AS R
	     WHERE F.NOC = R.NOC
	   END
	   ELSE IF @EventIdx = 3
	   BEGIN
	     UPDATE #FinalPlacingByNOC SET MC2 = '' WHERE NOC NOT IN (SELECT NOC FROM #TempRankList)
		 UPDATE #FinalPlacingByNOC SET MC2 = (
		   case when R.Rank = 1 then cast(R.Rank as NVARCHAR(8)) + 'st'
			    when R.Rank = 2 then cast(R.Rank as NVARCHAR(8)) + 'nd' 
			    when R.Rank = 3 then cast(R.Rank as NVARCHAR(8)) + 'rd'
			    when R.Rank > 3 then cast(R.Rank as NVARCHAR(8)) + 'th'
                else '' end)
	     FROM #FinalPlacingByNOC AS F,#TempRankList AS R
		 WHERE F.NOC = R.NOC
	   END
	   ELSE
	   BEGIN
	     UPDATE #FinalPlacingByNOC SET WK1 = '' WHERE NOC NOT IN (SELECT NOC FROM #TempRankList)
	     UPDATE #FinalPlacingByNOC SET WK1 = (
		   case when R.Rank = 1 then cast(R.Rank as NVARCHAR(8)) + 'st'
		        when R.Rank = 2 then cast(R.Rank as NVARCHAR(8)) + 'nd' 
			    when R.Rank = 3 then cast(R.Rank as NVARCHAR(8)) + 'rd'
			    when R.Rank > 3 then cast(R.Rank as NVARCHAR(8)) + 'th'
                else '' end)
		 FROM #FinalPlacingByNOC AS F,#TempRankList AS R
		 WHERE F.NOC = R.NOC
	   END
		 
	   SET @EventIdx = @EventIdx + 1
		  
	   DELETE #TempRankList 
    END
           
	SELECT * FROM #FinalPlacingByNOC Order by NOCOrder

SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

-- Just for test
EXEC [Proc_Report_SL_GetFinalPlacingByNOC] 67,'eng'

*/