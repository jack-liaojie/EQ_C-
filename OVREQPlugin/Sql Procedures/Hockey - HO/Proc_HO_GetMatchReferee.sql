IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_GetMatchReferee]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_GetMatchReferee]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_HO_GetMatchReferee]
--描    述：得到Match下已选的裁判信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年08月20日


CREATE PROCEDURE [dbo].[Proc_HO_GetMatchReferee](
												@MatchID		    INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_RegisterID      INT,
                                F_RegisterName    NVARCHAR(100),
                                F_Delegation      NVARCHAR(100),
                                F_Function        NVARCHAR(100),
                                F_Order           INT
							)

    INSERT INTO #Tmp_Table (F_RegisterID, F_RegisterName, F_Delegation, F_Function, F_Order)
	SELECT MS.F_RegisterID, RD.F_LongName, DD.F_DelegationLongName, FD.F_FunctionLongName, MS.F_Order
	FROM TS_Match_Servant AS MS
	LEFT JOIN TR_Register AS R ON MS.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON D.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	LEFT JOIN TD_Function AS F ON MS.F_FunctionID = F.F_FunctionID
	LEFT JOIN TD_Function_Des AS FD ON F.F_FunctionID = FD.F_FunctionID AND FD.F_LanguageCode = @LanguageCode
	WHERE MS.F_MatchID = @MatchID AND MS.F_RegisterID IS NOT NULL ORDER BY (CASE WHEN F_Order IS NULL THEN 1 ELSE 0 END), MS.F_Order,  MS.F_ServantNum
   
	SELECT F_RegisterName AS LongName, F_Delegation AS [Delegation], F_Function AS [Function], F_Order AS [Order], F_RegisterID FROM #Tmp_Table

Set NOCOUNT OFF
End

GO


