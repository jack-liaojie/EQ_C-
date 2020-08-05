IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GF_GetTeamRoundHoleInfo]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GF_GetTeamRoundHoleInfo]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Îâ¶¨•P
-- Create date: 2011/07/08
-- Description:	
-- =============================================

CREATE FUNCTION [dbo].[Fun_GF_GetTeamRoundHoleInfo]
								(
								    @EventID                    INT,
									@TeamID					    INT,
									@PhaseOrder                 INT,
									@Type                       INT	--1£º¸ËÊý 2£ºPar  3: IRMCode
								)
RETURNS NVARCHAR(10)
AS
BEGIN

    DECLARE @ResultNum AS NVARCHAR(10)
	DECLARE @SexCode AS INT
	DECLARE @IndividualEventID AS INT
    DECLARE @MatchID AS INT
    DECLARE @MatchIDR1 AS INT
    DECLARE @MatchIDR2 AS INT
    DECLARE @MatchIDR3 AS INT
    DECLARE @MatchIDR4 AS INT
    DECLARE @PlayerNum AS INT
       
    SELECT TOP 1 @MatchID = M.F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    WHERE M.F_Order = 1 AND P.F_Order = @PhaseOrder AND P.F_EventID = @EventID

    SELECT TOP 1 @MatchIDR1 = M.F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    WHERE M.F_Order = 1 AND P.F_Order = 1 AND P.F_EventID = @EventID
    SELECT TOP 1 @MatchIDR2 = M.F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    WHERE M.F_Order = 1 AND P.F_Order = 2 AND P.F_EventID = @EventID
    SELECT TOP 1 @MatchIDR3 = M.F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    WHERE M.F_Order = 1 AND P.F_Order = 3 AND P.F_EventID = @EventID
    SELECT TOP 1 @MatchIDR4 = M.F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    WHERE M.F_Order = 1 AND P.F_Order = 4 AND P.F_EventID = @EventID

    SELECT @SexCode = E.F_SexCode, @IndividualEventID = E.F_EventID, @PhaseOrder = P.F_Order FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID WHERE M.F_MatchID = @MatchID

    SET @PlayerNum = (CASE WHEN @SexCode = 1 THEN 3 WHEN @SexCode = 2 THEN 2 ELSE 0 END)

	IF @Type = 1 --Hole Number
	BEGIN
	    SET @ResultNum = NULL
	END
	ELSE IF @Type = 2 --Par
	BEGIN
	    SET @ResultNum = NULL
	END
	ELSE IF @Type = 3 --IRMID
	BEGIN
	    DECLARE @Temp_Table AS TABLE(F_Order INT, F_RegisterID INT, F_IRMID1 INT,F_IRMID2 INT,F_IRMID3 INT,F_IRMID4 INT,F_IRMID INT, 
	    F_IRMCode1 NVARCHAR(10),F_IRMCode2 NVARCHAR(10),F_IRMCode3 NVARCHAR(10),F_IRMCode4 NVARCHAR(10),F_IRMCode NVARCHAR(10))
	    INSERT INTO @Temp_Table(F_Order, F_RegisterID, F_IRMID1, F_IRMID2,F_IRMID3,F_IRMID4,F_IRMCode1,F_IRMCode2,F_IRMCode3,F_IRMCode4) 
	    SELECT RM.F_Order, RM.F_MemberRegisterID, MRR1.F_IRMID, MRR2.F_IRMID, MRR3.F_IRMID, MRR4.F_IRMID, 
	    I1.F_IRMCODE, I2.F_IRMCODE, I3.F_IRMCODE, I4.F_IRMCODE FROM TS_Match_Result AS MRR1 
	    LEFT JOIN TR_Register_Member AS RM ON MRR1.F_RegisterID = RM.F_MemberRegisterID
	    LEFT JOIN TS_Match_Result AS MRR2 ON MRR2.F_MatchID = @MatchIDR2 AND MRR2.F_RegisterID = MRR1.F_RegisterID 
	    LEFT JOIN TS_Match_Result AS MRR3 ON MRR3.F_MatchID = @MatchIDR3 AND MRR3.F_RegisterID = MRR1.F_RegisterID 
	    LEFT JOIN TS_Match_Result AS MRR4 ON MRR4.F_MatchID = @MatchIDR4 AND MRR4.F_RegisterID = MRR1.F_RegisterID 
	    LEFT JOIN TC_IRM AS I1 ON MRR1.F_IRMID = I1.F_IRMID
	    LEFT JOIN TC_IRM AS I2 ON MRR2.F_IRMID = I2.F_IRMID
	    LEFT JOIN TC_IRM AS I3 ON MRR3.F_IRMID = I3.F_IRMID
	    LEFT JOIN TC_IRM AS I4 ON MRR4.F_IRMID = I4.F_IRMID
	    WHERE RM.F_RegisterID = @TeamID AND MRR1.F_MatchID = @MatchIDR1 
	    AND (MRR1.F_IRMID IS NOT NULL OR MRR2.F_IRMID IS NOT NULL OR MRR3.F_IRMID IS NOT NULL OR MRR4.F_IRMID IS NOT NULL)
	    
	    update @Temp_Table set F_IRMCode = [dbo].[Fun_GF_GetTotalIRMCode](@PhaseOrder,f_irmcode1,F_IRMCode2,F_IRMCode3,F_IRMCode4)
	    update @Temp_Table set F_IRMID = [dbo].[Fun_GF_GetIRMID] (f_irmcode)
	    
	    DECLARE @OkNum INT 
	    SET @OkNum = (SELECT COUNT(*) FROM TR_Register_Member WHERE F_RegisterID = @TeamID) - (SELECT COUNT(*) FROM @Temp_Table)
	    DECLARE @CanDelNum INT 
	    SET @CanDelNum = (SELECT COUNT(*) FROM TR_Register_Member WHERE F_RegisterID = @TeamID) - @PlayerNum
	    
	    IF @OkNum < @PlayerNum
	    BEGIN	    
			DECLARE @Count  INT 
			/*
			SELECT @Count = COUNT(*) FROM @Temp_Table WHERE F_IRMCode = 'DQ'
			IF @Count > @CanDelNum
			   SET @ResultNum = 'DQ'
			ELSE 
			BEGIN
			   WHILE (@Count <> 0)
			   BEGIN
			        DELETE FROM @Temp_Table WHERE F_RegisterID = ( SELECT TOP 1 F_RegisterID FROM @Temp_Table WHERE F_IRMCode = 'DQ') 
					SET @CanDelNum = @CanDelNum - 1
					SELECT @Count = COUNT(*) FROM @Temp_Table WHERE F_IRMCode = 'DQ'
			   END
			END
			*/   
			   
			SELECT @Count = COUNT(*) FROM @Temp_Table WHERE F_IRMCode = 'WD'
			IF @Count > @CanDelNum
			   SET @ResultNum = 'WD'
			ELSE 
			BEGIN
			   WHILE (@Count <> 0)
			   BEGIN
			        DELETE FROM @Temp_Table WHERE F_RegisterID = ( SELECT TOP 1 F_RegisterID FROM @Temp_Table WHERE F_IRMCode = 'WD') 
					SET @CanDelNum = @CanDelNum - 1
					SELECT @Count = COUNT(*) FROM @Temp_Table WHERE F_IRMCode = 'WD'
			   END
			END   
			
			SELECT @Count = COUNT(*) FROM @Temp_Table WHERE F_IRMCode = 'RTD'
			IF @Count > @CanDelNum
			   SET @ResultNum = 'RTD'
			ELSE 
			BEGIN
			   WHILE (@Count <> 0)
			   BEGIN
			        DELETE FROM @Temp_Table WHERE F_RegisterID = ( SELECT TOP 1 F_RegisterID FROM @Temp_Table WHERE F_IRMCode = 'RTD') 
					SET @CanDelNum = @CanDelNum - 1
					SELECT @Count = COUNT(*) FROM @Temp_Table WHERE F_IRMCode = 'RTD'
			   END
			END   			
	    END
	END
    
	RETURN @ResultNum

END


GO


