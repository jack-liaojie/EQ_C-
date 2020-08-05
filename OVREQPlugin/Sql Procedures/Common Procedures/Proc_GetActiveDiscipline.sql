IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetActiveDiscipline]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetActiveDiscipline]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_GetActiveDiscipline]
----功		  能：得到当前激活的Discipline信息
----作		  者：李燕
----日		  期: 2009-08-17 

CREATE PROCEDURE [dbo].[Proc_GetActiveDiscipline]

AS
BEGIN
	
SET NOCOUNT ON

    SELECT F_DisciplineID FROM TS_Discipline WHERE F_Active = '1' 

Set NOCOUNT OFF
End	
