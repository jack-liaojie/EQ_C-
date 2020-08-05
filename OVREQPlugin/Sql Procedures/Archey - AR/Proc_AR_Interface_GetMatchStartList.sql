IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_Interface_GetMatchStartList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_Interface_GetMatchStartList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_AR_Interface_GetMatchStartList]
----功		  能：得到射箭项目下站位信息
----作		  者：崔凯
----日		  期: 2012-7-19
----修 改 记  录：
/*

*/


CREATE PROCEDURE [dbo].[Proc_AR_Interface_GetMatchStartList] 
                   (	
					@PhaseID				INT, 
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON

		SELECT MR.F_RegisterID
		,CASE WHEN M.F_MatchCode ='QR' THEN MR.F_Comment 
			  ELSE CAST(I.F_InscriptionRank AS NVARCHAR(10)) END AS F_Bib
		,DBO.Fun_AR_GetTargetNumber(MR.F_Comment) AS [Target]
		,P.F_PhaseID
		,M.F_MatchID 
		FROM TS_Match_Result AS MR
		LEFT JOIN TR_Inscription AS I ON I.F_RegisterID = MR.F_RegisterID
		LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID
		LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID 
		LEFT JOIN TS_Event AS E ON E.F_EventID	= P.F_EventID 
		WHERE  P.F_PhaseID = @PhaseID
		
        
SET NOCOUNT OFF
END


GO

/*
exec Proc_AR_Interface_GetMatchStartList 2, 'CHN'
*/