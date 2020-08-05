IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetFederationList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetFederationList]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称：[Proc_GetFederationList]
--描    述：得到代表团列表
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年05月30日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

CREATE PROCEDURE [dbo].[Proc_GetFederationList](
												@DisciplineID		INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	
	CREATE TABLE #Tmp_Table(
								F_Name			NVARCHAR(100),
								F_Key			INT
							)

	DECLARE @AllDes AS NVARCHAR(100)
	SET @AllDes = ' 全部'

	IF @LanguageCode = 'CHN'
	BEGIN
		SET @AllDes = ' 全部'
	END
	ELSE
	BEGIN
		IF @LanguageCode = 'ENG'
		BEGIN
			SET @AllDes = ' ALL'
		END
	END

	INSERT INTO #Tmp_Table (F_Name, F_Key) VALUES (@AllDes, -1)
	INSERT INTO #Tmp_Table (F_Name, F_Key) 
		SELECT B.F_FederationLongName, A.F_FederationID 
		FROM TC_Federation AS A 
		LEFT JOIN TC_Federation_Des AS B ON A.F_FederationID = B.F_FederationID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TS_ActiveFederation AS C ON A.F_FederationID = C.F_FederationID
		WHERE C.F_DisciplineID = @DisciplineID

	SELECT F_Name, F_Key FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

--exec [Proc_GetFederationList] 5, 'CHN'
--exec [Proc_GetFederationList] 5, 'ENG'
