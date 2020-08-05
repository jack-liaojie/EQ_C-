
/****** Object:  StoredProcedure [dbo].[Proc_TE_CreatTeamForDelegation]    Script Date: 03/07/2011 20:19:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_CreatTeamForDelegation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_CreatTeamForDelegation]
GO


/****** Object:  StoredProcedure [dbo].[Proc_TE_CreatTeamForDelegation]    Script Date: 03/07/2011 20:19:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_TE_CreatTeamForDelegation]
----功		  能：自动注册代表团信息
----作		  者：李燕
----日		  期: 2011-2-22

CREATE PROCEDURE [dbo].[Proc_TE_CreatTeamForDelegation]
			@DiscplineCode NVARCHAR(10),
			@EventID       INT,
			@SexCode       INT
AS
BEGIN
	SET NOCOUNT ON
	
	--存在则先删除
	IF EXISTS (SELECT * FROM TR_Register WHERE F_RegTypeID = 3 AND F_SexCode = @SexCode)
	BEGIN
		DELETE FROM TR_Register_Des WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_RegTypeID = 3 AND F_SexCode = @SexCode)
		DELETE FROM TR_Inscription WHERE F_EventID = @EventID
		DELETE FROM TS_Event_Result WHERE F_EventID = @EventID
		DELETE FROM TR_Register WHERE F_RegTypeID = 3 AND F_SexCode = @SexCode
	END
		
			
	--生成新的注册团队，RegisterCode暂时为DelegationCode	  
	DECLARE @TmpDlgID INT
	DECLARE @DiscplineID INT
	SELECT @DiscplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DiscplineCode 
	
	DECLARE @DlgCode NVARCHAR(20)
	DECLARE @NewRegID INT
	DECLARE tmp_cursor CURSOR FOR SELECT DISTINCT(F_DelegationID) FROM TR_Register WHERE F_DelegationID IS NOT NULL AND F_RegTypeID IN (1,2)
	OPEN tmp_cursor
	FETCH NEXT FROM tmp_cursor INTO @TmpDlgID
	WHILE @@FETCH_STATUS=0
		BEGIN
			SELECT @DlgCode = F_DelegationCode FROM TC_Delegation WHERE F_DelegationID = @TmpDlgID
			INSERT INTO TR_Register (F_RegTypeID, F_DelegationID, F_RegisterCode, F_DisciplineID, F_SexCode) 
					VALUES(3, @TmpDlgID, @DlgCode, @DiscplineID, @SexCode)
			SET @NewRegID = @@IDENTITY
			
			UPDATE TR_Register SET F_RegisterCode = @DlgCode+ N'TE' + Right('00000' + CAST( @NewRegID AS NVARCHAR(10)), 5) WHERE F_RegisterID = @NewRegID
			
			INSERT INTO TR_Register_Des (F_RegisterID, F_LanguageCode, F_LongName, F_ShortName, F_PrintLongName, F_PrintShortName,
							F_SBLongName, F_SBShortName, F_TvLongName, F_TvShortName)
			(SELECT @NewRegID, F_LanguageCode, F_DelegationLongName, F_DelegationShortName, F_DelegationLongName, F_DelegationShortName,
					F_DelegationLongName, F_DelegationShortName,F_DelegationLongName, F_DelegationShortName
			 FROM TC_Delegation_Des 
			WHERE F_DelegationID = @TmpDlgID AND F_LanguageCode = 'ENG'
			)
			
			INSERT INTO TR_Register_Des (F_RegisterID, F_LanguageCode, F_LongName, F_ShortName, F_PrintLongName, F_PrintShortName,
							F_SBLongName, F_SBShortName, F_TvLongName, F_TvShortName)
			(SELECT @NewRegID, F_LanguageCode, F_DelegationLongName, F_DelegationShortName, F_DelegationLongName, F_DelegationShortName,
					F_DelegationLongName, F_DelegationShortName,F_DelegationLongName, F_DelegationShortName
			 FROM TC_Delegation_Des 
			WHERE F_DelegationID = @TmpDlgID AND F_LanguageCode = 'CHN'
			)
				
			INSERT INTO TR_Inscription (F_EventID, F_RegisterID) VALUES(@EventID, @NewRegID)
			FETCH NEXT FROM tmp_cursor INTO @TmpDlgID
		END
	CLOSE tmp_cursor
	DEALLOCATE tmp_cursor
END



GO


