IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_Athlete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_Athlete]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----�洢�������ƣ�[Proc_DataExchange_Athlete]
----��		  �ܣ��˶�Ա������Ϣ(M0011)�������ǵ����˶�Ա���������κε������˫����ϵ���Ϣ���������κα�����ص���Ϣ��
----��		  �ߣ�֣����
----��		  ��: 2010-04-19 
----�޸�	��¼:

/*
         ����             �޸���            �޸�����
         2010-11-27		  ֣����			����洢���̵Ĳ��� @Lang; @RSC; @Discipline; @Event; @Phase; @Unit; @Gender; @Venue; @Date; @DisciplineID; @EventID; @PhaseID; @MatchID; @SessionID; @CourtID
         2011-01-12		  ֣����			�����������@LanguageCode�����⴦��:�� @LanguageCodeΪ'CHN'ʱҪ������Ϣͷ�������ʾΪ 'CHI'.���⴦��
         2011-01-19		  ֣����			������ߺ����أ��䵥λΪcm��Kg��������������Ϊ��������������С���㡣
         2011-01-19		  ֣����			����ԭ���ļ�¼��������Ϣ
         2011-03-05		  ֣����			����ԭ���ļ�¼��������Ϣ����ֻ֤��F_IsRecordΪ1���˶�Ա�����˵���Ҳ����F_IsRecordΪNULL�Ĳ������˵���
         2011-03-09		  ֣����			�����Ϣ���ǿյľ���������ϢΪ��,�����ʹ���Ϣ.
         2011-07-14		  ֣����			�����˶�Ա��University���ԡ�
*/


CREATE PROCEDURE [dbo].[Proc_DataExchange_Athlete]
		@Discipline			AS NVARCHAR(50),
		@LanguageCode		AS CHAR(3)
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineID	AS NVARCHAR(50)
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @Discipline

	DECLARE @Content AS NVARCHAR(MAX)
	SET @Content = (SELECT
			Athlete.F_RegisterCode AS Registration
			, Athlete.Operate
			, ISNULL(Athlete.F_LongName, '') AS [Name]
			, ISNULL(Athlete.F_LastName, '') AS Family_Name
			, ISNULL(Athlete.F_FirstName, '') AS Given_Name
			, ISNULL(Athlete.F_TvLongName, '') AS TVName
			, ISNULL(Athlete.F_ShortName, '') AS TVShortName
			, ISNULL(Athlete.F_PrintLongName, '') AS PrintName
			, ISNULL(Athlete.F_PrintShortName, '') AS PrintShortName
			, ISNULL(Athlete.F_SBLongName, '') AS SCBName
			, ISNULL(Athlete.F_SBShortName, '') AS SCBShortName
			, ISNULL(REPLACE(LEFT(CONVERT(NVARCHAR(MAX), Athlete.F_Birth_Date, 120 ), 10), '-', ''), '') AS Birthday
			, Athlete.F_GenderCode AS Gender
			, Athlete.Birth_City AS Birth_City
			, Athlete.Birth_Country AS Birth_Country
			, Athlete.Residence_City AS Residence_City
			, Athlete.Residence_Country AS Residence_Country
			, Athlete.F_Height AS Height
			, Athlete.F_Weight AS Weight
			, ISNULL(Athlete.F_NOC, '') AS Nationality
			, ISNULL(Athlete.F_DelegationCode, '') AS NOC
			, ISNULL(Athlete.F_RegisterNum, '') AS IF_Number
			, ISNULL(University, '') AS University
			FROM (SELECT A.F_RegisterCode, ISNULL(CAST(CAST(A.F_Height AS INT) AS NVARCHAR(20)), '') AS F_Height, ISNULL(CAST(CAST(A.F_Weight AS INT) AS NVARCHAR(20)), '') AS F_Weight, A.F_NOC, A.F_Birth_Date, A.F_RegisterNum, D.F_DelegationCode, 'ALL' AS Operate, B.F_FirstName, B.F_LastName, B.F_LongName, B.F_ShortName
				,B.F_TvLongName, B.F_TvShortName, B.F_SBLongName, B.F_SBShortName, B.F_PrintLongName, B.F_PrintShortName, ISNULL(C.F_GenderCode, '') AS F_GenderCode, E.F_Comment AS University
				,ISNULL(A.F_Birth_City, '') AS Birth_City, ISNULL(A.F_Birth_Country, '') AS Birth_Country, ISNULL(A.F_Residence_City, '') AS Residence_City, ISNULL(A.F_Residence_Country, '') AS Residence_Country FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
				LEFT JOIN TC_Sex AS C ON A.F_SexCode = C.F_SexCode LEFT JOIN TC_Delegation AS D ON A.F_DelegationID = D.F_DelegationID 
				LEFT JOIN TR_Register_Comment AS E ON A.F_RegisterID = E.F_RegisterID AND E.F_Title = 'University_' + @LanguageCode WHERE A.F_RegisterID > 0 AND A.F_RegTypeID = 1 AND A.F_DisciplineID = @DisciplineID AND ISNULL(A.F_IsRecord, 0) <> 1) AS Athlete
			FOR XML AUTO)


	IF @LanguageCode = 'CHN'
	BEGIN
		SET @LanguageCode = 'CHI'
	END

	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N'Version = "1.0"'
							+N' Category = "VRS"' 
							+N' Origin = "VRS"'
							+N' RSC = "' + @Discipline + '0000000"'
							+N' Discipline = "'+ @Discipline +'"'
							+N' Gender = "0"'
							+N' Event = "000"'
							+N' Phase = "0"'
							+N' Unit = "00"'
							+N' Venue ="000"'
							+N' Code = "M0011"'
							+N' Type = "DATA"'
							+N' Language = "' + @LanguageCode + '"'
							+N' Date ="'+ REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), ':', ''), '.', '')+'"'

	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Content
					+ N'
						</Message>'


	SELECT @OutputXML AS OutputXML
	RETURN

SET NOCOUNT OFF
END

GO




/*

EXEC Proc_DataExchange_Athlete 'TE', 'ENG'
EXEC Proc_DataExchange_Athlete 'TE', 'CHN'

*/

 
