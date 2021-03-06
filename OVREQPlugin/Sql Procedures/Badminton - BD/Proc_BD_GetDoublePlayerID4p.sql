IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_GetDoublePlayerID4p]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_GetDoublePlayerID4p]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_BD_GetDoublePlayerID4p]
----功		  能：获取双打的4个人的ID
----作		  者：王强
----日		  期: 2011-03-12 

CREATE PROCEDURE [dbo].[Proc_BD_GetDoublePlayerID4p]
    @MatchID INT,
	@MatchSplitID INT = -1
AS
BEGIN
	
SET NOCOUNT ON

	IF @MatchSplitID <= -1
		BEGIN
			SELECT B1.F_MemberRegisterID, B2.F_MemberRegisterID, B3.F_MemberRegisterID, B4.F_MemberRegisterID FROM TS_Match AS A
			LEFT JOIN TS_Match_Result AS C1 ON C1.F_MatchID = A.F_MatchID AND C1.F_CompetitionPositionDes1 = 1
			LEFT JOIN TR_Register_Member AS B1 ON B1.F_RegisterID = C1.F_RegisterID AND B1.F_Order = 1
			LEFT JOIN TR_Register_Member AS B2 ON B2.F_RegisterID = C1.F_RegisterID AND B2.F_Order = 2
			LEFT JOIN TS_Match_Result AS C2 ON C2.F_MatchID = A.F_MatchID AND C2.F_CompetitionPositionDes1 = 2
			LEFT JOIN TR_Register_Member AS B3 ON B3.F_RegisterID = C2.F_RegisterID AND B3.F_Order = 1
			LEFT JOIN TR_Register_Member AS B4 ON B4.F_RegisterID = C2.F_RegisterID AND B4.F_Order = 2
			WHERE A.F_MatchID = @MatchID AND B1.F_MemberRegisterID IS NOT NULL
		END
	ELSE
		BEGIN

			SELECT C1.F_MemberRegisterID, C2.F_MemberRegisterID, C3.F_MemberRegisterID, C4.F_MemberRegisterID FROM TS_Match_Split_Info AS A
			LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = 1
			LEFT JOIN TR_Register_Member AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_Order = 1
			LEFT JOIN TR_Register_Member AS C2 ON C2.F_RegisterID = B1.F_RegisterID AND C2.F_Order = 2
			LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = 2
			LEFT JOIN TR_Register_Member AS C3 ON C3.F_RegisterID = B2.F_RegisterID AND C3.F_Order = 1
			LEFT JOIN TR_Register_Member AS C4 ON C4.F_RegisterID = B2.F_RegisterID AND C4.F_Order = 2
			WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @MatchSplitID
			
		END
	

SET NOCOUNT OFF
END


GO

