/****** Object:  StoredProcedure [dbo].[Proc_AddFunction]    Script Date: 12/29/2009 16:24:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetFunctionCategoryCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetFunctionCategoryCode]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetFunctionCategoryCode]    Script Date: 12/29/2009 15:48:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetFunctionCategoryCode]
--��    ��: ���� Function ��Category Code
--����˵��: 
--˵    ��: 
--�� �� ��: ����
--��    ��: 2009��12��29��



CREATE PROCEDURE [dbo].[Proc_GetFunctionCategoryCode]
AS
BEGIN
SET NOCOUNT ON

		select N'S' AS TT
		union
		select N'T' AS TT
		union
		select N'A' AS TT

SET NOCOUNT OFF
END
