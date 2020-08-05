// InPlaceEdit.cpp : implementation file

#include "stdafx.h"
#include "TCHAR.h"
#include "AsCoolGridInPlaceEdit.h"
#include "AsCoolGridCtrl.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CAsCoolGridInPlaceEdit

CAsCoolGridInPlaceEdit::CAsCoolGridInPlaceEdit(CWnd* pParent, CRect& rect, DWORD dwStyle, UINT nID,
											   int nRow, int nColumn, CString sInitText, UINT nFirstChar)
{
    m_sInitText     = sInitText;
    m_nRow          = nRow;
    m_nColumn       = nColumn;
    m_nLastChar     = 0; 
    m_bExitOnArrows = (nFirstChar != VK_LBUTTON);    // If mouse click brought us here,
                                                     // then no exit on arrows

    m_Rect = rect;  // For bizarre CE bug.

	// Adjust the Edit height
	CWindowDC dc(pParent);
	CFont *pFontDC = dc.SelectObject(pParent->GetFont());
	CSize size = dc.GetTextExtent( sInitText );
	dc.SelectObject( pFontDC );

	m_Rect.bottom += size.cy * (size.cx/m_Rect.Width());

	// Get client rect
	CRect ParentRect;
	pParent->GetClientRect( &ParentRect );

	if (m_Rect.bottom > ParentRect.bottom -10)
	{
		m_Rect.bottom = ParentRect.bottom - 10;
	}
    
    DWORD dwEditStyle = WS_BORDER|WS_CHILD|WS_VISIBLE| ES_AUTOVSCROLL| ES_MULTILINE | dwStyle;
    if (!Create(dwEditStyle, m_Rect, pParent, nID)) return;
    
    SetFont(pParent->GetFont());
    
    SetWindowText(sInitText);
    SetFocus();
    
    switch (nFirstChar)
	{
        case VK_LBUTTON: 
        case VK_RETURN:   SetSel((int)_tcslen(m_sInitText), -1); return;
        case VK_BACK:     SetSel((int)_tcslen(m_sInitText), -1); break;
        case VK_TAB:
        case VK_DOWN: 
        case VK_UP:   
        case VK_RIGHT:
        case VK_LEFT:  
        case VK_NEXT:  
        case VK_PRIOR: 
        case VK_HOME:
        case VK_SPACE:
        case VK_END:      SetSel(0,-1); return;
        default:          SetSel(0,-1);
    }

	// Fix by GUAN, UNICODE can not be processed like DBCS
#ifdef UNICODE
     SendMessage(WM_CHAR, nFirstChar);
#else
	// Added by KiteFly. When entering DBCS chars into cells the first char was being lost
    // SenMessage changed to PostMessage (John Lagerquist)
	if( nFirstChar < 0x80)
		PostMessage(WM_CHAR, nFirstChar);   
	else
		PostMessage(WM_IME_CHAR, nFirstChar);
#endif

}

CAsCoolGridInPlaceEdit::~CAsCoolGridInPlaceEdit()
{
}

BEGIN_MESSAGE_MAP(CAsCoolGridInPlaceEdit, CEdit)
    //{{AFX_MSG_MAP(CInPlaceEdit)
    ON_WM_KILLFOCUS()
    ON_WM_CHAR()
    ON_WM_KEYDOWN()
    ON_WM_GETDLGCODE()
	ON_WM_MOUSEACTIVATE()
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()

////////////////////////////////////////////////////////////////////////////
// CAsCoolGridInPlaceEdit message handlers

// If an arrow key (or associated) is pressed, then exit if
//  a) The Ctrl key was down, or
//  b) m_bExitOnArrows == TRUE
void CAsCoolGridInPlaceEdit::OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags) 
{
    if ((nChar == VK_PRIOR || nChar == VK_NEXT ||
        nChar == VK_DOWN  || nChar == VK_UP   ||
        nChar == VK_RIGHT || nChar == VK_LEFT) &&
        (m_bExitOnArrows || GetKeyState(VK_CONTROL) < 0))
    {
        m_nLastChar = nChar;
        GetParent()->SetFocus();
        return;
    }
    
    CEdit::OnKeyDown(nChar, nRepCnt, nFlags);
}

