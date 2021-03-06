IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_NumberofEntriesByNOC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_NumberofEntriesByNOC]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_Report_GF_NumberofEntriesByNOC]
--描    述：得到Discipline下得各个Event参赛数
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年01月20日


CREATE PROCEDURE [dbo].[Proc_Report_GF_NumberofEntriesByNOC](
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
                                F_MI            INT,
                                F_MT            INT,
                                F_WI            INT,
                                F_WT            INT,
                                F_MTotal        INT,
                                F_WTotal        INT,
                                F_Total         INT
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
    DECLARE @EventIDMT INT
    DECLARE @EventIDWS INT
    DECLARE @EventIDWT INT

    DECLARE @CountMI INT
    DECLARE @CountMT INT
    DECLARE @CountWI INT
    DECLARE @CountWT INT

    SELECT @EventIDMS = F_EventID FROM TS_Event WHERE F_EventCode = '001' AND F_SexCode = 1 AND F_DisciplineID = @DisciplineID
    SELECT @EventIDMT = F_EventID FROM TS_Event WHERE F_EventCode = '002' AND F_SexCode = 1 AND F_DisciplineID = @DisciplineID
    SELECT @EventIDWS = F_EventID FROM TS_Event WHERE F_EventCode = '101' AND F_SexCode = 2 AND F_DisciplineID = @DisciplineID
    SELECT @EventIDWT = F_EventID FROM TS_Event WHERE F_EventCode = '102' AND F_SexCode = 2 AND F_DisciplineID = @DisciplineID

    DECLARE ONE_CURSOR CURSOR FOR SELECT F_DelegationID FROM #RegisterNumber_Table
	OPEN ONE_CURSOR
	FETCH NEXT FROM ONE_CURSOR INTO @DelegationID
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		SELECT @CountMI = COUNT(A.F_RegisterID) FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
        WHERE A.F_EventID = @EventIDMS AND B.F_RegTypeID = 1 AND B.F_DelegationID = @DelegationID

        SELECT @CountMT = COUNT(A.F_RegisterID) FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
        WHERE A.F_EventID = @EventIDMT AND B.F_RegTypeID = 3 AND B.F_DelegationID = @DelegationID

        SELECT @CountWI = COUNT(A.F_RegisterID) FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
        WHERE A.F_EventID = @EventIDWS AND B.F_RegTypeID = 1 AND B.F_DelegationID = @DelegationID

        SELECT @CountWT = COUNT(A.F_RegisterID) FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
        WHERE A.F_EventID = @EventIDWT AND B.F_RegTypeID = 3 AND B.F_DelegationID = @DelegationID

        DELETE FROM #Register_Table
        DELETE FROM #Number_Table
        
        INSERT INTO #Register_Table(F_DelegationID, F_RegisterID)
        SELECT @DelegationID, A.F_MemberRegisterID FROM TR_Register_Member AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID
        LEFT JOIN TR_Register AS C ON A.F_MemberRegisterID = C.F_RegisterID WHERE C.F_RegTypeID = 1 AND B.F_EventID = @EventIDMT
        AND C.F_DelegationID = @DelegationID

        INSERT INTO #Register_Table(F_DelegationID, F_RegisterID)
        SELECT @DelegationID, B.F_RegisterID FROM TR_Inscription AS A
        LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_RegTypeID = 1 AND A.F_EventID = @EventIDMS
        AND B.F_DelegationID = @DelegationID

        INSERT INTO #Number_Table(F_RegisterID)
        SELECT DISTINCT F_RegisterID FROM #Register_Table

        DECLARE @CountM INT
        SELECT @CountM = COUNT(F_RegisterID) FROM #Number_Table

        DELETE FROM #Register_Table
        DELETE FROM #Number_Table
        
        INSERT INTO #Register_Table(F_DelegationID, F_RegisterID)
        SELECT @DelegationID, A.F_MemberRegisterID FROM TR_Register_Member AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID
        LEFT JOIN TR_Register AS C ON A.F_MemberRegisterID = C.F_RegisterID WHERE C.F_RegTypeID = 1 AND B.F_EventID = @EventIDWT
        AND C.F_DelegationID = @DelegationID

        INSERT INTO #Register_Table(F_DelegationID, F_RegisterID)
        SELECT @DelegationID, B.F_RegisterID FROM TR_Inscription AS A
        LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_RegTypeID = 1 AND A.F_EventID = @EventIDWS
        AND B.F_DelegationID = @DelegationID

        INSERT INTO #Number_Table(F_RegisterID)
        SELECT DISTINCT F_RegisterID FROM #Register_Table

        DECLARE @CountW INT
        SELECT @CountW = COUNT(F_RegisterID) FROM #Number_Table
        
        UPDATE #RegisterNumber_Table SET F_MI = @CountMI, F_MT = @CountMT, F_WI = @CountWI, F_WT = @CountWT, F_MTotal = @CountM, F_WTotal = @CountW WHERE F_DelegationID = @DelegationID

		FETCH NEXT FROM ONE_CURSOR INTO @DelegationID
	END
	CLOSE ONE_CURSOR
	DEALLOCATE ONE_CURSOR
    --END

    UPDATE #RegisterNumber_Table SET F_Total = F_MTotal + F_WTotal
    DELETE FROM #RegisterNumber_Table WHERE F_Total = 0
    
    SELECT * FROM #RegisterNumber_Table ORDER BY F_NOC

Set NOCOUNT OFF
End	

set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO




