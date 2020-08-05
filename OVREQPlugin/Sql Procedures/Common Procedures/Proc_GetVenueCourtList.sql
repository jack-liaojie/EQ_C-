IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetVenueCourtList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetVenueCourtList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    �ƣ�[Proc_GetVenueCourtList]
--��    ����ΪDataEntry���񣬵õ�һ��Venue�����Court�б�
--����˵���� 
--˵    ����
--�� �� �ˣ�����
--��    �ڣ�2011��04��25��

CREATE PROCEDURE [dbo].[Proc_GetVenueCourtList](
				 @VenueID                  INT
)
As
Begin
SET NOCOUNT ON 

    
	DECLARE @LanguageCode AS CHAR(3)
	SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1

	CREATE TABLE #Tmp_Court(
								F_CourtShortName		NVARCHAR(100),
								F_CourtID				INT
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
	INSERT INTO #Tmp_Court (F_CourtShortName, F_CourtID) VALUES (@AllDes,-1)

    IF(@VenueID <> -1)
    BEGIN
       INSERT INTO #Tmp_Court (F_CourtShortName, F_CourtID) 
	    SELECT B.F_CourtShortName, A.F_CourtID 
	    FROM TC_Court AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @LanguageCode
	       WHERE A.F_VenueID = @VenueID

    END
	
	SELECT * FROM #Tmp_Court 

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

--exec [Proc_GetVenueCourtList] 35