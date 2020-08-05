IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Register_GetClubAllRegister]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Register_GetClubAllRegister]
GO
/****** Object:  StoredProcedure [dbo].[Proc_Register_GetClubAllRegister]    Script Date: 11/11/2009 15:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Register_GetClubAllRegister]
--描    述: 获取指定NOC的报名信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月25日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
			2009年09月08日		邓年彩		添加 Bib 号的显示	
            2009年09月18日      李燕        添加性别的显示	
            2009年09月18日      李燕        多增加一个参数，根据是否为运动员以及具体注册类型来查找	
*/



CREATE PROCEDURE [dbo].[Proc_Register_GetClubAllRegister]
	@ClubID        			INT,
	@DisciplineID			INT,
    @AthleteID              INT,     --------0:所有人员，1:运动员， 2:非运动员
	@RegTypeID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
 
		IF @RegTypeID is NULL
		BEGIN
            IF(@AthleteID = 0)
            BEGIN 
					SELECT a.F_RegTypeID AS [RegTypeID]
						, c.F_RegTypeLongDescription AS [RegType]
						, a.F_Bib AS [Bib]
						, b.F_LongName AS [RegLongName]
						, b.F_ShortName AS [RegShortName]
						, d.F_SexLongName As [Sex]
						, a.F_RegisterID AS [RegisterID]
						, a.F_SexCode AS [SexCode]
					FROM TR_Register a
					LEFT JOIN TR_Register_Des b
						ON a.F_RegisterID = b.F_RegisterID AND b.F_LanguageCode = @LanguageCode
					LEFT JOIN TC_RegType_Des c
						ON a.F_RegTypeID = c.F_RegTypeID AND c.F_LanguageCode = @LanguageCode
					LEFT JOIN TC_Sex_Des  d
						ON a.F_SexCode = d.F_SexCode AND d.F_LanguageCode = @LanguageCode
					WHERE a.F_ClubID = @ClubID
						AND a.F_DisciplineID = @DisciplineID
					ORDER BY a.F_RegTypeID
             END
             ELSE IF(@AthleteID = 1)
             BEGIN
                    SELECT a.F_RegTypeID AS [RegTypeID]
						, c.F_RegTypeLongDescription AS [RegType]
						, a.F_Bib AS [Bib]
						, b.F_LongName AS [RegLongName]
						, b.F_ShortName AS [RegShortName]
						, d.F_SexLongName As [Sex]
						, a.F_RegisterID AS [RegisterID]
						, a.F_SexCode AS [SexCode]
					FROM TR_Register a
					LEFT JOIN TR_Register_Des b
						ON a.F_RegisterID = b.F_RegisterID AND b.F_LanguageCode = @LanguageCode
					LEFT JOIN TC_RegType_Des c
						ON a.F_RegTypeID = c.F_RegTypeID AND c.F_LanguageCode = @LanguageCode
					LEFT JOIN TC_Sex_Des  d
						ON a.F_SexCode = d.F_SexCode AND d.F_LanguageCode = @LanguageCode
					WHERE a.F_ClubID = @ClubID
						AND a.F_DisciplineID = @DisciplineID
                        AND a.F_RegTypeID IN (1,2,3)
					ORDER BY a.F_RegTypeID
             END
             ELSE IF(@AthleteID = 2)
             BEGIN
                   SELECT a.F_RegTypeID AS [RegTypeID]
						, c.F_RegTypeLongDescription AS [RegType]
						, a.F_Bib AS [Bib]
						, b.F_LongName AS [RegLongName]
						, b.F_ShortName AS [RegShortName]
						, d.F_SexLongName As [Sex]
						, a.F_RegisterID AS [RegisterID]
						, a.F_SexCode AS [SexCode]
					FROM TR_Register a
					LEFT JOIN TR_Register_Des b
						ON a.F_RegisterID = b.F_RegisterID AND b.F_LanguageCode = @LanguageCode
					LEFT JOIN TC_RegType_Des c
						ON a.F_RegTypeID = c.F_RegTypeID AND c.F_LanguageCode = @LanguageCode
					LEFT JOIN TC_Sex_Des  d
						ON a.F_SexCode = d.F_SexCode AND d.F_LanguageCode = @LanguageCode
					WHERE a.F_ClubID = @ClubID
						AND a.F_DisciplineID = @DisciplineID
                        AND a.F_RegTypeID NOT IN (1,2,3)
					ORDER BY a.F_RegTypeID
             END
		END
		ELSE
		BEGIN
			SELECT a.F_RegTypeID AS [RegTypeID]
				, a.F_Bib AS [Bib]
				, c.F_RegTypeLongDescription AS [RegType]
				, b.F_LongName AS [RegLongName]
				, b.F_ShortName AS [RegShortName]
				, d.F_SexLongName As [Sex]
				, a.F_RegisterID AS [RegisterID]
				, a.F_SexCode AS [SexCode]
			FROM TR_Register a
			LEFT JOIN TR_Register_Des b
				ON a.F_RegisterID = b.F_RegisterID AND b.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_RegType_Des c
				ON a.F_RegTypeID = c.F_RegTypeID AND c.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Sex_Des  d
				ON a.F_SexCode = d.F_SexCode AND d.F_LanguageCode = @LanguageCode
			WHERE a.F_ClubID = @ClubID
				AND a.F_DisciplineID = @DisciplineID
				AND a.F_RegTypeID = @RegTypeID	
		END
      

SET NOCOUNT OFF
END
