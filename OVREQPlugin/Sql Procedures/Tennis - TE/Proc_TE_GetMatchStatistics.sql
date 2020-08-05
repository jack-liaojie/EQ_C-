IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchStatistics]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchStatistics]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称: [Proc_TE_GetMatchStatistics]
--描    述: 网球比赛的技术统计
--参数说明: 
--说    明: 
--创 建 人: 郑金勇
--日    期: 2010年10月14日


---修改记录
/*
            李燕         2011年1月7号     增加NetPointsWon，NetPointsPlayed的技术统计计算
            李燕         2011年2月10号    修改Winners, BackHandWinners, ForHandWinners, VolleyWinners的技术统计计算
            李燕         2011年2月10号    修改存储过程，利用StaCode得到技术统计值
*/
Create Procedure [dbo].[Proc_TE_GetMatchStatistics](
	@MatchID		INT,
	@LanguageCode	CHAR(3)
)
As
Begin
Set Nocount On 

	create table #temp_MatchSta(
					StaId		int,
					StaOrder	smallint,
					StaName		nvarchar(50),
					StaCode     nvarchar(50),
					H_1			nvarchar(50),
					H_2			nvarchar(50),
					H_3			nvarchar(50),
					H_4			nvarchar(50),
					H_5			nvarchar(50),
					H_Total		nvarchar(50),
					A_1			nvarchar(50),
					A_2			nvarchar(50),
					A_3			nvarchar(50),
					A_4			nvarchar(50),
					A_5			nvarchar(50),
					A_Total		nvarchar(50)
				)

	create table #temp_MatchStaF_MatchSplitID(
						StaId		int,
						StaOrder	smallint,
						StaName		nvarchar(50),
						StaCode     nvarchar(50),
						H		    nvarchar(50),
						A		    nvarchar(50),
					)

	
	insert into #temp_MatchSta (StaId,StaOrder) select F_StatisticID, F_Order from TD_Statistic
	insert into #temp_MatchStaF_MatchSplitID (StaId,StaOrder) select F_StatisticID, F_Order from TD_Statistic

	
	update 	#temp_MatchSta set StaName=b.F_StatisticLongName, StaCode = b.F_StatisticComment from #temp_MatchSta as a left join TD_Statistic_Des as b 
		on a.StaId=b.F_StatisticID and b.F_LanguageCode=@LanguageCode

	update 	#temp_MatchStaF_MatchSplitID set StaName=b.F_StatisticLongName, StaCode = b.F_StatisticComment from #temp_MatchStaF_MatchSplitID as a left join TD_Statistic_Des as b 
		on a.StaId=b.F_StatisticID and b.F_LanguageCode=@LanguageCode
	
	DECLARE @H_Total_1stServer 	AS INT
	DECLARE @H_Total_1stServer_Suc 	AS INT
	DECLARE @H_Total_1stServer_Win	AS INT
	DECLARE @H_Total_2ndServer_Win	AS INT
	DECLARE @H_Total_2ndServer_Suc	AS INT
	DECLARE @H_Total_BreakPoint	AS INT
	DECLARE @H_Total_BreakPoint_Suc	AS INT
	DECLARE @H_Total_Receiving	AS INT
	DECLARE @H_Total_Receiving_Win	AS INT	

	DECLARE @DivisionResult 	AS INT
	DECLARE @ResultDes 		as nvarchar(10)
	DECLARE @A_Total_1stServer 	AS INT
	DECLARE @A_Total_1stServer_Suc 	AS INT
	DECLARE @A_Total_1stServer_Win	AS INT
	DECLARE @A_Total_2ndServer_Win	AS INT
	DECLARE @A_Total_2ndServer_Suc	AS INT
	DECLARE @A_Total_BreakPoint	AS INT
	DECLARE @A_Total_BreakPoint_Suc	AS INT
	DECLARE @A_Total_Receiving	AS INT
	DECLARE @A_Total_Receiving_Win	AS INT	

	DECLARE @AceNum			AS INT
	DECLARE @ServiceWinners AS INT
	DECLARE @DoulbeFault 	AS INT
	DECLARE @WinningNum		AS INT
	DECLARE @UnforcedErrNum 	AS INT		
	DECLARE @TotalPoints		AS INT
	DECLARE @ForeHandWinners	AS INT
	DECLARE @BackHandWinners	AS INT
	DECLARE @VolleyWinners		AS INT
	
	DECLARE @H_NetPointsWon		AS INT
	DECLARE @H_NetPointsPlayed	AS INT
	
	DECLARE @A_NetPointsWon		AS INT
	DECLARE @A_NetPointsPlayed	AS INT
	
	DECLARE @StrSQL 		as nvarchar(max)



	DECLARE @CurF_MatchSplitID AS INT
	set @CurF_MatchSplitID=1

	while (@CurF_MatchSplitID<=5)
	begin
			
		update #temp_MatchStaF_MatchSplitID set H = dbo.Func
		
		select @H_Total_1stServer=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_ActionDetail1 = @CurF_MatchSplitID
	
		select @H_Total_1stServer_Suc=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail6 not in (1,2)
	
		select @H_Total_1stServer_Win=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_PointPosition=1 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail6 not in (1,2)

		select @H_Total_2ndServer_Win=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_PointPosition=1 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail6=1

		select @H_Total_2ndServer_Suc=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail6=1

		select @H_Total_BreakPoint=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_ActionDetail1 = @CurF_MatchSplitID and F_CriticalPoint IN (1, 2, 3) AND F_CriticalPointPosition IN (1, 3)
		
		select @H_Total_BreakPoint_Suc=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_PointPosition=1 and  F_ScoreDes LIKE '60-%' and F_ActionDetail1 = @CurF_MatchSplitID
		----此处有待进一步的修改，详细确定破发成功的数目
		
		select @H_Total_Receiving=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_ActionDetail6<>2 and F_ActionDetail1 = @CurF_MatchSplitID

		select @H_Total_Receiving_Win=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_PointPosition=1 and F_ActionDetail6<>2 and F_ActionDetail1 = @CurF_MatchSplitID

		if (@H_Total_1stServer=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@H_Total_1stServer_Suc AS decimal(10,5))/CAST(@H_Total_1stServer AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_1stServer_Suc as nvarchar(10))+' of '+cast(@H_Total_1stServer as nvarchar(10)) where StaId=1
		update #temp_MatchStaF_MatchSplitID set H=@ResultDes where StaId=2
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_1stServer_Suc as nvarchar(10))+' of '+cast(@H_Total_1stServer as nvarchar(10))+' = ' + @ResultDes where StaId=3
	
		if (@H_Total_1stServer_Suc=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@H_Total_1stServer_Win AS decimal(10,5))/CAST(@H_Total_1stServer_Suc AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_1stServer_Win as nvarchar(10))+' of '+cast(@H_Total_1stServer_Suc as nvarchar(10)) where StaId=6
		update #temp_MatchStaF_MatchSplitID set H=@ResultDes where StaId=7
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_1stServer_Win as nvarchar(10))+' of '+cast(@H_Total_1stServer_Suc as nvarchar(10))+' = ' + @ResultDes where StaId=8
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_1stServer_Win as nvarchar(10)) where StaId=21
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_1stServer_Suc as nvarchar(10)) where StaId=22
	
		if (@H_Total_2ndServer_Suc=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@H_Total_2ndServer_Win AS decimal(10,5))/CAST(@H_Total_2ndServer_Suc AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_2ndServer_Win as nvarchar(10))+' of '+cast(@H_Total_2ndServer_Suc as nvarchar(10)) where StaId=9
		update #temp_MatchStaF_MatchSplitID set H=@ResultDes where StaId=10
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_2ndServer_Win as nvarchar(10))+' of '+cast(@H_Total_2ndServer_Suc as nvarchar(10))+' = ' + @ResultDes where StaId=11
	
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_2ndServer_Win as nvarchar(10)) where StaId=23
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_2ndServer_Suc as nvarchar(10)) where StaId=24

		if (@H_Total_Receiving=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@H_Total_Receiving_Win AS decimal(10,5))/CAST(@H_Total_Receiving AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_Receiving_Win as nvarchar(10))+' of '+cast(@H_Total_Receiving as nvarchar(10)) where StaId=14
		update #temp_MatchStaF_MatchSplitID set H=@ResultDes where StaId=15
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_Receiving_Win as nvarchar(10))+' of '+cast(@H_Total_Receiving as nvarchar(10))+' = ' + @ResultDes where StaId=16
	
		if (@H_Total_BreakPoint=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@H_Total_BreakPoint_Suc AS decimal(10,5))/CAST(@H_Total_BreakPoint AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_BreakPoint_Suc as nvarchar(10))+' / '+cast(@H_Total_BreakPoint as nvarchar(10)) where StaId=17
		update #temp_MatchStaF_MatchSplitID set H=@ResultDes where StaId=18
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_BreakPoint_Suc as nvarchar(10))+' / '+cast(@H_Total_BreakPoint as nvarchar(10))+' = ' + @ResultDes where StaId=19
		
		UPDATE #temp_MatchStaF_MatchSplitID SET H=@H_Total_BreakPoint_Suc WHERE StaID = 27
		UPDATE #temp_MatchStaF_MatchSplitID SET H=@H_Total_BreakPoint WHERE StaID = 28
	
	
	    ----上网次数，上网得分率
		SELECT @H_NetPointsWon = COUNT(F_ActionNumberID) FROM TS_Match_ActionList 
		WHERE F_MatchID = @MatchID AND F_ActionTypeID = -2 AND F_ActionDetail1 = @CurF_MatchSplitID AND F_PointPosition = 1
			AND ((F_ActionDetail5 in (1002,1005) AND F_ActionDetail3 = 3) OR ( F_ActionDetail5 in (1001,1003, 1005, 1006) AND F_ActionDetail3 = 4)) 
			
		
		SELECT @H_NetPointsPlayed = COUNT(F_ActionNumberID) FROM TS_Match_ActionList 
		WHERE F_MatchID = @MatchID AND F_ActionTypeID = -2 AND F_ActionDetail1 = @CurF_MatchSplitID
			AND ((F_PointPosition = 1 AND F_ActionDetail5 in (1002,1005) AND F_ActionDetail3 = 3) OR (F_PointPosition = 1 AND F_ActionDetail5 in (1001,1003, 1005, 1006) AND F_ActionDetail3 = 4)
			      OR (F_PointPosition = 2 AND F_ActionDetail5 in (1001, 1003, 1005, 1006) AND F_ActionDetail3 = 3) OR (F_PointPosition = 2 AND F_ActionDetail5 in (1002, 1005) AND F_ActionDetail3 = 4)) 
			
	
		if (@H_NetPointsPlayed=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@H_NetPointsWon AS decimal(10,5))/CAST(@H_NetPointsPlayed AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set H=@H_NetPointsWon where StaId=29
		update #temp_MatchStaF_MatchSplitID set H=@H_NetPointsPlayed where StaId=30
		update #temp_MatchStaF_MatchSplitID set H=@ResultDes where StaId=31
		
		
	
		select @A_Total_1stServer=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_ActionDetail1 = @CurF_MatchSplitID
	
		select @A_Total_1stServer_Suc=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail6 not in (1,2)
	
		select @A_Total_1stServer_Win=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_PointPosition=2 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail6 not in (1,2)

		select @A_Total_2ndServer_Win=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_PointPosition=2 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail6=1

		select @A_Total_2ndServer_Suc=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail6=1
		
		select @A_Total_BreakPoint=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_ActionDetail1 = @CurF_MatchSplitID and F_CriticalPoint IN (1, 2, 3) AND F_CriticalPointPosition IN (2, 3)
		
		select @A_Total_BreakPoint_Suc=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_PointPosition=2 and  F_ScoreDes LIKE '%-60' and F_ActionDetail1 = @CurF_MatchSplitID
		----此处有待进一步的修改，详细确定破发成功的数目
		
		select @A_Total_Receiving=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_ActionDetail6<>2 and F_ActionDetail1 = @CurF_MatchSplitID

		select @A_Total_Receiving_Win=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_PointPosition=2 and F_ActionDetail6<>2 and F_ActionDetail1 = @CurF_MatchSplitID

		if (@A_Total_1stServer=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@A_Total_1stServer_Suc AS decimal(10,5))/CAST(@A_Total_1stServer AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	

		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_1stServer_Suc as nvarchar(10))+' of '+cast(@A_Total_1stServer as nvarchar(10)) where StaId=1
		update #temp_MatchStaF_MatchSplitID set A=@ResultDes where StaId=2
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_1stServer_Suc as nvarchar(10))+' of '+cast(@A_Total_1stServer as nvarchar(10))+' = ' + @ResultDes where StaId=3
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_1stServer_Win as nvarchar(10)) where StaId=21
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_1stServer_Suc as nvarchar(10)) where StaId=22

		if (@A_Total_1stServer_Suc=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@A_Total_1stServer_Win AS decimal(10,5))/CAST(@A_Total_1stServer_Suc AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_1stServer_Win as nvarchar(10))+' of '+cast(@A_Total_1stServer_Suc as nvarchar(10)) where StaId=6
		update #temp_MatchStaF_MatchSplitID set A=@ResultDes where StaId=7

		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_1stServer_Win as nvarchar(10))+' of '+cast(@A_Total_1stServer_Suc as nvarchar(10))+' = ' + @ResultDes where StaId=8
	

		if (@A_Total_2ndServer_Suc=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@A_Total_2ndServer_Win AS decimal(10,5))/CAST(@A_Total_2ndServer_Suc AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_2ndServer_Win as nvarchar(10))+' of '+cast(@A_Total_2ndServer_Suc as nvarchar(10)) where StaId=9
		update #temp_MatchStaF_MatchSplitID set A=@ResultDes where StaId=10
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_2ndServer_Win as nvarchar(10))+' of '+cast(@A_Total_2ndServer_Suc as nvarchar(10))+' = ' + @ResultDes where StaId=11
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_2ndServer_Win as nvarchar(10)) where StaId=23
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_2ndServer_Suc as nvarchar(10)) where StaId=24
		
		if (@A_Total_Receiving=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@A_Total_Receiving_Win AS decimal(10,5))/CAST(@A_Total_Receiving AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_Receiving_Win as nvarchar(10))+' of '+cast(@A_Total_Receiving as nvarchar(10)) where StaId=14
		update #temp_MatchStaF_MatchSplitID set A=@ResultDes where StaId=15
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_Receiving_Win as nvarchar(10))+' of '+cast(@A_Total_Receiving as nvarchar(10))+' = ' + @ResultDes where StaId=16
	


		if (@A_Total_BreakPoint=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@A_Total_BreakPoint_Suc AS decimal(10,5))/CAST(@A_Total_BreakPoint AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_BreakPoint_Suc as nvarchar(10))+' / '+cast(@A_Total_BreakPoint as nvarchar(10)) where StaId=17
		update #temp_MatchStaF_MatchSplitID set A=@ResultDes where StaId=18
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_BreakPoint_Suc as nvarchar(10))+' / '+cast(@A_Total_BreakPoint as nvarchar(10))+' = ' + @ResultDes where StaId=19
	

		UPDATE #temp_MatchStaF_MatchSplitID SET A=@A_Total_BreakPoint_Suc WHERE StaID = 27
		UPDATE #temp_MatchStaF_MatchSplitID SET A=@A_Total_BreakPoint WHERE StaID = 28


		--SELECT @A_NetPointsWon = 0
		--SELECT @A_NetPointsPlayed = 0
		
	 SELECT @A_NetPointsWon = COUNT(F_ActionNumberID) FROM TS_Match_ActionList 
		WHERE F_MatchID = @MatchID AND F_ActionTypeID = -2 AND F_ActionDetail1 = @CurF_MatchSplitID AND F_PointPosition = 2
			AND ((F_ActionDetail5 in (1002,1005) AND F_ActionDetail3 = 3) OR (F_ActionDetail5 in (1001,1003, 1005, 1006) AND F_ActionDetail3 = 4)) 
			
		
	 SELECT @A_NetPointsPlayed = COUNT(F_ActionNumberID) FROM TS_Match_ActionList 
		WHERE F_MatchID = @MatchID AND F_ActionTypeID = -2 AND F_ActionDetail1 = @CurF_MatchSplitID
			AND ((F_PointPosition = 2 AND F_ActionDetail5 in (1002,1005) AND F_ActionDetail3 = 3) OR (F_PointPosition = 2 AND F_ActionDetail5 in (1001,1003, 1005, 1006) AND F_ActionDetail3 = 4)
			      OR (F_PointPosition = 1 AND F_ActionDetail5 in (1001, 1003, 1005, 1006) AND F_ActionDetail3 = 3) OR (F_PointPosition = 1 AND F_ActionDetail5 in (1002, 1005) AND F_ActionDetail3 = 4)) 

	
		if (@A_NetPointsPlayed=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@A_NetPointsWon AS decimal(10,5))/CAST(@A_NetPointsPlayed AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set A=@A_NetPointsWon where StaId=29
		update #temp_MatchStaF_MatchSplitID set A=@A_NetPointsPlayed where StaId=30
		update #temp_MatchStaF_MatchSplitID set A=@ResultDes where StaId=31
		

		select @AceNum=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail3= 1
		
		update #temp_MatchStaF_MatchSplitID set H=@AceNum where StaId=4

		select @AceNum=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail3= 1
		
		update #temp_MatchStaF_MatchSplitID set A=@AceNum where StaId=4

		select @ServiceWinners=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail3= 2
		
		update #temp_MatchStaF_MatchSplitID set H=@ServiceWinners where StaId=26

		select @ServiceWinners=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail3= 2
		
		update #temp_MatchStaF_MatchSplitID set A=@ServiceWinners where StaId=26


		select @DoulbeFault=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition=1 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail6=2

		update #temp_MatchStaF_MatchSplitID set H=@DoulbeFault where StaId=5

		select @DoulbeFault=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition=2 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail6=2

		update #temp_MatchStaF_MatchSplitID set A=@DoulbeFault where StaId=5


--主动得分：发球得分+Ace+Winning
		select @WinningNum=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=1 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail3 in (1,2,4)
		
		update #temp_MatchStaF_MatchSplitID set H=@WinningNum where StaId=12

		select @WinningNum=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=2 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail3 in (1,2,4)
		
		update #temp_MatchStaF_MatchSplitID set A=@WinningNum where StaId=12


		select @UnforcedErrNum=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=2 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail3= 5 
		
		update #temp_MatchStaF_MatchSplitID set H=@UnforcedErrNum where StaId=13

		select @UnforcedErrNum=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=1 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail3= 5
		
		update #temp_MatchStaF_MatchSplitID set A=@UnforcedErrNum where StaId=13


		select @ForeHandWinners=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=1 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail4= 101 and F_ActionDetail3 = 4
		
		update #temp_MatchStaF_MatchSplitID set H=@ForeHandWinners where StaId=32

		select @ForeHandWinners=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=2 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail4= 101  and F_ActionDetail3 = 4
		
		update #temp_MatchStaF_MatchSplitID set A=@ForeHandWinners where StaId=32
		
		select @BackHandWinners=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=1 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail4= 102  and F_ActionDetail3 = 4
		
		update #temp_MatchStaF_MatchSplitID set H=@BackHandWinners where StaId=33

		select @BackHandWinners=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=2 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail4= 102  and F_ActionDetail3 = 4
		
		update #temp_MatchStaF_MatchSplitID set A=@BackHandWinners where StaId=33
		
		select @VolleyWinners=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=1 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail5= 1003  and F_ActionDetail3 = 4
		
		update #temp_MatchStaF_MatchSplitID set H=@VolleyWinners where StaId=34

		select @VolleyWinners=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=2 and F_ActionDetail1 = @CurF_MatchSplitID and F_ActionDetail5= 1003  and F_ActionDetail3 = 4
		
		update #temp_MatchStaF_MatchSplitID set A=@VolleyWinners where StaId=34

		select @TotalPoints=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_PointPosition=1 and F_ActionDetail1 = @CurF_MatchSplitID

		update #temp_MatchStaF_MatchSplitID set H=@TotalPoints where StaId=20

		select @TotalPoints=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_PointPosition=2 and F_ActionDetail1 = @CurF_MatchSplitID

		update #temp_MatchStaF_MatchSplitID set A=@TotalPoints where StaId=20


		set @StrSQL='update #temp_MatchSta set H_'+LTRIM(RTRIM(cast(@CurF_MatchSplitID as nvarchar(10))))+'=b.H,A_'+LTRIM(RTRIM(cast(@CurF_MatchSplitID as nvarchar(10))))+'=b.A from #temp_MatchSta as a left join #temp_MatchStaF_MatchSplitID as b on a.StaId=b.StaId'
		exec (@StrSQL)


		set @CurF_MatchSplitID=@CurF_MatchSplitID+1
	end



		select @H_Total_1stServer=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1
	
		select @H_Total_1stServer_Suc=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1  and F_ActionDetail6 not in (1,2)
	
		select @H_Total_1stServer_Win=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_PointPosition=1  and F_ActionDetail6 not in (1,2)

		select @H_Total_2ndServer_Win=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_PointPosition=1  and F_ActionDetail6=1

		select @H_Total_2ndServer_Suc=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1  and F_ActionDetail6=1

		select @H_Total_BreakPoint=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and  F_CriticalPoint IN (1, 2, 3) AND F_CriticalPointPosition IN (1, 3)
		
		select @H_Total_BreakPoint_Suc=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_PointPosition=1 and  F_ScoreDes LIKE '60-%' 
		----此处有待进一步的修改，详细确定破发成功的数目
		
		select @H_Total_Receiving=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_ActionDetail6<>2 

		select @H_Total_Receiving_Win=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_PointPosition=1 and F_ActionDetail6<>2 

		if (@H_Total_1stServer=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@H_Total_1stServer_Suc AS decimal(10,5))/CAST(@H_Total_1stServer AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_1stServer_Suc as nvarchar(10))+' of '+cast(@H_Total_1stServer as nvarchar(10)) where StaId=1
		update #temp_MatchStaF_MatchSplitID set H=@ResultDes where StaId=2
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_1stServer_Suc as nvarchar(10))+' of '+cast(@H_Total_1stServer as nvarchar(10))+' = ' + @ResultDes where StaId=3
		
		if (@H_Total_1stServer_Suc=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@H_Total_1stServer_Win AS decimal(10,5))/CAST(@H_Total_1stServer_Suc AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_1stServer_Win as nvarchar(10))+' of '+cast(@H_Total_1stServer_Suc as nvarchar(10)) where StaId=6
		update #temp_MatchStaF_MatchSplitID set H=@ResultDes where StaId=7
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_1stServer_Win as nvarchar(10))+' of '+cast(@H_Total_1stServer_Suc as nvarchar(10))+' = ' + @ResultDes where StaId=8
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_1stServer_Win as nvarchar(10)) where StaId=21
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_1stServer_Suc as nvarchar(10)) where StaId=22
	
		if (@H_Total_2ndServer_Suc=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@H_Total_2ndServer_Win AS decimal(10,5))/CAST(@H_Total_2ndServer_Suc AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_2ndServer_Win as nvarchar(10))+' of '+cast(@H_Total_2ndServer_Suc as nvarchar(10)) where StaId=9
		update #temp_MatchStaF_MatchSplitID set H=@ResultDes where StaId=10
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_2ndServer_Win as nvarchar(10))+' of '+cast(@H_Total_2ndServer_Suc as nvarchar(10))+' = ' + @ResultDes where StaId=11
	
	    update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_2ndServer_Win as nvarchar(10)) where StaId=23
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_2ndServer_Suc as nvarchar(10)) where StaId=24

		if (@H_Total_Receiving=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@H_Total_Receiving_Win AS decimal(10,5))/CAST(@H_Total_Receiving AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_Receiving_Win as nvarchar(10))+' of '+cast(@H_Total_Receiving as nvarchar(10)) where StaId=14
		update #temp_MatchStaF_MatchSplitID set H=@ResultDes where StaId=15
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_Receiving_Win as nvarchar(10))+' of '+cast(@H_Total_Receiving as nvarchar(10))+' = ' + @ResultDes where StaId=16
	
		if (@H_Total_BreakPoint=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@H_Total_BreakPoint_Suc AS decimal(10,5))/CAST(@H_Total_BreakPoint AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_BreakPoint_Suc as nvarchar(10))+' / '+cast(@H_Total_BreakPoint as nvarchar(10)) where StaId=17
		update #temp_MatchStaF_MatchSplitID set H=@ResultDes where StaId=18
		update #temp_MatchStaF_MatchSplitID set H=cast(@H_Total_BreakPoint_Suc as nvarchar(10))+' / '+cast(@H_Total_BreakPoint as nvarchar(10))+' = ' + @ResultDes where StaId=19
	
		select @ServiceWinners=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_ActionDetail3= 2
		
		update #temp_MatchStaF_MatchSplitID set H=@ServiceWinners where StaId=26

		select @ServiceWinners=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_ActionDetail3= 2
		
		update #temp_MatchStaF_MatchSplitID set A=@ServiceWinners where StaId=26
	
		UPDATE #temp_MatchStaF_MatchSplitID SET H=@H_Total_BreakPoint_Suc WHERE StaID = 27
		UPDATE #temp_MatchStaF_MatchSplitID SET H=@H_Total_BreakPoint WHERE StaID = 28
	

		
      SELECT @H_NetPointsWon = COUNT(F_ActionNumberID) FROM TS_Match_ActionList 
		WHERE F_MatchID = @MatchID AND F_ActionTypeID = -2 AND F_PointPosition = 1
			AND ((F_ActionDetail5 in (1002,1005) AND F_ActionDetail3 = 3) OR (F_ActionDetail5 in (1001,1003, 1005, 1006) AND F_ActionDetail3 = 4)) 
			
		
	 SELECT @H_NetPointsPlayed = COUNT(F_ActionNumberID) FROM TS_Match_ActionList 
		WHERE F_MatchID = @MatchID AND F_ActionTypeID = -2 
			AND ((F_PointPosition = 1 AND F_ActionDetail5 in (1002,1005) AND F_ActionDetail3 = 3) OR (F_PointPosition = 1 AND F_ActionDetail5 in (1001,1003, 1005, 1006) AND F_ActionDetail3 = 4)
			      OR (F_PointPosition = 2 AND F_ActionDetail5 in (1001, 1003, 1005, 1006) AND F_ActionDetail3 = 3) OR (F_PointPosition = 2 AND F_ActionDetail5 in (1002, 1005) AND F_ActionDetail3 = 4)) 

	
		if (@H_NetPointsPlayed=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@H_NetPointsWon AS decimal(10,5))/CAST(@H_NetPointsPlayed AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set H=@H_NetPointsWon where StaId=29
		update #temp_MatchStaF_MatchSplitID set H=@H_NetPointsPlayed where StaId=30
		update #temp_MatchStaF_MatchSplitID set H=@ResultDes where StaId=31
		
		select @A_Total_1stServer=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 
	
		select @A_Total_1stServer_Suc=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2  and F_ActionDetail6 not in (1,2)
	
		select @A_Total_1stServer_Win=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_PointPosition=2  and F_ActionDetail6 not in (1,2)

		select @A_Total_2ndServer_Win=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2 and F_PointPosition=2  and F_ActionDetail6=1

		select @A_Total_2ndServer_Suc=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2  and F_ActionDetail6=1
		
		select @A_Total_BreakPoint=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_CriticalPoint IN (1, 2, 3) AND F_CriticalPointPosition IN (2, 3)
		
		select @A_Total_BreakPoint_Suc=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_PointPosition=2 and  F_ScoreDes LIKE '%-60'
		----此处有待进一步的修改，详细确定破发成功的数目
		
		select @A_Total_Receiving=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_ActionDetail6<>2 

		select @A_Total_Receiving_Win=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1 and F_PointPosition=2 and F_ActionDetail6<>2 

		if (@A_Total_1stServer=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@A_Total_1stServer_Suc AS decimal(10,5))/CAST(@A_Total_1stServer AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	

		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_1stServer_Suc as nvarchar(10))+' of '+cast(@A_Total_1stServer as nvarchar(10)) where StaId=1
		update #temp_MatchStaF_MatchSplitID set A=@ResultDes where StaId=2
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_1stServer_Suc as nvarchar(10))+' of '+cast(@A_Total_1stServer as nvarchar(10))+' = ' + @ResultDes where StaId=3
	

		if (@A_Total_1stServer_Suc=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@A_Total_1stServer_Win AS decimal(10,5))/CAST(@A_Total_1stServer_Suc AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_1stServer_Win as nvarchar(10))+' of '+cast(@A_Total_1stServer_Suc as nvarchar(10)) where StaId=6
		update #temp_MatchStaF_MatchSplitID set A=@ResultDes where StaId=7
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_1stServer_Win as nvarchar(10))+' of '+cast(@A_Total_1stServer_Suc as nvarchar(10))+' = ' + @ResultDes where StaId=8
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_1stServer_Win as nvarchar(10)) where StaId=21
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_1stServer_Suc as nvarchar(10)) where StaId=22

		if (@A_Total_2ndServer_Suc=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@A_Total_2ndServer_Win AS decimal(10,5))/CAST(@A_Total_2ndServer_Suc AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_2ndServer_Win as nvarchar(10))+' of '+cast(@A_Total_2ndServer_Suc as nvarchar(10)) where StaId=9
		update #temp_MatchStaF_MatchSplitID set A=@ResultDes where StaId=10
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_2ndServer_Win as nvarchar(10))+' of '+cast(@A_Total_2ndServer_Suc as nvarchar(10))+' = ' + @ResultDes where StaId=11
	
	    update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_2ndServer_Win as nvarchar(10)) where StaId=23
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_2ndServer_Suc as nvarchar(10)) where StaId=24
		
		if (@A_Total_Receiving=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@A_Total_Receiving_Win AS decimal(10,5))/CAST(@A_Total_Receiving AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_Receiving_Win as nvarchar(10))+' of '+cast(@A_Total_Receiving as nvarchar(10)) where StaId=14
		update #temp_MatchStaF_MatchSplitID set A=@ResultDes where StaId=15
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_Receiving_Win as nvarchar(10))+' of '+cast(@A_Total_Receiving as nvarchar(10))+' = ' + @ResultDes where StaId=16
		


		if (@A_Total_BreakPoint=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@A_Total_BreakPoint_Suc AS decimal(10,5))/CAST(@A_Total_BreakPoint AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end
	
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_BreakPoint_Suc as nvarchar(10))+' / '+cast(@A_Total_BreakPoint as nvarchar(10)) where StaId=17
		update #temp_MatchStaF_MatchSplitID set A=@ResultDes where StaId=18
		update #temp_MatchStaF_MatchSplitID set A=cast(@A_Total_BreakPoint_Suc as nvarchar(10))+' / '+cast(@A_Total_BreakPoint as nvarchar(10))+' = ' + @ResultDes where StaId=19
	
	
		UPDATE #temp_MatchStaF_MatchSplitID SET A=@A_Total_BreakPoint_Suc WHERE StaID = 27
		UPDATE #temp_MatchStaF_MatchSplitID SET A=@A_Total_BreakPoint WHERE StaID = 28
		
		
     SELECT @A_NetPointsWon = COUNT(F_ActionNumberID) FROM TS_Match_ActionList 
		WHERE F_MatchID = @MatchID AND F_ActionTypeID = -2 AND F_PointPosition = 2
			AND ((F_ActionDetail5 in (1002,1005) AND F_ActionDetail3 = 3) OR (F_ActionDetail5 in (1001,1003, 1005, 1006) AND F_ActionDetail3 = 4)) 
			
		
	 SELECT @A_NetPointsPlayed = COUNT(F_ActionNumberID) FROM TS_Match_ActionList 
		WHERE F_MatchID = @MatchID AND F_ActionTypeID = -2 
			AND ((F_PointPosition = 2 AND F_ActionDetail5 in (1002,1005) AND F_ActionDetail3 = 3) OR (F_PointPosition = 2 AND F_ActionDetail5 in (1001,1003, 1005, 1006) AND F_ActionDetail3 = 4)
			      OR (F_PointPosition = 1 AND F_ActionDetail5 in (1001, 1003, 1005, 1006) AND F_ActionDetail3 = 3) OR (F_PointPosition = 1 AND F_ActionDetail5 in (1002, 1005) AND F_ActionDetail3 = 4)) 


		if (@A_NetPointsPlayed=0)
		begin
			set @ResultDes='0'
		end
		else
		begin
			set @DivisionResult= CAST(CAST(100 AS decimal(10,5))*CAST(@A_NetPointsWon AS decimal(10,5))/CAST(@A_NetPointsPlayed AS decimal(10,5)) AS decimal(10,0))
			set @ResultDes=cast (@DivisionResult as nvarchar(10))
		end

		update #temp_MatchStaF_MatchSplitID set A=@A_NetPointsWon where StaId=29
		update #temp_MatchStaF_MatchSplitID set A=@A_NetPointsPlayed where StaId=30
		update #temp_MatchStaF_MatchSplitID set A=@ResultDes where StaId=31
		
		select @AceNum=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=1  and F_ActionDetail3= 1
		
		update #temp_MatchStaF_MatchSplitID set H=@AceNum where StaId=4

		select @AceNum=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_ServerPosition=2  and F_ActionDetail3= 1
		
		update #temp_MatchStaF_MatchSplitID set A=@AceNum where StaId=4



		select @DoulbeFault=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition=1  and F_ActionDetail6= 2

		update #temp_MatchStaF_MatchSplitID set H=@DoulbeFault where StaId=5

		select @DoulbeFault=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_ServerPosition=2  and F_ActionDetail6= 2

		update #temp_MatchStaF_MatchSplitID set A=@DoulbeFault where StaId=5



		select @WinningNum=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=1  and F_ActionDetail3 in (1,2,4)
		
		update #temp_MatchStaF_MatchSplitID set H=@WinningNum where StaId=12

		select @WinningNum=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=2  and F_ActionDetail3 in (1,2,4)
		
		update #temp_MatchStaF_MatchSplitID set A=@WinningNum where StaId=12



		select @UnforcedErrNum=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=2  and F_ActionDetail3 = 5
		
		update #temp_MatchStaF_MatchSplitID set H=@UnforcedErrNum where StaId=13

		select @UnforcedErrNum=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=1  and F_ActionDetail3 = 5
		
		update #temp_MatchStaF_MatchSplitID set A=@UnforcedErrNum where StaId=13


		select @ForeHandWinners=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=1 and F_ActionDetail4= 101  and F_ActionDetail3 = 4
		
		update #temp_MatchStaF_MatchSplitID set H=@ForeHandWinners where StaId=32

		select @ForeHandWinners=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=2 and F_ActionDetail4= 101  and F_ActionDetail3 = 4
		
		update #temp_MatchStaF_MatchSplitID set A=@ForeHandWinners where StaId=32
		
		select @BackHandWinners=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=1 and F_ActionDetail4= 102  and F_ActionDetail3 = 4
		
		update #temp_MatchStaF_MatchSplitID set H=@BackHandWinners where StaId=33

		select @BackHandWinners=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=2 and F_ActionDetail4= 102  and F_ActionDetail3 = 4
		
		update #temp_MatchStaF_MatchSplitID set A=@BackHandWinners where StaId=33

		select @VolleyWinners=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=1 and F_ActionDetail5= 1003  and F_ActionDetail3 = 4
		
		update #temp_MatchStaF_MatchSplitID set H=@VolleyWinners where StaId=34

		select @VolleyWinners=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
			and F_PointPosition=2 and F_ActionDetail5= 1003  and F_ActionDetail3 = 4
		
		update #temp_MatchStaF_MatchSplitID set A=@VolleyWinners where StaId=34

		select @TotalPoints=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_PointPosition=1 

		update #temp_MatchStaF_MatchSplitID set H=@TotalPoints where StaId=20

		select @TotalPoints=COUNT(F_ActionNumberID) from TS_Match_ActionList where F_MatchID = @MatchID AND F_ActionTypeID = -2
					and F_PointPosition=2 

		update #temp_MatchStaF_MatchSplitID set A=@TotalPoints where StaId=20
		update #temp_MatchSta set H_Total=b.H,A_Total=b.A from #temp_MatchSta as a left join #temp_MatchStaF_MatchSplitID as b on a.StaId=b.StaId

	--select * from #temp_MatchStaF_MatchSplitID
	--select * from #temp_MatchSta
	--select * from #temp_MatchSta where StaId in (2,4,5,7,10,12,13,17,20, 21,22,23,24) order by StaOrder asc

	BEGIN--进行无效的Set的内容的置空处理
		CREATE TABLE #TempValidSets(F_Set	INT)
		INSERT INTO #TempValidSets (F_Set) VALUES (1)
		INSERT INTO #TempValidSets (F_Set) VALUES (2)
		INSERT INTO #TempValidSets (F_Set) VALUES (3)
		INSERT INTO #TempValidSets (F_Set) VALUES (4)
		INSERT INTO #TempValidSets (F_Set) VALUES (5)
		
		DELETE FROM #TempValidSets WHERE F_Set IN (SELECT F_MatchSplitCode FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND ( F_MatchSplitStatusID IS NULL OR F_MatchSplitStatusID = 0))
		SET @StrSQL = ''
		SELECT @StrSQL = @StrSQL + ' UPDATE #temp_MatchSta SET H_' + CAST (F_Set AS NVARCHAR(10)) +' = NULL, A_' + CAST (F_Set AS NVARCHAR(10)) +' = NULL' FROM #TempValidSets
		EXEC (@StrSQL)
	END
		
	SELECT * FROM #temp_MatchSta 


Set Nocount Off
End 



GO


--EXEC [Proc_TE_GetMatchStatistics] 6,  'ENG'