IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetCompetitorsList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetCompetitorsList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_Report_BD_GetCompetitorsList]
--描    述：得到Discipline下得Competitors列表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年01月21日


CREATE PROCEDURE [dbo].[Proc_Report_BD_GetCompetitorsList](
												@DisciplineID		INT,
                                                @DelegationID       INT,
												@LanguageCode		CHAR(3)
                                                
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH

	CREATE TABLE #Tmp_Table(
                                F_DelegationID  INT,
                                F_RegisterID    INT,
                                F_NOC           NVARCHAR(10),
                                F_NOCDes        NVARCHAR(100),
                                F_Bib           NVARCHAR(20),
                                F_RegTypeID     INT,
                                F_RegDes        NVARCHAR(50),
                                F_FimalyName    NVARCHAR(50),
                                F_GivenName     NVARCHAR(50),
								F_SexCode	    INT,
								F_Gender		NVARCHAR(50),
                                F_Birth_Date    NVARCHAR(11),
                                F_Height        INT,
                                F_Weight        INT,
                                F_RegisterCode  NVARCHAR(20),
                                F_UCICode       NVARCHAR(250),
                                F_PrintLN       NVARCHAR(100),
                                F_PrintSN       NVARCHAR(50),
                                F_TVLN          NVARCHAR(100),
                                F_TVSN          NVARCHAR(50),
                                F_SBLN          NVARCHAR(100),
                                F_SBSN          NVARCHAR(50),
                                F_WNPALN        NVARCHAR(100),
                                F_WNPASN        NVARCHAR(50),
                                F_HeightDes     NVARCHAR(20),
                                F_WeightDes     NVARCHAR(20),
                                F_FunctionID    INT,
                                F_Function      NVARCHAR(100),
                                F_Events        NVARCHAR(20),
                                F_Handedness    NVARCHAR(20)
							)

    CREATE TABLE #Tmp_Events(
                              F_Event       NVARCHAR(5)
                             )

    IF @DelegationID = -1
    BEGIN
		INSERT INTO #Tmp_Table (F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Bib, F_RegTypeID, 
				F_FimalyName, F_GivenName, F_SexCode, F_Birth_Date, F_Height, F_Weight, F_RegisterCode, F_UCICode, 
				F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, 
				F_SBLN, F_SBSN, F_WNPALN, F_WNPASN, F_FunctionID) 
		SELECT A.F_DelegationID, A.F_RegisterID, C.F_DelegationCode, D.F_DelegationLongName, A.F_Bib, A.F_RegTypeID, 
				B.F_LastName, B.F_FirstName, A.F_SexCode, [dbo].[Fun_Report_BD_GetDateTime](A.F_Birth_Date, 4), A.F_Height, A.F_Weight, A.F_RegisterCode, A.F_RegisterNum, 
				B.F_PrintLongName, B.F_PrintShortName, B.F_TvLongName, B.F_TvShortName,
		B.F_SBLongName, B.F_SBShortName, B.F_WNPA_LastName, B.F_WNPA_FirstName, A.F_FunctionID
		FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Delegation AS C ON A.F_DelegationID = C.F_DelegationID LEFT JOIN TC_Delegation_Des AS D ON C.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = @LanguageCode
		WHERE A.F_RegTypeID IN (1, 5) AND A.F_DisciplineID = @DisciplineID
		ORDER BY C.F_DelegationCode, A.F_SexCode, A.F_RegTypeID, B.F_LastName, B.F_FirstName
    END
    ELSE
    BEGIN
		INSERT INTO #Tmp_Table (F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Bib, F_RegTypeID, 
				F_FimalyName, F_GivenName, F_SexCode, F_Birth_Date, F_Height, F_Weight, F_RegisterCode, F_UCICode, 
				F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, 
				F_SBLN, F_SBSN, F_WNPALN, F_WNPASN, F_FunctionID) 
		SELECT A.F_DelegationID, A.F_RegisterID, C.F_DelegationCode, D.F_DelegationLongName, A.F_Bib, A.F_RegTypeID, 
				B.F_LastName, B.F_FirstName, A.F_SexCode, [dbo].[Fun_Report_BD_GetDateTime](A.F_Birth_Date, 4), A.F_Height, A.F_Weight, A.F_RegisterCode, A.F_RegisterNum, 
				B.F_PrintLongName, B.F_PrintShortName, B.F_TvLongName, B.F_TvShortName,
				B.F_SBLongName, B.F_SBShortName, B.F_WNPA_LastName, B.F_WNPA_FirstName, A.F_FunctionID
		FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode 
		LEFT JOIN TC_Delegation AS C ON A.F_DelegationID = C.F_DelegationID LEFT JOIN TC_Delegation_Des AS D ON C.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = @LanguageCode
		WHERE A.F_DelegationID = @DelegationID AND A.F_RegTypeID IN (1, 5) AND A.F_DisciplineID = @DisciplineID
		ORDER BY A.F_SexCode, A.F_RegTypeID, B.F_LastName, B.F_FirstName
    END

    UPDATE #Tmp_Table SET F_Handedness = B.F_Comment FROM #Tmp_Table AS A LEFT JOIN TR_Register_Comment AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_Title = 'Hand'
    UPDATE #Tmp_Table SET F_RegDes = B.F_RegTypeLongDescription FROM #Tmp_Table AS A LEFT JOIN TC_RegType_Des AS B ON A.F_RegTypeID = B.F_RegTypeID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_Gender = B.F_GenderCode FROM #Tmp_Table AS A LEFT JOIN TC_Sex AS B ON A.F_SexCode = B.F_SexCode
    UPDATE #Tmp_Table SET F_HeightDes = LEFT(F_Height / 100.0, 4) + ' / ' + CONVERT(NVARCHAR(2), F_Height * 100 / 3048) + '''' + CONVERT(NVARCHAR(2), (F_Height * 100 / 254) % 12) + '"'
    UPDATE #Tmp_Table SET F_WeightDes = CONVERT(NVARCHAR(3), F_Weight) + ' / ' + CONVERT(NVARCHAR(5), F_Weight * 22 / 10)

    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode AND F_RegTypeID = 5
    UPDATE #Tmp_Table SET F_Function = 'Athlete' WHERE F_RegTypeID = 1 AND @LanguageCode = 'ENG'
    UPDATE #Tmp_Table SET F_Function = '运动员' WHERE F_RegTypeID = 1 AND @LanguageCode = 'CHN'

    DECLARE @RegisterID INT
    DECLARE @Events NVARCHAR(100)
    DECLARE ONE_CURSOR CURSOR FOR SELECT F_RegisterID FROM #Tmp_Table WHERE F_RegTypeID = 1
	OPEN ONE_CURSOR
	FETCH NEXT FROM ONE_CURSOR INTO @RegisterID
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		BEGIN
        DELETE FROM #Tmp_Events
        INSERT INTO #Tmp_Events (F_Event)
        SELECT C.F_EventComment FROM TR_Inscription AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
        LEFT JOIN TS_Event_Des AS C ON B.F_EventID = C.F_EventID AND C.F_LanguageCode = @LanguageCode
        WHERE B.F_DisciplineID = @DisciplineID AND A.F_RegisterID = @RegisterID

        INSERT INTO #Tmp_Events (F_Event)
        SELECT D.F_EventComment FROM TR_Register_Member AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID
        LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
        LEFT JOIN TS_Event_Des AS D ON C.F_EventID = D.F_EventID AND D.F_LanguageCode = @LanguageCode
        WHERE C.F_DisciplineID = @DisciplineID AND A.F_MemberRegisterID = @RegisterID

        SET @Events = ''
        DECLARE @EventName NVARCHAR(10)
        DECLARE TWO_CURSOR CURSOR FOR SELECT F_Event FROM #Tmp_Events
		OPEN TWO_CURSOR
		FETCH NEXT FROM TWO_CURSOR INTO @EventName
		WHILE @@FETCH_STATUS = 0 
		BEGIN
			SET @Events = @Events + @EventName + ', '
			FETCH NEXT FROM TWO_CURSOR INTO @EventName
		END
		CLOSE TWO_CURSOR
		DEALLOCATE TWO_CURSOR
		--END

        IF LEN(@Events) > 0
        SET @Events = LEFT(@Events, LEN(@Events) - 1)
        UPDATE #Tmp_Table SET F_Events = @Events WHERE F_RegisterID = @RegisterID
        
        END
        
		FETCH NEXT FROM ONE_CURSOR INTO @RegisterID
	END
	CLOSE ONE_CURSOR
	DEALLOCATE ONE_CURSOR
    --END

	SELECT F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_Function, F_FimalyName, F_GivenName, F_Gender, F_Birth_Date, F_HeightDes, F_WeightDes, F_RegisterCode, F_UCICode,
    F_PrintLN, F_PrintSN, F_TVLN, F_TVSN, F_SBLN, F_SBSN, F_WNPALN, F_WNPASN, F_Events, F_Handedness FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

