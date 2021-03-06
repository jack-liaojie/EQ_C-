IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_GetTeamPlayers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_GetTeamPlayers]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_HO_GetTeamPlayers]
--描    述：得到Match下可选的队员信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年08月21日


CREATE PROCEDURE [dbo].[Proc_HO_GetTeamPlayers](
												@MatchID		    INT,
                                                @Pos                INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_RegisterID      INT,
                                F_RegisterName    NVARCHAR(100),
                                F_FunctionID      INT,
                                F_PositionID      INT,
                                F_Function        NVARCHAR(100),
                                F_Position        NVARCHAR(100),
                                F_Bib             INT
							)

    DECLARE @TeamID INT
    SELECT @TeamID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @Pos

    INSERT INTO #Tmp_Table(F_RegisterID, F_FunctionID, F_PositionID, F_Bib, F_Function, F_Position, F_RegisterName)
    SELECT RM.F_MemberRegisterID, RM.F_FunctionID, RM.F_PositionID, RM.F_ShirtNumber, FD.F_FunctionLongName, PD.F_PositionLongName, RD.F_LongName
    FROM TR_Register_Member AS RM
    LEFT JOIN TR_Register AS R ON RM.F_MemberRegisterID = R.F_RegisterID
    LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
    LEFT JOIN TD_Function AS F ON RM.F_FunctionID = F.F_FunctionID
    LEFT JOIN TD_Function_Des AS FD ON F.F_FunctionID = FD.F_FunctionID AND FD.F_LanguageCode = @LanguageCode
    LEFT JOIN TD_Position AS P ON RM.F_PositionID = P.F_PositionID
    LEFT JOIN TD_Position_Des AS PD ON P.F_PositionID = PD.F_PositionID AND PD.F_LanguageCode = @LanguageCode
    WHERE RM.F_RegisterID = @TeamID AND RM.F_MemberRegisterID NOT IN (SELECT F_RegisterID FROM TS_Match_Member WHERE F_MatchID = @MatchID)
    AND R.F_RegTypeID = 1

    SELECT F_RegisterID, F_Bib AS Bib, F_RegisterName AS LongName, F_Function AS [Function], F_FunctionID, F_Position AS [Position], F_PositionID FROM #Tmp_Table ORDER BY F_Bib

Set NOCOUNT OFF
End

GO





