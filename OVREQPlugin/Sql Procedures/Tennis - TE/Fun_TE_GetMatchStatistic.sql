IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_TE_GetMatchStatistic]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_TE_GetMatchStatistic]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[Fun_TE_GetMatchStatistic]
								(
									@MatchID					INT,
									@SplitMatchID               INT,  ----0:Match
									@Position                   INT,  ----1:A; 2:B
									@StatCode                   NVARCHAR(50)
									
								)
RETURNS nvarchar(50)
AS
BEGIN

	DECLARE @Return		AS NVARCHAR(50)
	SET @Return = ''
	
	DECLARE @Stat_Suc	AS INT
	DECLARE @Stat_Win	AS INT	
	DECLARE @Stat_Num   AS INT
	DECLARE @DivisionResult 	AS INT
	DECLARE @ResultDes  AS NVARCHAR(50)
	
	DECLARE @SplitStatus  AS INT
	SELECT @SplitStatus = F_MatchSplitStatusID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @SplitMatchID
	IF(@SplitMatchID <> 0 AND (@SplitStatus IS NULL OR (@SplitStatus <> 50 AND @SplitStatus <> 110)))
	BEGIN
	   SET @Return = NULL
	   RETURN @Return
	END
	ELSE
	BEGIN
			IF(@StatCode = 'Ser_Suc_Per_1st_1' OR @StatCode = 'Ser_Suc_Per_1st_2' OR @StatCode = 'Ser_Suc_Per_1st_3')
			BEGIN
				SELECT @Stat_Num=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
						and F_ServerPosition=@Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID)

				SELECT @Stat_Suc=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition=@Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail6 not in (1,2)
					
				IF (@Stat_Num=0)
				BEGIN
					set @ResultDes='0'
				END
				ELSE
				BEGIN
					set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@Stat_Suc AS decimal(10,5))/CAST(@Stat_Num AS decimal(10,5)) AS decimal(10,0))
					set @ResultDes=cast (@DivisionResult as nvarchar(50))
				END
				
				IF(@StatCode = 'Ser_Suc_Per_1st_1')
				BEGIN
					SET @Return = cast(@Stat_Suc as nvarchar(50))+'/'+cast(@Stat_Num as nvarchar(50))
					RETURN @Return
				END
				ELSE IF(@StatCode = 'Ser_Suc_Per_1st_2')
				BEGIN
					SET @Return = @ResultDes
					RETURN @Return
				END
				ELSE IF(@StatCode = 'Ser_Suc_Per_1st_3')
				BEGIN
					SET @Return =  cast(@Stat_Suc as nvarchar(50))+'/'+cast(@Stat_Num as nvarchar(50))+' (' + @ResultDes + '%)'
					RETURN @Return
				END
			END
			ELSE IF(@StatCode = 'Aces')
			BEGIN
			   SELECT @Stat_Num=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition=@Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail3= 1
					
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return			
			END
			ELSE IF(@StatCode = 'Double_Fault')
			BEGIN
				SELECT @Stat_Num=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
							and F_ServerPosition=@Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail6=2
				
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return	
			END
			ELSE IF(@StatCode = 'Se_Win_Per_1st_1' OR @StatCode = 'Se_Win_Per_1st_2' OR @StatCode = 'Se_Win_Per_1st_3')
			BEGIN

				SELECT @Stat_Suc=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition=@Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail6 not in (1,2)

				SELECT @Stat_Win=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition=@Position and F_PointPosition=@Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail6 not in (1,2)
					
				IF (@Stat_Suc=0)
				BEGIN
					set @ResultDes='0'
				END
				ELSE
				BEGIN
					set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@Stat_Win AS decimal(10,5))/CAST( @Stat_Suc AS decimal(10,5)) AS decimal(10,0))
					set @ResultDes=cast (@DivisionResult as nvarchar(50))
				END
				
				IF(@StatCode = 'Se_Win_Per_1st_1')
				BEGIN
					SET @Return = cast(@Stat_Win as nvarchar(50))+'/'+cast(@Stat_Suc as nvarchar(50))
					RETURN @Return
				END
				ELSE IF(@StatCode = 'Se_Win_Per_1st_2')
				BEGIN
					SET @Return = @ResultDes
					RETURN @Return
				END
				ELSE IF(@StatCode = 'Se_Win_Per_1st_3')
				BEGIN
					SET @Return =  cast(@Stat_Win as nvarchar(50))+'/'+cast(@Stat_Suc as nvarchar(50))+' (' + @ResultDes + '%)'
					RETURN @Return
				END
			END
			ELSE IF(@StatCode = 'Se_Win_Per_2nd_1' OR @StatCode = 'Se_Win_Per_2nd_2' OR @StatCode = 'Se_Win_Per_2nd_3')
			BEGIN

				SELECT @Stat_Suc=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition=@Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail6=1

				SELECT @Stat_Win=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition=@Position and F_PointPosition=@Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail6=1
					
				IF (@Stat_Suc=0)
				BEGIN
					set @ResultDes='0'
				END
				ELSE
				BEGIN
					set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@Stat_Win AS decimal(10,5))/CAST( @Stat_Suc AS decimal(10,5)) AS decimal(10,0))
					set @ResultDes=cast (@DivisionResult as nvarchar(50))
				END
				
				IF(@StatCode = 'Se_Win_Per_2nd_1')
				BEGIN
					SET @Return = cast(@Stat_Win as nvarchar(50))+'/'+cast(@Stat_Suc as nvarchar(50))
					RETURN @Return
				END
				ELSE IF(@StatCode = 'Se_Win_Per_2nd_2')
				BEGIN
					SET @Return = @ResultDes
					RETURN @Return
				END
				ELSE IF(@StatCode = 'Se_Win_Per_2nd_3')
				BEGIN
					SET @Return =  cast(@Stat_Win as nvarchar(50))+'/'+cast(@Stat_Suc as nvarchar(50))+' (' + @ResultDes + '%)'
					RETURN @Return
				END
			END
			ELSE IF(@StatCode = 'Winners')
			BEGIN
				SELECT @Stat_Num = COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_PointPosition=@Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail3 in (1,2,4)
				
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return	
			END
			ELSE IF(@StatCode = 'Unf_Error')
			BEGIN
				SELECT @Stat_Num = COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and (F_PointPosition= (3 - @Position)) and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail3= 3 
				
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return	
			END 
			ELSE IF(@StatCode = 'Rec_Win_Per_1' OR @StatCode = 'Rec_Win_Per_2' OR @StatCode = 'Rec_Win_Per_3')
			BEGIN

				SELECT @Stat_Num = COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition= (3 - @Position) and F_ActionDetail6<>2 and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID)

				SELECT @Stat_Win = COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition=(3 - @Position) and F_PointPosition= @Position and F_ActionDetail6<>2 and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID)
					
				IF (@Stat_Num=0)
				BEGIN
					set @ResultDes='0'
				END
				ELSE
				BEGIN
					set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@Stat_Win AS decimal(10,5))/CAST( @Stat_Num AS decimal(10,5)) AS decimal(10,0))
					set @ResultDes=cast (@DivisionResult as nvarchar(50))
				END
				
				IF(@StatCode = 'Rec_Win_Per_1')
				BEGIN
					SET @Return = cast(@Stat_Win as nvarchar(50))+'/'+cast(@Stat_Num as nvarchar(50))
					RETURN @Return
				END
				ELSE IF(@StatCode = 'Rec_Win_Per_2')
				BEGIN
					SET @Return = @ResultDes
					RETURN @Return
				END
				ELSE IF(@StatCode = 'Rec_Win_Per_3')
				BEGIN
					SET @Return =  cast(@Stat_Win as nvarchar(50))+'/'+cast(@Stat_Num as nvarchar(50))+' (' + @ResultDes + '%)'
					RETURN @Return
				END
			END
			ELSE IF(@StatCode = 'BreakPoint_Con_Per_1' OR @StatCode = 'BreakPoint_Con_Per_2' OR @StatCode = 'BreakPoint_Con_Per_3')
			BEGIN

				SELECT @Stat_Num = COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition= (3 - @Position) and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_CriticalPoint IN (1, 2, 3) AND F_CriticalPointPosition IN (1, 3)

				SELECT @Stat_Win = COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition= (3 - @Position) and F_PointPosition= @Position and  F_ScoreDes LIKE '60-%' and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID)
					
				IF (@Stat_Num=0)
				BEGIN
					set @ResultDes='0'
				END
				ELSE
				BEGIN
					set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@Stat_Win AS decimal(10,5))/CAST( @Stat_Num AS decimal(10,5)) AS decimal(10,0))
					set @ResultDes=cast (@DivisionResult as nvarchar(50))
				END
				
				IF(@StatCode = 'BreakPoint_Con_Per_1')
				BEGIN
					SET @Return = cast(@Stat_Win as nvarchar(50))+'/'+cast(@Stat_Num as nvarchar(50))
					RETURN @Return
				END
				ELSE IF(@StatCode = 'BreakPoint_Con_Per_2')
				BEGIN
					SET @Return = @ResultDes
					RETURN @Return
				END
				ELSE IF(@StatCode = 'BreakPoint_Con_Per_3')
				BEGIN
					SET @Return =  cast(@Stat_Win as nvarchar(50))+'/'+cast(@Stat_Num as nvarchar(50))+' (' + @ResultDes + '%)'
					RETURN @Return
				END
			END
			ELSE IF(@StatCode = 'Total_Point_Won')
			BEGIN
				SELECT @Stat_Num = COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
							and F_PointPosition=@Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID)
				
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return	
			END 
			ELSE IF(@StatCode = 'First_Se_Point_Won')
			BEGIN
				SELECT @Stat_Num = COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition = @Position and F_PointPosition = @Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail6 not in (1,2)
				
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return	
			END 
			ELSE IF(@StatCode = 'First_Se_Played')
			BEGIN
				SELECT @Stat_Num = COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition=@Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail6 not in (1,2)
				
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return	
			END 
			ELSE IF(@StatCode = 'Second_Se_Point_Won')
			BEGIN
				SELECT @Stat_Num = COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition = @Position and F_PointPosition = @Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail6=1
				
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return	
			END
			ELSE IF(@StatCode = 'Second_Se_Played')
			BEGIN
				SELECT @Stat_Num = COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition=@Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail6 = 1
				
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return	
			END  
			ELSE IF(@StatCode = 'Se_Winner')
			BEGIN
				SELECT @Stat_Num = COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition=@Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail3= 2
				
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return	
			END  
			ELSE IF(@StatCode = 'Break_Point_Con')
			BEGIN
				SELECT @Stat_Num = COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition=(3 - @Position) and F_PointPosition = @Position and  F_ScoreDes LIKE '60-%' and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID)
				
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return	
			END 
			ELSE IF(@StatCode = 'Break_Point_Opp')
			BEGIN
				SELECT @Stat_Num = COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition=(3 - @Position) and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_CriticalPoint IN (1, 2, 3) AND F_CriticalPointPosition IN (1, 3)
				
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return	
			END  
			ELSE IF(@StatCode = 'Net_Point_Won')
			BEGIN
				SELECT @Stat_Num = COUNT(F_ActionNumberID) FROM TS_Match_ActionList 
				WHERE F_MatchID = @MatchID AND F_ActionTypeID = -2 AND (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) AND F_PointPosition = @Position
					AND ((F_ActionDetail5 in (1002,1005) AND F_ActionDetail3 = 3) OR ( F_ActionDetail5 in (1001,1003, 1005, 1006) AND F_ActionDetail3 = 4)) 
				
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return	
			END   
			ELSE IF(@StatCode = 'Net_Point_Played')
			BEGIN
			   SELECT @Stat_Num =  COUNT(F_ActionNumberID) FROM TS_Match_ActionList 
				WHERE F_MatchID = @MatchID AND F_ActionTypeID = -2 AND (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID)
					AND ((F_PointPosition = @Position AND F_ActionDetail5 in (1002,1005) AND F_ActionDetail3 = 3) OR (F_PointPosition = @Position AND F_ActionDetail5 in (1001,1003, 1005, 1006) AND F_ActionDetail3 = 4)
						  OR (F_PointPosition = (3 - @Position) AND F_ActionDetail5 in (1001, 1003, 1005, 1006) AND F_ActionDetail3 = 3) OR (F_PointPosition = (3 - @Position) AND F_ActionDetail5 in (1002, 1005) AND F_ActionDetail3 = 4))  
				
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return	
			END  
			ELSE IF(@StatCode = 'Net_Point_Win_Per_1' OR @StatCode = 'Net_Point_Win_Per_2' OR @StatCode = 'Net_Point_Win_Per_3')
			BEGIN
				SELECT @Stat_Num = COUNT(F_ActionNumberID) FROM TS_Match_ActionList 
				WHERE F_MatchID = @MatchID AND F_ActionTypeID = -2 AND (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID)
					AND ((F_PointPosition = @Position AND F_ActionDetail5 in (1002,1005) AND F_ActionDetail3 = 3) OR (F_PointPosition = @Position AND F_ActionDetail5 in (1001,1003, 1005, 1006) AND F_ActionDetail3 = 4)
						  OR (F_PointPosition = (3 - @Position) AND F_ActionDetail5 in (1001, 1003, 1005, 1006) AND F_ActionDetail3 = 3) OR (F_PointPosition = (3 - @Position) AND F_ActionDetail5 in (1002, 1005) AND F_ActionDetail3 = 4))  
				
				SELECT @Stat_Win = COUNT(F_ActionNumberID) FROM TS_Match_ActionList 
				WHERE F_MatchID = @MatchID AND F_ActionTypeID = -2 AND (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) AND F_PointPosition = @Position
					AND ((F_ActionDetail5 in (1002,1005) AND F_ActionDetail3 = 3) OR ( F_ActionDetail5 in (1001,1003, 1005, 1006) AND F_ActionDetail3 = 4)) 
				
				if (@Stat_Num=0)
				begin
					set @ResultDes='0'
				end
				else
				begin
					set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@Stat_Win AS decimal(10,5))/CAST(@Stat_Num AS decimal(10,5)) AS decimal(10,0))
					set @ResultDes=cast (@DivisionResult as nvarchar(10))
				end
				
				IF(@StatCode = 'Net_Point_Win_Per_2')
				BEGIN
					SET @Return = cast(@Stat_Win as nvarchar(50))+'/'+cast(@Stat_Num as nvarchar(50))
					RETURN @Return
				END
				ELSE IF(@StatCode = 'Net_Point_Win_Per_1')
				BEGIN
					SET @Return = @ResultDes
					RETURN @Return
				END
				ELSE IF(@StatCode = 'Net_Point_Win_Per_3')
				BEGIN
					SET @Return =  cast(@Stat_Win as nvarchar(50))+'/'+cast(@Stat_Num as nvarchar(50))+' (' + @ResultDes + '%)'
					RETURN @Return
				END
			
				
				SET @Return = @ResultDes
				RETURN @Return	
			END  
			ELSE IF(@StatCode = 'Forehand_Winner')
			BEGIN
			   SELECT @Stat_Num =  COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_PointPosition=@Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail4= 101 and F_ActionDetail3 = 4
					
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return	
			END  
			ELSE IF(@StatCode = 'Backhand_Winner')
			BEGIN
			   SELECT @Stat_Num =  COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_PointPosition=@Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail4= 102  and F_ActionDetail3 = 4
					
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return	
			END 
			ELSE IF(@StatCode = 'Vol_Winner')
			BEGIN
			   SELECT @Stat_Num =  COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_PointPosition=@Position and (@SplitMatchID = 0 OR F_ActionDetail1 = @SplitMatchID) and F_ActionDetail5= 1003  and F_ActionDetail3 = 4
					
				SET @Return = CAST(@Stat_Num AS NVARCHAR(50))
				RETURN @Return	
			END
	END   


    RETURN @Return

END


GO


