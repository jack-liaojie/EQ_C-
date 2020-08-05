IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_StartList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_StartList]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--名    称：[Proc_Report_BK_StartList]
--描    述：得到该场Match的出场队员信息
--参数说明： 
--说    明：
--创 建 人：吴定昉
--日    期：2010年03月21日
--修改记录： 
/*			
			时间				修改人		修改内容	
			2012年9月20日       吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/


CREATE PROCEDURE [dbo].[Proc_Report_BK_StartList](
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
                                F_RegisterID    INT,
                                F_NOC           NVARCHAR(10),
                                F_NOCDes        NVARCHAR(100),
                                F_Bib           INT,
                                F_NvStlBib      NVARCHAR(10),
                                F_FunctionID    INT,
                                F_PositionID    INT,
                                F_UniformID     INT,
                                F_PrintLN       NVARCHAR(100),
                                F_PrintSN       NVARCHAR(50),
                                F_Function      NVARCHAR(100),
                                F_Position      NVARCHAR(30),
                                F_PositionName  NVARCHAR(100),
                                F_Uniform       NVARCHAR(100),
                                F_TeamLeander   NVARCHAR(100),
                                F_HCoach        NVARCHAR(150),
                                F_ACoach        NVARCHAR(150),
                                F_Height        INT,
                                F_HeightDes     NVARCHAR(20),
                                F_DateBirth     INT,
                                F_HomeNOC       NVARCHAR(10),
                                F_VisitNOC      NVARCHAR(10),
                                )


		INSERT INTO #Tmp_Table (F_TeamID, F_TeamPos, F_RegisterID, F_PrintLN, F_PrintSN, F_NOC, F_NOCDes, F_NvStlBib, F_Bib, F_FunctionID, F_PositionID, F_UniformID, F_Height, F_DateBirth)
           SELECT B.F_RegisterID, A.F_CompetitionPosition, A.F_RegisterID, CASE G.F_FunctionCode WHEN 'C'THEN D.F_PrintLongName+' (C)'ELSE D.F_PrintLongName END,CASE G.F_FunctionCode WHEN 'C'THEN D.F_PrintShortName+' (C)'ELSE D.F_PrintShortName END, E.F_DelegationCode, F.F_DelegationLongName
                  ,case when A.F_StartUp = 1 then '*' else null end,A.F_ShirtNumber,  A.F_FunctionID, A.F_PositionID, B.F_UniformID, C.F_Height, YEAR(C.F_Birth_Date)
           FROM TS_Match_Result AS B LEFT JOIN TS_Match_Member AS A 
				ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition
				LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID
				LEFT JOIN TR_Register_Des AS D ON C.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
				LEFT JOIN TC_Delegation AS E ON C.F_DelegationID = E.F_DelegationID
				LEFT JOIN TC_Delegation_Des AS F ON E.F_DelegationID = F.F_DelegationID AND F.F_LanguageCode = @LanguageCode
				LEFT JOIN TD_Function AS G ON A.F_FunctionID = G.F_FunctionID
            WHERE A.F_MatchID = @MatchID 
       
        UPDATE #Tmp_Table SET F_HomeNOC = C.F_DelegationCode 
             FROM TS_Match_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
                   LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
                 WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 1
                 
        UPDATE #Tmp_Table SET F_VisitNOC = C.F_DelegationCode 
             FROM TS_Match_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
                   LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
                 WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 2
          
        UPDATE #Tmp_Table SET F_TeamLeander = D.F_PrintLongName  
                FROM #Tmp_Table AS A LEFT JOIN TR_Register_Member AS B ON A.F_TeamID = B.F_RegisterID 
                      LEFT JOIN TD_Function AS C ON B.F_FunctionID = C.F_FunctionID 
                      LEFT JOIN TR_Register_Des AS D ON B.F_MemberRegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
                   WHERE C.F_FunctionCode = 'AA05'
           
         UPDATE #Tmp_Table SET F_HCoach = D.F_PrintLongName  
                FROM #Tmp_Table AS A LEFT JOIN TR_Register_Member AS B ON A.F_TeamID = B.F_RegisterID 
                      LEFT JOIN TD_Function AS C ON B.F_FunctionID = C.F_FunctionID 
                      LEFT JOIN TR_Register_Des AS D ON B.F_MemberRegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
                   WHERE C.F_FunctionCode = 'AA07'
                   
        UPDATE #Tmp_Table SET F_ACoach = D.F_PrintLongName  
                FROM #Tmp_Table AS A LEFT JOIN TR_Register_Member AS B ON A.F_TeamID = B.F_RegisterID 
                      LEFT JOIN TD_Function AS C ON B.F_FunctionID = C.F_FunctionID 
                      LEFT JOIN TR_Register_Des AS D ON B.F_MemberRegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
                   WHERE C.F_FunctionCode = 'AA22'
   
    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName 
            FROM #Tmp_Table AS A LEFT JOIN  TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode
                  
    UPDATE #Tmp_Table SET F_Position = B.F_PositionCode FROM  #Tmp_Table AS A LEFT JOIN TD_Position AS B ON A.F_PositionID = B.F_PositionID
    UPDATE #Tmp_Table SET F_PositionName = PD.F_PositionShortName 
    FROM  #Tmp_Table AS T LEFT JOIN TD_Position_Des AS PD ON T.F_PositionID = PD.F_PositionID AND PD.F_LanguageCode = @LanguageCode
         
    UPDATE #Tmp_Table SET F_Uniform = C.F_ColorLongName FROM #Tmp_Table AS A LEFT JOIN TR_Uniform AS B ON A.F_UniformID = B.F_UniformID
                        LEFT JOIN TC_Color_Des AS C ON B.F_Shirt = C.F_ColorID AND C.F_LanguageCode = @LanguageCode
                        
    DECLARE @MatchDate AS DateTime
	
	SELECT @MatchDate = F_MatchDate  FROM TS_Match WHERE F_MatchID = @MatchID
	            
    UPDATE #Tmp_Table SET F_HeightDes = LEFT(F_Height / 100.0, 4)-- + ' / ' + CONVERT(NVARCHAR(2), F_Height * 100 / 3048) + '''' + CONVERT(NVARCHAR(2), (F_Height * 100 / 254) % 12) + '"'
    --UPDATE #Tmp_Table SET F_WeightDes = CONVERT(NVARCHAR(3), F_Weight) + ' / ' + CONVERT(NVARCHAR(5), F_Weight * 22 / 10)
    UPDATE #Tmp_Table SET F_NvStlBib = F_NvStlBib + CAST(F_Bib as NVARCHAR(10)) WHERE F_NvStlBib IS NOT NULL
    UPDATE #Tmp_Table SET F_NvStlBib = CAST(F_Bib as NVARCHAR(10)) WHERE F_NvStlBib IS NULL
               
	SELECT * FROM #Tmp_Table ORDER BY  F_Bib

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO
