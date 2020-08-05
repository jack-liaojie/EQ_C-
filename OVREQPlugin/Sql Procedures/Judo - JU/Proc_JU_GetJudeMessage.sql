IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetJudgeMessage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetJudgeMessage]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


--��    ��: [Proc_JU_GetJudeMessage]
--��    ��: �����ȡÿ�������Ķ�����Ϣ
--�� �� ��: ��˳��
--��    ��: 2011��6��14�� ���ڶ�
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_JU_GetJudgeMessage]
	@Result							NVARCHAR(MAX) output
AS
BEGIN
SET NOCOUNT ON
	
	
	declare @Content NVARCHAR(MAX)
	
	select @Content=(select Judge.F_Bib AS ID,Judge.F_LongName as LongName,Judge.F_ShortName as ShortName,Judge.F_NOC AS NocCode from ( SELECT r.F_Bib,R.F_NOC,RD.F_LongName,F_ShortName FROM TR_Register as r
left join TR_Register_Des as rd
	on R.F_RegisterID=rd.F_RegisterID and rD.F_LanguageCode=N'ENG'	
where R.F_RegTypeID=4 )as Judge for xml auto)	
	
	set @Result=N'<?xml version="1.0"?><xml>'+@Content+N'</xml>'	
	
SET NOCOUNT OFF
END

