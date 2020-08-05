IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WR_GetPictures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WR_GetPictures]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Report_WR_GetPictures]
--��    ��: ˤ����Ŀ�����ȡͼƬ��Ϣ, ���˶���ͼ��, ������Ŀͼ��, ������ͼ��ȵ�,  
--�� �� ��: ��˳��
--��    ��: 2011��10��17�� ����1
--�޸ļ�¼��
/*			
		ʱ��					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_Report_WR_GetPictures]
	@DisciplineID					INT,
	@EventID						INT,
	@PhaseID						INT,
	@MatchID						INT,
	@DateID							INT,
	@SessionID						INT,
	@ReportType						NVARCHAR(20),
	@StampString					NVARCHAR(100)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @DisciplineCode			CHAR(2)

	------------------------------------------------------------------------------------------------------
	-- �� @DisciplineID, @EventID, @PhaseID, @MatchID ����Ԥ����
	------------------------------------------------------------------------------------------------------
	IF @MatchID > 0
		SELECT @PhaseID = M.F_PhaseID FROM TS_Match AS M WHERE M.F_MatchID = @MatchID
	
	IF @PhaseID > 0
		SELECT @EventID = P.F_EventID FROM TS_Phase AS P WHERE P.F_PhaseID = @PhaseID
	
	IF @EventID > 0
		SELECT @DisciplineID = E.F_DisciplineID FROM TS_Event AS E WHERE E.F_EventID = @EventID
	
	IF @DisciplineID = -1
		SELECT @DisciplineID = D.F_DisciplineID FROM TS_Discipline AS D WHERE D.F_Active = 1
		
	SELECT @DisciplineCode = D.F_DisciplineCode FROM TS_Discipline AS D WHERE D.F_DisciplineID = @DisciplineID

	SELECT
	(
		SELECT TOP 1 F_FileInfo FROM TC_PicFile_Info WHERE UPPER(F_FileCode) = N'SPORT_ENG'
	) AS [SPORT]
	, (
		SELECT TOP 1 F_FileInfo FROM TC_PicFile_Info WHERE UPPER(F_FileCode) = @DisciplineCode + N'_ENG'
	) AS [DISCIPLINE]
	, (
		SELECT TOP 1 F_FileInfo FROM TC_PicFile_Info WHERE UPPER(F_FileCode) = N'SPONSOR1_ENG'
	) AS [SPONSOR1]
	, (
		SELECT TOP 1 F_FileInfo FROM TC_PicFile_Info WHERE UPPER(F_FileCode) = N'SPONSOR2_ENG'
	) AS [SPONSOR2]
	, [CORRECTED_STAMP] = CASE @StampString
		WHEN 'Corrected'
			THEN ( SELECT TOP 1 F_FileInfo FROM TC_PicFile_Info WHERE UPPER(F_FileCode) = N'CORRECTED_STAMP' )
			ELSE NULL
		END
	, [TEST_STAMP] = CASE @StampString
		WHEN 'Test'
			THEN ( SELECT TOP 1 F_FileInfo FROM TC_PicFile_Info WHERE UPPER(F_FileCode) = N'TEST_STAMP' )
			ELSE NULL
		END

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetPictures] -1, -1, -1, -1, -1, -1, 'ALL', 'Test'
EXEC [Proc_Report_JU_GetPictures] -1, -1, -1, -1, -1, -1, 'ALL', 'Corrected'

*/