IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddVenueIntoDiscipline]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddVenueIntoDiscipline]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[Proc_AddVenueIntoDiscipline]
----��		  �ܣ����һ��Venue��һ����Ŀ֮��
----��		  �ߣ�֣���� 
----��		  ��: 2009-05-25

CREATE PROCEDURE [dbo].[Proc_AddVenueIntoDiscipline]
	@DisciplineID		INT,
	@VenueID			INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	���һ��Venueʧ�ܣ���ʾû�����κβ�����
					  -- @Result=1; 	���һ��Venue�ɹ���
					  -- @Result=-3; 	��ӳ���ʧ��! ����Ŀ�����иó���!

	IF EXISTS(SELECT F_DisciplineID FROM TD_Discipline_Venue WHERE F_DisciplineID = @DisciplineID AND F_VenueID = @VenueID)
	BEGIN
		SET @Result = -3
		RETURN
	END

	INSERT INTO TD_Discipline_Venue (F_DisciplineID, F_VenueID) VALUES (@DisciplineID, @VenueID)
	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO

