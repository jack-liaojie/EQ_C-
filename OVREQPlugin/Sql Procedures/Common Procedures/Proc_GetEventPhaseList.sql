

/****** Object:  StoredProcedure [dbo].[Proc_GetEventPhaseList]    Script Date: 04/25/2011 16:27:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEventPhaseList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetEventPhaseList]
GO


/****** Object:  StoredProcedure [dbo].[Proc_GetEventPhaseList]    Script Date: 04/25/2011 16:27:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GetEventPhaseList]
--描    述：为DataEntry服务，得到一个Event下面的Phase列表
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2011年04月25日

CREATE PROCEDURE [dbo].[Proc_GetEventPhaseList](
				 @EventID           INT, 
				 @DateTime          NVARCHAR(50)
)
As
Begin
SET NOCOUNT ON 

	DECLARE @LanguageCode AS CHAR(3)
	SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1

	CREATE TABLE #Tmp_Phase(
								F_PhaseLongName			NVARCHAR(100),
								F_PhaseID				INT
							)
	DECLARE @AllDes AS NVARCHAR(50)
	SET @AllDes = ' 全部'

	IF @LanguageCode = 'CHN'
	BEGIN
		SET @AllDes = ' 全部'
	END
	ELSE
	BEGIN
		IF @LanguageCode = 'ENG'
		BEGIN
			SET @AllDes = ' ALL'
		END
	END
	INSERT INTO #Tmp_Phase (F_PhaseLongName, F_PhaseID) VALUES (@AllDes,-1)

    IF(@EventID = -1)
    BEGIN
     	SELECT * FROM #Tmp_Phase 
     	RETURN
    END
    ELSE
    BEGIN
         IF ((@DateTime != ' ALL') AND (@DateTime != ' 全部'))
		BEGIN
		     INSERT INTO #Tmp_Phase (F_PhaseLongName, F_PhaseID)
			  SELECT DISTINCT PD.F_PhaseLongName, P.F_PhaseID
				FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
					LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
					LEFT JOIN TS_Phase_Des AS PD ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
			   WHERE  LEFT(CONVERT (NVARCHAR(100), M.F_MatchDate, 120), 10) = LTRIM(RTRIM(@DateTime)) AND E.F_EventID = @EventID
			   
		
		END
		ELSE 
		BEGIN
		    INSERT INTO #Tmp_Phase(F_PhaseLongName, F_PhaseID) 
			  SELECT C.F_PhaseLongName, A.F_PhaseID 
			  FROM TS_Phase AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
			       LEFT JOIN TS_Phase_Des AS C ON A.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode 
					WHERE B.F_EventID  = @EventID AND A.F_PhaseID NOT IN (SELECT DISTINCT F_FatherPhaseID FROM TS_Phase WHERE F_EventID = F_EventID) ORDER BY A.F_Order
		END

    END
	
    SELECT * FROM #Tmp_Phase 


Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


