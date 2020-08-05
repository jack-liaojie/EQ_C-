#if !defined(AFX_AsCoolGridCellCombo_H__ECD42822_16DF_11D1_992F_895E185F9C72__INCLUDED_)
#define AFX_AsCoolGridCellCombo_H__ECD42822_16DF_11D1_992F_895E185F9C72__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

/////////////////////////////////////////////////////////////////////////////
// AsCoolGridCellCombo.h : header file
//////////////////////////////////////////////////////////////////////
#include "AsCoolGridCell.h"

struct STAxCmbItem  // 网格控件中ComboBox类型Cell的信息
{
	CString strContent;
	LPARAM	lpParam;

	STAxCmbItem()
	{
		strContent = _T("");
		lpParam = NULL;
	};
	STAxCmbItem(CString str, LPARAM lpData)
	{
		strContent = str;
		lpParam = lpData;
	};

};
typedef CArray<STAxCmbItem, STAxCmbItem&> AryAxCmbItems;

class AX_OVRCOMMON_EXP CAsCoolGridCellCombo : public CAsCoolGridCell
{
    friend class CGridCtrl;
    DECLARE_DYNCREATE(CAsCoolGridCellCombo)

public:
    CAsCoolGridCellCombo();

// editing cells
public:
    virtual BOOL  Edit(int nRow, int nCol, CRect rect, CPoint point, UINT nID, UINT nChar);
    virtual CWnd* GetEditWnd() const;
    virtual void  EndEdit();

// Operations
public:
	virtual CSize GetCellExtent(CDC* pDC);

// CAsCoolGridCellCombo specific calls
public:
    void  SetOptions(const AryAxCmbItems& aryAxItems);
    void  SetStyle(DWORD dwStyle)           { m_dwStyle = dwStyle; }
    DWORD GetStyle()                        { return m_dwStyle;    }
	void  DrawCmbMarkBtn(BOOL bDraw)		{ m_bDrawMarkBtn = bDraw;}

protected:
    virtual BOOL Draw(CDC* pDC, int nRow, int nCol, CRect rect, BOOL bEraseBkgnd = TRUE);

	AryAxCmbItems m_aryAxCmbItems;
    DWORD         m_dwStyle;
	BOOL		  m_bDrawMarkBtn;
};



/////////////////////////////////////////////////////////////////////////////
// CComboEdit window

#define IDC_COMBOEDIT 1001

class CComboEdit : public CEdit
{
// Construction
public:
	CComboEdit();

// Attributes
public:

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CComboEdit)
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CComboEdit();

	// Generated message map functions
protected:
	//{{AFX_MSG(CComboEdit)
	afx_msg void OnKillFocus(CWnd* pNewWnd);
	afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
	afx_msg void OnKeyUp(UINT nChar, UINT nRepCnt, UINT nFlags);
	//}}AFX_MSG

	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////
// CInPlaceList window

class CInPlaceList : public CComboBox
{
    friend class CComboEdit;

// Construction
public:
	CInPlaceList(CWnd* pParent,         // parent
                 CRect& rect,           // dimensions & location
                 DWORD dwStyle,         // window/combobox style
                 UINT nID,              // control ID
                 int nRow, int nColumn, // row and column
                 COLORREF crFore, COLORREF crBack,  // Foreground, background colour
				 AryAxCmbItems& aryAxCmbItems,   // Items in list
                 CString sInitText,     // initial selection
				 UINT nFirstChar);      // first character to pass to control

// Attributes
public:
   CComboEdit m_edit;  // subclassed edit control

// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CInPlaceList)
	protected:
	virtual void PostNcDestroy();
	//}}AFX_VIRTUAL

// Implementation
public:
	virtual ~CInPlaceList();
    void EndEdit();

protected:
    int GetCorrectDropWidth();

// Generated message map functions
protected:
	//{{AFX_MSG(CInPlaceList)
	afx_msg void OnKillFocus(CWnd* pNewWnd);
	afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
	afx_msg void OnKeyUp(UINT nChar, UINT nRepCnt, UINT nFlags);
	afx_msg void OnDropdown();
	afx_msg UINT OnGetDlgCode();
	afx_msg void OnSelendOK();
	//}}AFX_MSG

	DECLARE_MESSAGE_MAP()

private:
	int		 m_nNumLines;
	CString  m_sInitText;
	int		 m_nRow;
	int		 m_nCol;
 	UINT     m_nLastChar; 
	BOOL	 m_bExitOnArrows; 
    COLORREF m_crForeClr, m_crBackClr;
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_AsCoolGridCellCombo_H__ECD42822_16DF_11D1_992F_895E185F9C72__INCLUDED_)
