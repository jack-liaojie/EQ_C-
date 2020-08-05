IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetEventCommonCodeInfo]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetEventCommonCodeInfo]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

----作		  者：穆学峰
----日		  期: 2010-12-24 
----修改	记录:


CREATE FUNCTION [Func_SH_GetEventCommonCodeInfo]
(
		@MatchID			INT
)
RETURNS @retTable		 TABLE(
							Discipline_Code NVARCHAR(10),
							Gender_Code NVARCHAR(10),
							Event_Code NVARCHAR(10),
							Phase_Code NVARCHAR(10),
							Match_Code NVARCHAR(10),
							Stage_Count INT,
							Series_Count INT,
							Event_Info NVARCHAR(50),
							RegType INT -- 3 IS TEAM
							)
AS
BEGIN

		--根据EventCode来决定有几个Stage和Series
		
		DECLARE @EventCode NVARCHAR(10)
		DECLARE @PhaseCode NVARCHAR(10)
		DECLARE @MatchCode NVARCHAR(10)
		DECLARE @GenderCode NVARCHAR(10)
		DECLARE @DisciplineCode NVARCHAR(10)
		DECLARE @StageCount INT
		DECLARE @SeriesCount INT
		DECLARE @EventInfo NVARCHAR(50)
		DECLARE @RegType INT

		SELECT  @MatchCode = M.F_MatchCode,
				@EventCode = E.F_EventCode,
				@PhaseCode = P.F_PhaseCode,
				@GenderCode = S.F_GenderCode,
				@DisciplineCode = D.F_DisciplineCode,
				@EventInfo = E.F_EventInfo,
				@RegType = E.F_PlayerRegTypeID
		FROM TS_Match M
		LEFT JOIN TS_Phase P ON P.F_PhaseID = M.F_PhaseID
		LEFT JOIN TS_Event E ON E.F_EventID = P.F_EventID
		LEFT JOIN TC_SEX S ON S.F_SexCode = E.F_SexCode
		LEFT JOIN TS_Discipline D ON D.F_DisciplineID = E.F_DisciplineID
		WHERE M.F_MatchID = @MatchID

		IF @GenderCode = 'M'
		BEGIN
			IF @EventInfo IN ( '10AP', '10AR', '50P', '50RP' )
			BEGIN
				SET @StageCount = 1
				SET @SeriesCount = 6
			END
			
			IF @EventInfo IN ( '25RF' )
			BEGIN
				SET @StageCount = 2
				SET @SeriesCount = 3
			END

			IF @EventInfo IN ( '25P' )
			BEGIN
				SET @StageCount = 3
				SET @SeriesCount = 2
			END

			IF @EventInfo IN ( 'SKEET','TRAP' )
			BEGIN
				SET @StageCount = 1
				SET @SeriesCount = 5
			END

			IF @EventInfo IN ( 'DOUBLETRAP' )
			BEGIN
				SET @StageCount = 1
				SET @SeriesCount = 3
			END
												
		END
		
		
		IF @GenderCode = 'W'
		BEGIN
			IF @EventInfo IN ('50RP' )
			BEGIN
				SET @StageCount = 1
				SET @SeriesCount = 6
			END

			IF @EventInfo IN ( '10AP', '10AR' )
			BEGIN
				SET @StageCount = 1
				SET @SeriesCount = 4
			END
			
			IF @EventInfo IN ( '25P' )
			BEGIN
				SET @StageCount = 2
				SET @SeriesCount = 3
			END
			
			IF @EventInfo IN ( '503P' )
			BEGIN
				SET @StageCount = 3
				SET @SeriesCount = 4
			END

			IF @EventInfo IN ( '50R3P' )
			BEGIN
				SET @StageCount = 3
				SET @SeriesCount = 2
			END
	
			IF @EventInfo IN ( 'SKEET','TRAP' )
			BEGIN
				SET @StageCount = 1
				SET @SeriesCount = 3
			END
												
		END
		

		INSERT INTO @retTable(Discipline_Code, Event_Code, Gender_Code, Phase_Code, Match_Code, Stage_Count, Series_Count, Event_Info, RegType)
		VALUES(@DisciplineCode, @EventCode, @GenderCode, @PhaseCode, @MatchCode, @StageCount, @SeriesCount, @EventInfo, @RegType)

				
		RETURN 

END

GO


-- SELECT * FROM dbo.[Func_SH_GetEventCommonCodeInfo] (1)
-- SELECT * FROM dbo.[Func_SH_GetEventCommonCodeInfo] (27)

-- SUM(ISNULL(CAST(F_ActionDetail1 AS INT),0))/10 