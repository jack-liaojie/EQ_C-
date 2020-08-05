
/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_TeamRosterOfficials]    Script Date: 08/29/2012 09:58:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HB_TeamRosterOfficials]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HB_TeamRosterOfficials]
GO


/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_TeamRosterOfficials]    Script Date: 08/29/2012 09:58:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_Report_HB_TeamRosterOfficials]
--描    述：得到代表团下各个队的官员列表
--参数说明： 
--说    明：
--创 建 人：杨佳鹏
--日    期：2010年07月06日


CREATE PROCEDURE [dbo].[Proc_Report_HB_TeamRosterOfficials](
												@DisciplineID		INT,
                                                @DelegationID       INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	
	CREATE TABLE #Tmp_Table(
                                F_EventID          INT,
                                F_RegisterID       INT,
                                F_FunctionCode     NVARCHAR(20),
                                F_FunctionName     NVARCHAR(100),
                                F_PrintLN          NVARCHAR(150),
                                F_PrintSN          NVARCHAR(100),
                                )

    IF @DelegationID = -1
    BEGIN
        INSERT INTO #Tmp_Table(F_EventID, F_RegisterID,F_PrintLN, F_PrintSN,F_FunctionCode,F_FunctionName)
        SELECT A.F_EventID, A.F_RegisterID
        ,E.F_PrintLongName + (CASE WHEN D.F_NOC IS NULL THEN '' ELSE ' (' + D.F_NOC + ')' END)
        ,E.F_PrintShortName + (CASE WHEN D.F_NOC IS NULL THEN '' ELSE ' (' + D.F_NOC + ')' END)
        ,F.F_FunctionCode
        ,F1.F_FunctionLongName
        FROM TR_Inscription AS A RIGHT JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_RegisterID
        LEFT JOIN TS_Event AS C ON A.F_EventID = C.F_EventID
        LEFT JOIN TR_Register AS D ON B.F_MemberRegisterID = D.F_RegisterID
        LEFT JOIN TR_Register_Des AS E ON D.F_RegisterID = E.F_RegisterID AND E.F_LanguageCode = @LanguageCode
        LEFT JOIN TD_Function AS F ON B.F_FunctionID = F.F_FunctionID
        LEFT JOIN TD_Function_Des AS F1 ON F1.F_FunctionID = F.F_FunctionID AND F1.F_LanguageCode = @LanguageCode
        WHERE C.F_DisciplineID = @DisciplineID 
        AND D.F_DisciplineID = @DisciplineID 
        AND D.F_RegTypeID = 5 
        AND B.F_FunctionID IS NOT NULL
    END
    ELSE
    BEGIN
        INSERT INTO #Tmp_Table(F_EventID, F_RegisterID,F_PrintLN, F_PrintSN,F_FunctionCode,F_FunctionName)
        SELECT A.F_EventID, A.F_RegisterID
        ,E.F_PrintLongName + (CASE WHEN D.F_NOC IS NULL THEN '' ELSE ' (' + D.F_NOC + ')' END)
        ,E.F_PrintShortName + (CASE WHEN D.F_NOC IS NULL THEN '' ELSE ' (' + D.F_NOC + ')' END)
        ,F.F_FunctionCode
        ,F1.F_FunctionLongName
        FROM TR_Inscription AS A RIGHT JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_RegisterID
        LEFT JOIN TS_Event AS C ON A.F_EventID = C.F_EventID
        LEFT JOIN TR_Register AS D ON B.F_MemberRegisterID = D.F_RegisterID
        LEFT JOIN TR_Register_Des AS E ON D.F_RegisterID = E.F_RegisterID AND E.F_LanguageCode = @LanguageCode
        LEFT JOIN TD_Function AS F ON B.F_FunctionID = F.F_FunctionID
        LEFT JOIN TD_Function_Des AS F1 ON F1.F_FunctionID = F.F_FunctionID AND F1.F_LanguageCode = @LanguageCode
        WHERE C.F_DisciplineID = @DisciplineID 
        AND D.F_DisciplineID = @DisciplineID 
        AND D.F_RegTypeID = 5 
        AND D.F_DelegationID = @DelegationID 
        AND B.F_FunctionID IS NOT NULL
    END
    
 --    CREATE TABLE #tmp_Function(
 --                                     F_FunctionCode   NVARCHAR(20),
 --                                     F_Order          INT
 --                                )
	--INSERT INTO #tmp_Function(F_FunctionCode, F_Order)
	--SELECT 'AA07',1 
	--UNION SELECT  'AA22', 2
	--UNION SELECT  'AA05', 3
	--UNION SELECT  'AA10', 4
	--UNION SELECT  'AA11', 5
	
	SELECT   a.F_EventID,
             a.F_RegisterID,
             a.F_FunctionCode,
             a.F_FunctionName,
             a.F_PrintLN,
             a.F_PrintSN,
             dense_RANK() OVER(ORDER BY F_FunctionCode) AS F_Order
	FROM #Tmp_Table as a --INNER join #tmp_Function as b 
	--ON a.F_FunctionCode = b.F_FunctionCode 
	ORDER BY F_RegisterID, F_FunctionCode, F_PrintLN 

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


