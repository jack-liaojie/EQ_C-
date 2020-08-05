
IF ( OBJECT_ID('func_VB_GetAge') IS NOT NULL )
DROP Function [func_VB_GetAge]
GO

IF ( OBJECT_ID('func_VB_GetDateTimeStr') IS NOT NULL )
DROP Function [func_VB_GetDateTimeStr]
GO

IF ( OBJECT_ID('func_VB_GetFormatTimeStr') IS NOT NULL )
DROP Function [func_VB_GetFormatTimeStr]
GO

IF ( OBJECT_ID('func_VB_GetHeightDes') IS NOT NULL )
DROP Function [func_VB_GetHeightDes]
GO

IF ( OBJECT_ID('func_VB_GetMatchResultByRegAB') IS NOT NULL )
DROP Function [func_VB_GetMatchResultByRegAB]
GO

IF ( OBJECT_ID('func_VB_GetMatchResultIRM') IS NOT NULL )
DROP Function [func_VB_GetMatchResultIRM]
GO

IF ( OBJECT_ID('func_VB_GetPercentStr') IS NOT NULL )
DROP Function [func_VB_GetPercentStr]
GO

IF ( OBJECT_ID('func_VB_GetPositionChangeUp') IS NOT NULL )
DROP Function [func_VB_GetPositionChangeUp]
GO

IF ( OBJECT_ID('func_VB_GetPositionLineUp') IS NOT NULL )
DROP Function [func_VB_GetPositionLineUp]
GO

IF ( OBJECT_ID('func_VB_GetRegisterWinLostInGroup') IS NOT NULL )
DROP Function [func_VB_GetRegisterWinLostInGroup]
GO

IF ( OBJECT_ID('func_VB_GetRscCode') IS NOT NULL )
DROP Function [func_VB_GetRscCode]
GO

IF ( OBJECT_ID('func_VB_GetScoreFromStat') IS NOT NULL )
DROP Function [func_VB_GetScoreFromStat]
GO

IF ( OBJECT_ID('func_VB_GetStatValue') IS NOT NULL )
DROP Function [func_VB_GetStatValue]
GO

IF ( OBJECT_ID('func_VB_GetStatValueByStatCode') IS NOT NULL )
DROP Function [func_VB_GetStatValueByStatCode]
GO

IF ( OBJECT_ID('func_VB_GetWeightDes') IS NOT NULL )
DROP Function [func_VB_GetWeightDes]
GO

IF ( OBJECT_ID('func_VB_GetZeroValue') IS NOT NULL )
DROP Function [func_VB_GetZeroValue]
GO

IF ( OBJECT_ID('func_VB_IsActionInPlayByPlay') IS NOT NULL )
DROP Function [func_VB_IsActionInPlayByPlay]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/************************func_VB_GetAge Start************************/GO


--��ȡ׼ȷ����
CREATE FUNCTION [dbo].[func_VB_GetAge]
(
	@BirthDay		DATETIME
)

RETURNS INT
AS
BEGIN
	DECLARE @Now DATETIME = GETDATE()
	DECLARE @ResultVar AS INT
	
	      Declare @Age int, @year int, @month int, @Day int
        Set @age   = 0
        Set @year  = 0
        Set @month = 0
        Set @day   = 0
        Set @year  = DatePart(Year,@Now) - DatePart(Year, @BirthDay)
        Set @month = DatePart(Month,@Now) - DatePart(Month, @BirthDay)
        Set @Day   = DatePart(Day,@Now) - DatePart(Day, @BirthDay)
        if( @month > 0)
                Set @Age = @Year
        if( @month < 0)
                Set @Age = @Year - 1
        if(@month = 0)
                Begin
                        if( @Day > 0)
                                Set @Age = @Year
                        Else
                                Set @Age = @Year -1
                End
        Return(@Age)

END














GO
/************************func_VB_GetAge OVER*************************/


/************************func_VB_GetDateTimeStr Start************************/GO


--���ظ���ʱ����ʽ

-- ���ر�׼
-- 1: MON 27 SEP 2010 16:39
-- 2: MON 27 SEP 2010
-- 3: 16:39
-- 4: 27 SEP 2010
-- 5: MON 27 SEP
-- 6: 27 SEP 2010
-- 7: 2010-07-27
-- 8: 20 Aug
-- 9: 10��3��
--10: 2010-07-27 12:55

--11: TUE
--12: ���ڶ�

--13: 20120910	Date
--14: 1038		Time
	
