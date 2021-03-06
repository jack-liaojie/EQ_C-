IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_TeamRoster]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_TeamRoster]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_Report_BK_TeamRoster]
--描    述：得到项目下每个队信息
--参数说明： 
--说    明：
--创 建 人：杨佳鹏
--日    期：2011年06月09日


CREATE PROCEDURE [dbo].[Proc_Report_BK_TeamRoster]
(
   @DisciplineID	INT,
   @EventID         INT,
   @DelegationID    INT,
   @RegisterID		INT,
   @LanguageCode    CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
CREATE TABLE #Tmp_Table(
                                F_DelegationID       INT,
                                F_RegisterID         INT,
                                F_NOC                NVARCHAR(10),
                                F_TeamLong             NVARCHAR(100),
                                F_TeamShort             NVARCHAR(100),
                                F_EventID            INT,
                                F_RSCCode			 NVARCHAR(100),
                                F_EventName          NVARCHAR(100),
                                F_EventNameCHN       NVARCHAR(100),
                                F_EventOrder         INT,
                                F_AgeMonths             int, -- 某个队伍下的队员的总年龄,以月数为单位
                                F_YearAge			NVARCHAR(150),
                                F_TotalAge			NVARCHAR(150)
							)

     INSERT INTO #Tmp_Table (F_DelegationID, F_RegisterID, F_NOC, F_TeamLong, F_TeamShort,F_EventID,F_RSCCode, F_EventName, F_EventOrder) 
	SELECT A.F_DelegationID, A.F_RegisterID, C.F_DelegationCode, D.F_DelegationLongName, D.F_DelegationShortName, E.F_EventID,CONVERT(NVARCHAR(100),H.F_DisciplineCode) + CONVERT(NVARCHAR(100),I.F_GenderCode) + CONVERT(NVARCHAR(100),F.F_EventCode) + '000' ,G.F_EventLongName, F.F_Order
	FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS C ON A.F_DelegationID = C.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS D ON C.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = @LanguageCode
	INNER JOIN TR_Inscription AS E ON A.F_RegisterID = E.F_RegisterID
	LEFT JOIN TS_Event AS F ON E.F_EventID = F.F_EventID
	LEFT JOIN TS_Event_Des AS G ON F.F_EventID = G.F_EventID AND G.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Discipline AS H ON H.F_DisciplineID = A.F_DisciplineID
	LEFT JOIN TC_Sex AS I ON A.F_SexCode = I.F_SexCode
	WHERE A.F_RegTypeID = 3 AND A.F_DisciplineID = @DisciplineID AND ( @EventID = -1 OR E.F_EventID = @EventID)AND(@DelegationID = -1  OR A.F_DelegationID = @DelegationID)AND (@RegisterID = -1 OR A.F_RegisterID = @RegisterID)
	ORDER BY C.F_DelegationCode, A.F_SexCode

    UPDATE #Tmp_Table SET F_EventNameCHN = B.F_EventLongName FROM #Tmp_Table AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = 'CHN'
    
    update #Tmp_Table set F_AgeMonths=(select  x.Ages from (
								  select a.F_RegisterID,avg(DATEDIFF(M, h.F_Birth_Date,GETDATE())) as Ages
                                  from TR_Register as a
                                  inner join TR_Register_Member as g on a.F_RegisterID=g.F_RegisterID
								  inner join TR_Register as h on g.F_MemberRegisterID=h.F_RegisterID
								  where h.F_RegTypeID = 1
								  group by a.F_RegisterID
							     ) as X
							     where #Tmp_Table.F_RegisterID = X.F_RegisterID)

	
	IF @LanguageCode = 'CHN'
	update #Tmp_Table SET F_YearAge = F_AgeMonths/12,F_TotalAge = cast(F_AgeMonths/12 as Nvarchar(50))+' 岁 '+cast(F_AgeMonths%12 as nvarchar(50))+' 月'
	ELSE
	update #Tmp_Table SET F_YearAge = F_AgeMonths/12,F_TotalAge = cast(F_AgeMonths/12 as Nvarchar(50))+' years '+cast(F_AgeMonths%12 as nvarchar(50))+' months'
    select * from #Tmp_Table

Set NOCOUNT OFF
End	

set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

--exec [Proc_Report_BK_TeamRoster] 1,-1,-1, -1,'ENG'