IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetMatchTeamName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetMatchTeamName]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[Fun_GetMatchTeamName]
								(
									@MatchID					INT,
									@CompetitionPosition		INT,
									@LanguageCode				CHAR(3)
								)
RETURNS NVARCHAR (100)
AS
BEGIN

	DECLARE @FederationShortName AS NVARCHAR(100)
	DECLARE @RegisterID		  AS INT
	SELECT @RegisterID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition

	declare @sourcePhaseid int
	declare @sourcePhaseRank int
	declare @soucePhaseName nvarchar(100)
	declare @sourceMatchid int
	declare @sourceMatchRank int
	declare @souceMatchName nvarchar(100)
	declare @MatchNum nvarchar(100)

	if(@RegisterID is null)
	begin
		SELECT @sourcePhaseid = F_SourcePhaseID FROM TS_Match_Result where  F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		if(@sourcePhaseid is null) -- continue to find source matchid
		begin
			SELECT @sourceMatchid = F_SourceMatchID FROM TS_Match_Result where  F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
			if(@sourceMatchid is not null)
			begin
				SELECT @MatchNum = F_MatchNum from ts_match where F_MatchID = @sourceMatchid
				SELECT @sourceMatchRank = F_SourceMatchRank FROM TS_Match_Result where  F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
				if(@sourceMatchRank=1) set @souceMatchName = @MatchNum + '胜'
				if(@sourceMatchRank=2) set @souceMatchName = @MatchNum + '负'
				set @FederationShortName = @souceMatchName
			end
		end

		else --- find source id
		begin
			SELECT @sourcePhaseRank = F_SourcePhaseRank FROM TS_Match_Result where  F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
			select @soucePhaseName = F_PhaseShortName from ts_phase_des where F_phaseId = @sourcePhaseid and F_languageCode = @LanguageCode
			set @FederationShortName = left(@soucePhaseName,1) + cast(@sourcePhaseRank as nvarchar(100))
		end
	end
	else
		SELECT @FederationShortName = B.F_FederationShortName FROM TR_Register as A Left join tc_federation_des as B on A.F_FederationID = B.F_FederationID where A.F_RegisterID = @RegisterID AND B.F_LanguageCode = 'CHN'

	RETURN @FederationShortName

END



GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO