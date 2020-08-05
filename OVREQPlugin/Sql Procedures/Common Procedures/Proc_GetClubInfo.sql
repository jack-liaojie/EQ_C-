/****** Object:  StoredProcedure [dbo].[Proc_GetClubInfo]    Script Date: 11/20/2009 13:44:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetClubInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetClubInfo]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetClubInfo]    Script Date: 11/20/2009 13:43:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_GetClubInfo]
----功		  能：得到所有的俱乐部信息
----作		  者：李燕
----日		  期: 2009-08-17 
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

CREATE PROCEDURE [dbo].[Proc_GetClubInfo](
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

    CREATE TABLE #Tmp_Table(
								F_Name			NVARCHAR(100),
								F_Key			INT
							)

	DECLARE @AllDes AS NVARCHAR(100)
	SET @AllDes = ' '

	INSERT INTO #Tmp_Table (F_Name, F_Key) VALUES (@AllDes, -1)
	INSERT INTO #Tmp_Table (F_Name, F_Key) 
		SELECT B.F_ClubLongName, A.F_CLubID 
	       FROM TC_CLub AS A  LEFT JOIN TC_CLub_Des AS B 
		ON A.F_CLubID = B.F_CLubID AND B.F_LanguageCode= @LanguageCode
	
    SELECT F_Name, F_Key FROM #Tmp_Table
	

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

