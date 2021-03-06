IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Report_TE_GetPhaseName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Report_TE_GetPhaseName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[Fun_Report_TE_GetPhaseName]
								(
                                    @MatchID                INT,
                                    @LanguageCode           CHAR(3)
								)

RETURNS NVARCHAR(1000)
AS
BEGIN

    DECLARE @PhaseName NVARCHAR(1000)
    DECLARE @FatherPhaseName NVARCHAR(100)
    SET @PhaseName = ''
    SET @FatherPhaseName = ''

    DECLARE @PhaseID AS INT
    DECLARE @FatherPhaseID AS INT
    DECLARE @PhaseIsPool AS INT
    DECLARE @EventCode   AS NVARCHAR(10)
    DECLARE @PhaseCode   AS NVARCHAR(10)
    
    SELECT @PhaseID = B.F_PhaseID, @FatherPhaseID = B.F_FatherPhaseID, @PhaseIsPool = B.F_PhaseIsPool, @PhaseCode =B.F_PhaseCode,  @EventCode =  C.F_EventCode
       FROM TS_Match AS A 
           INNER JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_MatchID = @MatchID
           INNER JOIN TS_Event AS C ON B.F_EventID  = C.F_EventID
            
    SELECT @PhaseName = F_PhaseLongName FROM TS_Phase_Des WHERE F_PhaseID = @PhaseID AND F_LanguageCode = @LanguageCode
    
    IF @PhaseIsPool = 1
    BEGIN
		SELECT @FatherPhaseName = F_PhaseLongName FROM TS_Phase_Des WHERE F_PhaseID = @FatherPhaseID AND F_LanguageCode = @LanguageCode
	    
		IF @LanguageCode = 'ENG'
			BEGIN
			SET @PhaseName = @FatherPhaseName + ' ' + @PhaseName
			END
		ELSE IF @LanguageCode = 'CHN'
			BEGIN
			SET @PhaseName = @FatherPhaseName + @PhaseName
			END
    END
    ELSE
    BEGIN
        IF(@EventCode IN ('001', '101'))    
        BEGIN                            
           SET @PhaseName  = CASE @PhaseCode  WHEN '6' THEN '1' WHEN '5' THEN '2' WHEN '4' THEN '3' WHEN '3' THEN 'QF' WHEN '2' THEN 'SF' WHEN '1' THEN 'F' WHEN 'A'THEN 'CT.F' WHEN 'B' THEN 'CT.SF' WHEN 'C' THEN 'CT.QF' WHEN 'D' THEN 'CT.2' WHEN 'E' THEN 'CT.1'END

        END
        ELSE IF(@EventCode IN ('002', '102', '201'))
        BEGIN
           SET @PhaseName  = CASE @PhaseCode WHEN '5' THEN '1' WHEN '4' THEN '2' WHEN '3' THEN 'QF' WHEN '2' THEN 'SF' WHEN '1' THEN 'F' END 
        END 
        
    END
    
    
       
	RETURN @PhaseName
    

END




GO
