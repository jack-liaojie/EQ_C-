IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GeTeamTtile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GeTeamTtile]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_JU_GeTeamTtile]
--��    ��: ��ȡ�������Ķ���.
--�� �� ��: ��˳��
--��    ��: 2010��12��29�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_JU_GeTeamTtile]
	@MatchID						INT,
	@CompPos						INT,
	@Title							NVARCHAR(100) OUTPUT,
	@LanguageCode					CHAR(3) = NULL
AS
BEGIN
SET NOCOUNT ON

	IF @LanguageCode IS NULL
	BEGIN
		SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1
	END
	SELECT @Title=RD.F_LongName 
	FROM TS_Match_Result AS MR
		LEFT JOIN TR_Register_Des AS RD
			ON MR.F_RegisterID=RD.F_RegisterID AND RD.F_LanguageCode=@LanguageCode
	WHERE MR.F_MatchID=@MatchID AND MR.F_CompetitionPosition=@CompPos
	
SET NOCOUNT OFF
END