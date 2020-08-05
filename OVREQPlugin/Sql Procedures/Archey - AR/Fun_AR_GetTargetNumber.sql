IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_AR_GetTargetNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_AR_GetTargetNumber]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--��    ��: [Fun_AR_GetTargetNumber]
--��    ��: ����λ����ĸȥ��
--�� �� ��: �޿�
--��    ��: 2012-7-23
--�޸ļ�¼��

CREATE FUNCTION [dbo].[Fun_AR_GetTargetNumber]
								(
									@Target						NVARCHAR(20) 
								)
RETURNS INT
AS
BEGIN
	
	DECLARE @ITarget	INT
	DECLARE @Idx		INT
	SET @Idx=LEN(@Target)
	
	WHILE(@Idx >0)
		BEGIN
			DECLARE @TEMP NVARCHAR(20)
			SET @TEMP = SUBSTRING(@Target,1,@Idx)
			IF(ISNUMERIC(@TEMP) = 1)
			BEGIN
				SET @ITarget = CAST(@TEMP AS INT)
				RETURN  @ITarget 
			END
			SET @Idx= @Idx-1
		END	
	RETURN  @ITarget
END



GO


