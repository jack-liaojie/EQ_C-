IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_TeamOfficial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_TeamOfficial]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_Report_BK_TeamOfficial]
--描    述：得到队伍的官员
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月21日


CREATE PROCEDURE [dbo].[Proc_Report_BK_TeamOfficial](
												@MatchID		    INT,
												@LanguageCode		CHAR(3)
                                                
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	
	DECLARE @DisciplineID  INT
	SELECT @DisciplineID = D.F_DisciplineID  
	     FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID 
	           LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	     WHERE M.F_MatchID = @MatchID
	             
    CREATE TABLE #Tmp_Table(
                                F_TeamID        INT,
                                F_TeamPos       INT,
                                F_RegisterID	INT,
                                F_Code			NVARCHAR(50),
                                F_Name			NVARCHAR(150),
                                F_Title        NVARCHAR(50)
                                )


		INSERT INTO #Tmp_Table (F_RegisterID,F_TeamID, F_TeamPos,F_Name,F_Code,F_Title)
          select distinct F_MemberRegisterID,F_RegisterID,F_CompetitionPosition,F_PrintLongName,F_FunctionCode,F_FunctionLongName 
          FROM 
           ((SELECT A.F_RegisterID, A.F_CompetitionPosition,B.F_MemberRegisterID,D.F_PrintLongName,C.F_FunctionCode,F.F_FunctionLongName
           FROM TS_Match_Result AS A 
           LEFT JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_RegisterID
           LEFT JOIN TD_Function AS C ON B.F_FunctionID = C.F_FunctionID 
           LEFT JOIN TD_Function_Des AS F ON F.F_FunctionID = C.F_FunctionID AND F.F_LanguageCode = @LanguageCode
           LEFT JOIN TR_Register_Des AS D ON B.F_MemberRegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
           WHERE A.F_MatchID = @MatchID AND C.F_FunctionCategoryCode = 'T')
           )AS #temp
          
       UPDATE #Tmp_Table SET F_Title = CASE F_Code WHEN 'AA07'THEN F_Title ELSE CASE @LanguageCode WHEN 'ENG'THEN 'Official'ELSE '官员' END END
	delete from   #Tmp_Table WHERE F_Code <> 'AA07'
	--SELECT * FROM #Tmp_Table ORDER BY CASE F_Code WHEN 'AA07' THEN 0 ELSE 1 END,F_Name
	select TOP 1 * from #Tmp_Table WHERE F_TeamPos = 1
	UNION select TOP 1 * from #Tmp_Table WHERE F_TeamPos = 2
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

