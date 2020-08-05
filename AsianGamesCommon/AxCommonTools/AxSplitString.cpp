#include "stdafx.h"
#include "AxSplitString.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CAxSplitString::CAxSplitString()
{
	SetData(_T(""));
	SetSequenceAsOne(FALSE);
	SetSplitFlag(_T(","));	
}

CAxSplitString::~CAxSplitString()
{
}

//设置文本函数
void CAxSplitString::SetData(CString strData)
{
	m_strData = strData;
	m_strData.TrimLeft();
	m_strData.TrimRight();
}

CString CAxSplitString::GetData()
{
	return m_strData;
}

//切分操作函数
void CAxSplitString::GetSplitStrArray(CStringArray &array)
{
	CString strData = GetData();
	CString strSplitFlag = GetSplitFlag();

	if (strData.Right(1) != strSplitFlag) 
		strData +=strSplitFlag;

	CString strTemp;
	int pos =-1;
	while ((pos=strData.Find(strSplitFlag,0)) != -1)
	{
		strTemp = strData.Left(pos);
		if (!GetSequenceAsOne())
		{
			array.Add(strTemp);
		}
		else
		{
			//连续的分隔符视为单个处理
			if (!strTemp.IsEmpty() && strTemp !="") 
			{
				array.Add(strTemp);
			}
		}
		strData = strData.Right(strData.GetLength() - pos - 1);
	}
}
