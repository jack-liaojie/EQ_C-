IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_AddMatchOfficial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_AddMatchOfficial]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_HO_AddMatchOfficial]
--描    述：给Match选择裁判员
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年08月20日


CREATE PROCEDURE [dbo].[Proc_HO_AddMatchOfficial](
												@MatchID		    INT,
                                                @RegisterID         INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！

	SET LANGUAGE ENGLISH

    DECLARE @ServantNum INT
    DECLARE @Order INT
    
    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
    
    SELECT @ServantNum = (CASE WHEN MAX(F_ServantNum) IS NULL THEN 0 ELSE MAX(F_ServantNum) END) + 1 FROM TS_Match_Servant WHERE F_MatchID = @MatchID
    SELECT @Order = (CASE WHEN MAX(F_Order) IS NULL THEN 0 ELSE MAX(F_Order) END) + 1 FROM TS_Match_Servant WHERE F_MatchID = @MatchID
        
    INSERT INTO TS_Match_Servant(F_MatchID, F_ServantNum, F_RegisterID, F_Order)
    VALUES (@MatchID, @ServantNum, @RegisterID, @Order)

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



