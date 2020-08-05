IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetVenueCourts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetVenueCourts]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    �ƣ�[Proc_GetVenueCourts]
--��    �����õ�Venue�µ�����Court
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2009��08��13��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��04��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������		
			2012��09Խ14��      ��ǿ        ����CourtOrder��	
*/

CREATE PROCEDURE [dbo].[Proc_GetVenueCourts](
				@VenueID			INT,
				@LanguageCode		CHAR(3)
)
AS
Begin
SET NOCOUNT ON 

	SELECT A.F_CourtCode AS [Code],
		A.F_Order AS [Order],
		B.F_CourtLongName AS [Long Name],
		B.F_CourtShortName AS [Short Name],
			A.F_CourtID AS [ID]
				FROM TC_Court AS A left join TC_Court_Des AS B
					ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode=@LanguageCode
						WHERE F_VenueID = @VenueID

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


go

--exec [Proc_GetVenueCourts] 9, 'CHN'
--exec [Proc_GetVenueCourts] 9, 'GRE'