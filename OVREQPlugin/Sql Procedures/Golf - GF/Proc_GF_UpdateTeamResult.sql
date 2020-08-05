IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_UpdateTeamResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_UpdateTeamResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_GF_UpdateTeamResult]
--描    述: 计算团体比赛成绩
--参数说明： 
--说    明：
--创 建 人：吴定昉
--日    期：2011年07月26日


CREATE PROCEDURE [dbo].[Proc_GF_UpdateTeamResult](
												@MatchID		    INT,
												@IsDetail           INT,
												@Result             AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	
    SET @Result=0;     -- @Result = 0; 更新失败，标示没有做任何操作！
					   -- @Result = 1; 更新成功！
                       -- @Result = -1; 更新失败，该MatchID或CompetitionID或Hole不存在！ 
	
	CREATE TABLE #Table_Team(
	                         F_TeamID            INT,
	                         F_TeamCode          NVARCHAR(10),
	                         F_NOC               NVARCHAR(10),
	                         F_Round1            INT,
	                         F_ToPar1            INT,
	                         F_IRM1       NVARCHAR(10),
	                         F_Round2            INT,
	                         F_ToPar2            INT,
	                         F_IRM2       NVARCHAR(10),
	                         F_Round3            INT,
	                         F_ToPar3            INT,
	                         F_IRM3       NVARCHAR(10),
	                         F_Round4            INT,
	                         F_ToPar4            INT,
	                         F_IRM4       NVARCHAR(10),
	                         F_Total             INT,
	                         F_ToPar             INT,
	                         F_IRM               NVARCHAR(10),
	                         F_Rank              INT,
	                         F_DisplayPos        INT
	                         )
	                         
	INSERT INTO #Table_Team(F_TeamID, F_TeamCode, F_NOC, 
	F_Round1, F_ToPar1, F_IRM1, F_Round2, F_ToPar2, F_IRM2, F_Round3, F_ToPar3, F_IRM3, F_Round4, F_ToPar4, F_IRM4,
	F_Total, F_ToPar, F_IRM, F_Rank, F_DisplayPos)
	EXEC [dbo].[Proc_GF_CalTeamResult] @MatchID,@IsDetail
							
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
	
	--存储团体赛成绩信息
	DECLARE @n INT
	DECLARE @MaxPos INT
	DECLARE @TeamID	        INT
	DECLARE @CompetitionPosition	        INT
	set @n = 1
	select @MaxPos = max(F_DisplayPos) from #Table_Team where F_DisplayPos is not null
    
	while @n <= @MaxPos
	begin
	    select @TeamID = F_TeamID from #Table_Team where F_DisplayPos = @n
	    if @TeamID is null 
	        continue

		set @CompetitionPosition = NULL
		SELECT @CompetitionPosition = F_CompetitionPosition FROM TS_Match_Result 
		WHERE F_MatchID = @TeamMatchID AND F_RegisterID = @TeamID

		IF @CompetitionPosition IS NULL
		BEGIN
			SELECT @CompetitionPosition = max(F_CompetitionPosition)+1 FROM TS_Match_Result 
			WHERE F_MatchID = @TeamMatchID
		  
			IF @CompetitionPosition IS NULL
				SET @CompetitionPosition = 1

			INSERT INTO TS_Match_Result(F_MatchID,F_CompetitionPosition,F_RegisterID) 
			VALUES( @TeamMatchID,@CompetitionPosition,@TeamID )
			
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END			
		END
		
		IF @PhaseOrder = 1
			UPDATE TS_Match_Result SET F_PointsCharDes1 = T.F_Round1,F_PointsCharDes2 = T.F_ToPar1,
			F_IRMID = [dbo].[Fun_GF_GetIRMID](T.F_IRM1)
			FROM TS_Match_Result AS ER LEFT JOIN #Table_Team AS T ON ER.F_RegisterID = T.F_TeamID
			WHERE F_MatchID = @TeamMatchID AND F_CompetitionPosition = @CompetitionPosition 

        IF @PhaseOrder = 2
			UPDATE TS_Match_Result SET F_PointsCharDes1 = T.F_Round2,F_PointsCharDes2 = T.F_ToPar2,
			F_IRMID = [dbo].[Fun_GF_GetIRMID](T.F_IRM2)
			FROM TS_Match_Result AS ER LEFT JOIN #Table_Team AS T ON ER.F_RegisterID = T.F_TeamID
			WHERE F_MatchID = @TeamMatchID AND F_CompetitionPosition = @CompetitionPosition

        IF @PhaseOrder = 3
			UPDATE TS_Match_Result SET F_PointsCharDes1 = T.F_Round3,F_PointsCharDes2 = T.F_ToPar3,
			F_IRMID = [dbo].[Fun_GF_GetIRMID](T.F_IRM3)
			FROM TS_Match_Result AS ER LEFT JOIN #Table_Team AS T ON ER.F_RegisterID = T.F_TeamID
			WHERE F_MatchID = @TeamMatchID AND F_CompetitionPosition = @CompetitionPosition

        IF @PhaseOrder = 4
			UPDATE TS_Match_Result SET F_PointsCharDes1 = T.F_Round4,F_PointsCharDes2 = T.F_ToPar4,
			F_IRMID = [dbo].[Fun_GF_GetIRMID](T.F_IRM4)
			FROM TS_Match_Result AS ER LEFT JOIN #Table_Team AS T ON ER.F_RegisterID = T.F_TeamID
			WHERE F_MatchID = @TeamMatchID AND F_CompetitionPosition = @CompetitionPosition
		
		UPDATE TS_Match_Result SET F_PointsCharDes3 = T.F_Total,F_PointsCharDes4 = T.F_ToPar, 
		F_IRMID = [dbo].[Fun_GF_GetIRMID](T.F_IRM),
		F_Rank = T.F_Rank, F_DisplayPosition = T.F_DisplayPos
		FROM TS_Match_Result AS ER LEFT JOIN #Table_Team AS T ON ER.F_RegisterID = T.F_TeamID
		WHERE F_MatchID = @TeamMatchID AND F_CompetitionPosition = @CompetitionPosition
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
	    set @n = @n + 1
	end

    COMMIT TRANSACTION --成功提交事务
    set @Result = 1
    
Set NOCOUNT OFF
End

GO

/*
EXEC Proc_GF_UpdateTeamResult 6,1,null
*/

