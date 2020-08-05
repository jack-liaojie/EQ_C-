
/****** Object:  StoredProcedure [dbo].[Proc_GetAthleteTree]    Script Date: 10/24/2011 14:06:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAthleteTree]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetAthleteTree]
GO



/****** Object:  StoredProcedure [dbo].[Proc_GetAthleteTree]    Script Date: 10/24/2011 14:06:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_GetAthleteTree]
--描    述：展开Sport底下的所有Federation/NOC/CLUB的运动员
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2009年04月16日

CREATE   PROCEDURE [dbo].[Proc_GetAthleteTree]
                 @GroupTypeID      INT  -------分组索引依据，1：Federation，2：NOC，3：Club, 4:Delegation
As
Begin
SET NOCOUNT ON 

    DECLARE @DisciplineID  int
    SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_Active = 1

    DECLARE @LanguageCode NVARCHAR(3)
    SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1
	
         CREATE TABLE #table_Tree (
                                    F_DisciplineID              INT,
                                    F_DisciplineName            NVARCHAR(50),
									F_GroupTypeID			    NVARCHAR(4) COLLATE DataBase_Default , 
                                    F_GroupCode                 NVARCHAR(10),
									F_GroupLongName		        NVARCHAR(100),
									F_RegisterID    		    INT,
									F_RegisterLongName			NVARCHAR(100),
									F_RegTypeID                 INT,   -----2,Pair;3,Team;1,Player
	                                F_NodeType			        INT,--注释: 0,根节点;1,Team;2,Player
									F_NodeLevel			        INT,
									F_NodeKey			        NVARCHAR(100),
									F_FatherNodeKey		        NVARCHAR(100),
									F_NodeName			        NVARCHAR(100),
                                    F_SexCode                   INT,
                                    F_ImageIdx                  INT,
									F_CompetitorNum		        INT,    ----参赛者数目
                                    F_NonCompetitorNum          INT     ----非参赛者数目
                                 )
	
    
      DECLARE @NodeLevel INT
	  SET @NodeLevel = 1	

      INSERT INTO #table_Tree( F_DisciplineID, F_DisciplineName,F_RegTypeID,F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName, F_GroupTypeID)
		 SELECT A.F_DisciplineID, NULL, -1, -1, @NodeLevel, 'D'+CAST( A.F_DisciplineID AS NVARCHAR(50)), NULL, NULL, '-1'
			 FROM TS_Discipline  AS A 
                WHERE A.F_DisciplineID = @DisciplineID

      IF(@GroupTypeID = 1)
      BEGIN
          SET @NodeLevel = @NodeLevel + 1
	      INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName, F_RegisterID,F_RegisterLongName,F_RegTypeID,F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName)
		       SELECT CAST(A.F_FederationID AS NVARCHAR(9)), NULL, NULL,NULL, 0, 0, @NodeLevel, 'F'+CAST( A.F_FederationID AS NVARCHAR(50)), 'D'+CAST( @DisciplineID AS NVARCHAR(50)) AS F_FatherNodeKey, NULL
					FROM TS_ActiveFederation AS A  WHERE A.F_DisciplineID = @DisciplineID
	
	      INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName,F_RegisterID,F_RegisterLongName,F_RegTypeID, F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName,F_SexCode)
		       SELECT A.F_GroupTypeID, A.F_GroupLongName,B.F_RegisterID, NULL,B.F_RegTypeID, 1,0, 'T'+CAST( B.F_RegisterID AS NVARCHAR(50)), A.F_NodeKey, NULL, B.F_SexCode
		         FROM #table_Tree AS A LEFT JOIN TR_Register AS B ON A.F_GroupTypeID = CAST(B.F_FederationID AS NVARCHAR(9))
                   WHERE B.F_RegisterID NOT IN(SELECT F_MemberRegisterID FROM TR_Register_Member) AND B.F_RegTypeID IN(1,2,3) AND B.F_DisciplineID = @DisciplineID 

------Federation为空的队员
      IF EXISTS (SELECT F_RegisterID FROM TR_Register WHERE F_FederationID IS NULL)
          BEGIN
              INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName, F_RegisterID,F_RegisterLongName,F_RegTypeID,F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName)
                 SELECT '0', NULL, NULL, NULL, 0, 0, @NodeLevel, 'F0', 'D'+CAST( @DisciplineID AS NVARCHAR(50)) AS F_FatherNodeKey, NULL
          END
       INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName,F_RegisterID,F_RegisterLongName,F_RegTypeID, F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName,F_SexCode)
		       SELECT A.F_GroupTypeID, A.F_GroupLongName,B.F_RegisterID, NULL,B.F_RegTypeID, 1,0, 'T'+CAST( B.F_RegisterID AS NVARCHAR(50)), A.F_NodeKey, NULL, B.F_SexCode
		         FROM #table_Tree AS A, TR_Register AS B 
                   WHERE B.F_RegisterID NOT IN(SELECT F_MemberRegisterID FROM TR_Register_Member) AND B.F_RegTypeID IN(1,2,3) AND B.F_DisciplineID = @DisciplineID  AND B.F_FederationID IS NULL AND A. F_GroupTypeID = '0'

     END
     ELSE IF(@GroupTypeID = 2)    
	 BEGIN
		  SET @NodeLevel = @NodeLevel + 1
		  INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName, F_RegisterID,F_RegisterLongName,F_RegTypeID,F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName)
			   SELECT CAST(A.F_NOC AS NVARCHAR(9)), NULL, NULL,NULL,0, 0, @NodeLevel, 'N'+CAST( A.F_NOC AS NVARCHAR(50)), 'D'+CAST( @DisciplineID AS NVARCHAR(50)) AS F_FatherNodeKey, NULL
				 FROM TS_ActiveNOC AS A WHERE A.F_DisciplineID = @DisciplineID


	   INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName, F_RegisterID, F_RegisterLongName,F_RegTypeID,F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName,F_SexCode)
		 SELECT A.F_GroupTypeID, A.F_GroupLongName,B.F_RegisterID, NULL, B.F_RegTypeID, 1,0, 'T'+CAST( B.F_RegisterID AS NVARCHAR(50)), A.F_NodeKey,NULL,B.F_SexCode
			FROM #table_Tree AS A LEFT JOIN TR_Register AS B ON A.F_GroupTypeID =  CAST(B.F_NOC AS NVARCHAR(9)) 
			WHERE B.F_RegisterID NOT IN(SELECT F_MemberRegisterID FROM TR_Register_Member) AND B.F_RegTypeID IN(1,2,3) AND B.F_DisciplineID = @DisciplineID 


----NOC为空的队员
      IF EXISTS (SELECT F_RegisterID FROM TR_Register WHERE F_NOC IS NULL)
      BEGIN
              INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName, F_RegisterID,F_RegisterLongName,F_RegTypeID,F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName)
                 SELECT '0', NULL, NULL, NULL, 0, 0, @NodeLevel, 'N0', 'D'+CAST( @DisciplineID AS NVARCHAR(50)) AS F_FatherNodeKey, NULL
      END

       INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName,F_RegisterID,F_RegisterLongName,F_RegTypeID, F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName,F_SexCode)
		       SELECT A.F_GroupTypeID, A.F_GroupLongName,B.F_RegisterID, NULL,B.F_RegTypeID, 1,0, 'T'+CAST( B.F_RegisterID AS NVARCHAR(50)), A.F_NodeKey, NULL, B.F_SexCode
		         FROM #table_Tree AS A, TR_Register AS B 
                   WHERE B.F_RegisterID NOT IN(SELECT F_MemberRegisterID FROM TR_Register_Member) AND B.F_RegTypeID IN(1,2,3) AND B.F_DisciplineID = @DisciplineID  AND B.F_NOC IS NULL AND A. F_GroupTypeID = '0'

	END
    ELSE IF(@GroupTypeID = 3)
	BEGIN
		 SET @NodeLevel = @NodeLevel + 1
		 INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName, F_RegisterID,F_RegisterLongName,F_RegTypeID,F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName)
			  SELECT CAST(A.F_CLubID AS NVARCHAR(9)), NULL, NULL,NULL,0, 0, @NodeLevel, 'C'+CAST( A.F_ClubID AS NVARCHAR(50)), 'D'+CAST( @DisciplineID AS NVARCHAR(50)) AS F_FatherNodeKey, NULL
				FROM TS_ActiveClub AS A WHERE A.F_DisciplineID = @DisciplineID


		 INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName,F_RegisterID,F_RegisterLongName,F_RegTypeID,F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName,F_SexCode)
	  SELECT A.F_GroupTypeID, A.F_GroupLongName,B.F_RegisterID, NULL, B.F_RegTypeID, 1,0, 'T'+CAST( B.F_RegisterID AS NVARCHAR(50)), A.F_NodeKey,NULL,B.F_SexCode
		FROM #table_Tree AS A LEFT JOIN TR_Register AS B ON A.F_GroupTypeID = CAST(B.F_CLubID AS NVARCHAR(9)) 
		WHERE B.F_RegisterID NOT IN(SELECT F_MemberRegisterID FROM TR_Register_Member) AND B.F_RegTypeID IN(1,2,3) AND B.F_DisciplineID = @DisciplineID 


------Club为空的队员
      IF EXISTS ( SELECT F_RegisterID FROM TR_Register WHERE F_NOC IS NULL)
          BEGIN
              INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName, F_RegisterID,F_RegisterLongName,F_RegTypeID,F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName)
                 SELECT '0', NULL, NULL, NULL, 0, 0, @NodeLevel, 'C0', 'D'+CAST( @DisciplineID AS NVARCHAR(50)) AS F_FatherNodeKey, NULL
          END

       INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName,F_RegisterID,F_RegisterLongName,F_RegTypeID, F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName,F_SexCode)
		       SELECT A.F_GroupTypeID, A.F_GroupLongName,B.F_RegisterID, NULL,B.F_RegTypeID, 1,0, 'T'+CAST( B.F_RegisterID AS NVARCHAR(50)), A.F_NodeKey, NULL, B.F_SexCode
		         FROM #table_Tree AS A, TR_Register AS B 
                   WHERE B.F_RegisterID NOT IN(SELECT F_MemberRegisterID FROM TR_Register_Member) AND B.F_RegTypeID IN(1,2,3) AND B.F_DisciplineID = @DisciplineID  AND B.F_ClubID IS NULL AND A. F_GroupTypeID = '0'

	END
    ELSE IF(@GroupTypeID = 4)
	BEGIN
		 SET @NodeLevel = @NodeLevel + 1
		 INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName, F_RegisterID,F_RegisterLongName,F_RegTypeID,F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName)
			  SELECT CAST(A.F_DelegationID AS NVARCHAR(9)), NULL, NULL,NULL,0, 0, @NodeLevel, 'C'+CAST( A.F_DelegationID AS NVARCHAR(50)), 'D'+CAST( @DisciplineID AS NVARCHAR(50)) AS F_FatherNodeKey, NULL
				FROM TS_ActiveDelegation AS A WHERE A.F_DisciplineID = @DisciplineID


		 INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName,F_RegisterID,F_RegisterLongName,F_RegTypeID,F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName,F_SexCode)
	  SELECT A.F_GroupTypeID, A.F_GroupLongName,B.F_RegisterID, NULL, B.F_RegTypeID, 1,0, 'T'+CAST( B.F_RegisterID AS NVARCHAR(50)), A.F_NodeKey,NULL,B.F_SexCode
		FROM #table_Tree AS A LEFT JOIN TR_Register AS B ON A.F_GroupTypeID = CAST(B.F_DelegationID AS NVARCHAR(9)) 
		WHERE B.F_RegisterID NOT IN(SELECT F_MemberRegisterID FROM TR_Register_Member) AND B.F_RegTypeID IN(1,2,3) AND B.F_DisciplineID = @DisciplineID 

------Delegation为空的队员
      IF EXISTS( SELECT F_RegisterID FROM TR_Register WHERE F_DelegationID IS NULL)
          BEGIN
              INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName, F_RegisterID,F_RegisterLongName,F_RegTypeID,F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName)
                 SELECT '0', NULL, NULL, NULL, 0, 0, @NodeLevel, 'C0', 'D'+CAST( @DisciplineID AS NVARCHAR(50)) AS F_FatherNodeKey, NULL
          END

       INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName,F_RegisterID,F_RegisterLongName,F_RegTypeID, F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName,F_SexCode)
		       SELECT A.F_GroupTypeID, A.F_GroupLongName,B.F_RegisterID, NULL,B.F_RegTypeID, 1,0, 'T'+CAST( B.F_RegisterID AS NVARCHAR(50)), A.F_NodeKey, NULL, B.F_SexCode
		         FROM #table_Tree AS A, TR_Register AS B 
                   WHERE B.F_RegisterID NOT IN(SELECT F_MemberRegisterID FROM TR_Register_Member) AND B.F_RegTypeID IN(1,2,3) AND B.F_DisciplineID = @DisciplineID  AND B.F_DelegationID IS NULL AND A. F_GroupTypeID = '0'

	END
             
	
    WHILE EXISTS (SELECT F_RegisterID FROM #table_Tree WHERE F_NodeLevel = 0)
    BEGIN        
        SET @NodeLevel = @NodeLevel + 1
	    UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0

        INSERT INTO #table_Tree( F_GroupTypeID, F_GroupLongName, F_RegisterID,F_RegisterLongName,F_RegTypeID,F_NodeType,F_NodeLevel,F_NodeKey,F_FatherNodeKey,F_NodeName,F_SexCode)
	        SELECT A.F_GroupTypeID, A.F_GroupLongName, B.F_MemberRegisterID, NULL AS F_RegisterLongName, D.F_RegTypeID, 2 AS F_NodeType, 0 AS F_NodeLevel, 'P'+CAST( B.F_MemberRegisterID AS NVARCHAR(50)) AS F_NodeKey, A.F_NodeKey AS F_FatherNodeKey,NULL AS F_NodeName, D.F_SexCode
	           FROM #table_Tree AS A RIGHT JOIN TR_Register_Member AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TR_Register AS D ON B.F_MemberRegisterID = D.F_RegisterID
				  WHERE A.F_NodeLevel = @NodeLevel

    END 

   UPDATE #table_Tree SET F_SexCode = 0   WHERE F_SexCode IS NULL

   DELETE FROM #table_Tree WHERE F_RegTypeID NOT IN(-1,0,2,3)

   UPDATE #table_Tree SET F_DisciplineName = F_DisciplineLongName, F_NodeName = F_DisciplineLongName, F_ImageIdx = 7
        FROM  #table_Tree AS A LEFT JOIN TS_Discipline_Des AS B ON A.F_DisciplineID = B.F_DisciplineID AND B.F_LanguageCode = @LanguageCode
           WHERE A.F_NodeLevel = 1

   IF(@GroupTypeID = 1)
   BEGIN
   UPDATE #table_Tree SET  F_GroupCode = B.F_FederationCode, F_GroupLongName = C.F_FederationShortName ,F_NodeName = C.F_FederationShortName, F_ImageIdx = 0
        FROM  #table_Tree AS A LEFT JOIN TC_Federation AS B ON A.F_GroupTypeID = CAST(B.F_FederationID AS NVARCHAR(9)) LEFT JOIN TC_Federation_Des AS C ON  B.F_FederationID = C.F_FederationID AND C.F_LanguageCode = @LanguageCode
           WHERE A.F_NodeLevel = 2

   --展现各个Group下的注册人员数目
	   UPDATE #table_Tree SET F_CompetitorNum = B.F_CompetitorNum FROM #table_Tree AS A LEFT JOIN
              (SELECT F_FederationID, COUNT(F_RegisterID) AS  F_CompetitorNum  FROM TR_Register WHERE F_RegTypeID = 1 AND F_DisciplineID = @DisciplineID GROUP BY F_FederationID) AS B
               ON A.F_GroupTypeID = CAST(B.F_FederationID AS NVARCHAR(9)) WHERE A.F_NodeType = 0  
			
   
      UPDATE #table_Tree SET F_NonCompetitorNum = B.F_NonCompetitorNum FROM #table_Tree AS A LEFT JOIN
              (SELECT F_FederationID, COUNT(F_RegisterID) AS  F_NonCompetitorNum  FROM TR_Register WHERE F_RegTypeID IN (4,5) AND F_DisciplineID = @DisciplineID GROUP BY F_FederationID) AS B
               ON A.F_GroupTypeID = CAST(B.F_FederationID AS NVARCHAR(9)) WHERE A.F_NodeType = 0  

--为空的运动员
   UPDATE #table_Tree SET F_CompetitorNum = B.F_CompetitorNum FROM #table_Tree AS A INNER JOIN
              (SELECT F_FederationID, COUNT(F_RegisterID) AS  F_CompetitorNum  FROM TR_Register WHERE F_RegTypeID = 1  AND F_DisciplineID = @DisciplineID GROUP BY F_FederationID) AS B 
             ON A.F_GroupTypeID = 0 AND B.F_FederationID IS NULL WHERE A.F_NodeType = 0  
			
   
   UPDATE #table_Tree SET F_NonCompetitorNum = B.F_NonCompetitorNum FROM #table_Tree AS A INNER JOIN
              (SELECT F_FederationID, COUNT(F_RegisterID) AS  F_NonCompetitorNum  FROM TR_Register WHERE F_RegTypeID IN (4,5) AND F_DisciplineID = @DisciplineID GROUP BY F_FederationID) AS B
               ON A.F_GroupTypeID = 0 AND B.F_FederationID IS NULL WHERE A.F_NodeType = 0  


   END
   ELSE IF(@GroupTypeID = 2)    
   BEGIN
      UPDATE #table_Tree SET  F_GroupCode = F_NOC, F_GroupLongName = F_CountryShortName ,F_NodeName = F_CountryShortName, F_ImageIdx = 0
        FROM  #table_Tree AS A LEFT JOIN TC_Country_Des AS B ON A.F_GroupTypeID = B.F_NOC AND B.F_LanguageCode = @LanguageCode
          WHERE A.F_NodeLevel = 2

    	--展现各个Group下的注册人员数目
	   UPDATE #table_Tree SET F_CompetitorNum = B.F_CompetitorNum FROM #table_Tree AS A LEFT JOIN
              (SELECT F_NOC, COUNT(F_RegisterID) AS  F_CompetitorNum  FROM TR_Register WHERE F_RegTypeID = 1 AND F_DisciplineID = @DisciplineID GROUP BY F_NOC) AS B
               ON A.F_GroupTypeID = B.F_NOC WHERE A.F_NodeType = 0  
			
   
      UPDATE #table_Tree SET F_NonCompetitorNum = B.F_NonCompetitorNum FROM #table_Tree AS A LEFT JOIN
              (SELECT F_NOC, COUNT(F_RegisterID) AS  F_NonCompetitorNum  FROM TR_Register WHERE F_RegTypeID IN (4,5) AND F_DisciplineID = @DisciplineID GROUP BY F_NOC) AS B
               ON A.F_GroupTypeID = B.F_NOC WHERE A.F_NodeType = 0  

--为空的运动员
   UPDATE #table_Tree SET F_CompetitorNum = B.F_CompetitorNum FROM #table_Tree AS A, 
              (SELECT F_NOC, COUNT(F_RegisterID) AS  F_CompetitorNum  FROM TR_Register WHERE F_RegTypeID = 1  AND F_DisciplineID = @DisciplineID GROUP BY F_NOC) AS B 
             WHERE A.F_GroupTypeID = '0' AND B.F_NOC IS NULL AND A.F_NodeType = 0  
			
   UPDATE #table_Tree SET F_NonCompetitorNum = B.F_NonCompetitorNum FROM #table_Tree AS A INNER JOIN
              (SELECT F_NOC, COUNT(F_RegisterID) AS  F_NonCompetitorNum  FROM TR_Register WHERE F_RegTypeID IN (4,5) AND F_DisciplineID = @DisciplineID GROUP BY F_NOC) AS B
               ON A.F_GroupTypeID = '0' AND B.F_NOC IS NULL WHERE A.F_NodeType = 0  

   END
   ELSE IF(@GroupTypeID = 3)
   BEGIN
	  UPDATE #table_Tree SET  F_GroupCode = B.F_ClubCode, F_GroupLongName = C.F_ClubShortName ,F_NodeName = C.F_ClubShortName, F_ImageIdx = 0
		FROM  #table_Tree AS A LEFT JOIN TC_Club AS B ON A.F_GroupTypeID = CAST(B.F_ClubID AS NVARCHAR(9)) LEFT JOIN TC_Club_Des AS C ON B.F_ClubID = C.F_ClubID AND C.F_LanguageCode = @LanguageCode
		  WHERE A.F_NodeLevel = 2

	   --展现各个Group下的注册人员数目
	   UPDATE #table_Tree SET F_CompetitorNum = B.F_CompetitorNum FROM #table_Tree AS A LEFT JOIN
              (SELECT F_ClubID, COUNT(F_RegisterID) AS  F_CompetitorNum  FROM TR_Register WHERE F_RegTypeID = 1 AND F_DisciplineID = @DisciplineID GROUP BY F_ClubID) AS B
               ON A.F_GroupTypeID = CAST(B.F_ClubID AS NVARCHAR(9)) WHERE A.F_NodeType = 0  
			
   
       UPDATE #table_Tree SET F_NonCompetitorNum = B.F_NonCompetitorNum FROM #table_Tree AS A LEFT JOIN
              (SELECT F_ClubID, COUNT(F_RegisterID) AS  F_NonCompetitorNum  FROM TR_Register WHERE F_RegTypeID IN (4,5) AND F_DisciplineID = @DisciplineID GROUP BY F_ClubID) AS B
               ON A.F_GroupTypeID = CAST(B.F_ClubID AS NVARCHAR(9)) WHERE A.F_NodeType = 0 
--为空的运动员
	   UPDATE #table_Tree SET F_CompetitorNum = B.F_CompetitorNum FROM #table_Tree AS A INNER JOIN
				  (SELECT F_ClubID, COUNT(F_RegisterID) AS  F_CompetitorNum  FROM TR_Register WHERE F_RegTypeID = 1 AND F_DisciplineID = @DisciplineID GROUP BY F_ClubID) AS B 
				 ON A.F_GroupTypeID = 0 AND B.F_ClubID IS NULL WHERE A.F_NodeType = 0  
				
	   
	   UPDATE #table_Tree SET F_NonCompetitorNum = B.F_NonCompetitorNum FROM #table_Tree AS A INNER JOIN
				  (SELECT F_ClubID, COUNT(F_RegisterID) AS  F_NonCompetitorNum  FROM TR_Register WHERE F_RegTypeID IN (4,5) AND F_DisciplineID = @DisciplineID GROUP BY F_ClubID) AS B
				   ON A.F_GroupTypeID = 0 AND B.F_ClubID IS NULL WHERE A.F_NodeType = 0  

   END
   ELSE IF(@GroupTypeID = 4)
   BEGIN
	  UPDATE #table_Tree SET  F_GroupCode = B.F_DelegationCode, F_GroupLongName = C.F_DelegationShortName ,F_NodeName = C.F_DelegationShortName, F_ImageIdx = 0
		FROM  #table_Tree AS A LEFT JOIN TC_Delegation AS B ON A.F_GroupTypeID = CAST(B.F_DelegationID AS NVARCHAR(9)) LEFT JOIN TC_Delegation_Des AS C ON B.F_DelegationID = C.F_DelegationID  AND C.F_LanguageCode = @LanguageCode
		  WHERE A.F_NodeLevel = 2

      --展现各个Group下的注册人员数目
	  UPDATE #table_Tree SET F_CompetitorNum = B.F_CompetitorNum FROM #table_Tree AS A LEFT JOIN
              (SELECT F_DelegationID, COUNT(F_RegisterID) AS  F_CompetitorNum  FROM TR_Register WHERE F_RegTypeID = 1 AND F_DisciplineID = @DisciplineID GROUP BY F_DelegationID) AS B
               ON A.F_GroupTypeID = CAST(B.F_DelegationID AS NVARCHAR(9)) WHERE A.F_NodeType = 0  
			
   
       UPDATE #table_Tree SET F_NonCompetitorNum = B.F_NonCompetitorNum FROM #table_Tree AS A LEFT JOIN
              (SELECT F_DelegationID, COUNT(F_RegisterID) AS  F_NonCompetitorNum  FROM TR_Register WHERE F_RegTypeID IN (4,5) AND F_DisciplineID = @DisciplineID GROUP BY F_DelegationID) AS B
               ON A.F_GroupTypeID = CAST(B.F_DelegationID AS NVARCHAR(9)) WHERE A.F_NodeType = 0 

----为空的运动员
	   UPDATE #table_Tree SET F_CompetitorNum = B.F_CompetitorNum FROM #table_Tree AS A INNER JOIN
				  (SELECT F_DelegationID, COUNT(F_RegisterID) AS  F_CompetitorNum  FROM TR_Register WHERE F_RegTypeID = 1 AND F_DisciplineID = @DisciplineID AND F_DelegationID IS NULL GROUP BY F_DelegationID) AS B 
				 ON A.F_GroupTypeID = 0 AND B.F_DelegationID IS NULL WHERE A.F_NodeType = 0  
				
	   
	   UPDATE #table_Tree SET F_NonCompetitorNum = B.F_NonCompetitorNum FROM #table_Tree AS A INNER JOIN
				  (SELECT F_DelegationID, COUNT(F_RegisterID) AS  F_NonCompetitorNum  FROM TR_Register WHERE F_RegTypeID IN (4,5) AND F_DisciplineID = @DisciplineID GROUP BY F_DelegationID) AS B
				   ON A.F_GroupTypeID = 0 AND B.F_DelegationID IS NULL WHERE A.F_NodeType = 0  

   END
   
   UPDATE #table_Tree SET F_GroupCode = NULL, F_GroupLongName = (CASE WHEN @LanguageCode = 'CHN' THEN '其它' ELSE 'Others' END) , F_NodeName = (CASE WHEN @LanguageCode = 'CHN' THEN '其它' ELSE 'Others' END), F_ImageIdx = 0 WHERE F_GroupTypeID = '0'
    

  

   UPDATE #table_Tree SET  F_RegisterLongName = F_LongName, F_NodeName = F_LongName,F_ImageIdx = 4
        FROM  #table_Tree AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
           WHERE A.F_RegTypeID = 3 AND F_SexCode = 1

   
   UPDATE #table_Tree SET  F_RegisterLongName = F_LongName, F_NodeName = F_LongName,F_ImageIdx = 5
    FROM  #table_Tree AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
       WHERE A.F_RegTypeID = 3 AND F_SexCode = 2

  UPDATE #table_Tree SET  F_RegisterLongName = F_LongName, F_NodeName = F_LongName,F_ImageIdx = 6
     FROM  #table_Tree AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
       WHERE A.F_RegTypeID = 3 AND (F_SexCode = 3 OR F_SexCode = 4 )

  UPDATE #table_Tree SET  F_RegisterLongName = F_LongName, F_NodeName = F_LongName,F_ImageIdx = 1
     FROM  #table_Tree AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
       WHERE A.F_RegTypeID = 2 AND F_SexCode = 1
  
 UPDATE #table_Tree SET  F_RegisterLongName = F_LongName, F_NodeName = F_LongName,F_ImageIdx = 2
     FROM  #table_Tree AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
       WHERE A.F_RegTypeID = 2 AND F_SexCode = 2
 
  UPDATE #table_Tree SET  F_RegisterLongName = F_LongName, F_NodeName = F_LongName,F_ImageIdx = 3
     FROM  #table_Tree AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
       WHERE A.F_RegTypeID = 2 AND (F_SexCode = 3 OR F_SexCode = 4 )

   UPDATE #table_Tree SET F_CompetitorNum = 0 FROM #table_Tree WHERE F_NodeType = 0 AND F_CompetitorNum IS NULL
   UPDATE #table_Tree SET F_NonCompetitorNum = 0 FROM #table_Tree WHERE F_NodeType = 0 AND F_NonCompetitorNum IS NULL

   IF NOT EXISTS (SELECT F_RegisterID FROM #table_Tree WHERE F_GroupTypeID = '0' AND F_RegTypeID <> 0)
   BEGIN
     DELETE FROM #table_Tree WHERE F_GroupTypeID = '0' AND F_CompetitorNum = 0 AND F_NonCompetitorNum = 0 
   END

   IF(@LanguageCode = 'CHN')
   BEGIN
       UPDATE #table_Tree SET F_NodeName = (CASE WHEN F_GroupCode  IS NULL THEN ''ELSE F_GroupCode END)
                     +' ['
                     + (CASE WHEN F_NodeName IS NULL THEN '' ELSE F_NodeName END)
                     + ']'
                     + '( 参赛者：' 
                     + CAST(F_CompetitorNum AS NVARCHAR(10)) 
                     +  '  非参赛者：' 
                     + CAST(F_NonCompetitorNum AS NVARCHAR(10))+ ')' WHERE F_NodeType = 0
   END
   ELSE IF(@LanguageCode = 'ENG')
   BEGIN
       UPDATE #table_Tree SET F_NodeName = (CASE WHEN F_GroupCode  IS NULL THEN '' ELSE F_GroupCode END )
                               + ' [' 
                               + (CASE WHEN F_NodeName IS NULL THEN '' ELSE F_NodeName END)
                               + ']' 
                               + '( Athlete：' 
                               + CAST(F_CompetitorNum AS NVARCHAR(10)) +  '  Official：' +  CAST(F_NonCompetitorNum AS NVARCHAR(10))+ ')' WHERE F_NodeType = 0
   END


   SELECT * FROM #table_Tree ORDER BY F_NodeLevel
	

Set NOCOUNT OFF
End	

set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


