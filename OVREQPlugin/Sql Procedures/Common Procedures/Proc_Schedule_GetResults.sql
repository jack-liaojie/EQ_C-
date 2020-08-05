IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetResults]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_Schedule_GetResults]
--��    ��: ��ȡ���н������, �������°���
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��17��



CREATE PROCEDURE [dbo].[Proc_Schedule_GetResults]
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	SELECT F_ResultID, F_ResultLongName 
	FROM TC_Result_Des 
	WHERE F_LanguageCode = @LanguageCode
SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_Schedule_GetResults] 'CHN'