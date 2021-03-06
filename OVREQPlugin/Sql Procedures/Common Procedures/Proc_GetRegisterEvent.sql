IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRegisterEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRegisterEvent]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








--名    称：[Proc_GetRegisterEvent]
--描    述：得到注册人员的报项
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2009年04月16日

CREATE PROCEDURE [dbo].[Proc_GetRegisterEvent]
                 @RegisterID         INT

AS
BEGIN
   SET NOCOUNT ON
       CREATE TABLE #table_RegisiterEvent(
                                          F_RegisterID          INT,
                                          F_LongName            NVARCHAR(100),
                                          F_EventID             INT,
                                          F_EventLongName        NVARCHAR(100),
                                          F_InscriptionNum       INT,
                                          F_Seed                 INT,
                                          F_InscriptionResult    NVARCHAR(100)
                                         )
 
    DECLARE @LanguageCode NVARCHAR(3)
    SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1

  INSERT INTO #table_RegisiterEvent(F_RegisterID,F_LongName,F_EventID,F_EventLongName,F_InscriptionNum,F_Seed,F_InscriptionResult)
          SELECT A.F_RegisterID,B.F_LongName,A.F_EventID,C.F_EventLongName,A.F_InscriptionNum,A.F_Seed,A.F_InscriptionResult
          FROM  TR_Inscription AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID  AND B.F_LanguageCode = @LanguageCode
                 LEFT JOIN TS_Event_Des  AS C ON A.F_EventID = C.F_EventID AND C.F_LanguageCode = @LanguageCode
           WHERE A.F_RegisterID = @RegisterID

  
   SELECT  F_LongName AS RegisterName, F_EventLongName AS EventLongName,  F_Seed AS Seed, F_InscriptionResult AS InscriptionResult, F_InscriptionNum AS InscriptionNum, F_RegisterID AS RegisterID,F_EventID AS EventID FROM #table_RegisiterEvent
   
Set NOCOUNT OFF
End

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
