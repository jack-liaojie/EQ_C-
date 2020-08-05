IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_WL_GetMatchReferee]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_WL_GetMatchReferee]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_TVG_WL_GetMatchReferee]
--描    述：得到Match下已选的裁判官员信息
--参数说明： 
--创 建 人：崔凯
--日    期：2011年4月20日


CREATE PROCEDURE [dbo].[Proc_TVG_WL_GetMatchReferee](
			@MatchID		    INT
)
As
Begin
SET NOCOUNT ON 
	
	DECLARE @MainMatchID INT 
		SET @MainMatchID = (SELECT top 1 F_MatchID from TS_Match
			WHERE F_MatchCode ='01' AND F_PhaseID = (SELECT top 1 F_PhaseID FROM TS_Match where F_MatchID =@MatchID)
			 ORDER BY F_MatchID)
			 
	CREATE TABLE #Tmp_Table(
                                F_RegisterID			INT,
                                F_RegisterName_ENG		NVARCHAR(100),
                                F_RegisterName_CHN		NVARCHAR(100),
                                F_FunctionID			INT,
                                F_FunctionCode			NVARCHAR(10),
                                F_Function_ENG			NVARCHAR(100),
                                F_Function_CHN			NVARCHAR(100),
                                Flag					NVARCHAR(20),
                                NOC						NVARCHAR(3)
							)

	INSERT INTO #Tmp_Table 
	(F_RegisterID,F_RegisterName_ENG,F_RegisterName_CHN, F_FunctionID,F_FunctionCode,F_Function_ENG,F_Function_CHN,Flag,NOC)
    SELECT 
    RDE.F_RegisterID,RDE.F_TvShortName,RDC.F_TvShortName, F.F_FunctionID,F.F_FunctionCode,FDE.F_FunctionLongName,FDC.F_FunctionLongName,'[image]'+R.F_NOC,R.F_NOC
    FROM TS_Match_Servant AS A
    LEFT JOIN TR_Register_Des AS RDE ON A.F_RegisterID = RDE.F_RegisterID AND RDE.F_LanguageCode = 'ENG'
    LEFT JOIN TR_Register_Des AS RDC ON A.F_RegisterID = RDC.F_RegisterID AND RDC.F_LanguageCode = 'CHN'
    LEFT JOIN TD_Function AS F ON A.F_FunctionID = F.F_FunctionID
    LEFT JOIN TD_Function_Des AS FDE ON A.F_FunctionID = FDE.F_FunctionID AND FDE.F_LanguageCode = 'ENG'
    LEFT JOIN TD_Function_Des AS FDC ON A.F_FunctionID = FDC.F_FunctionID AND FDC.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register AS R ON R.F_RegisterID = A.F_RegisterID 
    WHERE F_MatchID = @MainMatchID AND A.F_RegisterID IS NOT NULL ORDER BY F_ServantNum

	SELECT F_RegisterName_ENG,F_RegisterName_CHN,F_Function_ENG, F_Function_CHN,Flag,NOC,F_RegisterID,F_FunctionID,F_FunctionCode
	FROM #Tmp_Table 
	WHERE F_FunctionCode IN ('RRE','R1','R2','R3','RE','RES') AND F_FunctionCode IS NOT NULL

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


