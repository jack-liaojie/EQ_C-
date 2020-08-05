IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_WR_PreviousResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_WR_PreviousResult]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_TVG_WR_PreviousResult]
--��    ��: ÿ��������˫������ʷս��
--�� �� ��: �����
--��    ��: 2011��05��9�� ����1
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_TVG_WR_PreviousResult]
	@MatchID						INT,
	@Com							INT
AS
BEGIN
SET NOCOUNT ON

DECLARE @PlayerRegTypeID		INT
		
	SELECT @PlayerRegTypeID = E.F_PlayerRegTypeID
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	WHERE M.F_MatchID = @MatchID
	
	
	Select
		N'[Image]'+R1.F_NOC AS [CurFlag]
		,case When @Com=1 then N'[Image]Card_Red' else N'[Image]Card_Blue' END AS [Color]
		,RD1.F_TvLongName as NameA
		,N'[Image]'+R.F_NOC AS [Flag]
		,case when ISNUll(RD.F_LongName,N'')=N'' then N'BYE' else RD.F_LongName end AS NameB
		,ISNULL(DD.F_DecisionLongName +N'  '+CASE MRA1.F_ResultID WHEN 1 THEN N'W' ELSE N'L' END,N'') AS [Prev]
		,RD1.F_TvShortName AS NameA_Short
		,case when ISNUll(RD.F_TvShortName,N'')=N'' then N'BYE' else RD.F_TvShortName end AS NameB_Short
	from TS_Match AS M
	LEFT JOIN TS_Phase AS P
		ON M.F_PhaseID=P.F_PhaseID
	LEFT JOIN TS_Event AS E
		ON P.F_EventID=E.F_EventID
	LEFT JOIN TS_Match_Result AS MRA
		ON M.F_MatchID=MRA.F_MatchID AND MRA.F_CompetitionPosition=@com
	LEFT JOIN TR_Register AS R1
		ON MRA.F_RegisterID=R1.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD1
		ON R1.F_RegisterID=RD1.F_RegisterID AND RD1.F_LanguageCode=N'ENG'
	LEFT JOIN TS_Match_Result AS MRA1 
		ON MRA.F_RegisterID=MRA1.F_RegisterID AND MRA1.F_MatchID<MRA.F_MatchID
	LEFT JOIN TS_Match AS M1
		ON M1.F_MatchID=MRA1.F_MatchID
	LEFT JOIN TS_Phase AS P1
		ON P1.F_PhaseID=M1.F_PhaseID 
	LEFT JOIN TS_Event AS E1
		ON E1.F_EventID=P1.F_EventID
	LEFT JOIN TS_Match_Result AS MRA2
		ON MRA1.F_MatchID=MRA2.F_MatchID AND MRA2.F_CompetitionPosition <>MRA1.F_CompetitionPosition
	LEFT JOIN TS_Match AS M2
		ON MRA2.F_MatchID=M2.F_MatchID 
	LEFT JOIN TC_Decision_Des AS DD
		ON DD.F_DecisionID=M2.F_DecisionID AND DD.F_LanguageCode=N'ENG'
	LEFT JOIN TR_Register AS R
		ON MRA2.F_RegisterID=R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID=RD.F_RegisterID AND Rd.F_LanguageCode=N'ENG'
	where M.F_MatchID=@MatchID AND E.F_EventID=E1.F_EventID
	order by M1.F_MatchID ASC

	

SET NOCOUNT OFF
END

/*
EXEC [Proc_TVG_JU_PreviousResult] 84,2
*/