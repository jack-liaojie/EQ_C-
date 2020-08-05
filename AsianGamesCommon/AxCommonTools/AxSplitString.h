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
	//�зֵı�־����
	CString m_strSplitFlag;
	//�������зֵı�־���ŵ���һ����־����
	BOOL m_bSequenceAsOne;
	//���зֵ��ı�
	CString m_strData;

public:
	//�õ��зֺõ��ı���
	void GetSplitStrArray(CStringArray &array);
	//�õ����зֵ��ı�
	CString GetData();
	//���ñ��зֵ��ı�
	void SetData(CString sData);
	//�õ��зֲ���
	BOOL GetSequenceAsOne() {return m_bSequenceAsOne;};
	//�����зֲ���
	void SetSequenceAsOne(BOOL bSequenceAsOne) {m_bSequenceAsOne = bSequenceAsOne;};
	//�õ��зֱ�־
	CString GetSplitFlag() {return m_strSplitFlag;};
	//�����зֱ�־
	void SetSplitFlag(CString strSplitFlag) {m_strSplitFlag = strSplitFlag;};
};


