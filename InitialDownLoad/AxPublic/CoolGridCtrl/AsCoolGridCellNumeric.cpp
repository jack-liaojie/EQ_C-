// AsCoolGridCellNumeric.cpp: implementation of the CAsCoolGridCellNumeric class.

#include "stdafx.h"
#include "AsCoolGridCellNumeric.h"
#include "AsCoolGridInPlaceEdit.h"
#include "AsCoolGridCtrl.h"

IMPLEMENT_DYNCREATE(CAsCoolGridCellNumeric, CAsCoolGridCell)

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

// Create a control to do the editing
BOOL CAsCoolGridCellNumeric::Edit(int nRow, int nCol, CRect rect, CPoint /* point */, UINT nID, UINT nChar)
{
    m_bEditing = TRUE;
    
    // CInPlaceEdit auto-deletes itself
    m_pEditWnd = new CAsCoolGridInPlaceEdit(GetGrid(), rect, /*GetStyle() |*/ ES_NUMBER, nID, nRow, nCol,
		GetText(), nChar);

    return TRUE;
}

// Cancel the editing.
void CAsCoolGridCellNumeric::EndEdit()
{
    if (m_pEditWnd)
        ((CAsCoolGridInPlaceEdit*)m_pEditWnd)->EndEdit();
}

