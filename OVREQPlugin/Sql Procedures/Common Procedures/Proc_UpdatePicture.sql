/****** Object:  StoredProcedure [dbo].[Proc_UpdatePicture]    Script Date: 01/05/2010 11:50:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_UpdatePicture]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_UpdatePicture]
GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdatePicture]    Script Date: 01/05/2010 11:41:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_UpdatePicture]
----功		  能：更新图像数据
----作		  者：李燕
----日		  期: 2010-01-05

CREATE PROCEDURE [dbo].[Proc_UpdatePicture](
                       @PictureID      INT,
                       @PictureValue   VARBINARY(MAX),
                       @Result         AS INT OUTPUT
                      )
                                      	

AS
BEGIN
	
SET NOCOUNT ON

         SET @Result=0;  -- @Result=0; 	     更新失败
						 -- @Result>=1; 	 更新成功
					     -- @Result=-1; 	 不存在PictureID，更新失败
	     IF NOT EXISTS(SELECT F_FileID FROM TC_PicFile_Info WHERE F_FileID = @PictureID)
         BEGIN
              SET @Result = -1
              return
         END

        SET Implicit_Transactions off
        BEGIN TRANSACTION --设定事务
              
              UPDATE TC_PicFile_Info SET F_FileInfo = @PictureValue WHERE F_FileID = @PictureID
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
