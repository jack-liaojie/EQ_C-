/****** Object:  StoredProcedure [dbo].[Proc_Report_GetOfficialCommunication]    Script Date: 01/07/2010 14:40:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GetOfficialCommunication]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GetOfficialCommunication]
GO
/****** Object:  StoredProcedure [dbo].[Proc_Report_GetOfficialCommunication]    Script Date: 01/07/2010 14:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_Report_GetOfficialCommunication]
--描    述：得到OfficialCommunication
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年1月21日


CREATE PROCEDURE [dbo].[Proc_Report_GetOfficialCommunication](
												@NewsID	    INT
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE 'ENGLISH'
	CREATE TABLE #Tmp_Table(
                                F_NewsItem    NVARCHAR(20),
                                F_SubTitle    NVARCHAR(100),
                                F_Heading     NVARCHAR(100),
                                F_Text        NVARCHAR(MAX),
                                F_Issued_by   NVARCHAR(100),
                                F_Date        NVARCHAR(20),
                                F_Time        NVARCHAR(5),
                                F_Schedule    NVARCHAR(10),
                                F_Results     NVARCHAR(10),
                                F_Other       NVARCHAR(10),
                                F_Note        NVARCHAR(200),
							)

	INSERT INTO #Tmp_Table (F_NewsItem, F_SubTitle, F_Heading, F_Text, F_Issued_by, F_Date, F_Time, F_Note) 
		SELECT F_NewsItem, F_SubTitle, F_Heading, F_Text, F_Issued_by, UPPER(LEFT(CONVERT(NVARCHAR(100), F_Date, 113), 11)),
               LEFT(CONVERT(Nvarchar(100), f_date, 108), 5), F_Note
		 FROM  TS_Offical_Communication 
             WHERE F_NewsID = @NewsID 
     
    DECLARE @Type  INT
    SELECT  @Type = F_Type FROM TS_Offical_Communication WHERE F_NewsID = @NewsID
   
    IF(@Type  IN (1,3,5,7))
    BEGIN
       UPDATE #Tmp_Table SET F_Results = N'X'  FROM TS_Offical_Communication WHERE F_NewsID = @NewsID 
    END 
    
   IF(@Type IN (2,3,6,7))
    BEGIN
        UPDATE #Tmp_Table SET F_Schedule = N'X' FROM TS_Offical_Communication WHERE F_NewsID = @NewsID 
    END  
     
    IF(@Type IN (4,5,6,7))
    BEGIN
        UPDATE #Tmp_Table SET F_Other = N'X' FROM TS_Offical_Communication WHERE F_NewsID = @NewsID 
    END  


    UPDATE #Tmp_Table SET F_Note = ltrim(F_Note) 
    UPDATE #Tmp_Table SET F_Note = rtrim(F_Note)
   
     UPDATE #Tmp_Table SET F_Date = RIGHT(F_Date, 10) WHERE LEFT(F_Date, 1) = '0'
     UPDATE #Tmp_Table SET F_Time = RIGHT(F_Time, 4) WHERE LEFT(F_Time, 1) = '0'
    
    SELECT * FROM #Tmp_Table 

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF
GO



