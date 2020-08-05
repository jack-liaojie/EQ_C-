IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetEventRank]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetEventRank]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_Report_TE_GetEventRank]
--描    述: 网球项目报表获取单人项目奖牌获得者详细信息  
--参数说明: 
--说    明: 
--创 建 人: 李燕
--日    期: 2010年1月18日
--修改记录：


CREATE PROCEDURE [dbo].[Proc_Report_TE_GetEventRank]
	@EventID						INT,
	@LanguageCode                   NVARCHAR(3)
AS
BEGIN
SET NOCOUNT ON

	--DECLARE @LanguageCode			CHAR(3)
	--SET @LanguageCode = 'ENG'
    
    DECLARE @PlayerRegTypeID     INT
    DECLARE @SexCode             INT
    SELECT @PlayerRegTypeID = F_PlayerRegTypeID, @SexCode = F_SexCode FROM TS_Event WHERE F_EventID = @EventID

    IF(@PlayerRegTypeID = 1)
    BEGIN
		SELECT A.F_EventRank AS [Rank]
			, B.F_MedalLongName AS [Medal]
			, D.F_PrintLongName AS [MemberName]
			, 0 AS [MemberOrder]
			, TD.F_DelegationCode AS [NOCCode]
			, E.F_DelegationLongName AS [NOCLongName]
			, A.F_RegisterID
		FROM TS_Event_Result AS A
		LEFT JOIN TC_Medal_Des AS B 
			ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register AS C
			ON A.F_RegisterID = C.F_RegisterID
		LEFT JOIN TR_Register_Des AS D
			ON A.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Delegation AS TD
		    ON C.F_DelegationID = TD.F_DelegationID
		LEFT JOIN TC_Delegation_Des AS E
			ON TD.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
		WHERE A.F_EventID = @EventID AND A.F_EventRank IS NOT NULL
		    ORDER BY A.F_EventRank
	END
	ELSE IF(@PlayerRegTypeID = 2)
	 BEGIN
		SELECT A.F_EventRank AS [Rank]
			, B.F_MedalLongName AS [Medal]
			, D.F_PrintLongName + '/' + D2.F_PrintLongName AS [MemberName]
			, RM.F_Order   AS [MemberOrder]
			, TD.F_DelegationCode AS [NOCCode]
			, E.F_DelegationLongName AS [NOCLongName]
            , A.F_RegisterID
		FROM TS_Event_Result AS A
		LEFT JOIN TC_Medal_Des AS B 
			ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register AS C
			ON A.F_RegisterID = C.F_RegisterID
		LEFT JOIN TR_Register_Member AS RM
		    ON C.F_RegisterID = RM.F_RegisterID
		LEFT JOIN TR_Register AS R
		    ON RM.F_MemberRegisterID = R.F_RegisterID AND R.F_RegTypeID = 1
		LEFT JOIN TR_Register_Des AS D
			ON R.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode			
		LEFT JOIN TR_Register_Member AS RM2
		    ON C.F_RegisterID = RM2.F_RegisterID AND RM2.F_Order =2
		LEFT JOIN TR_Register AS R2
		    ON RM2.F_MemberRegisterID = R2.F_RegisterID AND R.F_RegTypeID = 1
		LEFT JOIN TR_Register_Des AS D2
			ON R2.F_RegisterID = D2.F_RegisterID AND D2.F_LanguageCode = @LanguageCode	
		LEFT JOIN TC_Delegation AS TD
		    ON C.F_DelegationID = TD.F_DelegationID
		LEFT JOIN TC_Delegation_Des AS E
			ON TD.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
		WHERE  A.F_EventRank IS NOT NULL AND  RM.F_Order =1
			AND A.F_EventID = @EventID ORDER BY A.F_EventRank, D.F_LastName
	END
	ELSE IF(@PlayerRegTypeID = 3)
	 BEGIN
		SELECT A.F_EventRank AS [Rank]
			, B.F_MedalLongName AS [Medal]
			, (select dbo.Fun_TE_GetTeamPlayers(C.F_RegisterID,'CHN')) AS [MemberName]
		    , 0 AS [MemberOrder]
			, TD.F_DelegationCode AS [NOCCode]
			, E.F_DelegationLongName AS [NOCLongName]
			, A.F_RegisterID
		FROM TS_Event_Result AS A
		LEFT JOIN TC_Medal_Des AS B 
			ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register AS C
			ON A.F_RegisterID = C.F_RegisterID
		--LEFT JOIN TR_Register_Member AS R 
		--    ON C.F_RegisterID = R.F_RegisterID
		--LEFT JOIN TR_Register_Des AS D
		--	ON R.F_MemberRegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Delegation AS TD
		    ON C.F_DelegationID = TD.F_DelegationID
		LEFT JOIN TC_Delegation_Des AS E
			ON TD.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
		WHERE  A.F_EventRank IS NOT NULL 
			AND A.F_EventID = @EventID --AND R.F_RegTypeID = 1
	    ORDER BY A.F_EventRank
	END

SET NOCOUNT OFF
END


GO


/*

-- Just for test
EXEC [Proc_Report_TE_GetEventRank] 4 , 'chn'

*/