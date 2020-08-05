IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_DataExchage_ConvertScheduleStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_DataExchage_ConvertScheduleStatus]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Func_DataExchage_ConvertScheduleStatus]
--��    ��: �����ݿ��� TC_Status_Des ��״̬ת��Ϊ Common Code �� CSIC_ScheduleStatus_Dict ��״̬.
--�� �� ��: �����
--��    ��: 2010��12��15��
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE FUNCTION [Func_DataExchage_ConvertScheduleStatus]
(
	@StatuID					INT
)
RETURNS INT
AS
BEGIN

	/*
	���ݿ��� TC_Status_Des ��״̬
	10		Available
	20		Configured
	30		Scheduled
	40		Startlist
	50		Running
	60		Suspend
	100		Unofficial
	110		Official
	120		Revision
	130		Canceled
	
	Common Code �� CSIC_ScheduleStatus_Dict ��״̬
	0		Not needed
	1		Planned
	2		Scheduled
	4		Running
	5		Closed
	6		Unofficial
	7		Official
	9		Delayed
	11		Cancelled
	12		Protested
	13		Postponed
	14		Rescheduled 
	*/

	RETURN CASE @StatuID 
		WHEN 0 THEN 0
		WHEN 10 THEN 0
		WHEN 20 THEN 1
		WHEN 30 THEN 2
		WHEN 40 THEN 4
		WHEN 50 THEN 4
		WHEN 60 THEN 4
		WHEN 100 THEN 6
		WHEN 110 THEN 7
		WHEN 120 THEN 12
		WHEN 130 THEN 11
	END

END

/*

-- Just for test
select dbo.[Func_DataExchage_ConvertScheduleStatus](0)
select dbo.[Func_DataExchage_ConvertScheduleStatus](10)
select dbo.[Func_DataExchage_ConvertScheduleStatus](20)
select dbo.[Func_DataExchage_ConvertScheduleStatus](30)
select dbo.[Func_DataExchage_ConvertScheduleStatus](40)
select dbo.[Func_DataExchage_ConvertScheduleStatus](50)
select dbo.[Func_DataExchage_ConvertScheduleStatus](60)
select dbo.[Func_DataExchage_ConvertScheduleStatus](100)
select dbo.[Func_DataExchage_ConvertScheduleStatus](110)
select dbo.[Func_DataExchage_ConvertScheduleStatus](120)
select dbo.[Func_DataExchage_ConvertScheduleStatus](130)

*/