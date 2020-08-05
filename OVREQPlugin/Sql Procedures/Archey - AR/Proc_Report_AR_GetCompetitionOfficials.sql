IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_GetCompetitionOfficials]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_GetCompetitionOfficials]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_Report_AR_GetCompetitionOfficials]
--描    述：裁判官员信息分组信息
--参数说明： 
--创 建 人：崔凯
--日    期：2011年6月1日


CREATE PROCEDURE [dbo].[Proc_Report_AR_GetCompetitionOfficials](
			@DisciplineID		    INT,
			@LanguageCode		    CHAR(3)
)
As
Begin
SET NOCOUNT ON 
	
	SELECT DISTINCT 
     RD.F_RegisterID 
     ,*
    ,RD.F_LongName AS Name
    ,F.F_FunctionID
    ,F.F_FunctionCode AS FunctionCode
    ,FD.F_FunctionLongName AS FunctionName
    ,D.F_DelegationCode AS NOC
    ,DD.F_DelegationShortName AS Delegation
    ,S.F_GenderCode AS SexCode
    ,ISNULL(F_FunctionCode,'999')  AS FunctionOrder
    FROM TR_Register AS A
    LEFT JOIN TR_Register_Des AS RD ON A.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
    LEFT JOIN TD_Function AS F ON A.F_FunctionID = F.F_FunctionID
    LEFT JOIN TD_Function_Des AS FD ON A.F_FunctionID = FD.F_FunctionID AND FD.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS R ON R.F_RegisterID = A.F_RegisterID 
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode =@LanguageCode
	LEFT JOIN TC_Sex  AS S ON S.F_SexCode = R.F_SexCode
	LEFT JOIN TC_Sex_Des AS SD ON SD.F_SexCode = R.F_SexCode AND SD.F_LanguageCode = @LanguageCode
	
	WHERE A.F_FunctionID IS NOT NULL AND A.F_RegTypeID =4

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


/*
exec [Proc_Report_AR_GetCompetitionOfficials] 1,'eng'
*/