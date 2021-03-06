IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_TVG_BDTT_GetRegisterResultDes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_TVG_BDTT_GetRegisterResultDes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		王强
-- Create date: 2011/4/25
-- Description:	获取TVG需要的运动员对阵成绩描述
-- =============================================

CREATE FUNCTION [dbo].[Fun_TVG_BDTT_GetRegisterResultDes]
								(
									@MatchID INT,
									@RegisterID INT
								)
RETURNS NVARCHAR(20)
AS
BEGIN
	
	DECLARE @PtA INT
	DECLARE @PtB INT
	DECLARE @ResultID INT
	DECLARE @IRMA NVARCHAR(10)
	DECLARE @IRMB NVARCHAR(10)
	DECLARE @Res NVARCHAR(30) = ''
	
	SELECT @PtA = A.F_Points, @IRMA = ISNULL( '(' + B.F_IRMCODE + ')', '' ) FROM TS_Match_Result AS A
	LEFT JOIN TC_IRM AS B ON B.F_IRMID = A.F_IRMID
	WHERE A.F_MatchID = @MatchID AND A.F_ResultID = 1
	
	SELECT @PtB = A.F_Points, @IRMB = ISNULL( '(' + B.F_IRMCODE + ')', '') FROM TS_Match_Result AS A 
	LEFT JOIN TC_IRM AS B ON B.F_IRMID = A.F_IRMID
	WHERE A.F_MatchID = @MatchID AND A.F_ResultID = 2
	
	SELECT @ResultID = F_ResultID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_RegisterID = @RegisterID
	IF @ResultID IS NULL
		RETURN ''
	
	IF @ResultID = 1
		BEGIN
			SET @Res = CONVERT( NVARCHAR(10), @PtA ) + @IRMA + '-' + CONVERT( NVARCHAR(10), @PtB ) + @IRMB + ' W'
		END
	ELSE IF @ResultID = 2
		BEGIN
			SET @Res = CONVERT( NVARCHAR(10), @PtB ) + @IRMB + '-' + CONVERT( NVARCHAR(10), @PtA ) + @IRMA + ' L'
		END
	RETURN @Res

END

GO

