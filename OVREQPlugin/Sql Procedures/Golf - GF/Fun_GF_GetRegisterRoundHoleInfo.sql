IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GF_GetRegisterRoundHoleInfo]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GF_GetRegisterRoundHoleInfo]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		张翠霞
-- Create date: 2010/10/05
-- Description:	统计Event排名
-- =============================================

CREATE FUNCTION [dbo].[Fun_GF_GetRegisterRoundHoleInfo]
								(
								    @EventID                    INT,
									@RegisterID					INT,
									@PhaseOrder                 INT,
									@Type                       INT	--1：杆数 2：Par  3: IRMID
								)
RETURNS INT
AS
BEGIN

    DECLARE @ResultNum AS INT
    DECLARE @MatchID AS INT
    SET @ResultNum = 0
    
    SELECT TOP 1 @MatchID = M.F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    WHERE M.F_Order = 1 AND P.F_Order = @PhaseOrder AND P.F_EventID = @EventID

	IF @Type = 1 --Hole Number
	BEGIN
	    SELECT @ResultNum = CAST(F_PointsCharDes1 AS INT) FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_RegisterID = @RegisterID
	END
	ELSE IF @Type = 2 --Par
	BEGIN
	    SELECT @ResultNum = CAST(F_PointsCharDes2 AS INT) FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_RegisterID = @RegisterID
	END
	ELSE IF @Type = 3 --IRMID
	BEGIN
	    SELECT @ResultNum = F_IRMID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_RegisterID = @RegisterID
	END
    
	RETURN @ResultNum

END


GO


