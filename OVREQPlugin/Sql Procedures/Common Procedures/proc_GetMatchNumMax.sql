IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetMatchNumMax]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_GetMatchNumMax]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：proc_GetMatchNumMax
----功		  能：获取一个Event中MatchNumb的最大值，方便所有比赛都排上号
----作		  者：王征 
----日		  期: 2009-04-21 

CREATE PROCEDURE [dbo].[proc_GetMatchNumMax] 
	@EventID		INT,
	@Result 		AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON
	SET @Result=0;  -- @Result<0; 	失败
					-- @Result>=0;  成功

	IF NOT EXISTS( Select F_EventID from ts_Event where F_EventID = @EventID )
	BEGIN
		SET @Result = -1
		RETURN
	END

	DECLARE @MatchNum AS INT		
	Select @MatchNum =  Max(F_MatchNum) From TS_Match Where F_PhaseID in(Select F_PhaseID From ts_Phase Where F_EventID = @EventID )
	IF @@error<>0  --事务失败返回  
	BEGIN 
		SET @Result=-1
		RETURN
	END

	SET @Result = @MatchNum
	RETURN

SET NOCOUNT OFF
END







GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
