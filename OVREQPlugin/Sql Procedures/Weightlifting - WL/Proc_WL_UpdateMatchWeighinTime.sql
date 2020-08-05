IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_UpdateMatchWeighinTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_UpdateMatchWeighinTime]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_WL_UpdateMatchWeighinTime]
--描    述: 举重项目,更新称重时间
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2011年2月21日
--修改记录：
/*			
			日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_WL_UpdateMatchWeighinTime]
	@MatchID				INT,
	@Time					VARCHAR(100),
	@Return  			    AS INT OUTPUT

AS
BEGIN
SET NOCOUNT ON

	SET @Return=0;  -- @Return=0; 	更新称重时间失败，标示没有做任何操作！
					-- @Return=1; 	更新称重时间成功，返回！
					-- @Return=-1; 	更新称重时间失败，@MatchID无效
					
	DECLARE @PhaseID  INT
	DECLARE @TMatchID INT
	SET @PhaseID = (SELECT F_PhaseID FROM TS_Match WHERE F_MatchID=@MatchID)
	SET @TMatchID = (SELECT TOP 1 F_MatchID FROM TS_Match WHERE F_PhaseID=@PhaseID AND F_MatchCode='01')
	
	UPDATE TS_Match SET F_MatchComment6 =@Time WHERE F_MatchID = @TMatchID AND F_PhaseID=@PhaseID

	DECLARE @WTIME VARCHAR(100)
	SET @WTIME = (SELECT F_MatchComment6 FROM TS_Match WHERE F_MatchID = @TMatchID AND F_PhaseID=@PhaseID)
	
	IF @WTIME IS NOT NULL
		BEGIN 		
           SET @Return = 1 
           RETURN
		END
SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

-- Just for test
EXEC [Proc_WL_UpdateMatchWeighinTime] 62,'18:49:39:550'

SELECT CONVERT(varchar(100), GETDATE(), 14)

*/



