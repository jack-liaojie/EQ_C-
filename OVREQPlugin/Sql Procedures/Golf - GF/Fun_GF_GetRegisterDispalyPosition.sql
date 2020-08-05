IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GF_GetRegisterDispalyPosition]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GF_GetRegisterDispalyPosition]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		吴定昉
-- Create date: 2011/08/02
-- Description:	统计当前的显示顺序
-- =============================================

CREATE FUNCTION [dbo].[Fun_GF_GetRegisterDispalyPosition]
								(
								    @PhaseOrder                 INT,
									@R1DisPos					INT,
									@R2DisPos                   INT,
									@R3DisPos                   INT,								
									@R4DisPos                   INT
								)
RETURNS INT
AS
BEGIN

    DECLARE @DisPos AS INT
    
    IF @PhaseOrder = 1
    BEGIN
        SET @DisPos = @R1DisPos
    END
    ELSE IF @PhaseOrder = 2
    BEGIN
        IF @R2DisPos is not null 
           SET @DisPos = @R2DisPos
        ELSE
           SET @DisPos = @R1DisPos
    END
    ELSE IF @PhaseOrder = 3
    BEGIN
        IF @R3DisPos is not null 
           SET @DisPos = @R3DisPos
        ELSE IF @R2DisPos is not null 
           SET @DisPos = @R2DisPos
        ELSE
           SET @DisPos = @R1DisPos
    END
    ELSE IF @PhaseOrder = 4
    BEGIN
        IF @R4DisPos is not null 
           SET @DisPos = @R4DisPos
        ELSE IF @R3DisPos is not null 
           SET @DisPos = @R3DisPos
        ELSE IF @R2DisPos is not null 
           SET @DisPos = @R2DisPos
        ELSE
           SET @DisPos = @R1DisPos
    END

    
	RETURN @DisPos

END


GO


