IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Report_BD_TT_GetDlgCodeForTeam]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Report_BD_TT_GetDlgCodeForTeam]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		王强
-- Create date: 2011/1/13
-- Description:	获取团队比赛时的代表团Code，主要是解决双打临时组合无DelegationID的问题
-- =============================================

CREATE FUNCTION [dbo].[Fun_Report_BD_TT_GetDlgCodeForTeam]
								(
									@MatchID   INT,
									@MatchSplitID INT,
									@PosID INT,
									@LanguageCode NVARCHAR(10)
								)
RETURNS NVARCHAR(20)
AS
BEGIN

	DECLARE @RegisterID INT
	DECLARE @TypeID INT
	DECLARE @DelegationCode NVARCHAR(20)
	SELECT @RegisterID = X.F_RegisterID
	FROM TS_Match_Split_Result AS X 
	WHERE X.F_MatchID = @MatchID AND X.F_MatchSplitID = @MatchSplitID AND X.F_CompetitionPosition = @PosID
	
	IF @RegisterID IS NULL
		RETURN ''
	
	--判断类型
	SELECT @TypeID = F_RegTypeID FROM TR_Register WHERE F_RegisterID = @RegisterID
	--如果是double
	IF @TypeID = 2
		BEGIN
			--如果组合是临时组合(没有delegtionID)
			IF NOT EXISTS (SELECT F_DelegationID FROM TR_Register WHERE F_RegisterID = @RegisterID AND (F_DelegationID IS NOT NULL) )
				BEGIN
					--取组合的成员
					SELECT @RegisterID = MAX(F_MemberRegisterID) FROM TR_Register_Member WHERE F_RegisterID = @RegisterID
					IF @RegisterID IS NULL
						RETURN ''
				END
		END
	
	
	SELECT @DelegationCode = B.F_DelegationShortName FROM TR_Register AS A
	LEFT JOIN TC_Delegation_Des AS B ON B.F_DelegationID = A.F_DelegationID AND B.F_LanguageCode = @LanguageCode
	WHERE A.F_RegisterID = @RegisterID
	
	RETURN @DelegationCode

END

GO

