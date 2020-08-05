/****** Object:  StoredProcedure [dbo].[Proc_GetColorByID]    Script Date: 11/20/2009 15:44:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetColorByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetColorByID]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetColorByID]    Script Date: 11/20/2009 15:44:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetColorByID]
--��    ��: ���� ID ��ȡһ�� Color ����Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: ����
--��    ��: 2009��11��20��



CREATE PROCEDURE [dbo].[Proc_GetColorByID]
	@ColorID					INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TC_Color AS A 
	left join TC_Color_Des AS B
		ON A.F_ColorID = B.F_ColorID AND B.F_LanguageCode=@LanguageCode
	WHERE A.F_ColorID = @ColorID

SET NOCOUNT OFF
END
