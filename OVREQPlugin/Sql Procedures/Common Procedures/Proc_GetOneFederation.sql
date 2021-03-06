IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetOneFederation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetOneFederation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GetOneFederation]
--描    述：得到某个代表团
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2009年11月5日

CREATE PROCEDURE [dbo].[Proc_GetOneFederation](
				 @FederationID			INT,
				 @LanguageCode			CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #Tmp_Federation(
								F_FederationID					INT,
								F_FederationCode				NVARCHAR(10),
								F_LanguageCode					CHAR(3),
								F_FederationLongName			NVARCHAR(100),
								F_FederationShortName			NVARCHAR(50),
								F_FederationComment				NVARCHAR(50),
							)

	INSERT INTO #Tmp_Federation (F_FederationID, F_FederationCode, F_LanguageCode, F_FederationLongName, F_FederationShortName, F_FederationComment)
		SELECT A.F_FederationID, A.F_FederationCode, B.F_LanguageCode, B.F_FederationLongName, B.F_FederationShortName, B.F_FederationComment 
			FROM TC_Federation AS A LEFT JOIN TC_Federation_Des AS B ON A.F_FederationID = B.F_FederationID AND B.F_LanguageCode = @LanguageCode
             WHERE A.F_FederationID = @FederationID
		

	SELECT F_FederationLongName, F_FederationCode, F_FederationShortName, F_FederationComment, F_FederationID, F_LanguageCode 
		FROM #Tmp_Federation

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

