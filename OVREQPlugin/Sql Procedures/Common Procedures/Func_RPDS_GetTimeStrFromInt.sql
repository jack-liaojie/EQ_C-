IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_RPDS_GetTimeStrFromInt]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_RPDS_GetTimeStrFromInt]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Func_RPDS_GetTimeStrFromInt]
--��    ��: ������ʱ��ת��Ϊ�ַ���ʱ��, ��ȷ��΢��. ��ʽΪ: 00:00:00.000
--����˵��: 
--˵    ��: 
--�� �� ��: ��Զ��
--��    ��: 2010��5��6�� ������
--�޸ļ�¼��
/*			
			����					�޸���		�޸�����
*/



CREATE FUNCTION [Func_RPDS_GetTimeStrFromInt]
(
	@OrigTime					INT
)
RETURNS NVARCHAR(30)
AS
BEGIN

	IF @OrigTime < 0 OR @OrigTime IS NULL
	BEGIN
		RETURN NULL
	END

	DECLARE @Hour				INT
	DECLARE @Min				INT
	DECLARE @Second				INT
	DECLARE @MiSecond			INT
	
	DECLARE @Hour_Str			NVARCHAR(10)
	DECLARE @Min_Str			NVARCHAR(10)
	DECLARE @Second_Str			NVARCHAR(10)
	DECLARE @MiSecond_Str		NVARCHAR(10)
	
	SET @Hour = @OrigTime / 3600000
	SET @Min = (@OrigTime - 3600000 * @Hour) / 60000
	SET @Second = (@OrigTime - 3600000 * @Hour - 60000 * @Min) / 1000
	SET @MiSecond = @OrigTime - 3600000 * @Hour - 60000 * @Min - 1000 * @Second
	
	SET @Hour_Str = RIGHT(N'0' + CAST(@Hour AS NVARCHAR(10)), 2)
	SET @Min_Str = RIGHT(N'0' + CAST(@Min AS NVARCHAR(10)), 2)
	SET @Second_Str = RIGHT(N'0' + CAST(@Second AS NVARCHAR(10)), 2)
	SET @MiSecond_Str = RIGHT(N'00' + CAST(@MiSecond AS NVARCHAR(10)), 3)
	
	RETURN @Hour_Str + N':' + @Min_Str + N':' + @Second_Str + N'.' + @MiSecond_Str

END

/*

-- Just for test
SELECT dbo.[Func_RPDS_GetTimeStrFromInt] (0)
	, dbo.[Func_RPDS_GetTimeStrFromInt] (55833123)
	, dbo.[Func_RPDS_GetTimeStrFromInt] (455123)
	, dbo.[Func_RPDS_GetTimeStrFromInt] (2055123)
	, dbo.[Func_RPDS_GetTimeStrFromInt] (24123)
	, dbo.[Func_RPDS_GetTimeStrFromInt] (4444123)

*/