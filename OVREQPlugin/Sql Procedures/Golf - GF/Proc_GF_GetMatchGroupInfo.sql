IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_GetMatchGroupInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_GetMatchGroupInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_GF_GetMatchGroupInfo]
--描    述：得到当前比赛中当前选中组别的信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年10月10日


CREATE PROCEDURE [dbo].[Proc_GF_GetMatchGroupInfo](
												@MatchID		    INT,
												@Group              INT
)
As
Begin
SET NOCOUNT ON				
	
	SELECT TOP 1 F_CompetitionPositionDes2 AS [Group], F_StartTimeNumDes AS Tee, F_StartTimeCharDes AS StartTime FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes2 = @Group

Set NOCOUNT OFF
End

GO


