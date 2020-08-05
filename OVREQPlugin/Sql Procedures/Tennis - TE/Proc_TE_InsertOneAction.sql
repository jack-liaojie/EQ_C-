IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_InsertOneAction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_InsertOneAction]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�[Proc_TE_InsertOneAction]
----��		  �ܣ�������Ŀ,����һ������Ʒֶ���
----��		  �ߣ�֣���� 
----��		  ��: 2010-10-02
----�� ��  �� ¼��
/*
                   ����   2011-2-17   ����@ResultPoint����
                   ����   2011-4-12   ����@ActionDetail8��������F_ActionDetail8 ΪGamePoint��SetPoint��MatchPoint�Ĳ���˵����
                                      ��ΪGamePointʱ������Point��PositionΪ�ӷ��򷽣���F_ActionDetail8��ʾBreakPoint
                   
                   ����   2011-6-29   ��MatchSplitID����ΪSubMatchCode������������
                   
*/

CREATE PROCEDURE [dbo].[Proc_TE_InsertOneAction] (	
	@MatchID						INT,
	@SubMatchCode					INT,   ---- -1��Ϊ������
	@CompetitionPosition			INT,
	@ServerPosition					INT,
	@PointPosition					INT,
	@ActionTime						DATETIME,
	@ActionType						INT,						
	@SetNum							INT,
	@GameNum						INT,
	@ActionPart1					INT,
	@ActionPart2					INT,
	@ActionPart3					INT,
	@MatchResultXml					NVARCHAR(MAX),
	@ScoreDes						NVARCHAR(50),
	@CriticalPointPosition			INT,
	@CriticalPoint					NVARCHAR(50),
	@Fault							INT,
	@ResultPoint                    INT,
	@BreakPoint                     INT,
	@BreakPointPos                  INT,
	@Result							INT OUTPUT
)	
AS
BEGIN
SET NOCOUNT ON


	SET @Result = 0 -- @Result = 0; 	����һ������Ʒֶ���ʧ�ܣ���ʾû�����κβ�����
					-- @Result =-1;		����һ������Ʒֶ���ʧ�ܣ��ṩ��@MatchID��Ч��
					-- @Result = 1; 	����һ������Ʒֶ����ɹ���


	IF NOT EXISTS (SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result =-1
		RETURN
	END

	IF NOT EXISTS (SELECT F_ActionTypeID FROM TD_ActionType WHERE F_ActionTypeID = @ActionType AND F_ActionTypeID < 0)
	BEGIN
		SET @Result =-1
		RETURN
	END
	
	DECLARE @MatchSplitID  INT
	SET @MatchSplitID = 0
	
	IF(@SubMatchCode <> -1)
	BEGIN
	    SELECT @MatchSplitID = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SubMatchCode AND F_FatherMatchSplitID = 0
	END
	--IF(@ResultDes IS NULL OR LEN(@ResultDes) = 0)
	--BEGIN
	--    SET @ResultDes = @ScoreDes
	--END
	
	DECLARE @ActionOrder AS INT
	SELECT @ActionOrder = ISNULL(MAX(F_ActionOrder), 0) + 1 FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_ActionTypeID = @ActionType
	
	DECLARE @ActionDetail8 AS INT
	----��ĿǰActionΪGamePoint������GamePoint��Position��BreakPointPositionһ��������ActionDetail8�д��BreakPoint����Ϣ
	IF(@CriticalPoint = 1 AND @CriticalPointPosition = @BreakPointPos AND @BreakPointPos <> 0)
	BEGIN
	     SET @ActionDetail8 = @BreakPoint
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION
	
	BEGIN TRY
			 
			INSERT INTO TS_Match_ActionList (F_ActionOrder, F_MatchID, F_MatchSplitID, F_CompetitionPosition, F_ServerPosition, F_PointPosition, F_ActionHappenTime
				, F_ActionTypeID, F_ActionDetail1, F_ActionDetail2, F_ActionDetail3, F_ActionDetail4, F_ActionDetail5, F_ActionDetail6, F_ActionXMLComment, F_ScoreDes, F_CriticalPointPosition, F_CriticalPoint, F_ActionDetail7, F_ActionDetail8)
				VALUES (@ActionOrder, @MatchID, @MatchSplitID, @CompetitionPosition, @ServerPosition, @PointPosition, @ActionTime
				, @ActionType, @SetNum, @GameNum, @ActionPart1, @ActionPart2, @ActionPart3, @Fault, @MatchResultXml, @ScoreDes, @CriticalPointPosition, @CriticalPoint, @ResultPoint, @ActionDetail8)
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
			
		SET @Result = 0
		RETURN 
	
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
		
	SET @Result = 1
	RETURN 
	
SET NOCOUNT OFF
END





GO

 --EXEC [Proc_AddCompetitionRule] 1
