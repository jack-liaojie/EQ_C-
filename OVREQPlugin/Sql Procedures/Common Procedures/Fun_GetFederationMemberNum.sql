IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetFederationMemberNum]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetFederationMemberNum]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [DBO].[Fun_GetFederationMemberNum]
								(
									@DisciplineID					INT,
									@FederationID					INT,
									@SexCode						INT --1ÄÐ£¬2Å®
								)
RETURNS INT
AS
BEGIN
	DECLARE  @Table_Memeber AS TABLE(F_RegisterID			INT,
						   F_RegTypeID			INT,
						   F_SexCode			INT,
						   F_EventID			INT
						  )
	INSERT INTO @Table_Memeber (F_RegisterID, F_RegTypeID, F_SexCode)
		SELECT A.F_RegisterID, B.F_RegTypeID, B.F_SexCode FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID  
			WHERE A.F_EventID IN (3, 4, 6, 7) AND B.F_FederationID = @FederationID

	INSERT INTO @Table_Memeber (F_RegisterID, F_RegTypeID, F_SexCode) 
		SELECT B.F_MemberRegisterID, C.F_RegTypeID, C.F_SexCode FROM @Table_Memeber AS A LEFT JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TR_Register AS C ON B.F_MemberRegisterID = C.F_RegisterID  
			WHERE A.F_RegTypeID = 2 
	DELETE FROM @Table_Memeber WHERE F_RegTypeID = 2
	DELETE FROM @Table_Memeber WHERE F_SexCode <> @SexCode
	DECLARE @MemberCount AS INT
	SELECT @MemberCount = COUNT (DISTINCT F_RegisterID )  FROM @Table_Memeber
	RETURN @MemberCount
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO