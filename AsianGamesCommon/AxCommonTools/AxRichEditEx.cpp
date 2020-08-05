//AxRichEditEx.cpp
#include "stdafx.h"
#include "AxRichEditEx.h"

IMPLEMENT_DYNCREATE(CAxRichEditEx, CRichEditCtrl)

BEGIN_MESSAGE_MAP(CAxRichEditEx, CRichEditCtrl)
	//{{AFX_MSG_MAP(CAxRichEditEx)
	ON_CONTROL_REFLECT(EN_CHANGE, OnChange)
	ON_WM_GETDLGCODE()
	ON_WM_CHAR()
	ON_WM_ERASEBKGND()
	//}}AFX_MSG_MAP
	ON_NOTIFY_REFLECT(EN_PROTECTED, OnProtected)
	ON_NOTIFY_REFLECT(EN_SELCHANGE, OnSelChange)
	ON_MESSAGE(WM_SETTEXT, OnSetText)
END_MESSAGE_MAP()


CAxRichEditEx::CAxRichEditEx()
{
	m_chComment = _T('\'');
	m_strComment = _T("rem");
	m_strStringQuotes = _T("\"");

	m_clrComment = RGB(100, 100, 100);
	m_clrNumber = RGB(0, 0, 0);
	m_clrString = RGB(0, 128, 0);
	m_clrKeyword = RGB(0, 0, 255);
	m_clrConstant = RGB(0, 0, 0);
	m_clrNormal = RGB(50, 50, 50);
	m_clrError = RGB(136, 0, 0);

	m_bInForcedChange = FALSE;
	m_changeType = ctUndo;
	m_crOldSel.cpMin = m_crOldSel.cpMax = 0;
}

CAxRichEditEx::~CAxRichEditEx()
{
}

BOOL CAxRichEditEx::Create(CWnd* pParentWnd, const RECT& rect, UINT nID,
						  DWORD dwStyleEx, DWORD dwStyle/* = WS_CHILD|WS_VISIBLE|WS_TABSTOP|WS_BORDER */)
{
	if(CRichEditCtrl::CreateEx(dwStyleEx, dwStyle, rect, pParentWnd, nID))
	{
		SetBackgroundColor(FALSE, RGB(184, 184, 184) );
		Initialize();

		LOGFONT m_lf;

		m_lf.lfHeight = 13;
		m_lf.lfWeight = 0;
		m_lf.lfEscapement = 0;
		m_lf.lfOrientation = 0;
		m_lf.lfWeight = 0;
		m_lf.lfItalic = FALSE;
		m_lf.lfUnderline = FALSE;
		m_lf.lfStrikeOut = FALSE;
		m_lf.lfCharSet = GB2312_CHARSET;
		m_lf.lfOutPrecision = OUT_STROKE_PRECIS;
		m_lf.lfClipPrecision = CLIP_STROKE_PRECIS;
		m_lf.lfQuality = DRAFT_QUALITY;
		m_lf.lfPitchAndFamily = VARIABLE_PITCH|FF_MODERN;
		lstrcpy(m_lf.lfFaceName,_T("System"));

		CFont   myFont;   
		myFont.CreateFontIndirect(&m_lf);   
		SetFont(&myFont);

		//设置TAB间隔
		SetWindowText(_T(" "));  
		CPoint p1 = GetCharPos(0);
		CPoint p2 = GetCharPos(1);
		int nCharSpaceWidth = p2.x - p1.x;	//空格宽度

		SetWindowText(_T("\t"));  
		p1 = GetCharPos(0);	
		p2 = GetCharPos(1);
		int nCharTabWidth = p2.x - p1.x;	//TAB宽度

		CDC *pdc = GetDC();
		PARAFORMAT pf ;
		pf.cbSize = sizeof(PARAFORMAT);
		pf.dwMask = PFM_TABSTOPS ;
		pf.cTabCount = MAX_TAB_STOPS;
		GetParaFormat( pf );
		int nSynCtrlTabSize = pf.rgxTabs[0];
		if(nSynCtrlTabSize == 0)
			nSynCtrlTabSize = 720;

		int nNewTab;
		nNewTab = int(nSynCtrlTabSize * 1.0 * 4 * nCharSpaceWidth / nCharTabWidth);

		pf.cTabCount = MAX_TAB_STOPS;
		pf.dwMask = PFM_TABSTOPS;
		for( int itab = 0; itab < pf.cTabCount; itab++ )
			pf.rgxTabs[itab] = (itab+1) * nNewTab ;

		SetParaFormat( pf );

		return TRUE;
	}

	return FALSE;
}

