/****** Object:  StoredProcedure [dbo].[Proc_GetOfficialCommunication]    Script Date: 01/21/2010 08:48:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetOfficialCommunication]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetOfficialCommunication]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetOfficialCommunication]    Script Date: 01/21/2010 08:48:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[Proc_GetOfficialCommunication]
----��		  �ܣ��õ�Official Communication
----��		  �ߣ�����
----��		  ��: 2010-1-21

CREATE PROCEDURE [dbo].[Proc_GetOfficialCommunication](
                                         @NewsID     INT
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

	SELECT * FROM TS_Offical_Communication WHERE F_NewsID = @NewsID

	RETURN

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS OFF
GO
