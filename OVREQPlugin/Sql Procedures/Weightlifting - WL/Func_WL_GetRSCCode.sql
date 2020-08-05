IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_WL_GetRSCCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].Func_WL_GetRSCCode
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----��    ��: [Func_WL_GetRSCCode]
----��    ��: ������Ŀ�����ȡ RSC Code, �� DISCIPLINE(2), SEX(1), EVENT(3), PHASE(1), Match(2) 9λ�������������ַ���. 
----����˵��: 
----˵    ��: 
----�� �� ��: �޿�	
----��   �ڣ�2012��09��12��

/*
	����˵����
	���	��������	����˵��
	1		@DisciplineID	��Ӧ�����ID  
	2		@LanguageCode
						չ�����ݵ�ָ������

*/

/*
	����������Infoϵͳ��ȡ���¼ƻ�Э��XML����
*/

/*
	�޸ļ�¼��
	���	����			�޸���		�޸�����
	1		2012-09-12		�޿�		�޸����������� 
*/



CREATE FUNCTION [dbo].[Func_WL_GetRSCCode]
(
	@DisciplineID					INT,
	@EventID						INT,
	@PhaseID						INT,
	@MatchID						INT 
)
RETURNS NVARCHAR(30)
AS
BEGIN 

	DECLARE @KEY		NVARCHAR(30)
	
	DECLARE @DisciplineCode			CHAR(2)
	DECLARE @Gender					CHAR(1)
	DECLARE @EventCode				CHAR(3)
	DECLARE @Phase					CHAR(1)
	DECLARE @EventUnit				CHAR(2) 
	DECLARE @MatchDate				DATETIME
	DECLARE @Date					NVARCHAR(20)
	
	SET @DisciplineCode = '00'
	SET @Gender = '0'
	SET @EventCode = '000'
	SET @Phase = '0'
	SET @EventUnit = '00'
	SET @KEY = N''
	SET @Date = N''
	SELECT @MatchDate= A.F_MatchDate FROM TS_Match AS A 
        LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_Event AS D ON B.F_EventID = D.F_EventID 
        WHERE D.F_EventID = @EventID AND A.F_MatchCode !='QR'
	
	------------------------------------------------------------------------------------------------------
	-- �� @DisciplineID, @EventID, @PhaseID, @MatchID ����Ԥ����
	------------------------------------------------------------------------------------------------------
	IF @MatchID > 0
		SELECT @PhaseID = M.F_PhaseID FROM TS_Match AS M WHERE M.F_MatchID = @MatchID
	
	IF @PhaseID > 0
		SELECT @EventID = P.F_EventID FROM TS_Phase AS P WHERE P.F_PhaseID = @PhaseID
	
	IF @EventID > 0
		SELECT @DisciplineID = E.F_DisciplineID FROM TS_Event AS E WHERE E.F_EventID = @EventID
	
	IF @DisciplineID = -1
		SELECT @DisciplineID = D.F_DisciplineID FROM TS_Discipline AS D WHERE D.F_Active = 1
		
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
	
	SELECT @EventUnit = RIGHT('00' + M.F_MatchCode, 2)
	FROM TS_Match AS M
	WHERE M.F_MatchID = @MatchID
	
	------------------------------------------------------------------------------------------------------
	-- ��ȡ RSC Code + '.'
	------------------------------------------------------------------------------------------------------
	SET @KEY = @DisciplineCode + @Gender + @EventCode + @Phase + @EventUnit
		
	RETURN @KEY
 
END

/*

-- Just for test
EXEC [Func_WL_GetRSCCode] NULL, NULL, NULL, NULL, NULL, NULL, N'ALL'
EXEC [Func_WL_GetRSCCode] 1, 1, 1, 1, 1, NULL, N'C73A'

*/
GO


