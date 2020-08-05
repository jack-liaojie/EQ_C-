IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_OutPutEventResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_OutPutEventResult]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----��   �ƣ�[Proc_Info_OutPutEventResult]
----��   �ܣ������Ŀ���ι���
----��	 �ߣ�֣����
----��   �ڣ�2010-08-20 

/*
	����˵����
	���	��������	����˵��
	1		@EventID	ָ���ı�����ĿID
*/

/*
	�������������ս���Э��淶����֯���ݡ�
			  �˴洢���������ڲ���MS SQL SERVER����淶��
			  
*/

/*
�޸ļ�¼��
	���	����			�޸���		�޸�����
	1						

*/

CREATE PROCEDURE [dbo].[Proc_Info_OutPutEventResult](
				 @EventID			INT,
                 @LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	DECLARE @DisciplineCode AS NVARCHAR(50)
	
	SET @LanguageCode = ISNULL( @LanguageCode, 'CHN')
	SELECT @DisciplineCode = F_DisciplineCode FROM TS_Event AS A LEFT JOIN TS_Discipline AS B ON A.F_DisciplineID = B.F_DisciplineID
			WHERE A.F_EventID = @EventID

	DECLARE @PlayerRegTypeID     INT
    DECLARE @SexCode             INT
    DECLARE @EventID_S           NVARCHAR(20)
    DECLARE @EventID_D           NVARCHAR(20)
    SELECT @PlayerRegTypeID = F_PlayerRegTypeID, @SexCode = F_SexCode FROM TS_Event WHERE F_EventID = @EventID

    CREATE TABLE #Temp_EventRank(
                             [Rank]                NVARCHAR(10),
                             [Medal]               NVARCHAR(50),
                             [MemberName]          NVARCHAR(100),
                             [MemberOrder]         INT,
                             [NOCCode]             NVARCHAR(50),
                             [NOCLongName]         NVARCHAR(100),
                             F_RegisterID          INT,
                             F_MemberRegisterID    INT,
                             F_DisplayPos          INT,
							 F_RegisterCode		   NVARCHAR(100),
							 F_MemberRegisterCode  NVARCHAR(100),
							 F_ResultCreateDate	   DATETIME,
							 F_ResultDate		   NVARCHAR(100),
							 F_RealMemberOrder	   INT
                             )
                             
    IF(@PlayerRegTypeID = 1)
    BEGIN
        INSERT INTO #Temp_EventRank([Rank], [Medal],[MemberName], [MemberOrder], [NOCCode], [NOCLongName], F_DisplayPos, F_RegisterID, F_RegisterCode, F_MemberRegisterID, F_MemberRegisterCode, F_ResultCreateDate)
		  SELECT A.F_EventRank, B.F_MedalLongName, D.F_PrintLongName, 0, TD.F_DelegationCode, E.F_DelegationLongName
		   , A.F_EventDisplayPosition, A.F_RegisterID, C.F_RegisterCode, A.F_RegisterID, C.F_RegisterCode, A.F_ResultCreateDate
			FROM TS_Event_Result AS A
			LEFT JOIN TC_Medal_Des AS B ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
			LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID
			LEFT JOIN TR_Register_Des AS D ON A.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS TD ON C.F_DelegationID = TD.F_DelegationID
			LEFT JOIN TC_Delegation_Des AS E ON TD.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
			WHERE A.F_EventRank IS NOT NULL AND A.F_EventID = @EventID
	END
	ELSE IF(@PlayerRegTypeID = 2 OR @PlayerRegTypeID = 3)
	 BEGIN
	    INSERT INTO #Temp_EventRank([Rank], [Medal],[MemberName], [MemberOrder], [NOCCode], [NOCLongName],  F_RegisterID, F_DisplayPos, F_MemberRegisterID, F_RegisterCode, F_MemberRegisterCode, F_ResultCreateDate)
		 SELECT A.F_EventRank, B.F_MedalLongName, D.F_PrintLongName, RM.F_Order, TD.F_DelegationCode, E.F_DelegationLongName, A.F_RegisterID
		        , A.F_EventDisplayPosition, RM.F_MemberRegisterID, C.F_RegisterCode, R.F_RegisterCode, A.F_ResultCreateDate
			FROM TS_Event_Result AS A
			LEFT JOIN TC_Medal_Des AS B ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
			LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID
			LEFT JOIN TR_Register_Member AS RM ON C.F_RegisterID = RM.F_RegisterID
			LEFT JOIN TR_Register AS R ON RM.F_MemberRegisterID = R.F_RegisterID 
			LEFT JOIN TR_Register_Des AS D ON R.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS TD ON C.F_DelegationID = TD.F_DelegationID
			LEFT JOIN TC_Delegation_Des AS E ON TD.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
			WHERE A.F_EventRank IS NOT NULL AND R.F_RegTypeID = 1 AND A.F_EventID = @EventID
	END
	

	DECLARE @EventCode AS NVARCHAR(100)
	SELECT @EventCode = B.F_DisciplineCode + C.F_GenderCode + A.F_EventCode FROM TS_Event AS A LEFT JOIN TS_Discipline AS B ON A.F_DisciplineID = B.F_DisciplineID LEFT JOIN TC_Sex AS C ON A.F_SexCode = C.F_SexCode
	UPDATE #Temp_EventRank SET F_ResultDate = ISNULL(REPLACE(REPLACE(LEFT(CONVERT(NVARCHAR(MAX), F_ResultCreateDate, 120 ), 16), '-', '') , ' ', ''), N'')

	UPDATE A SET F_RealMemberOrder = B.F_RealMemberOrder FROM #Temp_EventRank AS A LEFT JOIN
		(
			SELECT ROW_NUMBER() OVER (PARTITION BY [RANK] ORDER BY MemberOrder) AS F_RealMemberOrder, [RANK], F_RegisterID, F_MemberRegisterID FROM #Temp_EventRank
		)
		AS B
		ON A.[Rank] = B.[Rank] AND A.F_RegisterID = B.F_RegisterID AND A.F_MemberRegisterID = B.F_MemberRegisterID

	UPDATE #Temp_EventRank SET [Rank] = N'' WHERE F_RealMemberOrder != 1

	SELECT [Rank] AS ����, F_MemberRegisterCode AS ע���, [MemberName] AS ������
		, N'' AS ������, ISNULL(@EventCode, N'') AS ��������
		, NOCCode AS �����Ŵ���, NOCLongName AS �����ż��
		, N'' AS �ɼ�, F_DisplayPos AS ����
		, F_ResultDate AS ����ʱ��, N'' ��¼����, N'' �Ƽ�¼״̬, N'' ��ע 
		FROM #Temp_EventRank ORDER BY F_DisplayPos, MemberOrder

	RETURN

Set NOCOUNT OFF
End	
GO
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO
