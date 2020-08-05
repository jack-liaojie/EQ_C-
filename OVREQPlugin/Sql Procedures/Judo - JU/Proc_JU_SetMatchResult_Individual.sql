IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_SetMatchResult_Individual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_SetMatchResult_Individual]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_JU_SetMatchResult_Individual]
--��    ��: ���������Ŀ�趨һ������һ�������ߵı����ɼ�.
--�� �� ��: �����
--��    ��: 2010��11��5�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_JU_SetMatchResult_Individual]
	@MatchID						INT,
	@CompPos						INT,
	@IPP							INT,
	@WAZ							INT,
	@YUK							INT,
	@S1								INT,
	@S2								INT,
	@S3								INT,
	@S4								INT,
	@SH								INT,
	@SX								INT,
	@Hantei							INT,
	@IRMCode						NVARCHAR(40),
	@ResultID						INT,
	@Rank							INT,
	@Result							INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0

	DECLARE @IRMID					INT		
	SELECT @IRMID = I.F_IRMID
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	INNER JOIN TC_IRM AS I
		ON E.F_DisciplineID = I.F_DisciplineID AND I.F_IRMCODE = @IRMCode
	WHERE M.F_MatchID = @MatchID

	UPDATE TS_Match_Result
	SET F_PointsNumDes1 = @IPP
		, F_PointsNumDes2 = @WAZ
		, F_PointsNumDes3 = @YUK
		, F_PointsNumDes4 = CASE 
			WHEN @S1 = 1 THEN 1 
			WHEN @S2 = 1 THEN 2 
			WHEN @S3 = 1 THEN 3 
			WHEN @S4 = 1 THEN 4
			ELSE 0
		END
		, F_PointsCharDes4 = CASE
			WHEN @SH = 1 THEN N'H'
			WHEN @SX = 1 THEN N'X'
			ELSE N''
		END
		, F_PointsCharDes1 = CONVERT(NVARCHAR(100), @Hantei)
		, F_IRMID = @IRMID
		, F_ResultID = CASE @ResultID WHEN 0 THEN NULL ELSE @ResultID END
		, F_Rank = @Rank
	WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompPos
	
	SET @Result = 1

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatchResult_Individual] 

*/