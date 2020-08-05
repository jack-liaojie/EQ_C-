if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_CreateEventResult]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_CreateEventResult]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_CreateEventResult]
----功		  能：生成项目成绩排名,如果存在单项的排名存储过程，则调用单项的，否则调用公共的。
----作		  者：郑金勇 
----日		  期: 2011-02-22 
/*
	修改记录
	序号	日期			修改者		修改内容

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