// As soon as this edit loses focus, kill it.
void CAsCoolGridInPlaceEdit::OnKillFocus(CWnd* pNewWnd)
{
    CEdit::OnKillFocus(pNewWnd);
    EndEdit();
}

void CAsCoolGridInPlaceEdit::OnChar(UINT nChar, UINT nRepCnt, UINT nFlags)
{
    if (nChar == VK_TAB || nChar == VK_RETURN)
    {
        m_nLastChar = nChar;
        GetParent()->SetFocus();    // This will destroy this window
        return;
    }
    if (nChar == VK_ESCAPE) 
    {
        SetWindowText(m_sInitText);    // restore previous text
        m_nLastChar = nChar;
        GetParent()->SetFocus();
        return;
    }
    
    CEdit::OnChar(nChar, nRepCnt, nFlags);
    
    // Resize edit control if needed
    
    // Get text extent
    CString str;
    GetWindowText( str );

    CWindowDC dc(this);
    CFont *pFontDC = dc.SelectObject(GetFont());
    CSize size = dc.GetTextExtent( str );
    dc.SelectObject( pFontDC );
       
    // Get client rect
    CRect ParentRect;
    GetParent()->GetClientRect( &ParentRect );
    
    // Check whether control needs to be resized
    // and whether there is space to grow
    if ( ( size.cy * (size.cx/m_Rect.Width()+1) ) > m_Rect.Height())
    {
        if(m_Rect.bottom < ParentRect.bottom -10 )
            m_Rect.bottom += size.cy;
        MoveWindow( &m_Rect );
    }
}

UINT CAsCoolGridInPlaceEdit::OnGetDlgCode() 
{
    return DLGC_WANTALLKEYS;
}

////////////////////////////////////////////////////////////////////////////
// CAsCoolGridInPlaceEdit overrides

// Stoopid win95 accelerator key problem workaround - Matt Weagle.
BOOL CAsCoolGridInPlaceEdit::PreTranslateMessage(MSG* pMsg) 
{
    // Catch the Alt key so we don't choke if focus is going to an owner drawn button
    if (pMsg->message == WM_SYSCHAR)
        return TRUE;
    
    return CWnd::PreTranslateMessage(pMsg);
}

// Auto delete
void CAsCoolGridInPlaceEdit::PostNcDestroy() 
{
    CEdit::PostNcDestroy();
    
    delete this;	
}

////////////////////////////////////////////////////////////////////////////
// CAsCoolGridInPlaceEdit implementation

void CAsCoolGridInPlaceEdit::EndEdit()
{
    CString str;

    // EFW - BUG FIX - Clicking on a grid scroll bar in a derived class
    // that validates input can cause this to get called multiple times
    // causing assertions because the edit control goes away the first time.
    static BOOL bAlreadyEnding = FALSE;

    if(bAlreadyEnding)
        return;

    bAlreadyEnding = TRUE;
    GetWindowText(str);

    // Send Notification to parent
    GV_DISPINFO dispinfo;

    dispinfo.hdr.hwndFrom = GetSafeHwnd();
    dispinfo.hdr.idFrom   = GetDlgCtrlID();
    dispinfo.hdr.code     = GVN_ENDLABELEDIT;

    dispinfo.item.mask    = LVIF_TEXT|LVIF_PARAM;
    dispinfo.item.row     = m_nRow;
    dispinfo.item.col     = m_nColumn;
    dispinfo.item.strText  = str;
    dispinfo.item.lParam  = (LPARAM) m_nLastChar;

    CWnd* pOwner = GetOwner();
    if (pOwner)
        pOwner->SendMessage(WM_NOTIFY, GetDlgCtrlID(), (LPARAM)&dispinfo );

    // Close this window (PostNcDestroy will delete this)
    if (IsWindow(GetSafeHwnd()))
        SendMessage(WM_CLOSE, 0, 0);

    bAlreadyEnding = FALSE;
}

// Stop the parent to process the WM_MOUSEACTIVE. 
// Because if the parent call SetFocus(), the Edit Window will be destroyed, 
// then the subsequent message(ex. WM_LBUTTONDOW) will cause Assert
int CAsCoolGridInPlaceEdit::OnMouseActivate(CWnd* pDesktopWnd, UINT nHitTest, UINT message)
{
	//return CEdit::OnMouseActivate(pDesktopWnd, nHitTest, message);
	return MA_ACTIVATE;
}