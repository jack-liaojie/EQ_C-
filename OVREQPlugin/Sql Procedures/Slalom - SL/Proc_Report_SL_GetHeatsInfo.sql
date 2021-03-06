IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetHeatsInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetHeatsInfo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_Report_SL_GetHeatsInfo]
----功		  能：得到当前Heats信息
----作		  者：吴定昉
----日		  期: 2010-11-01 

CREATE PROCEDURE [dbo].[Proc_Report_SL_GetHeatsInfo]
             @MatchID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @EventCode		NVARCHAR(10)
    DECLARE @SexCode        INT
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @MatchCode		NVARCHAR(10)
	DECLARE @Run1MatchID	INT
	DECLARE @Run2MatchID	INT
	DECLARE @SQL		    NVARCHAR(max)

	SELECT @EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @PhaseCode = P.F_PhaseCode, 
    @MatchCode = M.F_MatchCode FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
    WHERE F_MatchID = @MatchID

    IF @PhaseCode = '9'
    BEGIN 
		SELECT @Run1MatchID = M.F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		WHERE E.F_EventCode = @EventCode 
        AND E.F_SexCode = @SexCode
        AND P.F_PhaseCode = @PhaseCode
        AND M.F_MatchCode = '01' 

		SELECT @Run2MatchID = M.F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		WHERE E.F_EventCode = @EventCode 
        AND E.F_SexCode = @SexCode
        AND P.F_PhaseCode = @PhaseCode
        AND M.F_MatchCode = '02' 
    END
    ELSE
    BEGIN
		SELECT @Run1MatchID = M.F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		WHERE E.F_EventCode = @EventCode 
        AND E.F_SexCode = @SexCode
        AND P.F_PhaseCode = '2'
        AND M.F_MatchCode = '01' 

		SELECT @Run2MatchID = M.F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		WHERE E.F_EventCode = @EventCode 
        AND E.F_SexCode = @SexCode
        AND P.F_PhaseCode = '1'
        AND M.F_MatchCode = '01' 

        SET @Run1MatchID = @MatchID
        SET @Run2MatchID = @MatchID
    END

	CREATE TABLE #TempTable
	(
		Run1StartTime			NVARCHAR(50),
		Run1EndTime			    NVARCHAR(50),
		Run2StartTime			NVARCHAR(50),
		Run2EndTime			    NVARCHAR(50)
	)

	-- 在临时表中插入基本信息
	INSERT #TempTable 
	(Run1StartTime, Run1EndTime, Run2StartTime, Run2EndTime)
	(
	SELECT  
	LEFT(CONVERT(NVARCHAR(100), M1.F_StartTime, 114), 5) AS Run1StartTime
	, LEFT(CONVERT(NVARCHAR(100), M1.F_EndTime, 114), 5) AS Run1EndTime
	, LEFT(CONVERT(NVARCHAR(100), M2.F_StartTime, 114), 5) AS Run2StartTime
	, LEFT(CONVERT(NVARCHAR(100), M2.F_EndTime, 114), 5) AS Run2EndTime
	FROM TS_Match AS M  
	LEFT JOIN TS_Match AS M1 ON M1.F_MatchID = @Run1MatchID    
	LEFT JOIN TS_Match AS M2 ON M2.F_MatchID = @Run2MatchID    
	WHERE M.F_MatchID = @MatchID 
	)

	SELECT * FROM #TempTable

Set NOCOUNT OFF
End
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*

-- Just for test
EXEC [Proc_Report_SL_GetHeatsInfo] 1,'eng'

*/
