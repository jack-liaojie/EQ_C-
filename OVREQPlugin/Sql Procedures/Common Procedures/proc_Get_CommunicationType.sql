/****** Object:  StoredProcedure [dbo].[proc_Get_CommunicationType]    Script Date: 01/20/2010 18:28:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_Get_CommunicationType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_Get_CommunicationType]
GO
/****** Object:  StoredProcedure [dbo].[proc_Get_CommunicationType]    Script Date: 01/20/2010 18:28:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：proc_Get_CommunicationType
----功		  能：得到OfficialCommunicationType 
----作		  者：李燕
----日		  期: 2010-1-20 

CREATE PROCEDURE [dbo].[proc_Get_CommunicationType]
	
AS
BEGIN
	
SET NOCOUNT ON

	SELECT 1 AS F_Order, 0 AS F_Type, N'' AS F_TypeDes
    UNION
    SELECT 2 AS F_Order, 1 AS F_Type, N'results' AS F_TypeDes
    UNION
	SELECT 3 AS F_Order, 2 AS F_Type, N'schedule' AS F_TypeDes
    UNION
	SELECT 4 AS F_Order, 4 AS F_Type, N'other' AS F_TypeDes
    UNION
    SELECT 5 AS F_Order, 3 AS F_Type, N'results & schedule' AS F_TypeDes
    UNION
    SELECT 6 AS F_Order, 5 AS F_Type, N'results & other' AS F_TypeDes 
    UNION
	SELECT 7 AS F_Order, 6 AS F_Type, N'schedule & other' AS F_TypeDes
    UNION
    SELECT 8 AS F_Order, 7 AS F_Type, N'schedule & result & other' AS F_TypeDes
  
   



SET NOCOUNT OFF
END