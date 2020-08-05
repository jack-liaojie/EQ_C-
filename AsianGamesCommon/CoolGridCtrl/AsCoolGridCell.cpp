// AsCoolGridCell.cpp : implementation file

#include "stdafx.h"
#include "AsCoolGridCell.h"
#include "AsCoolGridInPlaceEdit.h"
#include "AsCoolGridCtrl.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

IMPLEMENT_DYNCREATE(CAsCoolGridCell, CAsCoolGridCellBase)
IMPLEMENT_DYNCREATE(CAsCoolGridDefaultCell, CAsCoolGridCell)

/////////////////////////////////////////////////////////////////////////////
// GridCell

CAsCoolGridCell::CAsCoolGridCell()
{
    m_plfFont = NULL;
	CAsCoolGridCell::Reset();
}

CAsCoolGridCell::~CAsCoolGridCell()
{
    delete m_plfFont;
}

/////////////////////////////////////////////////////////////////////////////
// GridCell Attributes

void CAsCoolGridCell::operator=(const CAsCoolGridCell& cell)
{
    if (this != &cell) CAsCoolGridCellBase::operator=(cell);
}

void CAsCoolGridCell::Reset()
{
    CAsCoolGridCellBase::Reset();

    m_strText.Empty();
    m_nImage   = -1;
    m_lParam   = NULL;          
    m_pCoolGrid    = NULL;
    m_bEditing = FALSE;
    m_pEditWnd = NULL;

    m_nFormat = (DWORD)-1;       // Use default from CAsCoolGridDefaultCell
    m_crBkClr = CLR_DEFAULT;     // Background colour (or CLR_DEFAULT)
    m_crFgClr = CLR_DEFAULT;     // Forground colour (or CLR_DEFAULT)
    m_nMargin = (UINT)-1;        // Use default from CAsCoolGridDefaultCell

    delete m_plfFont;
    m_plfFont = NULL;            // Cell font
}

void CAsCoolGridCell::SetFont(const LOGFONT* plf)
{
    if (plf == NULL)
    {
        delete m_plfFont;
        m_plfFont = NULL;
    }
    else
    {
        if (!m_plfFont)
            m_plfFont = new LOGFONT;
        if (m_plfFont)
            memcpy(m_plfFont, plf, sizeof(LOGFONT)); 
    }
}

LOGFONT* CAsCoolGridCell::GetFont() const
{
    if (m_plfFont == NULL)
    {
        CAsCoolGridDefaultCell *pDefaultCell = (CAsCoolGridDefaultCell*) GetDefaultCell();
        if (!pDefaultCell)
            return NULL;

        return pDefaultCell->GetFont();
    }

    return m_plfFont; 
}

CFont* CAsCoolGridCell::GetFontObject() const
{
    // If the default font is specified, use the default cell implementation
    if (m_plfFont == NULL)
    {
        CAsCoolGridDefaultCell *pDefaultCell = (CAsCoolGridDefaultCell*) GetDefaultCell();
        if (!pDefaultCell)
            return NULL;

        return pDefaultCell->GetFontObject();
    }
    else
    {
        static CFont Font;
        Font.DeleteObject();
        Font.CreateFontIndirect(m_plfFont);
        return &Font;
    }
}

DWORD CAsCoolGridCell::GetFormat() const
{
    if (m_nFormat == (DWORD)-1)
    {
        CAsCoolGridDefaultCell *pDefaultCell = (CAsCoolGridDefaultCell*) GetDefaultCell();
        if (!pDefaultCell)
            return 0;

        return pDefaultCell->GetFormat();
    }

    return m_nFormat; 
}

UINT CAsCoolGridCell::GetMargin() const           
{
    if (m_nMargin == (UINT)-1)
    {
        CAsCoolGridDefaultCell *pDefaultCell = (CAsCoolGridDefaultCell*) GetDefaultCell();
        if (!pDefaultCell)
            return 0;

        return pDefaultCell->GetMargin();
    }

    return m_nMargin; 
}

