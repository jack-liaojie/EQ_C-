IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetJudgeMessage_ForMatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetJudgeMessage_ForMatch]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


--名    称: [Proc_JU_GetJudgeMessage_ForMatch]
--描    述: 柔道获取每场比赛的裁判信息
--创 建 人: 宁顺泽
--日    期: 2011年6月14日 星期一
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_GetJudgeMessage_ForMatch]
	@SessionNumber					INT,
	@CourtCode						NVARCHAR(20),
	@MatchType						INT,
	@Result							NVARCHAR(MAX) output
AS
BEGIN
SET NOCOUNT ON
	
	declare @Content NVARCHAR(MAX)

set @Content=(
select Judge.Session,Judge.Court,Judge.MatchNo,Judge.GroupGameNo,Judge.BlueNOC,Judge.WhiteNOC,Judge.RefereeID,Judge.Judge1ID,Judge.Judge2ID from 
(	
	select 
	case when @SessionNumber<10 then N'0'+CONVERT(NVARCHAR(10),@SessionNumber) else CONVERT(NVARCHAR(10),@SessionNumber) end  AS Session
	,RIGHT(@CourtCode,1) as Court
	,M.F_RaceNum as MatchNo
	,CASE when  1=1 then N'0' else N'1' end AS GroupGameNo
	,ISNULL(DA.F_DelegationCode,N'') As BlueNOC
	,ISNULL(DB.F_DelegationCode,N'') AS WhiteNOC
	,ISNULL(case when FD1.F_FunctionShortName=N'Referee' then R1.F_Bib
			when FD2.F_FunctionShortName=N'Referee' then R2.F_Bib
			when FD3.F_FunctionShortName=N'Referee' then R3.F_Bib
		END,N''	) as RefereeID
	,ISNULL(case when FD1.F_FunctionShortName=N'Judge' then R1.F_Bib
			when FD2.F_FunctionShortName=N'Judge' then R2.F_Bib
			when FD3.F_FunctionShortName=N'Judge' then R3.F_Bib
		END,N'') as Judge1ID
	,ISNULL(case when FD1.F_FunctionShortName=N'Judge' 
				then 
					case when FD2.F_FunctionShortName=N'Judge' then R2.F_Bib
						when FD3.F_FunctionShortName=N'Judge' then R3.F_Bib
					end
			when FD3.F_FunctionShortName=N'Judge' then R3.F_Bib			
		END ,N'')as Judge2ID
from TS_Match AS M 
LEFT JOIN TS_Session AS S
	ON M.F_SessionID=S.F_SessionID
LEFT JOIN TC_Court AS C
	ON C.F_CourtID=M.F_CourtID
LEFT JOIN TC_Court_Des AS CD 
	ON CD.F_CourtID =C.F_CourtID AND CD.F_LanguageCode=N'ENG'
LEFT JOIN TS_Match_Servant AS MS1
	ON MS1.F_MatchID=m.F_MatchID AND MS1.F_Order=1
LEFT JOIN TR_Register AS R1
	ON R1.F_RegisterID=Ms1.F_RegisterID
LEFT JOIN TD_Function_Des AS FD1
	ON FD1.F_FunctionID = MS1.F_FunctionID AND FD1.F_LanguageCode = N'ENG'
	
LEFT JOIN TS_Match_Servant AS MS2
	ON MS2.F_MatchID=m.F_MatchID AND MS2.F_Order=2
LEFT JOIN TR_Register AS R2
	ON R2.F_RegisterID=Ms2.F_RegisterID
LEFT JOIN TD_Function_Des AS FD2
	ON FD2.F_FunctionID = MS2.F_FunctionID AND FD2.F_LanguageCode = N'ENG'
	
LEFT JOIN TS_Match_Servant AS MS3
	ON MS3.F_MatchID=m.F_MatchID AND MS3.F_Order=3
LEFT JOIN TR_Register AS R3
	ON R3.F_RegisterID=Ms3.F_RegisterID
LEFT JOIN TD_Function_Des AS FD3
	ON FD3.F_FunctionID = MS3.F_FunctionID AND FD3.F_LanguageCode = N'ENG'
	
LEFT JOIN TS_Match_Result AS MR1
	ON M.F_MatchID=MR1.F_MatchID AND MR1.F_CompetitionPosition=1
LEFT JOIN TR_Register AS RA
	ON MR1.F_RegisterID=RA.F_RegisterID
LEFT JOIN TC_Delegation AS DA
	ON DA.F_DelegationID=RA.F_DelegationID
	
LEFT JOIN TS_Match_Result AS MR2
	ON MR2.F_MatchID=M.F_MatchID AND MR2.F_CompetitionPosition=2
LEFT JOIN TR_Register As RB
	ON RB.F_RegisterID=MR2.F_RegisterID
LEFT JOIN TC_Delegation AS DB
	ON DB.F_DelegationID=RB.F_DelegationID
	
where S.F_SessionNumber=@SessionNumber AND C.F_CourtCode=@CourtCode
) AS Judge
for xml auto
)
	set @Result=N'<?xml version="1.0"?><xml>'+@Content+N'</xml>'	
	
SET NOCOUNT OFF
END

