IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Report_BD_GetPhaseName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Report_BD_GetPhaseName]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[Fun_Report_BD_GetPhaseName]
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
    
    SELECT @PhaseID = B.F_PhaseID, @FatherPhaseID = B.F_FatherPhaseID, @PhaseIsPool = B.F_PhaseIsPool FROM TS_Match AS A INNER JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_MatchID = @MatchID
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
       
	RETURN @PhaseName
    

END



GO

