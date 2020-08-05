IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPhaseStatusList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetPhaseStatusList]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    �ƣ�[Proc_GetPhaseStatusList]
--��    �����õ�״̬�б�
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2010��06��23��
--�޸ļ�¼��


CREATE PROCEDURE [dbo].[Proc_GetPhaseStatusList](
											@LanguageCode	CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	
	CREATE TABLE #Tmp_Table(
								F_StatusLongName			NVARCHAR(100),
								F_StatusID			INT
							)


	INSERT INTO #Tmp_Table (F_StatusID, F_StatusLongName) SELECT A.F_StatusID, B.F_StatusLongName FROM
		TC_Phase_Status AS A LEFT JOIN TC_Phase_Status_Des AS B ON A.F_StatusID = B.F_StatusID AND B.F_LanguageCode = @LanguageCode

	SELECT F_StatusLongName, F_StatusID FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

