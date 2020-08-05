IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_GF_GetOutputEventCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_GF_GetOutputEventCode]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



---- =============================================
---- Author:		Wu Dingfang
---- Create date: 2012/09/12
---- Description:	�õ������ʽ��EventCode�����㲻ͬ�����£�ִ�в�ͬ�Ĺ������롣
----�޸ļ�¼�� 
/*			
			ʱ��				�޸���		�޸�����	
*/
---- =============================================


CREATE FUNCTION [dbo].[Func_GF_GetOutputEventCode]
(
    @GenderCode NVARCHAR(10),
	@EventCode	NVARCHAR(30)
)
RETURNS NvarCHAR(30)
AS
BEGIN
	DECLARE @OutputEventCode AS NVARCHAR(30)
    
    --���Ӹ���
	IF @GenderCode = 'M' AND @EventCode = '001'    
	BEGIN
	  SET @OutputEventCode = '001'
	END
	--��������
	ELSE IF @GenderCode = 'M' AND @EventCode = '002'
	BEGIN
	  SET @OutputEventCode = '511'
	END
    --Ů�Ӹ���
	ELSE IF @GenderCode = 'W' AND @EventCode = '101'
	BEGIN
	  SET @OutputEventCode = '101'
	END
	--Ů������
	ELSE IF @GenderCode = 'W' AND @EventCode = '102'
	BEGIN
	  SET @OutputEventCode = '501'
	END


	RETURN @OutputEventCode
END



GO


