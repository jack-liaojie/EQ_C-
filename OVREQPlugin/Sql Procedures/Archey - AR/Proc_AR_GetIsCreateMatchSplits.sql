IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_GetIsCreateMatchSplits]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_GetIsCreateMatchSplits]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







----�洢�������ƣ�[Proc_AR_GetIsCreateMatchSplits]
----��		  �ܣ�
----��		  �ߣ��޿�
----��		  ��: 2010-10-17 

CREATE PROCEDURE [dbo].[Proc_AR_GetIsCreateMatchSplits] 
	@MatchID			           INT,
	@EndCount				       INT,--�غ���Ŀ
	@ArrowCount			           INT,--ÿһ�غϵļ���
	@Distince			           INT,--�о࣬
	@Result 			           AS INT OUTPUT
	
AS
BEGIN
SET NOCOUNT ON

 	DECLARE @SQL		    NVARCHAR(max)
 	DECLARE @Order		    NVARCHAR(50)

	SET @Result=0;		-- @Result=1; 	����Split ����Split�����Ϲ���
						-- @Result=0; 	����Split
						-- @Result=-1; 	��Split
						-- @Result=-2; 	û�ж�Ӧ����

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -2
		RETURN
	END

	
	IF NOT EXISTS(SELECT 1 FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	DECLARE @AllEndCount int
	
	IF(@Distince >0)
	BEGIN
		Set @AllEndCount =  @EndCount*@Distince
	END
	ELSE BEGIN Set @AllEndCount =  @EndCount END
	
	IF((SELECT COUNT(F_MatchSplitID) FROM TS_Match_Split_Info 
		WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID =0 AND F_MatchSplitType=0) !=@AllEndCount)
	BEGIN	
		SET @Result = 1
	END
	ELSE 
	BEGIN
		DECLARE MYCURSOR CURSOR FOR SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID =0
		OPEN MYCURSOR
		
		DECLARE @MatchSplitID INT 
		FETCH NEXT FROM MYCURSOR INTO @MatchSplitID
		WHILE (@@FETCH_STATUS =0)
		BEGIN
			IF((SELECT COUNT(F_MatchSplitID) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID =@MatchSplitID  AND F_MatchSplitType=1) !=@ArrowCount)
			BEGIN			
				SET @Result = 1
			END
			FETCH NEXT FROM MYCURSOR INTO @MatchSplitID
		END
		CLOSE MYCURSOR
		DEALLOCATE MYCURSOR	
	END
	
	--SET @Result =0
	
	RETURN

SET NOCOUNT OFF
END	


GO

/*
DECLARE @Result int
EXEC Proc_AR_GetIsCreateMatchSplits 36,5,3,1,2, @Result output
SELECT	@Result as N'@Result'
*/

