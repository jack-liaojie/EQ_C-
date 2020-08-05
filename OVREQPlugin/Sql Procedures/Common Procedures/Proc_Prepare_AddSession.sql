IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Prepare_AddSession]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Prepare_AddSession]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Prepare_AddSession]
--描    述: 准备基础数据添加一个 Session.
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2010年9月14日 星期二
--修改记录：
/*			
			日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Prepare_AddSession]
	@DisciplineID						INT,
	@Date								DateTime,
	@Number								INT,
	@Time								DateTime,
	@EndTime							DateTime,
	@TypeID								INT			-- 1 - 上午; 2 - 中午; 3 - 下午; 4 - 晚上.
AS
BEGIN
SET NOCOUNT ON

	INSERT INTO TS_Session
	(F_DisciplineID, F_SessionDate, F_SessionNumber, F_SessionTime, F_SessionEndTime, F_SessionTypeID)
	VALUES
	(@DisciplineID, @Date, @Number, @Time, @EndTime, @TypeID)

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Prepare_AddSession] 

*/