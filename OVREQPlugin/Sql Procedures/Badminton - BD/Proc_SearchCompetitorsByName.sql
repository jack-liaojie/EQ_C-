IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SearchCompetitorsByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SearchCompetitorsByName]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_SearchCompetitorsByName]
----功		  能：根据名字模糊查询运动员
----作		  者：郑金勇 
----日		  期: 2012-02-16

CREATE PROCEDURE [dbo].[Proc_SearchCompetitorsByName] (	
	@FliterTypeID					INT,
	@Name							NVARCHAR(100)
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Name = N'%' + @Name + N'%'
	
	SELECT A.F_RegisterCode AS RegisterCode, B.F_LongName AS [Long Name], E.F_SexLongName AS Gender, C.F_DelegationCode AS [Delegation Code]
		, D.F_DelegationLongName AS [Delegation Name] , F.F_RegTypeLongDescription AS [Reg Type] 
		, A.F_RegisterID
		FROM TB_Register AS A LEFT JOIN TB_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = 'CHN'
		LEFT JOIN TB_Delegation AS C ON A.F_DelegationID = C.F_DelegationID
		LEFT JOIN TB_Delegation_Des AS D ON A.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = 'CHN'
		LEFT JOIN TC_Sex_Des AS E ON A.F_SexCode = E.F_SexCode AND E.F_LanguageCode = 'CHN'
		LEFT JOIN TC_RegType_Des AS F ON A.F_RegTypeID = F.F_RegTypeID AND F.F_LanguageCode = 'CHN'
		WHERE B.F_LongName LIKE @Name
		ORDER BY A.F_RegTypeID, A.F_SexCode, A.F_DelegationID

SET NOCOUNT OFF
END





GO


--EXEC Proc_SearchCompetitorsByName 1, '郑'