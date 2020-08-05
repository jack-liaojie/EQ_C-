IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_BDTT_GetPlayerNOCName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_BDTT_GetPlayerNOCName]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		王强
-- Create date: 2011/4/25
-- Description:	获取运动员的NOC Name
-- =============================================

CREATE FUNCTION [dbo].[Fun_BDTT_GetPlayerNOCName]
								(
									@RegisterID INT
								)
RETURNS NVARCHAR(100)
AS
BEGIN
	
	DECLARE @NOC NVARCHAR(100)
	SELECT @NOC = C.F_DelegationShortName FROM TR_Register AS A 
	LEFT JOIN TC_Delegation AS B ON B.F_DelegationID = A.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS C ON C.F_DelegationID = B.F_DelegationID AND C.F_LanguageCode = 'CHN'
	WHERE A.F_RegisterID = @RegisterID
	
	IF @NOC IS NULL
	BEGIN
		RETURN ''
	END
	RETURN @NOC
END


GO


