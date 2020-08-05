IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetDisciplineID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetDisciplineID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_Schedule_GetDisciplineID]
--��    ��: ��ȡ��ǰ��Ч�����ID, �������°���
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��17��



CREATE PROCEDURE [dbo].[Proc_Schedule_GetDisciplineID]
AS
BEGIN
SET NOCOUNT ON
	SELECT F_DisciplineID 
	FROM TS_Discipline 
	WHERE F_Active = 1 
		AND F_SportID IN (SELECT F_SportID FROM TS_Sport WHERE F_Active = 1 )
SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_Schedule_GetDisciplineID]