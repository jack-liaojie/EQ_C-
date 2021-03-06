IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetMedallists_Individual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetMedallists_Individual]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_Report_TE_GetMedallists_Individual]
--描    述: 网球项目报表获取单人项目奖牌获得者详细信息  
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2010年1月18日
--修改记录：
/*			
			时间				修改人		修改内容	
			2011-2-22           李燕        团体项目
*/



CREATE PROCEDURE [dbo].[Proc_Report_TE_GetMedallists_Individual]
	@EventID						INT,
	@LanguageCode                   NVARCHAR(3)
AS
BEGIN
SET NOCOUNT ON

	--DECLARE @LanguageCode			CHAR(3)
	--SET @LanguageCode = 'ENG'
    
    DECLARE @PlayerRegTypeID     INT
    DECLARE @SexCode             INT
    DECLARE @EventID_S           NVARCHAR(20)
    DECLARE @EventID_D           NVARCHAR(20)
    SELECT @PlayerRegTypeID = F_PlayerRegTypeID, @SexCode = F_SexCode FROM TS_Event WHERE F_EventID = @EventID

    CREATE TABLE #tmp_Medal(
                             [Rank]                INT,
                             [Medal]               NVARCHAR(50),
                             [MemberName]          NVARCHAR(100),
                             [MemberOrder]         INT,
                             [NOCCode]             NVARCHAR(50),
                             [NOCLongName]         NVARCHAR(100),
                             F_RegisterID          INT,
                             F_MemberRegisterID    INT,
                             F_LastName            NVARCHAR(100),
                             F_DisplayPos          INT,
                             F_MemberID            INT
                             )
                             
    IF(@PlayerRegTypeID = 1)
    BEGIN
        INSERT INTO #tmp_Medal([Rank], [Medal],[MemberName], [MemberOrder], [NOCCode], [NOCLongName],  F_RegisterID, F_LastName, F_DisplayPos, F_MemberID)
		  SELECT A.F_EventRank, B.F_MedalLongName, D.F_PrintLongName, 0, TD.F_DelegationCode, E.F_DelegationLongName , A.F_RegisterID
		         ,D.F_LastName, A.F_EventDisplayPosition, A.F_RegisterID
			FROM TS_Event_Result AS A
			LEFT JOIN TC_Medal_Des AS B ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
			LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID
			LEFT JOIN TR_Register_Des AS D ON A.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS TD ON C.F_DelegationID = TD.F_DelegationID
			LEFT JOIN TC_Delegation_Des AS E ON TD.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
			WHERE A.F_EventRank IS NOT NULL AND A.F_EventID = @EventID
	END
	ELSE IF(@PlayerRegTypeID IN (2, 3))
	BEGIN
	    INSERT INTO #tmp_Medal([Rank], [Medal],[MemberName], [MemberOrder], [NOCCode], [NOCLongName],  F_RegisterID, F_LastName, F_DisplayPos, F_MemberID)
		 SELECT A.F_EventRank, B.F_MedalLongName, D.F_PrintLongName, RM.F_Order, TD.F_DelegationCode, E.F_DelegationLongName, A.F_RegisterID
		        , D.F_LastName, A.F_EventDisplayPosition,A.F_RegisterID
			FROM TS_Event_Result AS A
			LEFT JOIN TC_Medal_Des AS B ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
			LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID
			LEFT JOIN TR_Register_Member AS RM ON C.F_RegisterID = RM.F_RegisterID
			LEFT JOIN TR_Register AS R ON RM.F_MemberRegisterID = R.F_RegisterID 
			LEFT JOIN TR_Register_Des AS D ON R.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS TD ON C.F_DelegationID = TD.F_DelegationID
			LEFT JOIN TC_Delegation_Des AS E ON TD.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
			WHERE A.F_EventRank IS NOT NULL AND R.F_RegTypeID = 1 AND A.F_EventID = @EventID --ORDER BY D.F_LastName
	END
	
	
	 SELECT [Rank], [Medal], [MemberName] , [MemberOrder] , [NOCCode],  [NOCLongName], F_RegisterID, F_DisplayPos,F_LastName  FROM #tmp_Medal ORDER BY F_DisplayPos, F_LastName

SET NOCOUNT OFF
END





