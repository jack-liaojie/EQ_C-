IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_GetFunction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_GetFunction]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_HO_GetFunction]
--描    述：得到可选职责列表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年08月20日


CREATE PROCEDURE [dbo].[Proc_HO_GetFunction](
												@MatchID		    INT,
                                                @FunctionType       CHAR(1),
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_FunctionID      INT,
                                F_Function        NVARCHAR(100)
							)

    DECLARE @DisciplineID INT
    SELECT @DisciplineID = C.F_DisciplineID
    FROM TS_Match AS A
    LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
    LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
    WHERE A.F_MatchID = @MatchID

    PRINT @DisciplineID
	INSERT INTO #Tmp_Table (F_FunctionID, F_Function)
    SELECT A.F_FunctionID, B.F_FunctionLongName
    FROM TD_Function AS A
    LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode
    WHERE A.F_DisciplineID = @DisciplineID AND A.F_FunctionCategoryCode = @FunctionType

    INSERT INTO #Tmp_Table(F_FunctionID, F_Function)
    VALUES(-1, 'NONE')

	SELECT F_Function AS [Function], F_FunctionID FROM #Tmp_Table

Set NOCOUNT OFF
End

GO


