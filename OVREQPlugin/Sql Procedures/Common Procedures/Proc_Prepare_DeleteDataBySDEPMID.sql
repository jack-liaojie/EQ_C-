IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Prepare_DeleteDataBySDEPMID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Prepare_DeleteDataBySDEPMID]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Prepare_DeleteDataBySDEPMID]
--��    ��: ���� ID (������ -1, SportID, DisciplineID, EventID, PhaseID �� MatchID) ɾ�����ݿ��е�����.
--����˵��: TypeID Ϊ�κ�(TypeID = -1), SportID(Type = 0), DisciplineID(Type = 1), EventID(Type = 2), PhaseID(Type = 3) �� MatchID(Type = 4).
--˵    ��: 
--�� �� ��: �����
--��    ��: 2010��9��14�� ���ڶ�
--�޸ļ�¼��
/*			
			����					�޸���		�޸�����
			2010��9��27�� ����һ	�����		ɾ�������� TS_Event_Position �� TS_Event_Competitors ��.
*/



CREATE PROCEDURE [dbo].[Proc_Prepare_DeleteDataBySDEPMID]
	@TypeID						INT,
	@Type						INT,
	@IsDeleteTop				INT		-- �Ƿ�ɾ����������: 0 - ��ɾ��; 1 - ɾ��.
