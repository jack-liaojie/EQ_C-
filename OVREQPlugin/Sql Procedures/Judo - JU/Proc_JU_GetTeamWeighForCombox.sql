IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetTeamWeighForCombox]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetTeamWeighForCombox]
GO
/****** Object:  StoredProcedure [dbo].[Proc_JU_GetTeamWeighForCombox]    Script Date: 12/27/2010 13:44:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_JU_GetTeamWeighForCombox]
--描    述：得到Match下得队的可选运动员列表
--参数说明： 
--说    明：
--创 建 人：宁顺泽
--日    期：2011年07月18日


CREATE PROCEDURE [dbo].[Proc_JU_GetTeamWeighForCombox](
												@MatchID		    INT
)
As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
							
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


SET	NOCOUNT OFF


END

/*

exec [Proc_JU_GetTeamWeighForCombox] 50


*/