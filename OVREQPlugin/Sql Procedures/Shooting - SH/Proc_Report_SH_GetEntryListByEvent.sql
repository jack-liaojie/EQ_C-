IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetEntryListByEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetEntryListByEvent]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_Report_SH_GetEntryListByEvent]
--描    述：得到Event下得各个代表团运动员列表

-- NOC lomumn example: CHN - China

CREATE PROCEDURE [dbo].[Proc_Report_SH_GetEntryListByEvent](
												@DisciplineID		INT,
												@LanguageCode		CHAR(3),
												@Type			INT = 0
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
								F_RegisterID	INT,
								F_NocID			INT,
                                F_EventID       INT,
                                F_EventLongName	NVARCHAR(100),
                                F_NOC           NVARCHAR(10),
                                F_NOCDes        NVARCHAR(100),
                                F_Birth_Date    NVARCHAR(20),
                                F_PrintLN       NVARCHAR(100),
                                F_Bib			NVARCHAR(100),
                                F_G				NVARCHAR(100),--Gender
                                F_CoutByNOC		INT --每个NOC中运动员人数统计
							)
							
	INSERT INTO #Tmp_Table(F_RegisterID, F_NocID, F_EventID, F_NOC, F_NOCDes, F_Birth_Date, F_PrintLN, F_G, F_Bib)
	SELECT R.F_RegisterID, D.F_DelegationID, E.F_EventID, D.F_DelegationCode, DD.F_DelegationShortName, [dbo].[Func_SH_GetChineseDate](R.F_Birth_Date), 
	RD.F_PrintLongName, S.F_GenderCode, R.F_Bib
	FROM TR_Inscription AS I
	LEFT JOIN TS_Event AS E ON I.F_EventID = E.F_EventID
	LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
	LEFT JOIN TC_Sex AS S ON S.F_SexCode = R.F_SexCode
	LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON D.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	WHERE E.F_DisciplineID = @DisciplineID AND E.F_PlayerRegTypeID = 1 
	ORDER BY E.F_Order, D.F_DelegationCode, RD.F_LastName, RD.F_FirstName
	
	-- Take in Team match
	INSERT INTO #Tmp_Table(F_RegisterID, F_NocID, F_EventID, F_NOC, F_NOCDes, F_Birth_Date, F_PrintLN, F_G, F_Bib)
	SELECT R.F_RegisterID, D.F_DelegationID, E.F_EventID, D.F_DelegationCode, DD.F_DelegationShortName, [dbo].[Func_SH_GetChineseDate](R.F_Birth_Date), 
	RD.F_PrintLongName, S.F_GenderCode, R.F_Bib --I.F_InscriptionNum
	FROM TR_Register_Member AS RM
	LEFT JOIN TR_Inscription AS I ON RM.F_RegisterID = I.F_RegisterID
	LEFT JOIN TS_Event AS E ON I.F_EventID = E.F_EventID
	LEFT JOIN TR_Register AS R ON RM.F_MemberRegisterID = R.F_RegisterID
	LEFT JOIN TC_Sex AS S ON S.F_SexCode = R.F_SexCode
	LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON D.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	WHERE E.F_DisciplineID = @DisciplineID AND E.F_PlayerRegTypeID = 3 
	ORDER BY E.F_Order, D.F_DelegationCode, RD.F_LastName, RD.F_FirstName

	UPDATE #Tmp_Table SET F_EventLongName = B.F_EventLongName 
	FROM #Tmp_Table AS A 
	LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID
	WHERE B.F_LanguageCode = @LanguageCode

	IF @Type = 1
	BEGIN
		CREATE TABLE #Player(
									F_RegisterID	INT,
									F_NocID			INT,
									F_NOC           NVARCHAR(10),
									F_NOCDes        NVARCHAR(100),
									F_Birth_Date    NVARCHAR(20),
									F_PrintLN       NVARCHAR(100),
									F_Bib			NVARCHAR(100),
									F_G				NVARCHAR(100),--Gender
									F_CoutByNOC		INT --每个NOC中运动员人数统计
								)
								
		INSERT INTO #Player(F_RegisterID, F_NocID, F_NOC, F_NOCDes, F_Birth_Date, F_PrintLN, F_Bib, F_G)						
		SELECT F_RegisterID, F_NocID, F_NOC, F_NOCDes, F_Birth_Date, F_PrintLN, F_Bib, F_G 
		FROM #Tmp_Table 
		GROUP BY F_RegisterID, F_NocID, F_NOC, F_NOCDes, F_Birth_Date, F_PrintLN, F_Bib, F_G
		
		CREATE TABLE #TT(F_NocID INT, F_COUNT INT)
		INSERT INTO #TT(F_NocID, F_COUNT)
		SELECT F_NocID,COUNT(F_NocID) FROM #Player AS A GROUP BY A.F_NocID
		
		UPDATE #Player SET F_CoutByNOC =  B.F_COUNT 
		FROM #Player AS A 
		LEFT JOIN #TT AS B ON A.F_NocID = B.F_NocID
		
		SELECT * FROM #Player ORDER BY F_NOC
	END	
	ELSE
	BEGIN
		UPDATE #Tmp_Table SET F_CoutByNOC =  B.CC 
		FROM #Tmp_Table AS A 
		LEFT JOIN (SELECT F_EventID, COUNT(F_EventID) AS CC FROM #Tmp_Table GROUP BY F_EventID) AS B ON A.F_EventID = B.F_EventID
		
		SELECT * FROM #Tmp_Table 
	END


Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


-- Proc_Report_SH_GetEntryListByEvent 1,'ENG'
-- Proc_Report_SH_GetEntryListByEvent 1,'ENG',1