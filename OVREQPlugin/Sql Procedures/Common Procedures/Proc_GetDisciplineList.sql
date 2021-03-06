/****** Object:  StoredProcedure [dbo].[Proc_GetDisciplineList]    Script Date: 11/09/2009 17:07:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDisciplineList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetDisciplineList]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetDisciplineList]    Script Date: 11/09/2009 15:13:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GetDisciplineList]
--描    述：得到Discipline列表
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2009年11月29日

CREATE PROCEDURE [dbo].[Proc_GetDisciplineList](
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	
	CREATE TABLE #Tmp_Table(
								F_Name			NVARCHAR(100),
								F_Key			INT
							)

	INSERT INTO #Tmp_Table (F_Name, F_Key) 
		SELECT B.F_DisciplineLongName, A.F_DisciplineID
		FROM TS_Discipline AS A LEFT JOIN 
           TS_Discipline_Des AS B
			ON A.F_DisciplineID = B.F_DisciplineID WHERE B.F_LanguageCode = @LanguageCode

	SELECT F_Name, F_Key FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


