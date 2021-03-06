/****** Object:  StoredProcedure [dbo].[Proc_Report_GetPictures_ByDisciplineID]    Script Date: 01/25/2010 14:39:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GetPictures_ByDisciplineID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GetPictures_ByDisciplineID]
GO
/****** Object:  StoredProcedure [dbo].[Proc_Report_GetPictures_ByDisciplineID]    Script Date: 01/25/2010 14:37:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--名    称: [Proc_Report_GetPictures_ByDisciplineID]
--描    述: 
--参数说明: 
--说    明: 报表用于获取图片.
--创 建 人: 邓年彩
--日    期: 
--修改记录：
/*			
			时间				修改人		修改内容
            2009-1-25           李燕        参数改为DisciplineID
            2010-2-09           李燕        增加"Test","Corrected"图片
*/



CREATE PROCEDURE [dbo].[Proc_Report_GetPictures_ByDisciplineID]
	@DisciplineID				INT
AS
BEGIN
SET NOCOUNT ON
	
    DECLARE @DisciplineCode         CHAR(2)
    SELECT @DisciplineCode = F_DisciplineCode FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID

	DECLARE @SQL					NVARCHAR(4000)
	
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