
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SH_UpdateSecondMatchScore]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SH_UpdateSecondMatchScore]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_SH_UpdateSecondMatchScore]
----功		  能：25米 更新第二组成绩
----作		  者：穆学峰 
----日		  期: 2011-03-25

CREATE PROCEDURE [dbo].[Proc_SH_UpdateSecondMatchScore] (	
	@MatchID					INT
)	
AS
BEGIN
	
SET NOCOUNT ON



SET NOCOUNT OFF
END

GO

-- EXEC Proc_SH_UpdateSecondMatchScore 1