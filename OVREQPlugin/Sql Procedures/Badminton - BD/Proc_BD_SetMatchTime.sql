IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_SetMatchTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_SetMatchTime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_BD_SetMatchTime]
--描    述：设置比赛时间
--参数说明： 
--说    明：
--创 建 人：王强
--日    期：2012年06月11日

CREATE PROCEDURE [dbo].[Proc_BD_SetMatchTime](
								@MatchCode NVARCHAR(10),--要改变为的MatchCode
								@TimeStart NVARCHAR(20),--要设置的比赛开始时间
								@TimeEnd   NVARCHAR(20), --要设置的比赛结束时间
								@Result INT OUTPUT
)
As
Begin
SET NOCOUNT ON 
	
	SET @Result = -1
	DECLARE @EventComment NVARCHAR(10)
	DECLARE @MatchID INT
	DECLARE @EventID INT
	SET @EventComment = LEFT(@MatchCode,2)
	
	SELECT @EventID = F_EventID FROM TS_Event_Des WHERE F_EventComment = @EventComment
	IF @EventID IS NULL
	BEGIN
		RETURN
	END
		
	SELECT @MatchID = F_MatchID FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
	WHERE B.F_EventID = @EventID AND A.F_RaceNum = SUBSTRING(@MatchCode, 3, 10)
	IF @MatchID IS NULL
	BEGIN
		RETURN
	END
	
	SET @TimeStart = '2012-01-01 ' + @TimeStart + ':00'
	SET @TimeEnd = '2012-01-01 ' + @TimeEnd + ':00'
	--为新比赛设置场地和顺序
	UPDATE TS_Match SET F_StartTime = @TimeStart,F_EndTime = @TimeEnd
	WHERE F_MatchID = @MatchID
	
	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

