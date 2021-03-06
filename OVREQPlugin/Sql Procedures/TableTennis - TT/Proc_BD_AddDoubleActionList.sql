IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_AddDoubleActionList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_AddDoubleActionList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
----存储过程名称：[Proc_BD_AddDoubleActionList]
----功		  能：为双打比赛添加得分历程
----作		  者：王强
----日		  期: 2011-03-12 

CREATE PROCEDURE [dbo].[Proc_BD_AddDoubleActionList]
    @CompetitionPosition     INT,
    @MatchID		         INT,
	@MatchSplitID		     INT,
	@RegisterIDA1	         INT,
	@RegisterIDA2	         INT,
	@RegisterIDB1	         INT,
	@RegisterIDB2	         INT,
    @ActionScore             INT
	
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @LastRegID INT
	DECLARE @LastScore INT
	DECLARE @Res INT
	DECLARE @MaxOrder INT
	DECLARE @MaxAOrder INT
	DECLARE @MaxBOrder INT
	SELECT @MaxOrder = MAX(F_ActionOrder) FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID  
	SELECT @MaxAOrder = MAX(F_ActionOrder) FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = 1
	SELECT @MaxBOrder = MAX(F_ActionOrder) FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = 2
	SELECT @LastRegID = F_RegisterID FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_ActionOrder = @MaxOrder

	--首先获取上一个得分的人
	IF @LastRegID IS NULL
		BEGIN
			IF @CompetitionPosition = 1
				BEGIN
					exec dbo.proc_BD_AddAction @CompetitionPosition, @MatchID, @MatchSplitID, @RegisterIDB1, 0, 0, 0, @Res OUTPUT
					exec dbo.proc_BD_AddAction @CompetitionPosition, @MatchID, @MatchSplitID, @RegisterIDA1, 0, 0, 0, @Res OUTPUT
				END
			ELSE
				BEGIN
					exec dbo.proc_BD_AddAction @CompetitionPosition, @MatchID, @MatchSplitID, @RegisterIDA1, 0, 0, 0, @Res OUTPUT
					exec dbo.proc_BD_AddAction @CompetitionPosition, @MatchID, @MatchSplitID, @RegisterIDB1, 0, 0, 0, @Res OUTPUT
				END	
		END
	DECLARE @TempRegID INT
	--如果上一个得分的人是A1
	IF @LastRegID = @RegisterIDA1
		BEGIN
			--如果A方继续得分则继续给A1加分
			IF @CompetitionPosition = 1
				exec dbo.proc_BD_AddAction @CompetitionPosition, @MatchID, @MatchSplitID, @RegisterIDA1, 0, @ActionScore, 0, @Res OUTPUT
			ELSE--如果B方得分了，则判断上次B方最后得分的人是谁
				BEGIN
					SELECT @TempRegID = F_RegisterID FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_ActionOrder = @MaxBOrder
					--B方上次得分的人是B1，则这次给其队友加分，是B2则给B1加分
					IF @TempRegID = @RegisterIDB1
						BEGIN
							exec dbo.proc_BD_AddAction @CompetitionPosition, @MatchID, @MatchSplitID, @RegisterIDB2, 0, @ActionScore, 0, @Res OUTPUT
						END
					ELSE
						BEGIN
							exec dbo.proc_BD_AddAction @CompetitionPosition, @MatchID, @MatchSplitID, @RegisterIDB1, 0, @ActionScore, 0, @Res OUTPUT
						END
				END
		END
		
	--如果上一个得分的人是A2
	IF @LastRegID = @RegisterIDA2
		BEGIN
			--如果A方继续得分则继续给A2加分
			IF @CompetitionPosition = 1
				exec dbo.proc_BD_AddAction @CompetitionPosition, @MatchID, @MatchSplitID, @RegisterIDA2, 0, @ActionScore, 0, @Res OUTPUT
			ELSE--如果B方得分了，则判断上次B方最后得分的人是谁
				BEGIN
					SELECT @TempRegID = F_RegisterID FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_ActionOrder = @MaxBOrder
					--B方上次得分的人是B1，则这次给其队友加分，是B2则给B1加分
					IF @TempRegID = @RegisterIDB1
						BEGIN
							exec dbo.proc_BD_AddAction @CompetitionPosition, @MatchID, @MatchSplitID, @RegisterIDB2, 0, @ActionScore, 0, @Res OUTPUT
						END
					ELSE
						BEGIN
							exec dbo.proc_BD_AddAction @CompetitionPosition, @MatchID, @MatchSplitID, @RegisterIDB1, 0, @ActionScore, 0, @Res OUTPUT
						END
				END
		END
		
	--如果上一个得分的人是B1
	IF @LastRegID = @RegisterIDB1
		BEGIN
			--如果B方继续得分则继续给B1加分
			IF @CompetitionPosition = 2
				exec dbo.proc_BD_AddAction @CompetitionPosition, @MatchID, @MatchSplitID, @RegisterIDB1, 0, @ActionScore, 0, @Res OUTPUT
			ELSE--如果A方得分了，则判断上次A方最后得分的人是谁
				BEGIN
					SELECT @TempRegID = F_RegisterID FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_ActionOrder = @MaxAOrder
					--A方上次得分的人是A1，则这次给其队友加分，是A2则给A1加分
					IF @TempRegID = @RegisterIDA1
						BEGIN
							exec dbo.proc_BD_AddAction @CompetitionPosition, @MatchID, @MatchSplitID, @RegisterIDA2, 0, @ActionScore, 0, @Res OUTPUT
						END
					ELSE
						BEGIN
							exec dbo.proc_BD_AddAction @CompetitionPosition, @MatchID, @MatchSplitID, @RegisterIDA1, 0, @ActionScore, 0, @Res OUTPUT
						END
				END
		END
		
	
	--如果上一个得分的人是B2
	IF @LastRegID = @RegisterIDB2
		BEGIN
			--如果B方继续得分则继续给B2加分
			IF @CompetitionPosition = 2
				exec dbo.proc_BD_AddAction @CompetitionPosition, @MatchID, @MatchSplitID, @RegisterIDB2, 0, @ActionScore, 0, @Res OUTPUT
			ELSE--如果A方得分了，则判断上次A方最后得分的人是谁
				BEGIN
					SELECT @TempRegID = F_RegisterID FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_ActionOrder = @MaxAOrder
					--A方上次得分的人是A1，则这次给其队友加分，是A2则给A1加分
					IF @TempRegID = @RegisterIDA1
						BEGIN
							exec dbo.proc_BD_AddAction @CompetitionPosition, @MatchID, @MatchSplitID, @RegisterIDA2, 0, @ActionScore, 0, @Res OUTPUT
						END
					ELSE
						BEGIN
							exec dbo.proc_BD_AddAction @CompetitionPosition, @MatchID, @MatchSplitID, @RegisterIDA1, 0, @ActionScore, 0, @Res OUTPUT
						END
				END
		END
	
	

SET NOCOUNT OFF
END


GO

