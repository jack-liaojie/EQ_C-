IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_AR_GetCompetitionSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_AR_GetCompetitionSchedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----��   �ƣ�[Proc_Info_AR_GetCompetitionSchedule]
----��   �ܣ�Info��ȡ���¼ƻ�Э��
----��	 �ߣ��޿�
----��   �ڣ�2012��09��12��

/*
	����˵����
	���	��������	����˵��
	1		@DisciplineID	��Ӧ�����ID  
	2		@LanguageCode
						չ�����ݵ�ָ������

*/

/*
	����������Infoϵͳ��ȡ���¼ƻ�Э��XML����
*/

/*
	�޸ļ�¼��
	���	����			�޸���		�޸�����
	1		2012-09-12		�޿�		�޸����������� 
*/

CREATE PROCEDURE [dbo].[Proc_Info_AR_GetCompetitionSchedule]
		@DisciplineID       AS INT,
		@LanguageCode		AS CHAR(3)
AS
BEGIN
	
SET NOCOUNT ON
 
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)
	
	DECLARE @SQL		    NVARCHAR(max)
    DECLARE @DisciplineCode NVARCHAR(10)	 

	SELECT @DisciplineCode = D.F_DisciplineCode FROM TS_Discipline AS D WHERE D.F_DisciplineID = @DisciplineID 
    
			CREATE TABLE #Schedule
			(
									[Code]					NVARCHAR(50),
									[Name]					NVARCHAR(100),
									[StartDate]             NVARCHAR(100),
									[StartTime]             NVARCHAR(100),
									[Order]					INT,
									[VenueCode]				NVARCHAR(100), 
									F_EventCode				NVARCHAR(10),
									F_PhaseCode				NVARCHAR(10),
									F_MatchCode				NVARCHAR(10),
			)
			
			CREATE TABLE #Details(
									[Code]					NVARCHAR(50),
									[Type]					NVARCHAR(100),--0=���򵥣�1=�ɼ����棻2=���ι��棻3=�Ƽ�¼��Ϣ��4=������
									[FileName]				NVARCHAR(100),
								)

	-- ����ʱ���в��������Ϣ
	INSERT #Schedule 
	([Code], [Name], [StartDate],StartTime,[Order],VenueCode,F_EventCode,F_PhaseCode,F_MatchCode)
	( 
	SELECT  
	DBO.Func_AR_GetRSCCode(1,E.F_EventID,NULL,NULL) AS [Code]
	,F_EventLongName AS [NAME]
	,REPLACE(dbo.Fun_AR_GetDateTime(E.F_OpenDate,1,@LanguageCode),'-','') AS StartDate
	,REPLACE(REPLACE(dbo.Fun_AR_GetDateTime(E.F_OpenDate,8,@LanguageCode),':',''),'.','') AS StartTime 
	,ROW_NUMBER() OVER(ORDER BY F_EventCode) 
	,'AR01' 
	,E.F_EventCode
	,'0'
	,'00'
	FROM TS_Event AS E
	LEFT JOIN TS_Event_DES AS ED ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode  
	
	UNION ALL 
	SELECT  
	DBO.Func_AR_GetRSCCode(1,E.F_EventID,P.F_PhaseID,NULL) AS [Code]
	,F_EventLongName + ' ' + PD.F_PhaseLongName AS [NAME]
	,REPLACE(dbo.Fun_AR_GetDateTime(M.F_MatchDate,1,@LanguageCode),'-','') AS StartDate
	,REPLACE(REPLACE(dbo.Fun_AR_GetDateTime(M.F_StartTime,8,@LanguageCode),':',''),'.','') AS StartTime  
	,ROW_NUMBER() OVER(ORDER BY F_EventCode,F_PhaseCode DESC)
	,'AR01' 
	,E.F_EventCode
	,P.F_PhaseCode
	,M.F_MatchCode
	FROM TS_Phase AS P  
	LEFT JOIN TS_Phase_DES AS PD ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID   
	LEFT JOIN TS_Event_DES AS ED ON P.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode 
	LEFT JOIN TS_Match AS M ON M.F_PhaseID = P.F_PhaseID AND (F_MatchCode = '01' OR F_MatchCode = 'QR' )
	LEFT JOIN TS_Match_DES AS MD ON M.F_MatchID = MD.F_MatchID AND MD.F_LanguageCode = @LanguageCode
	WHERE M.F_MatchID IS NOT NULL
	)
	
	--��������
	INSERT INTO #Details(Code, [FileName], [Type])
		SELECT Code, Code + N'.C51.CHI.1.0', N'C51' FROM #Schedule WHERE F_MatchCode!='00'	
	
	--����ɼ�����
	INSERT INTO #Details(Code, [FileName], [Type])
		SELECT Code, CASE WHEN F_MatchCode ='QR' THEN Code + N'.C73.CHI.1.0' 
					      ELSE  Code + N'.C75.CHI.1.0' END,
					 CASE WHEN F_MatchCode ='QR' THEN N'C73'
					      ELSE N'C75' END  FROM #Schedule 
	--�������ι���
	INSERT INTO #Details(Code, [FileName], [Type])
		SELECT Code, Code + N'.C92A.CHI.1.0', N'C92A' FROM #Schedule WHERE F_MatchCode='00'
	

	DECLARE @Result AS NVARCHAR(MAX)
	SET @Result = ( SELECT Schedule.[Code],[Name],[StartDate],[StartTime],[Order],[VenueCode]
									, [Detail].[Type]
									, [Detail].[FileName] FROM #Schedule AS Schedule 
						LEFT JOIN #Details AS Detail ON Detail.Code= Schedule.Code
						ORDER BY  [Order]
			FOR XML AUTO)

	IF @Result IS NULL
	BEGIN
		SET @Result = N''
	END

	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty =	 N' DisciplineCode = "' + @DisciplineCode + '"' 
							+N' Date ="'+ REPLACE(dbo.Fun_AR_GetDateTime(GETDATE(),1,@LanguageCode), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(dbo.Fun_AR_GetDateTime(GETDATE(),8,@LanguageCode), ':', ''),'.','') + '"'
							+N' Language = "' + CASE WHEN @LanguageCode =N'CHN' THEN N'CHI' ELSE @LanguageCode END + '"' 

	IF(@Result = N'')
		BEGIN
		SET @OutputXML = N''
		END
	ELSE
		BEGIN
		SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
						   <Message ' + @MessageProperty +'>'
						+ @Result
						+ N'
							</Message>'
		END

	IF (@Result IS NOT NULL AND @Result !='')
	BEGIN
	SELECT @OutputXML AS OutputXML
	RETURN
	END
 
SET NOCOUNT OFF
END


/*
exec Proc_Info_AR_GetCompetitionSchedule 1,'CHN' 
*/



GO


