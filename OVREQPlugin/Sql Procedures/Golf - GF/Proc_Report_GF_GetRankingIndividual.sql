IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_GetRankingIndividual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_GetRankingIndividual]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----名    称: [Proc_Report_GF_GetRankingIndividual]
----描    述: 为C74A报表服务
----参数说明: 
----说    明: 
----创 建 人: 张翠霞
----日    期: 2010年10月06日
----修改记录：
/*			
			时间				修改人		修改内容	
			2012年09月13日      吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/



CREATE PROCEDURE [dbo].[Proc_Report_GF_GetRankingIndividual]
	@MatchID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @SplitSQL		NVARCHAR(MAX)

	-- 创建临时表, 加入基本字段
	CREATE TABLE #MatchResult
	(
	    F_CompetitionPosition   INT,
	    F_RegisterID            INT,	    
		F_Rank                   NVARCHAR(10),
		F_Bib                   NVARCHAR(10),
		Name					NVARCHAR(100),
		NOC						CHAR(3),
		Delegation              NVARCHAR(20),
		F_TodayToPar            NVARCHAR(10),
		F_IRMID                 INT,
		F_IRMCode               NVARCHAR(10),
		F_MatchID               INT,
		F_TotalToPar            NVARCHAR(10),
		F_ToPar1                    INT,
		F_ToPar2                    INT,
		F_ToPar3                    INT,
		F_ToPar4                    INT,
		F_Round1                    INT,
		F_Round2                    INT,
		F_Round3                    INT,
		F_Round4                    INT,
		F_RoundEx1             NVARCHAR(10),
		F_RoundEx2             NVARCHAR(10),
		F_RoundEx3             NVARCHAR(10),
		F_RoundEx4             NVARCHAR(10),
		F_IRMIDR1                 INT,
		F_IRMIDR2                 INT,
		F_IRMIDR3                 INT,
		F_IRMIDR4                 INT,
		F_IRMCodeR1                  NVARCHAR(10),
		F_IRMCodeR2                  NVARCHAR(10),
		F_IRMCodeR3                  NVARCHAR(10),
		F_IRMCodeR4                  NVARCHAR(10),
		F_Total                 INT,
		F_TotalEx                  NVARCHAR(10),
		F_TodayIRMID                INT,
		F_TodayIRMCode              NVARCHAR(10),
		F_DisplayPos1           INT,		
		F_DisplayPos2           INT,		
		F_DisplayPos3           INT,		
		F_DisplayPos4           INT,								
		F_DisplayPos            INT
	)
	
	DECLARE @PhaseOrder AS INT
    DECLARE @EventID AS INT
    DECLARE @MatchIDR1 AS INT
    DECLARE @MatchIDR2 AS INT
    DECLARE @MatchIDR3 AS INT
    DECLARE @MatchIDR4 AS INT
    
    SELECT @PhaseOrder = P.F_Order, @EventID = P.F_EventID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE M.F_MatchID = @MatchID
    SELECT @MatchIDR1 = M.F_MatchID FROM TS_Match AS M where m.F_PhaseID = (select F_PhaseID from TS_Phase where F_EventID = @EventID and F_Order = 1) 
    SELECT @MatchIDR2 = M.F_MatchID FROM TS_Match AS M where m.F_PhaseID = (select F_PhaseID from TS_Phase where F_EventID = @EventID and F_Order = 2) 
    SELECT @MatchIDR3 = M.F_MatchID FROM TS_Match AS M where m.F_PhaseID = (select F_PhaseID from TS_Phase where F_EventID = @EventID and F_Order = 3) 
    SELECT @MatchIDR4 = M.F_MatchID FROM TS_Match AS M where m.F_PhaseID = (select F_PhaseID from TS_Phase where F_EventID = @EventID and F_Order = 4) 

	-- 在临时表中插入基本信息
	INSERT #MatchResult
		(F_CompetitionPosition, F_RegisterID, F_Rank, NOC, Delegation, Name, F_Bib, F_TodayToPar, F_MatchID, 
		F_ToPar1, F_ToPar2, F_ToPar3, F_ToPar4, F_Round1, F_Round2, F_Round3, F_Round4, 
		F_IRMIDR1, F_IRMIDR2, F_IRMIDR3, F_IRMIDR4, F_TodayIRMID, F_TodayIRMCode, F_DisplayPos,
		F_DisplayPos1,F_DisplayPos2,F_DisplayPos3,F_DisplayPos4)	
		(
			SELECT 
			      MR.F_CompetitionPosition
			    , MRR1.F_RegisterID  			      
				, MR.F_Rank 
				, D.F_DelegationCode
				, DD.F_DelegationLongName
				, RD.F_PrintLongName
				, D.F_DelegationCode + CAST(R.F_Bib AS NVARCHAR(10))
				, MR.F_PointsCharDes2
				, MR.F_MatchID
				, (CASE WHEN @PhaseOrder >= 1 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MRR1.F_RegisterID, 1, 2) ELSE NULL END)
				, (CASE WHEN @PhaseOrder >= 2 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MRR1.F_RegisterID, 2, 2) ELSE NULL END)
				, (CASE WHEN @PhaseOrder >= 3 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MRR1.F_RegisterID, 3, 2) ELSE NULL END)
				, (CASE WHEN @PhaseOrder >= 4 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MRR1.F_RegisterID, 4, 2) ELSE NULL END)
				, (CASE WHEN @PhaseOrder >= 1 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MRR1.F_RegisterID, 1, 1) ELSE NULL END)
				, (CASE WHEN @PhaseOrder >= 2 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MRR1.F_RegisterID, 2, 1) ELSE NULL END)
				, (CASE WHEN @PhaseOrder >= 3 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MRR1.F_RegisterID, 3, 1) ELSE NULL END)
				, (CASE WHEN @PhaseOrder >= 4 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MRR1.F_RegisterID, 4, 1) ELSE NULL END)
				, (CASE WHEN @PhaseOrder >= 1 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MRR1.F_RegisterID, 1, 3) ELSE NULL END)
				, (CASE WHEN @PhaseOrder >= 2 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MRR1.F_RegisterID, 2, 3) ELSE NULL END)
				, (CASE WHEN @PhaseOrder >= 3 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MRR1.F_RegisterID, 3, 3) ELSE NULL END)
				, (CASE WHEN @PhaseOrder >= 4 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MRR1.F_RegisterID, 4, 3) ELSE NULL END)
				, MR.F_IRMID
				, I.F_IRMCODE
				, [dbo].[Fun_GF_GetRegisterDispalyPosition](@PhaseOrder, MRR1.F_DisplayPosition, MRR2.F_DisplayPosition, MRR3.F_DisplayPosition ,MRR4.F_DisplayPosition ) 
				, MRR1.F_DisplayPosition, MRR2.F_DisplayPosition, MRR3.F_DisplayPosition ,MRR4.F_DisplayPosition
			FROM TS_Match_Result AS MRR1
				LEFT JOIN TR_Register AS R
					ON MRR1.F_RegisterID = R.F_RegisterID
				LEFT JOIN TC_Delegation AS D
					ON R.F_DelegationID = D.F_DelegationID
				LEFT JOIN TC_Delegation_Des AS DD
					ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
				LEFT JOIN TR_Register_Des AS RD
					ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			    LEFT JOIN TS_Match_Result AS MR
					ON MRR1.F_RegisterID = MR.F_RegisterID AND MR.F_MatchID = @MatchID
				LEFT JOIN TC_IRM AS I
					ON MR.F_IRMID = I.F_IRMID
			    LEFT JOIN TS_Match_Result AS MRR2
					ON MRR1.F_RegisterID = MRR2.F_RegisterID AND MRR2.F_MatchID = @MatchIDR2
			    LEFT JOIN TS_Match_Result AS MRR3
					ON MRR1.F_RegisterID = MRR3.F_RegisterID AND MRR3.F_MatchID = @MatchIDR3
			    LEFT JOIN TS_Match_Result AS MRR4
					ON MRR1.F_RegisterID = MRR4.F_RegisterID AND MRR4.F_MatchID = @MatchIDR4
			WHERE MRR1.F_MatchID = @MatchIDR1
		)
		
		UPDATE #MatchResult SET F_Total = (CASE WHEN F_Round1 IS NULL THEN 0 ELSE F_Round1 END) + (CASE WHEN F_Round2 IS NULL THEN 0 ELSE F_Round2 END)
		    + (CASE WHEN F_Round3 IS NULL THEN 0 ELSE F_Round3 END) + (CASE WHEN F_Round4 IS NULL THEN 0 ELSE F_Round4 END)
		    
		UPDATE #MatchResult SET F_TotalToPar = (CASE WHEN F_ToPar1 IS NULL THEN 0 ELSE F_ToPar1 END) + (CASE WHEN F_ToPar2 IS NULL THEN 0 ELSE F_ToPar2 END)
		    + (CASE WHEN F_ToPar3 IS NULL THEN 0 ELSE F_ToPar3 END) + (CASE WHEN F_ToPar4 IS NULL THEN 0 ELSE F_ToPar4 END)
		    
		UPDATE #MatchResult SET F_TodayToPar = 'E' WHERE F_TodayToPar = '0'
	    UPDATE #MatchResult SET F_TodayToPar = '+'+F_TodayToPar WHERE F_TodayToPar <> 'E' AND cast(F_TodayToPar as int) > 0
		UPDATE #MatchResult SET F_TotalToPar = 'E' WHERE F_TotalToPar = '0'
	    UPDATE #MatchResult SET F_TotalToPar = '+'+F_TotalToPar WHERE F_TotalToPar <> 'E' AND cast(F_TotalToPar as int) > 0
		UPDATE #MatchResult SET F_TodayToPar = NULL, F_Total = NULL, F_TotalToPar = NULL WHERE F_IRMID IS NOT NULL
		UPDATE #MatchResult SET F_Round1 = NULL WHERE F_IRMIDR1 IS NOT NULL
		UPDATE #MatchResult SET F_Round2 = NULL WHERE F_IRMIDR2 IS NOT NULL
		UPDATE #MatchResult SET F_Round3 = NULL WHERE F_IRMIDR3 IS NOT NULL
		UPDATE #MatchResult SET F_Round4 = NULL WHERE F_IRMIDR4 IS NOT NULL

		update #MatchResult set f_irmcoder1 = (select f_irmcode from TC_IRM where F_IRMID = f_irmidr1)
		update #MatchResult set f_irmcoder2 = (select f_irmcode from TC_IRM where F_IRMID = f_irmidr2)
		update #MatchResult set f_irmcoder3 = (select f_irmcode from TC_IRM where F_IRMID = f_irmidr3)
		update #MatchResult set f_irmcoder4 = (select f_irmcode from TC_IRM where F_IRMID = f_irmidr4)

		IF @PhaseOrder = 1
			UPDATE #MatchResult SET F_DisplayPos = B.DisplayPos
			FROM #MatchResult AS A 
			LEFT JOIN (SELECT row_number() OVER(ORDER BY 
			(CASE WHEN F_IRMCodeR1 IS NOT NULL THEN 1 ELSE 0 END),
			case when F_DisplayPos1 is null then 999 else F_DisplayPos1 end
			) AS DisplayPos
			, * FROM #MatchResult)
			AS B ON A.F_RegisterID = B.F_RegisterID
		IF @PhaseOrder = 2
			UPDATE #MatchResult SET F_DisplayPos = B.DisplayPos
			FROM #MatchResult AS A 
			LEFT JOIN (SELECT row_number() OVER(ORDER BY 
			(CASE WHEN F_IRMCodeR1 IS NOT NULL THEN 1 ELSE 0 END),
			(CASE WHEN F_IRMCodeR2 IS NOT NULL THEN 1 ELSE 0 END),
			case when F_DisplayPos2 is null then 999 else F_DisplayPos2 end ,
			case when F_DisplayPos1 is null then 999 else F_DisplayPos1 end
			) AS DisplayPos
			, * FROM #MatchResult)
			AS B ON A.F_RegisterID = B.F_RegisterID
		IF @PhaseOrder = 3
			UPDATE #MatchResult SET F_DisplayPos = B.DisplayPos
			FROM #MatchResult AS A 
			LEFT JOIN (SELECT row_number() OVER(ORDER BY 
			(CASE WHEN F_IRMCodeR1 IS NOT NULL THEN 1 ELSE 0 END),
			(CASE WHEN F_IRMCodeR2 IS NOT NULL THEN 1 ELSE 0 END),
			(CASE WHEN F_IRMCodeR3 IS NOT NULL THEN 1 ELSE 0 END),
			case when F_DisplayPos3 is null then 999 else F_DisplayPos3 end, 
			case when F_DisplayPos2 is null then 999 else F_DisplayPos2 end,
			case when F_DisplayPos1 is null then 999 else F_DisplayPos1 end
			) AS DisplayPos
			, * FROM #MatchResult)
			AS B ON A.F_RegisterID = B.F_RegisterID		
		IF @PhaseOrder = 4
			UPDATE #MatchResult SET F_DisplayPos = B.DisplayPos
			FROM #MatchResult AS A 
				LEFT JOIN (SELECT row_number() OVER(ORDER BY 
				(CASE WHEN F_IRMCodeR1 IS NOT NULL THEN 1 ELSE 0 END),
				(CASE WHEN F_IRMCodeR2 IS NOT NULL THEN 1 ELSE 0 END),
				(CASE WHEN F_IRMCodeR3 IS NOT NULL THEN 1 ELSE 0 END),
				(CASE WHEN F_IRMCodeR4 IS NOT NULL THEN 1 ELSE 0 END),
				case when F_DisplayPos4 is null then 999 else F_DisplayPos4 end, 
				case when F_DisplayPos3 is null then 999 else F_DisplayPos3 end,
				case when F_DisplayPos2 is null then 999 else F_DisplayPos2 end,
				case when F_DisplayPos1 is null then 999 else F_DisplayPos1 end
			) AS DisplayPos
			, * FROM #MatchResult)
			AS B ON A.F_RegisterID = B.F_RegisterID
		
		UPDATE #MatchResult SET F_IRMCode = [dbo].[Fun_GF_GetTotalIRMCode] (@phaseorder,f_irmcoder1,f_irmcoder2,f_irmcoder3,f_irmcoder4)
		UPDATE #MatchResult SET F_IRMID = [dbo].[Fun_GF_GetIRMID] (F_IRMCode)
	
		UPDATE #MatchResult SET F_TotalToPar = NULL WHERE F_IRMID IS NOT NULL
		UPDATE #MatchResult SET F_TodayToPar = NULL WHERE F_TodayIRMID IS NOT NULL
	
		UPDATE #MatchResult SET F_RoundEx1 = F_Round1 WHERE F_IRMIDR1 IS NULL
		UPDATE #MatchResult SET F_RoundEx2 = F_Round2 WHERE F_IRMIDR2 IS NULL
		UPDATE #MatchResult SET F_RoundEx3 = F_Round3 WHERE F_IRMIDR3 IS NULL
		UPDATE #MatchResult SET F_RoundEx4 = F_Round4 WHERE F_IRMIDR4 IS NULL
		UPDATE #MatchResult SET F_RoundEx1 = F_IRMCodeR1 WHERE F_IRMIDR1 IS NOT NULL
		UPDATE #MatchResult SET F_RoundEx2 = F_IRMCodeR2 WHERE F_IRMIDR2 IS NOT NULL
		UPDATE #MatchResult SET F_RoundEx3 = F_IRMCodeR3 WHERE F_IRMIDR3 IS NOT NULL
		UPDATE #MatchResult SET F_RoundEx4 = F_IRMCodeR4 WHERE F_IRMIDR4 IS NOT NULL
		UPDATE #MatchResult SET F_TotalEx = F_Total WHERE F_IRMID IS NULL
		UPDATE #MatchResult SET F_TotalEx = F_IRMCode WHERE F_IRMID IS NOT NULL
	
	SET	@SplitSQL = 'ALTER TABLE #MatchResult DROP COLUMN F_MatchID, F_CompetitionPosition'
		EXEC (@SplitSQL)

    DECLARE @n AS INT
    DECLARE @MaxDisPos AS INT
    DECLARE @count AS INT
    SELECT @MaxDisPos = max(F_DisplayPos) FROM #MatchResult
    SET @n = 1
    SET @count = 0
    while(@n<@MaxDisPos)
    begin
		DECLARE @nNVAR AS NVARCHAR(10)
		SET @nNVAR = cast(@n as NVARCHAR(10))
        SELECT @count = COUNT(*) FROM #MatchResult WHERE F_Rank = @nNVAR
		update #MatchResult set F_Rank = 'T' + F_Rank where @count > 1 and F_Rank = @nNVAR
		set @n = @n + 1
    end

	SELECT * FROM #MatchResult ORDER BY (CASE WHEN F_DisplayPos IS NULL THEN 1 ELSE 0 END), F_DisplayPos, NOC

SET NOCOUNT OFF
END

GO


