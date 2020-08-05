

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetQualificationMatchId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetQualificationMatchId]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

----作		  者：穆学峰
----日		  期: 2010-12-24 
----修改	记录:


CREATE FUNCTION [Func_SH_GetQualificationMatchId]
(
		@MatchID			INT
)
RETURNS @retTable		 TABLE(
								F_MatchID INT
							)
AS
BEGIN



		DECLARE @PhaseCode NVARCHAR(10)
		DECLARE @EventCode NVARCHAR(10)
		DECLARE @MatchCode NVARCHAR(10)
		DECLARE @EventInfo NVARCHAR(10)
		DECLARE @SexCode NVARCHAR(10)
		DECLARE @RegType INT
		
		SELECT  @EventCode = Event_Code,
				@PhaseCode = Phase_Code,
				@MatchCode = Match_Code,
				@EventInfo = Event_Info,
				@SexCode = Gender_Code,
				@RegType = RegType
				 
		FROM dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)

		IF @PhaseCode = '1'
		BEGIN
			SET @PhaseCode = '9'
		END
		
		-- 25M WOMNEN
		IF @SexCode = 'W' AND @EventInfo IN ('25P') AND @RegType = 1
		BEGIN
			INSERT @retTable(F_MatchID)
			SELECT M.F_MatchID FROM TS_Match AS M
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
			LEFT JOIN TS_Event AS E ON E.F_EventID = P.F_EventID
			WHERE E.F_EventInfo = @EventInfo 
					AND P.F_PhaseCode = @PhaseCode 
					AND M.F_MatchCode IN ('00')
					AND E.F_PlayerRegTypeID = @RegType
		END

		-- 25M MEN
		ELSE IF @SexCode = 'M' AND @EventInfo IN ('25RF') AND @RegType = 1
		BEGIN
			INSERT @retTable(F_MatchID)
			SELECT M.F_MatchID FROM TS_Match AS M
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
			LEFT JOIN TS_Event AS E ON E.F_EventID = P.F_EventID
			WHERE E.F_EventInfo = @EventInfo 
					AND P.F_PhaseCode = @PhaseCode 
					AND M.F_MatchCode IN ('02')
					AND E.F_PlayerRegTypeID = @RegType
		END

		ELSE
		BEGIN
			INSERT @retTable(F_MatchID)
			SELECT M.F_MatchID FROM TS_Match AS M
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
			LEFT JOIN TS_Event AS E ON E.F_EventID = P.F_EventID
			WHERE E.F_EventInfo = @EventInfo 
					AND P.F_PhaseCode = @PhaseCode 
					AND M.F_MatchCode IN ('01','02')
					AND E.F_PlayerRegTypeID = @RegType
		END
	
								
		RETURN 

END

GO


-- SELECT * FROM dbo.[Func_SH_GetQualificationMatchId] (102)
-- SELECT * FROM dbo.[Func_SH_GetQualificationMatchId] (74)
-- SELECT * FROM dbo.[Func_SH_GetMatchQualifiedlResult] (5)










