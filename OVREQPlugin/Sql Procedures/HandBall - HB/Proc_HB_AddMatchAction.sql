

/****** Object:  StoredProcedure [dbo].[Proc_HB_AddMatchAction]    Script Date: 08/30/2012 08:24:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HB_AddMatchAction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HB_AddMatchAction]
GO


/****** Object:  StoredProcedure [dbo].[Proc_HB_AddMatchAction]    Script Date: 08/30/2012 08:24:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--��    �ƣ�[Proc_HB_AddMatchAction]
--��    ��������Match��Action��Ϣ
--����˵���� 
--˵    ����
--�� �� �ˣ�����
--��    �ڣ�2010��03��10��


CREATE PROCEDURE [dbo].[Proc_HB_AddMatchAction](
                                                @ActionID           INT = -1,
												@MatchID		    INT,
												@MatchSplitID       INT,
                                                @RegisterID         INT,
                                                @TeamPos            INT,
                                                @ActionCode         NVARCHAR(20),
                                                @ActionHappenTime   DateTime,
                                                @ActionType         INT,          ----0:����Action��1����ԱAction��2������Action
                                                @ActionKey          INT,
                                                @ActionDetail1      INT,
                                                @ActionDetail2      INT,
                                                @ActionDetail3      INT,
                                                @ActionDes          NVARCHAR(50),
                                                @ActionXML          NVARCHAR(MAX),  
                                                @Result             AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result = 0   -- @Result=0; 	�޸�ʧ�ܣ���ʾû�����κβ�����
					  -- @Result>=1; 	�޸ĳɹ���
					  -- @Result=-1; 	�޸�ʧ��, @ActionType��Ч	
    
    DECLARE @NewActionID   INT
    DECLARE @DisciplineID  INT
    DECLARE @ActionTypeID  INT
    DECLARE @ActionOrder   INT
    
    IF(@ActionID <> -1 AND EXISTS (SELECT F_ActionNumberID FROM TS_Match_ActionList WHERE F_ActionNumberID = @ActionID))
    BEGIN
       UPDATE TS_Match_ActionList  SET F_MatchID = @MatchID, F_MatchSplitID = @MatchSplitID, F_CompetitionPosition = @TeamPos,
                                      F_RegisterID = @RegisterID, F_ActionTypeID = @ActionTypeID, F_ActionHappenTime = @ActionHappenTime, 
                                      F_ActionDetail1 = @ActionType,F_ActionXMLComment = @ActionXML, F_ActionDetail2 = @ActionKey, 
                                      F_ActionDetail3 = @ActionDetail1, F_ActionDetail4 = @ActionDetail2, F_ActionDetail5 = @ActionDetail3, F_ActionHappenTimeSpan = @ActionDes, F_ActionOrder= @ActionOrder
                                 WHERE F_ActionNumberID = @ActionID
    END
    ELSE
    BEGIN
    
			SELECT @DisciplineID = E.F_DisciplineID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
					 LEFT JOIN TS_Event AS E On P.F_EventID = E.F_EventID 
				WHERE M.F_MatchID = @MatchID
		    
			IF NOT EXISTS(SELECT F_ActionTypeID FROM TD_ActionType WHERE F_DisciplineID = @DisciplineID AND F_ActionCode = @ActionCode)
			BEGIN
			   SET @Result = -1
			   RETURN
			END
			ELSE
			BEGIN
			   SELECT @ActionTypeID = F_ActionTypeID FROM TD_ActionType WHERE F_DisciplineID = @DisciplineID AND F_ActionCode = @ActionCode
			END

			SELECT @ActionOrder = (CASE WHEN MAX(F_ActionOrder) IS NULL THEN 0 ELSE MAX(F_ActionOrder) END) + 1 FROM TS_Match_ActionList WHERE F_MatchID = @MatchID

			SET Implicit_Transactions off
			BEGIN TRANSACTION --�趨����
		       
			INSERT INTO TS_Match_ActionList (F_MatchID, F_MatchSplitID, F_CompetitionPosition, F_RegisterID, F_ActionTypeID, F_ActionHappenTime, F_ActionDetail1,F_ActionXMLComment, F_ActionDetail2, F_ActionDetail3, F_ActionDetail4, F_ActionDetail5, F_ActionHappenTimeSpan, F_ActionOrder)
					VALUES (@MatchID, @MatchSplitID, @TeamPos, @RegisterID, @ActionTypeID, @ActionHappenTime, @ActionType, @ActionXML, @ActionKey, @ActionDetail1, @ActionDetail2, @ActionDetail3,  @ActionDes, @ActionOrder)
				
				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END
		   
			SET @NewActionID = @@IDENTITY
				

			COMMIT TRANSACTION --�ɹ��ύ����

			SET @Result = @NewActionID
			RETURN
	  END

    
          
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


