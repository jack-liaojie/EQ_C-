IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_info_Schedule_unit_results]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_info_Schedule_unit_results]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_info_Schedule_unit_results]
----功		  能：为Info系统服务
----作		  者：穆学峰 
----日		  期: 2009-11-10 
----修 改  记 录：
		/*			
					时间				修改人		修改内容
					2009-11-28			邓年彩		将 REGISTER 复制到 REGISTER_A 中, 对于对抗性项目还需要修改
					2010-02-09			郑金勇		将POOLCODE由A、B、C、转化为 01, 02, 03
					2010-04-08			郑金勇		区分对抗类项目和竞技类项目、打分类项目,对抗类项目需要填充RegisterA和RegisterB
					2010-05-10			郑金勇		所有项目都要有Register这一列
					2010-06-29			郑金勇		降低事务隔离级别
					2010-08-12			郑金勇		竞技类和打分类项目的RegisterA要添其本身的Register
					2010-9-20			郑金勇		MATCH_NUM应该取OVR系统中的RaceNumber，暂时没有针对MATCH_NUM是否为空进行过滤！（以往提的要求是没有MATCH_NUM的比赛成绩应该不展现）
		*/

CREATE PROCEDURE [dbo].[proc_info_Schedule_unit_results]
	@DisciplineCode			CHAR(2)
AS
BEGIN
	
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	CREATE TABLE #table_tmp(
						[KEY]				nchar(27),
						DISCIPLINE			Nchar(2),
						SEX					Nchar(1),
						[EVENT]				Nchar(3),
						EVENT_PARENT		Nchar(3),
						PHASE				Nchar(1),
						POOL				Nchar(2),
						EVENT_UNIT			Nchar(5),
						REGISTER			INT,
						SCORE				Nvarchar(350),
						REGISTER_A			INT,
						EXTRA_INFO_A		Nvarchar(150),
						AFTER_INFO_A		Nvarchar(150),
						REGISTER_B			INT,
						EXTRA_INFO_B		Nvarchar(150),
						AFTER_INFO_B		Nvarchar(150),
						REGISTER_C			INT,
						REGISTER_D			INT,
						IS_DOUBLES_MATCH	tinyint,
						SHOW_UNIT			tinyint,
						UNIT_HAS_MEDALS		tinyint,
						MATCH_ID			INT,
						PHASE_ID			INT,
						FATHER_PHASE_ID		INT,
						IS_POOL				INT,
						F_MatchID			INT,
						F_CompetitionTypeID INT

	)
--竞技类\ Performance
	INSERT INTO #table_tmp(DISCIPLINE, SEX, [EVENT], EVENT_PARENT, PHASE, EVENT_UNIT,
							REGISTER, MATCH_ID, SCORE, REGISTER_A,
							PHASE_ID, FATHER_PHASE_ID, IS_POOL, IS_DOUBLES_MATCH, F_MatchID, F_CompetitionTypeID)
	SELECT	CAST(A.F_DisciplineCode AS NCHAR(2)), 
			CAST(C.F_GenderCode AS NCHAR(1)), 
			CAST(B.F_EventCode AS NCHAR(3)), 
			CAST(B.F_EventCode AS NCHAR(3)), 
			CAST(D.F_PhaseCode AS NCHAR(1)),
			Right('00000' + E.F_MatchCode, 5),
		 I.F_RegisterCode,
		 E.F_MATCHID, 
		N'*<ps>' + cast(H.F_PointsCharDes1 as Nvarchar(350)) + N'</ps>',
