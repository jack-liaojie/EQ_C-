IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_UpdateDoubleRegisterCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_UpdateDoubleRegisterCode]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[Proc_UpdateDoubleRegisterCode]
----��		  �ܣ�����˫����Ա��RegisterCode
----��		  �ߣ��Ŵ�ϼ 
----��		  ��: 2012-02-10

CREATE PROCEDURE [dbo].[Proc_UpdateDoubleRegisterCode] 
(	
	@Result 					AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	����ʧ�ܣ���ʾû�����κβ�����
					-- @Result = 1; 	���³ɹ���
	
	
	CREATE TABLE #Tmp_DoubleNoCode(
										F_RegisterID       INT,
										F_RegisterCode     NVARCHAR(100),
										F_Mem1ID           INT,
										F_Mem1Code         NVARCHAR(100),
										F_Mem2ID           INT,
										F_Mem2Code         NVARCHAR(100)
								)
								
	CREATE TABLE #Tmp_DoubleCode(
										F_RegisterID       INT,
										F_RegisterCode     NVARCHAR(100),
										F_Mem1ID           INT,
										F_Mem1Code         NVARCHAR(100),
										F_Mem2ID           INT,
										F_Mem2Code         NVARCHAR(100)
								)
								
    INSERT INTO #Tmp_DoubleNoCode(F_RegisterID, F_Mem1ID, F_Mem1Code, F_Mem2ID, F_Mem2Code)
    SELECT R.F_RegisterID, RM1.F_MemberRegisterID, R1.F_RegisterCode, RM2.F_MemberRegisterID, R2.F_RegisterCode
    FROM TR_Register AS R
    LEFT JOIN TR_Register_Member AS RM1 ON R.F_RegisterID = RM1.F_RegisterID AND RM1.F_Order = 1
    LEFT JOIN TR_Register AS R1 ON RM1.F_MemberRegisterID = R1.F_RegisterID
    LEFT JOIN TR_Register_Member AS RM2 ON R.F_RegisterID = RM2.F_RegisterID AND RM2.F_Order = 2
    LEFT JOIN TR_Register AS R2 ON RM2.F_MemberRegisterID = R2.F_RegisterID
    WHERE R.F_RegTypeID = 2 AND R.F_RegisterCode IS NULL
    
    INSERT INTO #Tmp_DoubleCode(F_RegisterID, F_RegisterCode, F_Mem1ID, F_Mem1Code, F_Mem2ID, F_Mem2Code)
    SELECT R.F_RegisterID, R.F_RegisterCode, RM1.F_MemberRegisterID, R1.F_RegisterCode, RM2.F_MemberRegisterID, R2.F_RegisterCode
    FROM TB_Register AS R
    LEFT JOIN TB_Register_Member AS RM1 ON R.F_RegisterID = RM1.F_RegisterID AND RM1.F_Order = 1
    LEFT JOIN TB_Register AS R1 ON RM1.F_MemberRegisterID = R1.F_RegisterID
    LEFT JOIN TB_Register_Member AS RM2 ON R.F_RegisterID = RM2.F_RegisterID AND RM2.F_Order = 2
    LEFT JOIN TB_Register AS R2 ON RM2.F_MemberRegisterID = R2.F_RegisterID
    WHERE R.F_RegTypeID = 2
    
    UPDATE A SET A.F_RegisterCode = B.F_RegisterCode FROM #Tmp_DoubleNoCode AS A 
	LEFT JOIN #Tmp_DoubleCode AS B
	ON A.F_Mem1Code = B.F_Mem1Code AND A.F_Mem2Code = B.F_Mem2Code
	WHERE A.F_RegisterCode IS NULL
	
	UPDATE A SET A.F_RegisterCode = B.F_RegisterCode FROM #Tmp_DoubleNoCode AS A 
	LEFT JOIN #Tmp_DoubleCode AS B
	ON A.F_Mem1Code = B.F_Mem2Code AND A.F_Mem2Code = B.F_Mem1Code
	WHERE A.F_RegisterCode IS NULL
    
	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����
	
    UPDATE A SET A.F_RegisterCode = b.F_RegisterCode FROM TR_Register AS A
    LEFT JOIN #Tmp_DoubleNoCode AS B ON A.F_RegisterID = b.F_RegisterID
    WHERE A.F_RegisterCode IS NULL
    
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


