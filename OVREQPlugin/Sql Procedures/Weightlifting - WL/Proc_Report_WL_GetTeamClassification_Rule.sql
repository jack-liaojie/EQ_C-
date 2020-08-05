IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetTeamClassification_Rule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetTeamClassification_Rule]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Report_WL_GetTeamClassification_Rule]
--��    ��: ��ȡ C76 - Unofficial Team Classification �� ���ֹ���.
--�� �� ��: �����
--��    ��: 2011��3��26�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_Report_WL_GetTeamClassification_Rule]
	@LanguageCode					CHAR(3) = 'ENG'
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @Rule					NVARCHAR(MAX)
	DECLARE @RankCount				INT

	CREATE TABLE #RankPoints
	(
		[Rank]						INT,
		Points						INT
	)
	
	-- ��������޼ʽ����������ݹ��ʾ���������еı�����������ӵ����������б�׼��ÿ���˶�Ա�ĵ÷���ӵó�
	INSERT #RankPoints VALUES (1, 28)
	INSERT #RankPoints VALUES (2, 25)
	INSERT #RankPoints VALUES (3, 23)
	INSERT #RankPoints VALUES (4, 22)
	INSERT #RankPoints VALUES (5, 21)
	INSERT #RankPoints VALUES (6, 20)
	INSERT #RankPoints VALUES (7, 19)
	INSERT #RankPoints VALUES (8, 18)
	INSERT #RankPoints VALUES (9, 17)
	INSERT #RankPoints VALUES (10, 16)
	INSERT #RankPoints VALUES (11, 15)
	INSERT #RankPoints VALUES (12, 14)
	INSERT #RankPoints VALUES (13, 13)
	INSERT #RankPoints VALUES (14, 12)
	INSERT #RankPoints VALUES (15, 11)
	INSERT #RankPoints VALUES (16, 10)
	INSERT #RankPoints VALUES (17, 9)
	INSERT #RankPoints VALUES (18, 8)
	INSERT #RankPoints VALUES (19, 7)
	INSERT #RankPoints VALUES (20, 6)
	INSERT #RankPoints VALUES (21, 5)
	INSERT #RankPoints VALUES (22, 4)
	INSERT #RankPoints VALUES (23, 3)
	INSERT #RankPoints VALUES (24, 2)
	INSERT #RankPoints VALUES (25, 1)
	
	SELECT @RankCount = COUNT(*) FROM #RankPoints
	
	SET @Rule = N''
	
	SELECT @Rule = @Rule + CONVERT(NVARCHAR(10), [Rank]) 
		+ N'<sup>' 
		+ CASE WHEN [Rank] IN (1, 21, 31, 41) THEN N'st'
			WHEN [Rank] IN (2, 22, 32, 42) THEN N'nd'
			WHEN [Rank] IN (3, 23, 33, 43) THEN N'rd'
			ELSE N'th'
		END 
		+ N'</sup>'
		+ N' place = '
		+ CONVERT(NVARCHAR(10), Points)
		+ CASE Points WHEN 1 THEN N' point, ' ELSE N' points, ' END
		+ CASE WHEN [Rank] % 5 = 0 AND [Rank] <> @RankCount THEN N'<br>' ELSE N'' END
	FROM #RankPoints
	ORDER BY [Rank]
	
	SELECT LEFT(@Rule, LEN(@Rule) - 1) AS [Rule]

SET NOCOUNT OFF
END
GO

/*

-- Just for test
EXEC [Proc_Report_WL_GetTeamClassification_Rule]

*/