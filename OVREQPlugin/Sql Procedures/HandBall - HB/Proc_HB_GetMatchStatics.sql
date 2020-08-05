
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HB_GetMatchStatics]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HB_GetMatchStatics]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----Author£ºMU XUEFENG
----Date: 2012-08-08
----Modified by:
----
CREATE PROCEDURE [dbo].[Proc_HB_GetMatchStatics] (	
	@MatchID					INT,
	@TeamID						INT,
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #TMP(
							
						F_1 NVARCHAR(10),
						F_2 NVARCHAR(10),
						F_3 NVARCHAR(10),
						F_4 NVARCHAR(10),
						F_5 NVARCHAR(10),
						F_6 NVARCHAR(10),
						F_7 NVARCHAR(10),
						F_8 NVARCHAR(10),
						F_9 NVARCHAR(10),
						F_10 NVARCHAR(10),
						F_11 NVARCHAR(10),
						F_12 NVARCHAR(10),
						F_13 NVARCHAR(10),
						F_14 NVARCHAR(10),
						F_15 NVARCHAR(10),
						F_16 NVARCHAR(10),
						F_17 NVARCHAR(10),
						F_18 NVARCHAR(10),
						F_19 NVARCHAR(10),
						F_20 NVARCHAR(10),
						F_21 NVARCHAR(10),
						F_22 NVARCHAR(10),
						F_23 NVARCHAR(10),
						F_24 NVARCHAR(10),
						F_25 NVARCHAR(10),
						F_26 NVARCHAR(10),
						F_27 NVARCHAR(10),
						F_28 NVARCHAR(10),
						F_29 NVARCHAR(10),
						F_30 NVARCHAR(10),
						F_31 NVARCHAR(10),
						F_32 NVARCHAR(10),
						F_33 NVARCHAR(10),
						F_34 NVARCHAR(10),
						F_35 NVARCHAR(10),
	)

	

	SELECT * FROM #TMP
	
SET NOCOUNT OFF
END

GO


-- EXEC Proc_HB_GetMatchStatics 3216,'ENG'
-- EXEC Proc_HB_GetMatchStatics 265,'ENG',1

