IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetPhaseNameBefore64]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetPhaseNameBefore64]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_Report_BD_GetPhaseNameBefore64]
----功		  能：获取64人晋级图的PhaseName集合
----作		  者：王强
----日		  期: 2012-05-29 

CREATE PROCEDURE [dbo].[Proc_Report_BD_GetPhaseNameBefore64]
             @EventID INT,
             @LanguageCode NVARCHAR(10)

AS
BEGIN
	
SET NOCOUNT ON

    SELECT C.F_PhaseShortName AS PhaseNames, B.F_PhaseID, F_Order, 
	(SELECT TOP 1 F_PhaseShortName 
		FROM TS_Phase AS D LEFT JOIN TS_Phase_Des AS E ON D.F_PhaseID = E.F_PhaseID AND E.F_LanguageCode =  @LanguageCode
		WHERE F_Order = A.F_Order+1 AND A.F_FatherPhaseID = F_FatherPhaseID AND F_EventID = A.F_EventID) 
		AS 'ToPhaseName'
	FROM TS_Phase AS A JOIN
	(SELECT F_PhaseID, COUNT(F_PhaseID) AS 'F_MatchCount' FROM TS_Match GROUP BY F_PhaseID) AS B ON A.F_PhaseID = B.F_PhaseID
	LEFT JOIN TS_Phase_Des AS C ON A.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode

	WHERE A.F_EventID = @EventID
    AND A.F_PhaseID IN 
    (
		SELECT X.F_PhaseID FROM TS_Phase_Des AS X
	    INNER JOIN TS_Phase AS Y ON Y.F_PhaseID = X.F_PhaseID AND Y.F_EventID = @EventID
	    WHERE X.F_PhaseComment LIKE '%64%'
    )
     ORDER BY F_Order

Set NOCOUNT OFF
End


GO

