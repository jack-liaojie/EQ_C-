IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_Interface_GetRegisterList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_Interface_GetRegisterList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称: [Proc_AR_Interface_GetRegisterList]
--描    述: 
--参数说明: 
--说    明: 射箭的运动员信息通过接口下发
--创 建 人: 崔凯	
--日    期: 2012年7月18日
--修改记录：
/*			

*/



CREATE PROCEDURE [dbo].[Proc_AR_Interface_GetRegisterList]
	@DisciplineCode				NVARCHAR(10),
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	
	SELECT R.F_RegisterID 
		, RD.F_LongName 
		, DD.F_DelegationLongName
		, SD.F_SexLongName 
		, R.F_RegisterCode

	FROM TR_Register AS R
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Sex_Des AS SD
		ON R.F_SexCode = SD.F_SexCode AND SD.F_LanguageCode = @LanguageCode
	LEFT JOIN TD_Function_Des AS FD
		ON R.F_FunctionID = FD.F_FunctionID AND FD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Country_Des AS CD
		ON R.F_NOC = CD.F_NOC AND CD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD
		ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Discipline AS DIS
		ON R.F_DisciplineID = DIS.F_DisciplineID 
	WHERE R.F_RegTypeID IN (1, 3)
		AND DIS.F_DisciplineCode = @DisciplineCode

SET NOCOUNT OFF
END


GO
/*
exec Proc_AR_Interface_GetRegisterList 'AR','CHN'
*/
