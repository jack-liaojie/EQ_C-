IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_ListFunctions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_ListFunctions]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    ��: [Proc_WR_ListFunctions]
--��    ��: �����Ŀ��ȡ Function �б�  
--�� �� ��: ��˳��
--��    ��: 2011��10��11�� ���ڶ�
--�޸ļ�¼��
/*			
	ʱ��					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WR_ListFunctions]
	@MatchID						INT,
	@LanguageCode					CHAR(3) = 'ANY'		-- Ĭ��ȡ��ǰ���������
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @DisciplineID			INT

	SELECT @DisciplineID = C.F_DisciplineID
	FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B
		ON A.F_PhaseID = B.F_PhaseID
	LEFT JOIN TS_Event AS C
		ON B.F_EventID = C.F_EventID
	WHERE A.F_MatchID = @MatchID

	IF @LanguageCode = 'ANY'
	BEGIN
		SELECT @LanguageCode = F_LanguageCode
		FROM TC_Language
		WHERE F_Active = 1
	END

	SELECT A.F_FunctionID AS [FunctionID]
		, B.F_FunctionLongName AS [Function]
	FROM TD_Function AS A
	LEFT JOIN TD_Function_Des AS B
		ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode
	WHERE A.F_DisciplineID = @DisciplineID
		AND A.F_FunctionCategoryCode = N'S'		-- ѡȡ F_FunctionCategoryCode Ϊ 'S' ��
	ORDER BY B.F_FunctionLongName

SET NOCOUNT OFF
END


/*

-- Just for test
EXEC [Proc_JU_ListFunctions] 1611, 'ENG'

*/