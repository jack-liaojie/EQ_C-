IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetAvailbleMember_Asia]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_GetAvailbleMember_Asia]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












----存储过程名称：proc_GetAvailbleMember_Asia
----功		  能：得到可选择的队员
----作		  者：李燕
----日		  期: 2009-04-19

CREATE PROCEDURE [dbo].[proc_GetAvailbleMember_Asia] 
	@DisciplineID			INT,
    @FederationID           INT,
	@RegisterID			    INT,
    @SexCode                INT,
    @LanguageCode           NVARCHAR(3)            
AS
BEGIN
	
SET NOCOUNT ON

    CREATE TABLE #table_avaibleMember(
                                     F_MemberID      INT,
                                     F_RegisterCode  NVARCHAR(20),   
                                     F_MemberName    NVARCHAR(100),
                                     F_RegTypeID     INT,
                                     F_RegTypeName   NVARCHAR(50)
                                     )

   DECLARE @FatherRegID   INT
   IF(@SexCode = -1)
   BEGIN
		--IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register_Member WHERE F_MemberRegisterID = @RegisterID)
	--	BEGIN
			INSERT INTO #table_avaibleMember(F_MemberID,F_RegisterCode,F_MemberName,F_RegTypeID,F_RegTypeName)
				   SELECT A.F_RegisterID,A.F_RegisterCode,B.F_LongName,A.F_RegTypeID,NULL
				   FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
				   WHERE A.F_RegisterID NOT IN (SELECT F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegisterID) AND A.F_DisciplineID = @DisciplineID AND A.F_RegTypeID IN(1,4,5,6) AND A.F_FederationID = @FederationID
		--END
		/*ELSE
		--BEGIN
        --   SELECT @FatherRegID = F_RegisterID FROM TR_Register_Member WHERE F_MemberRegisterID = @RegisterID 
           INSERT INTO #table_avaibleMember(F_MemberID,F_RegisterCode,F_MemberName,F_RegTypeID,F_RegTypeName)
				   SELECT A.F_RegisterID,A.F_RegisterCode,B.F_LongName,A.F_RegTypeID,NULL
				   FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
				   WHERE A.F_RegisterID  IN (SELECT F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @FatherRegID) AND A.F_RegisterID  NOT IN (SELECT F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegisterID)
                        AND A.F_RegTypeID IN (1,4,5,6)AND A.F_SportID = @SportID
		END*/
   END
   ELSE
   BEGIN
        --IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register_Member WHERE F_MemberRegisterID = @RegisterID)
		--  BEGIN
			   INSERT INTO #table_avaibleMember(F_MemberID,F_RegisterCode,F_MemberName,F_RegTypeID,F_RegTypeName)
				     SELECT A.F_RegisterID,A.F_RegisterCode,B.F_LongName,A.F_RegTypeID,NULL
				         FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
				            WHERE A.F_RegisterID NOT IN (SELECT F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegisterID) AND A.F_DisciplineID = @DisciplineID AND A.F_RegTypeID IN(1,4,5,6) AND A.F_SexCode = @SexCode AND A.F_FederationID = @FederationID
		 --  END
		  /*ELSE
		   BEGIN
               SELECT @FatherRegID = F_RegisterID FROM TR_Register_Member WHERE F_MemberRegisterID = @RegisterID 
               INSERT INTO #table_avaibleMember(F_MemberID,F_RegisterCode,F_MemberName,F_RegTypeID,F_RegTypeName)
				     SELECT A.F_RegisterID,A.F_RegisterCode,B.F_LongName,A.F_RegTypeID,NULL
				       FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
				         WHERE A.F_RegisterID  IN (SELECT F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @FatherRegID) AND A.F_RegisterID  NOT IN (SELECT F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegisterID)
                               AND A.F_RegTypeID IN (1,4,5,6)AND A.F_SportID = @SportID AND A.F_SexCode = @SexCode
		    END*/
   END
    UPDATE #table_avaibleMember SET F_RegTypeName = B.F_RegTypeLongDescription FROM #table_avaibleMember AS A LEFT JOIN TC_RegType_Des AS B ON A.F_RegTypeID = B.F_RegTypeID AND B.F_LanguageCode = @LanguageCode
    SELECT F_MemberName AS MemberName,F_RegisterCode AS RegisterCode,F_RegTypeName AS RegType, F_MemberID AS MemberID FROM #table_avaibleMember

SET NOCOUNT OFF
END

set QUOTED_IDENTIFIER OFF
SET ANSI_NULLS OFF
GO

