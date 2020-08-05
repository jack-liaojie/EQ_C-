IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_AddGroupOfficial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_AddGroupOfficial]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_WL_AddGroupOfficial]
--描    述：给Match选择官员
--参数说明： 
--说    明：
--创 建 人：崔凯
--日    期：2011年05月31日


CREATE PROCEDURE [dbo].[Proc_WL_AddGroupOfficial](
												@OfficialGroupID		    INT,
                                                @RegisterID         INT,
                                                @PositionID         INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！

	SET LANGUAGE ENGLISH
	

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
    INSERT INTO TS_Group_Official(F_OfficialGroupID, F_RegisterID,F_PositionID)
    VALUES (@OfficialGroupID, @RegisterID, @PositionID)

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

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO



