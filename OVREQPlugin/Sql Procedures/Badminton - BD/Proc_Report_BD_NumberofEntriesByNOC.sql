IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_NumberofEntriesByNOC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_NumberofEntriesByNOC]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_Report_BD_NumberofEntriesByNOC]
--描    述：得到Discipline下得各个Event参赛数
--参数说明： 
--说    明：
--创 建 人：管仁良
--日    期：2010年09月20日

----2011-03-16:增加医生和教练的统计


CREATE PROCEDURE [dbo].[Proc_Report_BD_NumberofEntriesByNOC](
												@DisciplineID	    INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	
	CREATE TABLE #RegisterNumber_Table(
                                F_DelegationID  INT,
                                F_NOC           NVARCHAR(10),
                                F_NOCDes        NVARCHAR(100),
                                F_MS            INT,
                                F_MD            INT,
                                F_MT			INT,
                                F_WS            INT,
                                F_WD            INT,
								F_WT			INT,
                                F_XD			INT,
                                F_XT			INT,
                                F_MTotal        INT,
                                F_WTotal        INT,
                                F_Total         INT,
                                F_Coach         INT,
                                F_Manager       INT,
                                F_Doctor        INT
							)

    CREATE TABLE #Register_Table(
                                  F_DelegationID  INT,
                                  F_RegisterID    INT,
                            )

    CREATE TABLE #Number_Table(
                                  F_RegisterID   INT
                              )

    INSERT INTO #RegisterNumber_Table(F_DelegationID, F_NOC, F_NOCDes)
    SELECT DISTINCT A.F_DelegationID, B.F_DelegationCode, C.F_DelegationLongName
    FROM TR_Register AS A LEFT JOIN TC_Delegation AS B ON A.F_DelegationID = B.F_DelegationID
    LEFT JOIN TC_Delegation_Des AS C ON B.F_DelegationID = C.F_DelegationID AND C.F_LanguageCode = @LanguageCode
    WHERE A.F_RegTypeID IN (1,3) AND A.F_DisciplineID =  @DisciplineID

    DECLARE @DelegationID INT

    DECLARE @EventIDMS INT
    DECLARE @EventIDMD INT
    DECLARE @EventIDMT INT    
    DECLARE @EventIDWS INT
    DECLARE @EventIDWD INT
    DECLARE @EventIDWT INT    
    DECLARE @EventIDXD INT
    DECLARE @EventIDXT INT 

    SELECT @EventIDMS = F_EventID FROM TS_Event WHERE F_EventCode = '001' AND F_SexCode = 1 AND F_DisciplineID = @DisciplineID
    SELECT @EventIDMD = F_EventID FROM TS_Event WHERE F_EventCode = '002' AND F_SexCode = 1 AND F_DisciplineID = @DisciplineID
    SELECT @EventIDMT = F_EventID FROM TS_Event WHERE F_EventCode = '003' AND F_SexCode = 1 AND F_DisciplineID = @DisciplineID    
    SELECT @EventIDWS = F_EventID FROM TS_Event WHERE F_EventCode = '101' AND F_SexCode = 2 AND F_DisciplineID = @DisciplineID
    SELECT @EventIDWD = F_EventID FROM TS_Event WHERE F_EventCode = '102' AND F_SexCode = 2 AND F_DisciplineID = @DisciplineID
    SELECT @EventIDWT = F_EventID FROM TS_Event WHERE F_EventCode = '103' AND F_SexCode = 2 AND F_DisciplineID = @DisciplineID
    SELECT @EventIDXD = F_EventID FROM TS_Event WHERE F_EventCode = '201' AND F_SexCode = 3 AND F_DisciplineID = @DisciplineID
    SELECT @EventIDXT = F_EventID FROM TS_Event WHERE F_EventCode = '202' AND F_SexCode = 3 AND F_DisciplineID = @DisciplineID     

    DECLARE @CountMS INT
    DECLARE @CountMD INT
    DECLARE @CountMT INT
    DECLARE @CountWS INT
    DECLARE @CountWD INT
    DECLARE @CountWT INT
    DECLARE @CountXD INT
    DECLARE @CountXT INT     
    

    DECLARE ONE_CURSOR CURSOR FOR SELECT F_DelegationID FROM #RegisterNumber_Table
	OPEN ONE_CURSOR
	FETCH NEXT FROM ONE_CURSOR INTO @DelegationID
	WHILE @@FETCH_STATUS = 0 
	BEGIN

