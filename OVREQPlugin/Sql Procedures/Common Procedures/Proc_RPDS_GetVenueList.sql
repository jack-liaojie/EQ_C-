IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_RPDS_GetVenueList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_RPDS_GetVenueList]
GO

/****** Object:  StoredProcedure [dbo].[Proc_RPDS_GetVenueList]    Script Date: 04/22/2010 11:27:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_RPDS_GetVenueList]
--描    述：获得场馆列表
--参数说明： 
--说    明：
--创 建 人：余远华
--日    期：2010年05月06日


CREATE PROCEDURE [dbo].[Proc_RPDS_GetVenueList](
												@DisciplineCode	    CHAR(2),
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	DECLARE @DisciplineID AS INT
	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode

	SELECT CV.F_VenueCode, CVD.F_VenueLongName
		FROM TD_Discipline_Venue AS DDV 
			LEFT JOIN TC_Venue AS CV ON CV.F_VenueID = DDV.F_VenueID 
			LEFT JOIN TC_Venue_Des AS CVD ON CVD.F_VenueID = DDV.F_VenueID AND CVD.F_LanguageCode = @LanguageCode 
		WHERE DDV.F_DisciplineID = @DisciplineID
		ORDER BY CVD.F_VenueLongName


Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


/*
-- Just For Test

EXEC Proc_RPDS_GetVenueList 'RS', 'ENG'

*/

