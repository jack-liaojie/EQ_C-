IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AutoSwitch_AutoDrawPhasePosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AutoSwitch_AutoDrawPhasePosition]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    �ƣ�[Proc_AutoSwitch_AutoDrawPhasePosition]
--��    ���������Զ���ǩ --�Զ����Һ��ʵĵ�������Ĵ洢���̽��е���
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2010��07��08��

CREATE PROCEDURE [dbo].[Proc_AutoSwitch_AutoDrawPhasePosition](
	@EventID					INT,
	@PhaseID					INT,
	@NodeType					INT,
    @Type                       INT,  --���̴�Сд/��ť���Ҽ���1Ϊ��д��ʹ��Ԥ�ȴ洢�õ�ǩλ��0ΪСд�������ǩ��
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
