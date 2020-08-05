if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_GetPhaseInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_GetPhaseInfo]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_GetPhaseInfo]
----功		  能：得到赛事阶段的信息
----作		  者：郑金勇 
----日		  期: 2009-05-08

CREATE PROCEDURE [dbo].[Proc_GetPhaseInfo] (	
	@PhaseID					INT,
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
	
SET NOCOUNT ON

	SELECT * FROM TS_Phase AS A LEFT JOIN TS_Phase_Des AS B
					  ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode WHERE A.F_PhaseID = @PhaseID 

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

