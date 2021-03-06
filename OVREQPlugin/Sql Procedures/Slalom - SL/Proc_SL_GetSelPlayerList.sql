IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SL_GetSelPlayerList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SL_GetSelPlayerList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









--名    称: [Proc_SL_GetSelPlayerList]
--描    述: 激流回旋项目,获取所选比赛队员信息
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年01月04日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_SL_GetSelPlayerList]
	@MatchID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @SQL		    NVARCHAR(max)
	DECLARE @i				INT
	DECLARE @DisciplineCode NVARCHAR(10)
	DECLARE @EventCode		NVARCHAR(10)
    DECLARE @SexCode        INT
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @MatchCode		NVARCHAR(10)
	DECLARE @Run1MatchID	INT
	DECLARE @Run2MatchID	INT
	DECLARE @SplitCount		INT
	DECLARE @SplitOrder		NVARCHAR(100)
	DECLARE @GateCount		INT
	DECLARE @GateOrder		NVARCHAR(100)

	SELECT @DisciplineCode = D.F_DisciplineCode,
	@EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @PhaseCode = P.F_PhaseCode, 
    @MatchCode = M.F_MatchCode FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    WHERE F_MatchID = @MatchID

    IF @PhaseCode = '9'
    BEGIN 
		SELECT @Run1MatchID = M.F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID		
		WHERE E.F_EventCode = @EventCode 
        AND E.F_SexCode = @SexCode
        AND P.F_PhaseCode = @PhaseCode
        AND M.F_MatchCode = '01' 
        AND D.F_DisciplineCode = @DisciplineCode 

		SELECT @Run2MatchID = M.F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
		WHERE E.F_EventCode = @EventCode 
        AND E.F_SexCode = @SexCode
        AND P.F_PhaseCode = @PhaseCode
        AND M.F_MatchCode = '02' 
        AND D.F_DisciplineCode = @DisciplineCode 
    END
    ELSE
    BEGIN
		SELECT @Run1MatchID = M.F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
		WHERE E.F_EventCode = @EventCode 
        AND E.F_SexCode = @SexCode
        AND P.F_PhaseCode = '2'
        AND M.F_MatchCode = '01' 
        AND D.F_DisciplineCode = @DisciplineCode 

		SELECT @Run2MatchID = M.F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
		WHERE E.F_EventCode = @EventCode 
        AND E.F_SexCode = @SexCode
        AND P.F_PhaseCode = '1'
        AND M.F_MatchCode = '01' 
        AND D.F_DisciplineCode = @DisciplineCode 
    END

	-- 计算一场 Match 有几个分段
	SELECT @SplitCount = F_MatchComment1 FROM TS_Match WHERE F_MatchID = @MatchID
	-- 计算一场 Match 有几个门
	SELECT @GateCount = F_MatchComment2	FROM TS_Match WHERE F_MatchID = @MatchID

	-- 创建临时表, 加入基本字段
	CREATE TABLE #MatchResult
	(
		F_CompetitionPosition	INT,
        StartOrder				INT,
		Bib						INT,
		NOC						CHAR(3),
		StartTime				NVARCHAR(50) 
	)
	SET @i = 1
	WHILE @i <= @SplitCount
	BEGIN
		SET @SplitOrder = CAST(@i AS NVARCHAR(2))
		SET @SQL = 'ALTER TABLE #MatchResult ADD [Split ' + @SplitOrder + '] NVARCHAR(100)' 
		EXEC (@SQL)
		SET @i = @i + 1
	END
	SET @SQL = 'ALTER TABLE #MatchResult ADD FinishTime NVARCHAR(50), Pen INT, [Time] NVARCHAR(50),Result NVARCHAR(50)' 
	EXEC (@SQL)
	SET @i = 1
	WHILE @i <= @GateCount
	BEGIN
		SET @GateOrder = CAST(@i AS NVARCHAR(2))
		SET @SQL = 'ALTER TABLE #MatchResult ADD [' + @GateOrder + '] NVARCHAR(2)' 
		EXEC (@SQL)
		SET @i = @i + 1
	END
	SET @SQL = 'ALTER TABLE #MatchResult ADD F_MatchID INT, IRM NVARCHAR(10), [Status] INT, 
				Run1Result NVARCHAR(50), Run2Result NVARCHAR(50), Run1IRM NVARCHAR(10), Run2IRM NVARCHAR(10)' 
	EXEC (@SQL)


	-- 在临时表中插入基本信息
	SET @SQL = 'INSERT #MatchResult
	(F_CompetitionPosition,StartOrder,Bib, NOC, StartTime, ' 
	SET @i = 1
	WHILE @i <= @SplitCount
	BEGIN
		SET @SplitOrder = CAST(@i AS NVARCHAR(2))
		SET @SQL = @SQL + '[Split ' + @SplitOrder + '],' 
		SET @i = @i + 1
	END
	SET @SQL = @SQL + 'FinishTime, Pen, [Time], [Result],' 
    SET @i = 1
	WHILE @i <= @GateCount
	BEGIN
		SET @GateOrder = CAST(@i AS NVARCHAR(2))
		SET @SQL = @SQL + '[' + @GateOrder + '],' 
		SET @i = @i + 1
	END
	SET @SQL = @SQL + 'F_MatchID,IRM,[Status],[Run1Result],[Run2Result],[Run1IRM],[Run2IRM]) 
	( 
	SELECT  
	MR.F_CompetitionPosition 
	, MR.F_CompetitionPositionDes1
	, (case when I.F_InscriptionNum is not null and I.F_InscriptionNum <> '''' then I.F_InscriptionNum else R.F_Bib end) 
	, D.F_DelegationCode
	, MR.F_StartTimeCharDes' 
	SET @i = 1
	WHILE @i <= @SplitCount
	BEGIN
		SET @SplitOrder = CAST(@i AS NVARCHAR(2))
		SET @SQL = @SQL + ', CAST(cast(CAST(MR.F_PointsNumDes'+ @SplitOrder + ' AS DECIMAL(20,2))/100 as DECIMAL(20,2)) AS NVARCHAR(100))' 
		SET @i = @i + 1 
	END
	SET @SQL = @SQL + ', MR.F_FinishTimeCharDes
	, MR.F_Points 
	, MR.F_PointsCharDes1 
	, MR.F_PointsCharDes2' 
	SET @i = 1
	WHILE @i <= @GateCount
	BEGIN
        SET @SQL = @SQL + ', case when MR.F_PointsCharDes3 is null 
				or Substring(MR.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ', 2) = '''' 
                or Substring(MR.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ', 2) = ''-1''
				then ''''
				else cast(cast(Substring(MR.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ',2) as int) as NVARCHAR(10)) end'
		SET @i = @i + 1
	END
	SET @SQL = @SQL + ', MR.F_MatchID  
	, ID.F_IRMLongName 
	, (case when MR.F_RealScore Is NULL then 0 else MR.F_RealScore end) 
	, MR1.F_PointsCharDes2 
	, MR2.F_PointsCharDes2
    , ID1.F_IRMLongName
    , ID2.F_IRMLongName
	FROM TS_Match_Result AS MR 
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RD ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = ''' + @LanguageCode + '''
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID  
	LEFT JOIN TC_IRM_Des AS ID ON MR.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = ''eng''
	LEFT JOIN TS_Match_Result AS MR1 ON MR.F_RegisterID = MR1.F_RegisterID AND MR1.F_MatchID = ''' + cast(@Run1MatchID as nvarchar(10)) +'''  
	LEFT JOIN TS_Match_Result AS MR2 ON MR.F_RegisterID = MR2.F_RegisterID AND MR2.F_MatchID = ''' + cast(@Run2MatchID as nvarchar(10)) +''' 
	LEFT JOIN TC_IRM_Des AS ID1 ON MR1.F_IRMID = ID1.F_IRMID AND ID1.F_LanguageCode = ''eng''
	LEFT JOIN TC_IRM_Des AS ID2 ON MR2.F_IRMID = ID2.F_IRMID AND ID2.F_LanguageCode = ''eng''
	WHERE MR.F_MatchID = ''' + cast(@MatchID as nvarchar(10)) +''' AND (MR.F_RealScore = 1 OR MR.F_RealScore = 2)
	)' 
	EXEC (@SQL)


	SET @SQL = '' 
	SET	@SQL = @SQL + 'ALTER TABLE #MatchResult  DROP COLUMN F_MatchID  '
	EXEC (@SQL)

	SELECT * FROM #MatchResult order by StartOrder

SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

-- Just for test
EXEC [Proc_SL_GetSelPlayerList] 2267,'eng'

*/







