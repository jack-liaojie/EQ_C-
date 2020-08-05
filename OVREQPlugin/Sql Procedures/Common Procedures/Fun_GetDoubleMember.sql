IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetDoubleMember]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetDoubleMember]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [DBO].[Fun_GetDoubleMember]
								(
									@RegisterID					INT,
									@OneRegisterID					INT
								)
RETURNS INT
AS
BEGIN

	DECLARE @MemRegisterID			AS INT
	DECLARE @RegTypeID				AS INT
	SELECT @RegTypeID = F_RegTypeID FROM TR_Register WHERE F_RegisterID = @RegisterID
	IF (@RegTypeID = 2)
	BEGIN
			IF (@OneRegisterID = 0)
			BEGIN
				SELECT TOP 1 @MemRegisterID = F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegisterID
			END
			ELSE
			BEGIN
				SELECT TOP 1 @MemRegisterID = F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegisterID AND F_MemberRegisterID <> @OneRegisterID
			END
	END
	ELSE
	BEGIN
		SET @MemRegisterID = @RegisterID
	END
	
	
	RETURN @MemRegisterID
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO