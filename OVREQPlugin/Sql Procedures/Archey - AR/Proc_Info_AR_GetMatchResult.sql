IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_AR_GetMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_AR_GetMatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----名   称：[Proc_Info_AR_GetMatchResult]
----功   能：Info获取实时成绩(淘汰赛)
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

CREATE PROCEDURE [dbo].[Proc_Info_AR_GetMatchResult]
		@MatchID            AS INT,
		@LanguageCode		AS CHAR(3)='CHN'
AS
BEGIN
	
SET NOCOUNT ON
 
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)	
	
	CREATE TABLE #Result( 
							F_MatchID          INT,
                            F_PhaseID          INT,
                            F_EventID          INT,
							F_APlayerID		   INT,
							Group_A			   NVARCHAR(100),
                            DelegationName_A   NVARCHAR(100),
                            AthleteName_A      NVARCHAR(100),
                            Result_A		   NVARCHAR(100),
                            
							F_BPlayerID		   INT,
							Group_B			   NVARCHAR(100),
                            DelegationName_B   NVARCHAR(100),
                            AthleteName_B      NVARCHAR(100),
                            Result_B		   NVARCHAR(100), 
                            Winner             NVARCHAR(100),
                            [Status]		   NVARCHAR(30),
							) 

	-- 在临时表中插入基本信息
	
		INSERT INTO #Result
			(F_MatchID,F_PhaseID,F_EventID,[Status])
		SELECT A.F_MatchID,B.F_PhaseID,c.F_EventID,S.F_StatusCode
		FROM TS_Match AS A
		LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
		LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID 
		LEFT JOIN TC_Status AS S ON S.F_StatusID = A.F_MatchStatusID
		WHERE A.F_MatchID = @MatchID 

		----Player A
		UPDATE #Result 
		SET F_APlayerID= X.F_RegisterID
		   ,AthleteName_A = W.F_PrintLongName
		   ,DelegationName_A = Z.F_DelegationLongName
		   ,Result_A = CASE WHEN X.F_IRMID IS NOT NULL THEN IRM.F_IRMLongName 
							WHEN M.F_MatchComment3 ='0' THEN CAST(X.F_Points AS VARCHAR) ELSE CAST(X.F_RealScore AS VARCHAR) END
		   ,Group_A = N''
		FROM #Result AS A 
		LEFT JOIN TS_Match AS M ON A.F_MatchID = M.F_MatchID
		LEFT JOIN TS_Match_Result AS X ON A.F_MatchID = X.F_MatchID
		LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID
		LEFT JOIN TC_Delegation_DES AS Z ON Y.F_DelegationID = Z.F_DelegationID AND Z.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register_Des AS W ON X.F_RegisterID = W.F_RegisterID AND W.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Inscription AS TRI ON Y.F_RegisterID = TRI.F_RegisterID AND TRI.F_EventID = A.F_EventID   
		LEFT JOIN TC_IRM_DES AS IRM ON IRM.F_IRMID = X.F_IRMID 
		WHERE X.F_CompetitionPositionDes1 = 1  

		----Player B 
		UPDATE #Result 
		SET F_BPlayerID= X.F_RegisterID
		   ,AthleteName_B = W.F_PrintLongName
		   ,DelegationName_B = Z.F_DelegationLongName
		   ,Result_B = CASE WHEN X.F_IRMID IS NOT NULL THEN IRM.F_IRMLongName 
							WHEN M.F_MatchComment3 ='0' THEN CAST(X.F_Points AS VARCHAR) ELSE CAST(X.F_RealScore AS VARCHAR) END
		   ,Group_B = N''
		FROM #Result AS A 
		LEFT JOIN TS_Match AS M ON A.F_MatchID = M.F_MatchID
		LEFT JOIN TS_Match_Result AS X ON A.F_MatchID = X.F_MatchID
		LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID
		LEFT JOIN TC_Delegation_DES AS Z ON Y.F_DelegationID = Z.F_DelegationID AND Z.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register_Des AS W ON X.F_RegisterID = W.F_RegisterID AND W.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Inscription AS TRI ON Y.F_RegisterID = TRI.F_RegisterID AND TRI.F_EventID = A.F_EventID   
		LEFT JOIN TC_IRM_DES AS IRM ON IRM.F_IRMID = X.F_IRMID 
		WHERE X.F_CompetitionPositionDes1 = 2  

		UPDATE #Result SET AthleteName_A = N'-BYE-'  WHERE F_APlayerID = -1
		UPDATE #Result SET AthleteName_B = N'-BYE-'  WHERE F_BPlayerID = -1 
		 
		UPDATE #Result SET Winner = W.F_PrintLongName
		FROM #Result AS A 
		LEFT JOIN TS_Match_Result AS X ON A.F_MatchID = X.F_MatchID AND X.F_Rank = 1 
		LEFT JOIN TR_Register_Des AS W ON X.F_RegisterID = W.F_RegisterID AND W.F_LanguageCode = @LanguageCode 

	DECLARE @Result AS NVARCHAR(MAX)
	SET @Result = ( SELECT Group_A,DelegationName_A,AthleteName_A,Result_A
						  ,Group_B,DelegationName_B,AthleteName_B,Result_B,Winner,[Status]
						 FROM #Result AS Row  
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
exec Proc_Info_AR_GetMatchResult 1,'CHN' 
*/



GO