/////////////////////////////////////////////////////////////////////////////
// GridCell Operations

BOOL CAsCoolGridCell::Edit(int nRow, int nCol, CRect rect, CPoint /* point */, UINT nID, UINT nChar)
{
    if ( m_bEditing )
	{      
		if (m_pEditWnd)
		{
			// Fix by GUAN, UNICODE can not be processed like DBCS
#ifdef UNICODE
			m_pEditWnd->SendMessage(WM_CHAR, nChar);
#else
			if( nChar < 0x80)
				m_pEditWnd->PostMessage(WM_CHAR, nChar);   
			else
				m_pEditWnd->PostMessage(WM_IME_CHAR, nChar);
#endif
		}
    }  
	else  
	{   
		DWORD dwStyle = ES_LEFT;
		if (GetFormat() & DT_RIGHT) 
			dwStyle = ES_RIGHT;
		else if (GetFormat() & DT_CENTER) 
			dwStyle = ES_CENTER;
		
		m_bEditing = TRUE;
		
		// InPlaceEdit auto-deletes itself
		CAsCoolGridCtrl* pGrid = GetGrid();
		m_pEditWnd = new CAsCoolGridInPlaceEdit(pGrid, rect, dwStyle, nID, nRow, nCol, GetText(), nChar);
    }
    return TRUE;
}

void CAsCoolGridCell::EndEdit()
{
    if (m_pEditWnd)
        ((CAsCoolGridInPlaceEdit*)m_pEditWnd)->EndEdit();
}

void CAsCoolGridCell::OnEndEdit()
{
    m_bEditing = FALSE;
    m_pEditWnd = NULL;
}

/////////////////////////////////////////////////////////////////////////////
// CAsCoolGridDefaultCell

CAsCoolGridDefaultCell::CAsCoolGridDefaultCell() 
{
    m_nFormat = DT_LEFT|DT_VCENTER|DT_SINGLELINE|DT_NOPREFIX | DT_END_ELLIPSIS;

    m_crFgClr = CLR_DEFAULT;
    m_crBkClr = CLR_DEFAULT;
    m_Size    = CSize(30,10);
    m_dwStyle = 0;

    NONCLIENTMETRICS ncm;
    ncm.cbSize = sizeof(NONCLIENTMETRICS);
    VERIFY(SystemParametersInfo(SPI_GETNONCLIENTMETRICS, sizeof(NONCLIENTMETRICS), &ncm, 0));
    SetFont(&(ncm.lfMessageFont));
}

CAsCoolGridDefaultCell::~CAsCoolGridDefaultCell()
{
    m_Font.DeleteObject(); 
}

void CAsCoolGridDefaultCell::SetFont(const LOGFONT* plf)
{
    ASSERT(plf);

    if (!plf) return;

    m_Font.DeleteObject();
    m_Font.CreateFontIndirect(plf);

    CAsCoolGridCell::SetFont(plf);

    // Get the font size and hence the default cell size
    CDC* pDC = CDC::FromHandle(::GetDC(NULL));
    if (pDC)
    {
        CFont* pOldFont = pDC->SelectObject(&m_Font);

        SetMargin(pDC->GetTextExtent(_T(" "), 1).cx);
        m_Size = pDC->GetTextExtent(_T(" XXXXXXXXXXXX "), 14);
        m_Size.cy = (m_Size.cy * 3) / 2;

        pDC->SelectObject(pOldFont);
        ReleaseDC(NULL, pDC->GetSafeHdc());
    }
    else
    {
        SetMargin(3);
        m_Size = CSize(40,16);
    }
}

LOGFONT* CAsCoolGridDefaultCell::GetFont() const
{
    ASSERT(m_plfFont);  // This is the default - it CAN'T be NULL!
    return m_plfFont;
}

CFont* CAsCoolGridDefaultCell::GetFontObject() const
{
    ASSERT(m_Font.GetSafeHandle());
    return (CFont*) &m_Font; 
}
