IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_RPDS_GetRscDescription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_RPDS_GetRscDescription]
GO

/****** Object:  StoredProcedure [dbo].[Proc_RPDS_GetRscDescription]    Script Date: 04/22/2010 11:27:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--名    称：[Proc_RPDS_GetRscDescription]
--描    述：获得RSC描述
--参数说明： 
--说    明：
--创 建 人：余远华
--日    期：2010年08月04日


CREATE PROCEDURE [dbo].[Proc_RPDS_GetRscDescription](
												@RSC				NVARCHAR(10),
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	DECLARE @DisciplineCode	    CHAR(2)
	DECLARE @GenderCode		    CHAR(1)
	DECLARE @EventCode		    CHAR(3)
	DECLARE @PhaseCode		    CHAR(1)
	DECLARE @UnitCode		    CHAR(2)
	DECLARE @Description		NVARCHAR(200)
	
	SET @DisciplineCode	= SUBSTRING(@RSC, 1, 2)
	SET @GenderCode		= SUBSTRING(@RSC, 3, 1)
	SET @EventCode		= SUBSTRING(@RSC, 4, 3)
	SET @PhaseCode		= SUBSTRING(@RSC, 7, 1)
	SET @UnitCode		= SUBSTRING(@RSC, 8, 2)
	SET @Description	= N''
	
	IF (SUBSTRING(@RSC, 4, 6) = N'000000')
	BEGIN
		SELECT TOP 1 @Description = SDD.F_DisciplineLongName
			FROM TS_Discipline AS SD
				LEFT JOIN TS_Discipline_Des AS SDD ON SDD.F_DisciplineID = SD.F_DisciplineID  AND SDD.F_LanguageCode = @LanguageCode
			WHERE SD.F_DisciplineCode = @DisciplineCode 

		IF (@GenderCode != N'0')
		BEGIN
			SELECT TOP 1 @Description = @Description + N' - ' + CSD.F_SexLongName
				FROM TC_Sex AS CS
					LEFT JOIN TC_Sex_Des AS CSD ON CSD.F_SexCode = CS.F_SexCode  AND CSD.F_LanguageCode = @LanguageCode
				WHERE CS.F_GenderCode = @GenderCode 
		END
		
		SELECT @Description AS [Description]
		RETURN
	END

	SELECT TOP 1 @Description = SED.F_EventLongName
		FROM TS_Event AS SE
			LEFT JOIN TS_Event_Des AS SED ON SED.F_EventID = SE.F_EventID  AND SED.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Discipline AS SD ON SD.F_DisciplineID = SE.F_DisciplineID
			LEFT JOIN TC_Sex AS CS ON CS.F_SexCode = SE.F_SexCode
		WHERE SD.F_DisciplineCode = @DisciplineCode 
			AND CS.F_GenderCode = @GenderCode 
			AND SE.F_EventCode = @EventCode 

	SELECT TOP 1 @Description = @Description + N' - ' + SPD.F_PhaseLongName
		FROM TS_Phase AS SP
			LEFT JOIN TS_Phase_Des AS SPD ON SPD.F_PhaseID = SP.F_PhaseID  AND SPD.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Event AS SE ON SE.F_EventID = SP.F_EventID 
			LEFT JOIN TS_Discipline AS SD ON SD.F_DisciplineID = SE.F_DisciplineID
			LEFT JOIN TC_Sex AS CS ON CS.F_SexCode = SE.F_SexCode
		WHERE SD.F_DisciplineCode = @DisciplineCode 
			AND CS.F_GenderCode = @GenderCode 
			AND SE.F_EventCode = @EventCode 
			AND SP.F_PhaseCode = @PhaseCode 

	SELECT TOP 1 @Description = @Description + N' - ' + SMD.F_MatchLongName
		FROM TS_Match AS SM
			LEFT JOIN TS_Match_Des AS SMD ON SMD.F_MatchID = SM.F_MatchID  AND SMD.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Phase AS SP ON SP.F_PhaseID = SM.F_PhaseID 
			LEFT JOIN TS_Event AS SE ON SE.F_EventID = SP.F_EventID 
			LEFT JOIN TS_Discipline AS SD ON SD.F_DisciplineID = SE.F_DisciplineID
			LEFT JOIN TC_Sex AS CS ON CS.F_SexCode = SE.F_SexCode
		WHERE SD.F_DisciplineCode = @DisciplineCode 
			AND CS.F_GenderCode = @GenderCode 
			AND SE.F_EventCode = @EventCode 
			AND SP.F_PhaseCode = @PhaseCode 
			AND SM.F_MatchCode = @UnitCode 

	SELECT @Description AS [Description]
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

/* 
-- Just for test

EXEC Proc_RPDS_GetRscDescription RSM002301, 'ENG'

*/


