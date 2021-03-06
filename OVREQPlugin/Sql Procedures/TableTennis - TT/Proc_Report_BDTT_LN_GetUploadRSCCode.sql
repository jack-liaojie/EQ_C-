IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BDTT_LN_GetUploadRSCCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BDTT_LN_GetUploadRSCCode]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_Report_BDTT_LN_GetUploadRSCCode]
----功		  能：获取辽宁全运会上传报表的RSC
----作		  者：王强
----日		  期: 2012-09-14 

CREATE PROCEDURE [dbo].[Proc_Report_BDTT_LN_GetUploadRSCCode]
    @EventID INT,
    @TeamFirstStage INT,
    @DateID INT
	
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @EventType INT
	DECLARE @PhaseType INT
	DECLARE @DateOrder INT
	
	SELECT @EventType = F_PlayerRegTypeID FROM TS_Event WHERE F_EventID = @EventID
	IF @TeamFirstStage = 1
	BEGIN
		SET @PhaseType = 1
	END
	ELSE
	BEGIN
		IF @EventType = 3
			SET @PhaseType = 2
		ELSE
			SET @PhaseType = 0
	END
	
	SELECT @DateOrder = F_DateOrder FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DateID
	IF @DateOrder IS NULL
	BEGIN
		SET @DateOrder = 0 
		SET @PhaseType = 0
	END
	SELECT dbo.Fun_Info_BDTT_LN_GetScheduleRSC(@EventID, @PhaseType, @DateOrder) + 'UP'
	
SET NOCOUNT OFF
END


GO

