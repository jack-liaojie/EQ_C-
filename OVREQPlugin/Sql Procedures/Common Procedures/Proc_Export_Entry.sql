
/****** Object:  StoredProcedure [dbo].[Proc_DataExchange_Entry]    Script Date: 02/10/2011 16:35:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Export_Entry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Export_Entry]
GO

/****** Object:  StoredProcedure [dbo].[Proc_Export_Entry]    Script Date: 02/10/2011 16:35:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_Export_Entry]
----功		  能：运动员以及赛队报项信息(M0121)。
----作		  者：郑金勇
----日		  期: 2010-11-29 
----修改	记录:
-----------------1	2010-11-27	变更存储过程的参数
-----------------	@Lang; @RSC; @Discipline; @Event; @Phase; @Unit; 
-----------------	@Gender; @Venue; @Date; @DisciplineID; @EventID; @PhaseID;
-----------------   @MatchID; @SessionID; @CourtID
-----------------2	2011-01-11	只发送运动员和双打组合以及队,不发送任何官员相关的信息!


CREATE PROCEDURE [dbo].[Proc_Export_Entry]
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
	SET @Content = (SELECT  [Entry].Entry_Name
			, [Entry].NOC
			, [Entry].Reg_ID
			, [Entry].Discipline
			, [Entry].Gender
			, [Entry].[Event]
			, [Entry].[Type]
			, [Entry].Operate
			, [Entry].Entry_Result
			, [Entry].IF_Rank
			, [Entry].NOC_Rank
			, [Entry].Seed
			, (SELECT Registration, [Order] FROM (SELECT B.F_RegisterCode AS Registration, ISNULL(A.F_Order, '') AS [Order] FROM TR_Register_Member AS A LEFT JOIN TR_Register AS B ON A.F_MemberRegisterID = B.F_RegisterID 
				WHERE A.F_RegisterID = [Entry].F_RegisterID) AS [Athlete] FOR XML AUTO, TYPE)
			FROM (SELECT A.F_RegisterID, D.F_DisciplineCode AS Discipline, E.F_GenderCode AS Gender, B.F_EventCode AS [Event], I.F_RegTypeCode AS [Type], C.F_RegisterCode AS Reg_ID, ISNULL(F.F_LongName, '') AS Entry_Name,
			 ISNULL(H.F_DelegationCode, '') AS NOC, 'ALL' AS Operate, ISNULL(A.F_InscriptionResult, '') AS Entry_Result, ISNULL(CAST(A.F_InscriptionRank AS NVARCHAR(20)), '') AS IF_Rank,  '' AS NOC_Rank, ISNULL(CAST(A.F_Seed AS NVARCHAR(20)), '') AS Seed  FROM TR_Inscription AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID 
				LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID LEFT JOIN TS_Discipline AS D ON B.F_DisciplineID = D.F_DisciplineID LEFT JOIN TC_Sex AS E ON B.F_SexCode = E.F_SexCode
				LEFT JOIN TR_Register_Des AS F ON A.F_RegisterID = F.F_RegisterID AND F.F_LanguageCode = 'ENG'
				LEFT JOIN TC_Delegation AS H ON C.F_DelegationID = H.F_DelegationID LEFT JOIN TC_RegType AS I ON B.F_PlayerRegTypeID = I.F_RegTypeID WHERE C.F_RegTypeID IN (1, 2, 3)) AS [Entry]
				 FOR XML AUTO)

	IF @Content IS NULL
	BEGIN
		SET @Content = N''
	END

	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N'Version = "1.0"'
							+N' Category = "CRS"' 
							+N' Origin = "CRS"'
							+N' RSC = "' + @Discipline + '0000000"'
							+N' Discipline = "'+ @Discipline +'"'
							+N' Gender = "0"'
							+N' Event = "000"'
							+N' Phase = "0"'
							+N' Unit = "00"'
							+N' Venue ="000"'
							+N' Code = "M0121"'
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


