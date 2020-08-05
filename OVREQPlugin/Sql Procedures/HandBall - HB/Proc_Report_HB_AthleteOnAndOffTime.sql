IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HB_AthleteOnAndOffTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HB_AthleteOnAndOffTime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--名    称：[Proc_Report_FB_TeamStartListWithTime]
--描    述：得到某场比赛的队员上下场时间信息
--参数说明： 
--说    明：
--创 建 人：杨佳鹏
--日    期：2011年03月13日


CREATE PROCEDURE [dbo].[Proc_Report_HB_AthleteOnAndOffTime](
												@MatchID		    INT,
												@RegisterID         INT,
												@Result				NVARCHAR(100) OUTPUT
												)
As
Begin
SET NOCOUNT ON 

	SET @Result = ''
	 CREATE TABLE #Action_Table  ( ActionTime      INT,
								   SpliteCode      INT,
									ActionOrder		INT,
									Comment			NVARCHAR(50)
                                )
    INSERT INTO #Action_Table (ActionTime,SpliteCode,ActionOrder,Comment)
          SELECT
           datepart(HOUR, tma.F_ActionHappenTime)*60+datepart(MINUTE, tma.F_ActionHappenTime)
           ,CONVERT(INT,TMS.F_MatchSplitCode)
           ,ROW_NUMBER() OVER(ORDER BY convert(varchar(10),TMA.F_ActionHappenTime, 108))
           ,CASE WHEN TDA.F_ActionCode='In' THEN '+'ELSE '-' END +CONVERT(NVARCHAR(50),datepart(HOUR, tma.F_ActionHappenTime)*60+datepart(MINUTE, tma.F_ActionHappenTime))+''''
           FROM  TS_Match_ActionList AS TMA
				LEFT JOIN TS_Match_Split_Info AS TMS ON TMS.F_MatchID = TMA.F_MatchID AND TMS.F_MatchSplitID = TMA.F_MatchSplitID 
				LEFT JOIN TD_ActionType AS TDA ON TDA.F_ActionTypeID = TMA.F_ActionTypeID
            WHERE TMA.F_MatchID = @MatchID 
            AND TMA.F_RegisterID = @RegisterID 
            and (TDA.F_ActionCode='In' OR TDA.F_ActionCode='Out')
            AND TMS.F_MatchSplitCode <> '51'
            ORDER BY convert(varchar(10),TMA.F_ActionHappenTime, 108)
     
	DECLARE @HasExtra INT
    IF EXISTS(SELECT * from TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = '3' )
    SET @HasExtra =1
    ELSE
    SET @HasExtra =0
           
     UPDATE #Action_Table SET Comment = Comment + ' HT' WHERE SpliteCode = 1 AND ActionTime>45
     UPDATE #Action_Table SET Comment = Comment + ' FT' WHERE @HasExtra = 1 AND SpliteCode = 2 AND ActionTime>90
     UPDATE #Action_Table SET Comment = Comment + ' ET' WHERE SpliteCode = 3 AND ActionTime>105
     UPDATE #Action_Table SET Comment = Comment + '' WHERE SpliteCode = 4 AND ActionTime>120
     
     DECLARE @Temp NVARCHAR(50)
      DECLARE ActionCursor CURSOR FOR
      SELECT  Comment FROM  #Action_Table
       OPEN ActionCursor
       FETCH NEXT FROM ActionCursor INTO @Temp
        WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @Result = @Result + ','+@Temp
			FETCH NEXT FROM ActionCursor INTO @Temp
		END
		CLOSE ActionCursor
		DEALLOCATE ActionCursor 
	DROP TABLE #Action_Table	
    IF RTRIM(LTRIM(@Result))=''
    Return
    ELSE
    SELECT  @Result =  '('+RIGHT(@Result,LEN(@Result)-1)+')'   
    Return
	Set NOCOUNT OFF
End	

set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO
--DECLARE @Result NVARCHAR(300)
--exec [Proc_Report_HB_AthleteOnAndOffTime]1,3,@Result OUTPUT
--select @Result