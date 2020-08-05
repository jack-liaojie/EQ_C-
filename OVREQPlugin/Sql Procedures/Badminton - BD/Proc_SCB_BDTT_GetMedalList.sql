IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_BDTT_GetMedalList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_BDTT_GetMedalList]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_SCB_BDTT_GetMedalList]
----功		  能：获取TT,BD-SCB需要的奖牌表
----作		  者：王强
----日		  期: 2011-2-21

CREATE PROCEDURE [dbo].[Proc_SCB_BDTT_GetMedalList]
		@EventID			AS INT
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @Type INT
	SELECT @Type = F_PlayerRegTypeID FROM TS_Event WHERE F_EventID = @EventID
	IF @Type IS NULL
		RETURN
	
	IF @Type = 1 OR @Type = 3
		BEGIN
			SELECT '[Image]' + B2.F_DelegationCode AS NOC, 
			'' AS Name1_ENG, '' AS Name1_CHN,'' AS Name2_ENG, '' AS Name2_CHN,B.F_SBLongName AS Name3_ENG, 
			C.F_SBLongName AS Name3_CHN
					
			FROM TS_Event_Result AS A 
			LEFT JOIN TR_Register AS B1 ON B1.F_RegisterID = A.F_RegisterID
			LEFT JOIN TC_Delegation AS B2 ON B2.F_DelegationID = B1.F_DelegationID
			LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
			LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = 'CHN'
			WHERE A.F_EventID = @EventID AND A.F_MedalID IS NOT NULL ORDER BY A.F_MedalID,B2.F_DelegationCode
		END
	ELSE IF @Type = 2
		BEGIN
			
			SELECT '[Image]' + B.F_DelegationCode AS NOC, D1.F_SBLongName AS Name1_ENG, D2.F_SBLongName AS Name1_CHN, 
					D3.F_SBLongName AS Name2_ENG, D4.F_SBLongName AS Name2_CHN, '' AS Name3_ENG, '' AS Name4_ENG
		    FROM TS_Event_Result AS ER
			LEFT JOIN TR_Register AS A ON A.F_RegisterID = ER.F_RegisterID
			LEFT JOIN TC_Delegation AS B ON B.F_DelegationID = A.F_DelegationID
			LEFT JOIN TR_Register_Member AS C1 ON C1.F_RegisterID = ER.F_RegisterID AND C1.F_Order = 1
			LEFT JOIN TR_Register_Des AS D1 ON D1.F_RegisterID = C1.F_MemberRegisterID AND D1.F_LanguageCode = 'ENG'
			LEFT JOIN TR_Register_Des AS D2 ON D2.F_RegisterID = C1.F_MemberRegisterID AND D2.F_LanguageCode = 'CHN'
			LEFT JOIN TR_Register_Member AS C2 ON C2.F_RegisterID = ER.F_RegisterID AND C2.F_Order = 2
			LEFT JOIN TR_Register_Des AS D3 ON D3.F_RegisterID = C2.F_MemberRegisterID AND D3.F_LanguageCode = 'ENG'
			LEFT JOIN TR_Register_Des AS D4 ON D4.F_RegisterID = C2.F_MemberRegisterID AND D4.F_LanguageCode = 'CHN'
			WHERE ER.F_EventID = @EventID AND ER.F_MedalID IS NOT NULL
			ORDER BY ER.F_MedalID,B.F_DelegationCode
			
		END

    
	
SET NOCOUNT OFF
END

GO





 
