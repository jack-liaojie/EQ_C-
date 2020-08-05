IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_UpdateMatchGroupInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_UpdateMatchGroupInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_GF_UpdateMatchGroupInfo]
--描    述：更新前比赛中选中组别的信息，Tee，StartTime
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年10月11日


CREATE PROCEDURE [dbo].[Proc_GF_UpdateMatchGroupInfo](
												@MatchID		    INT,
												@Group              INT,
												@Tee                INT,
												@StartTime          NVARCHAR(50),
												@Result             AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;     -- @Result = 0; 更新失败，标示没有做任何操作！
					   -- @Result = 1; 更新成功！
                       -- @Result = -1; 更新失败，该MatchID或Group不存在！ 
                       -- @Result = -2; 更新失败，该Tee不存在！ 

	SET LANGUAGE ENGLISH					
							
	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
	    SET @Result = -1
	    RETURN
	END
						
	IF NOT EXISTS(SELECT F_CompetitionPositionDes2 FROM TS_Match_Result WHERE F_CompetitionPositionDes2 = @Group)
	BEGIN
	    SET @Result = -1
	    RETURN
	END
	
	IF NOT EXISTS(SELECT F_Order FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_Order = @Tee)
	BEGIN
	    SET @Result = -2
	    RETURN
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
	UPDATE TS_Match_Result SET F_StartTimeNumDes = (CASE WHEN @Tee = 0 THEN NULL ELSE @Tee END)
	, F_StartTimeCharDes = (CASE WHEN @StartTime = '' THEN NULL ELSE @StartTime END)
	WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes2 = @Group
	
	IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
    COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End

GO


