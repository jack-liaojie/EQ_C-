IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_JU_GetMatchServant]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_JU_GetMatchServant]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Report_JU_GetMatchServant]
--��    ��: ��ȡһ�������Ĳ���.
--�� �� ��: �����
--��    ��: 2010��11��8�� ����һ
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_Report_JU_GetMatchServant]
	@MatchID						INT,
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT MS.F_Order AS [Order] 
		, R.F_Bib AS [No]
		, FD.F_FunctionLongName AS [Function]
		, RD.F_PrintLongName AS [Name]
		, R.F_NOC AS [NOC]
	FROM TS_Match_Servant AS MS
	LEFT JOIN TR_Register AS R
		ON MS.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TD_Function_Des AS FD
		ON MS.F_FunctionID = FD.F_FunctionID AND FD.F_LanguageCode = @LanguageCode
	WHERE MS.F_MatchID = @MatchID
	ORDER BY MS.F_Order

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetMatchServant] 36, 'ENG'

*/