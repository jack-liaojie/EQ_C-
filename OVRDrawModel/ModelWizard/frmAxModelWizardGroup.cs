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

namespace AutoSports.OVRDrawModel
{
    public partial class AxModelWizardGroupForm : UIForm
    {
        public AxModelWizardGroupForm()
        {
            InitializeComponent();
        }

        static string m_strSectionName = "OVRDrawModel";

        private void Localization()
        {
            this.lbStageTitle.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbStageTitle");
            this.lbGroupSize.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbGroupSize");
            this.lbGroupCount.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbGroupCount");
            this.lbGroupQual.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbGroupQual");
            this.lbGroupName.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbGroupName");
            this.lbNamingMode.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbNamingMode");
            this.chbUseBegol.Text = LocalizationRecourceManager.GetString(m_strSectionName, "chbUseBegol");
        }

        private void InitCtrlStyleContent()
        {
            for (Int32 nCyc = 3; nCyc <= 16; nCyc++)
            {
                this.cbGroupSize.Items.Add(nCyc);
            }

            for (int nCyc = 1; nCyc <= 8; nCyc++)
            {
                this.cbGroupQual.Items.Add(nCyc);
            }

            for (int nCyc = 2; nCyc <= 64; nCyc++)
            {
                this.cbGroupCount.Items.Add(nCyc);
            }

            this.tbStageTitle.Text = LocalizationRecourceManager.GetString(m_strSectionName, "cbTypeRoundRobin");
            this.tbGroupName.Text = LocalizationRecourceManager.GetString(m_strSectionName, "KOGroupGroup");
            this.cbGroupSize.SelectedIndex = 1;
            this.cbGroupQual.SelectedIndex = 1;
            this.cbGroupCount.SelectedIndex = 2;

            this.radLetter.Checked = true;

            UpdateUI_GroupName();
            UpdateUI_PlayerInfo();
        }

	    public Int32 GetGroupCnt()
        {
            return this.cbGroupCount.SelectedIndex + 2;
        }

	    public Int32 GetQualCntPerGroup()
        {
            return this.cbGroupQual.SelectedIndex + 1;
        }

	    public Int32 GetPlayerCntPerGroup()
        {
            return this.cbGroupSize.SelectedIndex + 3;
        }

	    public String GetStageTitle()   //�˽׶�����
        {
            String strTemp;
            strTemp = this.tbStageTitle.Text;
            return strTemp;
        }

        public void SetStageTitle(String strTitle)
        {
            this.tbStageTitle.Text = strTitle;
        }

        public String GetGroupPrefix()  //ÿ���ǰ׺��
        {
            String strTemp;
            strTemp = this.tbGroupName.Text;
            return strTemp;
        }

        public Boolean IsGroupNameUseLetter()
        {
            return this.radLetter.Checked;
        }

        public Boolean IsUseBogol()
        {
            return this.chbUseBegol.Checked;
        }

        public String GetGroupName(int nIndex)  //�����ڲ�����,����GroupA, GroupB,֮���
        {
            if (nIndex < 0 || nIndex >= GetGroupCnt())
            {
                return "";
            }

            String strValue;
            char byCharStart;
            if (IsGroupNameUseLetter())
            {
                byCharStart = 'A';
                byCharStart = (Char)(byCharStart + nIndex);
                strValue = String.Format("{0}{1}", GetGroupPrefix(), byCharStart.ToString());
            }
            else
            {
                byCharStart = 'A';
                strValue = String.Format("{0}{1}", GetGroupPrefix(), (nIndex+1).ToString());
            }

            return strValue;
        }

	    public void UpdateUI_GroupName()
        {
            String strGroupPrefix = GetGroupPrefix();
            String strGroupName;
            String strGroupNameDes;
            if (IsGroupNameUseLetter())
            {
                strGroupNameDes = LocalizationRecourceManager.GetString(m_strSectionName, "GroupNameLetter");
                strGroupName = String.Format(strGroupNameDes, strGroupPrefix, strGroupPrefix, strGroupPrefix, strGroupPrefix);
            }
            else
            {
                strGroupNameDes = LocalizationRecourceManager.GetString(m_strSectionName, "GroupNameNumber");
                strGroupName = String.Format(strGroupNameDes, strGroupPrefix, strGroupPrefix, strGroupPrefix, strGroupPrefix);
            }

            this.lbGroupNameDes.Text = strGroupName;
        }

        public void UpdateUI_PlayerInfo()
        {
            String strInfo;
            String strInfoDes;
            strInfoDes = LocalizationRecourceManager.GetString(m_strSectionName, "GroupInfo");
            strInfo = String.Format(strInfoDes, GetGroupCnt(), GetPlayerCntPerGroup(), GetQualCntPerGroup(), GetGroupCnt() * GetPlayerCntPerGroup(), GetGroupCnt() * GetQualCntPerGroup());

            this.lbPlayerCountDes.Text = strInfo;
        }

        private void radNumber_CheckedChanged(object sender, EventArgs e)
        {
            UpdateUI_GroupName();
        }

        private void radLetter_CheckedChanged(object sender, EventArgs e)
        {
            UpdateUI_GroupName();
        }

        private void tbGroupName_TextChanged(object sender, EventArgs e)
        {
            UpdateUI_GroupName();
        }

        private void cbGroupSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateUI_PlayerInfo();
        }

        private void cbGroupCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateUI_PlayerInfo();
        }

        private void cbGroupQual_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateUI_PlayerInfo();
        }

        private void AxModelWizardGroupForm_Load(object sender, EventArgs e)
        {
            Localization();
            InitCtrlStyleContent();
        }
    }
}