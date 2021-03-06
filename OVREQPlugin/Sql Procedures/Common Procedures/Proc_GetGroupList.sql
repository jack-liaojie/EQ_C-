/****** Object:  StoredProcedure [dbo].[Proc_GetGroupList]    Script Date: 11/19/2009 13:21:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetGroupList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetGroupList]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetGroupList]    Script Date: 11/19/2009 13:21:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GetGroupList]
--描    述：得到Federation\Club\NOC列表
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年05月30日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

CREATE PROCEDURE [dbo].[Proc_GetGroupList](
												@DisciplineID		INT,
												@LanguageCode		CHAR(3),
                                                @GroupType          INT
)
As
Begin
SET NOCOUNT ON 

	
	CREATE TABLE #Tmp_Table(
								F_Name			NVARCHAR(100),
								F_Key			NVARCHAR(4)
							)

	DECLARE @AllDes AS NVARCHAR(100)
	SET @AllDes = ' 全部'

	IF @LanguageCode = 'CHN'
	BEGIN
		SET @AllDes = ' 全部'
	END
	ELSE
	BEGIN
		IF @LanguageCode = 'ENG'
		BEGIN
			SET @AllDes = ' ALL'
		END
	END

	INSERT INTO #Tmp_Table (F_Name, F_Key) VALUES (@AllDes, '-1')
	
    IF(@GroupType = 1)
    BEGIN
		INSERT INTO #Tmp_Table (F_Name, F_Key) 
			SELECT B.F_FederationLongName, A.F_FederationID 
			FROM TC_Federation AS A 
			LEFT JOIN TC_Federation_Des AS B ON A.F_FederationID = B.F_FederationID AND B.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_ActiveFederation AS C ON A.F_FederationID = C.F_FederationID
			WHERE C.F_DisciplineID = @DisciplineID
     END
     ELSE IF(@GroupType = 2)
     BEGIN
		INSERT INTO #Tmp_Table (F_Name, F_Key) 
			SELECT B.F_CountryLongName, A.F_NOC 
			FROM TC_Country AS A 
			LEFT JOIN TC_Country_Des AS B ON A.F_NOC = B.F_NOC AND B.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_ActiveNOC AS C ON A.F_NOC = C.F_NOC
			WHERE C.F_DisciplineID = @DisciplineID
     END
     ELSE IF(@GroupType = 3)
     BEGIN
		INSERT INTO #Tmp_Table (F_Name, F_Key) 
			SELECT B.F_ClubLongName, A.F_ClubID 
			FROM TC_Club AS A 
			LEFT JOIN TC_Club_Des AS B ON A.F_ClubID = B.F_ClubID AND B.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_ActiveClub AS C ON A.F_ClubID = C.F_ClubID
			WHERE C.F_DisciplineID = @DisciplineID
      END
      ELSE IF(@GroupType = 4)
      BEGIN
		INSERT INTO #Tmp_Table (F_Name, F_Key) 
			SELECT B.F_DelegationLongName, A.F_DelegationID 
			FROM TC_Delegation AS A 
			LEFT JOIN TC_Delegation_Des AS B ON A.F_DelegationID = B.F_DelegationID AND B.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_ActiveDelegation AS C ON A.F_DelegationID = C.F_DelegationID
			WHERE C.F_DisciplineID = @DisciplineID
       END

	SELECT F_Name, F_Key FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


