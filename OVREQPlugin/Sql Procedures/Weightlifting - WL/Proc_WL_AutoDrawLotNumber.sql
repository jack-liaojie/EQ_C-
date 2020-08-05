IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_AutoDrawLotNumber]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_AutoDrawLotNumber]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--��    ��: [Proc_WL_AutoDrawLotNumber]
--��    ��: ���ر������ǩλ
--����˵��: 
--˵    ��: 
--�� �� ��: �޿�
--�� �� �ˣ��޿�	
--�޸����������ر������ǩλ
--��    ��: 2011-04-10


CREATE PROCEDURE [dbo].[Proc_WL_AutoDrawLotNumber]
	@EventID					INT,
	@SexCode					INT,
    @Type                       INT,  --��ǩ���1���б�����Ա��ǩ��0ָ��������λλ����Ա��ǩ
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	��ʾ���ɳ�ʼ����ǩλʧ�ܣ�ʲô����Ҳû��
					  -- @Result = 1; 	��ʾ���ɳ�ʼ����ǩλ

	
		CREATE TABLE #table_EventPositon(
                                     F_EventID              INT,
									 F_SexCode				INT,  
                                     F_RegisterID           INT
                                     )

		----�޿�����ʱ�����������seed�ţ���Ϊ�����˶�Աǩ��
		CREATE TABLE #table_ExistEventSeed(		
                                     F_RegisterID           INT,
                                     F_Seed	                INT,
									 F_SexCode			INT,
									 F_EventID			INT
                                     )
											  
		
		SET Implicit_Transactions off
		BEGIN TRANSACTION --�趨����
			
			IF(@Type = 1)			
			BEGIN	
				----�޿������ɴ�����Ա��������ʱ��
				INSERT INTO #table_EventPositon (F_RegisterID,F_SexCode,F_EventID)
						SELECT I.F_RegisterID,R.F_SexCode,I.F_EventID FROM TR_Inscription AS I
						LEFT JOIN TR_Register AS R ON R.F_RegisterID = I.F_RegisterID
							WHERE I.F_RegisterID IS NOT NULL AND R.F_RegTypeID=1
			
					IF @@error<>0  --����ʧ�ܷ���  
					BEGIN 
						ROLLBACK   --����ع�
						SET @Result=0
						RETURN
					END			
							
			END
			ELSE IF(@Type = 0)	
			BEGIN
					----�޿������ɴ�����Ա��������ʱ��
					INSERT INTO #table_EventPositon (F_RegisterID,F_SexCode,F_EventID)
						SELECT I.F_RegisterID,R.F_SexCode,I.F_EventID FROM TS_Event_Competitors AS I
						LEFT JOIN TR_Register AS R ON R.F_RegisterID = I.F_RegisterID
							WHERE I.F_RegisterID IS NOT NULL AND R.F_RegTypeID=1
							
					IF @@error<>0  --����ʧ�ܷ���  
					BEGIN 
						ROLLBACK   --����ع�
						SET @Result=0
						RETURN
					END					
					
			END
			
		IF (@SexCode != -1)
		BEGIN
			DELETE FROM #table_EventPositon WHERE (F_SexCode != @SexCode OR F_SexCode IS NULL)
		END	 

		IF (@EventID != -1)
		BEGIN		
			DELETE FROM #table_EventPositon WHERE F_EventID <> @EventID
			--F_RegisterID NOT IN (SELECT F_RegisterID FROM TR_Inscription WHERE F_EventID = @EventID)			
		END
						
			----�޿����������seed�ţ�������ʱ����Ϊ�����˶�Աǩ��				
			INSERT INTO #table_ExistEventSeed (F_RegisterID,F_Seed,F_SexCode,F_EventID)
					SELECT F_RegisterID,ROW_NUMBER() over(order by newid()),F_SexCode,F_EventID FROM #table_EventPositon

					
				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END	
				
			----�޿������˶�Աǩ�Ų��뱨�������
			Update TR_Inscription SET F_Seed=T.F_Seed FROM TR_Inscription AS I 
				 INNER JOIN #table_ExistEventSeed AS T ON T.F_RegisterID = I.F_RegisterID
						
				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END	

		COMMIT TRANSACTION --�ɹ��ύ����	   
		
	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END



GO


