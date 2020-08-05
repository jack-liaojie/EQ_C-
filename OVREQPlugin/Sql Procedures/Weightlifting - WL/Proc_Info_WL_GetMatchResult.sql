IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_WL_GetMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_WL_GetMatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----名   称：[Proc_Info_WL_GetMatchResult]
----功   能：Info获取举重实时成绩
----作	 者：崔凯
----日   期：2012年09月18日

/*
	参数说明：
	序号	参数名称	参数说明
	1		@MatchID	对应比赛的ID  
	2		@LanguageCode
						展现内容的指定语言

*/

/*
	功能描述：Info系统获取排名赛实时成绩XML数据
*/

/*
	修改记录：
	序号	日期			修改者		修改内容
	1		2012-09-18		崔凯		修改内容描述。 
*/

CREATE PROCEDURE [dbo].[Proc_Info_WL_GetMatchResult]
		@MatchID            AS INT,
		@LanguageCode		AS CHAR(3)='CHN'
AS
BEGIN
	
SET NOCOUNT ON
 
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)	
		 	 
	DECLARE @EventID	    INT

		SELECT @EventID = E.F_EventID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		WHERE F_MatchID = @MatchID


	CREATE TABLE #Temp_RegTable
	(
		F_RegisterID            INT,
    )
    
	INSERT #Temp_RegTable(F_RegisterID)
		(SELECT  DISTINCT MR.F_RegisterID
		FROM TS_Match_Result AS MR  
		WHERE MR.F_MatchID IN (
		SELECT F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		WHERE E.F_EventID = @EventID)
		AND MR.F_RegisterID IS NOT NULL
		)
	
	CREATE TABLE #Result(   
							[Rank]			   NVARCHAR(10),
							[LotNo]			   NVARCHAR(10),
							[DelegationName]   NVARCHAR(100), 
                            [AthleteName]	   NVARCHAR(100),
                            [Birthday]		   NVARCHAR(30),
							[Group]			   NVARCHAR(10),
                            [Weight]	       NVARCHAR(10),
                            [Weight_S1]	       NVARCHAR(10),
                            [Result_S1]	       NVARCHAR(10),
                            [Weight_S2]	       NVARCHAR(10),
                            [Result_S2]	       NVARCHAR(10),
                            [Weight_S3]	       NVARCHAR(10),
                            [Result_S3]	       NVARCHAR(10), 
                            [Result_S]	       NVARCHAR(10),
                            
                            [Weight_J1]	       NVARCHAR(10),
                            [Result_J1]	       NVARCHAR(10),
                            [Weight_J2]	       NVARCHAR(10),
                            [Result_J2]	       NVARCHAR(10),
                            [Weight_J3]	       NVARCHAR(10),
                            [Result_J3]	       NVARCHAR(10), 
                            [Result_J]	       NVARCHAR(10),
                            
                            [Total]		       NVARCHAR(10),
							) 

	-- 在临时表中插入基本信息
	
		INSERT INTO #Result
			( [Rank],[LotNo],[DelegationName],[AthleteName],[Birthday],[Group],[Weight]
			 ,[Weight_S1],[Result_S1],[Weight_S2],[Result_S2],[Weight_S3],[Result_S3],[Result_S]
			 ,[Weight_J1],[Result_J1],[Weight_J2],[Result_J2],[Weight_J3],[Result_J3],[Result_J],[Total])
		
		SELECT ISNULL(CAST(ER.F_EventRank AS NVARCHAR(10)),''),I.F_Seed,DD.F_DelegationLongName,RD.F_LongName
			  ,dbo.fun_WL_GetDateTime(R.F_Birth_Date,1,@LanguageCode),P.F_PhaseCode
			  ,ISNULL(PR.F_PhasePointsCharDes1,R.F_Weight)
			  ,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
				    WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND SNMR.F_PointsNumDes1 IS NULL THEN '---'
					WHEN SNMR.F_PointsNumDes1 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes1)='_' THEN '---'
					WHEN ER.F_IRMID IS NULL AND SNMR.F_PointsNumDes1 IS NULL THEN ''
					ELSE SNMR.F_PointsCharDes1 END
			  ,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN N'' 
					ELSE dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes1) END
					
			  ,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
				    WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND SNMR.F_PointsNumDes2 IS NULL THEN '---'
					WHEN SNMR.F_PointsNumDes2 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes2)='_' THEN '---'
					WHEN ER.F_IRMID IS NULL AND SNMR.F_PointsNumDes2 IS NULL THEN ''
					ELSE SNMR.F_PointsCharDes2 END
			  ,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN N'' 
					ELSE dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes2) END
					
			  ,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
				    WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND SNMR.F_PointsNumDes3 IS NULL THEN '---'
					WHEN SNMR.F_PointsNumDes3 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes3)='_' THEN '---'
					WHEN ER.F_IRMID IS NULL AND SNMR.F_PointsNumDes3 IS NULL THEN ''
					ELSE SNMR.F_PointsCharDes3 END
			  ,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN N'' 
					ELSE dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes3) END
			  ,PR.F_PhasePointsCharDes2
			  
			  ,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
				    WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND CJMR.F_PointsNumDes1 IS NULL THEN '---'
					WHEN CJMR.F_PointsNumDes1 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes1)='_' THEN '---'
					WHEN ER.F_IRMID IS NULL AND CJMR.F_PointsNumDes1 IS NULL THEN ''
					ELSE CJMR.F_PointsCharDes1 END
			  ,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN N'' 
					ELSE dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes1) END
					
			  ,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
				    WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND CJMR.F_PointsNumDes2 IS NULL THEN '---'
					WHEN CJMR.F_PointsNumDes2 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes2)='_' THEN '---'
					WHEN ER.F_IRMID IS NULL AND CJMR.F_PointsNumDes2 IS NULL THEN ''
					ELSE CJMR.F_PointsCharDes2 END
			  ,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN N'' 
					ELSE dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes2) END
					
			  ,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
				    WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND CJMR.F_PointsNumDes3 IS NULL THEN '---'
					WHEN CJMR.F_PointsNumDes3 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes3)='_' THEN '---'
					WHEN ER.F_IRMID IS NULL AND SNMR.F_PointsNumDes3 IS NULL THEN ''
					ELSE CJMR.F_PointsCharDes3 END
			  ,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN N'' 
					ELSE dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes3) END
			  ,PR.F_PhasePointsCharDes3	
			  ,PR.F_PhasePointsCharDes4		  
		FROM #Temp_RegTable AS TR
		LEFT JOIN TR_Register AS R ON TR.F_RegisterID = R.F_RegisterID 
		LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID  
		LEFT JOIN TC_Delegation_DES AS DD ON R.F_DelegationID = DD.F_DelegationID  AND DD.F_LanguageCode = @LanguageCode 
		LEFT JOIN TR_Inscription AS I ON TR.F_RegisterID = I.F_RegisterID 
		LEFT JOIN TS_Event_Result AS ER ON ER.F_RegisterID=TR.F_RegisterID AND ER.F_EventID=@EventID
		LEFT JOIN TC_IRM AS IRM ON ER.F_IRMID = IRM.F_IRMID  
		LEFT JOIN (SELECT F_RegisterID,MR.F_MatchID,F_PointsCharDes1,F_PointsNumDes1,F_PointsCharDes2,F_PointsNumDes2,F_PointsCharDes3,F_PointsNumDes3  FROM TS_Match_Result AS MR 
						LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
							WHERE M.F_MatchCode='01') AS SNMR ON SNMR.F_RegisterID = R.F_RegisterID
		LEFT JOIN TS_Match AS SM ON SM.F_MatchID=SNMR.F_MatchID 
		LEFT JOIN (SELECT F_RegisterID,MR.F_MatchID,F_PointsCharDes1,F_PointsNumDes1,F_PointsCharDes2,F_PointsNumDes2,F_PointsCharDes3,F_PointsNumDes3  FROM TS_Match_Result AS MR 
						LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
							WHERE M.F_MatchCode='02') AS CJMR ON CJMR.F_RegisterID = R.F_RegisterID
		LEFT JOIN TS_Match AS CM ON CM.F_MatchID=CJMR.F_MatchID 
		LEFT JOIN TS_Phase_Result AS PR ON PR.F_RegisterID = ER.F_RegisterID
		LEFT JOIN TS_Phase AS P ON SM.F_PhaseID = P.F_PhaseID AND P.F_EventID = ER.F_EventID  
		ORDER BY ISNULL(ER.F_EventRank,999)
	
	DECLARE @Result AS NVARCHAR(MAX)
	SET @Result = ( SELECT *  FROM #Result AS Row  
			FOR XML AUTO)

	IF @Result IS NULL
	BEGIN
		SET @Result = N''
	END

	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty =   N' Language = "' + CASE WHEN @LanguageCode =N'CHN' THEN N'CHI' ELSE @LanguageCode END + '"' 
							+N' Date ="'+ REPLACE(dbo.Fun_WL_GetDateTime(GETDATE(),1,@LanguageCode), '-', '') + '"'
							+N' Time= "'+ REPLACE(dbo.Fun_WL_GetDateTime(GETDATE(),4,@LanguageCode), ':', '') + '"'

	IF(@Result = N'')
		BEGIN
		SET @OutputXML = N''
		END
	ELSE
		BEGIN
		SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
						   <Message ' + @MessageProperty +'>'
						+ @Result
						+ N'
							</Message>'
		END

	IF (@Result IS NOT NULL AND @Result !='')
	BEGIN
	SELECT @OutputXML AS OutputXML
	RETURN
	END
 
SET NOCOUNT OFF
END


/*
exec Proc_Info_WL_GetMatchResult 1,'CHN' 
*/



GO