----------------------------------统计报项人数
		SELECT @CountMS = COUNT(A.F_RegisterID) FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
        WHERE A.F_EventID = @EventIDMS AND B.F_RegTypeID = 1 AND B.F_DelegationID = @DelegationID

        SELECT @CountMD = COUNT(A.F_RegisterID) FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
        WHERE A.F_EventID = @EventIDMD AND B.F_RegTypeID = 2 AND B.F_DelegationID = @DelegationID
        
        SELECT @CountMT = COUNT(A.F_RegisterID) FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
        WHERE A.F_EventID = @EventIDMT AND B.F_RegTypeID = 3 AND B.F_DelegationID = @DelegationID
        
        SELECT @CountWS = COUNT(A.F_RegisterID) FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
        WHERE A.F_EventID = @EventIDWS AND B.F_RegTypeID = 1 AND B.F_DelegationID = @DelegationID

        SELECT @CountWD = COUNT(A.F_RegisterID) FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
        WHERE A.F_EventID = @EventIDWD AND B.F_RegTypeID = 2 AND B.F_DelegationID = @DelegationID

        SELECT @CountWT = COUNT(A.F_RegisterID) FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
        WHERE A.F_EventID = @EventIDWT AND B.F_RegTypeID = 3 AND B.F_DelegationID = @DelegationID
        
        SELECT @CountXD = COUNT(A.F_RegisterID) FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
        WHERE A.F_EventID = @EventIDXD AND B.F_RegTypeID = 2 AND B.F_DelegationID = @DelegationID

        SELECT @CountXT = COUNT(A.F_RegisterID) FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
        WHERE A.F_EventID = @EventIDXT AND B.F_RegTypeID = 3 AND B.F_DelegationID = @DelegationID

-------------------------------------统计男子数
        DELETE FROM #Register_Table
        DELETE FROM #Number_Table
        
        --统计多人赛中男子ID
        INSERT INTO #Register_Table(F_DelegationID, F_RegisterID)
        SELECT @DelegationID, A.F_MemberRegisterID FROM TR_Register_Member AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID
        LEFT JOIN TR_Register AS C ON A.F_MemberRegisterID = C.F_RegisterID 
        WHERE C.F_RegTypeID = 1 AND C.F_SexCode=1 AND C.F_DelegationID = @DelegationID 
        AND (B.F_EventID = @EventIDMD OR B.F_EventID = @EventIDMT OR B.F_EventID = @EventIDXD OR B.F_EventID = @EventIDXT)        

		--统计单人赛中男子ID
        INSERT INTO #Register_Table(F_DelegationID, F_RegisterID)
        SELECT @DelegationID, B.F_RegisterID FROM TR_Inscription AS A
        LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_RegTypeID = 1 AND A.F_EventID = @EventIDMS
        AND B.F_DelegationID = @DelegationID

        INSERT INTO #Number_Table(F_RegisterID)
        SELECT DISTINCT F_RegisterID FROM #Register_Table

        DECLARE @CountM INT
        SELECT @CountM = COUNT(F_RegisterID) FROM #Number_Table

