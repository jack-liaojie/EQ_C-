/****** Object:  StoredProcedure [dbo].[Proc_GetClubs]    Script Date: 11/23/2009 16:51:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetClubs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetClubs]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetClubs]    Script Date: 11/23/2009 16:48:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GetClubs]
--描    述：得到所有的俱乐部，并表明当前Discipline激活的俱乐部
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年04月29日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

CREATE PROCEDURE [dbo].[Proc_GetClubs](
				 @DisciplineID			INT,
				 @LanguageCode			CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #Tmp_Federations(
								F_ClubID				INT,
								F_ClubCode				NVARCHAR(10),
								F_LanguageCode			CHAR(3),
								F_ClubLongName			NVARCHAR(100),
								F_ClubShortName			NVARCHAR(50),
                                F_RegisterNumber        INT,
								F_Active			    NVARCHAR(10)
							)

	 INSERT INTO #Tmp_Federations (F_ClubID, F_ClubCode, F_LanguageCode, F_ClubLongName, F_ClubShortName)
			SELECT A.F_ClubID, A.F_ClubCode, B.F_LanguageCode, B.F_ClubLongName, B.F_ClubShortName 
				FROM TC_Club AS A LEFT JOIN TC_Club_Des AS B ON A.F_ClubID = B.F_ClubID AND B.F_LanguageCode = @LanguageCode
			
		UPDATE #Tmp_Federations SET F_Active = 'Yes' FROM #Tmp_Federations AS A LEFT JOIN TS_ActiveClub AS B
			ON A.F_ClubID = B.F_ClubID WHERE B.F_DisciplineID = @DisciplineID

		UPDATE #Tmp_Federations SET F_Active = 'No' WHERE F_Active IS NULL
        
        UPDATE #Tmp_Federations SET F_RegisterNumber = B.F_RegisterNumber FROM #Tmp_Federations AS A LEFT JOIN (SELECT F_ClubID, COUNT(F_RegisterID) AS F_RegisterNumber FROM TR_Register GROUP BY F_ClubID) AS B
            ON A.F_ClubID = B.F_ClubID

        SELECT F_Active AS Active, F_ClubLongName AS LongName, F_ClubCode AS Code, F_ClubShortName AS ShortName, F_RegisterNumber AS RegisterNumber, F_ClubID AS [ID], F_LanguageCode AS LanguageCode
		FROM #Tmp_Federations ORDER BY F_RegisterNumber desc

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