AS
BEGIN
SET NOCOUNT ON

	DECLARE @AType				INT
	DECLARE @SType				INT
	DECLARE @DType				INT
	DECLARE @EType				INT
	DECLARE @PType				INT
	DECLARE @MType				INT
	
	SET @AType = -1
	SET @SType = 0
	SET @DType = 1
	SET @EType = 2
	SET @PType = 3
	SET @MType = 4
	
	IF @Type > @MType OR @Type < @AType
	BEGIN
		RETURN
	END
	
	-- ɾ�� Match ������ (�� 19 ��)
	DELETE TS_Match_Split_Result WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
	DELETE TS_Match_Split_Member WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
	DELETE TS_Match_Split_Servant WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
	DELETE TS_Match_Split_Des WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
	DELETE TS_Match_Split_Info WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
	
	DELETE TS_Match_Servant WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
	DELETE TS_Match_Statistic WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
	DELETE TS_Match_ActionList WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
	DELETE TS_Match_Member WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
	
	-- ���� TS_Phase_Model_Match_Result �� TS_Match_Result �й���, ����Ӧ��ɾ����Щ��.
	DELETE TS_Phase_Model_Match_Result_Des WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_PhaseID, @PType, @TypeID, @Type) = 1
	DELETE TS_Phase_Model_Match_Result WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_PhaseID, @PType, @TypeID, @Type) = 1
	
	DELETE TS_Match_Model_Match_Result_Des WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
	DELETE TS_Match_Model_Match_Result WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
	DELETE TS_Match_Model WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
	
	DELETE TS_Match_Result_Des WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
	DELETE TS_Match_Result WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
	
	DELETE TS_Result_Record WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
	
	IF (@Type = @MType AND @IsDeleteTop = 1) OR @Type < @MType
	BEGIN
		-- ��������ϵ����֮��ص� MatchID �ֶ��ÿ�
		UPDATE TS_Event_Result SET F_SourceMatchID = NULL WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_SourceMatchID, @MType, @TypeID, @Type) = 1
		UPDATE TS_Phase_Result SET F_SourceMatchID = NULL WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_SourceMatchID, @MType, @TypeID, @Type) = 1
		UPDATE TS_Phase_Position SET F_SourceMatchID = NULL WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_SourceMatchID, @MType, @TypeID, @Type) = 1
		UPDATE TS_Match_Result SET F_SourceMatchID = NULL WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_SourceMatchID, @MType, @TypeID, @Type) = 1 
		UPDATE TS_Match_Result SET F_HistoryMatchID = NULL WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_HistoryMatchID, @MType, @TypeID, @Type) = 1 
		
		DELETE TS_Match_Des WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
		DELETE TS_Match WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_MatchID, @MType, @TypeID, @Type) = 1
	END
	
	IF @Type <= @PType
	BEGIN
		-- ɾ�� Phase ������ (�� 9 ��)
		DELETE TS_Phase_Position WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_PhaseID, @PType, @TypeID, @Type) = 1
		DELETE TS_Phase_Competitors WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_PhaseID, @PType, @TypeID, @Type) = 1
		DELETE TS_Phase_Result WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_PhaseID, @PType, @TypeID, @Type) = 1
		DELETE TS_Phase_MatchPoint WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_PhaseID, @PType, @TypeID, @Type) = 1
		
		DELETE TS_Phase_Model_Phase_Position WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_PhaseID, @PType, @TypeID, @Type) = 1
		DELETE TS_Phase_Model_Phase_Resut WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_PhaseID, @PType, @TypeID, @Type) = 1
		DELETE TS_Phase_Model WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_PhaseID, @PType, @TypeID, @Type) = 1
		
		IF (@Type = @PType AND @IsDeleteTop = 1) OR @Type < @PType
		BEGIN
			-- ��������ϵ����֮��ص� PhaseID �ֶ��ÿ�
			UPDATE TS_Event_Result SET F_SourcePhaseID = NULL WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_SourcePhaseID, @PType, @TypeID, @Type) = 1
			UPDATE TS_Phase_Result SET F_SourcePhaseID = NULL WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_SourcePhaseID, @PType, @TypeID, @Type) = 1
			UPDATE TS_Phase_Position SET F_SourcePhaseID = NULL WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_SourcePhaseID, @PType, @TypeID, @Type) = 1
			UPDATE TS_Phase_Position SET F_StartPhaseID = NULL WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_StartPhaseID, @PType, @TypeID, @Type) = 1
			UPDATE TS_Match_Result SET F_SourcePhaseID = NULL WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_SourcePhaseID, @PType, @TypeID, @Type) = 1 
			UPDATE TS_Match_Result SET F_StartPhaseID = NULL WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_StartPhaseID, @PType, @TypeID, @Type) = 1
			
			DELETE TS_Phase_Des WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_PhaseID, @PType, @TypeID, @Type) = 1
			DELETE TS_Phase WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_PhaseID, @PType, @TypeID, @Type) = 1
		END
	END
	
	IF @Type <= @EType
	BEGIN
		-- ɾ�� Event ������ (�� 11 ��)
		DELETE TS_Round_Des WHERE F_RoundID IN 
			(
				SELECT F_RoundID FROM TS_Round WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_EventID, @EType, @TypeID, @Type) = 1
			)
		DELETE TS_Round WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_EventID, @EType, @TypeID, @Type) = 1
		
		DELETE TS_Record_Member WHERE F_RecordID IN 
			(
				SELECT F_RecordID FROM TS_Event_Record WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_EventID, @EType, @TypeID, @Type) = 1
			)
		DELETE TS_Record_Values WHERE F_RecordID IN 
			(
				SELECT F_RecordID FROM TS_Event_Record WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_EventID, @EType, @TypeID, @Type) = 1
			)
		DELETE TS_Event_Record WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_EventID, @EType, @TypeID, @Type) = 1
		
		DELETE TS_Event_Result WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_EventID, @EType, @TypeID, @Type) = 1
		
		DELETE TR_Inscription WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_EventID, @EType, @TypeID, @Type) = 1
		
		DELETE TS_Event_Position WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_EventID, @EType, @TypeID, @Type) = 1 
		DELETE TS_Event_Competitors WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_EventID, @EType, @TypeID, @Type) = 1 
		
		IF (@Type = @EType AND @IsDeleteTop = 1) OR @Type < @EType
		BEGIN
			DELETE TS_Event_Des WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_EventID, @EType, @TypeID, @Type) = 1
			DELETE TS_Event WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_EventID, @EType, @TypeID, @Type) = 1	
		END
	END
	
	IF @Type <= @DType
	BEGIN
		-- ɾ�� Discipline ������ (�� 30 ��)
		DELETE TS_Session WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
		DELETE TS_DisciplineDate_Des WHERE F_DisciplineDateID IN 
			(
				SELECT F_DisciplineDateID FROM TS_DisciplineDate WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
			)
		DELETE TS_DisciplineDate WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
		
		DELETE TD_Discipline_Venue WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
		
		DELETE TS_Offical_Communication WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
		
		-- ������Ϣ
		DELETE TR_Uniform WHERE F_RegisterID IN 
			(
				SELECT F_RegisterID FROM TR_Register WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
			)
		DELETE TR_Register_Comment WHERE F_RegisterID IN 
			(
				SELECT F_RegisterID FROM TR_Register WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
			)
		DELETE TR_Register_Member WHERE F_RegisterID IN 
			(
				SELECT F_RegisterID FROM TR_Register WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
			)
		DELETE TR_Register_Des WHERE F_RegisterID IN 
			(
				SELECT F_RegisterID FROM TR_Register WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
			)
		DELETE TR_Register WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1 AND F_RegisterID <> -1
		
		DELETE TS_ActiveClub WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
		DELETE TS_ActiveDelegation WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
		DELETE TS_ActiveFederation WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
		DELETE TS_ActiveNOC WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
		
		-- �� Discipline �йصĻ�����
		DELETE TD_ActionType_Des WHERE F_ActionTypeID IN 
			(
				SELECT F_ActionTypeID FROM TD_ActionType WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
			)
		DELETE TD_ActionType WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
		DELETE TD_CompetitionRule_Des WHERE F_CompetitionRuleID IN 
			(
				SELECT F_CompetitionRuleID FROM TD_CompetitionRule WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
			)
		DELETE TD_CompetitionRule WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
		DELETE TD_Function_Des WHERE F_FunctionID IN 
			(
				SELECT F_FunctionID FROM TD_Function WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
			)
		DELETE TD_Function WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
		DELETE TD_Position_Des WHERE F_PositionID IN 
			(
				SELECT F_PositionID FROM TD_Position WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
			)
		DELETE TD_Position WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
		DELETE TD_Statistic_Des WHERE F_StatisticID IN 
			(
				SELECT F_StatisticID FROM TD_Statistic WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
			)
		DELETE TD_Statistic WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
		DELETE TC_IRM_Des WHERE F_IRMID IN 
			(
				SELECT F_IRMID FROM TC_IRM WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
			)
		DELETE TC_IRM WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
		DELETE TC_Decision_Des WHERE F_DecisionID IN 
			(
				SELECT F_DecisionID FROM TC_Decision WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
			)
		DELETE TC_Decision WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
		
		IF (@Type = @DType AND @IsDeleteTop = 1) OR @Type < @DType
		BEGIN
			DELETE TS_Discipline_Des WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1
			DELETE TS_Discipline WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_DisciplineID, @DType, @TypeID, @Type) = 1	
		END
	END
	
	IF @Type <= @SType
	BEGIN
		IF (@Type = @SType AND @IsDeleteTop = 1) OR @Type < @SType
		BEGIN
			DELETE TS_Sport_Config WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_SportID, @SType, @TypeID, @Type) = 1
			DELETE TS_Sport_Des WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_SportID, @SType, @TypeID, @Type) = 1	
			DELETE TS_Sport WHERE dbo.[Func_Prepare_GetSDEPMRelation](F_SportID, @SType, @TypeID, @Type) = 1
		END	
	END

