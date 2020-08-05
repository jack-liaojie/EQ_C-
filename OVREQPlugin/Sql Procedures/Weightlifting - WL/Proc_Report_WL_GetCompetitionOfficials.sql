IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetCompetitionOfficials]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetCompetitionOfficials]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_Report_WL_GetCompetitionOfficials]
--描    述：裁判官员信息分组信息
--参数说明： 
--创 建 人：崔凯
--日    期：2011年6月1日


CREATE PROCEDURE [dbo].[Proc_Report_WL_GetCompetitionOfficials](
			@DisciplineID		    INT,
			@LanguageCode		    CHAR(3)
)
As
Begin
SET NOCOUNT ON 
	
	SELECT DISTINCT
     RD.F_RegisterID 
    ,CASE WHEN F.F_FunctionCode='POJ' THEN  '(President) ' + RD.F_LongName
		ELSE RD.F_LongName END AS Name
    ,F.F_FunctionID
    ,F.F_FunctionCode AS FunctionCode
    ,CASE WHEN F.F_FunctionCode='POJ' THEN 'Jury' ELSE FD.F_FunctionLongName END AS FunctionName
    ,D.F_DelegationCode AS NOC
    ,GD.F_GroupLongName AS GroupName
    ,GD.F_GroupShortName AS GroupNum
    ,CASE WHEN F_FunctionCode ='IF11' THEN 0 
				  WHEN F_FunctionCode IN ('POJ','IF16') THEN 1
				  WHEN F_FunctionCode IN ('R1','R2','R3','RE','RES','RRE') THEN 2 
				  --WHEN F_FunctionCode = 'RRE' THEN 3 
				  WHEN F_FunctionCode  IN ('DOD','AA10') THEN 4 
				  WHEN F_FunctionCode ='TKP' THEN 5 
				  WHEN F_FunctionCode ='TC'  THEN 6 
				  WHEN F_FunctionCode ='CMS' THEN 7 
				  WHEN F_FunctionCode ='CPS' THEN 8 
				  ELSE 9 END AS FunctionOrder			  
    FROM TS_Group_Official AS GG
	LEFT JOIN TS_Match_Servant AS A ON GG.F_RegisterID = A.F_RegisterID
    LEFT JOIN TR_Register_Des AS RD ON GG.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
    LEFT JOIN TD_Function AS F ON GG.F_FunctionID = F.F_FunctionID
    LEFT JOIN TD_Function_Des AS FD ON GG.F_FunctionID = FD.F_FunctionID AND FD.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS R ON R.F_RegisterID = GG.F_RegisterID 
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TD_OfficialGroup_Des AS GD ON GD.F_OfficialGroupID = GG.F_OfficialGroupID


Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


