/****** Object:  StoredProcedure [dbo].[Proc_GetNationByID]    Script Date: 11/20/2009 15:44:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetNationByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetNationByID]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetNationByID]    Script Date: 11/20/2009 15:44:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetNationByID]
--��    ��: ���� ID ��ȡһ�� Nation ����Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: ����
--��    ��: 2009��11��20��



CREATE PROCEDURE [dbo].[Proc_GetNationByID]
	@NationID					INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TC_Nation AS A 
	left join TC_Nation_Des AS B
		ON A.F_NationID = B.F_NationID AND B.F_LanguageCode=@LanguageCode
	WHERE A.F_NationID = @NationID

SET NOCOUNT OFF
END
