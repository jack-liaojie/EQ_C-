/****** Object:  StoredProcedure [dbo].[Proc_GetFederations]    Script Date: 11/23/2009 16:35:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetFederations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetFederations]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetFederations]    Script Date: 11/23/2009 16:28:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GetFederations]
--描    述：得到所有的代表团，并表明当前Discipline激活的代表团
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年04月29日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

CREATE PROCEDURE [dbo].[Proc_GetFederations](
				 @DisciplineID			INT,
				 @LanguageCode			CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #Tmp_Federations(
								F_FederationID					INT,
								F_FederationCode				NVARCHAR(10),
								F_LanguageCode					CHAR(3),
								F_FederationLongName			NVARCHAR(100),
								F_FederationShortName			NVARCHAR(50),
								F_FederationComment				NVARCHAR(50),
                                F_RegisterNumber                INT,
								F_Active						NVARCHAR(10)
							)

	INSERT INTO #Tmp_Federations (F_FederationID, F_FederationCode, F_LanguageCode, F_FederationLongName, F_FederationShortName, F_FederationComment)
		SELECT A.F_FederationID, A.F_FederationCode, B.F_LanguageCode, B.F_FederationLongName, B.F_FederationShortName, B.F_FederationComment 
			FROM TC_Federation AS A LEFT JOIN TC_Federation_Des AS B ON A.F_FederationID = B.F_FederationID AND B.F_LanguageCode = @LanguageCode
		
	UPDATE #Tmp_Federations SET F_Active = 'Yes' FROM #Tmp_Federations AS A LEFT JOIN TS_ActiveFederation AS B
		ON A.F_FederationID = B.F_FederationID WHERE B.F_DisciplineID = @DisciplineID

	UPDATE #Tmp_Federations SET F_Active = 'No' WHERE F_Active IS NULL

    UPDATE #Tmp_Federations SET F_RegisterNumber = B.F_RegisterNumber FROM #Tmp_Federations AS A LEFT JOIN (SELECT F_FederationID, COUNT(F_RegisterID) AS F_RegisterNumber FROM TR_Register GROUP BY F_FederationID) AS B
            ON A.F_FederationID = B.F_FederationID

	SELECT F_Active AS Active, F_FederationLongName AS LongName, F_FederationCode AS Code, F_FederationShortName AS ShortName, F_RegisterNumber AS RegisterNumber, F_FederationComment AS Comment, F_FederationID AS [ID], F_LanguageCode AS LanguageCode
		FROM #Tmp_Federations ORDER BY F_RegisterNumber desc

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

