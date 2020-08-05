IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_GetMatchActionList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_GetMatchActionList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_HO_GetMatchActionList]
--描    述：得到比赛中Action
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年8月27日
--修改记录：

CREATE PROCEDURE [dbo].[Proc_HO_GetMatchActionList]
                 @MatchID             INT,   
                 @LanguageCode        NVARCHAR(3)

AS
BEGIN
   SET NOCOUNT ON
   SELECT A.F_ActionNumberID,A.F_MatchID,A.F_MatchSplitID,A.F_RegisterID, A.F_CompetitionPosition,
		CONVERT(NVARCHAR(100),(datePart(HOUR,A.F_ActionHappenTime)*3600+datePart(MINUTE,A.F_ActionHappenTime)*60)/60)
		+':'+
		CASE WHEN LEN(CONVERT(NVARCHAR(100),datePart(SECOND,A.F_ActionHappenTime)%60))=1
        THEN '0'+CONVERT(NVARCHAR(100),datePart(SECOND,A.F_ActionHappenTime)%60)
        ELSE 
		 CONVERT(NVARCHAR(100),datePart(SECOND,A.F_ActionHappenTime)%60)
        END  
          
          AS F_ActionHappenTime
          , AD.F_ActionLongName, A.F_ActionOrder
          ,B.F_LongName, C.F_ShirtNumber
          ,AC.F_ActionCode
        FROM TS_Match_Split_Info AS D LEFT JOIN TS_Match_ActionList AS A ON A.F_MatchSplitID = D.F_MatchSplitID AND A.F_MatchID = D.F_MatchID
                LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
                LEFT JOIN TS_Match_Member AS C ON A.F_RegisterID = C.F_RegisterID AND A.F_MatchID = C.F_MatchID
                LEFT JOIN TD_ActionType AS AC ON A.F_ActionTypeID = AC.F_ActionTypeID
                LEFT JOIN TD_ActionType_Des AS AD ON AC.F_ActionTypeID = AD.F_ActionTypeID AND AD.F_LanguageCode = @LanguageCode
           WHERE D.F_MatchID = @MatchID AND A.F_MatchSplitID IS NOT NULL ORDER BY CONVERT(INT,D.F_MatchSplitCode), datePart(HOUR,A.F_ActionHappenTime),datePart(MINUTE,A.F_ActionHappenTime),datePart(SECOND,A.F_ActionHappenTime),A.F_ActionOrder  
           
            
Set NOCOUNT OFF
End
	
set QUOTED_IDENTIFIER OFF
go
--exec [Proc_HO_GetMatchActionList] 1,'CHN'