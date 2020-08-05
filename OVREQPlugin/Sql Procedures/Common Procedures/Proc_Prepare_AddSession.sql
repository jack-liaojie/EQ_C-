IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Prepare_AddSession]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Prepare_AddSession]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Prepare_AddSession]
--��    ��: ׼�������������һ�� Session.
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2010��9��14�� ���ڶ�
--�޸ļ�¼��
/*			
			����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_Prepare_AddSession]
	@DisciplineID						INT,
	@Date								DateTime,
	@Number								INT,
	@Time								DateTime,
	@EndTime							DateTime,
	@TypeID								INT			-- 1 - ����; 2 - ����; 3 - ����; 4 - ����.
AS
BEGIN
SET NOCOUNT ON

	INSERT INTO TS_Session
	(F_DisciplineID, F_SessionDate, F_SessionNumber, F_SessionTime, F_SessionEndTime, F_SessionTypeID)
	VALUES
	(@DisciplineID, @Date, @Number, @Time, @EndTime, @TypeID)

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Prepare_AddSession] 

*/