IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetTeamPlayers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetTeamPlayers]
GO


GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--名    称：[Proc_TE_GetTeamPlayers]
--描    述：得到Match下得队的可选运动员列表
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2011年07月04日


CREATE PROCEDURE [dbo].[Proc_TE_GetTeamPlayers](
												@MatchID		    INT,
                                                @Position           INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_RegisterID      INT,
                                F_RegisterName    NVARCHAR(100),
                                F_SexCode INT
							)

    DECLARE @TeamID INT
    SELECT @TeamID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @Position

	INSERT INTO #Tmp_Table (F_RegisterID)
    SELECT F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @TeamID

    UPDATE #Tmp_Table SET F_RegisterName = B.F_LongName
    FROM #Tmp_Table AS A 
    LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Register AS C ON C.F_RegisterID = B.F_RegisterID
     WHERE C.F_RegTypeID = 1

	SELECT F_RegisterName AS Name, F_RegisterID AS RegisterID FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

