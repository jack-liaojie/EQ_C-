IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_Report_TE_GetDelegationPlayerCount]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_Report_TE_GetDelegationPlayerCount]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称: [Func_Report_TE_GetDelegationPlayerCount]
--描    述: 获取一个代表团，参加某个大项的某一性别的运动员的数据
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 
--修改记录：



CREATE FUNCTION [dbo].[Func_Report_TE_GetDelegationPlayerCount]
(
	@DisciplineID			INT,
	@DelegationID			INT,
	@SexCode				INT
)
RETURNS INT
AS
BEGIN

	DECLARE @PlayerCount AS INT
	SET @PlayerCount = 0
	DECLARE @T_Player AS TABLE(
									F_RegisterID		INT,
									F_RegTypeID			INT,
									F_SexCode			INT,
									F_Level				INT
							   )
	--INSERT INTO 
	--INSERT INTO @T_Player (F_RegisterID, F_RegTypeID, F_SexCode, F_Level)
	--	SELECT A.F_RegisterID, C.F_RegTypeID, C.F_SexCode, 0 AS F_Level  FROM TR_Inscription AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID 
	--		LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID
	--			WHERE B.F_DisciplineID = @DisciplineID AND C.F_DelegationID =@DelegationID AND C.F_RegTypeID IN (1, 2, 3) 
	
	--DECLARE @Level AS INT
	--SET @Level = 0
	--WHILE EXISTS(SELECT F_RegisterID FROM @T_Player WHERE F_Level = 0)
	--BEGIN
	--	SET @Level = @Level + 1
	--	UPDATE @T_Player SET F_Level = @Level WHERE F_Level = 0
		
	--	INSERT INTO @T_Player (F_RegisterID, F_RegTypeID, F_SexCode, F_Level)
	--		SELECT B.F_MemberRegisterID, C.F_RegTypeID, C.F_SexCode, 0 AS F_Level  
	--			FROM @T_Player AS A INNER JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_RegisterID
	--				LEFT JOIN TR_Register AS C ON B.F_MemberRegisterID = C.F_RegisterID
	--					WHERE A.F_Level = @Level AND A.F_RegTypeID IN (2, 3)
	
	--END

    INSERT INTO @T_Player (F_RegisterID, F_RegTypeID, F_SexCode)
       SELECT F_RegisterID, F_RegTypeID, F_SexCode
           FROM TR_Register
           WHERE F_DisciplineID = @DisciplineID AND F_DelegationID = @DelegationID AND F_RegTypeID = 1 AND F_SexCode = @SexCode
           
	SELECT @PlayerCount = COUNT(DISTINCT(F_RegisterID)) FROM @T_Player --WHERE F_RegTypeID = 1 AND F_SexCode = @SexCode
	RETURN @PlayerCount

END



GO