void CAxRichEditEx::Initialize() 
{
	SetEventMask(ENM_CHANGE | ENM_SELCHANGE | ENM_PROTECTED);
}

void CAxRichEditEx::SetSLComment(TCHAR chComment, TCHAR chComment2)
{
	m_chComment = chComment;
	m_chComment2 = chComment2;
}

void CAxRichEditEx::SetSLComment(LPCTSTR lpszComment)
{
	m_strComment = lpszComment;
}

void CAxRichEditEx::AddKeywords(LPCTSTR lpszKwd)
{
	m_strKeywords = m_strKeywords + lpszKwd;
	m_strKeywordsLower = m_strKeywords;

	m_strKeywordsLower.MakeLower();
}

void CAxRichEditEx::ClearKeywords()
{
	m_strKeywords.Empty();
	m_strKeywordsLower.Empty();
}							  

void CAxRichEditEx::AddConstants(LPCTSTR lpszConst)
{
	m_strConstants = m_strConstants + lpszConst;
	m_strConstantsLower = m_strConstants;

	m_strConstantsLower.MakeLower();
}

void CAxRichEditEx::ClearConstants()
{
	m_strConstants.Empty();
	m_strConstantsLower.Empty();
}

void CAxRichEditEx::SetStringQuotes(LPCTSTR lpszStrQ)
{
	m_strStringQuotes = lpszStrQ;
}

void CAxRichEditEx::SetKeywordColor(COLORREF clr)
{
	m_clrKeyword = clr;
}

void CAxRichEditEx::SetConstantColor(COLORREF clr)
{
	m_clrConstant = clr;
}

void CAxRichEditEx::SetCommentColor(COLORREF clr)
{
	m_clrComment = clr;
}

void CAxRichEditEx::SetNumberColor(COLORREF clr)
{
	m_clrNumber = clr;
}

void CAxRichEditEx::SetStringColor(COLORREF clr)
{
	m_clrString = clr;
}

void CAxRichEditEx::SetErrorColor(COLORREF clr)
{
	m_clrError = clr;
}

void CAxRichEditEx::SetNormalColor(COLORREF clr)
{
	m_clrNormal = clr;
}

/////////////////////////////////////////////////////////////////////////////
// CAxRichEditEx message handlers
UINT CAxRichEditEx::OnGetDlgCode() 
{
	UINT uCode = CRichEditCtrl::OnGetDlgCode();

	uCode = DLGC_WANTALLKEYS | DLGC_WANTARROWS | \
		DLGC_WANTCHARS | DLGC_WANTMESSAGE | DLGC_WANTTAB;

	return uCode;
}

void CAxRichEditEx::OnChar(UINT nChar, UINT nRepCnt, UINT nFlags) 
{
	if (nChar == '\t' && GetKeyState(VK_CONTROL) >= 0)
	{
		ReplaceSel(_T("\t"));
		return;
	}

	CRichEditCtrl::OnChar(nChar, nRepCnt, nFlags);
}

int CAxRichEditEx::IsKeyword(LPCTSTR lpszSymbol)
{
	CString strSymbol;

	strSymbol.Format(_T(" %s "), lpszSymbol);
	strSymbol.MakeLower();

	return m_strKeywordsLower.Find(strSymbol);
}

int CAxRichEditEx::IsConstant(LPCTSTR lpszSymbol)
{
	CString strSymbol;

	strSymbol.Format(_T(" %s "), lpszSymbol);
	strSymbol.MakeLower();

	return m_strConstantsLower.Find(strSymbol);
}

BOOL CAxRichEditEx::IsStringQuote(TCHAR ch)
{
	return (m_strStringQuotes.Find(ch) >= 0);
}

void CAxRichEditEx::SetFormatRange(int nStart, int nEnd, COLORREF clr)
{
	if (nStart >= nEnd)
		return;

	SetSel(nStart, nEnd);

	CHARFORMAT2 cfm;
	cfm.cbSize = sizeof(cfm);
	GetSelectionCharFormat(cfm);

	if ((cfm.dwMask & CFM_COLOR)  && cfm.crTextColor == clr && 
		(cfm.dwMask & CFM_BOLD) && (cfm.dwEffects & CFE_BOLD) == CFE_BOLD)
		return;

	cfm.dwEffects = CFM_BOLD;
	cfm.crTextColor = clr;
	cfm.dwMask = CFM_BOLD | CFM_COLOR;

	SetSelectionCharFormat(cfm);
}

