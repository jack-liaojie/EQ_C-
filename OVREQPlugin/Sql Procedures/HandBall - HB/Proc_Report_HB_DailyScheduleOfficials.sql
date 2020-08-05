

/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_DailyScheduleOfficials]    Script Date: 08/29/2012 15:04:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HB_DailyScheduleOfficials]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HB_DailyScheduleOfficials]
GO



/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_DailyScheduleOfficials]    Script Date: 08/29/2012 15:04:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








----存储过程名称：[Proc_Report_HB_DailyScheduleOfficials]
----功		  能：得到该项目下今日各场Match的官员信息
----作		  者：李燕
----日		  期: 2010-10-28

CREATE PROCEDURE [dbo].[Proc_Report_HB_DailyScheduleOfficials] 
                   (	
					@DisciplineID			INT,
                    @DateID                 INT,
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON
       
         CREATE TABLE #tmp_Function(
                                      F_FunctionCode   NVARCHAR(20),
                                      F_Order          INT
                                      )
         INSERT INTO #tmp_Function(F_FunctionCode, F_Order)
                SELECT 'RE',1 
                UNION SELECT  'R1', 2
                UNION SELECT  'R2', 3
                UNION SELECT  'O4', 4
               -- UNION SELECT  'CM', 5
                --UNION SELECT  'CD', 7
               -- UNION SELECT  'RS', 6
          
          CREATE TABLE #tmp_Player(
                                    F_MatchID       INT,
                                    F_RegisterID    INT,
                                    F_Name          NVARCHAR(100),
                                    F_NOC           NVARCHAR(10),
                                    F_Function      NVARCHAR(100),
                                    F_FOrder        INT,
                                    F_Order         INT,
                                    F_FunctionCode  NVARCHAR(50)
                                    )
                                    
          
      INSERT #tmp_Player (F_MatchID, F_RegisterID, F_Name, F_NOC, F_Function,  F_Order, F_FunctionCode)                      
        SELECT A.F_MatchID, A.F_RegisterID, E.F_PrintLongName AS [F_Name], F.F_NOC, G.F_FunctionLongName AS [F_Function],  A.F_Order, K.F_FunctionCode
			FROM TS_Match_Servant AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID
			LEFT JOIN TS_DisciplineDate AS C ON B.F_MatchDate = C.F_Date
			LEFT JOIN TR_Register AS D ON A.F_RegisterID = D.F_RegisterID
			LEFT JOIN TR_Register_Des AS E ON D.F_RegisterID = E.F_RegisterID AND E.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Country AS F ON D.F_NOC = F.F_NOC
			LEFT JOIN TD_Function_Des AS G ON A.F_FunctionID = G.F_FunctionID AND G.F_LanguageCode = @LanguageCode
			LEFT JOIN TD_Function AS K ON A.F_FunctionID = K.F_FunctionID
		WHERE C.F_DisciplineID = @DisciplineID AND C.F_DisciplineDateID = @DateID 
	UPDATE #tmp_Player SET F_FOrder = B.F_Order FROM #tmp_Player AS A INNER JOIN #tmp_Function AS B ON A.F_FunctionCode = B.F_FunctionCode
	UPDATE #tmp_Player SET F_Name = F_Name + (CASE WHEN F_NOC IS NULL THEN '' ELSE ' ( ' + F_NOC + ')'END)
	--delete from #tmp_Player where F_Function='Match Commissioner'or F_Function='General Coordinator'
	
	SELECT * FROM #tmp_Player WHERE  F_FOrder IS NOT NULL ORDER BY F_MatchID,F_FOrder, F_Order,F_Name 
        
SET NOCOUNT OFF
END


GO


