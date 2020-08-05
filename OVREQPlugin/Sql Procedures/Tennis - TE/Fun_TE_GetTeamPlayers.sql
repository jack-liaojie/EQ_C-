IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_TE_GetTeamPlayers]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].Fun_TE_GetTeamPlayers
GO


GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--名    称：[Fun_TE_GetTeamPlayers]
--描    述：得到Match下得队的可选运动员列表
--参数说明： 
--说    明：
--创 建 人：崔凯	
--日    期：2011年10月08日


CREATE FUNCTION [dbo].[Fun_TE_GetTeamPlayers](
												@TeamID		    INT,
												@LanguageCode		CHAR(3) = 'CHN'
)
RETURNS nvarchar(200)
As
Begin

	declare @ReturnString nvarchar(200)

	declare MyCursor CURSOR FOR select F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @TeamID
	set @ReturnString=' '
	OPEN MyCursor
	
	--循环一个游标
	DECLARE @memberRegisterID int
	FETCH NEXT FROM  MyCursor INTO @memberRegisterID
	WHILE @@FETCH_STATUS =0
	BEGIN
		select @ReturnString = @ReturnString+ B.F_PrintLongName + ' '
		FROM TR_Register AS A
		LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
		where A.F_RegisterID = @memberRegisterID
		FETCH NEXT FROM  MyCursor INTO @memberRegisterID
	END	

	--关闭游标
	CLOSE MyCursor
	--释放资源
	DEALLOCATE MyCursor
	
	return @ReturnString
end
	


GO

