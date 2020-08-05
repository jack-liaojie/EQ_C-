
/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_GetMedallists]    Script Date: 08/29/2012 15:35:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HB_GetMedallists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HB_GetMedallists]
GO


/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_GetMedallists]    Script Date: 08/29/2012 15:35:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








--名    称：[Proc_Report_HB_GetMedallists]
--描    述：得到Event的奖牌信息
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年10月28日


CREATE PROCEDURE [dbo].[Proc_Report_HB_GetMedallists](
												@EventID		    INT,
												@EventRank          INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	
	CREATE TABLE #Tmp_Table(
                                F_RegisterID        INT,
                                F_NOC               NVARCHAR(10),
                                F_NOCDes            NVARCHAR(100),
                                F_DisplayPos        INT,
                                F_LongName          NVARCHAR(100),
                                F_ShortName         NVARCHAR(50),
                                F_ShirtNumber       INT,
                                F_Medal             NVARCHAR(50),
							)

	INSERT INTO #Tmp_Table (F_RegisterID, F_NOC, F_NOCDes, F_DisplayPos, F_Medal, F_LongName, F_ShortName, F_ShirtNumber) 
	SELECT B.F_MemberRegisterID, D.F_DelegationCode, E.F_DelegationLongName, A.F_EventDisplayPosition, C.F_MedalLongName, F.F_PrintLongName, F.F_PrintShortName, B.F_ShirtNumber
    FROM TS_Event_Result AS A
    LEFT JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_RegisterID
    LEFT JOIN TC_Medal_Des AS C ON A.F_MedalID = C.F_MedalID AND C.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Register AS M ON B.F_MemberRegisterID = M.F_RegisterID
    LEFT JOIN TC_Delegation AS D ON M.F_DelegationID = D.F_DelegationID
    LEFT JOIN TC_Delegation_Des AS E ON D.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Register_Des AS F ON M.F_RegisterID = F.F_RegisterID AND F.F_LanguageCode = @LanguageCode
    WHERE A.F_EventID = @EventID AND A.F_EventRank = @EventRank AND M.F_RegTypeID = 1 ORDER BY B.F_ShirtNumber
 
    SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


