/****** Object:  StoredProcedure [dbo].[Proc_GetOneGroupInfo]    Script Date: 11/19/2009 11:37:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetOneGroupInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetOneGroupInfo]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetOneGroupInfo]    Script Date: 11/19/2009 11:37:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GetOneGroupInfo]
--描    述：得到某个分组的信息
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2009年11月5日

CREATE PROCEDURE [dbo].[Proc_GetOneGroupInfo](
                 @GroupType             INT,   ----1:Federation, 2:NOC, 3:Club
				 @GroupID    			NVARCHAR(9),
				 @LanguageCode			CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #Tmp_Federation(
								F_GroupID   					NVARCHAR(4),
								F_GroupCode				        NVARCHAR(10),
								F_LanguageCode					CHAR(3),
								F_LongName			            NVARCHAR(100),
								F_ShortName			            NVARCHAR(50),
								F_Comment				        NVARCHAR(50),
                                F_Type                          NVARCHAR(10),
							)

	IF(@GroupType = 1)
	BEGIN
		INSERT INTO #Tmp_Federation (F_GroupID, F_GroupCode, F_LanguageCode, F_LongName, F_ShortName, F_Comment, F_Type)
			SELECT @GroupID, A.F_FederationCode, B.F_LanguageCode, B.F_FederationLongName, B.F_FederationShortName, B.F_FederationComment, NULL 
				FROM TC_Federation AS A LEFT JOIN TC_Federation_Des AS B ON A.F_FederationID = B.F_FederationID AND B.F_LanguageCode = @LanguageCode
				 WHERE CAST(A.F_FederationID AS NVARCHAR(9)) = @GroupID
	END
	ELSE IF(@GroupType = 2) 
	BEGIN
  		INSERT INTO #Tmp_Federation (F_GroupID, F_GroupCode, F_LanguageCode, F_LongName, F_ShortName, F_Comment, F_Type)
		   SELECT @GroupID, @GroupID, B.F_LanguageCode, B.F_CountryLongName, B.F_CountryShortName, NULL , NULL
			 FROM TC_Country AS A LEFT JOIN TC_Country_Des AS B ON A.F_NOC = B.F_NOC AND B.F_LanguageCode = @LanguageCode
			  WHERE CAST(A.F_NOC AS NVARCHAR(4)) = @GroupID

	END
	ELSE IF(@GroupType = 3) 
	BEGIN
	  INSERT INTO #Tmp_Federation (F_GroupID, F_GroupCode, F_LanguageCode, F_LongName, F_ShortName, F_Comment, F_Type)
		  SELECT @GroupID, A.F_ClubCode, B.F_LanguageCode, B.F_ClubLongName, B.F_ClubShortName, NULL, NULL 
			 FROM TC_Club AS A LEFT JOIN TC_Club_Des AS B ON A.F_ClubID = B.F_ClubID AND B.F_LanguageCode = @LanguageCode
			  WHERE CAST(A.F_ClubID AS NVARCHAR(9)) = @GroupID
	END
	ELSE IF(@GroupType = 4) 
	BEGIN
	  INSERT INTO #Tmp_Federation (F_GroupID, F_GroupCode, F_LanguageCode, F_LongName, F_ShortName, F_Comment, F_Type)
		  SELECT @GroupID, A.F_DelegationCode, B.F_LanguageCode, B.F_DelegationLongName, B.F_DelegationShortName, B.F_DelegationComment, A.F_DelegationType 
			 FROM TC_Delegation AS A LEFT JOIN TC_Delegation_Des AS B ON A.F_DelegationID = B.F_DelegationID AND B.F_LanguageCode = @LanguageCode
			  WHERE CAST(A.F_DelegationID AS NVARCHAR(9)) = @GroupID
	END      
			

	SELECT F_LongName, F_GroupCode, F_ShortName, F_Comment, F_Type,F_GroupID, F_LanguageCode 
		FROM #Tmp_Federation

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

