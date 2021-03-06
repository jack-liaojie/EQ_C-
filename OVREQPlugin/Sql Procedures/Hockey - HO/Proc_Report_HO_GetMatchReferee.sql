IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HO_GetMatchReferee]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HO_GetMatchReferee]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_Report_HO_GetMatchReferee]
--描    述：得到Match下已选的裁判信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年08月20日


CREATE PROCEDURE [dbo].[Proc_Report_HO_GetMatchReferee](
												@MatchID		    INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
	                            F_MatchID         INT,
                                F_Judge1          NVARCHAR(100),
                                F_Judge2          NVARCHAR(100),
                                F_Umpire1         NVARCHAR(100),
                                F_Umpire2         NVARCHAR(100),
                                F_Technical       NVARCHAR(100),
                                F_SUmpire         NVARCHAR(100),
							)
							
	CREATE TABLE #Tmp_Judge(
	                             F_RegisterID   INT, 
	                             F_Order        INT,
	                         )
	                         
	 CREATE TABLE #Tmp_Umpire(
	                             F_RegisterID   INT, 
	                             F_Order        INT,
	                         )
	                         
	CREATE TABLE #Tmp_Technical(
	                             F_RegisterID   INT, 
	                             F_Order        INT,
	                         )
	                         
	 CREATE TABLE #Tmp_SUmpire(
	                             F_RegisterID   INT, 
	                             F_Order        INT,
	                         )

    INSERT INTO #Tmp_Table (F_MatchID)
	VALUES(@MatchID)
	
	INSERT INTO #Tmp_Judge(F_RegisterID, F_Order)
	SELECT MS.F_RegisterID, RANK() OVER(ORDER BY MS.F_Order DESC) AS F_Order
	FROM TS_Match_Servant AS MS LEFT JOIN TD_Function AS F ON MS.F_FunctionID = F.F_FunctionID
	WHERE MS.F_MatchID = @MatchID AND F.F_FunctionCode = 'JU'
	
	INSERT INTO #Tmp_Umpire(F_RegisterID, F_Order)
	SELECT MS.F_RegisterID, RANK() OVER(ORDER BY MS.F_Order DESC) AS F_Order
	FROM TS_Match_Servant AS MS LEFT JOIN TD_Function AS F ON MS.F_FunctionID = F.F_FunctionID
	WHERE MS.F_MatchID = @MatchID AND F.F_FunctionCode = 'UM'
	
	INSERT INTO #Tmp_Technical(F_RegisterID, F_Order)
	SELECT MS.F_RegisterID, RANK() OVER(ORDER BY MS.F_Order DESC) AS F_Order
	FROM TS_Match_Servant AS MS LEFT JOIN TD_Function AS F ON MS.F_FunctionID = F.F_FunctionID
	WHERE MS.F_MatchID = @MatchID AND F.F_FunctionCode = 'TO'
	
	INSERT INTO #Tmp_SUmpire(F_RegisterID, F_Order)
	SELECT MS.F_RegisterID, RANK() OVER(ORDER BY MS.F_Order DESC) AS F_Order
	FROM TS_Match_Servant AS MS LEFT JOIN TD_Function AS F ON MS.F_FunctionID = F.F_FunctionID
	WHERE MS.F_MatchID = @MatchID AND F.F_FunctionCode = 'AU'
	
	UPDATE #Tmp_Table SET F_Judge1 = B.F_PrintLongName FROM #Tmp_Judge AS A
	LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID WHERE A.F_Order = 1
	
	UPDATE #Tmp_Table SET F_Judge2 = B.F_PrintLongName FROM #Tmp_Judge AS A
	LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID WHERE A.F_Order = 2
	
	UPDATE #Tmp_Table SET F_Umpire1 = B.F_PrintLongName FROM #Tmp_Umpire AS A
	LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID WHERE A.F_Order = 1
	
	UPDATE #Tmp_Table SET F_Umpire2 = B.F_PrintLongName  FROM #Tmp_Umpire AS A
	LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID WHERE A.F_Order = 2
	
	UPDATE #Tmp_Table SET F_Technical = B.F_PrintLongName FROM #Tmp_Technical AS A
	LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID WHERE A.F_Order = 1
	
	UPDATE #Tmp_Table SET F_SUmpire = B.F_PrintLongName FROM #Tmp_SUmpire AS A
	LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID WHERE A.F_Order = 1
	
	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End

GO 

/*EXEC Proc_Report_HO_GetMatchReferee 18,'CHN'*/


