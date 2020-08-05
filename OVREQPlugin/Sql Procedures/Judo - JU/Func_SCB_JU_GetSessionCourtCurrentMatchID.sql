IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SCB_JU_GetSessionCourtCurrentMatchID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SCB_JU_GetSessionCourtCurrentMatchID]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Func_SCB_JU_GetSessionCourtCurrentMatchID]
--��    ��: ��ȡһ�� Session һ�� Court �ĵ�ǰ������ MatchID.
--�� �� ��: �����
--��    ��: 2011��3��31�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE FUNCTION [Func_SCB_JU_GetSessionCourtCurrentMatchID]
(
	@SessionID				INT,
	@CourtID				INT
)
RETURNS INT
AS
BEGIN

	DECLARE @MatchID		INT
	
	/*
	1. ȡ���һ�� StartList �� Running �ı���, 
	2. ��û��, ȡ���һ�� Unofficial �� Officail �ı���, 
	3. �绹û��ȡ��һ������.
	*/
	SELECT TOP 1 @MatchID = M.F_MatchID
	FROM TS_Match AS M	
	WHERE M.F_MatchStatusID =50
		AND M.F_SessionID = @SessionID
		AND M.F_CourtID = @CourtID
	ORDER BY CONVERT(int,ISNULL(m.F_RaceNum,N'0')) DESC 
		
	IF @MatchID IS NULL
	BEGIN
		SELECT TOP 1 @MatchID = M.F_MatchID
		FROM TS_Match AS M	
		WHERE M.F_MatchStatusID=100
			AND M.F_SessionID = @SessionID
			AND M.F_CourtID = @CourtID
		ORDER BY CONVERT(int,ISNULL(m.F_RaceNum,N'0')) DESC 
		
	END
	
	IF @MatchID IS NULL
	BEGIN
		SELECT TOP 1 @MatchID = M.F_MatchID
		FROM TS_Match AS M	
		WHERE M.F_MatchStatusID<50
			AND M.F_SessionID = @SessionID
			AND M.F_CourtID = @CourtID
		ORDER BY CONVERT(int,ISNULL(m.F_RaceNum,N'0'))  
		
	END

	RETURN @MatchID

END
GO

/*

-- Just for test
select dbo.[Func_SCB_JU_GetSessionCourtCurrentMatchID](1)
select dbo.[Func_SCB_JU_GetSessionCourtCurrentMatchID](5)
select dbo.[Func_SCB_JU_GetSessionCourtCurrentMatchID](10)

*/