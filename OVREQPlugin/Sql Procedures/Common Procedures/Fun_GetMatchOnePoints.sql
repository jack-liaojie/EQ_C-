IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetMatchOnePoints]') AND type = N'FN')
DROP FUNCTION [dbo].[Fun_GetMatchOnePoints]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--��    �ƣ�[Fun_GetMatchOnePoints]
--��    �������� @MatchID, @CompetitionPosition �õ�һ��������һ�������߳ɼ���Ϣ
--����˵���� 
--˵    ����
--�� �� �ˣ������
--��    �ڣ�2009��11��23��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
*/

CREATE FUNCTION [dbo].[Fun_GetMatchOnePoints]
	(
		@MatchID				INT,
		@CompetitionPosition	INT
	)
RETURNS INT
AS
BEGIN

	DECLARE @Points		INT
	
	-- F_CompetitionPosition ���ܲ��������Ļ򲻴�1��ʼ, ���԰��� F_CompetitionPosition ��������
	SELECT @Points = 
		CASE 
			WHEN A.F_RegisterID = -1 THEN -1
			ELSE A.F_Points
		END
	FROM
	(
		SELECT X.F_MatchID
			, RANK() OVER (ORDER BY X.F_CompetitionPosition) AS F_CompetitionPosition
			, X.F_Points
			, X.F_RegisterID
		FROM TS_Match_Result AS X
		WHERE X.F_MatchID = @MatchID 
	) AS A
	WHERE A.F_MatchID = @MatchID 
		AND A.F_CompetitionPosition = @CompetitionPosition

	RETURN @Points

END