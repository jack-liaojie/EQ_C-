IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_info_Schedule_units]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_info_Schedule_units]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[proc_info_Schedule_units]
----��		  �ܣ�ΪInfoϵͳ���񣬻�ȡSchedule
----��		  �ߣ���ѧ�� 
----��		  ��: 2009-11-10 
----�� ��  �� ¼��
/*			
	ʱ��				�޸���		�޸�����
	2009-11-28			�����		�� REGISTER_A �� Score ��Ϊʤ�ߵ������ͱȷ�, ���ڶԿ�����Ŀ����Ҫ�޸�;
									������ Code �����ɹ���ȥ��
	2009-11-30			�����		ȡ�����ݼ�, ȥ���ֶ� UNIT_HAS_MEDALS
	2010-02-09			֣����		��POOLCODE��A��B��C��ת��Ϊ 01, 02, 03
	2010-04-08			֣����		���ֶԿ�����Ŀ�;�������Ŀ���������Ŀ,�Կ�����Ŀ��Ҫ���RegisterA��RegisterB
	2010-04-29			֣����		�����ĳ���ΪDisciplineCode+N'M',����ΪNULL
	2010-05-09			֣����		��Event_Unit��Ϊ��λ
	2010-05-12			֣����		�����ݸ���Ϊ�����ĳ��ݵ�CODE
	2010-06-29			֣����		����������뼶��
	2010-8-12			֣����		MAIN_NORDER��Ϊ��NULL��
	2010-8-30			֣����		MAIN_NORDER��TIME_ORDER��Ϊ0��
	2010-9-10			֣����		MATCH_NUMӦ��ȡOVRϵͳ�е�RaceNumber,�������RaceNumberΪ�վͲ�Ҫչ�ִ˱���
	2010-9-21			֣����		REGISTER_A��������⣬���ھ��������Ŀ��REGISTER_AӦ���Ǳ���������ʤ�ߣ����Ǳ���û�н����������Ӧ�ý�REGISTER_A��Ϊ�գ�ͬʱScoreҲӦ��Ϊ�ա�
	2010-9-21			֣����		MATCH_NUMӦ��ȡOVRϵͳ�е�RaceNumber,�������RaceNumberΪ����ʱҲչ�ִ˱���������
*/

CREATE PROCEDURE [dbo].[proc_info_Schedule_units]
	@DisciplineCode			CHAR(2)
AS
BEGIN

