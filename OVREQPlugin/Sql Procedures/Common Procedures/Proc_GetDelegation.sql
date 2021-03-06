/****** Object:  StoredProcedure [dbo].[Proc_GetDelegation]    Script Date: 12/09/2009 10:32:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDelegation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetDelegation]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetDelegation]    Script Date: 12/09/2009 10:32:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GetDelegation]
--描    述：得到所有的Delegation
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2009年11月19日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

CREATE PROCEDURE [dbo].[Proc_GetDelegation](
				 @DisciplineID			INT,
				 @LanguageCode			CHAR(3)
)
As
Begin
SET NOCOUNT ON 


    CREATE TABLE #Tmp_Federations(
								F_DelegationID				    INT,
								F_DelegationCode				NVARCHAR(10),
								F_LanguageCode			        CHAR(3),
								F_DelegationLongName			NVARCHAR(100),
								F_DelegationShortName			NVARCHAR(100),
                                F_DelegationComment 			NVARCHAR(50),
		 					    F_Active			            NVARCHAR(10),
                                F_RegisterNumber                INT,
                                F_DelegationType                NVARCHAR(10),
							)

	 INSERT INTO #Tmp_Federations (F_DelegationID, F_DelegationCode, F_LanguageCode, F_DelegationLongName, F_DelegationShortName, F_DelegationComment,F_DelegationType)
			SELECT A.F_DelegationID, A.F_DelegationCode, B.F_LanguageCode, B.F_DelegationLongName, B.F_DelegationShortName, B.F_DelegationComment, A.F_DelegationType
				FROM TC_Delegation AS A LEFT JOIN TC_Delegation_Des AS B ON A.F_DelegationID = B.F_DelegationID AND B.F_LanguageCode = @LanguageCode
			
		UPDATE #Tmp_Federations SET F_Active = 'Yes' FROM #Tmp_Federations AS A LEFT JOIN TS_ActiveDelegation AS B
			ON A.F_DelegationID = B.F_DelegationID WHERE B.F_DisciplineID = @DisciplineID

		UPDATE #Tmp_Federations SET F_Active = 'No' WHERE F_Active IS NULL
        
        UPDATE #Tmp_Federations SET F_RegisterNumber = B.F_RegisterNumber FROM #Tmp_Federations AS A LEFT JOIN (SELECT F_DelegationID, COUNT(F_RegisterID) AS F_RegisterNumber FROM TR_Register GROUP BY F_DelegationID) AS B
            ON A.F_DelegationID = B.F_DelegationID

        SELECT F_Active AS Active, F_DelegationLongName AS LongName, F_DelegationCode AS Code, F_DelegationShortName AS ShortName, F_RegisterNumber AS RegisterNumber, F_LanguageCode AS LanguageCode, F_DelegationType AS [TYPE], F_DelegationComment AS [Comment], F_DelegationID AS [ID] 
		     FROM #Tmp_Federations ORDER BY F_RegisterNumber desc

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

