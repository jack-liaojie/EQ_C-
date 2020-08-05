// ***************************************************************
//  AsCoolGridCellButton.h   version:  1.0   ¡¤  date: 04/28/2009
//  -------------------------------------------------------------
//  Author: Guan Ren Liang 
//  -------------------------------------------------------------
//  Copyright (C) 2009 - All Rights Reserved
// ***************************************************************


#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#include "AsCoolGridCell.h"

class CInplaceButton : public CButton
{
public:
	CInplaceButton()
	{
		m_nRow = -1;
		m_nCol = -1;
	};
	virtual ~CInplaceButton(){};

	int m_nRow;
	int m_nCol;

protected:
	DECLARE_MESSAGE_MAP()

private:
	virtual BOOL OnChildNotify(UINT message, WPARAM wParam, LPARAM lParam, LRESULT* pLResult);
	virtual BOOL PreTranslateMessage(MSG* pMsg);
};


class AX_OVRCOMMON_EXP CAsCoolGridCellButton : public CAsCoolGridCell
{
    friend class CAsCoolGridCtrl;
    DECLARE_DYNCREATE(CAsCoolGridCellButton)

public:
    CAsCoolGridCellButton();

// Operations
	virtual CSize GetCellExtent(CDC* pDC);
    virtual void OnClick( CPoint PointCellRelative);
    virtual BOOL GetTextRect( LPRECT pRect);

protected:
    virtual BOOL Draw(CDC* pDC, int nRow, int nCol, CRect rect, BOOL bEraseBkgnd = TRUE);

protected:
    CRect m_Rect;

	CInplaceButton m_Button;
};

