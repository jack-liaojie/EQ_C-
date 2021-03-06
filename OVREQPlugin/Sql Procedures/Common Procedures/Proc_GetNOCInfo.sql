/****** Object:  StoredProcedure [dbo].[Proc_GetNOCInfo]    Script Date: 11/20/2009 13:27:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetNOCInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetNOCInfo]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetNOCInfo]    Script Date: 11/20/2009 13:24:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_GetNOCInfo]
----功		  能：得到所有的国家信息
----作		  者：李燕
----日		  期: 2009-08-17 
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

CREATE PROCEDURE [dbo].[Proc_GetNOCInfo](
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON


    CREATE TABLE #Tmp_Table(
								F_Name			NVARCHAR(100),
								F_Key			NVARCHAR(3)
							)

	DECLARE @AllDes AS NVARCHAR(100)
	SET @AllDes = ' '


	INSERT INTO #Tmp_Table (F_Name, F_Key) VALUES (@AllDes, '-1')
	INSERT INTO #Tmp_Table (F_Name, F_Key) 
		SELECT B.F_CountryShortName, A.F_NOC 
	       FROM TC_Country AS A LEFT JOIN TC_Country_Des AS B 
		      ON A.F_NOC = B.F_NOC AND B.F_LanguageCode=@LanguageCode

	SELECT F_Name, F_Key FROM #Tmp_Table ORDER BY F_Name


	


Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

