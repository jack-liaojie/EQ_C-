/****** Object:  StoredProcedure [dbo].[Proc_GetDelegationInfo]    Script Date: 11/20/2009 13:48:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDelegationInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetDelegationInfo]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetDelegationInfo]    Script Date: 11/20/2009 13:48:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_GetDelegationInfo]
----功		  能：得到所有的Delegation信息
----作		  者：李燕
----日		  期: 2009-11-19 
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

CREATE PROCEDURE [dbo].[Proc_GetDelegationInfo](
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
		 SELECT B.F_DelegationLongName, A.F_DelegationID 
	       FROM TC_Delegation AS A LEFT JOIN TC_Delegation_Des AS B 
		       ON A.F_DelegationID = B.F_DelegationID AND B.F_LanguageCode = @LanguageCode
           ORDER BY A.F_DelegationType Desc, B.F_DelegationLongName
	
    SELECT F_Name, F_Key FROM #Tmp_Table


Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

