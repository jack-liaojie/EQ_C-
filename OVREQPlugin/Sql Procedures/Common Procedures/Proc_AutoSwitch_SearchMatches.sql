
/****** Object:  StoredProcedure [dbo].[Proc_AutoSwitch_SearchMatches]    Script Date: 04/25/2011 13:48:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AutoSwitch_SearchMatches]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AutoSwitch_SearchMatches]
GO



/****** Object:  StoredProcedure [dbo].[Proc_AutoSwitch_SearchMatches]    Script Date: 04/25/2011 13:48:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_AutoSwitch_SearchMatches]
--描    述：根据查询条件查询符合的Match列表 --自动查找合适的单项特殊的存储过程进行调用
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2010年05月20日
--修改记录：
/*
           2011年04月25日     李燕        增加PhaseID、CourtID参数
*/

CREATE PROCEDURE [dbo].[Proc_AutoSwitch_SearchMatches](
				 @DisciplineCode	CHAR(2),
				 @EventID			INT,
				 @DateTime			NVARCHAR(50),
				 @VenueID			INT,
				 @PhaseID           INT,
				 @CourtID           INT
)
As
Begin
SET NOCOUNT ON 
	DECLARE @SQL				AS NVARCHAR(MAX)
	DECLARE @DisciplineProcName AS NVARCHAR(50)
	SET @DisciplineProcName = N'[dbo].[Proc_SearchMatches_' + @DisciplineCode + N']'
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@DisciplineProcName) AND type in (N'P', N'PC'))
	BEGIN
		SET @SQL = N'EXEC ' + @DisciplineProcName + N' ''' + CAST(@DisciplineCode AS NVARCHAR(MAX)) + N''', '+CAST(@EventID AS NVARCHAR(MAX)) + N', '''+ CAST(@DateTime AS NVARCHAR(MAX)) + N''', '+ CAST(@VenueID AS NVARCHAR(MAX))+ N', '+ CAST(@PhaseID AS NVARCHAR(MAX)) + N', '+ CAST(@CourtID AS NVARCHAR(MAX))
		EXEC (@SQL)
		RETURN
	END
	ELSE
	BEGIN
		EXEC [dbo].[Proc_SearchMatches] @DisciplineCode, @EventID, @DateTime, @VenueID, @PhaseID, @CourtID
		RETURN
	END
	
	RETURN
	
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


