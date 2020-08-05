if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_AddPhase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_AddPhase]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

----名   称：[proc_AddPhase]
----功   能：添加一个Phase，主要是为编排服务
----作	 者：郑金勇
----日   期：2009-04-08 

/*
	参数说明：
	序号	参数名称				参数说明

*/

/*
	功能描述：添加一个Phase，主要是为编排服务。
			  
*/

/*
修改记录：
	序号	日期			修改者		修改内容
	1		2012-08-24		郑金勇		添加@PhaseType的描述，并且根据Phase的父节点的PhaseType类型决定自身的PhaseType。主要是21和31。				

*/

CREATE PROCEDURE proc_AddPhase 
	@EventID			INT,
	@FatherPhaseID		INT,
	@PhaseCode			NVARCHAR(10),
	@OpenDate			DATETIME,
	@CloseDate			DATETIME,
	@PhaseStatusID		INT,
	@PhaseNodeType		INT,
	@Order				INT,
	@PhaseType			INT,--1表示指示性的Phase节点，2表示小组赛的Phase节点, 21表示小组赛下的每一轮的phase节点，3表示淘汰赛的根Phase节点，31表示淘汰赛下每一轮的淘汰赛的Phase节点。
	@PhaseSize			INT,
	@PhaseRankSize		INT,
	@PhaseIsQual		INT,
	@PhaseInfo			NVARCHAR(50),
	@languageCode		CHAR(3),
	@PhaseLongName		NVARCHAR(100),
	@PhaseShortName		NVARCHAR(50),
	@PhaseComment		NVARCHAR(100),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加Phase失败，标示没有做任何操作！
					-- @Result>=1; 	添加Phase成功！此值即为PhaseID
					-- @Result=-1; 	添加Phase失败，@EventID无效、@FatherPhaseID无效
					-- @Result=-2; 	添加Phase失败，该节点的状态不允许添加Phase
	DECLARE @NewPhaseID AS INT	

	IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF @FatherPhaseID != 0
	BEGIN
		IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseID = @FatherPhaseID)
		BEGIN
			SET @Result = -1
			RETURN
		END
	END

	DECLARE @ParentStatusID AS INT
	
	IF @FatherPhaseID = 0
	BEGIN
		SELECT @ParentStatusID = F_EventStatusID FROM TS_Event WHERE F_EventID = @EventID
	END
	ELSE 
	BEGIN
		SELECT @ParentStatusID = F_PhaseStatusID FROM TS_Phase WHERE F_PhaseID = @FatherPhaseID 
	END

	IF @ParentStatusID > 10 
	BEGIN
		SET @Result = -2
		RETURN
	END


	IF @Order = 0 OR @Order IS NULL
	BEGIN
		SELECT @Order = (CASE WHEN MAX(F_Order) IS NULL THEN 0 ELSE MAX(F_Order) END) + 1 FROM TS_Phase WHERE F_EventID = @EventID AND F_FatherPhaseID = @FatherPhaseID
	END

	IF @PhaseStatusID IS NULL
	BEGIN
		SET @PhaseStatusID = 10
	END

	DECLARE @FatherPhaseType AS INT
	IF @FatherPhaseID != 0
	BEGIN
		SELECT @FatherPhaseType = F_PhaseType FROM TS_Phase WHERE F_PhaseID = @FatherPhaseID
	END

	IF(@PhaseType=1 AND @FatherPhaseID != 0)
	BEGIN
		IF @FatherPhaseType = 2
		BEGIN
			SET @PhaseType = 21
		END
		ELSE IF @FatherPhaseType = 3
		BEGIN
			SET @PhaseType = 31
		END
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TS_PHASE (F_EventID, F_FatherPhaseID, F_PhaseCode, F_OpenDate, F_CloseDate, F_PhaseStatusID, F_PhaseNodeType, F_Order, F_PhaseType, F_PhaseSize, F_PhaseRankSize, F_PhaseIsQual, F_PhaseInfo)
    		VALUES (@EventID, @FatherPhaseID, @PhaseCode, @OpenDate, @CloseDate, @PhaseStatusID, @PhaseNodeType, @Order, @PhaseType, @PhaseSize, @PhaseRankSize, @PhaseIsQual, @PhaseInfo)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		SET @NewPhaseID = @@IDENTITY

		insert into TS_PHASE_DES (F_PhaseID, F_LanguageCode, F_PhaseLongName, F_PhaseShortName, F_PhaseComment)
			VALUES (@NewPhaseID, @languageCode, @PhaseLongName, @PhaseShortName, @PhaseComment)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewPhaseID
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

