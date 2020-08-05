IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_AR_GetTeamXor10]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_AR_GetTeamXor10]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Fun_AR_GetTeamXor10]
								(
									@PhaseCode					Varchar(10),
									@RegisterID					INT,
									@Type						INT -- 0:X;1:10
								)
RETURNS INT
AS
BEGIN

	DECLARE @TotalXs INT
	SET @TotalXs = 0
	DECLARE @Total10s INT
	SET @Total10s = 0
	IF(@PhaseCode IN ('A','B','C','D'))
	BEGIN
		SET @Total10s =(SELECT SUM(T.F_WinPoints) FROM (select TOP 3 A.F_Points,F_WinPoints from TR_Register AS R
									LEFT JOIN TR_Register AS RM ON R.F_DelegationID=RM.F_DelegationID AND RM.F_RegtypeID=1 AND R.F_SexCode=RM.F_SexCode 
									LEFT JOIN (SELECT F_RegisterID,F_Points,F_WinPoints FROM TS_Match_Result AS MR
											LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
											LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID 
											WHERE M.F_MatchCode = 'QR' AND P.F_PhaseCode =@PhaseCode) 
									AS A ON A.F_RegisterID = RM.F_RegisterID 
							WHERE R.F_RegisterID =@RegisterID AND R.F_RegtypeID=3 ORDER BY A.F_Points DESC) AS T)
		SET @TotalXs =(SELECT SUM(T.F_LosePoints) FROM (select TOP 3 A.F_Points,F_LosePoints from TR_Register AS R
									LEFT JOIN TR_Register AS RM ON R.F_DelegationID=RM.F_DelegationID AND RM.F_RegtypeID=1 AND R.F_SexCode=RM.F_SexCode 
									LEFT JOIN (SELECT F_RegisterID,F_Points,F_LosePoints FROM TS_Match_Result AS MR
											LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
											LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID 
											WHERE M.F_MatchCode = 'QR' AND P.F_PhaseCode =@PhaseCode) 
									AS A ON A.F_RegisterID = RM.F_RegisterID 
							WHERE R.F_RegisterID =@RegisterID AND R.F_RegtypeID=3 ORDER BY A.F_Points DESC) AS T)
	END
	
	DECLARE @IResult INT 
	IF(@Type=0)
	BEGIN
	SET @IResult= @TotalXs
	END
	ELSE 
	BEGIN
	SET @IResult=  @Total10s	
	END
	 
	RETURN @IResult

END


GO


/*
select DBO.Fun_AR_GetTeamXor10('A',369,0)
*/