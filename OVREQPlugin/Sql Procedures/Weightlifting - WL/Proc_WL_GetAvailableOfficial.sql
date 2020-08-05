IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_GetAvailableOfficial]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_GetAvailableOfficial]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--名    称：[Proc_WL_GetAvailableOfficial]
--描    述：得到Match下可选的裁判信息
--参数说明： 
--说    明：
--创 建 人：崔凯
--日    期：2011年01月26日


CREATE PROCEDURE [dbo].[Proc_WL_GetAvailableOfficial](
                                                @DisciplineID       INT,
												@MatchID		    INT,
												@LanguageCode		NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 

	DECLARE @pMatchID INT 
		SET @pMatchID = (SELECT top 1 F_MatchID from TS_Match
			WHERE F_MatchCode ='01' AND F_PhaseID = (SELECT top 1 F_PhaseID FROM TS_Match where F_MatchID =@MatchID)
			 ORDER BY F_MatchID)
			
	CREATE TABLE #Tmp_Table(
                                F_RegisterID      INT,
                                F_RegisterName    NVARCHAR(100),
                                F_FunctionID      INT,
                                F_Function        NVARCHAR(100),              
                                F_OfficialGroupID      INT,
                                F_OfficialGroup        NVARCHAR(100),          
                                F_PositionID      INT
							)

    DECLARE @EventID INT
    SELECT @EventID = B.F_EventID FROM TS_Match AS A 
    LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchID = @pMatchID

    IF(@DisciplineID > 0)
    BEGIN
          INSERT INTO #Tmp_Table (F_RegisterID, F_FunctionID,F_OfficialGroupID,F_PositionID)
           SELECT B.F_RegisterID, ISNULL(GG.F_FunctionID,B.F_FunctionID),GG.F_OfficialGroupID,GG.F_PositionID FROM TR_Register AS B
		   LEFT JOIN TS_Group_Official AS GG ON GG.F_RegisterID= B.F_RegisterID
               WHERE F_DisciplineID = @DisciplineID AND (F_RegTypeID = 4 OR F_RegTypeID = 5)
               AND B.F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Match_Servant 
											WHERE F_MatchID = @pMatchID AND F_RegisterID IS NOT NULL)
    END
    ELSE
    BEGIN
       	  INSERT INTO #Tmp_Table (F_RegisterID, F_FunctionID,F_OfficialGroupID,F_PositionID)
           SELECT B.F_RegisterID,ISNULL(GG.F_FunctionID,B.F_FunctionID),GG.F_OfficialGroupID,GG.F_PositionID  FROM TR_Register AS B
		   LEFT JOIN TS_Group_Official AS GG ON GG.F_RegisterID= B.F_RegisterID
               WHERE F_DisciplineID = @DisciplineID AND (F_RegTypeID = 4 OR F_RegTypeID = 5)
               AND B.F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Match_Servant 
											WHERE F_MatchID = @pMatchID AND F_RegisterID IS NOT NULL)
    END
    
    UPDATE #Tmp_Table SET F_RegisterName = B.F_LongName FROM #Tmp_Table AS A 
		LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
    UPDATE #Tmp_Table SET F_Function = B.F_FunctionLongName FROM #Tmp_Table AS A 
		LEFT JOIN TD_Function_Des AS B ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode = @LanguageCode
	UPDATE #Tmp_Table SET F_OfficialGroup = B.F_GroupShortName FROM #Tmp_Table AS A 
		LEFT JOIN dbo.TD_OfficialGroup_Des AS B ON A.F_OfficialGroupID = B.F_OfficialGroupID 
		
	SELECT F_OfficialGroup AS [Group], F_RegisterName AS LongName, F_Function AS [Function], F_RegisterID, F_FunctionID,F_OfficialGroupID,F_PositionID FROM #Tmp_Table
	ORDER BY F_FunctionID
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


/*
EXEC Proc_WL_GetAvailableOfficial 1,73,'eng'
*/