SET NOCOUNT ON
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	CREATE TABLE #table_tmp(
		[KEY]				NCHAR(17),
		DISCIPLINE			NCHAR(2),
		SEX					NCHAR(1),
		[EVENT]				NCHAR(3),		
		EVENT_PARENT		NCHAR(3),
		PHASE				NCHAR(1),
		[POOL]				NCHAR(2),
		EVENT_UNIT			NCHAR(5),
		[START_DATE]		DATETIME,
		START_TIME			DATETIME,
		END_DATE			DATETIME,
		END_TIME			DATETIME,
		TIME_COMMENT		NVARCHAR(150),
		[STATUS]			TINYINT,
		MATCH_NUM			SMALLINT,
		VENUE				NCHAR(3),
		COURT				SMALLINT,
		SCORE				Nvarchar(350),
		NO_LANG_DESC		Nvarchar(50),
		REGISTER_A			INT,
		EXTRA_INFO_A		Nvarchar(150),
		AFTER_INFO_A		Nvarchar(150),
		REGISTER_B			INT,
		EXTRA_INFO_B		Nvarchar(150),
		AFTER_INFO_B		Nvarchar(150),
		REGISTER_C			INT,
		EXTRA_INFO_C		Nvarchar(150),
		AFTER_INFO_C		Nvarchar(150),
		REGISTER_D			INT,
		EXTRA_INFO_D		Nvarchar(150),
		AFTER_INFO_D		Nvarchar(150),
		IS_DOUBLES_MATCH	TINYINT,
		MAIN_ORDER			INT,
		TIME_ORDER			INT,
		SHOW_UNIT			TINYINT,
		UNIT_HAS_MEDALS		TINYINT,
		MATCH_ID			INT,
		PHASE_ID			INT,
		FATHER_PHASE_ID		INT,
		IS_POOL				INT
	)

	INSERT INTO #table_tmp(DISCIPLINE, SEX, [EVENT], EVENT_PARENT, PHASE, 
							[START_DATE], START_TIME, END_DATE, END_TIME,
							MATCH_NUM, VENUE, COURT, PHASE_ID, MATCH_ID, IS_POOL,
							[STATUS], EVENT_UNIT, UNIT_HAS_MEDALS, IS_DOUBLES_MATCH, 
							SCORE, REGISTER_A, REGISTER_B)
	SELECT	CAST(A.F_DisciplineCode AS NCHAR(2)), CAST(C.F_GenderCode AS NCHAR(1)), CAST(B.F_EventCode AS NCHAR(3)), CAST(B.F_EventCode AS NCHAR(3)), CAST(D.F_PhaseCode AS NCHAR(1)), 
		E.F_MatchDate,  E.F_StartTime,	E.F_MatchDate,	E.F_EndTime,
		E.F_RaceNum , F.F_VenueCode, NULL,--�����ĳ���ΪDisciplineCode+N'M',����ΪNULL
		E.F_PhaseId,
		E.F_MATCHID, 
		D.F_PhaseIsPool,
		E.F_MatchStatusId,
		RIGHT('00000'+ RTRIM(LTRIM(E.F_MatchCode)), 5),
		E.F_MatchHasMedal,
		(CASE WHEN B.F_PlayerRegTypeID=2 THEN 1 -- F_PlayerRegTypeID = 2 is double
		ELSE 0	END) AS IS_DOUBLES_MATCH,
		(
			CASE B.F_CompetitionTypeID WHEN 1 THEN --head-to-head
				(SELECT TOP 1 N'*<ps>' + cast(X.F_Points as Nvarchar(350)) + N':' + cast(Y.F_Points as Nvarchar(350)) + N'</ps>'
				FROM TS_Match_Result AS X
				LEFT JOIN TS_Match_Result AS Y
					ON X.F_MatchID = Y.F_MatchID 
				WHERE X.F_MatchID = E.F_MatchID AND X.F_CompetitionPositionDes1 = 1 AND Y.F_CompetitionPositionDes1 = 2 )
			WHEN 2 THEN --������
				(SELECT TOP 1 N'*<ps>' + cast(X.F_PointsCharDes1 as Nvarchar(350)) + N'</ps>'
				FROM TS_Match_Result AS X
				WHERE X.F_MatchID = E.F_MatchID
					AND X.F_Rank = 1 AND E.F_MatchStatusID = 110)
			WHEN 3 THEN --Performance
				(SELECT TOP 1 N'*<ps>' + cast(X.F_PointsCharDes1 as Nvarchar(350)) + N'</ps>'
				FROM TS_Match_Result AS X
				WHERE X.F_MatchID = E.F_MatchID
					AND X.F_Rank = 1 AND E.F_MatchStatusID = 110)
			ELSE NULL END
		) AS SCORE,
		(	
			CASE  B.F_CompetitionTypeID WHEN 1 THEN --head-to-head
				(SELECT TOP 1 Y.F_RegisterCode
				FROM TS_Match_Result AS X
				LEFT JOIN TR_Register AS Y
					ON X.F_RegisterID = Y.F_RegisterID
				WHERE X.F_MatchID = E.F_MatchID
					AND X.F_CompetitionPositionDes1 = 1)
			WHEN 2 THEN --������ 
				(SELECT TOP 1 Y.F_RegisterCode
				FROM TS_Match_Result AS X
				LEFT JOIN TR_Register AS Y
					ON X.F_RegisterID = Y.F_RegisterID
				WHERE X.F_MatchID = E.F_MatchID
					AND X.F_Rank = 1 AND E.F_MatchStatusID = 110)
			WHEN 3 THEN --Performance
				(SELECT TOP 1 Y.F_RegisterCode
				FROM TS_Match_Result AS X
				LEFT JOIN TR_Register AS Y
					ON X.F_RegisterID = Y.F_RegisterID
				WHERE X.F_MatchID = E.F_MatchID
					AND X.F_Rank = 1 AND E.F_MatchStatusID = 110)
			ELSE NULL END
		) AS REGISTER_A,
		(	
			CASE  B.F_CompetitionTypeID WHEN 1 THEN --head-to-head
				(SELECT TOP 1 Y.F_RegisterCode
				FROM TS_Match_Result AS X
				LEFT JOIN TR_Register AS Y
					ON X.F_RegisterID = Y.F_RegisterID
				WHERE X.F_MatchID = E.F_MatchID
					AND X.F_CompetitionPositionDes1 = 2)
			ELSE NULL END
		) AS REGISTER_B
	FROM TS_Discipline AS A 
		INNER JOIN TS_Event AS B ON A.F_DisciplineID = B.F_DisciplineID 
		INNER JOIN TS_PHASE AS D ON B.F_EventID = D.F_EventID
		INNER JOIN TS_Match AS E ON D.F_PhaseID = E.F_PhaseID
		LEFT JOIN TC_Sex AS C ON B.F_SexCode = C.F_SexCode
		LEFT JOIN TC_Venue AS F ON E.F_VenueID = F.F_VenueID
		WHERE A.F_DisciplineCode = @DisciplineCode


