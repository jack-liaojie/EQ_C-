IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPhaseIRMsList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetPhaseIRMsList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    �� [Proc_GetPhaseIRMsList]
--��    �����õ�һ��Phase��IRM�б�
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2010��07��08��

CREATE PROCEDURE [dbo].[Proc_GetPhaseIRMsList](
				 @PhaseID			INT,
                 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 
	
	CREATE TABLE #Table_IRMs(
									F_LongName			NVARCHAR(100),
									F_IRMID		INT
									)

	DECLARE @DisciplineID AS INT
	SELECT @DisciplineID = B.F_DisciplineID FROM TS_Phase AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID WHERE A.F_PhaseID = @PhaseID
	INSERT INTO #Table_IRMs (F_LongName, F_IRMID) SELECT F_IRMCODE, F_IRMID FROM TC_IRM WHERE F_DisciplineID = @DisciplineID
	INSERT INTO #Table_IRMs (F_LongName, F_IRMID) VALUES ('NONE', -1)
	SELECT * FROM #Table_IRMs
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

--exec Proc_GetPhaseIRMsList 1278, 'ENG'