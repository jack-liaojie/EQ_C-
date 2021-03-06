/****** Object:  StoredProcedure [dbo].[Proc_Register_GetEventNoInscription]    Script Date: 11/19/2009 11:23:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Register_GetEventNoInscription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Register_GetEventNoInscription]
GO
/****** Object:  StoredProcedure [dbo].[Proc_Register_GetEventNoInscription]    Script Date: 11/19/2009 11:23:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Register_GetEventNoInscription]
--描    述: 获取指定代表团未报指定小项的运动员信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月25日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题
			2009年09月08日		邓年彩		添加 Bib 号的显示
            2009年09月18日      李燕        添加Sex 的显示			
            2011年01月04日	    李燕        对于性别类型为“0”不做过滤
*/



CREATE PROCEDURE [dbo].[Proc_Register_GetEventNoInscription]
	@GroupType   			INT,
    @GroupID                NVARCHAR(9),
	@EventID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @PlayerRegTypeID AS INT
	DECLARE @DoubleRegTypeID AS INT
	DECLARE @TeamRegTypeID AS INT
	SET @PlayerRegTypeID = 1
	SET @DoubleRegTypeID = 2
	SET @TeamRegTypeID = 3

	DECLARE @MixSexCode AS INT
	SET @MixSexCode = 3
	
	DECLARE @OpenSexCode AS INT
	SET @OpenSexCode = 4

	DECLARE @RegTypeID AS INT
	DECLARE @SexCode AS INT
	DECLARE @DisciplineID AS INT

	SELECT @RegTypeID = F_PlayerRegTypeID, @SexCode = F_SexCode, @DisciplineID = F_DisciplineID
	FROM TS_Event 
	WHERE F_EventID = @EventID

    DECLARE @SQL AS NVARCHAR(MAX)
    DECLARE @SQL1 AS NVARCHAR(MAX)
    DECLARE @SQL2 AS NVARCHAR(MAX)

    SET @SQL = 'SELECT '
                + CAST(@RegTypeID AS NVARCHAR(4))
                + 'AS [RegTypeID] 
				, b.F_RegTypeLongDescription AS [RegType]
				, a.F_RegisterCode AS [RegCode]
				, c.F_LongName AS [RegLongName], c.F_ShortName AS [RegShortName]
				, a.F_RegisterID AS [RegisterID]
				FROM TR_Register AS a LEFT JOIN TC_RegType_Des AS b  ON a.F_RegTypeID = b.F_RegTypeID AND b.F_LanguageCode = '''
             + @LanguageCode + ''''
             + 'LEFT JOIN TR_Register_Des AS c ON a.F_RegisterID = c.F_RegisterID AND c.F_LanguageCode = '''
             + @LanguageCode + ''''
    
    IF(@SexCode = @OpenSexCode)
    BEGIN
       SET @SQL2 = ' AND (
						a.F_SexCode is NULL 
						OR
						(a.F_RegTypeID =' 
					 + CAST (@PlayerRegTypeID AS NVARCHAR(50)) 
					 +')'
					 + 'OR ((a.F_RegTypeID = '
					 + CAST (@DoubleRegTypeID AS NVARCHAR(50))
					 + 'OR a.F_RegTypeID ='
					 + CAST (@TeamRegTypeID AS NVARCHAR(50)) 
					 + ')'
					 + ')) AND a.F_RegisterID NOT IN ( SELECT F_RegisterID FROM TR_Inscription e WHERE e.F_EventID ='
					 + CAST( @EventID AS NVARCHAR(50))
					 + ')'
    END
    ELSE
    BEGIN 
		SET @SQL2 = ' AND (
						a.F_SexCode is NULL 
						OR
						(a.F_RegTypeID =' 
					 + CAST (@PlayerRegTypeID AS NVARCHAR(50)) 
					 + 'AND (a.F_SexCode ='
					 + CAST( @MixSexCode AS NVARCHAR(50))
					 + 'OR a.F_SexCode = '
					 + CAST (@SexCode AS NVARCHAR(50))
					 +'))'
					 + 'OR ((a.F_RegTypeID = '
					 + CAST (@DoubleRegTypeID AS NVARCHAR(50))
					 + 'OR a.F_RegTypeID ='
					 + CAST (@TeamRegTypeID AS NVARCHAR(50)) 
					 + ')'
					 + 'AND a.F_SexCode ='
					 + CAST (@SexCode  AS NVARCHAR(50))
					 + ')) AND a.F_RegisterID NOT IN ( SELECT F_RegisterID FROM TR_Inscription e WHERE e.F_EventID ='
					 + CAST( @EventID AS NVARCHAR(50))
					 + ')'
	 END
    
    IF(@GroupType = 1)
    BEGIN
			
		  SET @SQL1 = 'WHERE CAST(a.F_FederationID AS NVARCHAR(9)) = '''
                    + @GroupID + ''''
                    + 'AND a.F_RegTypeID = '
                    + CAST(@RegTypeID AS NVARCHAR(50))
                    + 'AND a.F_DisciplineID = '
                    + CAST(@DisciplineID AS NVARCHAR(50))	
    END
    ELSE IF(@GroupType = 2)
    BEGIN
		 SET @SQL1 = 'WHERE CAST(a.F_NOC AS NVARCHAR(9)) = '''
                    + @GroupID + ''''
                    + 'AND a.F_RegTypeID = '
                    + CAST(@RegTypeID AS NVARCHAR(50))
                    + 'AND a.F_DisciplineID = '
                    + CAST(@DisciplineID AS NVARCHAR(50))	
    END
    ELSE IF(@GroupType = 3)
    BEGIN
         SET @SQL1 = 'WHERE CAST(a.F_ClubID AS NVARCHAR(9)) = '''
                    + @GroupID + ''''
                    + 'AND a.F_RegTypeID = '
                    + CAST(@RegTypeID AS NVARCHAR(50))
                    + 'AND a.F_DisciplineID = '
                    + CAST(@DisciplineID AS NVARCHAR(50))
     END
     ELSE IF(@GroupType = 4)
     BEGIN
         SET @SQL1 = 'WHERE CAST(a.F_DelegationID AS NVARCHAR(9)) = '''
                    + @GroupID + ''''
                    + 'AND a.F_RegTypeID = '
                    + CAST(@RegTypeID AS NVARCHAR(50))
                    + 'AND a.F_DisciplineID = '
                    + CAST(@DisciplineID AS NVARCHAR(50))
     END

     SET @SQL = @SQL + @SQL1 + @SQL2
    
     exec (@SQL)

SET NOCOUNT OFF
END
