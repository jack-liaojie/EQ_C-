IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPositionSourceCompetitors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetPositionSourceCompetitors]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_GetPositionSourceCompetitors]
--描    述：得到一个签位，可能来源于本阶段某个运动员
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2009-09-11

CREATE PROCEDURE [dbo].[Proc_GetPositionSourceCompetitors](
				 @EventID			INT,
				 @PhaseID			INT,
				 @NodeType			INT,
                 @RegisterID        INT,
                 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #Temp_Table(
									F_LongName			NVARCHAR(1000),
									F_ID				INT
									)

	IF @NodeType = -1
	BEGIN

		INSERT INTO #Temp_Table (F_LongName, F_ID)
		  SELECT B.F_LongName AS F_LongName, A.F_RegisterID AS F_ID
			FROM TS_Event_Competitors AS A LEFT JOIN TR_Register_Des AS B 
				ON A.F_RegisterID = B.F_RegisterID WHERE B.F_LanguageCode = @LanguageCode AND A.F_EventID = @EventID

		DELETE FROM #Temp_Table WHERE F_ID IN (SELECT F_RegisterID FROM TS_Event_Position WHERE F_EventID = @EventID AND F_RegisterID <> @RegisterID)

	END
	ELSE
	BEGIN
	
		INSERT INTO #Temp_Table (F_LongName, F_ID)
		  SELECT B.F_LongName AS F_LongName, A.F_RegisterID AS F_ID
			FROM TS_Phase_Competitors AS A LEFT JOIN TR_Register_Des AS B 
				ON A.F_RegisterID = B.F_RegisterID WHERE B.F_LanguageCode = @LanguageCode AND A.F_PhaseID = @PhaseID

		DELETE FROM #Temp_Table WHERE F_ID IN (SELECT F_RegisterID FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID AND F_RegisterID <> @RegisterID)

	END

	INSERT INTO #Temp_Table (F_LongName, F_ID) VALUES ('BYE',-1)
    INSERT INTO #Temp_Table (F_LongName, F_ID) VALUES ('NONE',-2)
	SELECT F_LongName, F_ID FROM #Temp_Table
	
Set NOCOUNT OFF
End

GO