SET NOCOUNT OFF
END

/*

-- Just for test
-- Match
EXEC [Proc_Prepare_DeleteDataBySDEPMID] 2244, 4, 0
EXEC [Proc_Prepare_DeleteDataBySDEPMID] 2244, 4, 1
EXEC [Proc_Prepare_DeleteDataBySDEPMID] 2245, 4, 1

-- Phase
EXEC [Proc_Prepare_DeleteDataBySDEPMID] 1033, 3, 0
EXEC [Proc_Prepare_DeleteDataBySDEPMID] 1033, 3, 1
EXEC [Proc_Prepare_DeleteDataBySDEPMID] 1034, 3, 1
EXEC [Proc_Prepare_DeleteDataBySDEPMID] 1035, 3, 1

-- Event
EXEC [Proc_Prepare_DeleteDataBySDEPMID] 58, 2, 0
EXEC [Proc_Prepare_DeleteDataBySDEPMID] 58, 2, 1
EXEC [Proc_Prepare_DeleteDataBySDEPMID] 29, 2, 1

-- Discipline
EXEC [Proc_Prepare_DeleteDataBySDEPMID] 52, 1, 0
EXEC [Proc_Prepare_DeleteDataBySDEPMID] 52, 1, 1
EXEC [Proc_Prepare_DeleteDataBySDEPMID] 58, 1, 1

-- Sport
EXEC [Proc_Prepare_DeleteDataBySDEPMID] 36, 0, 0
EXEC [Proc_Prepare_DeleteDataBySDEPMID] 36, 0, 1
EXEC [Proc_Prepare_DeleteDataBySDEPMID] 28, 0, 1

-- All
EXEC [Proc_Prepare_DeleteDataBySDEPMID] NULL, -1, 0

*/