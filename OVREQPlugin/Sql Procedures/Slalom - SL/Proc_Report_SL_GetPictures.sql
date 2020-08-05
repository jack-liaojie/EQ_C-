IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetPictures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetPictures]
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

--名    称: [Proc_Report_SL_GetPictures]
--描    述: 激流回旋项目报表获取图片信息, 如运动会图标, 体育项目图标, 赞助商图标等等,  
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年01月22日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_Report_SL_GetPictures]
AS
BEGIN
SET NOCOUNT ON

	SELECT
	(
		SELECT TOP 1 F_FileInfo
		FROM TC_PicFile_Info
		WHERE UPPER(F_FileCode) = N'SPORT_ENG'
	) AS [SPORT]
	, (
		SELECT TOP 1 F_FileInfo
		FROM TC_PicFile_Info
		WHERE UPPER(F_FileCode) = N'SL_ENG'
	) AS [SL]
	, (
		SELECT TOP 1 F_FileInfo
		FROM TC_PicFile_Info
		WHERE UPPER(F_FileCode) = N'SPONSOR1_ENG'
	) AS [SPONSOR1]
	, (
		SELECT TOP 1 F_FileInfo
		FROM TC_PicFile_Info
		WHERE UPPER(F_FileCode) = N'SPONSOR2_ENG'
	) AS [SPONSOR2]
	, (
		SELECT TOP 1 F_FileInfo
		FROM TC_PicFile_Info
		WHERE UPPER(F_FileCode) = N'CORRECTED_STAMP'
	) AS [CORRECTED_STAMP]
	, (
		SELECT TOP 1 F_FileInfo
		FROM TC_PicFile_Info
		WHERE UPPER(F_FileCode) = N'TEST_STAMP'
	) AS [TEST_STAMP]

SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
