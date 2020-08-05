IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetVenueByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetVenueByID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetVenueByID]
--��    ��: ���� VenueID ��ȡ Venue ����Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��18��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/



CREATE PROCEDURE [dbo].[Proc_GetVenueByID]
	@VenueID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	select * from TC_Venue as A 
	left join TC_Venue_Des as B 
		on A.F_VenueID = B.F_VenueID  AND B.F_LanguageCode = @LanguageCode 
	where A.F_VenueID = @VenueID

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetVenueByID] 9, 'CHN'
--exec [Proc_GetVenueByID] 9, 'ENG'