---------------------------------------统计女子数
        DELETE FROM #Register_Table
        DELETE FROM #Number_Table
        
        --统计多人赛中女子ID
        INSERT INTO #Register_Table(F_DelegationID, F_RegisterID)
        SELECT @DelegationID, A.F_MemberRegisterID FROM TR_Register_Member AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID
        LEFT JOIN TR_Register AS C ON A.F_MemberRegisterID = C.F_RegisterID 
        WHERE C.F_RegTypeID = 1 AND C.F_SexCode=2 AND C.F_DelegationID = @DelegationID 
        AND (B.F_EventID = @EventIDWD OR B.F_EventID = @EventIDWT OR B.F_EventID = @EventIDXD OR B.F_EventID = @EventIDXT)
		
		--统计单人赛中女子ID
        INSERT INTO #Register_Table(F_DelegationID, F_RegisterID)
        SELECT @DelegationID, B.F_RegisterID FROM TR_Inscription AS A
        LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_RegTypeID = 1 AND A.F_EventID = @EventIDWS
        AND B.F_DelegationID = @DelegationID        

        INSERT INTO #Number_Table(F_RegisterID)
        SELECT DISTINCT F_RegisterID FROM #Register_Table

        DECLARE @CountW INT
        SELECT @CountW = COUNT(F_RegisterID) FROM #Number_Table
        
        --添加一条统计数据
        UPDATE #RegisterNumber_Table SET F_MS = @CountMS, F_MD = @CountMD, F_MT = @CountMT, F_WS = @CountWS, F_WD = @CountWD, F_WT = @CountWT, F_XD = @CountXD, F_XT = @CountXT, F_MTotal = @CountM, F_WTotal = @CountW 
        WHERE F_DelegationID = @DelegationID

		FETCH NEXT FROM ONE_CURSOR INTO @DelegationID
	END
	CLOSE ONE_CURSOR
	DEALLOCATE ONE_CURSOR
    --END

    UPDATE #RegisterNumber_Table SET F_Total = F_MTotal + F_WTotal

    DELETE FROM #RegisterNumber_Table WHERE F_Total = 0

    ALTER TABLE #RegisterNumber_Table DROP COLUMN F_DelegationID
   
	--UPDATE #RegisterNumber_Table SET F_Coach = COUNT(C.F_RegisterID)
	--FROM #RegisterNumber_Table AS A
	--LEFT JOIN TC_Delegation AS B ON B.F_DelegationCode = A.F_NOC
	--LEFT JOIN TR_Register AS C ON C.F_DelegationID = B.F_DelegationID
	--LEFT JOIN TD_Function AS D ON D.F_FunctionID = C.F_FunctionID
	--WHERE A.F_NOC = B.F_DelegationCode  AND D.F_FunctionCode = 'AA08'
	
	DECLARE @NOCCode NVARCHAR(10)
	DECLARE MyCursor CURSOR FOR SELECT F_NOC FROM #RegisterNumber_Table
	OPEN MyCursor 
	FETCH NEXT FROM MyCursor INTO @NOCCode
	WHILE @@FETCH_STATUS = 0
	BEGIN
		UPDATE #RegisterNumber_Table SET F_Coach = 
		(
			SELECT COUNT(A.F_RegisterID) FROM TR_Register AS A
			LEFT JOIN TC_Delegation AS B ON B.F_DelegationID = A.F_DelegationID
			LEFT JOIN TD_Function AS C ON C.F_FunctionID = A.F_FunctionID
			WHERE B.F_DelegationCode = @NOCCode AND C.F_FunctionCode = 'AA08'
		) WHERE F_NOC = @NOCCode
		
		UPDATE #RegisterNumber_Table SET F_Doctor = 
		(
			SELECT COUNT(A.F_RegisterID) FROM TR_Register AS A
			LEFT JOIN TC_Delegation AS B ON B.F_DelegationID = A.F_DelegationID
			LEFT JOIN TD_Function AS C ON C.F_FunctionID = A.F_FunctionID
			WHERE B.F_DelegationCode = @NOCCode AND C.F_FunctionCode = 'AA13'
		) WHERE F_NOC = @NOCCode
		
		
		UPDATE #RegisterNumber_Table SET F_Manager =
		(
			SELECT COUNT(A.F_RegisterID) FROM TR_Register AS A
			LEFT JOIN TC_Delegation AS B ON B.F_DelegationID = A.F_DelegationID
			LEFT JOIN TD_Function AS C ON C.F_FunctionID = A.F_FunctionID
			WHERE B.F_DelegationCode = @NOCCode AND C.F_FunctionCode = 'AA20'
		) WHERE F_NOC = @NOCCode
		
		FETCH NEXT FROM MyCursor INTO @NOCCode
	END
	
	CLOSE MyCursor
	DEALLOCATE MyCursor
    SELECT * FROM #RegisterNumber_Table ORDER BY F_NOC

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



GO

