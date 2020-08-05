IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AutoSwitch_AutoDrawPhasePosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AutoSwitch_AutoDrawPhasePosition]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_AutoSwitch_AutoDrawPhasePosition]
--描    述：根据自动抽签 --自动查找合适的单项特殊的存储过程进行调用
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2010年07月08日

CREATE PROCEDURE [dbo].[Proc_AutoSwitch_AutoDrawPhasePosition](
	@EventID					INT,
	@PhaseID					INT,
	@NodeType					INT,
    @Type                       INT,  --键盘大小写/按钮左右键，1为大写，使用预先存储好的签位；0为小写，随机抽签。
	@Result						AS INT OUTPUT	
)
As
Begin
SET NOCOUNT ON 
	DECLARE @SQL				AS NVARCHAR(MAX)
	DECLARE @DisciplineProcName AS NVARCHAR(50)
	DECLARE @DisciplineCode		AS NVARCHAR(2)

	IF @NodeType = -1
	BEGIN
		SELECT @DisciplineCode = C.F_DisciplineCode FROM TS_Event AS B 
			LEFT JOIN TS_Discipline AS C ON B.F_DisciplineID = C.F_DisciplineID WHERE B.F_EventID = @EventID
	END
	ELSE IF @NodeType = 0
	BEGIN
		SELECT @DisciplineCode = C.F_DisciplineCode FROM TS_Phase AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID 
			LEFT JOIN TS_Discipline AS C ON B.F_DisciplineID = C.F_DisciplineID WHERE A.F_PhaseID = @PhaseID
	END
	
	SET @DisciplineProcName = N'[dbo].[Proc_AutoDrawPhasePosition_' + @DisciplineCode + N']'

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@DisciplineProcName) AND type in (N'P', N'PC'))
	BEGIN
		SET @SQL = N'EXEC ' + @DisciplineProcName + N' ' + CAST(@EventID AS NVARCHAR(MAX)) + N', ' + CAST(@PhaseID AS NVARCHAR(MAX)) + N', ' + CAST(@NodeType AS NVARCHAR(MAX)) + N', ' + CAST(@Type AS NVARCHAR(MAX)) + N', 0'
		EXEC (@SQL)
		SET @Result = 1
		RETURN
	END
	ELSE
	BEGIN
		EXEC [dbo].[Proc_AutoDrawPhasePosition] @EventID, @PhaseID, @NodeType, @Type, @Result OUTPUT
		RETURN
	END
	
	RETURN
	
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

-- EXEC Proc_AutoSwitch_AutoDrawPhasePosition 1021,0,0
