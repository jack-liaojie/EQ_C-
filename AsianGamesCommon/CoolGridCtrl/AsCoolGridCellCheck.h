#if !defined(AFX_AsCoolGridCellCheck_H__ECD42822_16DF_11D1_992F_895E185F9C72__INCLUDED_)
#define AFX_AsCoolGridCellCheck_H__ECD42822_16DF_11D1_992F_895E185F9C72__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

/////////////////////////////////////////////////////////////////////////////
// AsCoolGridCellCheck.h : header file
//////////////////////////////////////////////////////////////////////


#include "AsCoolGridCell.h"


class AX_OVRCOMMON_EXP CAsCoolGridCellCheck : public CAsCoolGridCell
{
    friend class CAsCoolGridCtrl;
    DECLARE_DYNCREATE(CAsCoolGridCellCheck)

public:
    CAsCoolGridCellCheck();

public:
	BOOL SetCheck(BOOL bChecked = TRUE);
	BOOL GetCheck();
	void EnableInAnyCase(BOOL bEnableInAnyCase = FALSE); // TRUE: the cell can be checked even it is not editable, 
	CRect GetCheckPlacement(); // Return CheckBox's Rect

// Operations
	virtual CSize GetCellExtent(CDC* pDC);
    virtual void OnClick( CPoint PointCellRelative);
    virtual BOOL GetTextRect( LPRECT pRect);

protected:
    virtual BOOL Draw(CDC* pDC, int nRow, int nCol, CRect rect, BOOL bEraseBkgnd = TRUE);

protected:
    BOOL  m_bChecked;
	BOOL  m_bEnableInAnyCase;
    CRect m_Rect;
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_AsCoolGridCellCheck_H__ECD42822_16DF_11D1_992F_895E185F9C72__INCLUDED_)
