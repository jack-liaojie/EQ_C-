IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetFatherPhaseName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetFatherPhaseName]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create FUNCTION [dbo].[Fun_GetFatherPhaseName]
								(
									@PhaseID					INT
								)
RETURNS NVARCHAR(100)
AS
BEGIN

	DECLARE @FatherPhaseName AS NVARCHAR(300)
	DECLARE @PhaseName AS NVARCHAR(100)
	DECLARE @fatherPhaseID AS INT
	DECLARE @Row AS INT
	DECLARE @RowCount AS INT

	declare @table_phase as Table(f_order int, f_phasename nvarchar(100))
	
	set @fatherPhaseID = 0
	set @PhaseName = ''
	set @FatherPhaseName = ''
	set @Row = 1
	set @RowCount = 0

	select @fatherPhaseID = F_FatherPhaseID from ts_phase where f_phaseId=@PhaseID
	while @fatherPhaseID <>0
	begin
		select @PhaseName = F_PhaseShortName from ts_phase_des where f_phaseId = @fatherPhaseID and F_languageCode='CHN'
		select @fatherPhaseID = F_FatherPhaseID from ts_phase where f_phaseId = @fatherPhaseID
		insert into @table_phase(f_order, f_phasename)values(@row, @PhaseName)
		set @Row = @Row + 1
	end 

	select @RowCount = count(*) from @table_phase
	while @RowCount<>0
	begin
		select @PhaseName = f_phasename from @table_phase where f_order = @RowCount
		set @FatherPhaseName = @FatherPhaseName + @PhaseName
		set @rowCount = @RowCount -1
	end

	RETURN @FatherPhaseName

END

GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO