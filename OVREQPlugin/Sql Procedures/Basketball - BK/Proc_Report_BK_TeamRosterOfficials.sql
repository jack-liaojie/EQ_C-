IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_TeamRosterOfficials]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_TeamRosterOfficials]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_Report_BK_TeamRosterOfficials]
--描    述：得到每个参赛队的所有官员信息
--参数说明： 
--说    明：
--创 建 人：杨佳鹏
--日    期：2011年06月08日


CREATE PROCEDURE [dbo].[Proc_Report_BK_TeamRosterOfficials](
												@DisciplineID		INT,
												@EventID            INT,
                                                @DelegationID       INT,
                                                @RegisterID			INT,
												@LanguageCode		CHAR(3)
                                                
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH

	CREATE TABLE #Tmp_Table(
                                F_DelegationID       INT,
                                F_RegisterID         INT,
                                F_NOC                NVARCHAR(10),
                                F_NOCDes             NVARCHAR(100),
                                F_EventID            INT,
                                F_RSCCode			 NVARCHAR(100),
                                F_EventName          NVARCHAR(100),
                                F_EventNameCHN       NVARCHAR(100),
                                F_EventOrder         INT,
                                F_Title			     NVARCHAR(100),
                                F_Name				 NVARCHAR(100),
							)

     INSERT INTO #Tmp_Table (F_DelegationID, F_RegisterID, F_NOC, F_NOCDes, F_EventID,F_RSCCode, F_EventName, F_EventOrder,F_Title,F_Name) 
	SELECT A.F_DelegationID
	, A.F_RegisterID
	, C.F_DelegationCode
	, D.F_DelegationLongName
	, E.F_EventID
	,CONVERT(NVARCHAR(100),H.F_DisciplineCode) + CONVERT(NVARCHAR(100),I.F_GenderCode) + CONVERT(NVARCHAR(100),F.F_EventCode) + '000' 
	,G.F_EventLongName
	, F.F_Order
	,M.F_FunctionLongName
	,L.F_PrintLongName
	FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS C ON A.F_DelegationID = C.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS D ON C.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = @LanguageCode
	INNER JOIN TR_Inscription AS E ON A.F_RegisterID = E.F_RegisterID
	LEFT JOIN TS_Event AS F ON E.F_EventID = F.F_EventID
	LEFT JOIN TS_Event_Des AS G ON F.F_EventID = G.F_EventID AND G.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Discipline AS H ON H.F_DisciplineID = A.F_DisciplineID
	LEFT JOIN TC_Sex AS I ON A.F_SexCode = I.F_SexCode
	LEFT JOIN TR_Register_Member AS K ON A.F_RegisterID = K.F_RegisterID
	LEFT JOIN TR_Register_Des AS L ON K.F_MemberRegisterID = L.F_RegisterID AND L.F_LanguageCode = @LanguageCode
	LEFT JOIN TD_Function_Des AS M ON K.F_FunctionID = M.F_FunctionID AND M.F_LanguageCode = @LanguageCode
	LEFT JOIN TD_Function AS N ON K.F_FunctionID = N.F_FunctionID
	WHERE A.F_RegTypeID = 3 
	AND A.F_DisciplineID = @DisciplineID 
	AND ( @EventID = -1 OR E.F_EventID = @EventID)
	AND(@DelegationID = -1  OR A.F_DelegationID = @DelegationID)
	AND (@RegisterID = -1 OR A.F_RegisterID = @RegisterID)
	AND N.F_FunctionCode IN('AA22','AA07')--('AA05','AA22','AA07','AA10','AA11')
	ORDER BY C.F_DelegationCode, 
	A.F_SexCode,
	CASE N.F_FunctionCode 
		WHEN 'AA07' THEN 1 
		WHEN 'AA22' THEN 2
		--WHEN 'AA05'THEN 3 
		--WHEN 'AA10'THEN 4 
		--WHEN 'AA11' THEN 5 
	END,
	 L.F_PrintLongName

    UPDATE #Tmp_Table SET F_EventNameCHN = B.F_EventLongName FROM #Tmp_Table AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = 'CHN'
 
	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO
--exec [Proc_Report_BK_TeamRosterOfficials] 1,-1,-1,-1,'ENG'
