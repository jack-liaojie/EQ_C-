/****** Object:  StoredProcedure [dbo].[Proc_GetGroupInfo]    Script Date: 11/19/2009 09:41:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetGroupInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetGroupInfo]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetGroupInfo]    Script Date: 11/19/2009 09:26:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GetGroupInfo]
--描    述：得到所有的代表团\国家\俱乐部\Delegation，并表明当前Discipline激活的代表团\国家\俱乐部
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年04月29日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

CREATE PROCEDURE [dbo].[Proc_GetGroupInfo](
				 @DisciplineID			INT,
				 @LanguageCode			CHAR(3),
                 @GroupType             INT
)
As
Begin
SET NOCOUNT ON 


    IF(@GroupType = 1)
    BEGIN
		EXEC Proc_GetFederations @DisciplineID,@LanguageCode
    END
    ELSE IF(@GroupType = 2)
    BEGIN
        EXEC Proc_GetNOCs @DisciplineID,@LanguageCode
    END
    ELSE IF(@GroupType = 3)
    BEGIN
        EXEC Proc_GetClubs @DisciplineID,@LanguageCode
    END
    ELSE IF(@GroupType = 4)
    BEGIN
        EXEC Proc_GetDelegation @DisciplineID,@LanguageCode
    END


Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF
