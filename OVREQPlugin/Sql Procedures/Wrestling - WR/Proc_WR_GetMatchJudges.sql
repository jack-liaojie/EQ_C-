IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetMatchJudges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetMatchJudges]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    ��: [Proc_WR_GetMatchJudges]
--��    ��: �����Ŀ��ȡһ�� Match �Ĳ���  
--�� �� ��: �����
--��    ��: 2010��11��8�� ����һ
--�޸ļ�¼��
/*			
	ʱ��					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WR_GetMatchJudges]
	@MatchID						INT,
	@LanguageCode					CHAR(3) = 'ANY'		-- Ĭ��ȡ��ǰ���������
AS
BEGIN
SET NOCOUNT ON

	IF @LanguageCode = 'ANY'
	BEGIN
		SELECT @LanguageCode = F_LanguageCode
		FROM TC_Language
		WHERE F_Active = 1
	END

	SELECT A.F_ServantNum AS [ServantNum]
		, A.F_Order AS [Order]
		, A.F_RegisterID AS [RegisterID]
		, B.F_Bib + N'---' + C.F_LongName + ' (' + B.F_NOC +')'AS [Name]
		, C.F_LongName + ' (' + B.F_NOC +')' AS [NameWithNOC]
		, A.F_FunctionID AS [FunctionID]
		, D.F_FunctionLongName AS [Function]
	FROM TS_Match_Servant AS A
	LEFT JOIN TR_Register AS B
		ON A.F_RegisterID = B.F_RegisterID
	LEFT JOIN TR_Register_Des AS C
		ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
	LEFT JOIN TD_Function_Des AS D
		ON A.F_FunctionID = D.F_FunctionID AND D.F_LanguageCode = @LanguageCode
	WHERE A.F_MatchID = @MatchID
	ORDER BY A.F_Order

SET NOCOUNT OFF
END


/*

-- Just for test
EXEC [Proc_JU_GetMatchJudges] 2, 'ENG'

*/