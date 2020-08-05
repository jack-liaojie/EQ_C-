
// stdafx.cpp : 只包括标准包含文件的源文件
// InitialDownLoad.pch 将作为预编译头
// stdafx.obj 将包含预编译类型信息

#include "stdafx.h"



BOOL AxCommonFillGridCtrl(CAsCoolGridCtrl* pGridCtrl, CAxADORecordSet& recordSet, BOOL bColorRow/* = TRUE*/, COLORREF clrOddRow, COLORREF clrEvenRow, LOGFONT* lgHeaderFont/* = NULL*/, LOGFONT* lgCellTextFont/* = NULL*/)
{
	ASSERT( pGridCtrl != NULL);

	SAxTableRecordSet rsTbl;
	AxCommonTransRecordSet(recordSet, rsTbl);

	return AxCommonFillGridCtrl(pGridCtrl, rsTbl, bColorRow, clrOddRow, clrEvenRow, lgHeaderFont, lgCellTextFont);
}

BOOL AxCommonFillGridCtrl(CAsCoolGridCtrl* pGridCtrl, SAxTableRecordSet& rsTable, BOOL bColorRow/* = TRUE*/, COLORREF clrOddRow, COLORREF clrEvenRow, LOGFONT* lgHeaderFont/* = NULL*/, LOGFONT* lgCellTextFont/* = NULL*/)
{
	LOGFONT lf;
	GetObject(GetStockObject(SYSTEM_FONT), sizeof(LOGFONT), &lf);

	pGridCtrl->SetRowCount(0);
	pGridCtrl->SetColumnCount(rsTable.GetFieldsCount());
	pGridCtrl->SetRowCount(rsTable.GetRowRecordsCount() + 1);
	pGridCtrl->SetFixedRowCount();	

	for( int iFieldIdx = 0; iFieldIdx < rsTable.GetFieldsCount(); iFieldIdx++ )
	{
		pGridCtrl->SetItemText(0, iFieldIdx, rsTable.GetFieldName(iFieldIdx));
		pGridCtrl->SetRowHeight(0, 23);
		if( lgHeaderFont )
		{
			pGridCtrl->SetItemFont(0, iFieldIdx, lgHeaderFont);
		}
		else
		{
			pGridCtrl->SetItemFont(0, iFieldIdx, &lf);
		}
	}

	for( int iRowIdx = 0; iRowIdx < rsTable.GetRowRecordsCount(); iRowIdx++ )
	{
		for( int iFieldIdx = 0; iFieldIdx < rsTable.GetFieldsCount(); iFieldIdx++ )
		{
			pGridCtrl->SetItemText(iRowIdx + 1, iFieldIdx, rsTable.GetValue(iFieldIdx, iRowIdx));
			if( lgCellTextFont)		
			{
				pGridCtrl->SetItemFont(iRowIdx + 1, iFieldIdx, lgCellTextFont);
			}			
		}
		if( bColorRow)
		{
			if( iRowIdx % 2  == 1)
				pGridCtrl->SetRowBkColor(iRowIdx + 1, clrEvenRow);	
			else
				pGridCtrl->SetRowBkColor(iRowIdx + 1, clrOddRow);	
		}
	}

	pGridCtrl->AutoSizeColumns();
	pGridCtrl->ExpandLastColumn();
	pGridCtrl->Refresh();

	return TRUE;
}