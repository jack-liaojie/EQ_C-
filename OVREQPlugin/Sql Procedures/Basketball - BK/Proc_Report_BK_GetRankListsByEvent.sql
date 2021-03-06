IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_GetRankListsByEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_GetRankListsByEvent]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_Report_BK_GetRankListsByEvent]
--描    述：得到所有名次信息
--参数说明： 
--说    明：
--创 建 人：吴定昉
--日    期：2010年03月21日
--修改记录： 
/*			
			时间				修改人		修改内容	
			2012年9月20日       吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/


CREATE PROCEDURE [dbo].[Proc_Report_BK_GetRankListsByEvent](
												@EventID		    INT,
												@LanguageCode		    CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_TeamName    NVARCHAR(100),
                                F_TeamNOC     NVARCHAR(10),
                                F_MedalType   NVARCHAR(10),
                                F_MedalID     INT,
                                F_RegisterID  INT,
                                F_MemberName  NVARCHAR(100),
                                F_MemberID    INT,
                                F_Rank		  INT
							)

    INSERT INTO #Tmp_Table (F_MedalID, F_RegisterID, F_MemberID, F_Rank)
    SELECT  ER.F_MedalID, ER.F_RegisterID, RM.F_MemberRegisterID, ER.F_EventRank
    FROM TS_Event_Result AS ER 
    LEFT JOIN TS_Event_Des AS ED ON ER.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Register_Member AS RM ON ER.F_RegisterID = RM.F_RegisterID
    WHERE ER.F_EventID = @EventID AND ER.F_RegisterID IS NOT NULL
    ORDER BY ER.F_EventRank

    delete from #Tmp_Table where F_Rank > 12  

    UPDATE #Tmp_Table SET F_TeamName = B.F_PrintLongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_TeamNOC = C.F_DelegationCode FROM #Tmp_Table AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
    LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
    UPDATE #Tmp_Table SET F_MedalType = B.F_MedalLongName FROM #Tmp_Table AS A LEFT JOIN TC_Medal_Des AS B ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_MemberName = B.F_PrintLongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_MemberID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
    
    --计算总数
    SELECT * FROM #Tmp_Table WHERE F_RegisterID IS NOT NULL order by F_Rank

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

