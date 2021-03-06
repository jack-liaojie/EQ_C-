
GO

/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_GetTeamDrawList]    Script Date: 10/20/2010 13:52:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetTeamDrawList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetTeamDrawList]
GO


GO

/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_GetTeamDrawList]    Script Date: 10/20/2010 13:52:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








--名    称：[Proc_Report_BD_GetTeamDrawList]
--描    述：得到Event下小组成员表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年06月08日
--修	改：2010年10月19日 管仁良 添加组的F_PhaseID,@PoolOrder=-1, 取出所有组


CREATE PROCEDURE [dbo].[Proc_Report_BD_GetTeamDrawList](
                       @EventID         INT,
                       @PoolOrder       INT,
                       @LanguageCode    NVARCHAR(3)
)

As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
    
    CREATE TABLE #Tmp_Table(
							F_PhaseID		 INT,
                            F_Pos            INT,
                            F_RegisterID     INT,
                            F_RegisterLN     NVARCHAR(150), 
                            F_RegisterSN     NVARCHAR(50)
                            )

    DECLARE @PhaseID INT
    
    DECLARE GroupIDCur CURSOR FOR     
			SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND (F_PhaseIsPool = 1 OR F_PhaseType=2) 
			AND (F_Order = CASE @PoolOrder WHEN -1 THEN F_Order ELSE @PoolOrder END) --- 如果为-1则取出所有的组
			ORDER BY F_Order
	OPEN GroupIDCur
	FETCH NEXT FROM GroupIDCur INTO @PhaseID
	WHILE @@FETCH_STATUS = 0
	BEGIN

		INSERT INTO #Tmp_Table(A.F_PhaseID, F_Pos, F_RegisterID, F_RegisterLN, F_RegisterSN)
		SELECT A.F_PhaseID, A.F_PhasePosition, A.F_RegisterID, C.F_PrintShortName + '(' + D.F_DelegationCode + ')', D.F_DelegationCode FROM TS_Phase_Position AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
		LEFT JOIN TR_Register_Des AS C ON B.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
		WHERE A.F_PhaseID = @PhaseID AND A.F_RegisterID > 0 ORDER BY A.F_PhasePosition
    
    FETCH NEXT FROM GroupIDCur INTO @PhaseID		
	END
	CLOSE GroupIDCur
	DEALLOCATE GroupIDCur

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



GO

