IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetTeamMatchSplitsAndPlayers_ForAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetTeamMatchSplitsAndPlayers_ForAuto]
GO

/****** Object:  StoredProcedure [dbo].[Proc_JU_GetTeamMatchSplitsAndPlayers]    Script Date: 12/27/2010 13:43:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_JU_GetTeamMatchSplitsAndPlayers_ForAuto]
--描    述：自动团体Match下每场比赛的运动员列表
--参数说明： 
--说    明：
--创 建 人：宁顺泽
--日    期：2011年07月19日


CREATE PROCEDURE [dbo].[Proc_JU_GetTeamMatchSplitsAndPlayers_ForAuto](
												@MatchID		    INT,
												@LanguageCode		CHAR(3)=N'ENG'
)
As
Begin
SET NOCOUNT ON 
			CREATE TABLE #Tmp_Table(
                                F_MatchSplitID			INT,
                                F_Order					INT,
                                F_BlueID				INT,
                                F_WhiteID				INT,
                                F_BlueName				NVARCHAR(100) collate database_default,
                                F_WhiteName				NVARCHAR(100) collate database_default,
                                F_BluePosition          INT,
                                F_WhitePosition         INT,
                                F_WeighClass			NVARCHAR(20) collate database_default
							)
							
    INSERT INTO #Tmp_Table (F_MatchSplitID, F_Order,F_WeighClass) 
		SELECT F_MatchSplitID, F_Order,F_Memo FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 ORDER BY F_Order
	
	declare @BTeamRegisterID int
	declare @WTeamRegisterID int
	
	select @BTeamRegisterID=MRA.F_RegisterID,@WTeamRegisterID=MRB.F_RegisterID 
	from TS_Match AS M 
	LEFT JOIN TS_Match_Result AS MRA 
		ON MRA.F_MatchID=M.F_MatchID AND MRA.F_CompetitionPositionDes1=1
	LEFT JOIN TS_Match_Result AS MRB 
		ON MRB.F_MatchID=M.F_MatchID AND MRB.F_CompetitionPositionDes1=2
	where M.F_MatchID=@MatchID
	
	update #Tmp_Table set F_BlueID=B.F_RegisterID,F_BlueName=B.F_LongName,F_BluePosition=1,
			F_WhiteID=C.F_RegisterID,F_WhiteName=C.F_LongName,F_WhitePosition=2
	from #Tmp_Table AS A LEFT JOIN
	(
		select R.F_RegisterID,RD.F_LongName,PD.F_PositionLongName from TR_Register_Member AS RM
		LEFT JOIN TR_Register AS R 
		ON R.F_RegisterID=RM.F_MemberRegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON RD.F_RegisterID=R.F_RegisterID AND RD.F_LanguageCode=@LanguageCode
	LEFT JOIN TD_Position AS P
		ON P.F_PositionID=Rm.F_PositionID 
	LEFT JOIN TD_Position_Des AS PD 
		ON PD.F_PositionID=P.F_PositionID AND PD.F_LanguageCode=@LanguageCode
		where RM.F_RegisterID=@BTeamRegisterID
		) as B
	ON A.F_WeighClass=b.F_PositionLongName
	LEFT JOIN
	(
		select R.F_RegisterID,RD.F_LongName,PD.F_PositionLongName from TR_Register_Member AS RM
		LEFT JOIN TR_Register AS R 
		ON R.F_RegisterID=RM.F_MemberRegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON RD.F_RegisterID=R.F_RegisterID AND RD.F_LanguageCode=@LanguageCode
	LEFT JOIN TD_Position AS P
		ON P.F_PositionID=Rm.F_PositionID 
	LEFT JOIN TD_Position_Des AS PD 
		ON PD.F_PositionID=P.F_PositionID AND PD.F_LanguageCode=@LanguageCode
		where RM.F_RegisterID=@WTeamRegisterID
		) as C
	ON A.F_WeighClass=c.F_PositionLongName
	
	SELECT F_Order AS MatchOrder, F_MatchSplitID,F_BlueName AS BlueName, F_WhiteName AS WhiteName, F_BlueID, F_WhiteID, F_BluePosition, F_WhitePosition,F_WeighClass AS WeighClass FROM #Tmp_Table

Set NOCOUNT OFF
End	
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO
