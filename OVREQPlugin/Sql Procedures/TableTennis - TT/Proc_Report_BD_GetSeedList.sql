IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetSeedList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetSeedList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_Report_BD_GetSeedList]
--描    述：得到Event下运动员列表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年01月26日


CREATE PROCEDURE [dbo].[Proc_Report_BD_GetSeedList](
												@DisciplineID		INT,
                                                @EventCode          CHAR(3),
                                                @SexCode            INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_EventID       INT,
                                F_RegisterID    INT,
                                F_NOC           NVARCHAR(10),
                                F_NOCDes        NVARCHAR(100),
                                F_PrintLN       NVARCHAR(100),
                                F_WorldRank     NVARCHAR(250),
                                F_Seed          INT
							)

    INSERT INTO #Tmp_Table (F_EventID, F_RegisterID, F_NOC, F_NOCDes, F_PrintLN, F_Seed) 
	SELECT A.F_EventID, A.F_RegisterID, E.F_DelegationCode, F.F_DelegationLongName, C.F_PrintLongName, A.F_Seed
	FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TR_Register_Des AS C 
	ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS E ON B.F_DelegationID = E.F_DelegationID LEFT JOIN TC_Delegation_Des AS F ON E.F_DelegationID = F.F_DelegationID AND F.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Event AS G ON A.F_EventID = G.F_EventID
    WHERE G.F_DisciplineID = @DisciplineID AND G.F_EventCode = @EventCode AND G.F_SexCode = @SexCode AND B.F_RegTypeID IN(1, 3)
    AND A.F_Seed > 0 ORDER BY A.F_Seed

    UPDATE #Tmp_Table SET F_WorldRank = B.F_Comment FROM #Tmp_Table AS A LEFT JOIN TR_Register_Comment AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_Title = 'WR'

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

