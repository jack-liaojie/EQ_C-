IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_GetMatchCompetitionRuleDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_GetMatchCompetitionRuleDetail]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_GF_GetMatchCompetitionRuleDetail]
----功		  能：得到一竞赛规则的详细信息
----作		  者：张翠霞 
----日		  期: 2010-09-27

CREATE PROCEDURE [dbo].[Proc_GF_GetMatchCompetitionRuleDetail] (	
	@CompetitionRuleID					INT
)	
AS
BEGIN
	
SET NOCOUNT ON

    CREATE TABLE #table_CourseInfo(
                                    [Par/Distance]   NVARCHAR(100),
                                    Total            INT
                                   )
                                      
	DECLARE @HoleNum AS INT
	DECLARE @Par AS INT
	DECLARE @Distance AS INT
    
	DECLARE @XmlDoc AS XML
	SELECT @XmlDoc = F_CompetitionRuleInfo FROM TD_CompetitionRule WHERE F_CompetitionRuleID = @CompetitionRuleID

	IF @XmlDoc IS NOT NULL
	BEGIN
	DECLARE @iDoc AS INT
		EXEC sp_xml_preparedocument @iDoc OUTPUT, @XmlDoc
		
		SELECT TOP 1 * INTO #Temp_table
			FROM OPENXML (@iDoc, '/CourseInfo/HoleRule',1)
			WITH (
					HoleNum   INT '//CourseInfo/@NumHoles'
				)
				
	   SELECT TOP 1 @HoleNum = HoleNum FROM #Temp_table
				
		SELECT * INTO #Temp_Course
			FROM OPENXML (@iDoc, '/CourseInfo/HoleRule',1)
			WITH (
					Hole      INT '@HoleNum',
					Par       INT '@HolePar',
					Distance  INT '@HoleDistance'
				)
			
		EXEC sp_xml_removedocument @iDoc
		
	END
	ELSE
	BEGIN
	    RETURN
	END
	
	DECLARE @Num AS INT
	DECLARE @Order AS INT
	SET @Num = @HoleNum
	SET @Order = 1
	DECLARE @SQL AS NVARCHAR(MAX)

	WHILE @Num > 0
	BEGIN
	    SET @SQL = ' ALTER TABLE #table_CourseInfo ADD [' + CAST(@Order AS NVARCHAR(10)) + '] INT ' 
		EXEC (@SQL)
		SET @Order = @Order + 1
		SET @Num = @Num - 1
	END
	
	DECLARE @strCols AS NVARCHAR(MAX)
	SET @strCols = ''
	SELECT @strCols = @strCols + ', [' + CAST(Hole AS NVARCHAR(10)) + ']' FROM #Temp_Course

	SET @strCols = RIGHT(@strCols, LEN(@strCols) - 2)
	ALTER TABLE #table_CourseInfo DROP COLUMN [Par/Distance], Total
		
	SET @SQL = 'SELECT ' + @strCols + ' FROM (SELECT Hole, Par FROM #Temp_Course) AS A 
		PIVOT (MIN(Par) FOR Hole in ( ' + @strCols + ' ) ) AS B'

	INSERT INTO #table_CourseInfo
		EXEC (@SQL)
		
	SET @SQL = 'SELECT ' + @strCols + ' FROM (SELECT Hole, Distance FROM #Temp_Course) AS A 
		PIVOT (MIN(Distance) FOR Hole in ( ' + @strCols + ' ) ) AS B'
		
	INSERT INTO #table_CourseInfo
		EXEC (@SQL)
		
	SELECT * FROM #table_CourseInfo
	
SET NOCOUNT OFF
END


GO


