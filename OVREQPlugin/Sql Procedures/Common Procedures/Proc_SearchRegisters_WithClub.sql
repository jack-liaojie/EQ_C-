/****** Object:  StoredProcedure [dbo].[Proc_SearchRegisters_WithClub]    Script Date: 06/18/2010 15:38:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SearchRegisters_WithClub]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SearchRegisters_WithClub]
GO
/****** Object:  StoredProcedure [dbo].[Proc_SearchRegisters_WithClub]    Script Date: 06/18/2010 15:38:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_SearchRegisters_WithClub]
--描    述：根据查询条件查询符合的运动员列表
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年05月30日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月08日		邓年彩		增加 Bib 号的显示
*/

CREATE PROCEDURE [dbo].[Proc_SearchRegisters_WithClub](
				 @DisciplineID		INT,
				 @SexCode			INT,
				 @RegTypeID			INT,
				 @EventID			INT,
				 @ClubID		    INT,
				 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 
	CREATE TABLE #Temp_Table(
								F_RegisterID		INT,
								F_RegTypeID			INT,
								F_SexCode			INT,
								F_ClubID		    INT,
								F_Bib				NVARCHAR(20)
				)
	INSERT INTO #Temp_Table (F_RegisterID, F_RegTypeID, F_SexCode, F_ClubID, F_Bib)
			SELECT F_RegisterID, F_RegTypeID, F_SexCode, F_ClubID, F_Bib FROM TR_Register WHERE F_DisciplineID = @DisciplineID

	IF (@SexCode != -1)
	BEGIN
		DELETE FROM #Temp_Table WHERE (F_SexCode != @SexCode OR F_SexCode IS NULL)
	END

	IF (@RegTypeID != -1)
	BEGIN
		DELETE FROM #Temp_Table WHERE (F_RegTypeID != @RegTypeID OR F_RegTypeID IS NULL)
	END

	IF (@ClubID != -1)
	BEGIN
		DELETE FROM #Temp_Table WHERE (F_ClubID != @ClubID OR F_ClubID IS NULL)
	END

	IF (@EventID != -1)
	BEGIN
		DELETE FROM #Temp_Table WHERE F_RegisterID NOT IN (SELECT F_RegisterID FROM TR_Inscription WHERE F_EventID = @EventID)
	END
	
	SELECT B.F_RegisterCode AS [Register Code]
		, A.F_Bib AS [Bib]
		, C.F_LongName AS [Long Name]
		, D.F_ClubLongName AS [Club]
		, E.F_SexLongName AS [Sex]
		, F.F_RegTypeLongDescription AS [RegType]
		, B.F_Birth_Date AS [Birth Date]
		, B.F_Height AS [Height]
		, B.F_Weight AS [Weight]
		, B.F_IsRecord AS [IsRecord]
        , A.F_RegisterID AS [RegisterID]
        , A.F_ClubID AS [GroupID]
	FROM #Temp_Table AS A 
	LEFT JOIN TR_Register AS B 
		ON A.F_RegisterID = B.F_RegisterID 
	LEFT JOIN TR_Register_Des AS C 
		ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Club_Des AS D 
		ON A.F_ClubID = D.F_ClubID AND D.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Sex_Des AS E 
		ON A.F_SexCode = E.F_SexCode AND E.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_RegType_Des AS F 
		ON A.F_RegTypeID = F.F_RegTypeID AND F.F_LanguageCode = @LanguageCode

     
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF
