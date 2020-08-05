IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetTeamMember_DrawModel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetTeamMember_DrawModel]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_GetTeamMember_DrawModel]
----功		  能：得到当前队伍成员信息
----作		  者：张翠霞
----日		  期: 2010-08-17 

CREATE PROCEDURE [dbo].[Proc_GetTeamMember_DrawModel](
                                         @DisciplineID    INT,
                                         @RegisterID      INT,
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

    SELECT B.F_LongName AS [Register Name], A.F_Order AS [Order], C.F_FunctionLongName AS [Function], D.F_PositionLongName AS [Position],A.F_ShirtNumber AS [ShirtNumber],A.F_MemberRegisterID AS [RegisterID], M.F_DelegationID AS [DelegationID], M.F_SexCode AS [SexCode], G.F_DelegationLongName AS Name, A.F_RegisterID AS TeamID
		 FROM TR_Register_Member AS A LEFT JOIN TR_Register_Des AS B ON A.F_MemberRegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
					                  LEFT JOIN TD_Function_Des AS C ON A.F_FunctionID = C.F_FunctionID AND C.F_LanguageCode = @LanguageCode LEFT JOIN TD_POSITION_DES AS D ON A.F_PositionID = D.F_PositionID AND D.F_LanguageCode = @LanguageCode
					                  RIGHT JOIN TR_Register AS E ON A.F_MemberRegisterID = E.F_RegisterID AND  E.F_RegTypeID IN (1,4,5,6)
					                  LEFT JOIN TR_Register AS M ON A.F_RegisterID = M.F_RegisterID
					                  LEFT JOIN TC_Delegation AS F ON M.F_DelegationID = F.F_DelegationID
					                  LEFT JOIN TC_Delegation_Des AS G ON F.F_DelegationID = G.F_DelegationID AND G.F_LanguageCode = @LanguageCode
		 WHERE A.F_RegisterID = @RegisterID AND E.F_DisciplineID = @DisciplineID 
         ORDER BY A.F_Order


Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF


GO


