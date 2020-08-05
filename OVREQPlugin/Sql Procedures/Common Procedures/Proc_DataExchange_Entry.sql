IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_Entry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_Entry]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_DataExchange_Entry]
----功		  能：运动员以及赛队报项信息(M0021)。
----作		  者：郑金勇
----日		  期: 2010-11-29 
----修改	记录:

/*
         日期             修改人            修改内容
         2010-11-27		  郑金勇			变更存储过程的参数 @Lang; @RSC; @Discipline; @Event; @Phase; @Unit; @Gender; @Venue; @Date; @DisciplineID; @EventID; @PhaseID; @MatchID; @SessionID; @CourtID
		 2011-01-11		  郑金勇            只发送运动员和双打组合以及队,不发送任何官员相关的信息!
		 2011-01-15	      郑金勇            包括队员中的人员信息也仅仅是发送队员、双打组合信息，不发送其中的领队和教练和队医等信息！
		 2011-03-09		  郑金勇			对于输入参数@LanguageCode的特殊处理:当 @LanguageCode为'CHN'时要求在消息头里面的显示为 'CHI'.特殊处理！
         2011-03-09		  郑金勇			如果消息体是空的就让整个消息为空,不发送此消息.
         2011-03-20		  郑金勇			Bug修改Entry_Name应该分别取中文和英文。
*/

CREATE PROCEDURE [dbo].[Proc_DataExchange_Entry]
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
				WHERE A.F_RegisterID = [Entry].F_RegisterID AND B.F_RegTypeID IN (1, 2, 3)) AS [Athlete] FOR XML AUTO, TYPE)
			FROM (SELECT A.F_RegisterID, D.F_DisciplineCode AS Discipline, E.F_GenderCode AS Gender, B.F_EventCode AS [Event], I.F_RegTypeCode AS [Type], C.F_RegisterCode AS Reg_ID, ISNULL(F.F_LongName, '') AS Entry_Name,
			 ISNULL(H.F_DelegationCode, '') AS NOC, 'ALL' AS Operate, ISNULL(A.F_InscriptionResult, '') AS Entry_Result, ISNULL(CAST(A.F_InscriptionRank AS NVARCHAR(20)), '') AS IF_Rank,  '' AS NOC_Rank, ISNULL(CAST(A.F_Seed AS NVARCHAR(20)), '') AS Seed  FROM TR_Inscription AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID 
				LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID LEFT JOIN TS_Discipline AS D ON B.F_DisciplineID = D.F_DisciplineID LEFT JOIN TC_Sex AS E ON B.F_SexCode = E.F_SexCode
				LEFT JOIN TR_Register_Des AS F ON A.F_RegisterID = F.F_RegisterID AND F.F_LanguageCode = @LanguageCode
				LEFT JOIN TC_Delegation AS H ON C.F_DelegationID = H.F_DelegationID LEFT JOIN TC_RegType AS I ON C.F_RegTypeID = I.F_RegTypeID WHERE C.F_RegTypeID IN (1, 2, 3)) AS [Entry]
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
							+N' Code = "M0021"'
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


--EXEC Proc_DataExchange_Entry 'TE', 'ENG'
--EXEC Proc_DataExchange_Entry 'TE', 'CHN'