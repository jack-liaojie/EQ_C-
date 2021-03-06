IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BDTT_InitTeamMatchSplitType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BDTT_InitTeamMatchSplitType]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_BDTT_InitTeamMatchSplitType]
--描    述：初始化团体赛split类型
--参数说明： 
--说    明：
--创 建 人：王强
--日    期：2012年06月06日

CREATE PROCEDURE [dbo].[Proc_BDTT_InitTeamMatchSplitType]
					@MatchID INT
As
Begin
SET NOCOUNT ON 
	
	DECLARE @RegType INT
	DECLARE @EventInfo NVARCHAR(30)
	SELECT @RegType = C.F_PlayerRegTypeID, @EventInfo = C.F_EventInfo FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
	WHERE A.F_MatchID = @MatchID
	
	IF @RegType != 3
		RETURN
	
	IF @EventInfo IS NULL OR @EventInfo = ''
		RETURN

	CREATE TABLE #TMP_TABLE
	(
		F_Order INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		F_Type NVARCHAR(10),
		F_TypeINT INT
	)
	
	INSERT INTO #TMP_TABLE (F_Type) (SELECT * FROM dbo.Func_Split( @EventInfo,','))
	
	UPDATE #TMP_TABLE SET F_TypeINT = 
	CASE F_Type WHEN 'MS' THEN 1
	            WHEN 'WS' THEN 2
	            WHEN 'MD' THEN 3
	            WHEN 'WD' THEN 4
	            WHEN 'XD' THEN 5
	            ELSE NULL END

	IF EXISTS ( SELECT F_MatchID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitType IS NOT NULL )
		RETURN
	
	UPDATE TS_Match_Split_Info SET F_MatchSplitType = B.F_TypeINT
	FROM TS_Match_Split_Info AS A
	LEFT JOIN #TMP_TABLE AS B ON B.F_Order = A.F_Order 
	WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0

Set NOCOUNT OFF
End	

set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



GO

