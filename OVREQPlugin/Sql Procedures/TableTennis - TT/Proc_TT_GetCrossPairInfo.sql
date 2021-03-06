IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TT_GetCrossPairInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TT_GetCrossPairInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_TT_GetCrossPairInfo]
----功		  能：获取跨国组合的信息
----作		  者：王强
----日		  期: 2011-6-9

CREATE PROCEDURE [dbo].[Proc_TT_GetCrossPairInfo] 
	
AS
BEGIN
	
SET NOCOUNT ON

	SELECT A.F_RegisterID AS RegID, A.F_RegisterCode AS RegCode, B.F_LongName AS PairName, 
	D.F_SexShortName AS Sex, CASE WHEN C.F_RegisterID IS NULL THEN 0 ELSE 1 END AS Inscription
	FROM TR_Register AS A 
	LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Inscription AS C ON C.F_RegisterID = A.F_RegisterID
	LEFT JOIN TC_Sex_Des AS D ON D.F_SexCode = A.F_SexCode AND D.F_LanguageCode = 'ENG'
	WHERE A.F_RegisterID IS NOT NULL AND A.F_RegisterID != -1 AND A.F_DelegationID IS NULL AND A.F_RegTypeID = 2
	AND A.F_RegisterCode IS NOT NULL AND A.F_SexCode IS NOT NULL

SET NOCOUNT OFF
END

GO

