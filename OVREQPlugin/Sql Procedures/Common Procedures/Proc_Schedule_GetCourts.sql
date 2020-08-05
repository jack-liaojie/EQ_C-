IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetCourts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetCourts]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_Schedule_GetCourts]
--��    ��: ��ȡָ�����ݵ����г���, �������°���
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��17��



CREATE PROCEDURE [dbo].[Proc_Schedule_GetCourts]
	@LanguageCode			CHAR(3),
	@VenueID				INT
AS
BEGIN
SET NOCOUNT ON
	SELECT * FROM TC_Court_Des
	WHERE F_LanguageCode = @LanguageCode
	AND F_CourtID IN ( SELECT F_CourtID FROM TC_Court WHERE F_VenueID = @VenueID )
SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_Schedule_GetCourts] 'CHN', 9