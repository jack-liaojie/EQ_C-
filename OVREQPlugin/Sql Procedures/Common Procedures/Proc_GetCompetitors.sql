

/****** Object:  StoredProcedure [dbo].[Proc_GetCompetitors]    Script Date: 10/27/2011 18:47:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCompetitors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCompetitors]
GO


/****** Object:  StoredProcedure [dbo].[Proc_GetCompetitors]    Script Date: 10/27/2011 18:47:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_GetCompetitors]
--描    述：得到树节点下的运动员
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2009年04月16日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月08日		邓年彩		添加 Bib 号的显示
*/

CREATE PROCEDURE [dbo].[Proc_GetCompetitors]
                 @GroupType          INT,   ---1,Group by Federation; 2,Group by NOC; 3,Group by Club; 4,Group by Delegation
                 @GroupID             NVARCHAR(9),
                 @RegisterID         INT,
                 @NodeType           INT ----0,只找根节点下的运动员;1,找属于某个队的运动员
                 --@LanguageCode       NVARCHAR(3)

AS
BEGIN
   SET NOCOUNT ON
            CREATE TABLE #table_competitor(
                                             F_GroupID          NVARCHAR(4),
                                             F_RegisterID       INT,
                                             F_CompetitorID     INT,
                                             F_CompetitorCode   NVARCHAR(20),
											 F_Bib				NVARCHAR(20),
                                             F_LongName         NVARCHAR(100),
                                             F_ShortName        NVARCHAR(100),
                                             F_SexCode          INT,
                                             F_SexLongName      NVARCHAR(50),
                                             F_Height           DECIMAL(9,2),
                                             F_Weight           DECIMAL(9,2),
                                             F_BirthDate        DATETIME,
                                             F_RegTypeID        INT,
                                             F_RegTypeName      NVARCHAR(50),
                                            )
 
  DECLARE @DisciplineID  int
    SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_Active = 1

    DECLARE @LanguageCode NVARCHAR(3)
    SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1
    IF @LanguageCode IS NULL
    BEGIN 
        SET @LanguageCode = 'CHN'
    END

  
   IF @NodeType = 0
   BEGIN
       IF (@GroupType = 1)
       BEGIN
           IF(@GroupID IS NULL)
           BEGIN
		        INSERT INTO #table_competitor(F_GroupID,F_RegisterID,F_CompetitorID,F_CompetitorCode,F_Bib,F_LongName,F_ShortName,F_SexCode,F_SexLongName,F_Height,F_Weight,F_BirthDate,F_RegTypeID)
				  SELECT @GroupID, NULL,A.F_RegisterID,A.F_RegisterCode,A.F_Bib,NULL,NULL,A.F_SexCode,NULL,A.F_Height,A.F_Weight,A.F_Birth_Date,A.F_RegTypeID
					 FROM  TR_Register AS A 
					   WHERE A.F_FederationID IS NULL AND A.F_RegTypeID = 1  AND A.F_DisciplineID = @DisciplineID
           END
           ELSE
           BEGIN
		        INSERT INTO #table_competitor(F_GroupID,F_RegisterID,F_CompetitorID,F_CompetitorCode,F_Bib,F_LongName,F_ShortName,F_SexCode,F_SexLongName,F_Height,F_Weight,F_BirthDate,F_RegTypeID)
				  SELECT @GroupID, NULL,A.F_RegisterID,A.F_RegisterCode,A.F_Bib,NULL,NULL,A.F_SexCode,NULL,A.F_Height,A.F_Weight,A.F_Birth_Date,A.F_RegTypeID
					 FROM  TR_Register AS A 
					   WHERE CAST(A.F_FederationID AS NVARCHAR(9)) = @GroupID AND A.F_RegTypeID = 1  AND A.F_DisciplineID = @DisciplineID
           END
       END
       ELSE IF (@GroupType = 2)
       BEGIN
           IF(@GroupID IS NULL)
           BEGIN
              INSERT INTO #table_competitor(F_GroupID,F_RegisterID,F_CompetitorID,F_CompetitorCode,F_Bib,F_LongName,F_ShortName,F_SexCode,F_SexLongName,F_Height,F_Weight,F_BirthDate,F_RegTypeID)
			      SELECT @GroupID,NULL,A.F_RegisterID,A.F_RegisterCode,A.F_Bib,NULL,NULL,A.F_SexCode,NULL,A.F_Height,A.F_Weight,A.F_Birth_Date,A.F_RegTypeID
				    FROM  TR_Register AS A 
				       WHERE A.F_NOC IS NULL AND A.F_RegTypeID = 1  AND A.F_DisciplineID = @DisciplineID
           END
           ELSE
           BEGIN
              INSERT INTO #table_competitor(F_GroupID,F_RegisterID,F_CompetitorID,F_CompetitorCode,F_Bib,F_LongName,F_ShortName,F_SexCode,F_SexLongName,F_Height,F_Weight,F_BirthDate,F_RegTypeID)
			      SELECT @GroupID,NULL,A.F_RegisterID,A.F_RegisterCode,A.F_Bib,NULL,NULL,A.F_SexCode,NULL,A.F_Height,A.F_Weight,A.F_Birth_Date,A.F_RegTypeID
				    FROM  TR_Register AS A 
				       WHERE A.F_NOC = @GroupID AND A.F_RegTypeID = 1  AND A.F_DisciplineID = @DisciplineID
           END

       END
       ELSE IF (@GroupType = 3)
       BEGIN
          IF(@GroupID IS NULL)
          BEGIN
             INSERT INTO #table_competitor(F_GroupID,F_RegisterID,F_CompetitorID,F_CompetitorCode,F_Bib,F_LongName,F_ShortName,F_SexCode,F_SexLongName,F_Height,F_Weight,F_BirthDate,F_RegTypeID)
			    SELECT @GroupID,NULL,A.F_RegisterID,A.F_RegisterCode,A.F_Bib,NULL,NULL,A.F_SexCode,NULL,A.F_Height,A.F_Weight,A.F_Birth_Date,A.F_RegTypeID
				   FROM  TR_Register AS A 
				      WHERE A.F_ClubID IS NULL AND A.F_RegTypeID = 1  AND A.F_DisciplineID = @DisciplineID
          END
          ELSE
          BEGIN
             INSERT INTO #table_competitor(F_GroupID,F_RegisterID,F_CompetitorID,F_CompetitorCode,F_Bib,F_LongName,F_ShortName,F_SexCode,F_SexLongName,F_Height,F_Weight,F_BirthDate,F_RegTypeID)
			    SELECT @GroupID,NULL,A.F_RegisterID,A.F_RegisterCode,A.F_Bib,NULL,NULL,A.F_SexCode,NULL,A.F_Height,A.F_Weight,A.F_Birth_Date,A.F_RegTypeID
				   FROM  TR_Register AS A 
				      WHERE CAST(A.F_ClubID AS NVARCHAR(9))= @GroupID AND A.F_RegTypeID = 1  AND A.F_DisciplineID = @DisciplineID
          END 
       END
       ELSE IF (@GroupType = 4)
       BEGIN
          IF(@GroupID IS NULL)
          BEGIN
             INSERT INTO #table_competitor(F_GroupID,F_RegisterID,F_CompetitorID,F_CompetitorCode,F_Bib,F_LongName,F_ShortName,F_SexCode,F_SexLongName,F_Height,F_Weight,F_BirthDate,F_RegTypeID)
			  SELECT @GroupID,NULL,A.F_RegisterID,A.F_RegisterCode,A.F_Bib,NULL,NULL,A.F_SexCode,NULL,A.F_Height,A.F_Weight,A.F_Birth_Date,A.F_RegTypeID
				 FROM  TR_Register AS A 
				   WHERE A.F_DelegationID IS NULL AND A.F_RegTypeID = 1  AND A.F_DisciplineID = @DisciplineID
          END
          ELSE
          BEGIN
             INSERT INTO #table_competitor(F_GroupID,F_RegisterID,F_CompetitorID,F_CompetitorCode,F_Bib,F_LongName,F_ShortName,F_SexCode,F_SexLongName,F_Height,F_Weight,F_BirthDate,F_RegTypeID)
			  SELECT @GroupID,NULL,A.F_RegisterID,A.F_RegisterCode,A.F_Bib,NULL,NULL,A.F_SexCode,NULL,A.F_Height,A.F_Weight,A.F_Birth_Date,A.F_RegTypeID
				 FROM  TR_Register AS A 
				   WHERE CAST(A.F_DelegationID AS NVARCHAR(9))= @GroupID AND A.F_RegTypeID = 1  AND A.F_DisciplineID = @DisciplineID
          END
       END
   END
   ELSE
   BEGIN
      IF @NodeType <> 0
      BEGIN
         INSERT INTO #table_competitor(F_GroupID,F_RegisterID,F_CompetitorID,F_CompetitorCode,F_Bib,F_LongName,F_ShortName,F_SexCode,F_SexLongName,F_Height,F_Weight,F_BirthDate,F_RegTypeID)
              SELECT NULL,@RegisterID ,A.F_MemberRegisterID,B.F_RegisterCode,B.F_Bib,NULL,NULL,B.F_SexCode,NULL,B.F_Height,B.F_Weight,B.F_Birth_Date,B.F_RegTypeID
                 FROM  TR_Register AS B LEFT JOIN TR_Register_Member AS A ON A.F_MemberRegisterID = B.F_RegisterID 
                   WHERE A.F_RegisterID = @RegisterID AND B.F_DisciplineID = @DisciplineID AND B.F_RegTypeID = 1
        
      END
   END
    
   UPDATE #table_competitor SET F_LongName = B.F_LongName,F_ShortName = B.F_ShortName FROM #table_competitor AS A LEFT JOIN TR_Register_Des AS B ON A.F_CompetitorID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
   UPDATE #table_competitor SET F_SexLongName = B.F_SexLongName FROM #table_competitor AS A LEFT JOIN TC_Sex_Des AS B ON A.F_SexCode = B.F_SexCode AND B.F_LanguageCode = @LanguageCode
   UPDATE #table_competitor SET F_RegTypeName = B.F_RegTypeLongDescription FROM #table_competitor AS A LEFT JOIN TC_RegType_Des AS B ON A.F_RegTypeID = B.F_RegTypeID AND B.F_LanguageCode = @LanguageCode

   SELECT F_CompetitorCode AS RegisterCode,F_Bib AS BIB,F_LongName AS MemberLongName,F_ShortName AS MemberShortName,F_SexLongName AS Sex,F_Height AS Height,F_Weight AS Weight,CONVERT(CHAR(10),F_BirthDate,23) AS BirthDate,F_CompetitorID AS MemberID, F_RegTypeName AS RegTypeName, F_RegTypeID AS RegTypeID FROM #table_competitor
   
Set NOCOUNT OFF
End
	
set QUOTED_IDENTIFIER OFF


GO


