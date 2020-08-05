IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GetPictures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GetPictures]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Report_GetPictures]
--��    ��: 
--����˵��: 
--˵    ��: �������ڻ�ȡͼƬ.
--�� �� ��: �����
--��    ��: 
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2010��1��26��		�����		���ͼƬ [CORRCETED_STAMP], [TEST_STAMP].
			2012��08��24��      ��ǿ        ��@DisciplineCode��ΪĬ�ϲ��������������������Ĭ��ȡActive��DisciplineCode
*/



CREATE PROCEDURE [dbo].[Proc_Report_GetPictures]
	@DisciplineCode					CHAR(2) = ''
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @SQL					NVARCHAR(4000)
	
	IF @DisciplineCode = ''
		SELECT @DisciplineCode = F_DisciplineCode FROM TS_Discipline WHERE F_Active = 1
	
	SET @SQL = '
		SELECT
		(
			SELECT TOP 1 F_FileInfo
			FROM TC_PicFile_Info
			WHERE UPPER(F_FileCode) = N''SPORT_ENG''
		) AS [SPORT_ENG]
		, (
			SELECT TOP 1 F_FileInfo
			FROM TC_PicFile_Info
			WHERE UPPER(F_FileCode) = N''SPORT_CHN''
		) AS [SPORT_CHN]
		, (
			SELECT TOP 1 F_FileInfo
			FROM TC_PicFile_Info
			WHERE UPPER(F_FileCode) = N''' + @DisciplineCode + '_ENG''
		) AS [DISCIPLINE_ENG]
		, (
			SELECT TOP 1 F_FileInfo
			FROM TC_PicFile_Info
			WHERE UPPER(F_FileCode) = N''' + @DisciplineCode + '_CHN''
		) AS [DISCIPLINE_CHN]
		, (
			SELECT TOP 1 F_FileInfo
			FROM TC_PicFile_Info
			WHERE UPPER(F_FileCode) = N''SPONSOR1_ENG''
		) AS [SPONSOR1_ENG]
		, (
			SELECT TOP 1 F_FileInfo
			FROM TC_PicFile_Info
			WHERE UPPER(F_FileCode) = N''SPONSOR1_CHN''
		) AS [SPONSOR1_CHN]
		, (
			SELECT TOP 1 F_FileInfo
			FROM TC_PicFile_Info
			WHERE UPPER(F_FileCode) = N''SPONSOR2_ENG''
		) AS [SPONSOR2_ENG]
		, (
			SELECT TOP 1 F_FileInfo
			FROM TC_PicFile_Info
			WHERE UPPER(F_FileCode) = N''SPONSOR2_CHN''
		) AS [SPONSOR2_CHN]
		, (
			SELECT TOP 1 F_FileInfo
			FROM TC_PicFile_Info
			WHERE UPPER(F_FileCode) = N''CORRECTED_STAMP''
		) AS [CORRECTED_STAMP]
		, (
			SELECT TOP 1 F_FileInfo
			FROM TC_PicFile_Info
			WHERE UPPER(F_FileCode) = N''TEST_STAMP''
		) AS [TEST_STAMP]
	'
	
	EXEC (@SQL)
	

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_GetPictures] 'RO'

*/