IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_AR_GetTeamTotalScore]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_AR_GetTeamTotalScore]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Fun_AR_GetTeamTotalScore]
								(
									@PhaseCode					Varchar(10),
									@RegisterID					INT
								)
RETURNS INT
AS
BEGIN

	DECLARE @TotalPoints INT
	SET @TotalPoints = 0
	IF(@PhaseCode IN ('A','B','C','D'))
	BEGIN
		SET @TotalPoints =(SELECT SUM(T.F_Points) FROM (select TOP 3 A.F_Points from TR_Register AS R
									LEFT JOIN TR_Register AS RM ON R.F_DelegationID=RM.F_DelegationID AND RM.F_RegtypeID=1 AND R.F_SexCode=RM.F_SexCode 
									LEFT JOIN (SELECT F_RegisterID,F_Points FROM TS_Match_Result AS MR
											LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
											LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID 
											WHERE M.F_MatchCode = 'QR' AND P.F_PhaseCode =@PhaseCode) 
									AS A ON A.F_RegisterID = RM.F_RegisterID 
							WHERE R.F_RegisterID =@RegisterID AND R.F_RegtypeID=3 ORDER BY A.F_Points DESC) AS T)
	END
	ELSE IF(@PhaseCode ='X')
	BEGIN
		SET @TotalPoints =(
									(select TOP 1 A.F_Points from TR_Register AS R
												LEFT JOIN TR_Register AS RM ON R.F_DelegationID=RM.F_DelegationID 
															AND RM.F_RegtypeID=1 AND RM.F_SexCode =2
												LEFT JOIN (SELECT F_RegisterID,F_Points FROM TS_Match_Result AS MR
												LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
												LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID 
										WHERE M.F_MatchCode = 'QR' AND P.F_PhaseCode = 'A') 
										AS A ON A.F_RegisterID = RM.F_RegisterID
									WHERE R.F_RegisterID =@RegisterID ORDER BY A.F_Points DESC)
									+
									(select TOP 1 A.F_Points from TR_Register AS R
												LEFT JOIN TR_Register AS RM ON R.F_DelegationID=RM.F_DelegationID 
															AND RM.F_RegtypeID=1 AND RM.F_SexCode =1
												LEFT JOIN (SELECT F_RegisterID,F_Points FROM TS_Match_Result AS MR
												LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
												LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID 
										WHERE M.F_MatchCode = 'QR' AND P.F_PhaseCode = 'B') 
										AS A ON A.F_RegisterID = RM.F_RegisterID
									WHERE R.F_RegisterID =@RegisterID ORDER BY A.F_Points DESC)
							)
	END
	
	ELSE IF(@PhaseCode ='Y')
	BEGIN
		SET @TotalPoints =(
									(select TOP 1 A.F_Points from TR_Register_Member AS RM
												LEFT JOIN (SELECT F_RegisterID,F_Points FROM TS_Match_Result AS MR
												LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
												LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID 
										WHERE M.F_MatchCode = 'QR' AND P.F_PhaseCode = 'C') 
										AS A ON A.F_RegisterID = RM.F_MemberRegisterID
									WHERE RM.F_RegisterID =@RegisterID ORDER BY A.F_Points DESC)
									+
									(select TOP 1 A.F_Points from TR_Register_Member AS RM
												LEFT JOIN (SELECT F_RegisterID,F_Points FROM TS_Match_Result AS MR
												LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
												LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID 
										WHERE M.F_MatchCode = 'QR' AND P.F_PhaseCode = 'D') 
										AS A ON A.F_RegisterID = RM.F_MemberRegisterID
									WHERE RM.F_RegisterID =@RegisterID ORDER BY A.F_Points DESC)
						  )
	END
	RETURN @TotalPoints

END


GO


/*
select DBO.Fun_AR_GetTeamTotalScore('A',369)
*/