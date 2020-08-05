IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetFullId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_GetFullId]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称：[proc_GetFullId]
--描    述：得到完整的各层次节点的Id
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2011年01月07日

CREATE PROCEDURE [dbo].[proc_GetFullId]
	@DisciplineID	INT,
	@EventID	    INT,
	@PhaseID	    INT,
	@MatchID	    INT
AS
BEGIN
	
SET NOCOUNT ON

	IF (@MatchID != -1)
	BEGIN
		SELECT A.F_MatchID, B.F_PhaseID, C.F_EventID, C.F_DisciplineID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID 
			LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID WHERE A.F_MatchID = @MatchID
		RETURN
	END
	ELSE
	BEGIN
			IF (@PhaseID != -1)
			BEGIN
					SELECT @MatchID AS F_MatchID, B.F_PhaseID, C.F_EventID, C.F_DisciplineID FROM TS_Phase AS B
						LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID WHERE B.F_PhaseID = @PhaseID
					RETURN
			END
			ELSE
			BEGIN
					IF (@EventID != -1)
					BEGIN
						SELECT @MatchID AS F_MatchID, @PhaseID AS F_PhaseID, C.F_EventID, C.F_DisciplineID FROM TS_Event AS C  WHERE C.F_EventID = @EventID
						RETURN
					END
					ELSE
					BEGIN
						SELECT @MatchID AS F_MatchID, @PhaseID AS F_PhaseID, @EventID AS F_EventID, @DisciplineID AS F_DisciplineID
						RETURN
					END
			END
	END

SET NOCOUNT OFF
END


GO


