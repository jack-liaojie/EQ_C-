IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetEventList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetEventList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--��    ��: [Proc_Report_BD_GetEventList]
--��    ��: ��ȡ Event �б�, ��Ҫ���� C32C (Entry By NOC) ����
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��09��09��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����	
			2009��11��12��		�����		��Ӳ��� @DisciplineID, ʹ֮���� Active ��Ӱ��;
											ʹ�ù��� SQL �ķ����򻯴洢����.
			2010��1��12��		�����		ȥ������ @LanguageCode, ���һЩ����.
			2010��1��28��		�����		����ȡ��д.
			2010��2��4��		�����		ȡ����ʹ��ͳһ�ĺ��� [Func_Report_KR_GetDateTime], ���ڲ��� 0 ��ͷ.
			2010��5��12��		�����		��ȡС��� MatchType: 1-���ֵ���, 2-��������, 3-�͵���, 4-������.
*/



CREATE PROCEDURE [dbo].[Proc_Report_BD_GetEventList]
	@DisciplineID				INT,
	@EventID					INT		-- <= 0 ��ȡ����С���б�
AS
BEGIN
SET NOCOUNT ON

	DECLARE @LanguageCode_ENG	CHAR(3)
	DECLARE @LanguageCode_CHN	CHAR(3)
	SET @LanguageCode_ENG = 'ENG'
	SET @LanguageCode_CHN = 'CHN'

	DECLARE @SQL	NVARCHAR(4000)
	
	SET LANGUAGE 'us_english'

	SET @SQL = '
		SELECT A.F_EventID AS [EventID]
			, UPPER(B.F_EventLongName) AS [Event_ENG]
			, UPPER(C.F_EventLongName) AS [Event_CHN]
			, A.F_Order AS [Order]
			, A.F_EventCode AS [EventCode]
			, dbo.Fun_GetWeekdayName(A.F_OpenDate, ''' + @LanguageCode_ENG + ''') AS [Weekday_ENG]
			, dbo.Fun_GetWeekdayName(A.F_OpenDate, ''' + @LanguageCode_CHN + ''') AS [Weekday_CHN]
			, dbo.[Func_Report_TE_GetDateTime](A.F_OpenDate, 1, ''' + @LanguageCode_ENG + ''') AS [Date]
			, LEFT(CONVERT(NVARCHAR(20), A.F_OpenDate, 114), 5) AS [StartTime]
			, D.F_GenderCode AS [Gender]
			, MatchType = CASE UPPER(B.F_EventComment)
				WHEN ''KUMITE'' THEN CASE A.F_PlayerRegTypeID WHEN 1 THEN 1 ELSE 2 END
				WHEN ''KATA'' THEN CASE A.F_PlayerRegTypeID WHEN 1 THEN 3 ELSE 4 END
			END
		FROM TS_Event AS A
		LEFT JOIN TS_Event_Des AS B
			ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = ''' + @LanguageCode_ENG + ''' 
		LEFT JOIN TS_Event_Des AS C
			ON A.F_EventID = C.F_EventID AND C.F_LanguageCode = ''' + @LanguageCode_CHN + ''' 
		LEFT JOIN TC_Sex AS D
			ON A.F_SexCode = D.F_SexCode
	'
	
	IF @EventID <= 0
	BEGIN
		SET @SQL = @SQL + ' 
			WHERE A.F_DisciplineID = ' + CAST(@DisciplineID AS NVARCHAR(10)) + '
		'
	END
	ELSE
	BEGIN
		SET @SQL = @SQL + ' 
			WHERE A.F_EventID = ' + CAST(@EventID AS NVARCHAR(10)) + '
		'
	END

	EXEC (@SQL)

SET NOCOUNT OFF
END

GO


