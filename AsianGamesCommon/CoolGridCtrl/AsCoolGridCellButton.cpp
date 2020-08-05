#include "AsCoolGridCellButton.h"
#include "AsCoolGridCellButton.h"
// AsCoolGridCellButton.cpp : implementation file

#include "stdafx.h"
#include "AsCoolGridCell.h"
#include "AsCoolGridCtrl.h"

#include "AsCoolGridCellButton.h"

#define BUTTON_ID	10000

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

IMPLEMENT_DYNCREATE(CAsCoolGridCellButton, CAsCoolGridCell)

CAsCoolGridCellButton::CAsCoolGridCellButton() : CAsCoolGridCell()
{

}

CSize CAsCoolGridCellButton::GetCellExtent(CDC* pDC)
{
    // Using SM_CXHSCROLL as a guide to the size of the checkbox
    int nWidth = GetSystemMetrics(SM_CXHSCROLL) + 2*GetMargin();	
    CSize	cellSize = CAsCoolGridCell::GetCellExtent(pDC);	
    cellSize.cx += nWidth;	
    cellSize.cy = max (cellSize.cy, nWidth);	
    return  cellSize;
}

// i/o:  i=dims of cell rect; o=dims of text rect
BOOL CAsCoolGridCellButton::GetTextRect( LPRECT pRect)
{
    BOOL bResult = CAsCoolGridCell::GetTextRect(pRect);
    if (bResult)
    {
        int nWidth = GetSystemMetrics(SM_CXHSCROLL) + 2*GetMargin();
        pRect->left += nWidth;
        if (pRect->left > pRect->right)
            pRect->left = pRect->right;
    }
    return bResult;
}

// Override draw so that when the cell is selected, a drop arrow is shown in the RHS.
BOOL CAsCoolGridCellButton::Draw(CDC* pDC, int nRow, int nCol, CRect rect,  BOOL bEraseBkgnd /*=TRUE*/)
{
    BOOL bResult = CAsCoolGridCell::Draw(pDC, nRow, nCol, rect,  bEraseBkgnd);
	
	m_Button.m_nRow = nRow;
	m_Button.m_nCol = nCol;
	if (!::IsWindow(m_Button.GetSafeHwnd()) )
	{
		m_Button.Create(m_strText, WS_CHILD|WS_VISIBLE|BS_PUSHBUTTON, rect, m_pCoolGrid, BUTTON_ID);
	}
	if (::IsWindow(m_Button.GetSafeHwnd()) )
	{
		m_Button.MoveWindow(rect);
		m_Button.SetWindowText(m_strText);
		m_Button.ShowWindow(SW_NORMAL);
	}

    return bResult;
}

void CAsCoolGridCellButton::OnClick(CPoint PointCellRelative)
{
	// PointCellRelative is relative to the topleft of the cell. Convert to client coords
	PointCellRelative += m_Rect.TopLeft();
}

BEGIN_MESSAGE_MAP(CInplaceButton, CButton)
END_MESSAGE_MAP()

BOOL CInplaceButton::OnChildNotify(UINT message, WPARAM wParam, LPARAM lParam, LRESULT* pLResult)
{
	if (message == WM_CTLCOLORBTN)
	{
		//CWnd *pParent = GetParent();
		//if (pParent->IsKindOf(RUNTIME_CLASS(CAsCoolGridCtrl)))
		//{
		//	CAsCoolGridCtrl *pGrid = (CAsCoolGridCtrl*) pParent;
		//	COLORREF bkclr = pGrid->GetItemBkColour(m_nRow, m_nCol);
		//	CDC dc;
		//	dc.FromHandle(HDC(lParam));

		//	//dc.SetBkColor(bkclr);
		//	return TRUE;
		//}
	}

	return CButton::OnChildNotify(message, wParam, lParam, pLResult);
}

BOOL CInplaceButton::PreTranslateMessage(MSG* pMsg)
{
	// Send the Mouse Message to Parent Grid
	CWnd *pGrid = GetParent();
	CPoint pt(pMsg->pt);
	pGrid->ScreenToClient(&pt);
	pGrid->SendMessage( pMsg->message, pMsg->message, MAKELPARAM(pt.x, pt.y));
	
	return CButton::PreTranslateMessage(pMsg);
}
