#pragma once

// lib comments 
#ifdef _DEBUG
#pragma comment(lib, "AsianGamesCommonD.lib")
#else
#pragma comment(lib, "AsianGamesCommon.lib")
#endif // _DEBUG

#define AX_OVRCOMMON_EXP __declspec (dllimport)

#include "..\AsianGamesCommon\CoolGridCtrl\CoolGridCtrl.h"
#include "..\AsianGamesCommon\AxCommonTools\AxCommonTools.h"

#include "..\AsianGamesCommon\AsianGamesCommonInit.h"


