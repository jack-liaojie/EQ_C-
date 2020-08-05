IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_Prepare_GetSDEPMRelation]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_Prepare_GetSDEPMRelation]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Func_Prepare_GetSDEPMRelation]
--描    述: 判断两个 ID (可能是 SportID, DisciplineID, EventID, PhaseID 或 MatchID) 之间的关系(0 - 不包含的关系, 1 - 包含的关系).
--参数说明: TypeID 为 任何(TypeID = -1), SportID(Type = 0), DisciplineID(Type = 1), EventID(Type = 2), PhaseID(Type = 3) 或 MatchID(Type = 4).
--说    明: 
--创 建 人: 邓年彩
--日    期: 2010年9月14日 星期二
--修改记录：
/*			
			日期					修改人		修改内容
*/



CREATE FUNCTION [Func_Prepare_GetSDEPMRelation]
(
	@TypeID1					INT,
	@Type1						INT,
	@TypeID2					INT,
	@Type2						INT
)
RETURNS INT
AS
BEGIN

	DECLARE @CurDisciplineID	INT
	
	DECLARE @SportID			INT
	DECLARE @DisciplineID		INT
	DECLARE @EventID			INT
	DECLARE @PhaseID			INT
	DECLARE @MatchID			INT
	DECLARE @Temp				INT
	
	DECLARE @AType				INT
	DECLARE @SType				INT
	DECLARE @DType				INT
	DECLARE @EType				INT
	DECLARE @PType				INT
	DECLARE @MType				INT
	
	SET @AType = -1
	SET @SType = 0
	SET @DType = 1
	SET @EType = 2
	SET @PType = 3
	SET @MType = 4
	
	IF @Type1 < @Type2
	BEGIN
		SET @Temp = @Type1
		SET @Type1 = @Type2
		SET @Type2 = @Temp
		
		SET @Temp = @TypeID1
		SET @TypeID1 = @TypeID2
		SET @TypeID2 = @Temp
	END
	
	IF @Type1 > @MType OR @Type2 < @AType
	BEGIN
		RETURN 0
	END
	
	IF @Type2 = -1
	BEGIN
		RETURN 1
	END
	
	-- 获取 @Type1 对应的 @SportID, @DisciplineID, @EventID, @PhaseID, @MatchID
	IF @Type1 = @SType
	BEGIN
		SET @SportID = @TypeID1
	END
	ELSE IF @Type1 = @DType
	BEGIN
		SET @DisciplineID = @TypeID1
	END
	ELSE IF @Type1 = @EType
	BEGIN
		SET @EventID = @TypeID1
	END
	ELSE IF @Type1 = @PType
	BEGIN
		SET @PhaseID = @TypeID1
	END
	ELSE IF @Type1 = @MType
	BEGIN
		SET @MatchID = @TypeID1
	END
	
	IF @MatchID > 0
	BEGIN
		SELECT @PhaseID = M.F_PhaseID
		FROM TS_Match AS M
		WHERE M.F_MatchID = @MatchID
	END
	IF @PhaseID > 0
	BEGIN
		SELECT @EventID = P.F_EventID
		FROM TS_Phase AS P
		WHERE P.F_PhaseID = @PhaseID
	END
	IF @EventID > 0
	BEGIN
		SELECT @DisciplineID = E.F_DisciplineID
		FROM TS_Event AS E
		WHERE E.F_EventID = @EventID
	END
	IF @DisciplineID > 0
	BEGIN
		SELECT @SportID = D.F_SportID
		FROM TS_Discipline AS D
		WHERE D.F_DisciplineID = @DisciplineID
	END
	
	-- 判断关系
	IF @Type2 = @SType
	BEGIN
		IF @SportID = @TypeID2
		BEGIN
			RETURN 1
		END
	END
	ELSE IF @Type2 = @DType
	BEGIN
		IF @DisciplineID = @TypeID2
		BEGIN
			RETURN 1
		END
	END
	ELSE IF @Type2 = @EType
	BEGIN
		IF @EventID = @TypeID2
		BEGIN
			RETURN 1
		END
	END
	ELSE IF @Type2 = @PType
	BEGIN
		IF @PhaseID = @TypeID2
		BEGIN
			RETURN 1
		END
	END
	ELSE IF @Type2 = @MType
	BEGIN
		IF @MatchID = @TypeID2
		BEGIN
			RETURN 1
		END
	END
	
	RETURN 0

END

/*

-- Just for test
SELECT dbo.[Func_Prepare_GetSDEPMRelation](70, 1, 28, 0)
SELECT dbo.[Func_Prepare_GetSDEPMRelation](70, 1, 36, 0)
SELECT dbo.[Func_Prepare_GetSDEPMRelation](141, 2, 70, 1)
SELECT dbo.[Func_Prepare_GetSDEPMRelation](140, 2, 70, 1)
SELECT dbo.[Func_Prepare_GetSDEPMRelation](1562, 3, 141, 2)
SELECT dbo.[Func_Prepare_GetSDEPMRelation](1558, 3, 141, 2)
SELECT dbo.[Func_Prepare_GetSDEPMRelation](4320, 4, 1562, 3)
SELECT dbo.[Func_Prepare_GetSDEPMRelation](4323, 4, 1562, 3)

SELECT dbo.[Func_Prepare_GetSDEPMRelation](1562, 3, 4320, 4)
SELECT dbo.[Func_Prepare_GetSDEPMRelation](1562, 3, 4323, 4)

SELECT dbo.[Func_Prepare_GetSDEPMRelation](4320, 4, 4320, 4)
SELECT dbo.[Func_Prepare_GetSDEPMRelation](4320, 4, 4323, 4)

*/