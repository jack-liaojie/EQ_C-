IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HB_GetTeamMedallists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HB_GetTeamMedallists]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Proc_Report_HB_GetTeamMedallists](
												@EventID		    INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_RegisterID        INT,
                                F_NOC               NVARCHAR(10),
                                F_NOCDes            NVARCHAR(100),
                                F_DisplayPos        INT,
                                F_Rank				NVARCHAR(10),
                                F_LongName          NVARCHAR(100),
                                F_ShortName         NVARCHAR(50),
                                F_Medal             NVARCHAR(50),
                                F_Date              NVARCHAR(20),
                                F_WEEKENG           NVARCHAR(10),
                                F_WEEKCHN           NVARCHAR(10),
                                F_EventDate         DATETIME
							)

    DECLARE @EventType INT
    SELECT @EventType = F_PlayerRegTypeID FROM TS_Event WHERE F_EventID = @EventID
    
    -- Event is NOT Team, then return
    IF @EventType <> 3 
    BEGIN
        RETURN
    END

	INSERT INTO #Tmp_Table (F_RegisterID, F_NOC, F_NOCDes, F_DisplayPos, F_Rank, 
							F_Medal, F_LongName, F_ShortName, F_EventDate, F_Date, F_WEEKENG) 
	SELECT B.F_MemberRegisterID, D.F_DelegationCode, E.F_DelegationLongName, A.F_EventDisplayPosition, A.F_EventRank,
	C.F_MedalLongName, F.F_PrintLongName, F.F_PrintShortName,
    G.F_CloseDate, [dbo].[Fun_Report_GF_GetDateTime](G.F_CloseDate, 4), UPPER(LEFT(DATENAME(WEEKDAY, G.F_CloseDate), 3))
    FROM TS_Event_Result AS A
    LEFT JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_RegisterID
    LEFT JOIN TC_Medal_Des AS C ON A.F_MedalID = C.F_MedalID AND C.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Register AS M ON B.F_MemberRegisterID = M.F_RegisterID
    LEFT JOIN TC_Delegation AS D ON M.F_DelegationID = D.F_DelegationID
    LEFT JOIN TC_Delegation_Des AS E ON D.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Register_Des AS F ON M.F_RegisterID = F.F_RegisterID AND F.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Event AS G ON A.F_EventID = G.F_EventID
    WHERE A.F_EventID = @EventID --AND A.F_MedalID IS NOT NULL 
    ORDER BY F_EventRank, D.F_DelegationCode, F.F_LastName, F.F_FirstName
 
    SET LANGUAGE N'¼òÌåÖÐÎÄ'
	UPDATE #Tmp_Table SET F_WEEKCHN = UPPER(LEFT(DATENAME(WEEKDAY, F_EventDate), 3))
	
    SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


