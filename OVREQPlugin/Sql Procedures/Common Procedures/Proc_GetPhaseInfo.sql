if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_GetPhaseInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_GetPhaseInfo]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_GetPhaseInfo]
----��		  �ܣ��õ����½׶ε���Ϣ
----��		  �ߣ�֣���� 
----��		  ��: 2009-05-08

CREATE PROCEDURE [dbo].[Proc_GetPhaseInfo] (	
	@PhaseID					INT,
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
	
SET NOCOUNT ON

	SELECT * FROM TS_Phase AS A LEFT JOIN TS_Phase_Des AS B
					  ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode WHERE A.F_PhaseID = @PhaseID 

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

