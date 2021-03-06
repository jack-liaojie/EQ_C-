IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Info_BDTT_LN_GetScheduleRSC]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Info_BDTT_LN_GetScheduleRSC]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--辽宁全运会，用于获取Info需要的特殊的RSC
--2012-09-13  王强 
--用于全运会新增的全排名报表成绩展示
CREATE FUNCTION [dbo].[Fun_Info_BDTT_LN_GetScheduleRSC]
								(
									@EventID INT,
									@PhaseType INT,-- 0为不分阶段，1为第一阶段，--2为第二阶段
									@DateOrder INT
								)
RETURNS NVARCHAR(20)
AS
BEGIN
	
	DECLARE @RetStr NVARCHAR(20)
	
	IF @DateOrder = -1
	BEGIN
		SET @PhaseType = 0
		SET @DateOrder = 0
	END
		
		
	
	SELECT @RetStr = B.F_DisciplineCode + C.F_GenderCode + A.F_EventCode 
				+ CAST(@PhaseType AS NVARCHAR(1)) + RIGHT( '0' + CAST(@DateOrder AS NVARCHAR(3)),2 )
	FROM TS_Event AS A
	LEFT JOIN TS_Discipline AS B ON B.F_DisciplineID = A.F_DisciplineID
	LEFT JOIN TC_Sex AS C ON C.F_SexCode = A.F_SexCode
	WHERE a.F_EventID = @EventID
	
	RETURN @RetStr
END


GO

--PRINT [dbo].[Fun_BDTT_New_GetMatchResultDes](63,2,5)