IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetSessionTypes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetSessionTypes]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_Schedule_GetSessionTypes]
--��    ��: ��ȡ����(session) ��������, �������°���
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��17��



CREATE PROCEDURE [dbo].[Proc_Schedule_GetSessionTypes]
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	SELECT F_SessionTypeID, F_SessionTypeLongName 
	FROM TC_SessionType_Des
	WHERE F_LanguageCode = @LanguageCode
SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_Schedule_GetSessionTypes] 'CHN'