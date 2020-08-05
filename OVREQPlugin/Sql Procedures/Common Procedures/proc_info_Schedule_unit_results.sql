IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_info_Schedule_unit_results]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_info_Schedule_unit_results]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[proc_info_Schedule_unit_results]
----��		  �ܣ�ΪInfoϵͳ����
----��		  �ߣ���ѧ�� 
----��		  ��: 2009-11-10 
----�� ��  �� ¼��
		/*			
					ʱ��				�޸���		�޸�����
					2009-11-28			�����		�� REGISTER ���Ƶ� REGISTER_A ��, ���ڶԿ�����Ŀ����Ҫ�޸�
					2010-02-09			֣����		��POOLCODE��A��B��C��ת��Ϊ 01, 02, 03
					2010-04-08			֣����		���ֶԿ�����Ŀ�;�������Ŀ���������Ŀ,�Կ�����Ŀ��Ҫ���RegisterA��RegisterB
					2010-05-10			֣����		������Ŀ��Ҫ��Register��һ��
					2010-06-29			֣����		����������뼶��
					2010-08-12			֣����		������ʹ������Ŀ��RegisterAҪ���䱾���Register
					2010-9-20			֣����		MATCH_NUMӦ��ȡOVRϵͳ�е�RaceNumber����ʱû�����MATCH_NUM�Ƿ�Ϊ�ս��й��ˣ����������Ҫ����û��MATCH_NUM�ı����ɼ�Ӧ�ò�չ�֣�
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
--������\ Performance
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