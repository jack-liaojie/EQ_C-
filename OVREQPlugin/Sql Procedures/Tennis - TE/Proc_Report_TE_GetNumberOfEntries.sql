IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetNumberOfEntries]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetNumberOfEntries]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_Report_TE_GetNumberOfEntries]
--描    述: 网球项目报表 C30 (Number of Entries by NOC) 获取详细信息
--参数说明: 
--说    明: 
--创 建 人: 郑金勇
--日    期: 2010年10月09日




CREATE PROCEDURE [dbo].[Proc_Report_TE_GetNumberOfEntries]
	@DisciplineID					INT,
	@LanguageCode					CHAR(3) = 'ENG'
AS
BEGIN
SET NOCOUNT ON
	

	-- 临时表: 存储 NOC 报名人数
	CREATE TABLE #Temp_NumberOfEntries
	(
		F_DelegationID				INT,
		F_DelegationCode			NVARCHAR(20),
		F_DelegationLongName		NVARCHAR(200),
		MS							INT,
		WS							INT,
		MD							INT,
		WD							INT,
		MIX                         INT,
		Men							INT,
		Women						INT,
		Total						INT
	)
	
	INSERT INTO #Temp_NumberOfEntries(F_DelegationID, F_DelegationCode)
		SELECT DISTINCT B.F_DelegationID, D.F_DelegationCode FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
			LEFT JOIN TS_Event AS C ON A.F_EventID = C.F_EventID LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
				WHERE C.F_DisciplineID = @DisciplineID AND B.F_RegTypeID IN (1,2,3) ORDER BY D.F_DelegationCode
				
	UPDATE A SET A.F_DelegationLongName = B.F_DelegationLongName FROM #Temp_NumberOfEntries AS A LEFT JOIN TC_Delegation_Des AS B ON A.F_DelegationID = B.F_DelegationID WHERE B.F_LanguageCode = @LanguageCode
	
	DECLARE @MSEventID AS INT
	DECLARE @WSEventID AS INT
	DECLARE @MDEventID AS INT
	DECLARE @WDEventID AS INT
	DECLARE @MIXEventID AS INT
	
	SELECT @MSEventID = F_EventID FROM TS_Event WHERE F_DisciplineID = @DisciplineID AND F_SexCode = 1 AND F_PlayerRegTypeID = 1
	SELECT @WSEventID = F_EventID FROM TS_Event WHERE F_DisciplineID = @DisciplineID AND F_SexCode = 2 AND F_PlayerRegTypeID = 1
	SELECT @MDEventID = F_EventID FROM TS_Event WHERE F_DisciplineID = @DisciplineID AND F_SexCode = 1 AND F_PlayerRegTypeID = 2
	SELECT @WDEventID = F_EventID FROM TS_Event WHERE F_DisciplineID = @DisciplineID AND F_SexCode = 2 AND F_PlayerRegTypeID = 2
    SELECT @MIXEventID = F_EventID FROM TS_Event WHERE F_DisciplineID = @DisciplineID AND F_SexCode = 3 AND F_PlayerRegTypeID = 2

	UPDATE A SET A.MS = B.Numbers FROM #Temp_NumberOfEntries AS A LEFT JOIN
		(
			SELECT B.F_DelegationID, COUNT(A.F_RegisterID) AS Numbers FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
				WHERE A.F_EventID = @MSEventID AND B.F_RegTypeID IN (1, 2, 3)
					GROUP BY B.F_DelegationID
		) AS B 
		ON A.F_DelegationID = B.F_DelegationID

	UPDATE A SET A.WS = B.Numbers FROM #Temp_NumberOfEntries AS A LEFT JOIN
		(
			SELECT B.F_DelegationID, COUNT(A.F_RegisterID) AS Numbers FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
				WHERE A.F_EventID = @WSEventID AND B.F_RegTypeID IN (1, 2, 3)
					GROUP BY B.F_DelegationID
		) AS B 
		ON A.F_DelegationID = B.F_DelegationID
		
	UPDATE A SET A.MD = B.Numbers FROM #Temp_NumberOfEntries AS A LEFT JOIN
		(
			SELECT B.F_DelegationID, COUNT(A.F_RegisterID) AS Numbers FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
				WHERE A.F_EventID = @MDEventID AND B.F_RegTypeID IN (1, 2, 3)
					GROUP BY B.F_DelegationID
		) AS B 
		ON A.F_DelegationID = B.F_DelegationID
		
	UPDATE A SET A.WD = B.Numbers FROM #Temp_NumberOfEntries AS A LEFT JOIN
		(
			SELECT B.F_DelegationID, COUNT(A.F_RegisterID) AS Numbers FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
				WHERE A.F_EventID = @WDEventID AND B.F_RegTypeID IN (1, 2, 3)
					GROUP BY B.F_DelegationID
		) AS B 
		ON A.F_DelegationID = B.F_DelegationID
		
     UPDATE A SET A.MIX = B.Numbers FROM #Temp_NumberOfEntries AS A LEFT JOIN
		(
			SELECT B.F_DelegationID, COUNT(A.F_RegisterID) AS Numbers FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
				WHERE A.F_EventID = @MIXEventID AND B.F_RegTypeID IN (1, 2, 3)
					GROUP BY B.F_DelegationID
		) AS B 
		ON A.F_DelegationID = B.F_DelegationID
		

	UPDATE #Temp_NumberOfEntries SET Men = [dbo].[Func_Report_TE_GetDelegationPlayerCount] (@DisciplineID, F_DelegationID, 1)
	UPDATE #Temp_NumberOfEntries SET Women = [dbo].[Func_Report_TE_GetDelegationPlayerCount] (@DisciplineID, F_DelegationID, 2)
	
	UPDATE #Temp_NumberOfEntries SET Total = ISNULL(Men, 0) + ISNULL(Women, 0)

	SELECT * FROM #Temp_NumberOfEntries

SET NOCOUNT OFF
END



