IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetPhaseName32]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetPhaseName32]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_Report_BD_GetPhaseName32]
--描    述: 获取32晋级图的PhaseName
--参数说明: 
--说    明: 
--创 建 人: 王强
--日    期: 2012-05-29



CREATE PROCEDURE [dbo].[Proc_Report_BD_GetPhaseName32]
				@EventID  INT,
				@LanguageCode NVARCHAR(10)
AS
BEGIN
SET NOCOUNT ON

	CREATE TABLE #RET_TABLE
	(
		F_PhaseName2P NVARCHAR(100) DEFAULT(''),
		F_PhaseName4P NVARCHAR(100) DEFAULT(''),
		F_PhaseName8P NVARCHAR(100) DEFAULT(''),
		F_PhaseName16P NVARCHAR(100) DEFAULT(''),
		F_PhaseName32P NVARCHAR(100) DEFAULT('')
	)
	
	INSERT INTO #RET_TABLE
	        ( F_PhaseName2P 
	        )
	VALUES  ( '' )
	
	UPDATE #RET_TABLE SET F_PhaseName2P = 
	(
		SELECT TOP 1 B.F_PhaseShortName FROM TS_Phase AS A
		LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.F_PhaseID AND B.F_LanguageCode = 'ENG'
		WHERE A.F_PhaseID IN 
		(
			SELECT X.F_PhaseID FROM TS_Phase_Des AS X
			INNER JOIN TS_Phase AS Y ON Y.F_PhaseID = X.F_PhaseID AND Y.F_EventID = 1
			WHERE X.F_PhaseComment LIKE '%32-1%'
		)
	)
	
	UPDATE #RET_TABLE SET F_PhaseName4P = 
	(
		SELECT TOP 1 B.F_PhaseShortName FROM TS_Phase AS A
		LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.F_PhaseID AND B.F_LanguageCode = @LanguageCode
		WHERE A.F_PhaseID IN 
		(
			SELECT X.F_PhaseID FROM TS_Phase_Des AS X
			INNER JOIN TS_Phase AS Y ON Y.F_PhaseID = X.F_PhaseID AND Y.F_EventID = @EventID
			WHERE X.F_PhaseComment LIKE '%32-2%'
		)
	)
	
	UPDATE #RET_TABLE SET F_PhaseName8P = 
	(
		SELECT TOP 1 B.F_PhaseShortName FROM TS_Phase AS A
		LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.F_PhaseID AND B.F_LanguageCode = @LanguageCode
		WHERE A.F_PhaseID IN 
		(
			SELECT X.F_PhaseID FROM TS_Phase_Des AS X
			INNER JOIN TS_Phase AS Y ON Y.F_PhaseID = X.F_PhaseID AND Y.F_EventID = @EventID
			WHERE X.F_PhaseComment LIKE '%32-3%'
		)
	)
	
	
	UPDATE #RET_TABLE SET F_PhaseName16P = 
	(
		SELECT TOP 1 B.F_PhaseShortName FROM TS_Phase AS A
		LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.F_PhaseID AND B.F_LanguageCode = @LanguageCode
		WHERE A.F_PhaseID IN 
		(
			SELECT X.F_PhaseID FROM TS_Phase_Des AS X
			INNER JOIN TS_Phase AS Y ON Y.F_PhaseID = X.F_PhaseID AND Y.F_EventID = @EventID
			WHERE X.F_PhaseComment LIKE '%32-4%'
		)
	)
	
	
	UPDATE #RET_TABLE SET F_PhaseName32P = 
	(
		SELECT TOP 1 B.F_PhaseShortName FROM TS_Phase AS A
		LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.F_PhaseID AND B.F_LanguageCode = @LanguageCode
		WHERE A.F_PhaseID IN 
		(
			SELECT X.F_PhaseID FROM TS_Phase_Des AS X
			INNER JOIN TS_Phase AS Y ON Y.F_PhaseID = X.F_PhaseID AND Y.F_EventID = @EventID
			WHERE X.F_PhaseComment LIKE '%32-5%'
		)
	)
	
	SELECT * FROM #RET_TABLE

SET NOCOUNT OFF
END

GO


