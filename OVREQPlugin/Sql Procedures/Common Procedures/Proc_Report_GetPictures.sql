IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GetPictures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GetPictures]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_GetPictures]
--描    述: 
--参数说明: 
--说    明: 报表用于获取图片.
--创 建 人: 邓年彩
--日    期: 
--修改记录：
/*			
			时间				修改人		修改内容
			2010年1月26日		邓年彩		添加图片 [CORRCETED_STAMP], [TEST_STAMP].
			2012年08月24日      王强        将@DisciplineCode改为默认参数，如果不带参数，则默认取Active的DisciplineCode
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