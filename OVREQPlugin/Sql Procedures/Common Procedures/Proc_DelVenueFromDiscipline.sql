IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelVenueFromDiscipline]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelVenueFromDiscipline]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[Proc_DelVenueFromDiscipline]
----��		  �ܣ���һ����Ŀ֮��ɾ��һ��Venue
----��		  �ߣ�֣���� 
----��		  ��: 2009-05-25

CREATE PROCEDURE [dbo].[Proc_DelVenueFromDiscipline]
	@DisciplineID		INT,
	@VenueID			INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	ɾ��һ��Venueʧ�ܣ���ʾû�����κβ�����
					  -- @Result=1; 	ɾ��һ��Venue�ɹ���
					  -- @Result=-2; 	�Ƴ�����ʧ��! ����Ŀ�����б���ʹ�øó���!
	IF EXISTS(SELECT A.F_MatchID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID 
					LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID LEFT JOIN TS_Discipline AS D ON C.F_DisciplineID = D.F_DisciplineID
						WHERE A.F_VenueID = @VenueID AND D.F_DisciplineID = @DisciplineID)
	BEGIN
		SET @Result = -2
		RETURN
	END

	DELETE FROM TD_Discipline_Venue WHERE F_DisciplineID = @DisciplineID AND F_VenueID = @VenueID
	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO

