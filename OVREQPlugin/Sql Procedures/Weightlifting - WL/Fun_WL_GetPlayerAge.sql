IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_WL_GetPlayerAge]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_WL_GetPlayerAge]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Fun_WL_GetPlayerAge]
								( 
									@Birthday  datetime,
									@Now		datetime
								)
RETURNS int
AS
BEGIN

	declare @age int , @year int, @month int , @day int
	set @age = 0
	set @year = 0
	set @month = 0
	set @day = 0
	
	set @year = DatePart(Year,@Now)- DatePart(Year,@Birthday)
	set @month = DatePart(Month,@Now)- DatePart(Month,@Birthday)
	set @day = DatePart(Day,@Now)- DatePart(Day,@Birthday)

	if(@month >0)
		set @age = @year
	if(@month <0)
		set @age = @year-1
	if(@month =0)
		begin
			if(@day >=0)
				set @age = @year
			else
				set @age = @year-1			
		end
	return (@age)
END


GO


/*
select dbo.Fun_WL_GetPlayerAge (2,54,'1',154)

*/