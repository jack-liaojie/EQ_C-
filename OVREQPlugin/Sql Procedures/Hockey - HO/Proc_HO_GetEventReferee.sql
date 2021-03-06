IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_GetEventReferee]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_GetEventReferee]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_HO_GetEventReferee]
--描    述：得到Match下可选的裁判信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年08月20日


CREATE PROCEDURE [dbo].[Proc_HO_GetEventReferee](
												@MatchID		    INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_RegisterID      INT,
                                F_RegisterName    NVARCHAR(100),
                                F_Delegation      NVARCHAR(100)
							)

    DECLARE @EventID INT
    SELECT @EventID = B.F_EventID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchID = @MatchID

    INSERT INTO #Tmp_Table (F_RegisterID, F_Delegation)
	SELECT I.F_RegisterID, DD.F_DelegationLongName
	FROM TR_Inscription AS I
	LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON D.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	WHERE I.F_EventID = @EventID AND R.F_RegTypeID = 4 AND I.F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Match_Servant WHERE F_MatchID = @MatchID AND F_RegisterID IS NOT NULL)
  
    UPDATE #Tmp_Table SET F_RegisterName = B.F_PrintLongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode

	SELECT F_RegisterName AS LongName, F_Delegation AS [Delegation], F_RegisterID FROM #Tmp_Table ORDER BY LongName

Set NOCOUNT OFF
End

GO