void CAxRichEditEx::ChangeCase(int nStart, int nEnd, LPCTSTR lpsz)
{
	ASSERT((nEnd - nStart) == (int)_tcslen(lpsz));

	SetSel(nStart, nEnd);
	ReplaceSel(lpsz);
}

void CAxRichEditEx::FormatTextRange(int nStart, int nEnd)
{
	if (nStart >= nEnd)
		return;

	m_bInForcedChange = TRUE;

	CHARRANGE crOldSel;
	GetSel(crOldSel);

	//LockWindowUpdate();
	HideSelection(TRUE, FALSE);

	TCHAR *pBuffer = NULL;
	try
	{
		//alloc a buffer
		SetSel(nStart, nEnd);
		pBuffer = new TCHAR[nEnd - nStart + 1];

		//initial the buffer
		CString strT = _T("");
		CRichEditCtrl::GetTextRange(nStart, nEnd, strT);
		wcscpy(pBuffer, strT.AllocSysString());

		TCHAR* pSymbolStart = NULL;
		COLORREF clrTemp;

		TCHAR *pStart, *pPtr;
		pStart = pPtr = pBuffer;
		while (*pPtr != 0)
		{
			TCHAR ch = *pPtr;

			if (ch == m_chComment && (m_chComment2 == 0 || pPtr[1] == m_chComment2))
			{
				pSymbolStart = pPtr;

				do
				{
					ch = *(++pPtr);
				}
				while (ch != 0 && ch != '\r');

				clrTemp = m_clrComment;
			}
			else if (IsStringQuote(ch))
			{ 
				// Process strings
				TCHAR ch1 = ch;
				pSymbolStart = pPtr;

				do
				{
					ch = *(++pPtr);
				}
				while (ch != 0 && ch != ch1 && ch != '\r');

				if (ch == ch1)
					pPtr++;

				clrTemp = m_clrString;
			} 
			else if (_istdigit(ch))
			{ 
				// Process numbers
				pSymbolStart = pPtr;
				_tcstod(pSymbolStart, &pPtr);

				clrTemp = m_clrNumber;
			}
			else if (_istalpha(ch) || ch == '_')
			{
				// Process keywords
				pSymbolStart = pPtr;

				do 
				{
					ch = *(++pPtr);
				}
				while (_istalnum(ch) || ch == '_');

				*pPtr = 0;
				int nPos = IsKeyword(pSymbolStart);

				if (nPos >= 0)//this is a keyword symbol
				{
					ChangeCase(nStart + (int)(pSymbolStart - pBuffer), nStart + (int)(pPtr - pBuffer), 
						m_strKeywords.Mid(nPos+1, (int)(pPtr - pSymbolStart))); 

					if (_tcsicmp(m_strComment, pSymbolStart) == 0)
					{
						*pPtr = ch;
						*pSymbolStart = m_chComment;

						if (pSymbolStart[1] != 0 && m_chComment2 != 0)
							pSymbolStart[1] = m_chComment2;

						pPtr = pSymbolStart;
						pSymbolStart = NULL;

						continue;
					}
					clrTemp = m_clrKeyword;
				}
				else//maybe this is a constant symbol
				{
					nPos = IsConstant(pSymbolStart);
					if (nPos >= 0)
					{
						ChangeCase(nStart + (int)(pSymbolStart - pBuffer), nStart + (int)(pPtr - pBuffer), 
							m_strConstants.Mid(nPos+1, (int)(pPtr - pSymbolStart)));

						clrTemp = m_clrConstant;
					}
					else
					{
						pSymbolStart = NULL;
					}
				}
				*pPtr = ch;
			}
			else
			{
				pPtr++;
			}

			if (pSymbolStart != NULL)//the symbol thing is find
			{
				ASSERT(pSymbolStart < pPtr);

				SetFormatRange(nStart + (int)(pStart - pBuffer),
					nStart + (int)(pSymbolStart - pBuffer), m_clrNormal);

				SetFormatRange(nStart + (int)(pSymbolStart - pBuffer),
					nStart + (int)(pPtr - pBuffer), clrTemp);

				pStart = pPtr;
				pSymbolStart = 0;
			}
			else if (*pPtr == 0)//no symbol exit and meet the end of the exp
			{
				SetFormatRange(nStart + (int)(pStart - pBuffer),
					nStart + (int)(pPtr - pBuffer), m_clrNormal);
			}
		}

	}
	catch(...){}

	delete [] pBuffer;

	SetSel(crOldSel);
	HideSelection(FALSE, FALSE);
	//UnlockWindowUpdate();

	m_bInForcedChange = FALSE;
}

