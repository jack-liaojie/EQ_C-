IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_UpdateRegister2DB]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_UpdateRegister2DB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----名   称：[Proc_UpdateRegister2DB]
----功   能：将临时表中的人员和报项信息更新到数据库
----作	 者：郑金勇
----日   期：2011-06-12 

/*
	参数说明：
	序号	参数名称			参数说明
	1		@DisciplineCode		指定的比赛Code
*/

/*
	功能描述：此存储过程的不能够进行报名报项数据的更新，
			  理想做法是报名数据更新和增加，报项数据只能够增加。
			  
*/

/*
修改记录：
	序号	日期			修改者		修改内容
	1						

*/

CREATE PROCEDURE [dbo].[proc_UpdateRegister2DB] 
	@DisciplineCode			NVARCHAR(50),
	@Result 				AS INT OUTPUT
	
AS
BEGIN

SET NOCOUNT ON

	SET @Result = 0
	
		
		
	DECLARE @DisciplineID AS INT
	SELECT 	@DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
		DELETE FROM Temp_Athletes WHERE 运动员编号 IS NULL
		DELETE FROM Temp_Athletes WHERE 运动员编号 = ''
	
		UPDATE A SET A.F_DelegationID = B.F_DelegationID FROM Temp_Athletes AS A LEFT JOIN TC_Delegation AS B ON A.参赛单位代码 = B.F_DelegationCode
	
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
	
		INSERT INTO TR_Register(F_RegisterCode, F_RegTypeID, F_SexCode, F_Birth_Date, F_Height, F_Weight, F_Bib, F_DelegationID, F_DisciplineID)
			SELECT DISTINCT 运动员编号, 1, CASE 性别 WHEN '男' THEN 1 WHEN '女' THEN 2 ELSE NULL END, 出生日期, CASE [身高(cm)] WHEN N'' THEN NULL ELSE [身高(cm)] END
			, CASE [体重(kg)] WHEN N'' THEN NULL ELSE [体重(kg)] END, CASE [比赛服号码] WHEN N'' THEN NULL ELSE [比赛服号码] END
			, F_DelegationID, @DisciplineID
				FROM Temp_Athletes WHERE 运动员编号 IS NOT NULL 
	
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		UPDATE A SET A.F_RegisterID = B.F_RegisterID FROM Temp_Athletes AS A LEFT JOIN TR_Register AS B ON A.运动员编号 = B.F_RegisterCode 
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		INSERT INTO TR_Register_Des (F_RegisterID, F_LanguageCode, F_LongName, F_ShortName, F_PrintLongName, F_PrintShortName, F_SBLongName, F_SBShortName, F_TvLongName, F_TvShortName)
			SELECT DISTINCT F_RegisterID, 'CHN', 姓名, 姓名, 姓名, 姓名, 姓名, 姓名, 姓名, 姓名 FROM Temp_Athletes WHERE F_RegisterID IS NOT NULL
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		

		UPDATE A SET A.F_EventID = B.F_EventID, A.F_EventSexCode = B.F_SexCode, A.F_PlayerRegTypeID = B.F_PlayerRegTypeID 
			FROM Temp_Athletes AS A LEFT JOIN TS_Event AS B ON REPLACE(A.参赛项目代码, @DisciplineCode, '') = REPLACE(B.F_EventCode, @DisciplineCode, '')
			
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END		
		
		UPDATE Temp_Athletes SET F_TeamCode = @DisciplineCode + 参赛单位代码 + 参赛项目代码 + RIGHT((N'000'+ 组合号码), 3)
			WHERE 参赛单位代码 IS NOT NULL AND 参赛项目代码 IS NOT NULL AND 组合号码 IS NOT NULL AND 运动员编号 IS NOT NULL
				AND F_PlayerRegTypeID IN (2,3)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END		
		
		INSERT INTO TR_Register(F_RegisterCode, F_RegTypeID, F_SexCode, F_DelegationID, F_DisciplineID)
			SELECT DISTINCT F_TeamCode, F_PlayerRegTypeID, F_EventSexCode, F_DelegationID, @DisciplineID
				FROM Temp_Athletes WHERE F_TeamCode IS NOT NULL 
				
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END	
		
		UPDATE A SET A.F_TeamID = B.F_RegisterID FROM Temp_Athletes AS A LEFT JOIN TR_Register AS B ON A.F_TeamCode = B.F_RegisterCode 
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		INSERT INTO TR_Register_Des (F_RegisterID, F_LanguageCode, F_LongName, F_ShortName, F_PrintLongName, F_PrintShortName, F_SBLongName, F_SBShortName, F_TvLongName, F_TvShortName)
			SELECT DISTINCT F_TeamID, 'CHN', F_DelegationLongName, F_DelegationLongName, F_DelegationLongName, F_DelegationLongName, F_DelegationLongName, F_DelegationLongName, F_DelegationLongName, F_DelegationLongName FROM
			(SELECT DISTINCT A.F_TeamID, B.F_DelegationLongName FROM Temp_Athletes AS A 
			LEFT JOIN TC_Delegation_Des AS B ON A.F_DelegationID = B.F_DelegationID WHERE F_TeamID IS NOT NULL AND B.F_LanguageCode = 'CHN') AS A
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
	
		
		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order) 
			SELECT F_TeamID, F_RegisterID, ROW_NUMBER() OVER(PARTITION  BY F_TeamID ORDER BY F_RegisterID) AS F_Order FROM
			(
			SELECT DISTINCT F_TeamID, F_RegisterID FROM Temp_Athletes WHERE F_TeamID IS NOT NULL AND F_RegisterID IS NOT NULL
			) AS A
			
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
			
		DECLARE @StrSql AS NVARCHAR(MAX)
		SET @StrSql = ''
		
		SELECT @StrSql = @StrSql + ' ; ' +  N'EXEC proc_UpdateDoubleName ' + CAST(F_RegisterID AS NVARCHAR(100)) + N', ''CHN'', NULL'  from TR_Register where F_RegTypeID = 2
		
		EXEC (@StrSql)
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		INSERT INTO TS_ActiveDelegation (F_DelegationID, F_DisciplineID, F_Order)
			SELECT F_DelegationID, F_DisciplineID, ROW_NUMBER() OVER ( ORDER BY F_DelegationID) FROM
			(
			SELECT  DISTINCT F_DelegationID, F_DisciplineID FROM TR_Register WHERE F_DelegationID IS NOT NULL AND F_DisciplineID IS NOT NULL
			EXCEPT 
			SELECT F_DelegationID, F_DisciplineID FROM TS_ActiveDelegation
			) AS A
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		INSERT INTO TR_Inscription (F_EventID, F_RegisterID) 
		SELECT DISTINCT F_EventID, F_RegisterID FROM Temp_Athletes WHERE F_PlayerRegTypeID = 1
		EXCEPT SELECT F_EventID, F_RegisterID FROM TR_Inscription
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		INSERT INTO TR_Inscription (F_EventID, F_RegisterID) SELECT DISTINCT F_EventID, F_TeamID FROM Temp_Athletes WHERE F_PlayerRegTypeID IN (2, 3)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Athletes]') AND type in (N'U'))
		BEGIN
			DROP TABLE [dbo].[Temp_Athletes]
			
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		


	COMMIT TRANSACTION --成功提交事务
	
	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END






GO


--EXEC proc_UpdateRegister2DB 'TE', 0
--GO