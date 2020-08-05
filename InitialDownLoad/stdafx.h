
// stdafx.h : 标准系统包含文件的包含文件，
// 或是经常使用但不常更改的
// 特定于项目的包含文件

#pragma once

#ifndef _SECURE_ATL
#define _SECURE_ATL 1
#endif

#ifndef VC_EXTRALEAN
#define VC_EXTRALEAN            // 从 Windows 头中排除极少使用的资料
#endif

#include "targetver.h"

#define _ATL_CSTRING_EXPLICIT_CONSTRUCTORS      // 某些 CString 构造函数将是显式的

// 关闭 MFC 对某些常见但经常可放心忽略的警告消息的隐藏
#define _AFX_ALL_WARNINGS

#include <afxwin.h>         // MFC 核心组件和标准组件
#include <afxext.h>         // MFC 扩展


#include <afxdisp.h>        // MFC 自动化类



#ifndef _AFX_NO_OLE_SUPPORT
#include <afxdtctl.h>           // MFC 对 Internet Explorer 4 公共控件的支持
#endif
#ifndef _AFX_NO_AFXCMN_SUPPORT
#include <afxcmn.h>             // MFC 对 Windows 公共控件的支持
#endif // _AFX_NO_AFXCMN_SUPPORT

#include <afxcontrolbars.h>     // 功能区和控件条的 MFC 支持


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

// 填充Grid 控件
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


