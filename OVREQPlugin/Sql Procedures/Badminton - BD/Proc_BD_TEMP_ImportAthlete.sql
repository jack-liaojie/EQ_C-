IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_TEMP_ImportAthlete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_TEMP_ImportAthlete]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_BD_TEMP_ImportAthlete]
--描    述: 测试赛添加运动员
--创 建 人: 王强
--日    期: 2011-07-04



CREATE PROCEDURE [dbo].[Proc_BD_TEMP_ImportAthlete]
		@DelegationCode NVARCHAR(10),
		@RegCode NVARCHAR(10),
		@FirstName NVARCHAR(50),
		@LastName NVARCHAR(50),
		@SexCode INT
AS
BEGIN
SET NOCOUNT ON
	DECLARE @RegisterID INT
	DECLARE @DlgID INT
	SELECT @DlgID = F_DelegationID FROM TC_Delegation WHERE F_DelegationCode = @DelegationCode
	IF @DlgID IS NULL
		RETURN

	INSERT INTO TR_Register
			( 
			  F_RegTypeID,
			  F_RegisterCode ,
			  F_NOC ,
			  F_ClubID ,
			  F_FederationID ,
			  F_SexCode ,
			  F_Birth_Date ,
			  F_Height ,
			  F_Weight ,
			  F_NationID ,
			  F_DisciplineID ,
			  F_Bib ,
			  F_FunctionID ,
			  F_DelegationID ,
			  F_RegisterNum ,
			  F_IsRecord ,
			  F_Birth_City ,
			  F_Birth_Country ,
			  F_Residence_City ,
			  F_Residence_Country
			)
	VALUES  (
			  1, -- F_RegTypeID - int
			  @RegCode, -- F_RegisterCode - nvarchar(20)
			  'CHN', -- F_NOC - char(3)
			  NULL , -- F_ClubID - int
			  NULL , -- F_FederationID - int
			   @SexCode, -- F_SexCode - int
			  '1989-07-04 10:56:14' , -- F_Birth_Date - datetime
			  NULL , -- F_Height - decimal
			  NULL , -- F_Weight - decimal
			  NULL, -- F_NationID - int
			  1 , -- F_DisciplineID - int
			  '' , -- F_Bib - nvarchar(20)
			  NULL , -- F_FunctionID - int
			  @DlgID , -- F_DelegationID - int
			  '' , -- F_RegisterNum - nvarchar(20)
			  0 , -- F_IsRecord - int
			  NULL , -- F_Birth_City - nvarchar(50)
			  NULL , -- F_Birth_Country - char(3)
			  NULL , -- F_Residence_City - nvarchar(50)
			  NULL  -- F_Residence_Country - char(3)
			)
	
	SET @RegisterID =  @@IDENTITY
	INSERT INTO TR_Register_Des
			( F_RegisterID ,
			  F_LanguageCode ,
			  F_FirstName ,
			  F_LastName ,
			  F_LongName ,
			  F_ShortName ,
			  F_TvLongName ,
			  F_TvShortName ,
			  F_SBLongName ,
			  F_SBShortName ,
			  F_PrintLongName ,
			  F_PrintShortName ,
			  F_WNPA_FirstName ,
			  F_WNPA_LastName
			)
	VALUES  ( @RegisterID , -- F_RegisterID - int
			  'ENG' , -- F_LanguageCode - char(3)
			  @LastName , -- F_FirstName - nvarchar(50)
			  @FirstName , -- F_LastName - nvarchar(50)
			  @FirstName + @LastName, -- F_LongName - nvarchar(100)
			  @FirstName + @LastName, -- F_ShortName - nvarchar(50)
			  @FirstName + @LastName, -- F_TvLongName - nvarchar(100)
			  @FirstName + @LastName, -- F_TvShortName - nvarchar(50)
			  @FirstName + @LastName, -- F_SBLongName - nvarchar(100)
			  @FirstName + @LastName, -- F_SBShortName - nvarchar(50)
			  @FirstName + @LastName, -- F_PrintLongName - nvarchar(100)
			  @FirstName + @LastName, -- F_PrintShortName - nvarchar(50)
			  @FirstName + @LastName, -- F_WNPA_FirstName - nvarchar(50)
			  @FirstName + @LastName  -- F_WNPA_LastName - nvarchar(50)
			) 
			
	
	INSERT INTO TR_Register_Des
			( F_RegisterID ,
			  F_LanguageCode ,
			  F_FirstName ,
			  F_LastName ,
			  F_LongName ,
			  F_ShortName ,
			  F_TvLongName ,
			  F_TvShortName ,
			  F_SBLongName ,
			  F_SBShortName ,
			  F_PrintLongName ,
			  F_PrintShortName ,
			  F_WNPA_FirstName ,
			  F_WNPA_LastName
			)
	VALUES  ( @RegisterID , -- F_RegisterID - int
			  'CHN' , -- F_LanguageCode - char(3)
			  @LastName, -- F_FirstName - nvarchar(50)
			  @FirstName, -- F_LastName - nvarchar(50)
			  @FirstName + @LastName, -- F_LongName - nvarchar(100)
			  @FirstName + @LastName, -- F_ShortName - nvarchar(50)
			  @FirstName + @LastName, -- F_TvLongName - nvarchar(100)
			  @FirstName + @LastName, -- F_TvShortName - nvarchar(50)
			  @FirstName + @LastName, -- F_SBLongName - nvarchar(100)
			  @FirstName + @LastName, -- F_SBShortName - nvarchar(50)
			  @FirstName + @LastName, -- F_PrintLongName - nvarchar(100)
			  @FirstName + @LastName, -- F_PrintShortName - nvarchar(50)
			  @FirstName + @LastName, -- F_WNPA_FirstName - nvarchar(50)
			  @FirstName + @LastName  -- F_WNPA_LastName - nvarchar(50)
			)        
	

SET NOCOUNT OFF
END


GO

--exec Proc_BD_TS_GetMatches
