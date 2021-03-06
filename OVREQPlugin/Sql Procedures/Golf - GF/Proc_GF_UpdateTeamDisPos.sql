IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_UpdateTeamDisPos]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_UpdateTeamDisPos]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_GF_UpdateTeamDisPos]
--描    述: 更新团体成绩显示顺序
--参数说明： 
--说    明：
--创 建 人：吴定昉
--日    期：2011年08月17日


CREATE PROCEDURE [dbo].[Proc_GF_UpdateTeamDisPos](
												@MatchID		   INT,
												@TeamID            INT,
												@DisPos            INT,
												@Result             AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	
    SET @Result=0;     -- @Result = 0; 更新失败，标示没有做任何操作！
					   -- @Result = 1; 更新成功！
                       -- @Result = -1; 更新失败，该MatchID或CompetitionID或Hole不存在！ 
	
							
	DECLARE @SexCode AS INT
	DECLARE @IndiEventID AS INT
	DECLARE @PhaseOrder AS INT
    DECLARE @TeamEventID AS INT
    DECLARE @TeamMatchID AS INT
    
    SELECT @SexCode = E.F_SexCode, @IndiEventID = E.F_EventID, @PhaseOrder = P.F_Order FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID WHERE M.F_MatchID = @MatchID
    
    SELECT TOP 1 @TeamEventID = F_EventID FROM TS_Event WHERE F_SexCode = @SexCode AND F_PlayerRegTypeID = 3
    
    SELECT TOP 1 @TeamMatchID = F_MatchID FROM TS_Match AS M
    LEFT JOIN TS_Phase AS P ON M.f_Phaseid = P.f_phaseid 
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
    WHERE E.F_SexCode = @SexCode AND E.F_PlayerRegTypeID = 3
    AND E.F_EventID = @TeamEventID AND P.F_Order = @PhaseOrder
	
    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
		
	UPDATE TS_Match_Result SET F_DisplayPosition = @DisPos
	WHERE F_MatchID = @TeamMatchID AND F_RegisterID = @TeamID
		
	IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Result=0
		RETURN
	END

    COMMIT TRANSACTION --成功提交事务
    set @Result = 1
    
Set NOCOUNT OFF
End

GO

/*
EXEC Proc_GF_UpdateTeamDisPos 6,1,1,null
*/

