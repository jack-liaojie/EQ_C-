IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WR_GetWeighInList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WR_GetWeighInList]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_WR_GetWeighInList]
--描    述: 获取体重称量表的主要内容.
--创 建 人: 邓年彩
--日    期: 2010年11月8日 星期一
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Report_WR_GetWeighInList]
	@EventID						INT,
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT
		 i.F_EventID as EventID
		,D.F_DelegationCode AS [NOCCode]
		, RD.F_PrintLongName AS [Name]
		, CASE WHEN ISNULL(I.F_InscriptionComment1,N'')=N'' then N''
			WHEN UPPER(I.F_InscriptionComment1)=N'X' then N'X'
			ELSE CONVERT(NVARCHAR(10), CONVERT(DECIMAL(8,1),I.F_InscriptionComment1)) 
			END AS [Weight_Kg]
		, CASE WHEN ISNULL(I.F_InscriptionComment1,N'')=N'' then N''
			WHEN UPPER(I.F_InscriptionComment1)=N'X' then N'X'
			ELSE CONVERT(NVARCHAR(5), CONVERT(INT, ROUND(CONVERT(DECIMAL,I.F_InscriptionComment1),0)) * 22 / 10) 
			END AS [Weight_lbs]
		, I.F_InscriptionComment2 AS [Remarks]
	FROM TR_Inscription AS I
	INNER JOIN TR_Register AS R
		ON I.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	WHERE (I.F_EventID = @EventID OR @EventID=-1) and I.F_EventID<17
	ORDER BY I.F_EventID, D.F_DelegationCode

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetWeighInList] 14, 'ENG'

*/