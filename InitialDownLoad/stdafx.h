
// stdafx.h : ��׼ϵͳ�����ļ��İ����ļ���
// ���Ǿ���ʹ�õ��������ĵ�
// �ض�����Ŀ�İ����ļ�

#pragma once

#ifndef _SECURE_ATL
#define _SECURE_ATL 1
#endif

#ifndef VC_EXTRALEAN
#define VC_EXTRALEAN            // �� Windows ͷ���ų�����ʹ�õ�����
#endif

#include "targetver.h"

#define _ATL_CSTRING_EXPLICIT_CONSTRUCTORS      // ĳЩ CString ���캯��������ʽ��

// �ر� MFC ��ĳЩ�����������ɷ��ĺ��Եľ�����Ϣ������
#define _AFX_ALL_WARNINGS

#include <afxwin.h>         // MFC ��������ͱ�׼���
#include <afxext.h>         // MFC ��չ


#include <afxdisp.h>        // MFC �Զ�����



#ifndef _AFX_NO_OLE_SUPPORT
#include <afxdtctl.h>           // MFC �� Internet Explorer 4 �����ؼ���֧��
#endif
#ifndef _AFX_NO_AFXCMN_SUPPORT
#include <afxcmn.h>             // MFC �� Windows �����ؼ���֧��
#endif // _AFX_NO_AFXCMN_SUPPORT

#include <afxcontrolbars.h>     // �������Ϳؼ����� MFC ֧��


//#include "AxCommon_Export.h"

#include ".\AxPublic\AxCommonUtils.h"
#include ".\AxPublic\AxCoolADO.h"
#include ".\AxPublic\AxTableRecordDef.h"
#include ".\AxPublic\AxReadWriteINI.h"
#include ".\AxPublic\AxStaticLabel.h"
#include ".\AxPublic\AxSplitString.h"
#include ".\AxPublic\AxStaDigiClock.h"
#include ".\AxPublic\AxIPAddressCtrl.h"
#include ".\AxPublic\AxStdioFileEx.h"
#include ".\AxPublic\AxIdeaEncryption.h"
#include ".\AxPublic\AxMarkup.h"
#include ".\AxPublic\AxRichEditEx.h"
#include ".\AxPublic\AxLogSystem.h"
#include ".\AxPublic\\CoolGridCtrl\CoolGridCtrl.h"

// ���Grid �ؼ�
BOOL AxCommonFillGridCtrl(CAsCoolGridCtrl* pGridCtrl, CAxADORecordSet& recordSet, BOOL bColorRow = TRUE, COLORREF clrOddRow = GRID_ODD_ROW_COLOR, COLORREF clrEvenRow = GRID_EVEN_ROW_COLOR, LOGFONT* lgHeaderFont = NULL, LOGFONT* lgCellTextFont = NULL);

BOOL AxCommonFillGridCtrl(CAsCoolGridCtrl* pGridCtrl, SAxTableRecordSet& rsTable, BOOL bColorRow = TRUE, COLORREF clrOddRow = GRID_ODD_ROW_COLOR, COLORREF clrEvenRow = GRID_EVEN_ROW_COLOR, LOGFONT* lgHeaderFont = NULL, LOGFONT* lgCellTextFont = NULL);



#ifdef _UNICODE
#if defined _M_IX86
#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='x86' publicKeyToken='6595b64144ccf1df' language='*'\"")
#elif defined _M_X64
#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='amd64' publicKeyToken='6595b64144ccf1df' language='*'\"")
#else
#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='*' publicKeyToken='6595b64144ccf1df' language='*'\"")
#endif
#endif


