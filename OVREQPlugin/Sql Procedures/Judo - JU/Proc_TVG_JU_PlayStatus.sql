IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_JU_PlayStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_JU_PlayStatus]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称: [Proc_TVG_JU_PlayStatus]
--描    述: 比赛运动员状态
--创 建 人: 宁顺泽
--日    期: 2011年05月19日 星期四
--修改记录：
/*			
	时间					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_TVG_JU_PlayStatus]
	@MatchID						INT,
	@Composition					INT,
	@LanguageCode					CHAR(3) = N'ENG'		-- 默认取当前激活的语言
AS
BEGIN
SET NOCOUNT ON
		
		select 
			N'[Image]'+D.F_DelegationCode AS Noc
			,RD.F_TvLongName AS Name
			,case when ISNULL(MR.F_PointsCharDes4,N'')<>N'' then N'[Image]IRM_DSQ'
				else 
					case when MR.F_IRMID=1 then N'[Image]IRM_DNF'
						when MR.F_IRMID=2 then N'[Image]IRM_DNS'
						else N'' end 
				end AS [IRM]
			,case when @Composition=1 then N'[Image]Card_Blue' else N'[Image]Card_White' end AS Color
			,RD.F_TvShortName AS Name_Short
		from TS_Match AS M
		LEFT JOIN TS_Match_Result AS MR
			ON M.F_MatchID=MR.F_MatchID AND MR.F_CompetitionPosition=@Composition
		LEFT JOIN TR_Register AS R
			ON R.F_RegisterID=MR.F_RegisterID
		LEFT JOIN TR_Register_Des AS RD
			ON RD.F_RegisterID=R.F_RegisterID AND RD.F_LanguageCode=@LanguageCode
		LEFT JOIN TC_Delegation AS D
			ON D.F_DelegationID=R.F_DelegationID
		WHERE M.F_MatchID=@MatchID
		
		
SET NOCOUNT OFF
END


/*

-- Just for test
EXEC [Proc_TVG_JU_PlayStatus] 2,1
*/