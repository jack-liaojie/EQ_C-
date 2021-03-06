/****** Object:  StoredProcedure [dbo].[Proc_Register_GetEventInscription]    Script Date: 11/19/2009 11:31:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Register_GetEventInscription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Register_GetEventInscription]
GO
/****** Object:  StoredProcedure [dbo].[Proc_Register_GetEventInscription]    Script Date: 11/19/2009 11:31:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Register_GetEventInscription]
--描    述: 获取指定代表团报了指定小项的运动员信息
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
            2010年03月15日      李燕        添加InscriptionRank的显示	
            2010年07月11日      李燕        添加InscriptionReserve的显示					
*/



CREATE PROCEDURE [dbo].[Proc_Register_GetEventInscription]
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

	DECLARE @RegTypeID AS INT
	DECLARE @SexCode AS INT

	DECLARE @EventLongName AS NVARCHAR(100)

	SELECT @RegTypeID = F_PlayerRegTypeID, @SexCode = F_SexCode 
	FROM TS_Event 
	WHERE F_EventID = @EventID

    DECLARE @SQL AS NVARCHAR(MAX)
    DECLARE @SQL1 AS NVARCHAR(MAX)

    SET @SQL = 'SELECT '
                + CAST (@RegTypeID AS NVARCHAR(10)) 
                + ' AS [RegTypeID] 
				, c.F_Bib AS [Bib]
				, b.F_LongName AS RegisterName
				, d.F_SexLongName AS [Sex]
				, a.F_Seed AS Seed
				, a.F_InscriptionResult AS InscriptionResult
				, a.F_InscriptionNum AS InscriptionNum
                , a.F_InscriptionRank AS InscriptionRank
                , CASE WHEN a.F_Reserve = 1 THEN ''' +  'Yes' + ''' ELSE  CASE WHEN a.F_Reserve = 0 THEN ''' + 'No' + ''' ELSE '''' END END AS Reserve
				, a.F_RegisterID AS RegisterID
			    FROM TR_Inscription AS a
			    LEFT JOIN TR_Register_Des AS b ON a.F_RegisterID = b.F_RegisterID AND b.F_LanguageCode = '''
            +  @LanguageCode + ''''
			+ ' LEFT JOIN TR_Register AS c ON a.F_RegisterID = c.F_RegisterID LEFT JOIN TC_Sex_Des AS  d
				ON c.F_SexCode = d.F_SexCode AND d.F_LanguageCode = '''
            + @LanguageCode + ''''
			+ ' WHERE a.F_EventID = '
            + CAST (@EventID AS NVARCHAR(10))

    
    IF(@GroupType = 1)
    BEGIN
        SET @SQL1 = ' AND CAST(c.F_FederationID AS NVARCHAR(9)) =''' + @GroupID + ''''
    END
    ELSE IF(@GroupType = 2)
    BEGIN
      SET @SQL1 = ' AND c.F_NOC =''' + @GroupID + ''''
    END
    ELSE IF(@GroupType = 3)
    BEGIN
       SET @SQL1 = ' AND CAST(c.F_ClubID AS NVARCHAR(9)) =''' + @GroupID + ''''
    END
     ELSE IF(@GroupType = 4)
    BEGIN
       SET @SQL1 = ' AND CAST(c.F_DelegationID AS NVARCHAR(9)) =''' + @GroupID + ''''
    END
		
    SET @SQL = @SQL + @SQL1

print @SQL
    execute (@SQL)

SET NOCOUNT OFF
END

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO



