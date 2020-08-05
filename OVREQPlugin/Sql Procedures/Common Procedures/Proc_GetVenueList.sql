IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetVenueList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetVenueList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    �ƣ�[Proc_GetVenueList]
--��    �����õ�һ��Discipline�µ����еĳ�����Ϣ
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2009��04��29��

CREATE PROCEDURE [dbo].[Proc_GetVenueList](
				 @DisciplineCode	CHAR(2)
)
As
Begin
SET NOCOUNT ON 

	DECLARE @DisciplineID AS INT
	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode
	
	DECLARE @LanguageCode AS CHAR(3)
	SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1

	
	CREATE TABLE #Tmp_Venues(
								F_VenueLongName		NVARCHAR(100),
								F_VenueID			INT
							)

	DECLARE @AllDes AS NVARCHAR(50)
	SET @AllDes = ' ȫ��'

	IF @LanguageCode = 'CHN'
	BEGIN
		SET @AllDes = ' ȫ��'
	END
	ELSE
	BEGIN
		IF @LanguageCode = 'ENG'
		BEGIN
			SET @AllDes = ' ALL'
		END
	END

	INSERT INTO #Tmp_Venues (F_VenueLongName, F_VenueID) VALUES (@AllDes, -1)


	INSERT INTO #Tmp_Venues (F_VenueLongName, F_VenueID) SELECT B.F_VenueLongName, A.F_VenueID FROM
		TD_Discipline_Venue AS A LEFT JOIN TC_Venue_Des AS B ON A.F_VenueID = B.F_VenueID WHERE A.F_DisciplineID = @DisciplineID AND B.F_LanguageCode = @LanguageCode 

	SELECT * FROM #Tmp_Venues ORDER BY F_VenueLongName

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

--exec Proc_GetVenueList 'BD'
