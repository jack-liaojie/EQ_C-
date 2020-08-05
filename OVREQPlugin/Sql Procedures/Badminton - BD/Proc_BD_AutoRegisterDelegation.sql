IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_AutoRegisterDelegation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_AutoRegisterDelegation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----�洢�������ƣ�[Proc_BD_AutoRegisterDelegation]
----��		  �ܣ��Զ�ע���������Ϣ
----��		  �ߣ���ǿ
----��		  ��: 2010-12-20
----�޸ģ�2011-02-22�����Ӵ���������

CREATE PROCEDURE [dbo].[Proc_BD_AutoRegisterDelegation]
			@DiscplineCode NVARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON
	
	--��������ɾ��
	IF EXISTS (SELECT * FROM TR_Register WHERE F_RegTypeID = 3)
	BEGIN
		DELETE FROM TS_Event_Result WHERE F_EventID = (SELECT F_EventID FROM TS_Event WHERE F_PlayerRegTypeID = 3 )
		DELETE FROM TR_Register_Member WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_RegTypeID = 3)
		DELETE FROM TR_Register_Des WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_RegTypeID = 3)
		DELETE FROM TR_Inscription WHERE F_RegisterID IN (SELECT F_RegisterID FROM TR_Register WHERE F_RegTypeID = 3)
		DELETE FROM TR_Register WHERE F_RegTypeID = 3
	END
		
			
	--�����µ�ע���Ŷӣ�RegisterCode��ʱΪDelegationCode
	DECLARE @MixedEventID INT
	DECLARE @TmpDlgID INT
	DECLARE @DiscplineID INT
	SELECT @DiscplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DiscplineCode
	
	SELECT @MixedEventID = F_EventID FROM TS_Event WHERE F_SexCode = 3
	DECLARE @DlgCode NVARCHAR(20)
	DECLARE @NewRegID INT
	DECLARE tmp_cursor CURSOR FOR SELECT DISTINCT(F_DelegationID) FROM TR_Register WHERE F_DelegationID IS NOT NULL
	OPEN tmp_cursor
	FETCH NEXT FROM tmp_cursor INTO @TmpDlgID
	DECLARE @RegCodeInt INT = 100000
	WHILE @@FETCH_STATUS=0
		BEGIN
			--��������RegCode
			SET @RegCodeInt = @RegCodeInt + 1
			
			--�������ӵ�RegCode
			SELECT @DlgCode = F_DelegationCode + 'BDM' + RIGHT( CONVERT( NVARCHAR(10), @RegCodeInt ), 4) FROM TC_Delegation WHERE F_DelegationID = @TmpDlgID
			
			INSERT INTO TR_Register (F_RegTypeID, F_DelegationID, F_RegisterCode, F_DisciplineID, F_SexCode) 
					VALUES(3, @TmpDlgID, @DlgCode, @DiscplineID, 1)
			SET @NewRegID = @@IDENTITY
			
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
				
			INSERT INTO TR_Inscription (F_EventID, F_RegisterID) VALUES(1, @NewRegID)
			
			--���Ů�ӵ�
			SELECT @DlgCode = F_DelegationCode + 'BDW' + RIGHT( CONVERT( NVARCHAR(10), @RegCodeInt ), 4) FROM TC_Delegation WHERE F_DelegationID = @TmpDlgID
			
			INSERT INTO TR_Register (F_RegTypeID, F_DelegationID, F_RegisterCode, F_DisciplineID, F_SexCode) 
					VALUES(3, @TmpDlgID, @DlgCode, @DiscplineID, 2)
			SET @NewRegID = @@IDENTITY
			
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
				
			INSERT INTO TR_Inscription (F_EventID, F_RegisterID) VALUES(2, @NewRegID)
			
			
			FETCH NEXT FROM tmp_cursor INTO @TmpDlgID
		END
	CLOSE tmp_cursor
	DEALLOCATE tmp_cursor
END

GO
--exec Proc_BD_AutoRegisterDelegation 'BD'