IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_CreateModel2XML]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_CreateModel2XML]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_CreateModel2XML]
----功		  能：将一个编排模型导出为XML文件
----作		  者：郑金勇
----日		  期: 2009-08-20 

CREATE PROCEDURE [dbo].[proc_CreateModel2XML]
    @ModelID			INT,
	@ModelXML			NVARCHAR(MAX) OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @TM_ModelDoc AS NVARCHAR(MAX)
	DECLARE @TM_PhaseDoc AS NVARCHAR(MAX)
	DECLARE @TM_Phase_DesDoc AS NVARCHAR(MAX)
	DECLARE @TM_Phase_MatchPointDoc AS NVARCHAR(MAX)
	DECLARE @TM_MatchDoc AS NVARCHAR(MAX)
	DECLARE @TM_Match_DesDoc AS NVARCHAR(MAX)
	DECLARE @TM_Match_ResultDoc AS NVARCHAR(MAX)
	DECLARE @TM_Match_Result_DesDoc AS NVARCHAR(MAX)
	DECLARE @TM_Phase_PositionDoc AS NVARCHAR(MAX)
	DECLARE @TM_Phase_ResultDoc AS NVARCHAR(MAX)
	DECLARE @TM_RoundDoc AS NVARCHAR(MAX)
	DECLARE @TM_Round_DesDoc AS NVARCHAR(MAX)
	DECLARE @TM_Event_ResultDoc AS NVARCHAR(MAX)
	
	DECLARE @TM_Phase_Model AS NVARCHAR(MAX)
	DECLARE @TM_Phase_Model_Match_Result AS NVARCHAR(MAX)
	DECLARE @TM_Phase_Model_Match_Result_Des AS NVARCHAR(MAX)
	DECLARE @TM_Phase_Model_Phase_Position AS NVARCHAR(MAX)
	DECLARE @TM_Phase_Model_Phase_Resut AS NVARCHAR(MAX)
	DECLARE @TM_Match_Model AS NVARCHAR(MAX)
	DECLARE @TM_Match_Model_Match_Result AS NVARCHAR(MAX)
	DECLARE @TM_Match_Model_Match_Result_Des AS NVARCHAR(MAX)

	SET @TM_ModelDoc = '<TM_Models>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Model WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Models>'

	SET @TM_PhaseDoc = '<TM_Phases>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Phase WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Phases>'

	SET @TM_Phase_DesDoc = '<TM_Phase_Dess>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Phase_Des WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Phase_Dess>'

	SET @TM_Phase_MatchPointDoc = '<TM_Phase_MatchPoints>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Phase_MatchPoint WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Phase_MatchPoints>'

	SET @TM_MatchDoc = '<TM_Matchs>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Match WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Matchs>'

	SET @TM_Match_DesDoc = '<TM_Match_Dess>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Match_Des WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Match_Dess>'

	SET @TM_Match_ResultDoc = '<TM_Match_Results>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Match_Result WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Match_Results>'

	SET @TM_Match_Result_DesDoc = '<TM_Match_Result_Dess>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Match_Result_Des WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Match_Result_Dess>'

	SET @TM_Phase_PositionDoc = '<TM_Phase_Positions>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Phase_Position WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Phase_Positions>'

	SET @TM_Phase_ResultDoc = '<TM_Phase_Results>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Phase_Result WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Phase_Results>'

	SET @TM_RoundDoc = '<TM_Rounds>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Round WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Rounds>'

	SET @TM_Round_DesDoc = '<TM_Round_Dess>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Round_Des WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Round_Dess>'

	SET @TM_Event_ResultDoc = '<TM_Event_Results>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Event_Result WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Event_Results>'


	SET @TM_Phase_Model = '<TM_Phase_Models>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Phase_Model WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Phase_Models>'

	SET @TM_Phase_Model_Match_Result = '<TM_Phase_Model_Match_Results>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Phase_Model_Match_Result WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Phase_Model_Match_Results>'

	SET @TM_Phase_Model_Match_Result_Des = '<TM_Phase_Model_Match_Result_Dess>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Phase_Model_Match_Result_Des WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Phase_Model_Match_Result_Dess>'

	SET @TM_Phase_Model_Phase_Position = '<TM_Phase_Model_Phase_Positions>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Phase_Model_Phase_Position WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Phase_Model_Phase_Positions>'

	SET @TM_Phase_Model_Phase_Resut = '<TM_Phase_Model_Phase_Resuts>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Phase_Model_Phase_Resut WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Phase_Model_Phase_Resuts>'

	SET @TM_Match_Model = '<TM_Match_Models>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Match_Model WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Match_Models>'

	SET @TM_Match_Model_Match_Result = '<TM_Match_Model_Match_Results>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Match_Model_Match_Result WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Match_Model_Match_Results>'

	SET @TM_Match_Model_Match_Result_Des = '<TM_Match_Model_Match_Result_Dess>'+ CHAR(10) + CHAR(13) 
						+ ( SELECT * FROM TM_Match_Model_Match_Result_Des WHERE F_ModelID = @ModelID FOR XML AUTO, ELEMENTS XSINIL )
						+ CHAR(10) + CHAR(13) +'</TM_Match_Model_Match_Result_Dess>'



	SET @ModelXML = '<ModelRoot>'+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_ModelDoc IS NULL THEN '' ELSE @TM_ModelDoc END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_PhaseDoc IS NULL THEN '' ELSE @TM_PhaseDoc END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Phase_DesDoc IS NULL THEN '' ELSE @TM_Phase_DesDoc END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Phase_MatchPointDoc IS NULL THEN '' ELSE @TM_Phase_MatchPointDoc END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_MatchDoc IS NULL THEN '' ELSE @TM_MatchDoc END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Match_DesDoc IS NULL THEN '' ELSE @TM_Match_DesDoc END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Match_ResultDoc IS NULL THEN '' ELSE @TM_Match_ResultDoc END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Match_Result_DesDoc IS NULL THEN '' ELSE @TM_Match_Result_DesDoc END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Phase_PositionDoc IS NULL THEN '' ELSE @TM_Phase_PositionDoc END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Phase_ResultDoc IS NULL THEN '' ELSE @TM_Phase_ResultDoc END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_RoundDoc IS NULL THEN '' ELSE @TM_RoundDoc END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Round_DesDoc IS NULL THEN '' ELSE @TM_Round_DesDoc END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Event_ResultDoc IS NULL THEN '' ELSE @TM_Event_ResultDoc END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Phase_Model IS NULL THEN '' ELSE @TM_Phase_Model END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Phase_Model_Match_Result IS NULL THEN '' ELSE @TM_Phase_Model_Match_Result END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Phase_Model_Match_Result_Des IS NULL THEN '' ELSE @TM_Phase_Model_Match_Result_Des END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Phase_Model_Phase_Position IS NULL THEN '' ELSE @TM_Phase_Model_Phase_Position END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Phase_Model_Phase_Resut IS NULL THEN '' ELSE @TM_Phase_Model_Phase_Resut END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Match_Model IS NULL THEN '' ELSE @TM_Match_Model END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Match_Model_Match_Result IS NULL THEN '' ELSE @TM_Match_Model_Match_Result END)
					+ CHAR(10) + CHAR(13) + (CASE WHEN @TM_Match_Model_Match_Result_Des IS NULL THEN '' ELSE @TM_Match_Model_Match_Result_Des END)
					+ CHAR(10) + CHAR(13) +'</ModelRoot>'

	RETURN

SET NOCOUNT OFF
END

GO

/*

DECLARE @ModelXML AS NVARCHAR(MAX)
EXEC proc_CreateModel2XML 1, @ModelXML OUTPUT
SELECT @ModelXML
SELECT RIGHT (@ModelXML,50)
SELECT LEN(@ModelXML)
GO
*/