--		(SELECT TOP 1 Y.F_RegisterCode
--			FROM TS_Match_Result AS X
--			LEFT JOIN TR_Register AS Y
--				ON X.F_RegisterID = Y.F_RegisterID
--			WHERE X.F_MatchID = E.F_MatchID
--				AND X.F_Rank = 1),
		I.F_RegisterCode,
		E.F_PhaseID,
		D.F_FatherPhaseId,
		D.F_PhaseIsPool,
		temp = CASE
		WHEN B.F_PlayerRegTypeID=2 THEN 1 -- F_PlayerRegTypeID = 2 is double
		ELSE 0
		END,
		E.F_MatchID,
		B.F_CompetitionTypeID
	FROM TS_Discipline AS A 
		INNER JOIN TS_Event AS B ON A.F_DisciplineID = B.F_DisciplineID 
		INNER JOIN TS_PHASE AS D ON B.F_EventID = D.F_EventID
		INNER JOIN TS_Match AS E ON D.F_PhaseID = E.F_PhaseID
		LEFT JOIN TC_VENUE AS F ON E.F_VenueID = F.F_VenueID
		LEFT JOIN TC_Court AS G ON G.F_CourtID = E.F_CourtID
		LEFT JOIN TS_MATCH_RESULT AS H ON H.F_MatchID = E.F_MatchID
		LEFT JOIN TR_Register AS I ON I.F_RegisterId = H.F_RegisterID
		LEFT JOIN TC_Sex AS C ON B.F_SexCode = C.F_SexCode
		WHERE A.F_DisciplineCode = @DisciplineCode
			AND H.F_RegisterID > -1 
			AND H.F_RegisterID IS NOT NULL AND B.F_CompetitionTypeID IN (2, 3)
--			AND E.F_RaceNum IS NOT NULL AND E.F_RaceNum <> ''

	--UPDATE #table_tmp SET REGISTER_A = C.F_RegisterCode FROM #table_tmp AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID
	--	LEFT JOIN TR_Register AS C ON B.F_RegisterId = C.F_RegisterId WHERE A.F_CompetitionTypeID IN (2, 3) AND B.F_Rank = 1
			
--Head to Head
	INSERT INTO #table_tmp(DISCIPLINE, SEX, [EVENT], EVENT_PARENT, PHASE, EVENT_UNIT,
							REGISTER, MATCH_ID, SCORE, REGISTER_A, REGISTER_B,
							PHASE_ID, FATHER_PHASE_ID, IS_POOL, IS_DOUBLES_MATCH, F_MatchID, F_CompetitionTypeID)
	SELECT	CAST(A.F_DisciplineCode AS NCHAR(2)), 
			CAST(C.F_GenderCode AS NCHAR(1)), 
			CAST(B.F_EventCode AS NCHAR(3)), 
			CAST(B.F_EventCode AS NCHAR(3)), 
			CAST(D.F_PhaseCode AS NCHAR(1)),
			Right('00000' + E.F_MatchCode, 5),
		 I.F_RegisterCode,
		 E.F_MATCHID, 
		 (SELECT TOP 1 N'*<ps>' + cast(X.F_Points as Nvarchar(350)) + N':' + cast(Y.F_Points as Nvarchar(350)) + N'</ps>'
				FROM TS_Match_Result AS X
				LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID 
				WHERE X.F_MatchID = E.F_MatchID AND X.F_CompetitionPositionDes1 = 1 AND Y.F_CompetitionPositionDes1 = 2 ),
--		(SELECT TOP 1 Y.F_RegisterCode
--			FROM TS_Match_Result AS X
--			LEFT JOIN TR_Register AS Y
--				ON X.F_RegisterID = Y.F_RegisterID
--			WHERE X.F_MatchID = E.F_MatchID
--				AND X.F_CompetitionPositionDes1 = 1),
--		(SELECT TOP 1 Y.F_RegisterCode
--			FROM TS_Match_Result AS X
--			LEFT JOIN TR_Register AS Y
--				ON X.F_RegisterID = Y.F_RegisterID
--			WHERE X.F_MatchID = E.F_MatchID
--				AND X.F_CompetitionPositionDes1 = 2),
		NULL,
		NULL,
		E.F_PhaseID,
		D.F_FatherPhaseId,
		D.F_PhaseIsPool,
		(CASE
		WHEN B.F_PlayerRegTypeID=2 THEN 1 -- F_PlayerRegTypeID = 2 is double
			ELSE 0 END) AS IS_DOUBLES_MATCH,
		E.F_MatchID,
		B.F_CompetitionTypeID
	FROM TS_Discipline AS A 
		INNER JOIN TS_Event AS B ON A.F_DisciplineID = B.F_DisciplineID 
		INNER JOIN TS_PHASE AS D ON B.F_EventID = D.F_EventID
		INNER JOIN TS_Match AS E ON D.F_PhaseID = E.F_PhaseID
		LEFT JOIN TC_VENUE AS F ON E.F_VenueID = F.F_VenueID
		LEFT JOIN TC_Court AS G ON G.F_CourtID = E.F_CourtID
		LEFT JOIN TS_MATCH_RESULT AS H ON H.F_MatchID = E.F_MatchID
		LEFT JOIN TR_Register AS I ON I.F_RegisterId = H.F_RegisterID
		LEFT JOIN TC_Sex AS C ON B.F_SexCode = C.F_SexCode
		WHERE A.F_DisciplineCode = @DisciplineCode 
			 AND H.F_RegisterID > -1 AND H.F_RegisterID IS NOT NULL
			 AND B.F_CompetitionTypeID = 1
