IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEventCompetitorsList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetEventCompetitorsList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    �ƣ�[Proc_GetEventCompetitorsList]
--��    �����õ�һ��Event�²�����Ա�б���ҪΪ�༭���ս������
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2009��05��14��

CREATE PROCEDURE [dbo].[Proc_GetEventCompetitorsList](
				 @EventID			INT,
				 @RegisterID		INT,
                 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 
	
	CREATE TABLE #Table_Competitors(
									F_LongName			NVARCHAR(100),
									F_RegisterID		INT
									)


	DECLARE @PlayerRegTypeID AS INT
	SELECT @PlayerRegTypeID = F_PlayerRegTypeID FROM TS_Event WHERE F_EventID = @EventID 

	INSERT INTO #Table_Competitors (F_LongName, F_RegisterID)
		SELECT C.F_LongName, A.F_RegisterID FROM TR_Inscription AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
			LEFT JOIN TR_Register_Des AS C ON A.F_RegisterID = C.F_RegisterID
				WHERE A.F_EventID = @EventID AND B.F_RegTypeID = @PlayerRegTypeID AND C.F_LanguageCode = @LanguageCode

	DELETE FROM #Table_Competitors WHERE F_RegisterID IN (SELECT F_RegisterID FROM TS_Event_Result WHERE F_EventID = @EventID AND F_RegisterID <> @RegisterID)

	INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) VALUES ('NONE',-2)
	SELECT * FROM #Table_Competitors
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

