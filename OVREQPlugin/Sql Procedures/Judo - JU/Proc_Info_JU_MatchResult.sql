IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_JU_MatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_JU_MatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----名   称：[Proc_Info_JU_MatchResult]
----功   能：比赛成绩、单场或者多场
----作	 者：宁顺泽
----日   期：2012-08-20 

/*
	参数说明：
	序号	参数名称	参数说明
	1		@MatchID	指定的比赛ID
*/

/*
	功能描述：按照交换协议规范，组织数据。
			  此存储过程遵照内部的MS SQL SERVER编码规范。
			  
*/

/*
修改记录：
	序号	日期			修改者		修改内容
	1						

*/

CREATE PROCEDURE [dbo].[Proc_Info_JU_MatchResult]
		@MatchID			AS INT
AS
BEGIN
	
SET NOCOUNT ON

    DECLARE @Discipline AS NVARCHAR(50)
    DECLARE @Gender AS NVARCHAR(50)
    DECLARE @SexCode AS INT
    DECLARE @Event AS NVARCHAR(50)
    DECLARE @EventName AS NVARCHAR(50)
    DECLARE @EventID AS INT
    DECLARE @Phase AS NVARCHAR(50)
    DECLARE @Unit AS NVARCHAR(50)
    DECLARE @Vunue AS NVARCHAR(50)
	DECLARE @LanguageCode AS CHAR(3)
	Declare @GameTime as nvarchar(100)
	
	Declare @FOrder  as nvarchar(10)
	DECLARE @MatchStatus    INT
	DECLARE @CriticalPoint  INT
	DECLARE @CriticalPos    INT
	DECLARE @ServePos       INT
	
	SELECT @Discipline = D.F_DisciplineCode, @SexCode = E.F_SexCode, @Event = E.F_EventCode, @EventID = E.F_EventID
	, @Phase = P.F_PhaseCode, @Unit = M.F_MatchCode, @Vunue = V.F_VenueCode, @MatchStatus = M.F_MatchStatusID,
	@FOrder=convert(nvarchar(10),m.F_Order),@GameTime=isnull(F_MatchComment4,N'')
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Phase_Des as PD ON P.F_PhaseID=PD.F_PhaseID and PD.F_LanguageCode=@LanguageCode
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	LEFT JOIN TC_Venue AS V ON M.F_VenueID = V.F_VenueID
	WHERE F_MatchID = @MatchID
	
	SELECT @Gender = F_GenderCode FROM TC_Sex WHERE F_SexCode = @SexCode
	
	SET @LanguageCode = ISNULL( @LanguageCode, 'CHN')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

	DECLARE @Content AS NVARCHAR(MAX)
	
	
	
	-----对阵数据
	CREATE TABLE #tmp_Duel(	
								Match				  NVARCHAR(100),
								DelegationName_B	  NVARCHAR(100),
								AthleteName_B		  NVARCHAR(100),
								DelegationName_W	  NVARCHAR(100),
								AthleteName_W	      NVARCHAR(100),
								GameTime			  nvarchar(100),
								Result 				  NVARCHAR(100),
								Winner				  NVARCHAR(100),
								[Status]			  NVARCHAR(100)
							)
							
	insert into #tmp_Duel(Match,DelegationName_B,
							AthleteName_B,DelegationName_W,
							AthleteName_W,GameTime,
							Result,Winner,[Status])
	select 
		PD.F_PhaseLongName+N'第'+convert(nvarchar(10),m.F_Order)+N'场',
		DD1.F_DelegationLongName,
		Rd1.F_LongName,
		DD2.F_DelegationLongName,
		Rd2.F_LongName,
		@GameTime,
		CONVERT(NVARCHAR(10), ISNULL(MR1.F_PointsNumDes1, 0))
		+ CONVERT(NVARCHAR(10), ISNULL(MR1.F_PointsNumDes2, 0))
		+ CONVERT(NVARCHAR(10), ISNULL(MR1.F_PointsNumDes3, 0))
		+N'/'
		+CONVERT(NVARCHAR(10), ISNULL(MR2.F_PointsNumDes1, 0))
		+ CONVERT(NVARCHAR(10), ISNULL(MR2.F_PointsNumDes2, 0))
		+ CONVERT(NVARCHAR(10), ISNULL(MR2.F_PointsNumDes3, 0)),
		case WHEN Mr1.F_ResultID = 1 THEN RD1.F_LongName
		     when Mr2.F_ResultID = 1 THEN RD2.F_LongName 
		end,
		SD2.F_StatusLongName	 
	from TS_Match as M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Phase_Des as PD ON P.F_PhaseID=PD.F_PhaseID and PD.F_LanguageCode=@LanguageCode
	LEFT JOIN TS_Match_Result as MR1
		ON MR1.F_CompetitionPosition=1 and m.F_MatchID=mr1.F_MatchID
	LEFT JOIN TR_Register as R1
		ON R1.F_RegisterID=Mr1.F_RegisterID
	LEFT JOIN TR_Register_Des as RD1
		ON R1.F_RegisterID=RD1.F_RegisterID and RD1.F_LanguageCode=@LanguageCode
	LEFT JOIN TC_Delegation as D1
		ON D1.F_DelegationID=R1.F_DelegationID
	LEFt JOIN TC_Delegation_Des as DD1
		on D1.F_DelegationID=DD1.F_DelegationID and DD1.F_LanguageCode=@LanguageCode
	LEFT JOIn TS_Match_Result as MR2
		ON MR2.F_CompetitionPosition=2 and M.F_MatchID=mr2.F_MatchID
	LEFT JOIN TR_Register as R2
		ON MR2.F_RegisterID=R2.F_RegisterID
	LEFT JOIN TR_Register_Des as RD2
		ON R2.F_RegisterID=RD2.F_RegisterID and RD2.F_LanguageCode=@LanguageCode
	LEFT JOIN TC_Delegation as D2
		ON R2.F_DelegationID=D2.F_DelegationID
	LEFT JOIN TC_Delegation_Des as DD2
		ON D2.F_DelegationID=DD2.F_DelegationID and DD2.F_LanguageCode=@LanguageCode
	LEFT JOIN TC_Status_Des as SD2
		ON SD2.F_StatusID=M.F_MatchStatusID and SD2.F_LanguageCode=@LanguageCode
	where m.F_MatchID=@MatchID	and ISNULL(mr1.f_registerID,-1)<>-1 and ISNULL(MR2.f_registerID,-1)<>-1

	SET		@Content = (SELECT [Row].[Match],  [Row].[DelegationName_B], [Row].[AthleteName_B]
							, [Row].[DelegationName_W], [Row].[AthleteName_W], [Row].[GameTime], [Row].[Result], [Row].[Winner], [Row].[Status]
						FROM #tmp_Duel AS [Row]  FOR XML AUTO)

   --SELECT cast( @Content AS XML )
	
	IF @LanguageCode = 'CHN'
	BEGIN
		SET @LanguageCode = 'CHI'
	END

	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N' Language = "' + @LanguageCode + '"'
							+N' Date ="'+ REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(LEFT(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), 5), ':', ''), '.', '')+'"'

	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Content
					+ N'
						</Message>'

	DECLARE @FileName	AS NVARCHAR(100)
	SET @FileName =	@Discipline + @Gender + @Event + N'000' + N'.C71.CHI.1.0'
		
	SELECT @OutputXML AS OutputXML, @FileName AS [FileName]
	RETURN

SET NOCOUNT OFF
END





GO


