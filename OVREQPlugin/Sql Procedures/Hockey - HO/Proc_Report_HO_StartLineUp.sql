IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HO_StartLineUp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HO_StartLineUp]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_Report_HO_StartLineUp]
--描    述：得到该场Match的出场队员信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年08月31日


CREATE PROCEDURE [dbo].[Proc_Report_HO_StartLineUp](
												@MatchID		    INT,
                                                @Pos                INT,
												@LanguageCode		CHAR(3)
                                                
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH

	CREATE TABLE #Tmp_Table(
                                F_RegisterID        INT,
                                F_NOC               NVARCHAR(10),
                                F_NOCDes            NVARCHAR(100),
                                F_Bib               INT,
                                F_FunctionID        INT,
                                F_PositionID        INT,
                                F_UniformID         INT,
                                F_StartUp           NVARCHAR(1),
                                F_PrintLN           NVARCHAR(100),
                                F_PrintSN           NVARCHAR(50),
                                F_NameCode          NVARCHAR(100),
                                F_Height            INT,
                                F_Weight            INT,
                                F_Birth_Date        NVARCHAR(11),
                                F_HeightDes         NVARCHAR(100),
                                F_WeightDes         NVARCHAR(100),
                                F_FunctionCode      NVARCHAR(100),
                                F_PositionCode      NVARCHAR(100),
                                F_Function          NVARCHAR(100),
                                F_Position          NVARCHAR(100),
                                F_Shirt             NVARCHAR(100),
                                F_Short             NVARCHAR(100),
                                F_Sock              NVARCHAR(100),
                                F_Manager           NVARCHAR(150),
                                F_SManager          NVARCHAR(150),
                                F_COACH            NVARCHAR(150),
                                F_Physiotherapist  NVARCHAR(150),
                                F_Green            INT,
                                F_Yellow           INT,
                                F_Red              INT                             
							)
							
	CREATE TABLE #TableGCard(
	                            F_RegisterID     INT,
	                            F_GCard          INT
	                            )
	                            
	CREATE TABLE #TableYCard(
	                            F_RegisterID     INT,
	                            F_YCard          INT
	                            )
	                            
	CREATE TABLE #TableRCard(
	                            F_RegisterID     INT,
	                            F_RCard          INT
	                            )
	                            

    DECLARE @MatchType INT
    SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID

    INSERT INTO #Tmp_Table (F_RegisterID, F_PrintLN, F_NameCode, F_PrintSN, F_NOC, F_NOCDes, F_Bib, F_Height, F_Weight, F_Birth_Date, F_FunctionID, F_PositionID, F_UniformID, F_StartUp)
    SELECT A.F_RegisterID, D.F_PrintLongName, D.F_PrintLongName, D.F_PrintShortName, E.F_DelegationCode
    , F.F_DelegationLongName, A.F_ShirtNumber, C.F_Height, C.F_Weight
    , LEFT(CONVERT(NVARCHAR(30), C.F_Birth_Date, 20), 10)
    , A.F_FunctionID, A.F_PositionID, B.F_UniformID
    , (CASE WHEN F_StartUp = 1 THEN 'X' ELSE '' END)
    FROM TS_Match_Member AS A LEFT JOIN TS_Match_Result AS B
    ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition
    LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID
    LEFT JOIN TR_Register_Des AS D ON C.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
    LEFT JOIN TC_Delegation AS E ON C.F_DelegationID = E.F_DelegationID
    LEFT JOIN TC_Delegation_Des AS F ON E.F_DelegationID = F.F_DelegationID AND F.F_LanguageCode = @LanguageCode
    WHERE A.F_MatchID = @MatchID AND B.F_CompetitionPositionDes1 = @Pos
    ORDER BY (CASE WHEN A.F_StartUp IS NULL THEN 2 ELSE 1 END), A.F_ShirtNumber

    UPDATE #Tmp_Table SET F_HeightDes = LEFT(F_Height / 100.0, 4) + ' / ' + CONVERT(NVARCHAR(2), F_Height * 100 / 3048) + '''' + CONVERT(NVARCHAR(2), (F_Height * 100 / 254) % 12) + '"'

    UPDATE #Tmp_Table SET F_WeightDes = CONVERT(NVARCHAR(3), F_Weight) + ' / ' + CONVERT(NVARCHAR(5), F_Weight * 22 / 10)

    UPDATE #Tmp_Table SET F_FunctionCode = B.F_FunctionCode FROM #Tmp_Table AS A LEFT JOIN TD_Function AS B ON A.F_FunctionID = B.F_FunctionID

    UPDATE #Tmp_Table SET F_PositionCode = B.F_PositionCode FROM #Tmp_Table AS A LEFT JOIN TD_Position AS B ON A.F_PositionID = B.F_PositionID WHERE B.F_PositionCode = 'GK'
    
    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode

    UPDATE #Tmp_Table SET F_Position = B.F_PositionLongName FROM #Tmp_Table AS A LEFT JOIN TD_Position_Des AS B ON A.F_PositionID = B.F_PositionID AND B.F_LanguageCode = @LanguageCode
    
    UPDATE #Tmp_Table SET F_Shirt = C.F_ColorLongName FROM #Tmp_Table AS A LEFT JOIN TR_Uniform AS B ON A.F_UniformID = B.F_UniformID
    LEFT JOIN TC_Color_Des AS C ON B.F_Shirt = C.F_ColorID AND C.F_LanguageCode = @LanguageCode
    
    UPDATE #Tmp_Table SET F_Short = C.F_ColorLongName FROM #Tmp_Table AS A LEFT JOIN TR_Uniform AS B ON A.F_UniformID = B.F_UniformID
    LEFT JOIN TC_Color_Des AS C ON B.F_Shorts = C.F_ColorID AND C.F_LanguageCode = @LanguageCode
    
    UPDATE #Tmp_Table SET F_Sock = C.F_ColorLongName FROM #Tmp_Table AS A LEFT JOIN TR_Uniform AS B ON A.F_UniformID = B.F_UniformID
    LEFT JOIN TC_Color_Des AS C ON B.F_Socks = C.F_ColorID AND C.F_LanguageCode = @LanguageCode

    UPDATE #Tmp_Table SET F_Manager = C.F_PrintLongName 
    FROM TS_Match_Result AS A 
    LEFT JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_RegisterID
    LEFT JOIN TR_Register_Des AS C ON B.F_MemberRegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
    LEFT JOIN TD_Function AS D ON B.F_FunctionID = D.F_FunctionID
    WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @Pos AND D.F_FunctionCode = 'MANAGER'

    UPDATE #Tmp_Table SET F_SManager = C.F_PrintLongName 
    FROM TS_Match_Result AS A 
    LEFT JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_RegisterID
    LEFT JOIN TR_Register_Des AS C ON B.F_MemberRegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
    LEFT JOIN TD_Function AS D ON B.F_FunctionID = D.F_FunctionID
    WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @Pos AND D.F_FunctionCode = 'SMANAGER'

    UPDATE #Tmp_Table SET F_COACH = C.F_PrintLongName 
    FROM TS_Match_Result AS A 
    LEFT JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_RegisterID
    LEFT JOIN TR_Register_Des AS C ON B.F_MemberRegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
    LEFT JOIN TD_Function AS D ON B.F_FunctionID = D.F_FunctionID
    WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @Pos AND D.F_FunctionCode = 'COACH'

    UPDATE #Tmp_Table SET F_Physiotherapist = C.F_PrintLongName 
    FROM TS_Match_Result AS A 
    LEFT JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_RegisterID
    LEFT JOIN TR_Register_Des AS C ON B.F_MemberRegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
    LEFT JOIN TD_Function AS D ON B.F_FunctionID = D.F_FunctionID
    WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @Pos AND D.F_FunctionCode = 'PHYSIOTHER'

    INSERT INTO #TableGCard(F_RegisterID, F_GCard)
    SELECT MA.F_RegisterID, COUNT(F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'GCard'
    GROUP BY MA.F_RegisterID
    
    INSERT INTO #TableYCard(F_RegisterID, F_YCard)
    SELECT MA.F_RegisterID, COUNT(F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'YCard'
    GROUP BY MA.F_RegisterID
    
    INSERT INTO #TableRCard(F_RegisterID, F_RCard)
    SELECT MA.F_RegisterID, COUNT(F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'RCard'
    GROUP BY MA.F_RegisterID
    
    UPDATE A SET A.F_Green = B.F_GCard FROM #Tmp_Table AS A LEFT JOIN #TableGCard AS B ON A.F_RegisterID = B.F_RegisterID
    UPDATE A SET A.F_Yellow = B.F_YCard FROM #Tmp_Table AS A LEFT JOIN #TableYCard AS B ON A.F_RegisterID = B.F_RegisterID
    UPDATE A SET A.F_Red = B.F_RCard FROM #Tmp_Table AS A LEFT JOIN #TableRCard AS B ON A.F_RegisterID = B.F_RegisterID
    UPDATE #Tmp_Table SET F_NameCode = F_NameCode + '(' + F_PositionCode + ')' WHERE F_PositionCode IS NOT NULL
    UPDATE #Tmp_Table SET F_NameCode = F_NameCode + '(' + F_FunctionCode + ')' WHERE F_FunctionCode IS NOT NULL
	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

GO

/*EXEC Proc_Report_HO_StartLineUp 18,1,'CHN'*/


