IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_InsertPicture]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_InsertPicture]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_InsertPicture]
----功		  能：增加图像数据
----作		  者：李燕
----日		  期: 2010-01-05

CREATE PROCEDURE [dbo].[Proc_InsertPicture](
                         @PictureValue   VARBINARY(MAX),
                         @Result         AS INT OUTPUT
                    )
                                      	

AS
BEGIN
	
SET NOCOUNT ON

        SET @Result=0;  -- @Result=0; 	     增加失败
						 -- @Result>=1; 	 增加成功
		
  SET Implicit_Transactions off
  BEGIN TRANSACTION --设定事务
        INSERT TC_PicFile_Info(F_FileCode, F_FileComment, F_FileType, F_FileInfo) VALUES(null, null,null,@PictureValue) 
             IF @@error<>0  --事务失败返回  
			  BEGIN 
				  ROLLBACK   --事务回滚
				  SET @Result=0
				  RETURN
			   END
     SET @Result = 1
   COMMIT TRANSACTION --成功提交事务
   RETURN			

        

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF
