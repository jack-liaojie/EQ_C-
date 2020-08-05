IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_GetMatchGroupOfficial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_GetMatchGroupOfficial]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--��    �ƣ�[Proc_WL_GetMatchGroupOfficial]
--��    �����õ�Match����ѡ�Ĳ�������Ϣ������������function��position
--����˵���� 
--˵    ����
--�� �� �ˣ��޿�
--��    �ڣ�2011��5��31��


CREATE PROCEDURE [dbo].[Proc_WL_GetMatchGroupOfficial](
												@OfficialGroupID    INT,
												@LanguageCode		NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 

			
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

	INSERT INTO #Tmp_Table (F_RegisterID, F_FunctionID,F_PositionID,F_OfficialGroupID,F_OfficialGroup)
    SELECT GG.F_RegisterID, ISNULL(GG.F_FunctionID,F.F_FunctionID), GG.F_PositionID,GG.F_OfficialGroupID,GD.F_GroupLongName
		FROM TS_Group_Official AS GG
		LEFT JOIN TD_OfficialGroup_Des AS GD ON GD.F_OfficialGroupID= GG.F_OfficialGroupID
		LEFT JOIN TR_Register AS R ON R.F_RegisterID= GG.F_RegisterID
		LEFT JOIN TD_Function AS F ON F.F_FunctionID= R.F_FunctionID
		WHERE GG.F_OfficialGroupID = @OfficialGroupID AND GG.F_RegisterID IS NOT NULL 
		  
    
    UPDATE #Tmp_Table SET F_RegisterName = B.F_LongName 
		FROM #Tmp_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName 
		FROM #Tmp_Table AS A LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode		
    UPDATE #Tmp_Table SET F_Position = B.F_PositionLongName
		FROM #Tmp_Table AS A LEFT JOIN TD_Position_Des AS B ON A.F_PositionID = B.F_PositionID AND B.F_LanguageCode = @LanguageCode

	SELECT F_RegisterName AS LongName, F_Function AS [Function], F_Position AS [Position], F_RegisterID FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


/*
EXEC Proc_WL_GetMatchGroupOfficial 1,'ENG'
*/
GO


