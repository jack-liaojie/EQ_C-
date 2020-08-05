
/****** Object:  UserDefinedFunction [dbo].[Fun_GetMatchIRM]    Script Date: 06/14/2011 07:15:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Report_TE_GetMatchIRM]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Report_TE_GetMatchIRM]
GO


/****** Object:  UserDefinedFunction [dbo].[Fun_Report_TE_GetMatchIRM]    Script Date: 06/14/2011 07:15:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE FUNCTION [dbo].[Fun_Report_TE_GetMatchIRM]
								(
									@MatchID					INT,
									@Player1					nvarchar(100),
									@Player2					nvarchar(100),
									@LanguageCode				CHAR(3)
								)
RETURNS NVARCHAR (100)
AS
BEGIN

	DECLARE @IrmReturn AS NVARCHAR(100)
	set @IrmReturn = ''

	DECLARE @IrmName1 AS NVARCHAR(100)
	DECLARE @IrmName2 AS NVARCHAR(100)
	DECLARE @IRMID1 INT
	DECLARE @IRMID2 INT
	DECLARE @ResultID  AS INT

	--SELECT @ResultID = F_RegisterID FROM TS_Match WHERE F_MatchID = @MatchID
	SELECT @IRMID1 = F_IRMID from ts_match_result where F_matchid = @MatchID and F_CompetitionPosition=1
	SELECT @IRMID2 = F_IRMID from ts_match_result where F_matchid = @MatchID and F_CompetitionPosition=2

	select @IrmName1 = F_IrmShortName from tc_irm_des where F_irmid = @IRMID1 and F_languageCode = @LanguageCode
	select @IrmName2 = F_IrmShortName from tc_irm_des where F_irmid = @IRMID2 and F_languageCode = @LanguageCode

	if(@IRMID1 is not Null) set @IrmReturn = @Player1 + @IrmName1
	if(@IRMID2 is not Null) set @IrmReturn = @Player2 + @IrmName2
	
	RETURN @IrmReturn

END



GO


