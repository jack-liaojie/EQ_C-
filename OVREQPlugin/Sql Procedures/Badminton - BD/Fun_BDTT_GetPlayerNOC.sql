IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_BDTT_GetPlayerNOC]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_BDTT_GetPlayerNOC]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		王强
-- Create date: 2011/4/25
-- Description:	获取运动员的NOCCode
-- =============================================

CREATE FUNCTION [dbo].[Fun_BDTT_GetPlayerNOC]
								(
									@RegisterID INT
								)
RETURNS NVARCHAR(20)
AS
BEGIN
	
	DECLARE @NOC NVARCHAR(20)
	SELECT @NOC = B.F_DelegationCode FROM TR_Register AS A 
	LEFT JOIN TC_Delegation AS B ON B.F_DelegationID = A.F_DelegationID
	WHERE A.F_RegisterID = @RegisterID
	
	IF @NOC IS NULL
	BEGIN
		RETURN ''
	END
	RETURN @NOC
END

GO

