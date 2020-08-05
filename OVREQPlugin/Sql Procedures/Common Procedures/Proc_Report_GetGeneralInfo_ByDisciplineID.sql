IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GetGeneralInfo_ByDisciplineID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GetGeneralInfo_ByDisciplineID]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

----存储过程名称：[Proc_Report_GetGeneralInfo_ByDisciplineID]
----功		  能：获得报表所需的基本信息
----作		  者：余远华
----日		  期: 2010-03-30 

CREATE PROCEDURE [dbo].[Proc_Report_GetGeneralInfo_ByDisciplineID]
				@DisciplineID	INT,
				@VenueCode		NVARCHAR(50),
				@LanguageCode	CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH
    
    DECLARE @VenueID AS INT
    SET @VenueID = -1

    CREATE TABLE #table_Tmp(
						[DisciplineCode]	CHAR(2),
		                [DisciplineName]	NVARCHAR(100),
                        [VenueName]         NVARCHAR(100),		-- 指定到项目的场馆，没有考虑多场馆的情况
                        [CurrentDate]		NVARCHAR(30),
                        [CurrentTime]		NVARCHAR(30),
                        [Report_CreateDate] NVARCHAR(30),
                        [RSC_Code]			NVARCHAR(100),
                                  )
    INSERT INTO #table_Tmp([DisciplineCode]) VALUES(N'00')
    
	SELECT @VenueID = TDV.F_VenueID
		FROM TD_Discipline_Venue AS TDV 
			LEFT JOIN TC_Venue AS TV ON TV.F_VenueID = TDV.F_VenueID 
		WHERE TDV.F_DisciplineID = @DisciplineID AND TV.F_VenueCode = @VenueCode
	
	IF @VenueID = -1
		BEGIN
			SELECT @VenueID = F_VenueID 
				FROM TD_Discipline_Venue
				WHERE F_DisciplineID = @DisciplineID 
		END
	
	-- 参数 @DisciplineID 有效
	IF @DisciplineID > 0
	BEGIN
		UPDATE #table_Tmp
			SET	  [DisciplineCode] = TD.F_DisciplineCode
				, [DisciplineName] =UPPER(TDD.F_DisciplineLongName)
				, [VenueName] = UPPER(TVD.F_VenueShortName)
			FROM TS_Discipline AS TD
				LEFT JOIN TS_Discipline_Des AS TDD ON TDD.F_DisciplineID = TD.F_DisciplineID AND TDD.F_LanguageCode = @LanguageCode
				LEFT JOIN TC_Venue_Des AS TVD ON TVD.F_VenueID = @VenueID AND TVD.F_LanguageCode = @LanguageCode
			WHERE TD.F_DisciplineID = @DisciplineID
	END
	
	
    UPDATE #table_Tmp SET [RSC_Code] = [DisciplineCode] + N'0000000'
    UPDATE #table_Tmp SET [CurrentDate] = [dbo].[Func_Report_GetDateTime](GETDATE(), 2)
    UPDATE #table_Tmp SET [CurrentTime] = [dbo].[Func_Report_GetDateTime](GETDATE(), 3)
    UPDATE #table_Tmp SET [Report_CreateDate] = [dbo].[Func_Report_GetDateTime](GETDATE(), 1)

    SELECT * FROM #table_Tmp

Set NOCOUNT OFF
End


/*

-- Just for test
EXEC [Proc_Report_GetGeneralInfo_ByDisciplineID] 68, 'GZV', 'ENG'
EXEC [Proc_Report_GetGeneralInfo_ByDisciplineID] 68, 'NONE', 'CHN'

SELECT * FROM TS_Discipline WHERE F_DisciplineID = 68
*/