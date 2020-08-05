IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_AR_GetQualificationResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_AR_GetQualificationResults]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----名   称：[Proc_Info_AR_GetQualificationResults]
----功   能：Info获取实时成绩(排名赛)
----作	 者：崔凯
----日   期：2012年09月11日

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
	1		2012-09-11		崔凯		修改内容描述。 
*/

CREATE PROCEDURE [dbo].[Proc_Info_AR_GetQualificationResults]
		@MatchID            AS INT,
		@LanguageCode		AS CHAR(3)='CHN'
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineID	AS NVARCHAR(50)
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)
	
	DECLARE @SQL		    NVARCHAR(max)
    DECLARE @DisciplineCode NVARCHAR(10)	
	DECLARE @EventCode		NVARCHAR(10)
	DECLARE @PhaseCode		NVARCHAR(10)
    DECLARE @SexCode        INT
    DECLARE @EventID        INT

	SELECT @DisciplineCode = D.F_DisciplineCode,
	@EventCode = E.F_EventCode,
	@PhaseCode = P.F_PhaseCode,
    @SexCode = E.F_SexCode,
    @EventID = E.F_EventID
    FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    WHERE M.F_MatchID = @MatchID
    
	CREATE TABLE #ResultList
	(
		[Rank]				    NVARCHAR(10),	
		[Target]		        NVARCHAR(10),		
		[AthleteName]			NVARCHAR(100), 
		DelegationName          NVARCHAR(100), 	
		Result1					NVARCHAR(10), 
		Result2					NVARCHAR(10), 		
		Result			        NVARCHAR(10), 
		[Number_10s]			NVARCHAR(10),
		[Number_10x]			NVARCHAR(10), 
	)

	-- 在临时表中插入基本信息
	INSERT #ResultList 
	([Rank], [Target], [AthleteName],DelegationName,
	Result1,Result2,Result,[Number_10s],[Number_10x])
	(
	SELECT  
	  MR.F_Rank
	, MR.F_Comment 
	, RD.F_PrintLongName AS [AthleteName]  
	, DD.F_DelegationLongName 
	, MR.F_PointsNumDes1
	, MR.F_PointsNumDes2
	, CASE WHEN MR.F_IRMID IS NOT NULL THEN IRMD.F_IRMLongName ELSE CAST(MR.F_Points AS NVARCHAR) END
	, MR.F_WinPoints
	, MR.F_LosePoints 
	FROM TS_Match_Result AS MR 
	LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID AND M.F_MatchCode = 'QR' 
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode 
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode			
	LEFT JOIN TC_Federation_Des AS FD ON R.F_FederationID = FD.F_FederationID AND FD.F_LanguageCode = @LanguageCode			
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID AND P.F_PhaseCode IN ('A','B','C','D')
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID  
	LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND I.F_EventID = @EventID  
	LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = MR.F_IRMID	
	LEFT JOIN TC_IRM_DES AS IRMD ON IRMD.F_IRMID = MR.F_IRMID AND IRMD.F_LanguageCode = @LanguageCode	
	WHERE E.F_EventID = @EventID AND M.F_MatchCode = 'QR'
	)

	DECLARE @Result AS NVARCHAR(MAX)
	SET @Result = ( SELECT * FROM #ResultList AS Row 
						ORDER BY  ISNULL(RIGHT('00000'+CONVERT(VARCHAR(10),[RANK]),5),999)
			FOR XML AUTO)

	IF @Result IS NULL
	BEGIN
		SET @Result = N''
	END

	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty =   N' Language = "' + CASE WHEN @LanguageCode =N'CHN' THEN N'CHI' ELSE @LanguageCode END + '"' 
							+N' Date ="'+ REPLACE(dbo.Fun_AR_GetDateTime(GETDATE(),1,@LanguageCode), '-', '') + '"'
							+N' Time= "'+ REPLACE(dbo.Fun_AR_GetDateTime(GETDATE(),4,@LanguageCode), ':', '') + '"'

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
exec Proc_Info_AR_GetQualificationResults 1,'CHN' 
*/



GO


