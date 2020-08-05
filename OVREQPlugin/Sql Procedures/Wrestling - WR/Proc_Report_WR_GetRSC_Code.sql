IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WR_GetRSC_Code]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WR_GetRSC_Code]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Report_WR_GetRSC_Code]
--��    ��: ����Ŀ�����ȡ RSC Code, �� DISCIPLINE(2), SEX(1), EVENT(3), EVENT_PARENT(3), PHASE(1), POOL(2), EVENT_UNIT(5) �������������ַ���. 
--�� �� ��: �����
--��    ��: 2010��9��15�� ������
--�޸ļ�¼��
/*			
	ʱ��					�޸���		�޸�����
	2010��10��28�� ������	�����		�� ReportType Ϊ C51B ʱ, �� EventID Ϊ׼; �������ı���� ReportType; ��� X98, X99.
	2011��1��13�� ������	��˳��		��ʽ�� "DDSEEEEEEFPPUUUUU.(����)" ��Ϊ DDSEEEFUU.

*/



CREATE PROCEDURE [dbo].[Proc_Report_WR_GetRSC_Code]
	@DisciplineID					INT,
	@EventID						INT,
	@PhaseID						INT,
	@MatchID						INT,
	@DateID							INT,
	@SessionID						INT,
	@ReportType						NVARCHAR(20),
	@DelegationID					INT = -1
