
/****** Object:  StoredProcedure [dbo].[Proc_AutoSwitch_SearchMatches]    Script Date: 04/25/2011 13:48:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AutoSwitch_SearchMatches]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AutoSwitch_SearchMatches]
GO



/****** Object:  StoredProcedure [dbo].[Proc_AutoSwitch_SearchMatches]    Script Date: 04/25/2011 13:48:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--��    �ƣ�[Proc_AutoSwitch_SearchMatches]
--��    �������ݲ�ѯ������ѯ���ϵ�Match�б� --�Զ����Һ��ʵĵ�������Ĵ洢���̽��е���
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2010��05��20��
--�޸ļ�¼��
/*
           2011��04��25��     ����        ����PhaseID��CourtID����
*/

CREATE PROCEDURE [dbo].[Proc_AutoSwitch_SearchMatches](
				 @DisciplineCode	CHAR(2),
				 @EventID			INT,
				 @DateTime			NVARCHAR(50),
				 @VenueID			INT,
				 @PhaseID           INT,
				 @CourtID           INT
)
As
Begin
SET NOCOUNT ON 
	DECLARE @SQL				AS NVARCHAR(MAX)
	DECLARE @DisciplineProcName AS NVARCHAR(50)
	SET @DisciplineProcName = N'[dbo].[Proc_SearchMatches_' + @DisciplineCode + N']'
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@DisciplineProcName) AND type in (N'P', N'PC'))
	BEGIN
		SET @SQL = N'EXEC ' + @DisciplineProcName + N' ''' + CAST(@DisciplineCode AS NVARCHAR(MAX)) + N''', '+CAST(@EventID AS NVARCHAR(MAX)) + N', '''+ CAST(@DateTime AS NVARCHAR(MAX)) + N''', '+ CAST(@VenueID AS NVARCHAR(MAX))+ N', '+ CAST(@PhaseID AS NVARCHAR(MAX)) + N', '+ CAST(@CourtID AS NVARCHAR(MAX))
		EXEC (@SQL)
		RETURN
	END
	ELSE
	BEGIN
		EXEC [dbo].[Proc_SearchMatches] @DisciplineCode, @EventID, @DateTime, @VenueID, @PhaseID, @CourtID
		RETURN
	END
	
	RETURN
	
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


