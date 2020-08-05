IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_GetMatchOfficial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_GetMatchOfficial]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--��    �ƣ�[Proc_AR_GetMatchOfficial]
--��    �����õ�Match����ѡ�Ĳ�����Ϣ������������function��position
--����˵���� 
--˵    ����
--�� �� �ˣ��޿�
--��    �ڣ�2011��01��10��


CREATE PROCEDURE [dbo].[Proc_AR_GetMatchOfficial](
												@MatchID		    INT,
												@LanguageCode		NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 

		DECLARE @pMatchID INT 
		SET @pMatchID = (SELECT top 1 F_MatchID from TS_Match
			WHERE F_PhaseID = (SELECT top 1 F_PhaseID FROM TS_Match where F_MatchID =@MatchID)
			 ORDER BY F_MatchID)
			
	CREATE TABLE #Tmp_Table(
                                F_RegisterID      INT,
                                F_RegisterName    NVARCHAR(100),
                                F_FunctionID      INT,
                                F_Function        NVARCHAR(100),                               
                                F_PositionID      INT,
                                F_Position        NVARCHAR(100),              
                                F_OfficialGroupID      INT,
                                F_OfficialGroup        NVARCHAR(100)
							)

	INSERT INTO #Tmp_Table (F_RegisterID, F_FunctionID,F_PositionID,F_OfficialGroupID)
    SELECT B.F_RegisterID, B.F_FunctionID, B.F_PositionID,GG.F_OfficialGroupID
		FROM TS_Match_Servant AS B
		   LEFT JOIN TS_Group_Official AS GG ON GG.F_RegisterID= B.F_RegisterID 
		   WHERE F_MatchID = @pMatchID AND B.F_RegisterID IS NOT NULL ORDER BY F_ServantNum
    
    UPDATE #Tmp_Table SET F_RegisterName = B.F_LongName 
		FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName 
		FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode		
    UPDATE #Tmp_Table SET F_Position = B.F_PositionLongName
		FROM #Tmp_Table AS A LEFT JOIN TD_Position_Des AS B ON A.F_PositionID = B.F_PositionID AND B.F_LanguageCode = @LanguageCode
	UPDATE #Tmp_Table SET F_OfficialGroup = B.F_GroupShortName FROM #Tmp_Table AS A 
		LEFT JOIN dbo.TD_OfficialGroup_Des AS B ON A.F_OfficialGroupID = B.F_OfficialGroupID 
	
	SELECT F_OfficialGroup AS [Group], F_RegisterName AS LongName, F_Function AS [Function], F_Position AS [Position], F_RegisterID FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


