IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_SetMatchCodeByTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_SetMatchCodeByTime]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    ��: [Proc_Schedule_SetMatchCodeByTime]
--��    ��: ���°��Ÿ���ʱ��˳���ų�ָ�������� MatchCode
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��12��11��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����	
*/



CREATE PROCEDURE [dbo].[Proc_Schedule_SetMatchCodeByTime]
	@MatchIDList			NVARCHAR(MAX),
	@Prefix					NVARCHAR(10),
	@StartNum				INT,
	@Step					INT,
	@Length					INT,
	@Result					INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	DECLARE @SQL			NVARCHAR(MAX)

	CREATE TABLE #tmp_table
	(
		F_MatchID		INT,
		F_MatchDate		DateTime,
		F_StartTime		NVARCHAR(10),
		F_RowNum		INT,
		F_MatchCode		NVARCHAR(20)
	)

	-- ��� MatchID, MatchDate, StartTime �Ȼ�����Ϣ
	SET @SQL = '
		INSERT INTO #tmp_table
		(F_MatchID, F_MatchDate, F_StartTime)
		(
			SELECT F_MatchID, F_MatchDate, CONVERT(NVARCHAR(10), F_StartTime, 108)
			FROM TS_Match
			WHERE F_MatchID IN (' + @MatchIDList + ')
		)
	'

	EXEC (@SQL)

	-- ���� MatchDate, StartTime ������� RowNum
	UPDATE #tmp_table
	SET F_RowNum = B.F_RowNum
	FROM #tmp_table AS A
	LEFT JOIN ( 
		SELECT F_MatchID, ROW_NUMBER() OVER (ORDER BY F_MatchDate, F_StartTime) AS F_RowNum
		FROM #tmp_table
	) AS B
		ON A.F_MatchID = B.F_MatchID
	
	-- ���� RowNum ����� MatchCode
	IF @Length <> 0			-- �� Length ��Ϊ 0 ʱ, ǰ�油 0 ; �� Length Ϊ 0, ��� MatchCode
	BEGIN
		UPDATE #tmp_table
		SET F_MatchCode = @Prefix 
				+ REPLICATE(N'0'
					, CASE 
						WHEN @Length - LEN(CONVERT(NVARCHAR(10), (F_RowNum - 1) * @Step  + @StartNum)) < 0 THEN 0
						ELSE @Length - LEN(CONVERT(NVARCHAR(10), (F_RowNum - 1) * @Step  + @StartNum))
					END
				)
				+ CONVERT(NVARCHAR(10), (F_RowNum - 1) * @Step  + @StartNum)
	END
		
	SET Implicit_Transactions off
	BEGIN TRANSACTION		-- �趨����

	-- ���� TS_Match �е� F_MatchCode �ֶ�
	UPDATE TS_Match
	SET F_MatchCode = B.F_MatchCode
	FROM TS_Match AS A
	INNER JOIN #tmp_table AS B
		ON A.F_MatchID = B.F_MatchID

	IF @@error<>0 
	BEGIN 
		ROLLBACK			-- ����ع�
		SET @Result = 0		-- ����ʧ��
		RETURN
	END

	COMMIT TRANSACTION		-- �ɹ��ύ����
	SET @Result = 1			-- ���³ɹ�
	RETURN

SET NOCOUNT OFF
END

/*

DECLARE @Result		INT
EXEC [Proc_Schedule_SetMatchCodeByTime] N'1515, 1512, 1513, 1511', N'A', 3, 5, 5, @Result OUT
SELECT F_MatchID, F_MatchCode FROM TS_Match

*/