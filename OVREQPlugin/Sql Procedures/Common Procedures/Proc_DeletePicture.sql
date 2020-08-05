/****** Object:  StoredProcedure [dbo].Proc_DeletePicture]    Script Date: 01/05/2010 11:50:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DeletePicture]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DeletePicture]
GO
/****** Object:  StoredProcedure [dbo].[Proc_DeletePicture]    Script Date: 01/05/2010 11:41:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_DeletePicture]
----功		  能：删除图像数据
----作		  者：李燕
----日		  期: 2010-01-05

CREATE PROCEDURE [dbo].[Proc_DeletePicture](
                      @PictureID         INT,
                      @Result            AS INT OUTPUT
                   )
                                  	

AS
BEGIN
	
SET NOCOUNT ON
             
         SET @Result=0;  -- @Result=0; 	     删除失败
						 -- @Result>=1; 	 删除成功
					     -- @Result=-1; 	 不存在PictureID，删除失败


        IF NOT EXISTS(SELECT F_FileID FROM TC_PicFile_Info WHERE F_FileID = @PictureID)
         BEGIN
              SET @Result = -1
              return
         END

        SET Implicit_Transactions off
        BEGIN TRANSACTION --设定事务
             DELETE TC_PicFile_Info WHERE F_FileID = @PictureID
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