--2012-09-05	��������
--2012-09-10	Add @hh 13,14
CREATE FUNCTION [dbo].[func_VB_GetDateTimeStr]
(
	@DataTime	DATETIME, 
	@Type		int
)
RETURNS NvarCHAR(30)
AS
BEGIN

	--New
	DECLARE @ResultVar		NVARCHAR(100)
				
	DECLARE @D				NVARCHAR(100)	--1		1��	
	DECLARE @DD				NVARCHAR(100)	--01	1��
	DECLARE @M				NVARCHAR(100)	--1		1��			
	DECLARE @MM				NVARCHAR(100)	--01	1��		
	DECLARE @MM_E			NVARCHAR(100)	--JAN
	DECLARE @MMM_E			NVARCHAR(100)	--January
	
	DECLARE @YYYY			NVARCHAR(100)	--2012	��
	DECLARE @W				NVARCHAR(100)	--1		������
	DECLARE @WWW_C			NVARCHAR(100)	--������
	DECLARE @WW_E			NVARCHAR(100)	--SUN
	DECLARE @WWW_E			NVARCHAR(100)	--Monday	
	DECLARE @H				NVARCHAR(100)	--1		һ��
	DECLARE @HH				NVARCHAR(100)	--01	һ��
	DECLARE @NN				NVARCHAR(100)	--14	14��
	
	SET @D		= DATEPART(d,	@DataTime)										
	SET @DD		= RIGHT(N'00' + CONVERT(NVARCHAR(2), DATEPART(d, @DataTime)), 2)
	
	SET @M		= DATEPART(m,	@DataTime)
	SET @MM		= RIGHT(N'00' + CONVERT(NVARCHAR(2), DATEPART(m, @DataTime)), 2)
	
	SET @YYYY	= DATEPART(yy,	@DataTime)
	SET @W		= DATEPART(dw,	@DataTime)
	SET @H		= DATEPART(hh,	@DataTime)
	SET @HH		= RIGHT(N'00' + CONVERT(NVARCHAR(2), DATEPART(hh, @DataTime)), 2)
	SET @NN		= RIGHT(N'00' + CONVERT(NVARCHAR(2), DATEPART(n, @DataTime)), 2)

	--Week
	IF @W = N'1'		SET @WWW_C = N'������'
	IF @W = N'2'		SET @WWW_C = N'����һ'
	IF @W = N'3'		SET @WWW_C = N'���ڶ�'
	IF @W = N'4'		SET @WWW_C = N'������'
	IF @W = N'5'		SET @WWW_C = N'������'
	IF @W = N'6'		SET @WWW_C = N'������'
	IF @W = N'7'		SET @WWW_C = N'������'
	
	IF @W = N'1'		SET @WW_E = N'SUN'
	IF @W = N'2'		SET @WW_E = N'MON'
	IF @W = N'3'		SET @WW_E = N'TUE'
	IF @W = N'4'		SET @WW_E = N'WED'
	IF @W = N'5'		SET @WW_E = N'THU'
	IF @W = N'6'		SET @WW_E = N'FRI'
	IF @W = N'7'		SET @WW_E = N'SAT'
	
	IF @W = N'1'		SET @WWW_E = N'Sunday'
	IF @W = N'2'		SET @WWW_E = N'Monday'
	IF @W = N'3'		SET @WWW_E = N'Tuesday'
	IF @W = N'4'		SET @WWW_E = N'Wednesday'
	IF @W = N'5'		SET @WWW_E = N'Thursday'
	IF @W = N'6'		SET @WWW_E = N'Friday'
	IF @W = N'7'		SET @WWW_E = N'Saturday'
	
	--Month
	IF @M = N'1'		SET @MM_E = N'JAN'
	IF @M = N'2'		SET @MM_E = N'FEB'
	IF @M = N'3'		SET @MM_E = N'MAR'
	IF @M = N'4'		SET @MM_E = N'APR'
	IF @M = N'5'		SET @MM_E = N'MAY'
	IF @M = N'6'		SET @MM_E = N'JUN'
	IF @M = N'7'		SET @MM_E = N'JUL'
	IF @M = N'8'		SET @MM_E = N'AUG'
	IF @M = N'9'		SET @MM_E = N'SEP'
	IF @M = N'10'		SET @MM_E = N'OCT'
	IF @M = N'11'		SET @MM_E = N'NOV'
	IF @M = N'12'		SET @MM_E = N'DEC'
	
	IF @M = N'1'		SET @MMM_E = N'January'
	IF @M = N'2'		SET @MMM_E = N'February'
	IF @M = N'3'		SET @MMM_E = N'March'
	IF @M = N'4'		SET @MMM_E = N'April'
	IF @M = N'5'		SET @MMM_E = N'May'
	IF @M = N'6'		SET @MMM_E = N'June'
	IF @M = N'7'		SET @MMM_E = N'July'
	IF @M = N'8'		SET @MMM_E = N'August'
	IF @M = N'9'		SET @MMM_E = N'September'
	IF @M = N'10'		SET @MMM_E = N'October'
	IF @M = N'11'		SET @MMM_E = N'November'
	IF @M = N'12'		SET @MMM_E = N'December'
	--New

	IF		@Type = 1
		SELECT @ResultVar = @WW_E + ' ' + @D + ' ' + @MM_E + ' ' + @YYYY + ' ' + @H + ':' + @NN

	ELSE IF @Type = 2
		SELECT @ResultVar = @WW_E + ' ' + @D + ' ' + @MM_E + ' '	+ @YYYY

	ELSE IF @Type = 3
		SELECT @ResultVar = @H + ':' + @NN

	ELSE IF @Type = 4
		SELECT @ResultVar =  @D + ' ' + @MM_E + ' ' + @YYYY

	ELSE IF @Type = 5
		SELECT @ResultVar = @WW_E + ' ' + @D + ' ' + @MM_E 

	ELSE IF @Type = 6
		SELECT @ResultVar = @D + ' ' + @MM_E + ' ' + @YYYY

	ELSE IF @Type = 7
		SELECT @ResultVar = @YYYY + '-' + @MM + '-'+ @DD
		
	ELSE IF @Type = 8
		SELECT @ResultVar = @D + ' ' + @MM_E

	ELSE IF @Type = 9
		SELECT @ResultVar = @M + '��' + @D + '��'

	ELSE IF @Type = 10
		SELECT @ResultVar = @YYYY + '-' + @MM + '-'+ @DD + ' ' + @H + ':' + @NN
	
	ELSE IF @Type = 11
		SELECT @ResultVar = @WW_E
	
	ELSE IF @Type = 12
		SELECT @ResultVar = @WWW_C
	
	ELSE IF @Type = 13
		SELECT @ResultVar = @YYYY+@MM+@DD

	ELSE IF @Type = 14
		SELECT @ResultVar = @HH + @NN
	
	
	SET @ResultVar = RTRIM(LTRIM(@ResultVar))
	RETURN @ResultVar
	
END


/*
go 
select dbo.[func_VB_GetDateTimeStr](GETDATE(), 3)
*/


GO
/************************func_VB_GetDateTimeStr OVER*************************/


/************************func_VB_GetFormatTimeStr Start************************/GO


-- =============================================
-- Author:		����
-- Create date: 2010/12/16
-- Description:	����Ϊ��
-- 1: 3h2m3s, 3Сʱ2����1�� 
-- 2: 3:02:01
-- =============================================

-- 2011-01-30 ����NULL��0
CREATE FUNCTION [dbo].[func_VB_GetFormatTimeStr]
								(
									@SpendTimeINT   INT,
									@Type			INT,
									@LanguageCode   CHAR(3)
								)
RETURNS NVARCHAR(10)
AS
BEGIN
	IF ( @SpendTimeINT IS NULL )
	RETURN NULL
		
    DECLARE @TimeCHAR AS NVARCHAR(10)
    SET @TimeCHAR = ''

	DECLARE @Hour AS INT
	DECLARE @Minute AS INT
	DECLARE @Second AS INT
	
	SET @Hour = @SpendTimeINT / 3600
	SET @Minute = (@SpendTimeINT - @Hour * 3600) / 60
	SET @Second = (@SpendTimeINT - @Hour * 3600) % 60
	
	IF( @Type = 1 )
	BEGIN
			IF @LanguageCode = 'ENG'
			BEGIN
			  SET @TimeCHAR = (CASE WHEN @Hour <> 0 THEN CAST(@Hour AS NVARCHAR(2)) + 'h' ELSE '' END) + 
				(CASE WHEN @Minute <> 0 THEN CAST(@Minute AS NVARCHAR(2)) + 'm' ELSE '' END) + 
				(CASE WHEN @Second <> 0 THEN CAST(@Second AS NVARCHAR(2)) + 's' ELSE '' END)
			END
			ELSE IF @LanguageCode = 'CHN'
			BEGIN
			  SET @TimeCHAR = (CASE WHEN @Hour <> 0 THEN CAST(@Hour AS NVARCHAR(2)) + 'Сʱ' ELSE '' END) + 
				(CASE WHEN @Minute <> 0 THEN CAST(@Minute AS NVARCHAR(2)) + '��' ELSE '' END) + 
				(CASE WHEN @Second <> 0 THEN CAST(@Second AS NVARCHAR(2)) + '��' ELSE '' END)
			END
			
			IF ( @TimeCHAR = '' )
			BEGIN
				SET @TimeCHAR = '0'
			END

	END
	ELSE
	IF ( @Type = 2 )
	BEGIN
			 SET @TimeCHAR = CAST(@Hour AS NVARCHAR(2)) + ':' + 
				CASE WHEN @Minute < 10 THEN '0' ELSE '' END + CAST(@Minute AS NVARCHAR(2)) + ':' +
				CASE WHEN @Second < 10 THEN '0' ELSE '' END + CAST(@Second AS NVARCHAR(2)) 
	END
		
	RETURN @TimeCHAR

END

/*
GO
SELECT 
	  dbo.[func_VB_GetFormatTimeStr](15123, 1, 'CHN')
	, dbo.[func_VB_GetFormatTimeStr](15123, 2, 'CHN')
	, dbo.[func_VB_GetFormatTimeStr](15123, 1, 'ENG')
	, dbo.[func_VB_GetFormatTimeStr](15123, 2, 'ENG')
*/












GO
/************************func_VB_GetFormatTimeStr OVER*************************/


/************************func_VB_GetHeightDes Start************************/GO


--@type 1: 1.69 / 5'6"	2: 1.69

