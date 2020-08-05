IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_InscriptionAllRegister_GroupByClub]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_InscriptionAllRegister_GroupByClub]
GO
/****** Object:  StoredProcedure [dbo].[Proc_InscriptionAllRegister_GroupByClub]    Script Date: 11/16/2009 13:46:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_InscriptionAllRegister_GroupByClub]
--��    ��: ���и�Event�µı����˶�Ա������
--����˵��: 
--˵    ��: 
--�� �� ��: ����
--��    ��: 2009��8��31��
--�޸ļ�¼��2009��11��16��
-- -        2011��01��04��	    ����        �����Ա�����Ϊ��0����������




CREATE PROCEDURE [dbo].[Proc_InscriptionAllRegister_GroupByClub]
	@EventID				INT,
	@LanguageCode			CHAR(3),
    @Result 			AS INT OUTPUT

AS
BEGIN
SET NOCOUNT ON
   
     CREATE TABLE #table_group(
							     F_GroupID      NVARCHAR(9)
                               )
     
     CREATE TABLE #table_register(
								     F_RegisterID      INT
                                  )
    /* Get Active Info*/
    DECLARE @RegTypeID AS INT
	DECLARE @SexCode AS INT
	DECLARE @DisciplineID AS INT

	SELECT @RegTypeID = F_PlayerRegTypeID, @SexCode = F_SexCode, @DisciplineID = F_DisciplineID
	FROM TS_Event 
	WHERE F_EventID = @EventID

  
    INSERT INTO  #table_group(F_GroupID)
	  SELECT CAST(F_ClubID AS NVARCHAR(9)) FROM TS_ActiveClub
			WHERE F_DisciplineID = @DisciplineID
	
    DECLARE @PlayerRegTypeID AS INT
	DECLARE @DoubleRegTypeID AS INT
	DECLARE @TeamRegTypeID AS INT
	SET @PlayerRegTypeID = 1
	SET @DoubleRegTypeID = 2
	SET @TeamRegTypeID = 3

	DECLARE @MixSexCode AS INT
	SET @MixSexCode = 3
	
	DECLARE @OpenSexCode AS INT
	SET @OpenSexCode = 4

	INSERT INTO #table_register( F_RegisterID)
        SELECT  a.F_RegisterID  FROM TR_Register AS a 
	    WHERE   a.F_RegTypeID = @RegTypeID AND a.F_DisciplineID = @DisciplineID
			 AND a.F_RegisterID NOT IN (
				  SELECT F_RegisterID
				    FROM TR_Inscription AS e
				    WHERE e.F_EventID = @EventID)
			 AND a.F_ClubID IN (
				 SELECT CAST(F_GroupID AS INT) FROM  #table_group)
		     AND (
		           @SexCode = @OpenSexCode 
		           OR
		           (
						a.F_SexCode is NULL 
						OR
						(a.F_RegTypeID = @PlayerRegTypeID AND (a.F_SexCode = @MixSexCode OR a.F_SexCode = @SexCode))
						OR
						((a.F_RegTypeID = @DoubleRegTypeID OR a.F_RegTypeID = @TeamRegTypeID) AND a.F_SexCode = @SexCode)
					)
		          )

  
   /* Register Inscription*/
   SET @Result=0;  -- @Result=0; 	ע����Ա����ʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	ע����Ա����ɹ���
					-- @Result=-1; 	ע����Ա����ʧ�ܣ�@EventID��Ч��@RegisterID��Ч
					-- @Result=-2; 	ע����Ա����ʧ�ܣ��Ѿ�ע����ˣ�

	IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterID IN (SELECT F_RegisterID FROM #table_register))
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS(SELECT F_RegisterID FROM TR_Inscription WHERE F_EventID = @EventID AND F_RegisterID IN (SELECT F_RegisterID FROM #table_register))
	BEGIN
		SET @Result = -2
		RETURN
	END 
   
   SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		INSERT INTO TR_Inscription (F_RegisterID, F_EventID, F_Seed)
			SELECT F_RegisterID, @EventID, NULL
             FROM #table_register

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

