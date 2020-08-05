if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_GetReportUploadType]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_GetReportUploadType]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----名   称：[Proc_GetReportUploadType]
----功   能：获取报表上传到CRS和Info用的ReportType。
----作	 者：郑金勇
----日   期：2012-08-24 

/*
	参数说明：
	序号	参数名称				参数说明
	1		@DisciplineCode			Discipline 的编码
	2       @ReportType				报表编码
*/

/*
	功能描述：根据报表自身的Type来查找对应的上传到CRS和Info的ReportType。
			  
*/

/*
修改记录：
	序号	日期			修改者		修改内容
	1						

*/

CREATE PROCEDURE [dbo].[Proc_GetReportUploadType] (	
	@DisciplineID		AS INT,
	@ReportType			AS NVARCHAR(50),
	@UploadReportType	AS NVARCHAR(50) OUTPUT,
	@LanguageCode		AS CHAR(3) OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineCode AS NVARCHAR(50)
	SELECT @DisciplineCode = F_DisciplineCode FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID

	SELECT @UploadReportType = F_UploadReportType, @LanguageCode = F_LanguageCode FROM TC_LN_ReportType WHERE F_DisciplineCode = @DisciplineCode AND F_ReportType = @ReportType

	SET @UploadReportType = ISNULL(@UploadReportType, @ReportType)

	IF @LanguageCode IS NULL
	BEGIN
		IF LEFT(@ReportType, 1) = N'C'
		BEGIN
			SET @LanguageCode = 'ENG'
		END
		ELSE IF LEFT(@ReportType, 1) = N'Z'
		BEGIN
			SET @LanguageCode = 'CHI'
		END
		ELSE
		BEGIN
			SET @LanguageCode = 'CHI'
		END
	END
	
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

