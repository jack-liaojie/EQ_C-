IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetMatchWeighInOfficial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetMatchWeighInOfficial]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_Report_WL_GetMatchWeighInOfficial]
--描    述：得到Match下已选的裁判信息
--参数说明： 
--创 建 人：崔凯
--日    期：2010年12月23日


CREATE PROCEDURE [dbo].[Proc_Report_WL_GetMatchWeighInOfficial](
			@MatchID		    INT,
			@LanguageCode		NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 

	DECLARE @MainMatchID INT 
	SET @MainMatchID = (SELECT top 1 F_MatchID from TS_Match
		WHERE F_MatchCode ='01' AND F_PhaseID = 
			(SELECT top 1 F_PhaseID FROM TS_Match where F_MatchID =@MatchID)
			 ORDER BY F_MatchID)
			 

	CREATE TABLE #Tmp_Table(
                                F_RegisterID      INT,
                                F_RegisterName    NVARCHAR(100),
                                F_FunctionID      INT,
                                F_Function        NVARCHAR(100),
                                F_FunctionCode    NVARCHAR(20),
                                NOC				  NVARCHAR(20),
                                F_Position		  NVARCHAR(30),
                                F_PositionID	  INT
							)

	INSERT INTO #Tmp_Table 
	(F_RegisterID,F_RegisterName, F_FunctionID,F_Function,NOC,F_FunctionCode,F_Position,F_PositionID)
    SELECT 
    RD.F_RegisterID,RD.F_LongName, FD.F_FunctionID,FD.F_FunctionLongName,R.F_NOC,F.F_FunctionCode
    ,PD.F_PositionLongName,PD.F_PositionID
    FROM TS_Match_Servant AS A
    LEFT JOIN TR_Register_Des AS RD ON A.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
    LEFT JOIN TD_Function AS F ON A.F_FunctionID = F.F_FunctionID
    LEFT JOIN TD_Function_Des AS FD ON A.F_FunctionID = FD.F_FunctionID AND FD.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS R ON R.F_RegisterID = A.F_RegisterID 
	LEFT JOIN TD_Position_Des as PD ON PD.F_PositionID=A.F_PositionID AND PD.F_LanguageCode = @LanguageCode
    WHERE F_MatchID = @MainMatchID AND RD.F_RegisterID IS NOT NULL ORDER BY F_ServantNum

	SELECT F_RegisterName AS LongName, F_Function AS [Function],NOC, F_RegisterID,F_Position,F_PositionID
	FROM #Tmp_Table WHERE F_FunctionCode IN ('RRE','R1','R2','R3','RE','RES') AND F_Position IS NOT NULL
		ORDER BY F_PositionID

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

/*
exec Proc_Report_WL_GetMatchWeighInOfficial 1, 'eng'
*/
