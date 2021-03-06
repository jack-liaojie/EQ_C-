IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEventList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetEventList]

GO
/****** Object:  StoredProcedure [dbo].[Proc_GetEventList]    Script Date: 09/18/2009 11:17:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GetEventList]
--描    述：得到Discipline下得Event列表
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2009年08月25日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月03日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题		
			2010年1月12日		邓年彩		最前面添加一项空项目, 对应 F_Key 为 -1, 表示所有项目.	
*/

CREATE PROCEDURE [dbo].[Proc_GetEventList](
												@DisciplineID		INT,
												@LanguageCode		CHAR(3)
)
As
Begin
SET NOCOUNT ON 

	
	CREATE TABLE #Tmp_Table(
								F_Name			NVARCHAR(100),
								F_Key			INT
							)

	INSERT INTO #Tmp_Table (F_Name, F_Key) VALUES (N'', -1)

	INSERT INTO #Tmp_Table (F_Name, F_Key) 
		SELECT B.F_EventLongName, A.F_EventID 
		FROM TS_Event AS A 
		LEFT JOIN TS_Event_Des AS B 
			ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @LanguageCode 
		WHERE A.F_DisciplineID = @DisciplineID ORDER BY A.F_Order

	SELECT F_Name, F_Key FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


