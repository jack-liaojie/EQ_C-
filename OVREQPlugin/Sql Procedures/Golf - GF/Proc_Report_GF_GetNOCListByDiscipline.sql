
/****** Object:  StoredProcedure [dbo].[Proc_Report_GF_GetNOCListByDiscipline]    Script Date: 07/20/2011 10:26:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_GetNOCListByDiscipline]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_GetNOCListByDiscipline]
GO

/****** Object:  StoredProcedure [dbo].[Proc_Report_GF_GetNOCListByDiscipline]    Script Date: 07/20/2011 10:26:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








--名    称：[Proc_Report_GF_GetNOCListByDiscipline]
--描    述：得到Discipline下男女参赛国家列表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年09月15日
--修改记录：
/*
           2011年07月20日     李燕    修改NOCList只是含有运动员的NOC
*/


CREATE PROCEDURE [dbo].[Proc_Report_GF_GetNOCListByDiscipline](
												@DisciplineID	    INT,
                                                @DelegationID       INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	
	CREATE TABLE #Tmp_Table(
                                F_DelegationID  INT,
                                F_NOC           NVARCHAR(10),
                                F_NOCDes        NVARCHAR(100)
							)

    IF @DelegationID = -1
    BEGIN
		INSERT INTO #Tmp_Table (F_DelegationID, F_NOC, F_NOCDes)
		SELECT DISTINCT B.F_DelegationID, B.F_DelegationCode, C.F_DelegationLongName FROM TR_Register AS A LEFT JOIN TC_Delegation AS B ON A.F_DelegationID = B.F_DelegationID
        LEFT JOIN TC_Delegation_Des AS C ON B.F_DelegationID = C.F_DelegationID AND C.F_LanguageCode = @LanguageCode 
        WHERE A.F_DisciplineID = @DisciplineID AND A.F_RegTypeID = 1 ORDER BY B.F_DelegationCode
    END
    ELSE
    BEGIN
        INSERT INTO #Tmp_Table (F_DelegationID, F_NOC, F_NOCDes)
        SELECT @DelegationID, A.F_DelegationCode, B.F_DelegationLongName 
        FROM TC_Delegation AS A LEFT JOIN TC_Delegation_Des AS B ON A.F_DelegationID = B.F_DelegationID AND B.F_LanguageCode = @LanguageCode
        WHERE A.F_DelegationID = @DelegationID
    END

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


