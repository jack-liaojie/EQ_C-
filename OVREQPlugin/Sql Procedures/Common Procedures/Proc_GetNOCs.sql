/****** Object:  StoredProcedure [dbo].[Proc_GetNOCs]    Script Date: 12/23/2009 13:28:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetNOCs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetNOCs]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetNOCs]    Script Date: 12/23/2009 13:27:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GetNOCs]
--描    述：得到所有的国家，并表明当前Discipline激活的国家
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年04月29日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

CREATE PROCEDURE [dbo].[Proc_GetNOCs](
				 @DisciplineID			INT,
				 @LanguageCode			CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #Tmp_Federations(
								F_GroupID				NVARCHAR(4) COLLATE DataBase_Default,
								F_GroupCode				NVARCHAR(10),
								F_LanguageCode			CHAR(3),
								F_GroupLongName			NVARCHAR(100),
								F_GroupShortName	    NVARCHAR(100),
                                F_RegisterNumber        INT,
								F_Active			    NVARCHAR(10)
							)

	 INSERT INTO #Tmp_Federations (F_GroupID, F_GroupCode, F_LanguageCode, F_GroupLongName, F_GroupShortName)
			SELECT A.F_NOC, A.F_NOC, B.F_LanguageCode, B.F_CountryLongName, B.F_CountryShortName
				FROM TC_Country AS A LEFT JOIN TC_Country_Des AS B ON A.F_NOC = B.F_NOC AND B.F_LanguageCode = @LanguageCode
			
		UPDATE #Tmp_Federations SET F_Active = 'Yes' FROM #Tmp_Federations AS A LEFT JOIN TS_ActiveNOC AS B
			ON A.F_GroupID = B.F_NOC WHERE B.F_DisciplineID = @DisciplineID

		UPDATE #Tmp_Federations SET F_Active = 'No' WHERE F_Active IS NULL
        
         UPDATE #Tmp_Federations SET F_RegisterNumber = B.F_RegisterNumber FROM #Tmp_Federations AS A LEFT JOIN (SELECT F_NOC, COUNT(F_RegisterID) AS F_RegisterNumber FROM TR_Register GROUP BY F_NOC) AS B
            ON A.F_GroupID = B.F_NOC

        SELECT F_Active AS Active, F_GroupLongName AS LongName, F_GroupCode AS Code, F_GroupShortName AS ShortName, F_RegisterNumber AS RegisterNumber, F_GroupID AS [ID], F_LanguageCode AS LanguageCode
		FROM #Tmp_Federations ORDER BY F_RegisterNumber desc

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