void CAxRichEditEx::FormatTextLines(int nLineStart, int nLineEnd)
{
	long nStart = LineIndex(LineFromChar(nLineStart));
	long nEnd = LineIndex(LineFromChar(nLineEnd));
	nEnd += LineLength(nLineEnd);

	FormatTextRange(nStart, nEnd);
}


void CAxRichEditEx::FormatAll()
{
	FormatTextRange(0, GetTextLength());
}

LRESULT CAxRichEditEx::OnSetText(WPARAM wParam, LPARAM lParam)
{
	LRESULT res = Default();
	FormatAll();

	return res;	
}

void CAxRichEditEx::OnChange() 
{
	if (m_bInForcedChange)
		return;

	CHARRANGE crCurSel; 
	GetSel(crCurSel);

	if (m_changeType == ctMove && crCurSel.cpMin == crCurSel.cpMax)
	{
		// cut was canceled, so this is paste operation
		m_changeType = ctPaste;
	}

	switch(m_changeType)
	{
	case ctReplSel:// old=(x,y) -> cur=(x+len,x+len)
	case ctPaste:  // old=(x,y) -> cur=(x+len,x+len)
		{
			FormatTextLines(m_crOldSel.cpMin, crCurSel.cpMax);
		}
		break;
	case ctDelete: // old=(x,y) -> cur=(x,x)
	case ctBack:   // old=(x,y) -> cur=(x,x), newline del => old=(x,x+1) -> cur=(x-1,x-1)
	case ctCut:    // old=(x,y) -> cur=(x,x)
		{
			FormatTextLines(crCurSel.cpMin, crCurSel.cpMax);
		}
		break;
	case ctUndo:   // old=(?,?) -> cur=(x,y)
		{
			FormatTextLines(crCurSel.cpMin, crCurSel.cpMax);
		}
		break;
	case ctMove:   // old=(x,x+len) -> cur=(y-len,y) | cur=(y,y+len)
		{
			FormatTextLines(crCurSel.cpMin, crCurSel.cpMax);

			if (crCurSel.cpMin > m_crOldSel.cpMin) // move after
			{
				FormatTextLines(m_crOldSel.cpMin, m_crOldSel.cpMin);
			}
			else // move before
			{
				FormatTextLines(m_crOldSel.cpMax, m_crOldSel.cpMax);
			}
		}
		break;
	default:
		{
			FormatAll();
		}
		break;
	}

	//undo action does not call OnProtected, so make it default
	m_changeType = ctUndo;
}

void CAxRichEditEx::OnProtected(NMHDR* pNMHDR, LRESULT* pResult)
{
	ENPROTECTED* pEP = (ENPROTECTED*)pNMHDR;

	// determine type of change will occur
	switch (pEP->msg)
	{
	case WM_KEYDOWN:
		{
			switch (pEP->wParam)
			{
			case VK_DELETE:
				m_changeType = ctDelete;
				break;
			case VK_BACK:
				m_changeType = ctBack;
				break;
			default:
				m_changeType = ctUnknown;
				break;
			}
		}
		break;
	case EM_REPLACESEL:
	case WM_CHAR:
		{
			m_changeType = ctReplSel;
		}
		break;
	case WM_PASTE:
		{
			m_changeType = (m_changeType == ctCut)?ctMove:ctPaste;
		}
		break;
	case WM_CUT:
		{
			m_changeType = ctCut;
		}
		break;
	default:
		{
			m_changeType = ctUnknown;
		}
		break;
	};

	if (pEP->msg != EM_SETCHARFORMAT && m_changeType != ctMove)
	{
		m_crOldSel = pEP->chrg;
	}

	*pResult = FALSE;
}

void CAxRichEditEx::OnSelChange(NMHDR* pNMHDR, LRESULT* pResult)
{
	SELCHANGE* pSC = (SELCHANGE*)pNMHDR;

	*pResult = 0;
}
