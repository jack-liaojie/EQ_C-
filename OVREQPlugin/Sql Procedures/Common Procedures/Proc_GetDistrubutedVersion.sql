IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDistrubutedVersion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetDistrubutedVersion]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[Proc_GetDistrubutedVersion]
----��		  �ܣ��õ������͹��İ汾��
----��		  �ߣ�֣���� 
----��		  ��: 2011-07-13

CREATE PROCEDURE [dbo].[Proc_GetDistrubutedVersion] (	
	@TplType				NVARCHAR(20),
	@RscCode				NVARCHAR(50)
)	
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @TplDes AS NVARCHAR(100)
	SELECT @TplDes = F_Parameter FROM TI_IDS_Msg WHERE F_MsgCode = @TplType AND F_RSC = @RscCode
	IF @TplDes IS NULL
	BEGIN
		SET @TplDes = ''
	END
	ELSE
	BEGIN
	
		SET @TplDes = SUBSTRING(@TplDes, 11 , LEN(@TplDes) - 11 - 3)

		SET @TplDes = RIGHT(@TplDes, LEN(@TplDes) - CHARINDEX('.', @TplDes))
		
		SET @TplDes = RIGHT(@TplDes, LEN(@TplDes) - CHARINDEX('.', @TplDes))
		
	END
	
	SELECT @TplDes AS F_DistrubutedVersion
	RETURN
	
SET NOCOUNT OFF
END





GO


--EXEC Proc_GetDistrubutedVersion 'C73A', 'TEM001702'