IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Register_GetClubAllRegister]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Register_GetClubAllRegister]
GO
/****** Object:  StoredProcedure [dbo].[Proc_Register_GetClubAllRegister]    Script Date: 11/11/2009 15:19:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_Register_GetClubAllRegister]
--��    ��: ��ȡָ��NOC�ı�����Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��25��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
			2009��09��08��		�����		��� Bib �ŵ���ʾ	
            2009��09��18��      ����        ����Ա����ʾ	
            2009��09��18��      ����        ������һ�������������Ƿ�Ϊ�˶�Ա�Լ�����ע������������	
*/



CREATE PROCEDURE [dbo].[Proc_Register_GetClubAllRegister]
	@ClubID        			INT,
	@DisciplineID			INT,
    @AthleteID              INT,     --------0:������Ա��1:�˶�Ա�� 2:���˶�Ա
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
