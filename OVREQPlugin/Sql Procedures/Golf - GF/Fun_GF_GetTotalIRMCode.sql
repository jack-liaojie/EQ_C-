IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GF_GetTotalIRMCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GF_GetTotalIRMCode]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		吴定昉
-- Create date: 2011/08/02
-- Description:	统计当前的IRM信息
-- =============================================

CREATE FUNCTION [dbo].[Fun_GF_GetTotalIRMCode]
								(
								    @PhaseOrder        INT,
									@IRMCodeR1		   NVARCHAR(10),
									@IRMCodeR2         NVARCHAR(10),
									@IRMCodeR3         NVARCHAR(10),								
									@IRMCodeR4         NVARCHAR(10)
								)
RETURNS NVARCHAR(10)
AS
BEGIN

    DECLARE @IRMCode AS NVARCHAR(10)
    
    IF @PhaseOrder = 1
    BEGIN
        SET @IRMCode = @IRMCodeR1
    END
    ELSE IF @PhaseOrder = 2
    BEGIN
        IF @IRMCodeR1 = 'DQ' OR @IRMCodeR2 = 'DQ'
           SET @IRMCode = 'DQ' 
        IF @IRMCodeR1 = 'WD' OR @IRMCodeR2 = 'WD'
           SET @IRMCode = 'WD' 
        IF @IRMCodeR1 = 'RTD' OR @IRMCodeR2 = 'RTD'
           SET @IRMCode = 'RTD' 
    END
    ELSE IF @PhaseOrder = 3
    BEGIN
        IF @IRMCodeR1 = 'DQ' OR @IRMCodeR2 = 'DQ' OR @IRMCodeR3 = 'DQ'
           SET @IRMCode = 'DQ' 
        IF @IRMCodeR1 = 'WD' OR @IRMCodeR2 = 'WD' OR @IRMCodeR3 = 'WD'
           SET @IRMCode = 'WD' 
        IF @IRMCodeR1 = 'RTD' OR @IRMCodeR2 = 'RTD' OR @IRMCodeR3 = 'RTD'
           SET @IRMCode = 'RTD' 
    END
    ELSE IF @PhaseOrder = 4
    BEGIN
        IF @IRMCodeR1 = 'DQ' OR @IRMCodeR2 = 'DQ' OR @IRMCodeR3 = 'DQ' OR @IRMCodeR4 = 'DQ'
           SET @IRMCode = 'DQ' 
        IF @IRMCodeR1 = 'WD' OR @IRMCodeR2 = 'WD' OR @IRMCodeR3 = 'WD' OR @IRMCodeR4 = 'WD'
           SET @IRMCode = 'WD' 
        IF @IRMCodeR1 = 'RTD' OR @IRMCodeR2 = 'RTD' OR @IRMCodeR3 = 'RTD' OR @IRMCodeR4 = 'RTD'
           SET @IRMCode = 'RTD' 
    END
    
	RETURN @IRMCode

END


GO


