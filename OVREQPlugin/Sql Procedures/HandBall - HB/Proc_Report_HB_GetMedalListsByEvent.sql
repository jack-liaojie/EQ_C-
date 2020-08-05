
/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_GetMedalListsByEvent]    Script Date: 08/29/2012 15:37:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HB_GetMedalListsByEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HB_GetMedalListsByEvent]
GO



/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_GetMedalListsByEvent]    Script Date: 08/29/2012 15:37:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--名    称：[Proc_Report_HB_GetMedalListsByEvent]
--描    述：得到有奖牌榜信息的Event
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月21日


CREATE PROCEDURE [dbo].[Proc_Report_HB_GetMedalListsByEvent](
												@DisciplineID		    INT,
												@LanguageCode		    CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_EventID      INT,
                                F_EventName    NVARCHAR(100),
                                F_Date         NVARCHAR(11),
                                F_MedalName    NVARCHAR(100),
                                F_MedalNOC     NVARCHAR(10),
                                F_MedalType    NVARCHAR(10),
                                F_MemberName   NVARCHAR(50),
                                F_FinishCount  INT,
                                F_TotalCount   INT,
                                F_MedalID      INT,
                                F_RegisterID   INT,
                                F_MemberID     INT
							)

    CREATE TABLE #Tmp_FinishEvent(
                                     F_EventID     INT
                                 )


    INSERT INTO #Tmp_Table (F_EventID, F_EventName, F_Date, F_MedalID, F_RegisterID, F_MemberID)
    SELECT A.F_EventID, C.F_EventLongName, LEFT(CONVERT (NVARCHAR(100), B.F_CloseDate, 113), 11), A.F_MedalID, A.F_RegisterID, D.F_MemberRegisterID
    FROM TS_Event_Result AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID 
                    LEFT JOIN TS_Event_Des AS C ON A.F_EventID = C.F_EventID AND C.F_LanguageCode = @LanguageCode
                    LEFT JOIN TR_Register_Member AS D ON A.F_RegisterID = D.F_RegisterID
                    LEFT JOIN TR_Register AS E ON D.F_MemberRegisterID = E.F_RegisterID
         WHERE B.F_DisciplineID = @DisciplineID AND E.F_RegTypeID = 1 AND A.F_MedalID IS NOT NULL
              ORDER BY B.F_CloseDate, A.F_EventRank

    UPDATE #Tmp_Table SET F_MedalName = B.F_PrintLongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_MedalNOC = C.F_DelegationCode FROM #Tmp_Table AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
    LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
    UPDATE #Tmp_Table SET F_MedalType = B.F_MedalLongName FROM #Tmp_Table AS A LEFT JOIN TC_Medal_Des AS B ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
    
    UPDATE #Tmp_Table SET F_MemberName = B.F_PrintLongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_MemberID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode

    
    --计算总数
    DECLARE @Count INT
    SELECT @Count = COUNT(F_EventID) FROM TS_Event WHERE F_DisciplineID = @DisciplineID
    UPDATE #Tmp_Table SET F_TotalCount = @Count

    INSERT INTO #Tmp_FinishEvent(F_EventID)
    SELECT DISTINCT B.F_EventID FROM TS_Event_Result AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
    WHERE B.F_DisciplineID = @DisciplineID AND A.F_RegisterID IS NOT NULL

    SELECT @Count = COUNT(F_EventID) FROM #Tmp_FinishEvent
    UPDATE #Tmp_Table SET F_FinishCount = @Count

    SELECT * FROM #Tmp_Table WHERE F_RegisterID IS NOT NULL AND F_MedalID IS NOT NULL

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


