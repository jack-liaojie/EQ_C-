IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Prepare_AddEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Prepare_AddEvent]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Prepare_AddEvent]
--描    述: 准备基础数据时添加小项.
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2010年9月14日 星期二
--修改记录：
/*			
			日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Prepare_AddEvent]
	@DisciplineCode						CHAR(2),
	@EventCode							NVARCHAR(20),
	@OpenDate							DateTime,
	@CloseDate							DateTime,
	@Order								INT,
	@SexCode							INT,
	@PlayerRegTypeID					INT,
	@CompetitionTypeID					INT,
	@EngLongName						NVARCHAR(200),
	@EngShortName						NVARCHAR(100),
	@ChnLongName						NVARCHAR(200),
	@ChnShortName						NVARCHAR(100),
	@EngComment							NVARCHAR(200),
	@ChnComment							NVARCHAR(200)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @DisciplineID				INT
	DECLARE @EventID					INT
	
	SELECT @DisciplineID = D.F_DisciplineID
	FROM TS_Discipline AS D
	WHERE D.F_DisciplineCode = @DisciplineCode
	
	IF @DisciplineID IS NULL
	BEGIN
		RETURN
	END
	
	SELECT @EventID = E.F_EventID
	FROM TS_Event AS E
	WHERE E.F_DisciplineID = @DisciplineID AND E.F_EventCode = @EventCode AND E.F_SexCode = @SexCode
	
	-- 存在此 Event, 则更新数据
	IF @EventID IS NOT NULL
	BEGIN
		UPDATE TS_Event
		SET F_OpenDate = @OpenDate, F_CloseDate = @CloseDate, F_Order = @Order
			, F_PlayerRegTypeID = @PlayerRegTypeID, F_CompetitionTypeID = @CompetitionTypeID
		WHERE F_EventID = @EventID
		
		UPDATE TS_Event_Des
		SET F_EventLongName = @EngLongName, F_EventShortName = @EngShortName, F_EventComment = @EngComment
		WHERE F_EventID = @EventID AND F_LanguageCode = 'ENG'
		
		UPDATE TS_Event_Des
		SET F_EventLongName = @ChnLongName, F_EventShortName = @ChnShortName, F_EventComment = @ChnComment
		WHERE F_EventID = @EventID AND F_LanguageCode = 'CHN'		
	END
	-- 不存在此 Event, 则添加数据
	ELSE
	BEGIN
		INSERT TS_Event (F_DisciplineID, F_EventCode, F_OpenDate, F_CloseDate, F_Order, F_SexCode, F_PlayerRegTypeID, F_CompetitionTypeID)
			VALUES (@DisciplineID, @EventCode, @OpenDate, @CloseDate, @Order, @SexCode, @PlayerRegTypeID, @CompetitionTypeID)
		SET @EventID = @@IDENTITY
		INSERT TS_Event_Des (F_EventID, F_LanguageCode, F_EventLongName, F_EventShortName, F_EventComment)
			VALUES (@EventID, 'ENG', @EngLongName, @EngShortName, @EngComment)
		INSERT TS_Event_Des (F_EventID, F_LanguageCode, F_EventLongName, F_EventShortName, F_EventComment)
			VALUES (@EventID, 'CHN', @ChnLongName, @ChnShortName, @ChnComment)
	END

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Prepare_AddEvent] 'KR', N'001', '2010-11-24 9:30', '2010-11-24 12:00', 1, 2, 1, 1, N'Women''s Individual Kata', N'Women''s Individual Kata', N'女子个人型', N'女子个人型', N'Kata', N'Kata'
EXEC [Proc_Prepare_AddEvent] 'KR', N'001', '2010-11-24 9:30', '2010-11-24 12:00', 2, 1, 1, 1, N'Men''s Individual Kata', N'Men''s Individual Kata', N'男子个人型', N'男子个人型', N'Kata', N'Kata'

*/