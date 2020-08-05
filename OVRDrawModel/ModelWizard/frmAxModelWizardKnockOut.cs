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
    public partial class AxModelWizardKnockOutForm : UIForm
    {
        public AxModelWizardKnockOutForm()
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
        }

        private void InitCtrlStyleContent()
        {
	        for (Int32 nCyc=1; nCyc<=7; nCyc++)
	        {
                Int32 nSize = (Int32)Math.Pow(2, nCyc);
                this.cbGroupSize.Items.Add(nSize);
	        }

	        for (int nCyc=1; nCyc<=8; nCyc++)
	        {
                this.cbGroupQual.Items.Add(nCyc);
	        }

	        for (int nCyc=2; nCyc<=8; nCyc++)
	        {
                this.cbGroupCount.Items.Add(nCyc);
	        }

            this.tbStageTitle.Text = LocalizationRecourceManager.GetString(m_strSectionName, "KOStageQual");
            this.tbGroupName.Text = LocalizationRecourceManager.GetString(m_strSectionName, "KOGroupKnock");
            this.cbGroupSize.SelectedIndex = 2;
            this.cbGroupCount.SelectedIndex = 2;
            this.cbGroupQual.SelectedIndex = 1;

            this.radLetter.Checked = true;

	        UpdateUI_GroupName();
	        UpdateUI_PlayerInfo();
        }

        public Int32 GetGroupCnt()
        {
            return this.cbGroupCount.SelectedIndex + 2;
        }

        public Int32 GetLayerCntPerGroup()
        {
            return this.cbGroupSize.SelectedIndex + 1;
        }

        public Int32 GetQualCntPerGroup()
        {
            return this.cbGroupQual.SelectedIndex + 1;
        }

        public String GetGroupPrefix()   //每组的前缀名


        {
            String strTemp;
            strTemp = this.tbGroupName.Text;
            return strTemp;
        }

        public String GetStageTitle()   //此阶段名称


        {
            String strTemp;
            strTemp = this.tbStageTitle.Text;
            return strTemp;
        }

        public Boolean IsGroupNameUseLetter()
        {
            return this.radLetter.Checked;
        }

        public String GetGroupName(int nIndex)  //根据内部设置,返回GroupA, GroupB,之类的


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
                strValue = String.Format("{0}{1}", GetGroupPrefix(), (nIndex + 1).ToString());
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
            Int32 nPerGroup = (Int32)Math.Pow(2, GetLayerCntPerGroup());
            Int32 nTotalPlayer = GetGroupCnt() * nPerGroup;
            Int32 nQualPlayer = GetGroupCnt() * GetQualCntPerGroup();

            String strInfo;
            String strInfoDes;
            strInfoDes = LocalizationRecourceManager.GetString(m_strSectionName, "GroupInfo");
            strInfo = String.Format(strInfoDes, GetGroupCnt(), nPerGroup, GetQualCntPerGroup(), nTotalPlayer, nQualPlayer);

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

        private void AxModelWizardKnockOutForm_Load(object sender, EventArgs e)
        {
            Localization();
            InitCtrlStyleContent();
        }
    }
}
