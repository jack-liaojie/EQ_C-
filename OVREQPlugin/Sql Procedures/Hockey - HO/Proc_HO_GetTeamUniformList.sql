IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_GetTeamUniformList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_GetTeamUniformList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_HO_GetTeamUniformList]
--描    述：得到该队可选制服列表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年08月21日


CREATE PROCEDURE [dbo].[Proc_HO_GetTeamUniformList](
												@MatchID		    INT,
                                                @Pos                INT,
                                                @LanguageCode       CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_Uniform       NVARCHAR(100),
                                F_UniformID     INT,
                                F_Shirt         INT
							)

    DECLARE @RegisterID INT
    SELECT @RegisterID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @Pos

    INSERT INTO #Tmp_Table(F_UniformID, F_Shirt, F_Uniform)
    SELECT U.F_UniformID, U.F_Shirt, CD.F_ColorLongName
    FROM TR_Uniform AS U
    LEFT JOIN TC_Color_Des AS CD ON U.F_Shirt = CD.F_ColorID AND CD.F_LanguageCode = @LanguageCode
    WHERE U.F_RegisterID = @RegisterID ORDER BY U.F_Order
	
    SELECT F_UniformID, F_Uniform FROM #Tmp_Table

Set NOCOUNT OFF
End

GO