--		     AND E.F_RaceNum IS NOT NULL AND E.F_RaceNum <> ''

	UPDATE #table_tmp SET REGISTER_A = C.F_RegisterCode FROM #table_tmp AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID
		LEFT JOIN TR_Register AS C ON B.F_RegisterId = C.F_RegisterId WHERE A.F_CompetitionTypeID = 1 AND B.F_CompetitionPositionDes1 = 1

	UPDATE #table_tmp SET REGISTER_B = C.F_RegisterCode FROM #table_tmp AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID
		LEFT JOIN TR_Register AS C ON B.F_RegisterId = C.F_RegisterId WHERE A.F_CompetitionTypeID = 1 AND B.F_CompetitionPositionDes1 = 2

	UPDATE #table_tmp SET FATHER_PHASE_ID = F_FatherPhaseID FROM  #table_tmp AS A LEFT JOIN TS_Phase AS B ON A.PHASE_ID = B.F_PhaseID WHERE A.IS_POOL = 1
	UPDATE #table_tmp SET FATHER_PHASE_ID = PHASE_ID WHERE IS_POOL = 1 AND (FATHER_PHASE_ID = 0 OR FATHER_PHASE_ID IS NULL)
	UPDATE #table_tmp SET PHASE = left(B.F_PhaseCode,1) FROM  #table_tmp AS A LEFT JOIN TS_Phase AS B ON A.FATHER_PHASE_ID = B.F_PhaseID WHERE A.IS_POOL = 1
	UPDATE #table_tmp SET POOL = cast(ltrim(B.F_PhaseCode) as nchar(2)) FROM  #table_tmp AS A LEFT JOIN TS_Phase AS B ON A.PHASE_ID = B.F_PhaseID WHERE A.IS_POOL = 1
	UPDATE #table_tmp SET POOL = (CASE POOL WHEN 'A' THEN '01' WHEN 'B' THEN '02' WHEN 'C' THEN '03' WHEN 'D' THEN '04' WHEN 'E' THEN '05' WHEN 'F' THEN '06' ELSE '00' END) WHERE IS_POOL = 1
	UPDATE #table_tmp SET POOL = '00' WHERE IS_POOL = 0

	UPDATE #table_tmp SET SHOW_UNIT = 1
	UPDATE #table_tmp SET [KEY] = DISCIPLINE + SEX + [EVENT] + EVENT_PARENT + PHASE + POOL + EVENT_UNIT + Right('0000000000' + CAST( REGISTER AS NVARCHAR(50)), 10)

	SELECT	[KEY],
			DISCIPLINE,
			SEX,
			[EVENT],
			EVENT_PARENT,
			PHASE,
			POOL,
			EVENT_UNIT,
			REGISTER,
			SCORE,
			REGISTER_A,
			EXTRA_INFO_A,
			AFTER_INFO_A,
			REGISTER_B,
			EXTRA_INFO_B,
			AFTER_INFO_B,
			REGISTER_C,
			REGISTER_D,
			IS_DOUBLES_MATCH,
			SHOW_UNIT
 FROM #table_tmp ORDER BY F_MatchID

SET NOCOUNT OFF
END


GO