/////////////////////////////////////////////////////////////////////////
// FileName: AsSplitStr.h
// Description: Use Split string with flag.
// Date: 2007.02.275
// Author: Zhao Haijun
/////////////////////////////////////////////////////////////////////////

#pragma once

class AX_OVRCOMMON_EXP CAxSplitString
{
public:
	CAxSplitString();
	virtual ~CAxSplitString();

private:
	//切分的标志符号
	CString m_strSplitFlag;
	//连续的切分的标志符号当成一个标志处理
	BOOL m_bSequenceAsOne;
	//被切分的文本
	CString m_strData;

public:
	//得到切分好的文本串
	void GetSplitStrArray(CStringArray &array);
	//得到被切分的文本
	CString GetData();
	//设置被切分的文本
	void SetData(CString sData);
	//得到切分参数
	BOOL GetSequenceAsOne() {return m_bSequenceAsOne;};
	//设置切分参数
	void SetSequenceAsOne(BOOL bSequenceAsOne) {m_bSequenceAsOne = bSequenceAsOne;};
	//得到切分标志
	CString GetSplitFlag() {return m_strSplitFlag;};
	//设置切分标志
	void SetSplitFlag(CString strSplitFlag) {m_strSplitFlag = strSplitFlag;};
};


