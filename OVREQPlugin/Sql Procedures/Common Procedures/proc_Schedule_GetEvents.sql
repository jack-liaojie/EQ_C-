IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetEvents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetEvents]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_Schedule_GetEvents]
--��    ��: �õ�ĳ�������µ�����С��, �������°���
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��17��

CREATE PROCEDURE [dbo].[Proc_Schedule_GetEvents]
	@DisciplineID			INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	SELECT A.F_EventID, B.F_EventLongName
		FROM TS_Event AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @LanguageCode 
			WHERE A.F_DisciplineID = @DisciplineID ORDER BY A.F_Order
SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_Schedule_GetEvents] 3, 'CHN'