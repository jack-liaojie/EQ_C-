/****** Object:  StoredProcedure [dbo].[Proc_InscriptionAllRegister]    Script Date: 11/19/2009 11:32:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_InscriptionAllRegister]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_InscriptionAllRegister]
GO
/****** Object:  StoredProcedure [dbo].[Proc_InscriptionAllRegister]    Script Date: 11/19/2009 11:32:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_InscriptionAllRegister]
--描    述: 所有该Event下的报名运动员都报项
--参数说明: 
--说    明: 
--创 建 人: 李燕
--日    期: 2009年8月31日
--修改记录：2009年11月16日
-- -        2011年01月04日	    李燕        对于性别类型为“0”不做过滤




CREATE PROCEDURE [dbo].[Proc_InscriptionAllRegister]
	@EventID				INT,
    @GroupType              INT,
	@LanguageCode			CHAR(3),
    @Result 			AS INT OUTPUT

AS
BEGIN
SET NOCOUNT ON
   
    IF(@GroupType = 1)
    BEGIN 
        exec Proc_InscriptionAllRegister_GroupByFederation @EventID, @LanguageCode, @Result output
    END
    ELSE IF(@GroupType = 2)
    BEGIN
        exec Proc_InscriptionAllRegister_GroupByNOC @EventID, @LanguageCode, @Result output
    END
    ELSE IF(@GroupType = 3)
    BEGIN
        exec Proc_InscriptionAllRegister_GroupByClub @EventID, @LanguageCode, @Result output
    END
    ELSE IF(@GroupType = 4)
    BEGIN
        exec Proc_InscriptionAllRegister_GroupByDelegation @EventID, @LanguageCode, @Result output
    END

SET NOCOUNT OFF
END

