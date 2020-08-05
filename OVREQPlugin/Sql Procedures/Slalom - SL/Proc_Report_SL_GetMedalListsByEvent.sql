IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetMedalListsByEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetMedalListsByEvent]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--��    ��: [Proc_Report_SL_GetMedalListsByEvent]
--��    ��: ����������Ŀ�����ȡ������Ŀ���ƻ������ϸ��Ϣ  
--����˵��: 
--˵    ��: 
--�� �� ��: �ⶨ�P
--��    ��: 2010��01��25��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����	
*/



CREATE PROCEDURE [dbo].[Proc_Report_SL_GetMedalListsByEvent]
	@DisciplineID						INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
     SET Language English
	SELECT E.F_Order AS [EventOrder]
		, F.F_EventLongName AS [EventName]
		, UPPER(CONVERT(NVARCHAR(20), E.F_CloseDate, 106)) AS [Date]
		--, DATENAME(DAY,E.F_CloseDate) + ' ' + UPPER(Substring(DATENAME(MONTH,E.F_CloseDate),1,3)) AS [Date]
		, A.F_EventRank AS [Rank]
		, B.F_MedalLongName AS [Medal]
		, 0 AS [MemberOrder]
	    ,(SELECT REPLACE(D.F_PrintLongName,'/',nchar(10))) AS [MemberName]
		, G.F_DelegationCode AS [NOC]
		, A.F_RegisterID
	FROM TS_Event_Result AS A
	LEFT JOIN TC_Medal_Des AS B 
		ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS C
		ON A.F_RegisterID = C.F_RegisterID
	LEFT JOIN TR_Register_Des AS D
		ON A.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event AS E
		ON A.F_EventID = E.F_EventID 
	LEFT JOIN TS_Event_Des AS F
		ON A.F_EventID = F.F_EventID AND F.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS G
		ON C.F_DelegationID = G.F_DelegationID
	WHERE A.F_MedalID IS NOT NULL
		AND E.F_DisciplineID = @DisciplineID
		AND E.F_EventStatusID > 100

SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

-- Just for test
EXEC [Proc_Report_SL_GetMedalListsByEvent] 59

*/