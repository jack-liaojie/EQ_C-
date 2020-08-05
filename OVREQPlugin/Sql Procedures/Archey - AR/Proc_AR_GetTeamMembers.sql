IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_GetTeamMembers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_GetTeamMembers]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--名    称: [Proc_AR_GetTeamMembers]
--描    述: 射箭项目,获取所选比赛队员信息
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2010年10月13日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_AR_GetTeamMembers]
	@MatchID				int,
	@RegisterID				int,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @PhaseCode varchar(10)
	
	select @PhaseCode= p.F_PhaseCode from TS_Phase as p 
		LEFT JOIN TS_Phase AS CP ON CP.F_FatherPhaseID = P.F_PhaseID
		LEFT JOIN TS_Match AS M on M.F_PhaseID = CP.F_PhaseID
		where M.F_MatchID = @MatchID AND P.F_FatherPhaseID = 0
	
	CREATE TABLE #TEMP_TABLE
	(
		F_CompetitionPosition   INT,
		F_RegisterID			INT,
		Bib						NVARCHAR(10),	
		Name					NVARCHAR(100),
		NOC						NVARCHAR(50),
		[Rank]					NVARCHAR(50),
		Total					NVARCHAR(50),
		Point					NVARCHAR(50),
		IRM						NVARCHAR(50),
		[10s]					NVARCHAR(50),
		[Xs]					NVARCHAR(50),
		Remark					NVARCHAR(50),
		[Target]				NVARCHAR(10),		
	)
	
	INSERT INTO #TEMP_TABLE (F_RegisterID,Bib,Name,NOC)
	(SELECT RM.F_MemberRegisterID
		, I.F_InscriptionNum AS Bib
		, RD.F_LongName AS Name
		, DD.F_DelegationShortName AS NOC
		FROM TR_Register_Member AS RM
			LEFT JOIN TS_Match_Result AS MR ON MR.F_RegisterID = RM.F_RegisterID  
			LEFT JOIN TR_Register AS R ON R.F_RegisterID = RM.F_MemberRegisterID 
			LEFT JOIN TR_Register_Des AS RD ON RM.F_MemberRegisterID = RD.F_RegisterID AND RD.F_LanguageCode =  @LanguageCode
			LEFT JOIN TR_Inscription AS I ON I.F_RegisterID = RM.F_MemberRegisterID  
			LEFT JOIN TC_Delegation_Des AS DD ON DD.F_DelegationID = R.F_DelegationID AND DD.F_LanguageCode =  @LanguageCode 
				WHERE RM.F_RegisterID = @RegisterID AND MR.F_MatchID = @MatchID  AND RM.F_Order IN (1,2,3)
	)
	
	UPDATE #TEMP_TABLE SET F_CompetitionPosition = MMR.F_CompetitionPosition,[Rank]= MMR.F_Rank, Total = MMR.F_Points 
        , Point = MMR.F_RealScore , IRM= ID.F_IRMLongName , [10s] = MMR.F_WinPoints  , Xs= MMR.F_LosePoints , Remark = MMR.F_Service 
		FROM #TEMP_TABLE AS A		
		LEFT JOIN TS_Match_Result AS MMR ON MMR.F_RegisterID = A.F_RegisterID 
		LEFT JOIN TS_Match AS M ON MMR.F_MatchID = M.F_MatchID AND M.F_MatchCode = 'QR'
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID  
		LEFT JOIN TC_IRM AS II ON MMR.F_IRMID = II.F_IRMID AND II.F_DisciplineID = E.F_DisciplineID 
		LEFT JOIN TC_IRM_Des AS ID ON II.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = @LanguageCode  	
					AND P.F_PhaseCode IN (CASE WHEN @PhaseCode ='X' THEN 'A,C' 
									   WHEN @PhaseCode ='Y' THEN 'B,D'
									   ELSE @PhaseCode END)
		
		SELECT * FROM #TEMP_TABLE
		
		
	RETURN

SET NOCOUNT OFF
END

GO


/*
exec Proc_AR_GetTeamMembers 66,155 ,'eng'
*/