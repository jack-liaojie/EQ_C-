// AsCoolGridCellCheck.cpp : implementation file

#include "stdafx.h"
#include "AsCoolGridCell.h"
#include "AsCoolGridCtrl.h"

#include "AsCoolGridCellCheck.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

IMPLEMENT_DYNCREATE(CAsCoolGridCellCheck, CAsCoolGridCell)

CAsCoolGridCellCheck::CAsCoolGridCellCheck() : CAsCoolGridCell()
{
    m_bChecked = FALSE;
	m_bEnableInAnyCase = FALSE;
    //m_Rect.IsRectNull();
}

CSize CAsCoolGridCellCheck::GetCellExtent(CDC* pDC)
{
    // Using SM_CXHSCROLL as a guide to the size of the checkbox
    int nWidth = GetSystemMetrics(SM_CXHSCROLL) + 2*GetMargin();	
    CSize	cellSize = CAsCoolGridCell::GetCellExtent(pDC);	
    cellSize.cx += nWidth;	
    cellSize.cy = max (cellSize.cy, nWidth);	
    return  cellSize;
}

// i/o:  i=dims of cell rect; o=dims of text rect
BOOL CAsCoolGridCellCheck::GetTextRect( LPRECT pRect)
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
BOOL CAsCoolGridCellCheck::Draw(CDC* pDC, int nRow, int nCol, CRect rect,  BOOL bEraseBkgnd /*=TRUE*/)
{
    BOOL bResult = CAsCoolGridCell::Draw(pDC, nRow, nCol, rect,  bEraseBkgnd);

#ifndef _WIN32_WCE
    // Store the cell's dimensions for later
    m_Rect = rect;

    CRect CheckRect = GetCheckPlacement();
    rect.left = CheckRect.right;

    // enough room to draw?
    // if (CheckRect.Width() < rect.Width() && CheckRect.Height() < rect.Height()) {

    // Do the draw 
    pDC->DrawFrameControl(GetCheckPlacement(), DFC_BUTTON, 
	    (m_bChecked)? DFCS_BUTTONCHECK | DFCS_CHECKED : DFCS_BUTTONCHECK);

    // }
#endif
    return bResult;
}

void CAsCoolGridCellCheck::OnClick(CPoint PointCellRelative)
{
	// PointCellRelative is relative to the topleft of the cell. Convert to client coords
	PointCellRelative += m_Rect.TopLeft();

    // Bail if cell is read-only
    CAsCoolGridCellID cell = GetGrid()->GetCellFromPt(PointCellRelative);	
	if (!GetGrid()->IsValid(cell)) return;
    if (!m_bEnableInAnyCase && !GetGrid()->IsCellEditable(cell))		
        return;

	// GetCheckPlacement returns the checkbox dimensions in client coords. Only check/
	// uncheck if the user clicked in the box
	if (GetCheckPlacement().PtInRect(PointCellRelative))
	{
		m_bChecked = !m_bChecked;
		GetGrid()->InvalidateRect(m_Rect);
	}
}

//////////////////////////////////////////////////////////////////////
// Operations
//////////////////////////////////////////////////////////////////////

BOOL CAsCoolGridCellCheck::SetCheck(BOOL bChecked /*=TRUE*/)
{
	BOOL bTemp = m_bChecked;
	m_bChecked = bChecked;
	if (!m_Rect.IsRectEmpty())
		GetGrid()->InvalidateRect(m_Rect);

	return bTemp;
}

BOOL CAsCoolGridCellCheck::GetCheck()
{
	return m_bChecked;
}

void CAsCoolGridCellCheck::EnableInAnyCase(BOOL bEnableInAnyCase /* = FALSE */)
{
	m_bEnableInAnyCase = bEnableInAnyCase;
}

//////////////////////////////////////////////////////////////////////
// Protected implementation
//////////////////////////////////////////////////////////////////////

// Returns the dimensions and placement of the checkbox in client coords.
CRect CAsCoolGridCellCheck::GetCheckPlacement()
{
	int nWidth = GetSystemMetrics(SM_CXHSCROLL);
	CRect place = m_Rect + CSize(GetMargin(), GetMargin());
    place.right = place.left + nWidth;
    place.bottom = place.top + nWidth;

	/* for centering
	int nDiff = (place.Width() - nWidth)/2;
	if (nDiff > 0)
	{
		place.left += nDiff;
		place.right = place.left + nWidth;
	}
	nDiff = (place.Height() - nWidth)/2;
	if (nDiff > 0)
	{
		place.top += nDiff;
		place.bottom = place.top + nWidth;
	}
    */

    if (m_Rect.Height() < nWidth + 2 * static_cast<int> (GetMargin())) 
    {		
        place.top = m_Rect.top + (m_Rect.Height() - nWidth) / 2;	    
        place.bottom = place.top + nWidth;	
    }

	return place;
}