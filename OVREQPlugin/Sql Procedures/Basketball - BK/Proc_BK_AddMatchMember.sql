IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BK_AddMatchMember]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BK_AddMatchMember]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_BK_AddMatchMember]
--描    述：给Match选择队员
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年03月10日


CREATE PROCEDURE [dbo].[Proc_BK_AddMatchMember](
												@MatchID		    INT,
                                                @MemberID           INT,
                                                @TeamPos            INT,
                                                @FunctionID         INT,
                                                @PositionID			INT,
                                                @ShirtNumber        INT,
                                                @Result 			AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！


    SET @FunctionID = (CASE WHEN @FunctionID = -1 THEN NULL ELSE @FunctionID END)
    SET @PositionID = (CASE WHEN @PositionID = -1 THEN NULL ELSE @PositionID END)
    SET @ShirtNumber = (CASE WHEN @ShirtNumber = -1 THEN NULL ELSE @ShirtNumber END)

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	

    INSERT INTO TS_Match_Member(F_MatchID, F_CompetitionPosition, F_RegisterID, F_FunctionID,F_PositionID, F_ShirtNumber)
    VALUES (@MatchID, @TeamPos, @MemberID, @FunctionID,@PositionID, @ShirtNumber)

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

