IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_Interface_GetScheduleInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_Interface_GetScheduleInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_AR_Interface_GetScheduleInfo]
----功		  能：接口发送射箭项目全部竞赛日程
----作		  者：崔凯
----日		  期: 2012-7-19
----修 改 记  录：
/*

*/


CREATE PROCEDURE [dbo].[Proc_AR_Interface_GetScheduleInfo] 
                   (	
					@DisciplineCode			NVARCHAR(10),
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON
		
		
			CREATE TABLE #Temp_V
			(
								RuleID			INT, 
								EndCount		INT,
								ArrowCount		INT ,
								IsSetPoints		INT ,
								WinPoints		INT,
								MatchType		INT,
								DistinceNum		INT
			)
			
			DECLARE MyCursor CURSOR FOR 
			SELECT F_CompetitionRuleID FROM TD_CompetitionRule
			
			OPEN MyCursor
			DECLARE @RuleID INT			
			FETCH NEXT FROM MyCursor INTO @RuleID
				WHILE @@FETCH_STATUS=0
				BEGIN
					DECLARE @XmlDoc AS XML
					SELECT @XmlDoc = F_CompetitionRuleInfo FROM TD_CompetitionRule 
							WHERE F_CompetitionRuleID = @RuleID

					IF @XmlDoc IS NOT NULL
					BEGIN
					DECLARE @XMLHandler AS INT
						EXEC sp_xml_preparedocument @XMLHandler OUTPUT, @XmlDoc
								
							INSERT #Temp_V (RuleID,EndCount , ArrowCount,IsSetPoints, WinPoints,MatchType,DistinceNum)
							  SELECT  @RuleID , EndCount , ArrowCount, IsSetPoints , 
									  WinPoints , MatchType, DistinceNum
								 FROM OPENXML(@XMLHandler, '/MatchRule/SetRule', 1)
								 WITH(
									RuleName NVARCHAR(50) '//MatchRule/@RuleName',
									MatchType INT '//MatchRule/@MatchType',						
									EndCount INT '@EndCount',
									ArrowCount	 INT '@ArrowCount',
									IsSetPoints INT '@IsSetPoints',
									WinPoints INT '@WinPoints',
									DistinceNum INT '@DistinceNum'
								)
												
						EXEC sp_xml_removedocument @XMLHandler	
						
					END
					
					FETCH NEXT FROM MyCursor INTO @RuleID
				END 
			CLOSE MyCursor
			DEALLOCATE MyCursor
			
		SELECT P.F_PhaseID
		,ED.F_EventLongName+PD.F_PhaseLongName  
		,ED.F_EventLongName
		,T.EndCount*T.DistinceNum AS EndCount
		,T.ArrowCount
		,E.F_PlayerRegTypeID AS Shottoff
		,T.IsSetPoints
		,T.WinPoints
		,T.MatchType 
		FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID
		LEFT JOIN TS_Phase_Des AS PD ON PD.F_PhaseID = P.F_PhaseID AND PD.F_LanguageCode=@LanguageCode
		LEFT JOIN TS_Event AS E ON E.F_EventID	= P.F_EventID
		LEFT JOIN TS_Event_Des AS ED ON ED.F_EventID = E.F_EventID AND ED.F_LanguageCode=@LanguageCode
		LEFT JOIN TD_CompetitionRule AS C ON M.F_CompetitionRuleID=C.F_CompetitionRuleID 
		LEFT JOIN TS_Discipline AS DIS ON E.F_DisciplineID = DIS.F_DisciplineID 
		LEFT JOIN #Temp_V AS T ON T.RuleID = M.F_CompetitionRuleID
		WHERE DIS.F_DisciplineCode = @DisciplineCode
		
        
SET NOCOUNT OFF
END


GO

/*
exec Proc_AR_Interface_GetScheduleInfo 'ar', 'CHN'
*/