--	UPDATE #table_tmp SET VENUE = DISCIPLINE + 'M'
	UPDATE #table_tmp SET SHOW_UNIT = 1
	UPDATE #table_tmp SET FATHER_PHASE_ID = F_FatherPhaseID FROM  #table_tmp AS A LEFT JOIN TS_Phase AS B ON A.PHASE_ID = B.F_PhaseID WHERE A.IS_POOL = 1
	UPDATE #table_tmp SET FATHER_PHASE_ID = PHASE_ID WHERE IS_POOL = 1 AND (FATHER_PHASE_ID = 0 OR FATHER_PHASE_ID IS NULL)
	UPDATE #table_tmp SET PHASE = left(B.F_PhaseCode,1) FROM  #table_tmp AS A LEFT JOIN TS_Phase AS B ON A.FATHER_PHASE_ID = B.F_PhaseID WHERE A.IS_POOL = 1
	UPDATE #table_tmp SET POOL = cast(ltrim(B.F_PhaseCode) as nchar(2)) FROM  #table_tmp AS A LEFT JOIN TS_Phase AS B ON A.PHASE_ID = B.F_PhaseID WHERE A.IS_POOL = 1
	UPDATE #table_tmp SET POOL = (CASE POOL WHEN 'A' THEN '01' WHEN 'B' THEN '02' WHEN 'C' THEN '03' WHEN 'D' THEN '04' WHEN 'E' THEN '05' WHEN 'F' THEN '06' ELSE '00' END) WHERE IS_POOL = 1
	UPDATE #table_tmp SET POOL = '00' WHERE IS_POOL = 0
	UPDATE #table_tmp SET [STATUS] = 10 WHERE [STATUS] IS NULL OR [STATUS] = 0
	UPDATE #table_tmp SET MAIN_ORDER = 0, TIME_ORDER = 0

	UPDATE #table_tmp SET [KEY] = DISCIPLINE + SEX + [EVENT] + EVENT_PARENT + PHASE + POOL + EVENT_UNIT
	
	SELECT 		[KEY],
		DISCIPLINE,
		SEX,
		[EVENT],		
		EVENT_PARENT,
		PHASE,
		[POOL],
		EVENT_UNIT,
		[START_DATE],
		START_TIME,
		END_DATE,
		END_TIME,
		TIME_COMMENT,
		[STATUS],
		MATCH_NUM,
		VENUE,
		COURT,
		SCORE,
		NO_LANG_DESC,
		REGISTER_A,
		EXTRA_INFO_A,
		AFTER_INFO_A,
		REGISTER_B,
		EXTRA_INFO_B,
		AFTER_INFO_B,
		REGISTER_C,
		EXTRA_INFO_C,
		AFTER_INFO_C,
		REGISTER_D,
		EXTRA_INFO_D,
		AFTER_INFO_D,
		IS_DOUBLES_MATCH,
		MAIN_ORDER,
		TIME_ORDER,
		SHOW_UNIT,
		UNIT_HAS_MEDALS
	FROM #table_tmp 

SET NOCOUNT OFF
END

GO


/*

EXEC proc_info_Schedule_units 'SQ'
EXEC proc_info_Schedule_units 'SP'

*/