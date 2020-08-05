IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetWeight]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetWeight]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_WR_GetWeight]
--描    述: 获取Weight数据集 
--创 建 人: 宁顺泽
--日    期: 2011年10月13日 
--修改记录：
/*			
	
*/



CREATE PROCEDURE [dbo].[Proc_WR_GetWeight]
	@EventID							INT
AS
BEGIN
SET NOCOUNT ON

	select ROW_NUMBER() over (order by d.f_delegationcode, rd.f_longname) as Number
	, d.f_delegationcode as [NOC Code]
	, rd.f_longname as [Name]
	, i.F_InscriptionComment1 as [Weight (kg)]
	, i.F_InscriptionComment2 as [Remark]
from TR_Inscription as i
left join TS_Event_Des as ed
	on i.F_EventID = ed.F_EventID and ed.F_LanguageCode = 'eng'
 left join TR_Register as r
	on i.F_RegisterID = r.F_RegisterID
left join TR_Register_Des as rd
	on r.F_RegisterID = rd.F_RegisterID and rd.F_LanguageCode = 'eng'
left join TC_Delegation as d
	on r.F_DelegationID = d.F_DelegationID
where i.F_EventID = @EventID

SET NOCOUNT OFF
END

------------------
--exec [Proc_JU_GetWeight] 1
------------------------