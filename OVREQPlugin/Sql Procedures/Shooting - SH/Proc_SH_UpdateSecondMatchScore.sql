
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SH_UpdateSecondMatchScore]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SH_UpdateSecondMatchScore]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[Proc_SH_UpdateSecondMatchScore]
----��		  �ܣ�25�� ���µڶ���ɼ�
----��		  �ߣ���ѧ�� 
----��		  ��: 2011-03-25

CREATE PROCEDURE [dbo].[Proc_SH_UpdateSecondMatchScore] (	
	@MatchID					INT
)	
AS
BEGIN
	
SET NOCOUNT ON



SET NOCOUNT OFF
END

GO

-- EXEC Proc_SH_UpdateSecondMatchScore 1