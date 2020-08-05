

/****** Object:  StoredProcedure [dbo].[Proc_CreateGroupResult]    Script Date: 10/24/2011 17:55:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CreateGroupResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CreateGroupResult]
GO


/****** Object:  StoredProcedure [dbo].[Proc_CreateGroupResult]    Script Date: 10/24/2011 17:55:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_CreateGroupResult]
----功		  能：计算小组的积分和排名,可以调用单项的特殊处理存储过程!
----作		  者：郑金勇 
----日		  期: 2011-05-04

CREATE PROCEDURE [dbo].[Proc_CreateGroupResult] (	
	@PhaseID			INT
)	
AS
BEGIN
SET NOCOUNT ON

	DECLARE @DisciplineCode NVARCHAR(10)
    DECLARE @SQL            NVARCHAR(100)
    
    SELECT @DisciplineCode = F_DisciplineCode FROM TS_Phase AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID 
		LEFT JOIN TS_Discipline AS C ON B.F_DisciplineID = C.F_DisciplineID WHERE A.F_PhaseID = @PhaseID
    
    SET @SQL = 'Proc_' + @DisciplineCode + '_CreateGroupResult'
    IF EXISTS (select * from dbo.sysobjects where id = object_id(N'[dbo].' + @SQL) and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
         EXEC @SQL @PhaseID
    END
    ELSE
    BEGIN
        EXEC Proc_CreateGroupResult_Original @PhaseID
    END
	
SET NOCOUNT OFF
END




GO


