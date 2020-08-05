#pragma once

// lib comments 
#ifdef _DEBUG
#pragma comment(lib, "AxPublicD.lib")
#else
#pragma comment(lib, "AxPublic.lib")
#endif // _DEBUG

#ifndef AX_PUBLIC_EXP
#define AX_PUBLIC_EXP __declspec (dllimport)
#endif

#include "D:\AutoSports 2010\AutoSports Common\AxPublic\AxCommonUtils.h"
#include "D:\AutoSports 2010\AutoSports Common\AxPublic\AxCoolADO.h"
#include "D:\AutoSports 2010\AutoSports Common\AxPublic\AxTableRecordDef.h"
#include "D:\AutoSports 2010\AutoSports Common\AxPublic\AxReadWriteINI.h"
#include "D:\AutoSports 2010\AutoSports Common\AxPublic\AxStaticLabel.h"
#include "D:\AutoSports 2010\AutoSports Common\AxPublic\AxSplitString.h"
#include "D:\AutoSports 2010\AutoSports Common\AxPublic\AxStaDigiClock.h"
#include "D:\AutoSports 2010\AutoSports Common\AxPublic\AxIPAddressCtrl.h"
#include "D:\AutoSports 2010\AutoSports Common\AxPublic\AxStdioFileEx.h"
#include "D:\AutoSports 2010\AutoSports Common\AxPublic\AxIdeaEncryption.h"
#include "D:\AutoSports 2010\AutoSports Common\AxPublic\AxMarkup.h"
#include "D:\AutoSports 2010\AutoSports Common\AxPublic\AxRichEditEx.h"
#include "D:\AutoSports 2010\AutoSports Common\AxPublic\AxLogSystem.h"
#include "D:\AutoSports 2010\AutoSports Common\AxPublic\CoolGridCtrl\CoolGridCtrl.h"