IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_GetMatchPlayers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_GetMatchPlayers]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_HO_GetMatchPlayers]
--描    述：得到Match下已选的队员信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年08月21日


CREATE PROCEDURE [dbo].[Proc_HO_GetMatchPlayers](
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
                                F_Function        NVARCHAR(100),
                                F_PositionID      INT,
                                F_Position        NVARCHAR(100),
                                F_Bib             INT,
                                F_StartUp         NVARCHAR(10),
                                F_Order           INT
							)

    DECLARE @CompetitionPosition INT
    SELECT @CompetitionPosition = F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @Pos

    INSERT INTO #Tmp_Table(F_RegisterID, F_FunctionID, F_PositionID, F_Bib, F_StartUp, F_RegisterName, F_Function, F_Position, F_Order)
    SELECT MM.F_RegisterID, MM.F_FunctionID, MM.F_PositionID, MM.F_ShirtNumber
    , (CASE MM.F_StartUp WHEN 1 THEN 'StartUp' ELSE '' END)
    , RD.F_LongName, FD.F_FunctionLongName, PD.F_PositionLongName, MM.F_Order
    FROM TS_Match_Member AS MM
    LEFT JOIN TR_Register AS R ON MM.F_RegisterID = R.F_RegisterID
    LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
    LEFT JOIN TD_Function AS F ON MM.F_FunctionID = F.F_FunctionID
    LEFT JOIN TD_Function_Des AS FD ON F.F_FunctionID = FD.F_FunctionID AND FD.F_LanguageCode = @LanguageCode
    LEFT JOIN TD_Position AS P ON MM.F_PositionID = P.F_PositionID
    LEFT JOIN TD_Position_Des AS PD ON P.F_PositionID = PD.F_PositionID AND PD.F_LanguageCode = @LanguageCode
    WHERE MM.F_MatchID = @MatchID AND MM.F_CompetitionPosition = @CompetitionPosition ORDER BY (CASE WHEN MM.F_StartUp IS NULL THEN 1 ELSE 0 END), MM.F_StartUp, MM.F_ShirtNumber

    SELECT F_RegisterID, F_Bib AS Bib, F_RegisterName AS LongName, F_Function AS [Function], F_StartUp AS [StartUp], F_Position AS [Position] FROM #Tmp_Table

Set NOCOUNT OFF
End	

GO