AS
BEGIN
SET NOCOUNT ON

	DECLARE @DisciplineCode			CHAR(2)
	DECLARE @Gender					CHAR(1)
	DECLARE @EventCode				CHAR(3)
	DECLARE @Phase					CHAR(1)
	DECLARE @EventUnit				CHAR(2)
	DECLARE @KEY					NVARCHAR(50)
	
	SET @DisciplineCode = '00'
	SET @Gender = '0'
	SET @EventCode = '000'
	SET @Phase = '0'
	SET @EventUnit = '00'
	SET @KEY = N''
	
	------------------------------------------------------------------------------------------------------
	-- �� @DisciplineID, @EventID, @PhaseID, @MatchID ����Ԥ����
	------------------------------------------------------------------------------------------------------
	IF @ReportType <> N'C51B' AND @ReportType <> N'Z51B'
	BEGIN
		IF @MatchID > 0
			SELECT @PhaseID = M.F_PhaseID FROM TS_Match AS M WHERE M.F_MatchID = @MatchID
		
		IF @PhaseID > 0
			SELECT @EventID = P.F_EventID FROM TS_Phase AS P WHERE P.F_PhaseID = @PhaseID
	END
	
	IF @EventID > 0
		SELECT @DisciplineID = E.F_DisciplineID FROM TS_Event AS E WHERE E.F_EventID = @EventID
	
	IF @DisciplineID = -1
		SELECT @DisciplineID = D.F_DisciplineID FROM TS_Discipline AS D WHERE D.F_Active = 1
	
	------------------------------------------------------------------------------------------------------
	-- ���� @ReportType ���� @DisciplineID, @EventID, @PhaseID, @MatchID
	------------------------------------------------------------------------------------------------------
	/* Judo - JU (���) ���豨��
		(1)	C08 - Competition Schedule
		(2)	C30 - Number of Entries by NOC
		(3) C32A - Entry List by NOC
		(4) C32C - Entry List by Weight Category
		(5) C38 - Entry Data Checklist
		(6) C39 - Entry Data Checklist - Competition Officials
		(7) C51A - Contest List(without contest number)
		(8) C51B - Contest List(with contest number)
		(9) C56 - Weigh-in List(media release)
		(10) C58 - Contest Order
		(11) C67 - Official Communication
		(12) C71 - Contest Results
		(13) C75 - Contest List
		(14) C92A - Medallists
		(15) C93 - Medallists by Event
		(16) C95 - Medal Standings
		(17) C96 - Top 8
		(18) X98 - Good Morning
		(19) X99 - Good Night
	*/
	
	-- ���� @DisciplineID ��Ч
	-- (1) C08 - Competition Schedule, (2) C30 - Number of Entries by NOC, (3) C32A - Entry List by NOC,
	-- (5) C38 - Entry Data Checklist, (6) C39 - Entry Data Checklist - Competition Officials
	-- (10) C58 - Contest Order, (11) C67 - Official Communication, 
	-- (15) C93 - Medallists by Event, (16) C95 - Medal Standings,
	-- (18) X98 - Good Morning, (19) X99 - Good Night
	IF @ReportType = N'C08' OR @ReportType = N'C30' OR @ReportType = N'C32A' 
		OR @ReportType = N'C38' OR @ReportType = N'C39' 
		OR @ReportType = N'C58' OR @ReportType = N'C67' 
		OR @ReportType = N'C93' OR @ReportType = N'C95'
		OR @ReportType = N'Z08' OR @ReportType = N'Z30' OR @ReportType = N'Z32A' 
		OR @ReportType = N'Z38' OR @ReportType = N'Z39' 
		OR @ReportType = N'Z58' OR @ReportType = N'Z67' 
		OR @ReportType = N'Z93' OR @ReportType = N'Z95'
		OR @ReportType = N'X98' OR @ReportType = N'X99'
	BEGIN
		SET @EventID = NULL
		SET @PhaseID = NULL
		SET @MatchID = NULL
	END	
	
	-- ���� @DisciplineID, @EventID ��Ч
	-- (4) C32C - Entry List by Event, (7) C51A - Contest List(without contest number), 
	-- (8) C51B - Contest List(with contest number), (9) C56 - Weigh-in List(media release), 
	-- (13) C75 - Contest List, (14) C92A - Medallsits (Individual), (17) C96 - Top 8
	ELSE IF @ReportType = N'C32C' OR @ReportType = N'C51A' 
		OR @ReportType = N'C51B' OR @ReportType = N'C56' 
		OR @ReportType = N'C75' OR @ReportType = N'C92A' OR @ReportType = N'C96'
		OR @ReportType = N'Z32C' OR @ReportType = N'Z51A' 
		OR @ReportType = N'Z51B' OR @ReportType = N'Z56' 
		OR @ReportType = N'Z75' OR @ReportType = N'Z92A' OR @ReportType = N'Z96'
	BEGIN
		SET @PhaseID = NULL
		SET @MatchID = NULL
	END
	
	------------------------------------------------------------------------------------------------------
	-- ��ȡ @DisciplineCode(2), @Gender(1), @EventCode(3), @Phase(1), @EventUnit(2)
	------------------------------------------------------------------------------------------------------
	SELECT @DisciplineCode = RIGHT(D.F_DisciplineCode, 2)
	FROM TS_Discipline AS D
	WHERE D.F_DisciplineID = @DisciplineID
	
	SELECT @Gender = RIGHT(S.F_GenderCode, 1)
		, @EventCode = RIGHT(E.F_EventCode, 3)
	FROM TS_Event AS E
	LEFT JOIN TC_Sex AS S
		ON E.F_SexCode = S.F_SexCode
	WHERE E.F_EventID = @EventID
	
	SELECT @Phase = RIGHT(P.F_PhaseCode, 1)
	FROM TS_Phase AS P
	WHERE P.F_PhaseID = @PhaseID
	
	--SELECT @EventUnit = RIGHT('00000' + M.F_MatchCode, 5)
	SELECT @EventUnit = RTRIM(RIGHT('0' + M.F_MatchCode, 2))
	FROM TS_Match AS M
	WHERE M.F_MatchID = @MatchID
	
	------------------------------------------------------------------------------------------------------
	-- ��ȡ RSC Code + '.'
	------------------------------------------------------------------------------------------------------
	SET @KEY = @DisciplineCode + @Gender + @EventCode + @Phase + @EventUnit 
	
	------------------------------------------------------------------------------------------------------
	-- ��ȡ��ز���
	------------------------------------------------------------------------------------------------------
	IF (@ReportType = N'C32A' OR @ReportType = N'C38'
		OR @ReportType = N'Z32A' OR @ReportType = N'Z38') 
		AND @DelegationID <> -1
	BEGIN
		SELECT @KEY = @KEY + N'C_' + D.F_DelegationCode
		FROM TC_Delegation AS D
		WHERE D.F_DelegationID = @DelegationID
	END
	------------------------------------------------------------------------------------------------------
	-- �������ݼ�
	------------------------------------------------------------------------------------------------------
	SELECT RTRIM(@KEY) AS [KEY]

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetRSC_Code] -1, -1, -1, 2, -1, -1, N'C32A'
EXEC [Proc_Report_JU_GetRSC_Code] 62, NULL, NULL, NULL, NULL, NULL, N'C32A'

*/