IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetMatchOfficial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetMatchOfficial]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_Report_WL_GetMatchOfficial]
--描    述：得到Match下已选的裁判信息
--参数说明： 
--创 建 人：崔凯
--日    期：2010年12月23日


CREATE PROCEDURE [dbo].[Proc_Report_WL_GetMatchOfficial](
			@MatchID		    INT,
			@LanguageCode		NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 
	
	DECLARE @MainMatchID INT 
		SET @MainMatchID = (SELECT top 1 F_MatchID from TS_Match
			WHERE F_MatchCode ='01' AND F_PhaseID = (SELECT top 1 F_PhaseID FROM TS_Match where F_MatchID =@MatchID)
			 ORDER BY F_MatchID)
			 
	CREATE TABLE #Tmp_Table(
                                F_RegisterID      INT,
                                F_RegisterName    NVARCHAR(100),
                                F_FunctionID      INT,
                                F_Function        NVARCHAR(100),
                                NOC NVARCHAR(3),
                                FunctionOrder INT
							)

	INSERT INTO #Tmp_Table 
	(F_RegisterID,F_RegisterName, F_FunctionID,F_Function,NOC,FunctionOrder)
    SELECT 
    RD.F_RegisterID,RD.F_PrintLongName, FD.F_FunctionID,
    CASE WHEN F.F_FunctionCode IN ('R1','R2','R3','RE','RES') THEN PD.F_PositionLongName 
		 ELSE FD.F_FunctionLongName END
    ,R.F_NOC
    ,CASE WHEN F_FunctionCode ='IF11' THEN 0 
				  WHEN F_FunctionCode ='POJ' THEN 1
				  WHEN F_FunctionCode ='IF16' THEN 2
				  WHEN F_FunctionCode IN ('R1','R2','R3','RE','RES') AND P.F_PositionCode ='MTR' THEN 3 
				  WHEN F_FunctionCode IN ('R1','R2','R3','RE','RES') AND P.F_PositionCode ='LTR' THEN 4
				  WHEN F_FunctionCode IN ('R1','R2','R3','RE','RES') AND P.F_PositionCode ='RTR' THEN 5
				  WHEN F_FunctionCode IN ('R1','R2','R3','RE','RES') AND P.F_PositionCode ='STR' THEN 6
				  WHEN F_FunctionCode = 'RRE' THEN 7 
				  WHEN F_FunctionCode  IN ('DOD','AA10') THEN 8 
				  WHEN F_FunctionCode ='TKP' THEN 9 
				  WHEN F_FunctionCode ='TC'  THEN 91 
				  WHEN F_FunctionCode ='CMS' THEN 92 
				  WHEN F_FunctionCode ='CPS' THEN 93 
				  ELSE 99 END AS FunctionOrder
    FROM TS_Match_Servant AS A
    LEFT JOIN TR_Register_Des AS RD ON A.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
    LEFT JOIN TD_Function AS F ON A.F_FunctionID = F.F_FunctionID
    LEFT JOIN TD_Function_Des AS FD ON A.F_FunctionID = FD.F_FunctionID AND FD.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS R ON R.F_RegisterID = A.F_RegisterID
	LEFT JOIN TD_Position  AS P ON A.F_PositionID = P.F_PositionID
    LEFT JOIN TD_Position_Des AS PD ON A.F_PositionID = PD.F_PositionID AND PD.F_LanguageCode = @LanguageCode 
    WHERE F_MatchID = @MainMatchID AND RD.F_RegisterID IS NOT NULL ORDER BY F_ServantNum

	SELECT F_RegisterName AS LongName, F_Function AS [Function],NOC, F_RegisterID,FunctionOrder
	FROM #Tmp_Table  order by FunctionOrder

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


