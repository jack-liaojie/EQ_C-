IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEventRecords]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetEventRecords]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_GetEventRecords]
--描    述: 根据 EventID 获取 Event的记录信息
--参数说明: 
--说    明: 
--创 建 人: 郑金勇
--日    期: 2010年12月29日
--修改记录：
/*
            2011-01-20    李燕     更改RecordType的来源，以及删除关于创纪录的运动员的一些信息，比如：F_Residence_Country， F_CompetitorBirthDate， F_CompetitorGender
*/



CREATE PROCEDURE [dbo].[Proc_GetEventRecords]
	@EventID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT A.F_Active, D.F_RecordTypeCode AS F_RecordType, A.F_Equalled, F_IsNewCreated
		, C.F_LongName
		, B.F_NOC 
		, F_RecordValue
		, LEFT(CONVERT(NVARCHAR(100), F_RecordDate, 120), 10) AS F_RecordDate
		, F_Location
		,F_RecordSport
		,A.F_Order
		,A.F_SubEventCode
		, B.F_RegisterCode
		, A.F_RecordID, F_EventID
			FROM TS_Event_Record AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
			LEFT JOIN TR_Register_Des AS C ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_RecordType AS D ON A.F_RecordTypeID = D.F_RecordTypeID
			WHERE F_EventID = @EventID ORDER BY A.F_Order
		
SET NOCOUNT OFF
END

GO


