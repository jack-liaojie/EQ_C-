IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDisciplineAthletes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetDisciplineAthletes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----名   称：[Proc_GetDisciplineAthletes]
----功   能：得到指定项目下的报名报项信息
----作	 者：郑金勇
----日   期：2010-08-27 

/*
	参数说明：
	序号	参数名称			参数说明
	1		@DisciplineCode		指定的比赛ID
*/

/*
	功能描述：得到指定项目下的报名报项信息。
			  
*/

/*
修改记录：
	序号	日期			修改者		修改内容
	1						

*/

CREATE PROCEDURE [dbo].[Proc_GetDisciplineAthletes]
		@DisciplineCode			AS NVARCHAR(50)
AS
BEGIN
	
SET NOCOUNT ON
	
	CREATE TABLE #Temp_Athletes(
		[运动员编号] [nvarchar](255) NULL,
		[姓名] [nvarchar](255) NULL,
		[性别] [nvarchar](255) NULL,
		[出生日期] [nvarchar](255) NULL,
		[民族] [nvarchar](255) NULL,
		[身高(cm)] [nvarchar](255) NULL,
		[体重(kg)] [nvarchar](255) NULL,
		[注册证号/会员证号] [nvarchar](255) NULL,
		[参赛单位] [nvarchar](255) NULL,
		[参赛单位代码] [nvarchar](255) NULL,
		[分计单位] [nvarchar](255) NULL,
		[分计单位代码] [nvarchar](255) NULL,
		[体操是否团体] [nvarchar](255) NULL,
		[参赛项目] [nvarchar](255) NULL,
		[参赛项目代码] [nvarchar](255) NULL,
		[报名成绩] [nvarchar](255) NULL,
		[是否预备队员] [nvarchar](255) NULL,
		[组合号码] [nvarchar](255) NULL,
		[参赛子项] [nvarchar](255) NULL,
		[子项代码] [nvarchar](255) NULL,
		[射击团体顺序] [nvarchar](255) NULL,
		[比赛服号码] [nvarchar](255) NULL,	----大球类项目专用
		[F23] [nvarchar](255) NULL,
		F_RegisterID		INT,
		F_DelegationID		INT,
		F_TeamCode			NVARCHAR(255),
		F_TeamID			INT,
		F_EventID			INT,
		F_EventSexCode		INT,
		F_PlayerRegTypeID	INT,
		F_RegisterRegTypeID			INT,
		F_TeamRegTypeID				INT,
		F_TeamLevel					INT
	)
	
	DECLARE @DisciplineID AS INT
	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode
	DECLARE @LanguageCode AS CHAR(3)
	SET @LanguageCode = 'CHN'
	
	
	----Step 1: Single Player
	INSERT INTO #Temp_Athletes(F_RegisterID, F_EventID, F_EventSexCode, F_PlayerRegTypeID, F_RegisterRegTypeID
				, 参赛项目代码, 参赛项目, 报名成绩)
	SELECT A.F_RegisterID, A.F_EventID, B.F_SexCode, B.F_PlayerRegTypeID, D.F_RegTypeID, B.F_EventCode, C.F_EventLongName
			, A.F_InscriptionResult FROM TR_Inscription AS A 
			LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
			LEFT JOIN TS_Event_Des AS C ON A.F_EventID = C.F_EventID AND C.F_LanguageCode = @LanguageCode
			LEFT JOIN TR_Register AS D ON A.F_RegisterID = D.F_RegisterID
		 WHERE B.F_DisciplineID = @DisciplineID AND B.F_PlayerRegTypeID = 1
	
	----Step 2: Double Player
	----Step 3: Team Player
	
	INSERT INTO #Temp_Athletes(F_RegisterID, F_TeamID, F_EventID, F_EventSexCode, F_PlayerRegTypeID, F_TeamRegTypeID
				, 参赛项目代码, 参赛项目, 报名成绩, 组合号码, F_TeamLevel)
	SELECT A.F_RegisterID, A.F_RegisterID, A.F_EventID, B.F_SexCode, B.F_PlayerRegTypeID, D.F_RegTypeID, B.F_EventCode, C.F_EventLongName
			, A.F_InscriptionResult, ROW_NUMBER() OVER(PARTITION BY A.F_EventID, D.F_DelegationID ORDER BY A.F_RegisterID), 0 AS F_TeamLevel FROM TR_Inscription AS A 
			LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
			LEFT JOIN TS_Event_Des AS C ON A.F_EventID = C.F_EventID AND C.F_LanguageCode = @LanguageCode
			LEFT JOIN TR_Register AS D ON A.F_RegisterID = D.F_RegisterID
		 WHERE B.F_DisciplineID = @DisciplineID AND B.F_PlayerRegTypeID IN (2, 3)
	
	
	DECLARE @Level AS INT
	SET @Level = 0
	WHILE EXISTS(SELECT C.F_RegisterID FROM #Temp_Athletes AS A LEFT JOIN TR_Register_Member AS B ON A.F_TeamID = B.F_RegisterID
					LEFT JOIN TR_Register AS C ON B.F_MemberRegisterID = C.F_RegisterID
					WHERE A.F_TeamLevel = 0 AND C.F_RegTypeID IN (2, 3))
	BEGIN
		SET @Level = @Level + 1
		UPDATE #Temp_Athletes SET F_TeamLevel = @Level WHERE F_TeamLevel = 0
		
		INSERT INTO #Temp_Athletes(F_RegisterID, F_TeamID, F_EventID, F_EventSexCode, F_PlayerRegTypeID, F_TeamRegTypeID 
				, 参赛项目代码, 参赛项目, 报名成绩, 组合号码, F_TeamLevel)
		SELECT C.F_RegisterID, C.F_RegisterID, A.F_EventID, A.F_EventSexCode, A.F_PlayerRegTypeID, C.F_RegTypeID
				, A.参赛项目代码,  A.参赛项目, A.报名成绩, A.组合号码, 0 AS F_TeamLevel 
				FROM #Temp_Athletes AS A LEFT JOIN TR_Register_Member AS B ON A.F_TeamID = B.F_RegisterID
					LEFT JOIN TR_Register AS C ON B.F_MemberRegisterID = C.F_RegisterID
					WHERE A.F_TeamLevel = @Level AND C.F_RegTypeID IN (2, 3)
		
	END
	
	SET @Level = @Level + 1
	UPDATE #Temp_Athletes SET F_TeamLevel = @Level WHERE F_TeamLevel = 0
	DECLARE @MaxLevel AS INT
	SET @MaxLevel = @Level
	SET @Level = 1
	

	
	INSERT INTO #Temp_Athletes(F_RegisterID, F_EventID, F_EventSexCode, F_PlayerRegTypeID, F_RegisterRegTypeID
			, 参赛项目代码, 参赛项目, 报名成绩, 组合号码, 比赛服号码)
	SELECT B.F_MemberRegisterID, A.F_EventID, A.F_EventSexCode, A.F_PlayerRegTypeID, C.F_RegTypeID
				, A.参赛项目代码,  A.参赛项目, A.报名成绩, A.组合号码, B.F_ShirtNumber FROM #Temp_Athletes AS A 
					LEFT JOIN TR_Register_Member AS B ON A.F_TeamID = B.F_RegisterID
					LEFT JOIN TR_Register AS C ON B.F_MemberRegisterID = C.F_RegisterID
					WHERE A.F_TeamLevel > 0 AND C.F_RegTypeID = 1


	----Step 4: Player that not Inscrption
	INSERT INTO #Temp_Athletes(F_RegisterID, F_RegisterRegTypeID)
		SELECT F_RegisterID, F_RegTypeID FROM TR_Register WHERE 
			F_RegisterID NOT IN (SELECT F_RegisterID FROM #Temp_Athletes WHERE F_RegisterRegTypeID = 1)
			AND F_RegTypeID = 1
	
	----Step 5: Non Athlete Register
	INSERT INTO #Temp_Athletes(F_RegisterID, F_RegisterRegTypeID)
		SELECT F_RegisterID, F_RegTypeID FROM TR_Register WHERE 
			F_RegisterID NOT IN (SELECT F_RegisterID FROM #Temp_Athletes WHERE F_RegisterRegTypeID = 1)
			AND F_RegTypeID NOT IN (1, 2, 3)
			
	----Step 6: Fill Register Description
	UPDATE A SET A.运动员编号 = B.F_RegisterCode, A.姓名 = F.F_LongName, A.性别 = C.F_SexLongName, A.出生日期 = LEFT(CONVERT(NVARCHAR(MAX)
		, B.F_Birth_Date, 120 ), 10), A.[身高(cm)] = B.F_Height, A.[体重(kg)] = B.F_Weight 
		, A.参赛单位代码 = D.F_DelegationCode, A.参赛单位 = E.F_DelegationLongName, A.F_DelegationID = B.F_DelegationID FROM #Temp_Athletes AS A 
		LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
		LEFT JOIN TC_Sex_Des AS C ON B.F_SexCode = C.F_SexCode AND C.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Delegation AS D ON B.F_DelegationID = D.F_DelegationID
		LEFT JOIN TC_Delegation_Des AS E ON B.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register_Des AS F ON A.F_RegisterID = F.F_RegisterID AND F.F_LanguageCode = @LanguageCode
	
			
	SELECT  [运动员编号], [姓名], [性别], [出生日期], [民族], [身高(cm)], [体重(kg)]
			, [注册证号/会员证号], [参赛单位], [参赛单位代码], [分计单位], [分计单位代码]
			, [体操是否团体], [参赛项目], [参赛项目代码], [报名成绩], [是否预备队员]
			, [组合号码], [参赛子项], [子项代码], [射击团体顺序], [比赛服号码]
			--, [F23]
			--, [F_RegisterID], [F_DelegationID], [F_TeamCode], [F_TeamID], [F_EventID]
			--, [F_EventSexCode], [F_PlayerRegTypeID], [F_RegisterRegTypeID], [F_TeamRegTypeID], [F_TeamLevel]
		 FROM #Temp_Athletes WHERE F_RegisterRegTypeID = 1 ORDER BY F_DelegationID, F_EventID
	
	RETURN

SET NOCOUNT OFF
END





GO


--EXEC Proc_GetDisciplineAthletes 'TS'