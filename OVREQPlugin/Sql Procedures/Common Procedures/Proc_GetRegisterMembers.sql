IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRegisterMembers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRegisterMembers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--��    ��: [Proc_GetRegisterMembers]
--��    ��: ���� RegisterID ��ȡRegMember��Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: ֣����
--��    ��: 2010��12��30��



CREATE PROCEDURE [dbo].[Proc_GetRegisterMembers]
	@RecordID					INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @RegisterID AS INT
	SELECT @RegisterID = F_RegisterID FROM TS_Event_Record WHERE F_RecordID = @RecordID
	
	SELECT A.F_Order, B.F_RegisterCode, C.F_LongName, B.F_NOC FROM TR_Register_Member AS A 
		LEFT JOIN TR_Register AS B ON A.F_MemberRegisterID = B.F_RegisterID
		LEFT JOIN TR_Register_Des AS C ON B.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
		WHERE A.F_RegisterID = @RegisterID

SET NOCOUNT OFF
END



GO


