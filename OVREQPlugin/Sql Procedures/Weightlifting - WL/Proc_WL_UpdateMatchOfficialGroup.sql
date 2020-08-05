IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_UpdateMatchOfficialGroup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_UpdateMatchOfficialGroup]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_WL_UpdateMatchOfficialGroup]
--描    述：删除Match下的官员
--参数说明： 
--说    明：
--创 建 人：崔凯
--日    期：2011年01月26日

CREATE PROCEDURE [dbo].[Proc_WL_UpdateMatchOfficialGroup](
						@MatchID		    INT,
                        @OfficialGroupID    INT,
                        @OPType				INT, --0:Add     1:Remove
                        @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！
	DECLARE @pMatchID INT 
		SET @pMatchID = (SELECT top 1 F_MatchID from TS_Match
			WHERE F_MatchCode ='01' AND F_PhaseID = (SELECT top 1 F_PhaseID FROM TS_Match where F_MatchID =@MatchID)
			 ORDER BY F_MatchID)


    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	IF(@OPType =1)
	BEGIN
    DELETE FROM  TS_Match_OfficialGroup WHERE F_MatchID = @pMatchID AND F_OfficialGroupID = @OfficialGroupID

    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
	END
    ELSE
    BEGIN
    IF EXISTS(SELECT F_MatchID FROM  TS_Match_OfficialGroup WHERE F_MatchID = @pMatchID)
		BEGIN
		UPDATE TS_Match_OfficialGroup SET F_OfficialGroupID = @OfficialGroupID WHERE F_MatchID = @pMatchID
		END
	ELSE 
		BEGIN
		 INSERT INTO TS_Match_OfficialGroup(F_OfficialGroupID, F_MatchID)
			VALUES (@OfficialGroupID, @pMatchID)
		END

    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
	END
    COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO



