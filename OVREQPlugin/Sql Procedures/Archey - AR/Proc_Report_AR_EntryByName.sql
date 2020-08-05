IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_EntryByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_EntryByName]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--名    称: [Proc_Report_AR_EntryByName]
--描    述: 
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2011年10月18日
--修改记录：
/*	
                    2011-2-17              增加Mixed Double Event	
                    2011-10-22    李燕     增加FIFA WorldRanking		


*/



CREATE PROCEDURE [dbo].[Proc_Report_AR_EntryByName]
	@DisciplineID				INT,
	@DelegationID				INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT A.F_RegisterID, A.F_SexCode, D.F_SexLongName 
	, dbo.Fun_AR_GetDateTime(A.F_Birth_Date, 1, @LanguageCode) AS [BirthDate]
	, B.F_PrintLongName, B.F_PrintShortName, C.F_DelegationCode, CD.F_DelegationLongName
	, B.F_LastName, B.F_FirstName 
	INTO #Temp_Entry 
	   FROM TR_Register AS A 
	    LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Delegation AS C ON A.F_DelegationID = C.F_DelegationID 
		LEFT JOIN TC_Delegation_Des AS CD ON C.F_DelegationID = CD.F_DelegationID AND CD.F_LanguageCode=@LanguageCode
		LEFT JOIN TC_Sex_Des AS D ON A.F_SexCode = D.F_SexCode AND D.F_LanguageCode = @LanguageCode
			WHERE A.F_RegTypeID = 1 AND ((C.F_DelegationID = @DelegationID AND @DelegationID !=-1) OR (C.F_DelegationID != @DelegationID AND @DelegationID =-1))
	
	ALTER TABLE #Temp_Entry ADD DoubleRegisterID		INT NULL
	ALTER TABLE #Temp_Entry ADD PartnerRegisterID		INT NULL
	ALTER TABLE #Temp_Entry ADD SexLongName_CHN         NVARCHAR(50)  NULL
	ALTER TABLE #Temp_Entry ADD SexLongName_ENG         NVARCHAR(50)  NULL
	ALTER TABLE #Temp_Entry ADD DoublePartner			NVARCHAR(100) NULL
	ALTER TABLE #Temp_Entry ADD Handedness				NVARCHAR(100) NULL
	ALTER TABLE #Temp_Entry ADD SingleRank				NVARCHAR(100) NULL
	ALTER TABLE #Temp_Entry ADD DoubleRank				NVARCHAR(100) NULL
	ALTER TABLE #Temp_Entry ADD Residence				NVARCHAR(100) NULL
	ALTER TABLE #Temp_Entry ADD Event_Single			NVARCHAR(100) NULL
	ALTER TABLE #Temp_Entry ADD Event_Double			NVARCHAR(100) NULL
	ALTER TABLE #Temp_Entry ADD Event_MixedDouble       NVARCHAR(100) NULL
	ALTER TABLE #Temp_Entry ADD FITA_Ranking            NVARCHAR(100) NULL
	ALTER TABLE #Temp_Entry ADD HightDes                NVARCHAR(100) NULL
	ALTER TABLE #Temp_Entry ADD WeightDes               NVARCHAR(100) NULL
	ALTER TABLE #Temp_Entry ADD EventID					INT NULL
	ALTER TABLE #Temp_Entry ADD EventName				 NVARCHAR(100) NULL
	
	
	UPDATE A SET A.SexLongName_ENG = C.F_SexLongName  FROM #Temp_Entry AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TC_Sex_Des AS C ON B.F_SexCode = C.F_SexCode AND C.F_LanguageCode = 'ENG' 
	UPDATE A SET A.SexLongName_CHN = C.F_SexLongName  FROM #Temp_Entry AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TC_Sex_Des AS C ON B.F_SexCode = C.F_SexCode AND C.F_LanguageCode = 'CHN' 
	
	UPDATE A SET A.DoubleRegisterID = B.F_RegisterID FROM #Temp_Entry AS A LEFT JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_MemberRegisterID 
			LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID LEFT JOIN TR_Register AS D ON B.F_RegisterID = D.F_RegisterID WHERE  D.F_RegTypeID = 2
	
	--UPDATE A SET A.PartnerRegisterID = B.F_MemberRegisterID FROM #Temp_Entry AS A LEFT JOIN TR_Register_Member AS B ON A.DoubleRegisterID = B.F_RegisterID AND A.F_RegisterID != B.F_MemberRegisterID 
	
	--UPDATE A SET A.DoublePartner = B.F_PrintLongName FROM #Temp_Entry AS A LEFT JOIN TR_Register_Des AS B ON A.PartnerRegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	
	--UPDATE A SET A.Event_Single = (CASE C.F_EventCode WHEN '001' THEN 'S' WHEN '101' THEN 'S' ELSE '' END ) FROM #Temp_Entry AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
	
	--UPDATE A SET A.Event_Double = (CASE C.F_EventCode WHEN '002' THEN 'D' WHEN '102' THEN 'D' ELSE '' END ) FROM #Temp_Entry AS A LEFT JOIN TR_Inscription AS B ON A.DoubleRegisterID = B.F_RegisterID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
		
	--UPDATE A SET A.Event_MixedDouble = (CASE C.F_EventCode WHEN '201' THEN 'XD' ELSE '' END ) FROM #Temp_Entry AS A LEFT JOIN TR_Inscription AS B ON A.DoubleRegisterID = B.F_RegisterID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID

	UPDATE A SET A.Handedness = B.F_Comment FROM #Temp_Entry AS A LEFT JOIN TR_Register_Comment AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_Title = 'Handedness'
	UPDATE A SET A.SingleRank = B.F_Comment FROM #Temp_Entry AS A LEFT JOIN TR_Register_Comment AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_Title = 'single rank'
	UPDATE A SET A.DoubleRank = B.F_Comment FROM #Temp_Entry AS A LEFT JOIN TR_Register_Comment AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_Title = 'double rank'
	UPDATE A SET A.Residence = ISNULL(B.F_Residence_City, '') + ', '+ISNULL(B.F_Residence_Country, '') FROM #Temp_Entry AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
	
	UPDATE A SET A.Residence = '' FROM #Temp_Entry AS A WHERE RTRIM(LTRIM(A.Residence)) = ','
	UPDATE A SET A.Residence = RIGHT(Residence, LEN(Residence) - 1) FROM #Temp_Entry AS A  WHERE LEFT(A.Residence, 1) = ','
	UPDATE A SET A.Residence = LTRIM(Residence) FROM #Temp_Entry AS A 
	
	--UPDATE A SET FITA_Ranking = RCM.F_Comment FROM #Temp_Entry AS A LEFT JOIN  TR_Register_Comment AS RCM ON A.F_RegisterID = RCM.F_RegisterID 
	--         WHERE F_Title= 'FITA Ranking'
	UPDATE A SET FITA_Ranking = RCM.F_Seed FROM #Temp_Entry AS A 
		LEFT JOIN  TR_Inscription AS RCM ON A.F_RegisterID = RCM.F_RegisterID 
	
	UPDATE A SET HightDes = LEFT(CONVERT(INT, ROUND(R.F_Height, 0)) / 100.0, 4) + ' / ' 
			+ CONVERT(NVARCHAR(2), CONVERT(INT, ROUND(R.F_Height, 0)) * 100 / 3048) + ''''
			+ CONVERT(NVARCHAR(2), (CONVERT(INT, ROUND(R.F_Height, 0)) * 100 / 254) % 12) + '"'   FROM #Temp_Entry  AS A LEFT JOIN TR_Register AS R ON a.F_RegisterID = R.F_RegisterID
			
   
    UPDATE A SET  WeightDes = CONVERT(NVARCHAR(3), CONVERT(INT, ROUND(R.F_Weight, 0))) + ' / ' 
			+ CONVERT(NVARCHAR(5), CONVERT(INT, ROUND(R.F_Weight, 0)) * 22 / 10) FROM #Temp_Entry AS A LEFT JOIN TR_Register AS R ON A.F_RegisterID = R.F_RegisterID
	
	
	UPDATE #Temp_Entry SET EventID= RCM.F_EventID FROM #Temp_Entry AS A 
		LEFT JOIN  TR_Inscription AS RCM ON A.F_RegisterID = RCM.F_RegisterID 
	
	UPDATE #Temp_Entry SET EventName= CASE WHEN A.EventID IN (1,2,3,4,5) THEN '反曲弓'  
										   WHEN A.EventID IN (6,7) THEN '复合弓' end FROM #Temp_Entry AS A
	
	UPDATE #Temp_Entry SET F_SexLongName = SexLongName_ENG + ' ' + EventName FROM #Temp_Entry AS A
	
	SELECT * FROM #Temp_Entry WHERE F_PrintLongName IS NOT NULL AND F_DelegationCode IS NOT NULL
		 ORDER BY F_SexCode, F_SexLongName, F_LastName, F_FirstName,F_PrintLongName
   
	
SET NOCOUNT OFF
END



GO

/*
exec Proc_Report_AR_EntryByName 1,-1,'CHN'
*/
