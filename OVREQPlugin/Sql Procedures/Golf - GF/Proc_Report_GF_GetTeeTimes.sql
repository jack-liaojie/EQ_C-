IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_GetTeeTimes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_GetTeeTimes]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----名    称：[Proc_Report_GF_GetTeeTimes]
----功	  能：得到单个Round的TeeTimes
----作	  者：张翠霞
----日	  期: 2010-09-15
----修改记录：
/*			
			时间				修改人		修改内容	
			2012年09月13日      吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/



CREATE PROCEDURE [dbo].[Proc_Report_GF_GetTeeTimes] 
                   (	
					@MatchID			    INT,
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON

   SET LANGUAGE ENGLISH

        CREATE TABLE #Temp_table(
                                   F_RegisterID    INT,
                                   F_Group         INT,
                                   F_Time          NVARCHAR(10),
                                   F_Tee           NVARCHAR(10),
                                   F_TeeEx         NVARCHAR(10),
                                   F_Bib           NVARCHAR(10),
                                   F_Name          NVARCHAR(100),
                                   F_NOC           NVARCHAR(10),
                                   F_Delegation    NVARCHAR(20),
                                   F_Round1        INT,
                                   F_Round2        INT,
                                   F_Round3        INT,
                                   F_Round4        INT,
								   F_RoundEx1      NVARCHAR(10),
								   F_RoundEx2      NVARCHAR(10),
								   F_RoundEx3      NVARCHAR(10),
								   F_RoundEx4      NVARCHAR(10),                                   
								   F_IRMID1        INT,
								   F_IRMID2        INT,
								   F_IRMID3        INT,
								   F_IRMID4        INT,
								   F_IRMCode1      NVARCHAR(10),
								   F_IRMCode2      NVARCHAR(10),
								   F_IRMCode3      NVARCHAR(10),
								   F_IRMCode4      NVARCHAR(10),
                                   F_Total         INT,
                                   F_TotalEx       NVARCHAR(10),
								   F_IRMID         INT,
								   F_IRMCode       NVARCHAR(10),
                                   F_GroupOrder    INT                                 
                                )

        INSERT INTO #Temp_Table(F_RegisterID, F_Group, F_Time, F_Tee, F_TeeEx, F_Bib, F_Name, F_NOC, F_Delegation, F_GroupOrder)
        SELECT MR.F_RegisterID, MR.F_CompetitionPositionDes2, MR.F_StartTimeCharDes, MR.F_StartTimeNumDes, MR.F_StartTimeNumDes
        , R.F_Bib, RD.F_PrintLongName, D.F_DelegationCode, DD.F_DelegationLongName, MR.F_FinishTimeNumDes
        FROM TS_Match_Result AS MR
        LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID
        LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
        LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
        LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
        WHERE MR.F_MatchID = @MatchID
        ORDER BY MR.F_CompetitionPositionDes1, MR.F_FinishTimeNumDes

		-- 创建临时表, 加入基本字段
		CREATE TABLE #MatchResult
		(
			F_CompetitionPosition   INT,
			F_RegisterID            INT,
			F_MatchID               INT,
			F_Round1                INT,
			F_Round2                INT,
			F_Round3                INT,
			F_Round4                INT,
			F_IRMID1                INT,
			F_IRMID2                INT,
			F_IRMID3                INT,
			F_IRMID4                INT,
			F_Total                 INT
		)
		
		DECLARE @PhaseOrder AS INT
		DECLARE @EventID AS INT
	    
		SELECT @PhaseOrder = P.F_Order, @EventID = P.F_EventID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE M.F_MatchID = @MatchID

		-- 在临时表中插入基本信息
		INSERT #MatchResult
			(F_CompetitionPosition, F_RegisterID, F_MatchID, F_Round1, F_Round2, F_Round3, F_Round4, F_IRMID1, F_IRMID2, F_IRMID3, F_IRMID4)	
			(
				SELECT 
					  MR.F_CompetitionPosition
					, MR.F_RegisterID
					, MR.F_MatchID
					, (CASE WHEN @PhaseOrder > 1 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MR.F_RegisterID, 1, 1) ELSE NULL END)
					, (CASE WHEN @PhaseOrder > 2 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MR.F_RegisterID, 2, 1) ELSE NULL END)
					, (CASE WHEN @PhaseOrder > 3 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MR.F_RegisterID, 3, 1) ELSE NULL END)
					, (CASE WHEN @PhaseOrder > 4 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MR.F_RegisterID, 4, 1) ELSE NULL END)
					, (CASE WHEN @PhaseOrder > 1 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MR.F_RegisterID, 1, 3) ELSE NULL END)
					, (CASE WHEN @PhaseOrder > 2 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MR.F_RegisterID, 2, 3) ELSE NULL END)
					, (CASE WHEN @PhaseOrder > 3 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MR.F_RegisterID, 3, 3) ELSE NULL END)
					, (CASE WHEN @PhaseOrder > 4 THEN [dbo].[Fun_GF_GetRegisterRoundHoleInfo](@EventID, MR.F_RegisterID, 4, 3) ELSE NULL END)
				FROM TS_Match_Result AS MR
				WHERE MR.F_MatchID = @MatchID
			)
				
			UPDATE #MatchResult SET F_Total = (CASE WHEN F_Round1 IS NULL THEN 0 ELSE F_Round1 END) + (CASE WHEN F_Round2 IS NULL THEN 0 ELSE F_Round2 END)
				+ (CASE WHEN F_Round3 IS NULL THEN 0 ELSE F_Round3 END) + (CASE WHEN F_Round4 IS NULL THEN 0 ELSE F_Round4 END)
		
		UPDATE A SET A.F_Round1 = B.F_Round1, A.F_Round2 = B.F_Round2, A.F_Round3 = B.F_Round3,  A.F_Round4 = B.F_Round4,
					 A.F_IRMID1 = B.F_IRMID1, A.F_IRMID2 = B.F_IRMID2, A.F_IRMID3 = B.F_IRMID3,  A.F_IRMID4 = B.F_IRMID4,
		             A.F_Total = (CASE WHEN B.F_Total = 0 THEN NULL ELSE B.F_Total END)
		FROM #Temp_table AS A LEFT JOIN #MatchResult AS B ON A.F_RegisterID = B.F_RegisterID

		update #Temp_table set f_irmcode1 = (select f_irmcode from TC_IRM where F_IRMID = f_irmid1)
		update #Temp_table set f_irmcode2 = (select f_irmcode from TC_IRM where F_IRMID = f_irmid2)
		update #Temp_table set f_irmcode3 = (select f_irmcode from TC_IRM where F_IRMID = f_irmid3)
		update #Temp_table set f_irmcode4 = (select f_irmcode from TC_IRM where F_IRMID = f_irmid4)

		--UPDATE #Temp_table SET F_IRMCode = 'DQ' WHERE f_irmcode1 = 'DQ' OR f_irmcode2 = 'DQ' OR f_irmcode3 = 'DQ' OR f_irmcode4 = 'DQ' 
		--UPDATE #Temp_table SET F_IRMCode = 'WD' WHERE f_irmcode1 = 'WD' OR f_irmcode2 = 'WD' OR f_irmcode3 = 'WD' OR f_irmcode4 = 'WD' AND F_IRMCode IS NULL 
		--UPDATE #Temp_table SET F_IRMCode = 'RTD' WHERE f_irmcode1 = 'RTD' OR f_irmcode2 = 'RTD' OR f_irmcode3 = 'RTD' OR f_irmcode4 = 'RTD' AND F_IRMCode IS NULL 
		UPDATE #Temp_table SET F_IRMCode = [dbo].[Fun_GF_GetTotalIRMCode] (@phaseorder,f_irmcode1,f_irmcode2,f_irmcode3,f_irmcode4) 
		UPDATE #Temp_table SET F_IRMID = [dbo].[Fun_GF_GetIRMID] (F_IRMCode)
			    	 
	    IF @PhaseOrder = 1 
			UPDATE #Temp_table SET F_Round1 = NULL,F_Round2 = NULL,F_Round3 = NULL,F_Round4 = NULL
        ELSE IF @PhaseOrder = 2
            UPDATE #Temp_table SET F_Round2 = NULL,F_Round3 = NULL,F_Round4 = NULL
        ELSE IF @PhaseOrder = 3
            UPDATE #Temp_table SET F_Round3 = NULL,F_Round4 = NULL
        ELSE IF @PhaseOrder = 4
            UPDATE #Temp_table SET F_Round4 = NULL
           
		UPDATE #Temp_table SET F_RoundEx1 = F_Round1 WHERE F_IRMID1 IS NULL
		UPDATE #Temp_table SET F_RoundEx2 = F_Round2 WHERE F_IRMID2 IS NULL
		UPDATE #Temp_table SET F_RoundEx3 = F_Round3 WHERE F_IRMID3 IS NULL
		UPDATE #Temp_table SET F_RoundEx4 = F_Round4 WHERE F_IRMID4 IS NULL
		UPDATE #Temp_table SET F_RoundEx1 = F_IRMCode1 WHERE F_IRMID1 IS NOT NULL
		UPDATE #Temp_table SET F_RoundEx2 = F_IRMCode2 WHERE F_IRMID2 IS NOT NULL
		UPDATE #Temp_table SET F_RoundEx3 = F_IRMCode3 WHERE F_IRMID3 IS NOT NULL
		UPDATE #Temp_table SET F_RoundEx4 = F_IRMCode4 WHERE F_IRMID4 IS NOT NULL
		UPDATE #Temp_table SET F_TotalEx = F_Total WHERE F_IRMID IS NULL
		UPDATE #Temp_table SET F_TotalEx = F_IRMCode WHERE F_IRMID IS NOT NULL
                        			    	   
        UPDATE #Temp_table SET F_Bib = F_NOC + F_Bib
        UPDATE #Temp_table SET F_Tee = NULL WHERE F_GroupOrder <> 1
        
        SELECT * FROM #Temp_Table
SET NOCOUNT OFF
END

GO


