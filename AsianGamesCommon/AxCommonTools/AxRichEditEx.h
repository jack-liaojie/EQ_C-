//RichEditEx.h
//可自动用颜色标记关键字的文本编辑框
#pragma once

class AX_OVRCOMMON_EXP CAxRichEditEx : public CRichEditCtrl
{
	DECLARE_DYNCREATE(CAxRichEditEx)
public:
	CAxRichEditEx();
	virtual ~CAxRichEditEx();

public:
	BOOL Create(CWnd* pParentWnd, const RECT& rect, UINT nID, DWORD dwStyleEx = 0, 
		DWORD dwStyle = WS_CHILD|WS_VISIBLE|WS_TABSTOP|WS_BORDER);

	void Initialize();

public:
	//Set comment symbol. ex. 'exp and rem exp
	void SetSLComment(TCHAR chComment, TCHAR chComment2 = 0);
	void SetSLComment(LPCTSTR lpszComment);

	//set string quote. ex. "
	void SetStringQuotes(LPCTSTR lpszStrQ);

	//deal with keywords and constants used in script space
	void AddKeywords(LPCTSTR lpszKwd);
	void AddConstants(LPCTSTR lpszKwd);
	void ClearKeywords();
	void ClearConstants();

	//set the sensitive color while coding
	//giving a wonderful effect expression in the RichEdit control
	void SetKeywordColor(COLORREF clr);
	void SetConstantColor(COLORREF clr);
	void SetCommentColor(COLORREF clr);
	void SetNumberColor(COLORREF clr);
	void SetStringColor(COLORREF clr);
	void SetNormalColor(COLORREF clr);
	void SetErrorColor(COLORREF clr);

	//functions used to make sure witch kind of symbol it is while importing
	BOOL IsStringQuote(TCHAR ch);
	int IsKeyword(LPCTSTR lpszSymbol);
	int IsConstant(LPCTSTR lpszSymbol);

public:
	//functions used to set the text to the right color
	void FormatAll();//ex. used while pasting
	void SetFormatRange(int nStart, int nEnd, COLORREF clr);//set the format param relatively
	void FormatTextRange(int nStart, int nEnd);//format the text from nStart to nEnd
	void FormatTextLines(int nStart, int nEnd);//make sure the text range to be formated
	void ChangeCase(int nStart, int nEnd, LPCTSTR lpszStr);//the format action
	void FormatError();//highlight the error script code

private:
	enum ChangeType
	{
		ctUndo,
		ctUnknown,
		ctReplSel,
		ctDelete,
		ctBack,
		ctCut,
		ctPaste,
		ctMove
	};

	TCHAR			m_chComment;
	TCHAR			m_chComment2;
	CString			m_strComment;
	CString			m_strStringQuotes;
	CString			m_strKeywords;
	CString			m_strKeywordsLower;
	CString			m_strConstants;
	CString			m_strConstantsLower;

	COLORREF		m_clrComment ;
	COLORREF		m_clrNumber  ;
	COLORREF		m_clrString  ;
	COLORREF		m_clrKeyword ;
	COLORREF		m_clrConstant;
	COLORREF		m_clrNormal	 ;
	COLORREF		m_clrError   ;

	BOOL			m_bInForcedChange;
	ChangeType		m_changeType;
	CHARRANGE		m_crOldSel;

	// Generated message map functions
protected:
	//{{AFX_MSG(M5DRichEdit)
	afx_msg void	OnChange();
	afx_msg UINT	OnGetDlgCode();
	afx_msg void	OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
	afx_msg LRESULT OnSetText(WPARAM wParam, LPARAM lParam);
	afx_msg void	OnProtected(NMHDR*, LRESULT* pResult);
	afx_msg void	OnSelChange(NMHDR*, LRESULT* pResult);
	//}}AFX_MSG

	DECLARE_MESSAGE_MAP()
};