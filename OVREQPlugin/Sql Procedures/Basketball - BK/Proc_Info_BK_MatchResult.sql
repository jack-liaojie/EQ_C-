IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_BK_MatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_BK_MatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----名   称：[Proc_Info_BK_MatchResult]
----功   能：比赛成绩、单场或者多场
----作	 者：吴定昉
----日   期：2012-09-11 

/*
	参数说明：
	序号	参数名称	参数说明
	1		@MatchID	指定的比赛ID
*/

/*
	功能描述：按照交换协议规范，组织数据。
			  此存储过程遵照内部的MS SQL SERVER编码规范。
			  
*/

/*
修改记录：
	序号	日期			修改者		修改内容
	1						

*/

CREATE PROCEDURE [dbo].[Proc_Info_BK_MatchResult]
		@MatchID			AS INT
AS
BEGIN
	
SET NOCOUNT ON

    DECLARE @DisciplineCode AS NVARCHAR(50)
    DECLARE @GenderCode     AS NVARCHAR(50)
    DECLARE @EventCode      AS NVARCHAR(50)
    DECLARE @EventID        AS INT
    DECLARE @PhaseCode      AS NVARCHAR(50)
    DECLARE @UnitCode       AS NVARCHAR(50)
    DECLARE @VunueCode      AS NVARCHAR(50)
	DECLARE @LanguageCode   AS CHAR(3)	
	DECLARE @MatchStatusID  INT
	
	SELECT @DisciplineCode = D.F_DisciplineCode, @GenderCode = S.F_GenderCode
	, @EventCode = E.F_EventCode, @EventID = E.F_EventID
	, @PhaseCode = P.F_PhaseCode, @UnitCode = M.F_MatchCode
	, @VunueCode = V.F_VenueCode, @MatchStatusID = M.F_MatchStatusID
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	LEFT JOIN TC_Venue AS V ON M.F_VenueID = V.F_VenueID
	WHERE F_MatchID = @MatchID
	
	SET @LanguageCode = ISNULL( @LanguageCode, 'CHN')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

	DECLARE @Content AS NVARCHAR(MAX)
	
	
	CREATE TABLE #Temp_Table
	(
	    [MatchID]           INT,
        [Match]             NVARCHAR(100),
        [Phase]             NVARCHAR(100),
        [Venue]             NVARCHAR(100),
		[StartTime]	        NVARCHAR(100),
		[DelegationName_A]	NVARCHAR(100),
		[DelegationName_B]  NVARCHAR(100),
		[Result1]	  NVARCHAR(10),
		[Result2]	  NVARCHAR(10),
		[Result3]	  NVARCHAR(10),
		[Result4]	  NVARCHAR(10),
		[Result5]	  NVARCHAR(10),
		[Result6]	  NVARCHAR(10),
		[Result]	  NVARCHAR(10),
		[Status]	  NVARCHAR(10),
	)

    INSERT #Temp_Table([MatchID],
        [Match],[Phase],[Venue],[StartTime],
		[DelegationName_A],[DelegationName_B],
		[Result],[Status])
	(
    SELECT M.F_MatchID,
           M.F_MatchNum,PD.F_PhaseLongName,VD.F_VenueLongName,LEFT(CONVERT (NVARCHAR(100), M.F_StartTime, 108), 5),
          DDA.F_DelegationLongName,DDB.F_DelegationLongName,
          CASE WHEN M.F_MatchStatusID = 110 THEN CONVERT(NVARCHAR(100), MRA.F_Points) +' : '+CONVERT(NVARCHAR(100),MRB.F_Points) 
          ELSE '' END,
          M.F_MatchStatusID
    FROM TS_Match as M
    LEFT join TC_Venue as V on M.F_VenueID=V.F_VenueID
    LEFT join TC_Venue_Des as VD on M.F_VenueID=VD.F_VenueID and VD.F_LanguageCode=@LanguageCode
    LEFT join TS_Match_Result as MRA on M.F_MatchID=MRA.F_MatchID and MRA.F_CompetitionPosition=1 --比赛双方
    LEFT join TR_Register as RA on MRA.F_RegisterID=RA.F_RegisterID
    LEFT JOIN TC_Delegation AS DA ON RA.F_DelegationID = DA.F_DelegationID
    LEFT join TC_Delegation_Des as DDA on RA.F_DelegationID=DDA.F_DelegationID and DDA.F_LanguageCode=@LanguageCode
    LEFT join TS_Match_Result as MRB on M.F_MatchID=MRB.F_MatchID and MRB.F_CompetitionPosition=2 --比赛双方
    LEFT join TR_Register as RB on MRB.F_RegisterID=RB.F_RegisterID
    LEFT JOIN TC_Delegation AS DB ON RB.F_DelegationID = DB.F_DelegationID
    LEFT join TC_Delegation_Des as DDB on RB.F_DelegationID=DDB.F_DelegationID and DDB.F_LanguageCode=@LanguageCode
    LEFT join TS_Phase as P on M.F_PhaseID=P.F_PhaseID
    LEFT join TS_Phase_Des as PD on M.F_PhaseID=PD.F_PhaseID and PD.F_LanguageCode=@LanguageCode
    LEFT join TS_Event as E on P.F_EventID=E.F_EventID
    LEFT join TS_Discipline as DL on E.F_DisciplineID=DL.F_DisciplineID
    LEFT JOIN TS_Round AS R ON R.F_RoundID = M.F_RoundID
    LEFT JOIN TS_Round_Des AS RD ON RD.F_RoundID = M.F_RoundID and RD.F_LanguageCode=@LanguageCode
    WHERE 1=1
    --AND M.F_MatchID = @MatchID
    AND M.F_MatchNum < 100 
	)
	
	
    DECLARE @TempMatchID AS INT
    DECLARE @1T_A AS NVARCHAR(100)
    DECLARE @1T_B AS NVARCHAR(100)
    DECLARE @1T   AS NVARCHAR(100)
    DECLARE @2T_A AS NVARCHAR(100)
    DECLARE @2T_B AS NVARCHAR(100)
    DECLARE @2T   AS NVARCHAR(100)
    DECLARE @3T_A AS NVARCHAR(100)
    DECLARE @3T_B AS NVARCHAR(100)
    DECLARE @3T   AS NVARCHAR(100)
    DECLARE @4T_A AS NVARCHAR(100)
    DECLARE @4T_B AS NVARCHAR(100)
    DECLARE @4T   AS NVARCHAR(100)
    DECLARE @ET_A AS NVARCHAR(100)
    DECLARE @ET_B AS NVARCHAR(100)
    DECLARE @ET   AS NVARCHAR(100)


    DECLARE Match_CURSOR CURSOR FOR 
	SELECT MatchID FROM #Temp_table WHERE [Status] = 110
	OPEN Match_CURSOR
	FETCH NEXT FROM Match_CURSOR INTO @TempMatchID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		exec dbo.[Proc_Report_BK_GetMatchResult] @MatchID,@1T_A OUTPUT,@1T_B OUTPUT,@1T OUTPUT,
		@2T_A OUTPUT,@2T_B OUTPUT,@2T OUTPUT,@3T_A OUTPUT,@3T_B OUTPUT,@3T OUTPUT,
		@4T_A OUTPUT,@4T_B OUTPUT,@4T OUTPUT,@ET_A OUTPUT,@ET_B OUTPUT,@ET OUTPUT
		
		UPDATE A SET A.[Result1] = @1T,
		A.[Result2] = @2T,
		A.[Result3] = @3T,
		A.[Result4] = @4T,
		A.[Result5] = @ET FROM #Temp_table AS A WHERE A.MatchID = @TempMatchID
		SELECT @1T_A = NULL,@1T_B = NULL,@1T = NULL,@2T_A = NULL,@2T_B = NULL,@2T = NULL,
		@3T_A = NULL,@3T_B = NULL,@3T = NULL,@4T_A = NULL,@4T_B = NULL,@4T = NULL,@ET_A = NULL,@ET_B = NULL,@ET = NULL
		FETCH NEXT FROM Match_CURSOR INTO @TempMatchID
	END
	CLOSE Match_CURSOR
	DEALLOCATE Match_CURSOR
		
    select * from #Temp_Table
    
	SET @Content = ( SELECT [Row].[Match] AS [Match],
	                     [Row].[Phase] AS [Phase],
	                     [Row].[Venue] AS [Venue],
	                     [Row].[StartTime] AS [StartTime],
	                     [Row].[DelegationName_A] AS [DelegationName_A],
	                     [Row].[DelegationName_B] AS [DelegationName_B],
	                     [Row].[Result1] AS [Result1],
	                     [Row].[Result2] AS [Result2],
	                     [Row].[Result3] AS [Result3],
	                     [Row].[Result4] AS [Result4],
	                     ISNULL([Row].[Result5],N'') AS [Result5],
	                     ISNULL([Row].[Result6],N'') AS [Result6],
	                     ISNULL([Row].[Result],N'') AS [Result],
	                     N'' AS [Status]
	            FROM (SELECT * FROM #Temp_Table) AS [Row] ORDER BY cast([Match] as int)
			FOR XML AUTO)

	IF @Content IS NULL
	BEGIN
		SET @Content = N''
		RETURN 
	END

    --SELECT cast( @Content AS XML )
	
	IF @LanguageCode = 'CHN'
	BEGIN
		SET @LanguageCode = 'CHI'
	END

	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N' Language = "' + @LanguageCode + '"'
							+N' Date ="'+ REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(LEFT(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), 5), ':', ''), '.', '')+'"'
    
	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Content
					+ N'
						</Message>'
    	
	DECLARE @OutputEventCode	AS NVARCHAR(10)
	DECLARE @FileName	AS NVARCHAR(100)
	
	SET @OutputEventCode = [dbo].[Func_BK_GetOutputEventCode](@GenderCode, @EventCode)
	SET @FileName =	@DisciplineCode + @GenderCode + @OutputEventCode + @PhaseCode + @UnitCode + N'.0.CHI.1.0'
		
	SELECT @OutputXML AS OutputXML, @FileName AS [FileName]
	RETURN

SET NOCOUNT OFF
END





GO


--EXEC [Proc_Info_BK_MatchResult] 67
--EXEC [Proc_Info_BK_MatchResult] 803