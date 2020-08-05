IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_GetInscriptionForLotNo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_GetInscriptionForLotNo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_WL_GetInscriptionForLotNo]
--描    述：根据查询条件查询符合的运动员列表，用于抽签
--参数说明： 
--说    明：
--创 建 人：崔凯
--日    期：2009年05月30日
--修改记录：
/*			
			时间				修改人		修改内容
*/

CREATE PROCEDURE [dbo].[Proc_WL_GetInscriptionForLotNo](
				 @DisciplineID		INT,
				 @SexCode			INT,
				 @RegTypeID			INT,
				 @EventID			INT,
				 @GroupID			INT,
				 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 
	SET @LanguageCode = 'ENG'
	SET @RegTypeID = 1
	CREATE TABLE #Temp_Table(
								F_RegisterID		INT,
								F_RegTypeID			INT,
								F_SexCode			INT,
								F_DelegationID		INT,
								F_Bib				NVARCHAR(20),
								F_InscriptionResult				NVARCHAR(20),
								F_EventID			INT,
								F_Seed				INT
				)
	INSERT INTO #Temp_Table (F_RegisterID, F_RegTypeID, F_SexCode, F_DelegationID, F_Bib,F_InscriptionResult,F_EventID,F_Seed)
			SELECT I.F_RegisterID, R.F_RegTypeID, R.F_SexCode, R.F_DelegationID, 
					I.F_InscriptionNum,I.F_InscriptionResult,I.F_EventID,I.F_Seed
			FROM TR_Inscription AS I
			INNER JOIN TR_Register AS R ON R.F_RegisterID = I.F_RegisterID
			 WHERE F_DisciplineID = @DisciplineID

	IF (@SexCode != -1)
	BEGIN
		DELETE FROM #Temp_Table WHERE (F_SexCode != @SexCode OR F_SexCode IS NULL)
	END

	IF (@RegTypeID != -1)
	BEGIN
		DELETE FROM #Temp_Table WHERE (F_RegTypeID != @RegTypeID OR F_RegTypeID IS NULL)
	END

    DECLARE @DelegationID  INT
    SET @DelegationID = CAST(@GroupID AS INT)
	IF (@DelegationID != -1)
	BEGIN
		DELETE FROM #Temp_Table WHERE (F_DelegationID != @DelegationID OR F_DelegationID IS NULL)
	END

	IF (@EventID != -1)
	BEGIN
		DELETE FROM #Temp_Table WHERE F_EventID <> @EventID
			--F_RegisterID NOT IN (SELECT F_RegisterID FROM TR_Inscription WHERE F_EventID = @EventID)
	END
	ELSE 
	BEGIN
		DELETE FROM #Temp_Table WHERE F_RegisterID NOT IN (SELECT F_RegisterID FROM TR_Inscription)
	END
	
	SELECT 
		 ED.F_EventLongName AS [Event Name]
		,B.F_RegisterCode AS [Register Code]
		, C.F_LongName AS [Long Name]
		, A.F_Bib AS [Bib]
		, A.F_Seed AS [LotNo]
        , A.F_InscriptionResult AS [InscriptionResult]
		, E.F_SexLongName AS [Sex]
		, B.F_Weight AS [Weight]
		, B.F_Height AS [Height]
		, B.F_Birth_Date AS [Birth Date]
		, D.F_DelegationLongName AS [Delegation]
		, F.F_RegTypeLongDescription AS [RegType]
		, B.F_IsRecord AS [IsRecord]
        , A.F_RegisterID AS [RegisterID]
        , A.F_EventID AS [EventID]
        , A.F_DelegationID AS [GroupID]
	FROM #Temp_Table AS A 
	LEFT JOIN TR_Register AS B 
		ON A.F_RegisterID = B.F_RegisterID 
	INNER JOIN TS_Event_Des AS ED ON ED.F_EventID = A.F_EventID AND ED.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register_Des AS C 
		ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation_Des AS D 
		ON A.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Sex_Des AS E 
		ON A.F_SexCode = E.F_SexCode AND E.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_RegType_Des AS F 
		ON A.F_RegTypeID = F.F_RegTypeID AND F.F_LanguageCode = @LanguageCode


     
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


/*

exec Proc_WL_GetInscriptionForLotNo 1,-1,-1,1,-1,'ENG'

*/