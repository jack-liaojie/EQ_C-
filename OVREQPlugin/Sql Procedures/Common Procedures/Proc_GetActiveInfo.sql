if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_GetActiveInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_GetActiveInfo]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_GetActiveInfo]
----��		  �ܣ��õ���ǰ�ļ�����Ϣ
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-19 

CREATE PROCEDURE [dbo].[Proc_GetActiveInfo] (	
	@SportID			AS INT OUTPUT,
	@DisciplineID		AS INT OUTPUT,
	@LanguageCode		AS CHAR(3) OUTPUT,
	@Result 			AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	ȡ�ü�����Ϣʧ��
					-- @Result = 1; 	ȡ�ü�����Ϣ�ɹ���

	SELECT  TOP 1 @SportID =  (F_SportID) FROM TS_Sport WHERE F_Active = 1 
	SELECT TOP 1 @DisciplineID = (F_DisciplineID) FROM TS_Discipline WHERE F_Active = 1 AND F_SportID = @SportID
	SELECT TOP 1 @LanguageCode = (F_LanguageCode) FROM TC_Language WHERE F_Active = 1

	IF (@SportID IS NULL) OR (@DisciplineID IS NULL) OR (@LanguageCode IS NULL)
	BEGIN
		SET @Result = 0
	END
	ELSE
	BEGIN
		SET @Result = 1
	END

	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

