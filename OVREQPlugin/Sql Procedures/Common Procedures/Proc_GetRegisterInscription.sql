/****** Object:  StoredProcedure [dbo].[Proc_GetRegisterInscription]    Script Date: 09/18/2009 13:09:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRegisterInscription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRegisterInscription]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetRegisterInscription]    Script Date: 09/18/2009 13:06:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









--名    称：[Proc_GetRegisterInscription]
--描    述：得到注册人员的报项信息，包括该运动员，已经报的项目和可以报的项目列表
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年05月22日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
*/

/*			
			时间				修改人		修改内容
			2009年09月18日		李燕		增加Event的Order	
			2011年01月04日	    李燕        对于性别类型为“0”不做过滤
*/


CREATE PROCEDURE [dbo].[Proc_GetRegisterInscription]
(
                 @RegisterID         INT
)
AS
BEGIN
SET NOCOUNT ON

	CREATE TABLE #table_RegisiterInscription(
										F_Active				INT,
										F_RegisterID			INT,
										F_RegTypeID				INT,
										F_LongName				NVARCHAR(100),
										F_EventID				INT,
										F_EventLongName			NVARCHAR(100),
										F_InscriptionNum		INT,
										F_Seed					INT,
										F_InscriptionResult		NVARCHAR(100),
                                        F_InscriptionRank       INT,
                                        F_InscriptionReserve    INT,
                                        F_Reserve               NVARCHAR(100),
                                        F_EventOrder            INT
									 )
	
	DECLARE @LanguageCode		AS NVARCHAR(3)
	SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1

	DECLARE @RegisterLongName	AS NVARCHAR(100)
	SELECT @RegisterLongName = F_LongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID AND F_LanguageCode = @LanguageCode 

	DECLARE @DisciplineID	AS INT
	DECLARE @RegTypeID		AS INT
	DECLARE @SexCode		AS INT
	SELECT @DisciplineID = F_DisciplineID, @RegTypeID = F_RegTypeID, @SexCode = F_SexCode FROM TR_Register WHERE F_RegisterID = @RegisterID
	
	DECLARE @OpenSexCode   AS INT
	SET @OpenSexCode = 4

	IF @RegTypeID IN (1, 2, 3)
	BEGIN
	   IF(@SexCode = 4)  ----对于Event的注册性别为Men，Women，则不做过滤
	   BEGIN
	       INSERT INTO #table_RegisiterInscription(F_Active, F_RegisterID, F_RegTypeID, F_LongName, F_EventID, F_EventLongName, F_EventOrder)
			SELECT 0 AS F_Active, @RegisterID AS F_RegisterID, @RegTypeID AS F_RegTypeID, @RegisterLongName AS F_LongName, A.F_EventID, B.F_EventLongName, A.F_Order
				FROM TS_Event AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID  AND B.F_LanguageCode = @LanguageCode
					WHERE A.F_PlayerRegTypeID = @RegTypeID AND A.F_DisciplineID = @DisciplineID
	   END
	   ELSE
	   BEGIN
	     INSERT INTO #table_RegisiterInscription(F_Active, F_RegisterID, F_RegTypeID, F_LongName, F_EventID, F_EventLongName, F_EventOrder)
			SELECT 0 AS F_Active, @RegisterID AS F_RegisterID, @RegTypeID AS F_RegTypeID, @RegisterLongName AS F_LongName, A.F_EventID, B.F_EventLongName, A.F_Order
				FROM TS_Event AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID  AND B.F_LanguageCode = @LanguageCode
					WHERE A.F_PlayerRegTypeID = @RegTypeID AND A.F_SexCode IN (@SexCode, 3,4) AND A.F_DisciplineID = @DisciplineID
	   END
	END
	ELSE
	BEGIN
		INSERT INTO #table_RegisiterInscription(F_Active, F_RegisterID, F_RegTypeID, F_LongName, F_EventID, F_EventLongName, F_EventOrder)
			SELECT 0 AS F_Active, @RegisterID AS F_RegisterID, @RegTypeID AS F_RegTypeID, @RegisterLongName AS F_LongName, A.F_EventID, B.F_EventLongName, A.F_Order
				FROM TS_Event AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID  AND B.F_LanguageCode = @LanguageCode
					WHERE A.F_DisciplineID = @DisciplineID
	END

	UPDATE #table_RegisiterInscription SET F_Active = 1, F_InscriptionNum = B.F_InscriptionNum, F_Seed = B.F_Seed, F_InscriptionResult = B.F_InscriptionResult, F_InscriptionRank =  B.F_InscriptionRank, F_InscriptionReserve = B.F_Reserve
		FROM  #table_RegisiterInscription AS A RIGHT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID AND A.F_EventID = B.F_EventID
	
	UPDATE #table_RegisiterInscription SET F_LongName = NULL WHERE F_Active =0
    UPDATE #table_RegisiterInscription SET F_RegTypeID = NULL WHERE F_Active =0
    
    UPDATE #table_RegisiterInscription SET F_Reserve = 'Yes' WHERE F_InscriptionReserve = 1
    UPDATE #table_RegisiterInscription SET F_Reserve = 'No' WHERE F_InscriptionReserve = 0

	SELECT  F_Active AS Active, F_LongName AS RegisterName, F_EventLongName AS EventLongName,  F_Seed AS Seed, F_InscriptionResult AS InscriptionResult, F_InscriptionNum AS InscriptionNum, F_InscriptionRank AS InscriptionRank, F_Reserve AS Reserve,
	        F_RegisterID AS RegisterID, F_EventID AS EventID, F_RegTypeID AS RegTypeID 
         FROM #table_RegisiterInscription ORDER BY F_EventOrder

Set NOCOUNT OFF
End

