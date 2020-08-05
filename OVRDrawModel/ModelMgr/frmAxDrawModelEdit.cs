using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using Sunny.UI;

//����һ��С����ģ������Ա༭
//����09-04-08

//������Drawʱ��ֱ�ӵ���DoModel, ֮��GetDrawInfo����������ֵ
//�༭ʱ,��SetDrawInfo,֮��DoModel, ��GetDrawInfo����������ֵ,ͨ��IsModified...�ж��޸ĵ�����Ӱ�췶Χ

namespace AutoSports.OVRDrawModel
{
    public partial class AxDrawModelEditForm : UIForm
    {
        public AxDrawModelEditForm()
        {
            InitializeComponent();
        }

        protected Boolean m_bIsModify;	//�����ͱ༭����ģ��ʱ,������ʾ�ô���
        protected AxDrawModelInfo m_stDrawInfo = new AxDrawModelInfo();
        protected AxDrawModelInfo m_stDrawInfoOld = new AxDrawModelInfo();	//Old�ǲ��޸ĵ�,�����ж��Ƿ��޸�������,�Ƿ��޸�������

        static string m_strSectionName = "OVRDrawModel";

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "frmDrawModelEdit");
            this.lbTitle.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbTitle");
            this.lbType.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbType");
            this.lbNumber.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbNumber");
            this.lbRank.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbRank");
            this.chbBracket.Text = LocalizationRecourceManager.GetString(m_strSectionName, "chbBracket");
            this.chbBegol.Text = LocalizationRecourceManager.GetString(m_strSectionName, "chbBegol");
            this.btnOk.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnOk");
            this.btnCancel.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnCancel");
        }

        private void InitCtrlStyleContent()
        {
            this.cbType.Items.Clear();
            this.cbType.Items.Add(LocalizationRecourceManager.GetString(m_strSectionName, "cbTypeManual"));
            this.cbType.Items.Add(LocalizationRecourceManager.GetString(m_strSectionName, "cbTypeRoundRobin"));
            this.cbType.Items.Add(LocalizationRecourceManager.GetString(m_strSectionName, "cbTypeKnockOut"));
            this.chbBracket.Text = LocalizationRecourceManager.GetString(m_strSectionName, "chbBracket");
            this.chbBegol.Text = LocalizationRecourceManager.GetString(m_strSectionName, "chbUseBegol");

            //���½�ģʽ��,ǿ�Ƹ���ֵ
            if (!m_bIsModify)
            {
                m_stDrawInfo.m_eType = EDrawModelType.emTypeManual;
                m_stDrawInfo.m_nSize = 0;
                m_stDrawInfo.m_strTitle = LocalizationRecourceManager.GetString(m_strSectionName, "tbTitleManual");
            }

            //���ڲ��ṹ��ֵ��ʾ����
            this.cbType.SelectedIndex = (Int32)m_stDrawInfo.m_eType - 1;
            UpdateUI();

            Int32 nIndexType = this.cbType.SelectedIndex;

            if (nIndexType == 1) //ѭ����
            {
                this.cbNumber.SelectedIndex = m_stDrawInfo.m_nSize - 2;
            }
            else if (nIndexType == 2)
            {
                this.cbNumber.SelectedIndex = m_stDrawInfo.m_nSize - 1;
                this.cbRank.SelectedIndex = m_stDrawInfo.m_nRank - 1;
            }

            this.chbBracket.Checked = m_stDrawInfo.m_bQual;
            this.chbBegol.Checked = m_stDrawInfo.m_bBogol;
            this.tbTitle.Text = m_stDrawInfo.m_strTitle;
        }

        public Boolean IsModifiedName()  //��Input���Ƿ��޸�������
        {
            if (m_stDrawInfo.m_strTitle != m_stDrawInfoOld.m_strTitle)
                return true;
            else
                return false;
        }

        public Boolean IsModifiedQual()  //��Input���Ƿ��޸��˽���
        {
            if (m_stDrawInfo.m_bQual != m_stDrawInfoOld.m_bQual)
                return true;
            else
                return false;
        }

        public Boolean IsModifiedOther()  ////��Input���Ƿ��޸�����Ҫ�ӹ����µ�����
        {
            if (m_stDrawInfo.m_eType != m_stDrawInfoOld.m_eType ||
                m_stDrawInfo.m_nRank != m_stDrawInfoOld.m_nRank ||
                m_stDrawInfo.m_bBogol != m_stDrawInfoOld.m_bBogol ||
                m_stDrawInfo.m_nSize != m_stDrawInfoOld.m_nSize)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public AxDrawModelInfo GetDrawInfo()
        {
            return m_stDrawInfo;
        }

	    public void SetDrawInfo(AxDrawModelInfo drawInfo)
        {
            m_stDrawInfo = drawInfo;
            m_stDrawInfoOld = drawInfo;
            m_bIsModify = true; //Ϊ�޸�ģʽ
        }

        protected void UpdateUI()
        {
            int nMatchType = this.cbType.SelectedIndex;
            if (nMatchType == 0) //�ֹ����
            {
                this.cbRank.Items.Clear();
                this.cbRank.Enabled = false;
                this.chbBegol.Enabled = false;

                this.cbNumber.Items.Clear();
                this.cbNumber.Enabled = false;
                this.cbRank.Enabled = false;
                this.chbBracket.Enabled = false;

                this.tbTitle.Text = LocalizationRecourceManager.GetString(m_strSectionName, "tbTitleManual");
            }
            else if (nMatchType == 1) //ѭ����
            {
                this.cbRank.Items.Clear();
                this.cbRank.Enabled = false;
                this.chbBegol.Enabled = true;
                this.chbBracket.Enabled = false;
                this.tbTitle.Text = LocalizationRecourceManager.GetString(m_strSectionName, "cbTypeRoundRobin");

                this.cbNumber.Items.Clear();
                this.cbNumber.Enabled = true;

                for (Int32 nCyc = 2; nCyc <= 32; nCyc++)	//2-32��ÿ��
                {
                    this.cbNumber.Items.Add(nCyc);
                }

                this.cbNumber.SelectedIndex = 2;
            }
            else if (nMatchType == 2) //��̭��
            {
                this.chbBegol.Checked = false;
                this.chbBegol.Enabled = false;
                this.chbBracket.Enabled = false;
                this.cbRank.Enabled = true;
                this.tbTitle.Text = LocalizationRecourceManager.GetString(m_strSectionName, "cbTypeKnockOut");

                this.cbNumber.Items.Clear();
                this.cbNumber.Enabled = true;

                for (Int32 iCyc = 1; iCyc < 9; iCyc++)	//1-9��
                {
                    Int32 nCnt = (Int32)Math.Pow(2, iCyc);
                    this.cbNumber.Items.Add(nCnt);
                }

                this.cbNumber.SelectedIndex = 2;

                this.cbRank.Items.Clear();          //���1-8��	
                for (Int32 nCyc = 1; nCyc <= 8; nCyc++)
                {
                    this.cbRank.Items.Add(nCyc);
                }

                this.cbRank.SelectedIndex = 1;
              }

            m_stDrawInfo.m_strTitle = this.tbTitle.Text;
        }

        private void cbType_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateUI();
        }

        private void btnOk_Click(object sender, EventArgs e)
        {
            //�ѽ�������ݸ��ڲ��ṹ
            Int32 nTypeIndex = this.cbType.SelectedIndex;
            m_stDrawInfo.m_eType = (EDrawModelType)(nTypeIndex + 1);	//ǧ��ע��˳��

            m_stDrawInfo.m_strTitle = this.tbTitle.Text;

            if (nTypeIndex == 0) //Manual
            {
                m_stDrawInfo.m_nSize = 0;
                m_stDrawInfo.m_nRank = 0;
            }
            else if (nTypeIndex == 1) //С����
            {
                m_stDrawInfo.m_nSize = this.cbNumber.SelectedIndex + 2;
                m_stDrawInfo.m_nRank = m_stDrawInfo.m_nSize;
            }
            else
            {
                m_stDrawInfo.m_nSize = this.cbNumber.SelectedIndex + 1;
                m_stDrawInfo.m_nRank = this.cbRank.SelectedIndex + 1;
            }

            m_stDrawInfo.m_bQual = this.chbBracket.Checked;
            m_stDrawInfo.m_bBogol = this.chbBegol.Checked;

            if (m_stDrawInfo.m_eType == EDrawModelType.emTypeKonckOut)
            {
                Int32 nPlayerCnt = (Int32)Math.Pow(2, m_stDrawInfo.m_nSize);
                if (nPlayerCnt < m_stDrawInfo.m_nRank)
                {
                    String strMsg = LocalizationRecourceManager.GetString(m_strSectionName, "RankPlayerError");
                    DevComponents.DotNetBar.MessageBoxEx.Show(strMsg);
                    return;
                }
            }

            if (m_bIsModify && IsModifiedOther())
            {
                String strMsg = LocalizationRecourceManager.GetString(m_strSectionName, "DelModelOrNot");
                if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsg, "", MessageBoxButtons.YesNo) == DialogResult.Yes)
                {
                    return;
                }
            }

            this.DialogResult = DialogResult.OK;
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            m_stDrawInfo.RemoveAll();
            m_stDrawInfo.m_eType = EDrawModelType.emTypeNone;
            this.DialogResult = DialogResult.Cancel;
        }

        private void AxDrawModelEditForm_Load(object sender, EventArgs e)
        {
            Localization();
            InitCtrlStyleContent();
        }
    }
}