
GO

/****** Object:  StoredProcedure [dbo].[Proc_BD_GetIRMList]    Script Date: 10/15/2010 11:28:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_GetIRMList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_GetIRMList]
GO


GO

/****** Object:  StoredProcedure [dbo].[Proc_BD_GetIRMList]    Script Date: 10/15/2010 11:28:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








--名    称：[Proc_BD_GetIRMList]
--描    述：得到可选IRM列表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年01月07日


CREATE PROCEDURE [dbo].[Proc_BD_GetIRMList](
												@MatchID		    INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_IRMID                 INT,
                                F_IRM                   NVARCHAR(4)
							)

    DECLARE @DisciplineID INT
    SELECT @DisciplineID = C.F_DisciplineID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID WHERE A.F_MatchID = @MatchID

	INSERT INTO #Tmp_Table (F_IRMID, F_IRM)
    SELECT F_IRMID, F_IRMCODE FROM TC_IRM WHERE F_DisciplineID = @DisciplineID

    INSERT INTO #Tmp_Table (F_IRMID, F_IRM)
    VALUES (-1, 'NONE')

	SELECT F_IRM, F_IRMID FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

