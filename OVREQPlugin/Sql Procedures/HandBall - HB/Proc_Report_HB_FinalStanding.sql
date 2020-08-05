
/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_FinalStanding]    Script Date: 08/29/2012 16:55:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HB_FinalStanding]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HB_FinalStanding]
GO


/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_FinalStanding]    Script Date: 08/29/2012 16:55:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







----存储过程名称：[Proc_Report_HB_FinalStanding]
----功		  能：得到该项目下最终排名
----作		  者：李燕
----日		  期: 2010-03-23



CREATE PROCEDURE [dbo].[Proc_Report_HB_FinalStanding] 
                   (	
					@EventID    			INT,
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON

        CREATE TABLE #Tmp_Table(
                                F_NOC               NVARCHAR(10),
                                F_NOCDes            NVARCHAR(100),
                                F_DisplayPos        INT,
                                F_Rank              INT,
                                F_Medal             NVARCHAR(50)
							)

	INSERT INTO #Tmp_Table ( F_Rank, F_NOC, F_NOCDes, F_DisplayPos, F_Medal) 
	SELECT  A.F_EventRank, D.F_DelegationCode, E.F_DelegationShortName, A.F_EventDisplayPosition, C.F_MedalLongName
	    FROM TS_Event_Result AS A
    LEFT JOIN TC_Medal_Des AS C ON A.F_MedalID = C.F_MedalID AND C.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Register AS M ON A.F_RegisterID = M.F_RegisterID
    LEFT JOIN TC_Delegation AS D ON M.F_DelegationID = D.F_DelegationID
    LEFT JOIN TC_Delegation_Des AS E ON D.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Event AS F ON A.F_EventID = F.F_EventID
    WHERE A.F_EventID = @EventID  AND F.F_EventStatusID = 110 ORDER BY A.F_EventDisplayPosition 
 
    SELECT * FROM #Tmp_Table
    
SET NOCOUNT OFF
END


GO


