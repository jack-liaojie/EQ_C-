if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_CreateEventResult]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_CreateEventResult]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_CreateEventResult]
----��		  �ܣ�������Ŀ�ɼ�����,������ڵ���������洢���̣�����õ���ģ�������ù����ġ�
----��		  �ߣ�֣���� 
----��		  ��: 2011-02-22 
/*
	�޸ļ�¼
	���	����			�޸���		�޸�����

*/
CREATE PROCEDURE [dbo].[Proc_CreateEventResult] (	
													@EventID			INT
)	
AS
BEGIN
SET NOCOUNT ON

    DECLARE @DisciplineCode NVARCHAR(10)
    DECLARE @SQL            NVARCHAR(100)
    
    SELECT @DisciplineCode = F_DisciplineCode FROM TS_Event AS A LEFT JOIN TS_Discipline AS B ON A.F_DisciplineID = B.F_DisciplineID WHERE A.F_EventID = @EventID
    
    SET @SQL = 'Proc_' + @DisciplineCode + '_CreateEventResult'
    IF EXISTS (select * from dbo.sysobjects where id = object_id(N'[dbo].' + @SQL) and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
         EXEC @SQL @EventID
    END
    ELSE
    BEGIN
        EXEC Proc_CreateEventResult_Original @EventID
    END
    
    
SET NOCOUNT OFF
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


/*
exec [Proc_CreateEventResult] 1
*/