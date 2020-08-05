IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetRegisterIDByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetRegisterIDByName]
GO

/****** Object:  StoredProcedure [dbo].[Proc_JU_GetRegisterIDByName]    Script Date: 12/27/2010 13:43:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_JU_GetRegisterIDByName]
--描    述：依照名字查找RegisterID
--参数说明： 
--说    明：
--创 建 人：宁顺泽
--日    期：2011年07月19日


CREATE PROCEDURE [dbo].[Proc_JU_GetRegisterIDByName](
												@MatchID		    INT,
												@Name				NVARCHAR(100),
												@Compos				INT,
												@LanguageCode		CHAR(3)=N'ENG',
												@RegisterID			INT output
)
As
Begin
SET NOCOUNT ON 
			
	
	declare @TeamRegisterID int
	select @TeamRegisterID=MRA.F_RegisterID
	from TS_Match AS M 
	LEFT JOIN TS_Match_Result AS MRA 
		ON MRA.F_MatchID=M.F_MatchID AND MRA.F_CompetitionPositionDes1=@Compos-1
	where M.F_MatchID=@MatchID
	
	set @RegisterID=-1
	select @RegisterID=ISNULL(R.F_RegisterID,-1) from TR_Register_Member AS RM
	LEFT JOIN TR_Register AS R
		ON RM.F_MemberRegisterID=R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON RD.F_RegisterID=R.F_RegisterID AND RD.F_LanguageCode=@LanguageCode
	where RM.F_RegisterID=@TeamRegisterID AND RD.F_LongName=@Name

Set NOCOUNT OFF
End	
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO
