/****** Object:  StoredProcedure [dbo].[Proc_GetMember_WithOrder]    Script Date: 09/10/2009 14:57:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetMember_WithOrder]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetMember_WithOrder]
GO

/****** Object:  StoredProcedure [dbo].[Proc_GetMember_WithOrder]    Script Date: 09/10/2009 14:56:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_GetMember_WithOrder]
----功		  能：得到当前队伍成员信息
----作		  者：李燕
----日		  期: 2009-08-17 

CREATE PROCEDURE [dbo].[Proc_GetMember_WithOrder](
                                         @DisciplineID    INT,
                                         @RegisterID      INT,
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

    SELECT E.F_RegisterCode AS[RegisterCode], B.F_LongName AS [Register Name], A.F_Order AS [Order], C.F_FunctionLongName AS [Function], D.F_PositionLongName AS [Position],A.F_ShirtNumber AS [ShirtNumber], A.F_Comment AS [Comment], A.F_MemberRegisterID AS [RegisterID]
		 FROM TR_Register_Member AS A LEFT JOIN TR_Register_Des AS B ON A.F_MemberRegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
					                  LEFT JOIN TD_Function_Des AS C ON A.F_FunctionID = C.F_FunctionID AND C.F_LanguageCode = @LanguageCode LEFT JOIN TD_POSITION_DES AS D ON A.F_PositionID = D.F_PositionID AND D.F_LanguageCode = @LanguageCode
					                  RIGHT JOIN TR_Register AS E ON A.F_MemberRegisterID = E.F_RegisterID  
		 WHERE A.F_RegisterID = @RegisterID AND E.F_DisciplineID = @DisciplineID 
         ORDER BY A.F_Order


Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF
