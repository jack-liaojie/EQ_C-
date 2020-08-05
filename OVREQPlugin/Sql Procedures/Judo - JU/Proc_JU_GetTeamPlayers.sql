IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetTeamPlayers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetTeamPlayers]
GO
/****** Object:  StoredProcedure [dbo].[Proc_JU_GetTeamPlayers]    Script Date: 12/27/2010 13:44:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










--名    称：[[Proc_JU_GetTeamPlayers]]
--描    述：得到Match下得队的可选运动员列表
--参数说明： 
--说    明：
--创 建 人：宁顺泽
--日    期：2010年10月08日


CREATE PROCEDURE [dbo].[Proc_JU_GetTeamPlayers](
												@MatchID		    INT,
                                                @Position           INT,
												@LanguageCode		CHAR(3),
												@WeighClass			INT =-1
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                F_RegisterID      INT,
                                F_RegisterName    NVARCHAR(100)
							)
							
	CREATE TABLE #Tmp_Weigh(
								F_Order				INT,
								F_WeighClass		NVARCHAR(20)
							)
	
	
	DECLARE @Sex		INT
	select @Sex=E.F_SexCode from TS_Match AS M
	LEFT JOIN TS_Phase aS P
		ON M.F_PhaseID=P.F_PhaseID
	LEFT JOIN TS_Event AS E
		ON P.F_EventID=E.F_EventID
	WHERE M.F_MatchID=@MatchID
	
	IF @WeighClass<>-1
	BEGIN
		if @Sex=1
		BEGIN
			INSERT INTO #Tmp_Weigh(F_Order,F_WeighClass) values(1,N'-66 KG')
			INSERT INTO #Tmp_Weigh(F_Order,F_WeighClass) values(2,N'-73 KG')
			INSERT INTO #Tmp_Weigh(F_Order,F_WeighClass) values(3,N'-81 KG')
			INSERT INTO #Tmp_Weigh(F_Order,F_WeighClass) values(4,N'-90 KG')
			INSERT INTO #Tmp_Weigh(F_Order,F_WeighClass) values(5,N'+90 KG')
			select F_WeighClass,F_Order From #Tmp_Weigh
		END
		ELSE
			
		BEGIN
			INSERT INTO #Tmp_Weigh(F_Order,F_WeighClass) values(1,N'-52 KG')
			INSERT INTO #Tmp_Weigh(F_Order,F_WeighClass) values(2,N'-57 KG')
			INSERT INTO #Tmp_Weigh(F_Order,F_WeighClass) values(3,N'-63 KG')
			INSERT INTO #Tmp_Weigh(F_Order,F_WeighClass) values(4,N'-70 KG')
			INSERT INTO #Tmp_Weigh(F_Order,F_WeighClass) values(5,N'+70 KG')
			select F_WeighClass,F_Order From #Tmp_Weigh
		END
	END
	ELSE
	BEGIN
		DECLARE @TeamID INT
		SELECT @TeamID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @Position

		INSERT INTO #Tmp_Table (F_RegisterID)
		SELECT F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @TeamID

		UPDATE #Tmp_Table SET F_RegisterName = B.F_LongName FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode

		SELECT F_RegisterName, F_RegisterID FROM #Tmp_Table
	END
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF





GO


