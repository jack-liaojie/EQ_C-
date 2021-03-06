/****** Object:  StoredProcedure [dbo].[Proc_SearchRegisters]    Script Date: 11/19/2009 13:17:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SearchRegisters]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SearchRegisters]
GO
/****** Object:  StoredProcedure [dbo].[Proc_SearchRegisters]    Script Date: 11/19/2009 13:17:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_SearchRegisters]
--描    述：根据查询条件查询符合的运动员列表
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年05月30日
--修改记录：
/*			
			时间			修改人		修改内容
			2009年09月08日		邓年彩		增加 Bib 号的显示
                        2009年11月11日		李燕		根据不同Group(Federation/Club/NOC)，搜索运动员
                        2011年01月26日      李燕        增加F_IsRecord的显示
*/

CREATE PROCEDURE [dbo].[Proc_SearchRegisters](
				 @DisciplineID		INT,
				 @SexCode			INT,
				 @RegTypeID			INT,
				 @EventID			INT,
				 @LanguageCode		CHAR(3),
				 @GroupID		    NVARCHAR(9),
                 @GroupType         INT
)
As
Begin
SET NOCOUNT ON 
	  IF(@GroupType = 1)
      BEGIN
          DECLARE @FederationID  INT
          SET @FederationID = CAST(@GroupID AS INT)
          EXEC Proc_SearchRegisters_WithFederation  @DisciplineID, @SexCode, @RegTypeID, @EventID, @FederationID,@LanguageCode
      END
      ELSE IF(@GroupType = 2)
      BEGIN
          EXEC Proc_SearchRegisters_WithNOC  @DisciplineID, @SexCode, @RegTypeID, @EventID, @GroupID, @LanguageCode
      END
      ELSE IF(@GroupType = 3)
      BEGIN
          DECLARE @ClubID  INT
          SET @ClubID = CAST(@GroupID AS INT)
          EXEC Proc_SearchRegisters_WithClub  @DisciplineID, @SexCode, @RegTypeID, @EventID, @ClubID,@LanguageCode
      END
      ELSE IF(@GroupType = 4)
      BEGIN
          DECLARE @DelegationID  INT
          SET @DelegationID = CAST(@GroupID AS INT)
          EXEC Proc_SearchRegisters_WithDelegation  @DisciplineID, @SexCode, @RegTypeID, @EventID, @DelegationID,@LanguageCode
      END
   

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

