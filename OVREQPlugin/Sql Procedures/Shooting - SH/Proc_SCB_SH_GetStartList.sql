IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_SH_GetStartList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_SH_GetStartList]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[Proc_SCB_SH_GetStartList]
             @MatchID         INT,
             @GroupNum        INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #TMP(	
						COMPETITION_POS INT,
						Relay NVARCHAR(10),
						FP NVARCHAR(10),
						Bay NVARCHAR(10),
						RegisterID INT,
						StartTime NVARCHAR(10),
						BIB NVARCHAR(50),
						Name NVARCHAR(50),
						NOC NVARCHAR(10),
						DOB NVARCHAR(50),
						IRM NVARCHAR(10),
						StartTime2 NVARCHAR(10)
						
	)
	
	INSERT INTO #TMP EXEC Proc_Report_SH_GetMatchStartList @MatchID, 'ENG'
	
	
	--UPDATE #TMP SET Name = B.F_SBLongName
	--FROM #TMP AS A
	--LEFT JOIN TR_Register_Des AS B ON A.RegisterID = B.F_RegisterID AND B.F_LanguageCode = 'ENG'
	
	
	
	SELECT 			COMPETITION_POS,
					Relay,
					FP,
					Bay,
					RegisterID,
					StartTime,
					BIB,
					Name,
					'[IMAGE]' + NOC AS NOC,
					DOB,
					IRM,
					StartTime2
	FROM #TMP
	
Set NOCOUNT OFF
End

GO


