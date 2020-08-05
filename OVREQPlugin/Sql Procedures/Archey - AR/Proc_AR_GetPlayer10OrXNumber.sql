IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_GetPlayer10OrXNumber]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_GetPlayer10OrXNumber]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--��    ��: [Proc_AR_GetPlayer10OrXNumber]
--��    ��: �����Ŀ,��ȡ10������10������
--����˵��: 
--˵    ��: 
--�� �� ��: �޿�
--��    ��: 2010��10��11��
--�޸ļ�¼��



CREATE PROCEDURE [dbo].[Proc_AR_GetPlayer10OrXNumber]
	@MatchID				INT,
	@EndDistince			INT, --�оࣺ0����̭��; 1��90m/70m; 2:70m/60m; 3:50m ; 4:30m��
	@CompetitionPosition	INT,
	@Type					int, --0��10��������1��X����
	@LanguageCode			CHAR(3) = Null,
	@Result  			    AS INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
		
	if @LanguageCode = null
	begin
	 set @LanguageCode = 'ENG'
	 END
	 
	 
	if(@EndDistince=-1 AND @Type=0)
	begin
		SET @Result = (SELECT SUM(F_Comment1)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitType = 0)
	end
	
	else 	if(@EndDistince=-1 AND @Type=1)
	begin
		SET @Result = (SELECT SUM(F_Comment2)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitType = 0)
	end
		
	else 	if(@EndDistince<>-1 AND @Type=0)
	begin
		SET @Result = (SELECT SUM(F_Comment1)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitPrecision = @EndDistince
				AND MSI.F_MatchSplitType = 0)
	end	
	
	else 	if(@EndDistince<>-1 AND @Type=1)
	begin
		SET @Result = (SELECT SUM(F_Comment2)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitPrecision = @EndDistince
				AND MSI.F_MatchSplitType = 0)
	end
	
SET NOCOUNT OFF
END

GO

/*
exec Proc_AR_GetPlayer10OrXNumber 1,1,1,1,'ENG'
*/
