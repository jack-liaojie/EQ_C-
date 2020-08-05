IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_AddCompetitionRule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_AddCompetitionRule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_GF_AddCompetitionRule]
----功		  能：添加高尔夫的一个竞赛规则
----作		  者：张翠霞
----日		  期: 2010-09-28

CREATE PROCEDURE [dbo].[Proc_GF_AddCompetitionRule] (	
	@DisciplineID					INT,
	@Hole                           INT,
	@Result							INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON
	SET @Result = 0
	
	IF @Hole < 1
	BEGIN
	    SET @Result = 0
	    RETURN
	END
	
	CREATE TABLE #TABLE(
	                     HoleNum      INT,
	                     HolePar      INT,
	                     HoleDistance INT
	                     )
	DECLARE @NumberHole AS INT                 
	DECLARE @Index AS INT
	SET @Index = 0
	SET @NumberHole = @Hole
	
	WHILE @Hole > 0
	BEGIN
	    SET @Index = @Index + 1
	    SET @Hole = @Hole - 1
	    
	    INSERT INTO #TABLE(HoleNum, HolePar, HoleDistance)
	    VALUES(@Index, 0, 0)
	END
	
	DECLARE @NewCompetitionRuleID AS INT
	SELECT  @NewCompetitionRuleID = (ISNULL(MAX(F_CompetitionRuleID), 0) + 1) FROM TD_CompetitionRule
	
	DECLARE @RuleInfo AS NVARCHAR(MAX)

	SET @RuleInfo = (SELECT HoleNum
							, HolePar
							, HoleDistance
							FROM #TABLE AS HoleRule
							FOR XML AUTO)

	IF @RuleInfo IS NULL
	BEGIN
		SET @RuleInfo = N''
	END

	SET @RuleInfo = N'<CourseInfo NumHoles=' + '"'+ CAST(@NumberHole AS NVARCHAR(10)) + '"' + '>'
					+ @RuleInfo
					+ N'</CourseInfo>'
                        
	INSERT INTO TD_CompetitionRule (F_CompetitionRuleID, F_DisciplineID, F_CompetitionRuleInfo)
	VALUES (@NewCompetitionRuleID, @DisciplineID, @RuleInfo)

	SET @Result = @NewCompetitionRuleID
	RETURN
	
SET NOCOUNT OFF
END


GO


