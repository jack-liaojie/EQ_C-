IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_UpdateRaceNum]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_UpdateRaceNum]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_Schedule_UpdateRaceNum]
--��    ��: ����ָ��һ��������RaceNum, �������°���
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��11��16��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_Schedule_UpdateRaceNum]
	@MatchID				INT,
	@RaceNum				NVARCHAR(20),
	@Result					AS INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;	--@Result = 0;	����ʧ�ܣ���ʾû�����κβ�����
						--@Result = 1;	���³ɹ�  
						--@Result = -1; ����ʧ�ܣ�@MatchID��Ч

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	UPDATE TS_Match SET F_RaceNum = @RaceNum
	WHERE F_MatchID = @MatchID

	IF @@error<>0
	BEGIN 
		SET @Result = 0
		RETURN
	END

	SET @Result = 1

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*

-- Just for test
DECLARE @MatchID INT
DECLARE @RaceNum NVARCHAR(20)
DECLARE @Result INT

SET @MatchID = 453
SET @RaceNum = N'1111'

EXEC [Proc_Schedule_UpdateRaceNum] @MatchID, @RaceNum, @Result

SELECT @Result AS TestResult
SELECT F_RaceNum
FROM TS_Match
WHERE F_MatchID = @MatchID

*/