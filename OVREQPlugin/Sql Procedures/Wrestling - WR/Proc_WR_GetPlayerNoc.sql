IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetPlayerNoc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetPlayerNoc]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_WR_GetPlayerNoc]
--��    ��: ˤ����Ŀ ��ȡ����˫��Noc.
--�� �� ��: ��˳��
--��    ��: 2010��10��6�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WR_GetPlayerNoc]
	@MatchID						INT,
	@Compos							int,
	@Title							NVARCHAR(200) OUTPUT,
	@LanguageCode					CHAR(3) = NULL
AS
BEGIN
SET NOCOUNT ON

	IF @LanguageCode IS NULL
	BEGIN
		SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1
	END
	
	SELECT @Title = substring(DD.F_DelegationShortName,1,3) from TS_Match_Result AS MR
			LEFt JOIN TR_Register AS R
				ON MR.F_RegisterID=R.F_RegisterID 
			LEFT JOIN TC_Delegation as D
				ON D.F_DelegationID=R.F_DelegationID
			LEfT JOIN TC_Delegation_Des as DD
				ON D.F_DelegationID=DD.F_DelegationID and DD.F_LanguageCode=@LanguageCode
	WHERE MR.F_MatchID = @MatchID and MR.F_CompetitionPosition=@Compos

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetDataEntryTitle] 

*/