--2012-08-27	add type
--2012-09-05	rename from func_VB_RPT_GetHeightDes
CREATE FUNCTION [dbo].[func_VB_GetHeightDes]
(
	@Height		int,
	@Type		int = 1
)
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE @ResultVar AS NVARCHAR(100)
	
	IF @Type = 1
	BEGIN
		set @ResultVar = LEFT(@Height / 100.0, 4) + ' / ' + CONVERT(NVARCHAR(100), @Height * 100 / 3048) + '''' + CONVERT(NVARCHAR(100), (@Height * 100 / 254) % 12) + '"'
	END
	ELSE
	BEGIN
		set @ResultVar = LEFT(@Height / 100.0, 4)
	END
	RETURN @ResultVar
END

















GO
/************************func_VB_GetHeightDes OVER*************************/


/************************func_VB_GetMatchResultByRegAB Start************************/GO


--ͨ������˫��RegID��ȡ�˳�����MatchID
--�����û�п�ʼ���������Ǳ�������
--��ʾ�ȷ�ʱ����������˫���Զ��ж�
--һ����PhaseResultʹ��

--2011-10-15	Add Language
--2012-09-05	��OneRowScore�޸�
CREATE FUNCTION [dbo].[func_VB_GetMatchResultByRegAB]
(
	@PhaseID		INT,
	@TeamARegID		INT,
	@TeamBRegID		INT,
	@Lang			NVARCHAR(100)
)

RETURNS NVARCHAR(100)
AS
BEGIN

	DECLARE @MatchID		INT
	DECLARE @MatchDate		DATE
	DECLARE @MatchScoreA	NVARCHAR(100)
	DECLARE @MatchScoreB	NVARCHAR(100)
	DECLARE @Reserved		INT = 0 --�Ƿ�A,B��ת��
	DECLARE @ResultVar		NVARCHAR(100)
	
	--������A��B�ҵķ�ʽ���ұ���
	SELECT @MatchID = tMatch.F_MatchID FROM TS_Match AS tMatch
		INNER JOIN TS_Match_Result AS tMatchA ON tMatch.F_MatchID = tMatchA.F_MatchID AND tMatchA.F_CompetitionPosition = 1 AND tMatchA.F_RegisterID = @TeamARegID
		INNER JOIN TS_Match_Result AS tMatchB ON tMatch.F_MatchID = tMatchB.F_MatchID AND tMatchB.F_CompetitionPosition = 2 AND tMatchB.F_RegisterID = @TeamBRegID
		WHERE tMatch.F_PhaseID = @PhaseID
	
	--û�ҵ�,����A�ң�B��ɼ�
	IF ( @MatchID IS NULL )
	BEGIN
		SET @Reserved = 1
		SELECT @MatchID = tMatch.F_MatchID FROM TS_Match AS tMatch
		INNER JOIN TS_Match_Result AS tMatchA ON tMatch.F_MatchID = tMatchA.F_MatchID AND tMatchA.F_CompetitionPosition = 1 AND tMatchA.F_RegisterID = @TeamBRegID
		INNER JOIN TS_Match_Result AS tMatchB ON tMatch.F_MatchID = tMatchB.F_MatchID AND tMatchB.F_CompetitionPosition = 2 AND tMatchB.F_RegisterID = @TeamARegID 
		WHERE tMatch.F_PhaseID = @PhaseID
	END
		
	--��û�ҵ�����ֱ���˳�
	IF ( @MatchID IS NULL )
		RETURN @ResultVar
	
	
	--����˱����Ǹ��ֿ�,ֱ�ӷ���
	IF ( @TeamARegID = -1 OR @TeamBRegID = -1 )
	RETURN 'BYE'
	
	--����ȡ�ȷ֣������ת�ˣ��ͷ�תȡ	
	IF ( @Reserved <> 1 )
		SELECT @MatchScoreA = F_PtsASetDes, @MatchScoreB = F_PtsBSetDes FROM dbo.func_VB_GetMatchScoreOneRow(@MatchID, @Lang)
	ELSE
		SELECT @MatchScoreB = F_PtsASetDes, @MatchScoreA = F_PtsBSetDes FROM dbo.func_VB_GetMatchScoreOneRow(@MatchID, @Lang)
		
	IF ( @MatchScoreA IS NOT NULL AND @MatchScoreB IS NOT NULL ) 
		RETURN @MatchScoreA + '-' + @MatchScoreB
	ELSE
		RETURN dbo.func_VB_GetDateTimeStr((SELECT F_MatchDate FROM TS_Match WHERE F_MatchID = @MatchID), CASE @Lang WHEN 'ENG' THEN 8 ELSE 9 END )
	
	RETURN @ResultVar
END


/*
go
select dbo.[func_VB_GetMatchResultByRegAB]( 2, 1, 449, 'ENG')
*/


GO
/************************func_VB_GetMatchResultByRegAB OVER*************************/


/************************func_VB_GetMatchResultIRM Start************************/GO


--���ɱ������������������IRM��Ϣ���ȷֵ�
--������ʾ��

--2012-09-05	rename from [func_VB_RPT_GetMatchResultIRM]
CREATE FUNCTION [dbo].[func_VB_GetMatchResultIRM]
		(
			@MatchID					INT
		)
RETURNS NVARCHAR(100)
AS
BEGIN

	DECLARE @ResultDes AS NVARCHAR(100)
	DECLARE @HomePoint AS INT
	DECLARE @AwayPoint AS INT
    DECLARE @AIRM AS NVARCHAR(50)
    DECLARE @BIRM AS NVARCHAR(50)

	SET @ResultDes = ''

	SELECT @HomePoint = A.F_Points, @AIRM = '(' + B.F_IRMCODE + ')' FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID
    WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 1
	SELECT @AwayPoint = A.F_Points, @BIRM = '(' + B.F_IRMCODE + ')' FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID
    WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 2

	IF ((@HomePoint IS NOT NULL) AND (@AwayPoint IS NOT NULL) AND (@HomePoint+@AwayPoint)<>0)
	BEGIN
		SET @ResultDes = CAST(@HomePoint AS NVARCHAR(100)) + 
		(CASE WHEN @AIRM IS NULL THEN '' ELSE @AIRM END) + ' - ' + 
		CAST(@AwayPoint AS NVARCHAR(100)) + 
		(CASE WHEN @BIRM IS NULL THEN '' ELSE @BIRM END)
	END

	RETURN @ResultDes

END


GO
/************************func_VB_GetMatchResultIRM OVER*************************/


/************************func_VB_GetPercentStr Start************************/GO



--��������ø�ʽ�İٷ���
--һ����㼼��ͳ��

--2012-09-05	����һ��
CREATE FUNCTION [dbo].[func_VB_GetPercentStr]
(
	@Up			FLOAT,
	@Down		FLOAT
)

RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @fResult	AS FLOAT
	DECLARE @strResult	AS NVARCHAR(10)
	
	SET @fResult = CASE WHEN @Down = 0 THEN 0 ELSE @Up / @Down END
	SET @strResult = CAST( CAST( @fResult * 100 as Decimal(25,0)) as NVARCHAR(100) )
	
	RETURN @strResult
END














GO
/************************func_VB_GetPercentStr OVER*************************/


/************************func_VB_GetPositionChangeUp Start************************/GO


-- =============================================
-- Author:		����
-- Create date: 2010/10/13
-- Description:	�ж�һ��ѡ���Ƿ񱻻����ϳ���,�׷�����
-- Result:		Null:û�Ϲ���, 0:�����˻����׷�, RegID
-- =============================================

--2010-12-20	�ĳɷ��ض�ԱRegID
CREATE FUNCTION [dbo].[func_VB_GetPositionChangeUp]
(
	@MatchID		INT,	--������
	@CurSet			INT,	--iton�ڼ���
	@CompPos		INT,	-- 1:A��  2:B��
	@RegisterID		INT		--��ԱID
)
RETURNS INT
AS
BEGIN
	
	--�������
	if @RegisterID < 1 or @MatchID < 1 or @CurSet < 1 or @CompPos < 1 or @CompPos > 2 
	begin
		return NULL
	end
	
	Declare @ActPlyInID  as INT --ѡ���ϳ���ActionID
	Declare @ActPlyOutID as INT --ѡ���³���ActionID
	Declare @ActLibInID  as INT --�������ϳ���ActionID
	Declare @ActLibOutID as INT --�������³���ActionID
	
	Select @ActPlyInID = F_ActionTypeID From TD_ActionType Where F_ActionCode = 'Ply_In'
	Select @ActPlyOutID = F_ActionTypeID From TD_ActionType Where F_ActionCode = 'Ply_Out'
	Select @ActLibInID = F_ActionTypeID From TD_ActionType Where F_ActionCode = 'Lib_In'
	Select @ActLibOutID = F_ActionTypeID From TD_ActionType Where F_ActionCode = 'Lib_Out'
	
	if @ActPlyInID is null or @ActLibInID is null or @ActPlyOutID is null or @ActLibOutID is null
	begin
		return NULL
	end
	
	--�����ж������ϳ�
	Declare @PlayerFirstInOrder as INT --ѡ�ֵ�һ���ϳ��ļ���ͳ�ƶ������,����Ų�һ����������,������ж�
	select top 1 @PlayerFirstInOrder = F_ActionOrder From TS_Match_ActionList
	Where F_ActionTypeID = @ActPlyInID and
	F_CompetitionPosition = @CompPos and F_MatchSplitID = @CurSet and F_MatchID = @MatchID and F_RegisterID = @RegisterID
	Order by F_ActionOrder
	
	if @PlayerFirstInOrder is not null
	begin
		--�Է�����������Ϲ���
		Declare @PlayerInCntBefore INT --�ǵڼ����ϳ���
		Select @PlayerInCntBefore = COUNT(*) From TS_Match_ActionList
		Where F_ActionTypeID = @ActPlyInID and
		F_CompetitionPosition = @CompPos and F_MatchSplitID = @CurSet and F_MatchID = @MatchID and 
		F_ActionOrder < @PlayerFirstInOrder
		
		if @PlayerInCntBefore < 6
		begin
			--ǰ���Ѿ���5���������ϳ�,���Դ������׷�
			--
			return 0;
		end	
		else
		begin
			Declare @PlayerOutRegID	INT --���³��Ǹ��˵�RegID
			Select top 1 @PlayerOutRegID = F_RegisterID From TS_Match_ActionList 
			Where F_ActionTypeID = @ActPlyOutID and
			F_CompetitionPosition = @CompPos and F_MatchSplitID = @CurSet and F_MatchID = @MatchID and 
			F_ActionOrder < @PlayerFirstInOrder
			Order by F_ActionOrder desc
		
			if @PlayerOutRegID is null 
			begin
				--�Ҳ���֮ǰ�ϳ�����,ֻ�ܷ���Null
				return NULL
			end
			
			--declare @PlayerOutBib INT --�³��˵�Bib
			--Select @PlayerOutBib = F_ShirtNumber From TS_Match_Member 	
			--Where F_MatchID = @MatchID and F_CompetitionPosition = @CompPos and F_RegisterID = @PlayerOutRegID
			--return @PlayerOutBib
			
			return @PlayerOutRegID
		end			
	end
	
	--�ٳ����������ж�
	Declare @PlayerLibInOrder as INT --�����Ƿ�������������Ϲ���
	select top 1 @PlayerLibInOrder = F_ActionOrder From TS_Match_ActionList
	Where F_ActionTypeID = @ActLibInID and F_CompetitionPosition = @CompPos and F_MatchSplitID = @CurSet and F_MatchID = @MatchID and 
	F_RegisterID = @RegisterID
	Order by F_ActionOrder desc

	if @PlayerLibInOrder is null
	begin
		--û��������������Ϲ���
		return null
	end
	else
	begin
		--�Ϲ���,���������׷�,�����ǻ���
		declare @PlayerLibOutRegID as INT --֮ǰ�³���LibID
		Select top 1 @PlayerLibOutRegID = F_RegisterID From TS_Match_ActionList
		Where F_ActionTypeID = @ActLibOutID and F_CompetitionPosition = @CompPos and F_MatchSplitID = @CurSet and F_MatchID = @MatchID and 
		F_ActionOrder < @PlayerLibInOrder
		Order by F_ActionOrder desc 
		
		if @PlayerLibOutRegID is null
		begin
			--��ǰû�������˵��³�
			return null
		end
		else
		begin
			--declare @PlayerLibOutBib INT --�³��˵�Bib
			--Select @PlayerLibOutBib = F_ShirtNumber From TS_Match_Member 	
			--Where F_MatchID = @MatchID and F_CompetitionPosition = @CompPos and F_RegisterID = @PlayerLibOutRegID
			--return @PlayerLibOutBib
			return @PlayerLibOutRegID
		end
	end

	RETURN NULL
END

















GO
/************************func_VB_GetPositionChangeUp OVER*************************/


/************************func_VB_GetPositionLineUp Start************************/GO

















-- =============================================
-- Author:		����
-- Create date: 2010/10/13
-- Description:	�ж�һ��ѡ���Ƿ�Ϊ�׷�,�����,���׷��ڼ�λ
-- Result:	Null:�����׷�, 1-6:����λ, 0:������
-- =============================================
CREATE FUNCTION [dbo].[func_VB_GetPositionLineUp]
(
	@MatchID		INT,	--������
	@CurSet			INT,	--iton�ڼ���
	@CompPos		INT,	-- 1:A��  2:B��
	@RegisterID		INT		--��ԱID
)
RETURNS INT
AS
BEGIN
	
	--�������
	if @RegisterID < 1 or @MatchID < 1 or @CurSet < 1 or @CompPos < 1 or @CompPos > 2 
	begin
		return NULL
	end
	
	Declare @ActPlyInID as INT --ѡ���ϳ���ActionID
	Select @ActPlyInID = F_ActionTypeID From TD_ActionType Where F_ActionCode = 'Ply_In'
	
	Declare @ActLibInID as INT --�������ϳ���ActionID
	Select @ActLibInID = F_ActionTypeID From TD_ActionType Where F_ActionCode = 'Lib_In'
	
	if @ActPlyInID is null or @ActLibInID is null
	begin
		return NULL
	end
	
	--�����ж������ϳ�
	Declare @PlayerFirstInOrder as INT --ѡ�ֵ�һ���ϳ��ļ���ͳ�ƶ������,����Ų�һ����������,������ж�
	select top 1 @PlayerFirstInOrder = F_ActionOrder From TS_Match_ActionList
	Where F_ActionTypeID = @ActPlyInID and
	F_CompetitionPosition = @CompPos and F_MatchSplitID = @CurSet and F_MatchID = @MatchID and F_RegisterID = @RegisterID
	Order by F_ActionOrder
	
	if @PlayerFirstInOrder is not null
	begin
		--�Է�����������Ϲ���
		Declare @PlayerInIndex INT --�ǵڼ����ϳ���
		Select @PlayerInIndex = COUNT(*) From TS_Match_ActionList
		Where F_ActionTypeID = @ActPlyInID and
		F_CompetitionPosition = @CompPos and F_MatchSplitID = @CurSet and F_MatchID = @MatchID and 
		F_ActionOrder < @PlayerFirstInOrder
		
		if @PlayerInIndex < 6
		begin
			--ǰ���Ѿ���5���������ϳ�,���Դ������׷�
			--
			return @PlayerInIndex + 1;
		end				
	end
	
	--�ٳ����������ж�
	Declare @FirstInLibRegID as INT --���ֵ�һ���ϳ���������
	select top 1 @FirstInLibRegID = F_RegisterID From TS_Match_ActionList
	Where F_ActionTypeID = @ActLibInID and
	F_CompetitionPosition = @CompPos and F_MatchSplitID = @CurSet and F_MatchID = @MatchID
	Order by F_ActionOrder

	--��һ���ϳ�������������Ϊ����,��ô���˾���������	
	if @FirstInLibRegID = @RegisterID
	begin
		return 0
	end

	
	RETURN NULL
END

















GO
/************************func_VB_GetPositionLineUp OVER*************************/


/************************func_VB_GetRegisterWinLostInGroup Start************************/GO


--ͳ��һ������С����,��������,ʤ������,��������,ʤ�ִ�,���ִεȵ�
--������Official״̬

--2012-09-05	����һ��
CREATE FUNCTION [dbo].[func_VB_GetRegisterWinLostInGroup]
								(
									@PhaseID			INT,
									@RegisterID			INT,	
									@TypeID				INT,	-- 1:Match	2:Sets	3:Points
									@ResultID			INT		-- 1:Win	2:Lost
								)
RETURNS INT
AS
BEGIN

    DECLARE @ResultNum AS INT
    SET @ResultNum = 0

	IF @TypeID = 1 --Match Win Lost
	BEGIN
	    SELECT @ResultNum = COUNT(X.F_MatchID) FROM 
	    TS_Match AS X 
	    LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
	    WHERE X.F_PhaseID = @PhaseID AND 
	    X.F_MatchStatusID IN(100, 110) AND 
	    Y.F_RegisterID = @RegisterID AND 
	    Y.F_ResultID = @ResultID
	END
	ELSE IF (@TypeID = 2) AND (@ResultID = 1) --Sets Won 
	BEGIN
	    SELECT @ResultNum = SUM(CASE WHEN X.F_WinSets IS NULL THEN 0 ELSE X.F_WinSets END) FROM TS_Match_Result AS X 
	    LEFT JOIN TS_Match AS Y ON X.F_MatchID = Y.F_MatchID
        WHERE Y.F_PhaseID = @PhaseID AND Y.F_MatchStatusID IN(100, 110) AND X.F_RegisterID = @RegisterID
	END
	ELSE IF (@TypeID = 2) AND (@ResultID = 2) --Sets Lost 
	BEGIN
	    SELECT @ResultNum = SUM(CASE WHEN X.F_LoseSets IS NULL THEN 0 ELSE X.F_LoseSets END) FROM TS_Match_Result AS X 
	    LEFT JOIN TS_Match AS Y ON X.F_MatchID = Y.F_MatchID
        WHERE Y.F_PhaseID = @PhaseID AND Y.F_MatchStatusID IN(100, 110) AND X.F_RegisterID = @RegisterID
	END
	ELSE IF (@TypeID = 3) AND (@ResultID = 1) --Points Won
	BEGIN
	    SELECT @ResultNum = SUM(CASE WHEN X.F_WinPoints IS NULL THEN 0 ELSE X.F_WinPoints END) FROM TS_Match_Result AS X 
	    LEFT JOIN TS_Match AS Y ON X.F_MatchID = Y.F_MatchID
        WHERE Y.F_PhaseID = @PhaseID AND Y.F_MatchStatusID IN(100, 110) AND X.F_RegisterID = @RegisterID
	END
	ELSE IF (@TypeID = 3) AND (@ResultID = 2) --Points Lost
	BEGIN
	    SELECT @ResultNum = SUM(CASE WHEN X.F_LosePoints IS NULL THEN 0 ELSE X.F_LosePoints END) FROM TS_Match_Result AS X 
	    LEFT JOIN TS_Match AS Y ON X.F_MatchID = Y.F_MatchID
        WHERE Y.F_PhaseID = @PhaseID AND Y.F_MatchStatusID IN(100, 110) AND X.F_RegisterID = @RegisterID
	END
	
	IF @ResultNum IS NULL
	SET @ResultNum = 0
	RETURN @ResultNum

END






















GO
/************************func_VB_GetRegisterWinLostInGroup OVER*************************/


/************************func_VB_GetRscCode Start************************/GO






--������ҪRscCode�ĵط�����Ҫ�Ӵ˴���ȡ


--2011-3-21		Created
--2011-10-15	Get Disc code automaticly
CREATE FUNCTION [dbo].[func_VB_GetRscCode]
(
	@EventID	  INT = -1,
	@PhaseID	  INT = -1,
	@MatchID	  INT = -1
)

RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @DiscCode	NVARCHAR(100)
	DECLARE @EventCode	NVARCHAR(100)
	DECLARE @GenderCode	NVARCHAR(100)
	DECLARE @PhaseCode	NVARCHAR(100)
	DECLARE @MatchCode	NVARCHAR(100)
	DECLARE @Result		NVARCHAR(100)
	
	SELECT @DiscCode = F_DisciplineCode FROM TS_Discipline WHERE F_Active = 1
	
	--��Match��
	IF ( @MatchID > 0 )
	BEGIN
		SELECT 
			  @EventCode = tEvent.F_EventCode
			, @GenderCode = tSex.F_GenderCode
			, @PhaseCode = tPhase.F_PhaseCode
			, @MatchCode = tMatch.F_MatchCode 
		FROM TS_Match AS tMatch
			LEFT JOIN TS_Phase AS tPhase ON tPhase.F_PhaseID = tMatch.F_PhaseID
			LEFT JOIN TS_Event AS tEvent ON tEvent.F_EventID = tPhase.F_EventID
			LEFT JOIN TC_Sex AS tSex ON tSex.F_SexCode = tEvent.F_SexCode
		WHERE F_MatchID = @MatchID
		
		SELECT @Result = @DiscCode + @GenderCode + @EventCode + @PhaseCode + @MatchCode
		RETURN @Result
	END
	
	--��Phase��
	IF ( @PhaseID > 0 ) 
	BEGIN
		SELECT 
			  @EventCode = tEvent.F_EventCode
			, @GenderCode = tSex.F_GenderCode
			, @PhaseCode = tPhase.F_PhaseCode 
		FROM TS_Phase AS tPhase 
			LEFT JOIN TS_Event AS tEvent ON tEvent.F_EventID = tPhase.F_EventID
			LEFT JOIN TC_Sex AS tSex ON tSex.F_SexCode = tEvent.F_SexCode
		WHERE F_PhaseID = @PhaseID
		
		SELECT @Result = @DiscCode + @GenderCode + @EventCode + @PhaseCode + '00'
		RETURN @Result
	END
	
	--��Event��
	IF ( @EventID > 0 )
	BEGIN
		SELECT 
			  @EventCode = tEvent.F_EventCode
			, @GenderCode = tSex.F_GenderCode
		FROM TS_Event AS tEvent
			LEFT JOIN TC_Sex AS tSex ON tSex.F_SexCode = tEvent.F_SexCode
		WHERE F_EventID = @EventID
		
		SELECT @Result = @DiscCode + @GenderCode + @EventCode + '0' + '00'
		RETURN @Result
	END
	
	SET @Result = @DiscCode + '0000000'
	RETURN @Result
END













GO
/************************func_VB_GetRscCode OVER*************************/


/************************func_VB_GetScoreFromStat Start************************/GO


-- Description:	���ٸ���STAT����������÷�

--Created		2011-03-31
CREATE FUNCTION [dbo].[func_VB_GetScoreFromStat]
(
	@MatchID		INT,	--������
	@CurSet			INT,	--iton�ڼ���
	@DependCompPos	INT,	-- 1:A��  2:B��		���ķ�����ͳ������
	@TargetCompPos	INT		-- 1:A��  2:B��		�����ķ�����ͳ��
)
RETURNS INT
AS
BEGIN
	
	--�������
	IF @MatchID < 1 OR @CurSet < 1 OR @DependCompPos < 1 OR @DependCompPos > 2 OR @TargetCompPos < 1 OR @TargetCompPos > 2
		RETURN NULL
	
	DECLARE @Result INT=0
	
	SELECT @Result = COUNT(F_ActionNumberID) 
	FROM TS_Match_ActionList AS A
	INNER JOIN TD_ActionType AS B ON B.F_ActionTypeID = A.F_ActionTypeID
	WHERE F_MatchID = @MatchID AND F_MatchSplitID = @CurSet AND F_CompetitionPosition = @DependCompPos AND 
		F_ActionEffect = 
		CASE 
			WHEN @DependCompPos = 1 AND @TargetCompPos = 1 THEN 1
			WHEN @DependCompPos = 1 AND @TargetCompPos = 2 THEN -1
			WHEN @DependCompPos = 2 AND @TargetCompPos = 1 THEN -1
			WHEN @DependCompPos = 2 AND @TargetCompPos = 2 THEN 1
		END
	
	RETURN @Result
END




/*
go
select [dbo].[func_VB_GetScoreFromStat](1,1,1,1)
*/











GO
/************************func_VB_GetScoreFromStat OVER*************************/


/************************func_VB_GetStatValue Start************************/GO


-- =============================================
-- Author:		����
-- Create date: 2010/10/13
-- Description:	��ȡһ���ͳ����ֵ
-- =============================================

--2010/01/04 All Match ֻͳ��״̬ΪOfficial�Ժ�ı���

CREATE FUNCTION [dbo].[func_VB_GetStatValue]
(
	@StatType		INT,	--0:Only Current Match    1:Before Current Match      2: 0+1   3:All Match
	@RegisterID		INT,	--��Ϊ��ԱID,Ҳ��Ϊ����ID
	@MatchID		INT,	--StatType 0,1,2ʱ��Ч
	@CurSet			INT,	--�ڼ���, 1-5: ��N�� NULL:���о�    StatType 0 ʱ��Ч
	@StatID			INT		--
)
RETURNS INT
AS
BEGIN
									
	DECLARE @StatCnt		INT=0
	DECLARE @RegType		INT=-1		--���˻���������	
	DECLARE	@CurMatchDate	DATETIME	--��������������
	DECLARE @CurMatchTime	DATETIME	--����������ʱ��
	
	
	IF @RegisterID = -1
	begin --A��������
		Select @RegisterID = F_RegisterID From TS_Match_Result 
		Where F_MatchID = @MatchID and F_CompetitionPosition = 1
	end
	
	IF @RegisterID = -2
	begin -- B��������
		Select @RegisterID = F_RegisterID From TS_Match_Result 
		Where F_MatchID = @MatchID and F_CompetitionPosition = 2
	end

	Select @RegType = F_RegTypeID from TR_Register where F_RegisterID = @RegisterID
		
	Select @CurMatchDate = F_MatchDate, @CurMatchTime = F_StartTime 
	FROM TS_Match Where F_MatchID = @MatchID


	IF @RegisterID IS NULL OR @StatID IS NULL
	BEGIN
		RETURN 0
	END
	
	
	IF @RegType = 1
	BEGIN --����
		
		IF @StatType = 0 
		BEGIN --���� ��������	
				
				IF @CurSet > 0 
				BEGIN --���� �������� ���� 
					Select @StatCnt = COUNT(*) From TS_Match_ActionList
					Where F_ActionTypeID = @StatID and F_MatchID = @MatchID and 
					F_RegisterID = @RegisterID and F_MatchSplitID = @CurSet
				END
				ELSE
				BEGIN --���� �������� ���о�
					Select @StatCnt = COUNT(*) From TS_Match_ActionList
					Where F_ActionTypeID = @StatID and F_MatchID = @MatchID and 
					F_RegisterID = @RegisterID
				END
				
		END	
		
		IF @StatType = 1
		BEGIN --���� �˳�����ǰ���м���ͳ��,�����˳�����
					
				SELECT @StatCnt = COUNT(*)
				FROM TS_Match_Result as TMatchResult
				INNER JOIN TS_Match_ActionList as tActionList on 
					tActionList.F_MatchID = TMatchResult.F_MatchID and tActionList.F_CompetitionPosition = TMatchResult.F_CompetitionPosition
				Where TMatchResult.F_MatchID IN 
							(
								Select F_MatchID FROM TS_Match WHERE 
								(F_MatchDate < @CurMatchDate) or (F_MatchDate = @CurMatchDate and F_StartTime < @CurMatchTime )
							)
				AND tActionList.F_RegisterID = @RegisterID AND tActionList.F_ActionTypeID = @StatID
		END
		
		IF @StatType = 2
		BEGIN --���� �˳�����ǰ���м���ͳ��,���˳�����
				
				SELECT @StatCnt = COUNT(*)
				FROM TS_Match_Result as TMatchResult
				INNER JOIN TS_Match_ActionList as tActionList on 
					tActionList.F_MatchID = TMatchResult.F_MatchID and tActionList.F_CompetitionPosition = TMatchResult.F_CompetitionPosition
				Where TMatchResult.F_MatchID IN 
							(
								Select F_MatchID FROM TS_Match WHERE 
								(F_MatchDate <= @CurMatchDate) or (F_MatchDate = @CurMatchDate and F_StartTime <= @CurMatchTime )
							)
				and tActionList.F_RegisterID = @RegisterID AND tActionList.F_ActionTypeID = @StatID
		END
		
		IF @StatType = 3
		BEGIN --���� ���б���
			
			Select @StatCnt = COUNT(F_ActionTypeID) From TS_Match_ActionList
			Where F_ActionTypeID = @StatID and F_RegisterID = @RegisterID 
		END
		
		
	END
	ELSE
	BEGIN --����
		
		IF @StatType = 0 
		BEGIN --���� ��������	
				
				IF @CurSet > 0 
				BEGIN --���� �������� ���� 
					SELECT @StatCnt = COUNT(*)
					FROM TS_Match_Result as TMatchResult
					INNER JOIN TS_Match_ActionList as tActionList on 
						tActionList.F_MatchID = TMatchResult.F_MatchID and 
						tActionList.F_CompetitionPosition = TMatchResult.F_CompetitionPosition and 
						tActionList.F_MatchSplitID = @CurSet and
						tActionList.F_ActionTypeID = @StatID
					Where TMatchResult.F_MatchID = @MatchID and TMatchResult.F_RegisterID = @RegisterID
				END
				ELSE
				BEGIN --���� �������� ���о�
					SELECT @StatCnt = COUNT(*)
					FROM TS_Match_Result as TMatchResult
					INNER JOIN TS_Match_ActionList as tActionList on 
						tActionList.F_MatchID = TMatchResult.F_MatchID and 
						tActionList.F_CompetitionPosition = TMatchResult.F_CompetitionPosition and 
						tActionList.F_ActionTypeID = @StatID
					Where TMatchResult.F_MatchID = @MatchID and TMatchResult.F_RegisterID = @RegisterID
				END
				
		END	
		
		
		IF @StatType = 1
		BEGIN --���� �˳�����ǰ���м���ͳ��,�����˳�����
					
				SELECT @StatCnt = COUNT(*)
				FROM TS_Match_Result as TMatchResult
				INNER JOIN TS_Match_ActionList as tActionList on 
					tActionList.F_MatchID = TMatchResult.F_MatchID and 
					tActionList.F_CompetitionPosition = TMatchResult.F_CompetitionPosition and 
					tActionList.F_ActionTypeID = @StatID
				Where TMatchResult.F_MatchID IN 
							(
								Select F_MatchID FROM TS_Match WHERE 
								(F_MatchDate < @CurMatchDate) or (F_MatchDate = @CurMatchDate and F_StartTime < @CurMatchTime )
							)
				and tActionList.F_RegisterID = @RegisterID
		END
		
		IF @StatType = 2
		BEGIN --���� �˳�����ǰ���м���ͳ��,���˳�����
				
				SELECT @StatCnt = COUNT(*)
				FROM TS_Match_Result as TMatchResult
				INNER JOIN TS_Match_ActionList as tActionList on 
					tActionList.F_MatchID = TMatchResult.F_MatchID and 
					tActionList.F_CompetitionPosition = TMatchResult.F_CompetitionPosition and 
					tActionList.F_ActionTypeID = @StatID
				Where TMatchResult.F_MatchID IN 
							(
								Select F_MatchID FROM TS_Match WHERE 
								(F_MatchDate <= @CurMatchDate) or (F_MatchDate = @CurMatchDate and F_StartTime <= @CurMatchTime )
							)
				and tActionList.F_RegisterID = @RegisterID
		END
		
		IF @StatType = 3
		BEGIN --���� ���б��� ������״̬ΪOfficial���ϵı���
	
				Select @StatCnt = COUNT(*)
				FROM TS_Match_Result as tMatchResult
				INNER JOIN TS_Match as tMatch ON
					tMatch.F_MatchID = tMatchResult.F_MatchID AND tMatch.F_MatchStatusID >= 110
				INNER JOIN TS_Match_ActionList as tActionList on 
					tActionList.F_MatchID = TMatchResult.F_MatchID and 
					tActionList.F_CompetitionPosition = TMatchResult.F_CompetitionPosition and 
					tActionList.F_ActionTypeID = @StatID
				Where tMatchResult.F_RegisterID = @RegisterID
		END
		
	END	
		
	Return @StatCnt
			
END

















GO
/************************func_VB_GetStatValue OVER*************************/


/************************func_VB_GetStatValueByStatCode Start************************/GO


-- =============================================
-- Author:		����
-- Create date: 2010/10/13
-- Description:	��ȡһ���ͳ����ֵ
-- Ϊ�˵��÷���,�����StatCode��ʽ
-- =============================================
CREATE FUNCTION [dbo].[func_VB_GetStatValueByStatCode]
(
	@StatType		INT,	--0:Only Current Match    1:Before Current Match      2: 0+1   3:All Match
	@RegisterID		INT,	--��Ϊ��ԱID,Ҳ��Ϊ����ID
	@MatchID		INT,	--StatType 0,1,2ʱ��Ч
	@CurSet			INT,	--�ڼ���, 1-5: ��N�� NULL:���о�    StatType 0 ʱ��Ч
	@StatCode		NVARCHAR(100)
)
RETURNS INT
AS
BEGIN
		
	DECLARE @StatID INT
	Select @StatID = F_ActionTypeID From TD_ActionType 
	Where F_ActionCode = @StatCode
			
	IF @StatID IS NULL 
	BEGIN
		RETURN NULL
	END
	
		
	RETURN dbo.func_VB_GetStatValue(@StatType, @RegisterID, @MatchID, @CurSet, @StatID)
			
END

















GO
/************************func_VB_GetStatValueByStatCode OVER*************************/


/************************func_VB_GetWeightDes Start************************/GO


--2012-08-27
--@type 1: 26 / 57 2: 26

--2012-09-05	rename from [func_VB_RPT_GetWeightDes]
CREATE FUNCTION [dbo].[func_VB_GetWeightDes]
(
	@Weight		int,
	@Type		int = 1
)
RETURNS NVARCHAR(30)
AS
BEGIN
	DECLARE @ResultVar AS NVARCHAR(100)
	
	IF @Type = 1
	BEGIN
		set @ResultVar = CONVERT(NVARCHAR(100), @Weight) + ' / ' + CONVERT(NVARCHAR(100), @Weight * 22 / 10)
	END
	ELSE
	BEGIN
		set @ResultVar = CONVERT(NVARCHAR(100), @Weight)
	END
	
	RETURN @ResultVar
END

















GO
/************************func_VB_GetWeightDes OVER*************************/


/************************func_VB_GetZeroValue Start************************/GO


--�����0 ��Ϊ '-'
--ΪVB����ͳ�Ʊ������

--2012-09-05
CREATE FUNCTION [dbo].[func_VB_GetZeroValue]
(
	@Value		INT
)

RETURNS NVARCHAR(30)
AS
BEGIN

	DECLARE @ResultVar AS NVARCHAR(30)
	
	SET @ResultVar = CASE @Value WHEN 0 THEN '-' ELSE CAST(@Value AS NVARCHAR(30)) END
	
	RETURN @ResultVar
END
















GO
/************************func_VB_GetZeroValue OVER*************************/


/************************func_VB_IsActionInPlayByPlay Start************************/GO


--�ж���ActionType�Ƿ�Ӧ�ó�����PlayByPlay��
--Ŀǰ�ж���Ӱ��ȷֵģ�����ģ���Ӧ��
--����1:��  0:��

--2011-03-14	Created
CREATE FUNCTION [dbo].[func_VB_IsActionInPlayByPlay]
(
	@AcitonTypeID		INT
)

RETURNS INT
AS
BEGIN
	--��������Ƿ����
	IF ( (SELECT COUNT(F_ActionTypeID) FROM TD_ActionType 
		WHERE F_ActionTypeID = @AcitonTypeID AND F_ActionCode IN('SRV_SUC', 'SRV_CNT', 'SRV_FLT')) > 0 )
	BEGIN
		RETURN 1
	END
	
	--�������ʱӰ��ȷֵ�
	IF ( (SELECT COUNT(F_ActionTypeID) FROM TD_ActionType WHERE F_ActionTypeID = @AcitonTypeID AND F_ActionEffect <> 0 ) > 0 )
	BEGIN
		RETURN 1
	END
	
	RETURN 0
END

/*
go
select dbo.func_VB_IsActionInPlayByPlay(1)
*/











GO
/************************func_VB_IsActionInPlayByPlay OVER*************************/

