IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetActiveFederationInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetActiveFederationInfo]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




----�洢�������ƣ�[Proc_GetActiveFederationInfo]
----��		  �ܣ��õ����еĴ�������Ϣ
----��		  �ߣ�����
----��		  ��: 2009-08-17 
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/

CREATE PROCEDURE [dbo].[Proc_GetActiveFederationInfo](
                                         @DisciplineID    INT,
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

	SELECT A.F_FederationCode AS [FederationCode]
		, B.F_FederationLongName AS [FederationLongName]
		, A.F_FederationID AS [FederationID]
	FROM TC_Federation AS A 
	LEFT JOIN TC_Federation_Des AS B 
		ON A.F_FederationID = B.F_FederationID AND B.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_ActiveFederation AS C 
		ON A.F_FederationID = C.F_FederationID 
	WHERE C.F_DisciplineID = @DisciplineID

Set NOCOUNT OFF
End	


set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


go

--exec [Proc_GetActiveFederationInfo] 5, 'CHN'
--exec [Proc_GetActiveFederationInfo] 5, 'ENG'