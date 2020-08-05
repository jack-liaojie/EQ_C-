IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_UpdatetWeight]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_UpdatetWeight]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [[Proc_WR_UpdatetWeight]]
--描    述: 获取Weight数据集 
--创 建 人: 宁顺泽
--日    期: 2011年10月13日 星期
--修改记录：
/*			
	
*/



CREATE PROCEDURE [dbo].[Proc_WR_UpdatetWeight]
	@EventID							INT,
	@Noc								NVARCHAR(3),
	@Name								NVARCHAR(50),
	@Weight								NVARCHAR(10),
	@Reamrk								NVARCHAR(20)
AS
BEGIN
SET NOCOUNT ON

		DECLARE @registerID			INT
		
		Select @registerID=R.F_RegisterID from TR_Inscription AS i
		Left Join TR_Register AS R
			on i.F_RegisterID=R.F_RegisterID
		LEFt Join TR_Register_Des AS Rd
			on R.F_RegisterID=rd.F_RegisterID and Rd.F_LanguageCode=N'ENG'
		LEFT JOIN TC_Delegation as D
			ON D.F_DelegationID=R.F_DelegationID
		where D.F_DelegationCode=@Noc AND Rd.F_LongName=@Name
		
		UPDATE TR_Inscription Set F_InscriptionComment1=@Weight,F_InscriptionComment2=@Reamrk
		WHERE F_RegisterID=@registerID AND F_EventID=@EventID
		
SET NOCOUNT OFF
END

------------------
--exec [Proc_JU_UpdatetWeight] 14,N'AFG',N'BAYAT Marzia',N'45',N''
------------------------