IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetPictures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetPictures]
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

--��    ��: [Proc_Report_SL_GetPictures]
--��    ��: ����������Ŀ�����ȡͼƬ��Ϣ, ���˶���ͼ��, ������Ŀͼ��, ������ͼ��ȵ�,  
--����˵��: 
--˵    ��: 
--�� �� ��: �ⶨ�P
--��    ��: 2010��01��22��
--�޸ļ�¼��



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
