IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GF_GetIRMID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GF_GetIRMID]
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

CREATE FUNCTION [dbo].[Fun_GF_GetIRMID]
								(
									@IRMCode	NVARCHAR(10)
								)
RETURNS INT
AS
BEGIN

    DECLARE @IRMID AS INT
    
    select @IRMID = F_IRMID from TC_IRM where F_IRMCODE COLLATE Chinese_PRC_CI_AS = @IRMCode COLLATE Chinese_PRC_CI_AS
    
	RETURN @IRMID

END


GO


