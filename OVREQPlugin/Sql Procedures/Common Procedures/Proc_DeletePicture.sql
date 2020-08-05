/****** Object:  StoredProcedure [dbo].Proc_DeletePicture]    Script Date: 01/05/2010 11:50:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DeletePicture]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DeletePicture]
GO
/****** Object:  StoredProcedure [dbo].[Proc_DeletePicture]    Script Date: 01/05/2010 11:41:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�[Proc_DeletePicture]
----��		  �ܣ�ɾ��ͼ������
----��		  �ߣ�����
----��		  ��: 2010-01-05

CREATE PROCEDURE [dbo].[Proc_DeletePicture](
                      @PictureID         INT,
                      @Result            AS INT OUTPUT
                   )
                                  	

AS
BEGIN
	
SET NOCOUNT ON
             
         SET @Result=0;  -- @Result=0; 	     ɾ��ʧ��
						 -- @Result>=1; 	 ɾ���ɹ�
					     -- @Result=-1; 	 ������PictureID��ɾ��ʧ��


        IF NOT EXISTS(SELECT F_FileID FROM TC_PicFile_Info WHERE F_FileID = @PictureID)
         BEGIN
              SET @Result = -1
              return
         END

        SET Implicit_Transactions off
        BEGIN TRANSACTION --�趨����
             DELETE TC_PicFile_Info WHERE F_FileID = @PictureID
             IF @@error<>0  --����ʧ�ܷ���  
			  BEGIN 
				  ROLLBACK   --����ع�
				  SET @Result=0
				  RETURN
			   END
         SET @Result = 1
        COMMIT TRANSACTION --�ɹ��ύ����
	    RETURN

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF
