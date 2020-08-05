IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetCompetitionSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetCompetitionSummary]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_Report_SL_GetCompetitionSummary]
--描    述：得到Discipline下得CompetitionSummary列表
--参数说明： 
--说    明：
--创 建 人：吴定昉
--日    期：2010年02月01日


CREATE PROCEDURE [dbo].[Proc_Report_SL_GetCompetitionSummary](
												@DisciplineID		INT,
												@LanguageCode		CHAR(3),
                                                @PhaseCode          INT
                                                
)
As
Begin
SET NOCOUNT ON 

    DECLARE @i	            INT
	DECLARE @K1MMaxDisPos	INT
	DECLARE @C1MMaxDisPos	INT
	DECLARE @C2MMaxDisPos	INT
	DECLARE @K1WMaxDisPos	INT
	DECLARE @MaxDisPos	    INT
	DECLARE @TemDisPos	    INT
	DECLARE @Rank           INT
	DECLARE @NOCCode        NVARCHAR(50)
    DECLARE @Name           NVARCHAR(100)
	DECLARE @IRM            NVARCHAR(50)

	CREATE TABLE #Tmp_Table(
    [Tem_DisPos]       INT,
    [K1M_Rank]         INT,
    [K1M_NOCCode]      NVARCHAR(50),
    [K1M_Name]         NVARCHAR(100),
    [C1M_Rank]         INT,
    [C1M_NOCCode]      NVARCHAR(50),
    [C1M_Name]         NVARCHAR(100),
    [C2M_Rank]         INT,
    [C2M_NOCCode]      NVARCHAR(50),
    [C2M_Name]         NVARCHAR(100),
    [K1W_Rank]         INT,
    [K1W_NOCCode]      NVARCHAR(50),
    [K1W_Name]         NVARCHAR(100)
	)

    IF @PhaseCode = 9
    BEGIN						
		SET @MaxDisPos = 0
		SET @TemDisPos = 0

        --//K1 Men
        select @K1MMaxDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '2' and e.f_eventcode = '110' and e.f_sexcode = 1 and e.f_disciplineid = @DisciplineID
        select @TemDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '9' and e.f_eventcode = '110' and e.f_sexcode = 1 and e.f_disciplineid = @DisciplineID
        IF @TemDisPos-@K1MMaxDisPos > @MaxDisPos
        BEGIN 
         SET @MaxDisPos = @TemDisPos-@K1MMaxDisPos
		END

        --//C1 Men
        select @C1MMaxDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '2' and e.f_eventcode = '210' and e.f_sexcode = 1 and e.f_disciplineid = @DisciplineID
        select @TemDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '9' and e.f_eventcode = '210' and e.f_sexcode = 1 and e.f_disciplineid = @DisciplineID
        IF @TemDisPos-@C1MMaxDisPos > @MaxDisPos
        BEGIN 
         SET @MaxDisPos = @TemDisPos-@C1MMaxDisPos
		END
		
        --//C2 Men
        select @C2MMaxDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '2' and e.f_eventcode = '220' and e.f_sexcode = 1 and e.f_disciplineid = @DisciplineID
        select @TemDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '9' and e.f_eventcode = '220' and e.f_sexcode = 1 and e.f_disciplineid = @DisciplineID
        IF @TemDisPos-@C2MMaxDisPos > @MaxDisPos
        BEGIN 
         SET @MaxDisPos = @TemDisPos-@C2MMaxDisPos
		END
	
        --//K1 Women
        select @K1WMaxDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '2' and e.f_eventcode = '110' and e.f_sexcode = 2 and e.f_disciplineid = @DisciplineID
        select @TemDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '9' and e.f_eventcode = '110' and e.f_sexcode = 2 and e.f_disciplineid = @DisciplineID
        IF @TemDisPos-@K1WMaxDisPos > @MaxDisPos
        BEGIN 
         SET @MaxDisPos = @TemDisPos-@K1WMaxDisPos
		END
		
		SET @i = 1
		WHILE @i <= @MaxDisPos
		BEGIN
			Insert #Tmp_Table([Tem_DisPos]) values(@i)

            --//K1 Men
            SET @Rank = NULL
            SET @NOCCode = NULL
            SET @Name = NULL
            SET @IRM = NULL
			SELECT @Rank = ER.F_EventRank, @NOCCode = D.F_DelegationCode, @Name = RD.F_LongName, 
			@IRM = (case when ER.F_IRMID IS NOT NULL then (nchar(10)+'('+ID.F_IRMShortName+')') else '' end)  
			FROM TS_Phase_Result AS PR 
			LEFT JOIN TS_Phase AS P ON PR.F_PhaseID = P.F_PhaseID 
			LEFT JOIN TS_Event AS E on P.F_EventID = E.F_EventID
			LEFT JOIN TS_Event_Result AS ER on E.F_EventID = ER.F_EventID AND PR.F_RegisterID = ER.F_RegisterID
			LEFT JOIN TR_Register AS R ON PR.F_RegisterID = R.F_RegisterID 
			LEFT JOIN TR_Register_Des AS RD ON PR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID 
			LEFT JOIN TC_IRM_Des AS ID ON ER.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = 'ENG'
			WHERE P.F_PhaseCode = '9' AND E.F_EventCode = '110' AND E.F_SexCode = 1 AND E.F_DisciplineID = @DisciplineID
			AND PR.F_PhaseDisplayPosition = @i+@K1MMaxDisPos
            update #Tmp_Table set [K1M_Rank]=@Rank,[K1M_NOCCode]=@NOCCode+@IRM,[K1M_Name]=@Name where [Tem_DisPos] = @i

            --//C1 Men
            SET @Rank = NULL
            SET @NOCCode = NULL
            SET @Name = NULL
            SET @IRM = NULL
			SELECT @Rank = ER.F_EventRank, @NOCCode = D.F_DelegationCode, @Name = RD.F_LongName, 
			@IRM = (case when ER.F_IRMID IS NOT NULL then (nchar(10)+'('+ID.F_IRMShortName+')') else '' end)  
			FROM TS_Phase_Result AS PR 
			LEFT JOIN TS_Phase AS P ON PR.F_PhaseID = P.F_PhaseID 
			LEFT JOIN TS_Event AS E on P.F_EventID = E.F_EventID
			LEFT JOIN TS_Event_Result AS ER on E.F_EventID = ER.F_EventID AND PR.F_RegisterID = ER.F_RegisterID			
			LEFT JOIN TR_Register AS R ON PR.F_RegisterID = R.F_RegisterID 
			LEFT JOIN TR_Register_Des AS RD ON PR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID 
			LEFT JOIN TC_IRM_Des AS ID ON ER.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = 'ENG'
			WHERE P.F_PhaseCode = '9' AND E.F_EventCode = '210' AND E.F_SexCode = 1 AND E.F_DisciplineID = @DisciplineID
			AND PR.F_PhaseDisplayPosition = @i+@C1MMaxDisPos
            update #Tmp_Table set [C1M_Rank]=@Rank,[C1M_NOCCode]=@NOCCode+@IRM,[C1M_Name]=@Name where [Tem_DisPos] = @i

            --//C2 Men
            SET @Rank = NULL
            SET @NOCCode = NULL
            SET @Name = NULL
            SET @IRM = NULL
			SELECT @Rank = ER.F_EventRank, @NOCCode = D.F_DelegationCode, @Name = (SELECT REPLACE(RD.F_LongName,'/',nchar(10))), 
			@IRM = (case when ER.F_IRMID IS NOT NULL then (nchar(10)+'('+ID.F_IRMShortName+')') else '' end)  
			FROM TS_Phase_Result AS PR 
			LEFT JOIN TS_Phase AS P ON PR.F_PhaseID = P.F_PhaseID 
			LEFT JOIN TS_Event AS E on P.F_EventID = E.F_EventID
			LEFT JOIN TS_Event_Result AS ER on E.F_EventID = ER.F_EventID AND PR.F_RegisterID = ER.F_RegisterID			
			LEFT JOIN TR_Register AS R ON PR.F_RegisterID = R.F_RegisterID 
			LEFT JOIN TR_Register_Des AS RD ON PR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID 
			LEFT JOIN TC_IRM_Des AS ID ON ER.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = 'ENG'
			WHERE P.F_PhaseCode = '9' AND E.F_EventCode = '220' AND E.F_SexCode = 1 AND E.F_DisciplineID = @DisciplineID
			AND PR.F_PhaseDisplayPosition = @i+@C2MMaxDisPos
            update #Tmp_Table set [C2M_Rank]=@Rank,[C2M_NOCCode]=@NOCCode+@IRM,[C2M_Name]=@Name where [Tem_DisPos] = @i

            --//K1 Women
            SET @Rank = NULL
            SET @NOCCode = NULL
            SET @Name = NULL
            SET @IRM = NULL
			SELECT @Rank = ER.F_EventRank, @NOCCode = D.F_DelegationCode, @Name = RD.F_LongName,
			@IRM = (case when ER.F_IRMID IS NOT NULL then (nchar(10)+'('+ID.F_IRMShortName+')') else '' end)  
			FROM TS_Phase_Result AS PR 
			LEFT JOIN TS_Phase AS P ON PR.F_PhaseID = P.F_PhaseID 
			LEFT JOIN TS_Event AS E on P.F_EventID = E.F_EventID
			LEFT JOIN TS_Event_Result AS ER on E.F_EventID = ER.F_EventID AND PR.F_RegisterID = ER.F_RegisterID			
			LEFT JOIN TR_Register AS R ON PR.F_RegisterID = R.F_RegisterID 
			LEFT JOIN TR_Register_Des AS RD ON PR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID 
			LEFT JOIN TC_IRM_Des AS ID ON ER.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = 'ENG'
			WHERE P.F_PhaseCode = '9' AND E.F_EventCode = '110' AND E.F_SexCode = 2 AND E.F_DisciplineID = @DisciplineID
			AND PR.F_PhaseDisplayPosition = @i+@K1WMaxDisPos
            update #Tmp_Table set [K1W_Rank]=@Rank,[K1W_NOCCode]=@NOCCode+@IRM,[K1W_Name]=@Name where [Tem_DisPos] = @i

			SET @i = @i + 1
		END
    END

    IF @PhaseCode = 2
    BEGIN
		SET @MaxDisPos = 0
		SET @TemDisPos = 0

        --//K1 Men
        select @K1MMaxDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '1' and e.f_eventcode = '110' and e.f_sexcode = 1 and e.f_disciplineid = @DisciplineID
        select @TemDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '2' and e.f_eventcode = '110' and e.f_sexcode = 1 and e.f_disciplineid = @DisciplineID
        IF @TemDisPos-@K1MMaxDisPos > @MaxDisPos
        BEGIN 
         SET @MaxDisPos = @TemDisPos-@K1MMaxDisPos
		END

        --//C1 Men
        select @C1MMaxDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '1' and e.f_eventcode = '210' and e.f_sexcode = 1 and e.f_disciplineid = @DisciplineID
        select @TemDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '2' and e.f_eventcode = '210' and e.f_sexcode = 1 and e.f_disciplineid = @DisciplineID
        IF @TemDisPos-@C1MMaxDisPos > @MaxDisPos
        BEGIN 
         SET @MaxDisPos = @TemDisPos-@C1MMaxDisPos
		END
		
        --//C2 Men
        select @C2MMaxDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '1' and e.f_eventcode = '220' and e.f_sexcode = 1 and e.f_disciplineid = @DisciplineID
        select @TemDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '2' and e.f_eventcode = '220' and e.f_sexcode = 1 and e.f_disciplineid = @DisciplineID
        IF @TemDisPos-@C2MMaxDisPos > @MaxDisPos
        BEGIN 
         SET @MaxDisPos = @TemDisPos-@C2MMaxDisPos
		END
	
        --//K1 Women
        select @K1WMaxDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '1' and e.f_eventcode = '110' and e.f_sexcode = 2 and e.f_disciplineid = @DisciplineID
        select @TemDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '2' and e.f_eventcode = '110' and e.f_sexcode = 2 and e.f_disciplineid = @DisciplineID
        IF @TemDisPos-@K1WMaxDisPos > @MaxDisPos
        BEGIN 
         SET @MaxDisPos = @TemDisPos-@K1WMaxDisPos
		END
		
		SET @i = 1
		WHILE @i <= @MaxDisPos
		BEGIN
			Insert #Tmp_Table([Tem_DisPos]) values(@i)

            --//K1 Men
            SET @Rank = NULL
            SET @NOCCode = NULL
            SET @Name = NULL
            SET @IRM = NULL
			SELECT @Rank = ER.F_EventRank, @NOCCode = D.F_DelegationCode, @Name = RD.F_LongName, 
			@IRM = (case when ER.F_IRMID IS NOT NULL then (nchar(10)+'('+ID.F_IRMShortName+')') else '' end)  
			FROM TS_Phase_Result AS PR 
			LEFT JOIN TS_Phase AS P ON PR.F_PhaseID = P.F_PhaseID 
			LEFT JOIN TS_Event AS E on P.F_EventID = E.F_EventID
			LEFT JOIN TS_Event_Result AS ER on E.F_EventID = ER.F_EventID AND PR.F_RegisterID = ER.F_RegisterID			
			LEFT JOIN TR_Register AS R ON PR.F_RegisterID = R.F_RegisterID 
			LEFT JOIN TR_Register_Des AS RD ON PR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID 
			LEFT JOIN TC_IRM_Des AS ID ON ER.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = 'ENG'
			WHERE P.F_PhaseCode = '2' AND E.F_EventCode = '110' AND E.F_SexCode = 1 AND E.F_DisciplineID = @DisciplineID
			AND PR.F_PhaseDisplayPosition = @i+@K1MMaxDisPos
            update #Tmp_Table set [K1M_Rank]=@Rank,[K1M_NOCCode]=@NOCCode+@IRM,[K1M_Name]=@Name where [Tem_DisPos] = @i

            --//C1 Men
            SET @Rank = NULL
            SET @NOCCode = NULL
            SET @Name = NULL
            SET @IRM = NULL
			SELECT @Rank = ER.F_EventRank, @NOCCode = D.F_DelegationCode, @Name = RD.F_LongName, 
			@IRM = (case when ER.F_IRMID IS NOT NULL then (nchar(10)+'('+ID.F_IRMShortName+')') else '' end)  
			FROM TS_Phase_Result AS PR 
			LEFT JOIN TS_Phase AS P ON PR.F_PhaseID = P.F_PhaseID 
			LEFT JOIN TS_Event AS E on P.F_EventID = E.F_EventID
			LEFT JOIN TS_Event_Result AS ER on E.F_EventID = ER.F_EventID AND PR.F_RegisterID = ER.F_RegisterID
			LEFT JOIN TR_Register AS R ON PR.F_RegisterID = R.F_RegisterID 
			LEFT JOIN TR_Register_Des AS RD ON PR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID 
			LEFT JOIN TC_IRM_Des AS ID ON ER.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = 'ENG'
			WHERE P.F_PhaseCode = '2' AND E.F_EventCode = '210' AND E.F_SexCode = 1 AND E.F_DisciplineID = @DisciplineID
			AND PR.F_PhaseDisplayPosition = @i+@C1MMaxDisPos
            update #Tmp_Table set [C1M_Rank]=@Rank,[C1M_NOCCode]=@NOCCode+@IRM,[C1M_Name]=@Name where [Tem_DisPos] = @i

            --//C2 Men
            SET @Rank = NULL
            SET @NOCCode = NULL
            SET @Name = NULL
            SET @IRM = NULL
			SELECT @Rank = ER.F_EventRank, @NOCCode = D.F_DelegationCode, @Name = (SELECT REPLACE(RD.F_LongName,'/',nchar(10))), 
			@IRM = (case when ER.F_IRMID IS NOT NULL then (nchar(10)+'('+ID.F_IRMShortName+')') else '' end)  
			FROM TS_Phase_Result AS PR 
			LEFT JOIN TS_Phase AS P ON PR.F_PhaseID = P.F_PhaseID 
			LEFT JOIN TS_Event AS E on P.F_EventID = E.F_EventID
			LEFT JOIN TS_Event_Result AS ER on E.F_EventID = ER.F_EventID AND PR.F_RegisterID = ER.F_RegisterID
			LEFT JOIN TR_Register AS R ON PR.F_RegisterID = R.F_RegisterID 
			LEFT JOIN TR_Register_Des AS RD ON PR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID 
			LEFT JOIN TC_IRM_Des AS ID ON ER.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = 'ENG'
			WHERE P.F_PhaseCode = '2' AND E.F_EventCode = '220' AND E.F_SexCode = 1 AND E.F_DisciplineID = @DisciplineID
			AND PR.F_PhaseDisplayPosition = @i+@C2MMaxDisPos
            update #Tmp_Table set [C2M_Rank]=@Rank,[C2M_NOCCode]=@NOCCode+@IRM,[C2M_Name]=@Name where [Tem_DisPos] = @i

            --//K1 Women
            SET @Rank = NULL
            SET @NOCCode = NULL
            SET @Name = NULL
            SET @IRM = NULL
			SELECT @Rank = ER.F_EventRank, @NOCCode = D.F_DelegationCode, @Name = RD.F_LongName,
			@IRM = (case when ER.F_IRMID IS NOT NULL then (nchar(10)+'('+ID.F_IRMShortName+')') else '' end)  
			FROM TS_Phase_Result AS PR 
			LEFT JOIN TS_Phase AS P ON PR.F_PhaseID = P.F_PhaseID 
			LEFT JOIN TS_Event AS E on P.F_EventID = E.F_EventID
			LEFT JOIN TS_Event_Result AS ER on E.F_EventID = ER.F_EventID AND PR.F_RegisterID = ER.F_RegisterID			
			LEFT JOIN TR_Register AS R ON PR.F_RegisterID = R.F_RegisterID 
			LEFT JOIN TR_Register_Des AS RD ON PR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID 
			LEFT JOIN TC_IRM_Des AS ID ON ER.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = 'ENG'
			WHERE P.F_PhaseCode = '2' AND E.F_EventCode = '110' AND E.F_SexCode = 2 AND E.F_DisciplineID = @DisciplineID
			AND PR.F_PhaseDisplayPosition = @i+@K1WMaxDisPos
            update #Tmp_Table set [K1W_Rank]=@Rank,[K1W_NOCCode]=@NOCCode+@IRM,[K1W_Name]=@Name where [Tem_DisPos] = @i

			SET @i = @i + 1
		END
    END

    IF @PhaseCode = 1
    BEGIN
		SET @MaxDisPos = 0
		SET @TemDisPos = 0

        --//K1 Men
        select @TemDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '1' and e.f_eventcode = '110' and e.f_sexcode = 1 and e.f_disciplineid = @DisciplineID
        IF @TemDisPos > @MaxDisPos
        BEGIN 
         SET @MaxDisPos = @TemDisPos
		END
 
        --//C1 Men
        select @TemDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '1' and e.f_eventcode = '210' and e.f_sexcode = 1 and e.f_disciplineid = @DisciplineID
        IF @TemDisPos > @MaxDisPos
        BEGIN 
         SET @MaxDisPos = @TemDisPos
		END

        --//C2 Men
        select @TemDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '1' and e.f_eventcode = '220' and e.f_sexcode = 1 and e.f_disciplineid = @DisciplineID
        IF @TemDisPos > @MaxDisPos
        BEGIN 
         SET @MaxDisPos = @TemDisPos
		END
	
        --//K1 Women
        select @TemDisPos = max(pr.f_phasedisplayposition) from ts_phase_result as pr
        left join ts_phase as p on pr.f_phaseid = p.f_phaseid
        left join ts_event as e on p.f_eventid = e.f_eventid
        where p.f_phasecode = '1' and e.f_eventcode = '110' and e.f_sexcode = 2 and e.f_disciplineid = @DisciplineID
        IF @TemDisPos > @MaxDisPos
        BEGIN 
         SET @MaxDisPos = @TemDisPos
		END
		
		SET @i = 1
		WHILE @i <= @MaxDisPos
		BEGIN
			Insert #Tmp_Table([Tem_DisPos]) values(@i)

            --//K1 Men
            SET @Rank = NULL
            SET @NOCCode = NULL
            SET @Name = NULL
            SET @IRM = NULL
			SELECT @Rank = ER.F_EventRank, @NOCCode = D.F_DelegationCode, @Name = RD.F_LongName, 
			@IRM = (case when ER.F_IRMID IS NOT NULL then (nchar(10)+'('+ID.F_IRMShortName+')') else '' end)  
			FROM TS_Phase_Result AS PR 
			LEFT JOIN TS_Phase AS P ON PR.F_PhaseID = P.F_PhaseID 
			LEFT JOIN TS_Event AS E on P.F_EventID = E.F_EventID
			LEFT JOIN TS_Event_Result AS ER on E.F_EventID = ER.F_EventID AND PR.F_RegisterID = ER.F_RegisterID
			LEFT JOIN TR_Register AS R ON PR.F_RegisterID = R.F_RegisterID 
			LEFT JOIN TR_Register_Des AS RD ON PR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID 
			LEFT JOIN TC_IRM_Des AS ID ON ER.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = 'ENG'
			WHERE P.F_PhaseCode = '1' AND E.F_EventCode = '110' AND E.F_SexCode = 1 AND E.F_DisciplineID = @DisciplineID
			AND PR.F_PhaseDisplayPosition = @i
            update #Tmp_Table set [K1M_Rank]=@Rank,[K1M_NOCCode]=@NOCCode+@IRM,[K1M_Name]=@Name where [Tem_DisPos] = @i

            --//C1 Men
            SET @Rank = NULL
            SET @NOCCode = NULL
            SET @Name = NULL
            SET @IRM = NULL
			SELECT @Rank = ER.F_EventRank, @NOCCode = D.F_DelegationCode, @Name = RD.F_LongName,
			@IRM = (case when ER.F_IRMID IS NOT NULL then (nchar(10)+'('+ID.F_IRMShortName+')') else '' end)   
			FROM TS_Phase_Result AS PR 
			LEFT JOIN TS_Phase AS P ON PR.F_PhaseID = P.F_PhaseID 
			LEFT JOIN TS_Event AS E on P.F_EventID = E.F_EventID
			LEFT JOIN TS_Event_Result AS ER on E.F_EventID = ER.F_EventID AND PR.F_RegisterID = ER.F_RegisterID			
			LEFT JOIN TR_Register AS R ON PR.F_RegisterID = R.F_RegisterID 
			LEFT JOIN TR_Register_Des AS RD ON PR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID 
			LEFT JOIN TC_IRM_Des AS ID ON ER.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = 'ENG'
			WHERE P.F_PhaseCode = '1' AND E.F_EventCode = '210' AND E.F_SexCode = 1 AND E.F_DisciplineID = @DisciplineID
			AND PR.F_PhaseDisplayPosition = @i
            update #Tmp_Table set [C1M_Rank]=@Rank,[C1M_NOCCode]=@NOCCode+@IRM,[C1M_Name]=@Name where [Tem_DisPos] = @i

            --//C2 Men
            SET @Rank = NULL
            SET @NOCCode = NULL
            SET @Name = NULL
            SET @IRM = NULL
			SELECT @Rank = ER.F_EventRank, @NOCCode = D.F_DelegationCode, @Name = (SELECT REPLACE(RD.F_LongName,'/',nchar(10))),
			@IRM = (case when ER.F_IRMID IS NOT NULL then (nchar(10)+'('+ID.F_IRMShortName+')') else '' end)  
			FROM TS_Phase_Result AS PR 
			LEFT JOIN TS_Phase AS P ON PR.F_PhaseID = P.F_PhaseID 
			LEFT JOIN TS_Event AS E on P.F_EventID = E.F_EventID
			LEFT JOIN TS_Event_Result AS ER on E.F_EventID = ER.F_EventID AND PR.F_RegisterID = ER.F_RegisterID			
			LEFT JOIN TR_Register AS R ON PR.F_RegisterID = R.F_RegisterID 
			LEFT JOIN TR_Register_Des AS RD ON PR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID 
			LEFT JOIN TC_IRM_Des AS ID ON ER.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = 'ENG'
			WHERE P.F_PhaseCode = '1' AND E.F_EventCode = '220' AND E.F_SexCode = 1 AND E.F_DisciplineID = @DisciplineID
			AND PR.F_PhaseDisplayPosition = @i
            update #Tmp_Table set [C2M_Rank]=@Rank,[C2M_NOCCode]=@NOCCode+@IRM,[C2M_Name]=@Name where [Tem_DisPos] = @i

            --//K1 Women
            SET @Rank = NULL
            SET @NOCCode = NULL
            SET @Name = NULL
            SET @IRM = NULL
			SELECT @Rank = ER.F_EventRank, @NOCCode = D.F_DelegationCode, @Name = RD.F_LongName,
			@IRM = (case when ER.F_IRMID IS NOT NULL then (nchar(10)+'('+ID.F_IRMShortName+')') else '' end)  
			FROM TS_Phase_Result AS PR 
			LEFT JOIN TS_Phase AS P ON PR.F_PhaseID = P.F_PhaseID 
			LEFT JOIN TS_Event AS E on P.F_EventID = E.F_EventID
			LEFT JOIN TS_Event_Result AS ER on E.F_EventID = ER.F_EventID AND PR.F_RegisterID = ER.F_RegisterID
			LEFT JOIN TR_Register AS R ON PR.F_RegisterID = R.F_RegisterID 
			LEFT JOIN TR_Register_Des AS RD ON PR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode 
			LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
			LEFT JOIN TC_IRM_Des AS ID ON ER.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = 'ENG'
			WHERE P.F_PhaseCode = '1' AND E.F_EventCode = '110' AND E.F_SexCode = 2 AND E.F_DisciplineID = @DisciplineID
			AND PR.F_PhaseDisplayPosition = @i
            update #Tmp_Table set [K1W_Rank]=@Rank,[K1W_NOCCode]=@NOCCode+@IRM,[K1W_Name]=@Name where [Tem_DisPos] = @i

			SET @i = @i + 1
		END
    END

	--ALTER TABLE #Tmp_Table  DROP COLUMN [Tem_DisPos]

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	
GO
	
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*

-- Just for test
EXEC [Proc_Report_SL_GetCompetitionSummary] 67,'eng',1
EXEC [Proc_Report_SL_GetCompetitionSummary] 67,'eng',2
EXEC [Proc_Report_SL_GetCompetitionSummary] 67,'eng',9
*/

