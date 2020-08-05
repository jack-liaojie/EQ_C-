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
    public partial class AxModelWizardKnockSingleForm : UIForm
    {
        public AxModelWizardKnockSingleForm()
        {
            InitializeComponent();
        }

        public Int32 m_nPlayerCnt;	//记录下拥有人数,发生变化时,再更新默认选项

        static string m_strSectionName = "OVRDrawModel";

	    public void SetParam(Int32 nPlayerCnt)
        {
            if ( nPlayerCnt != m_nPlayerCnt )
            {
	            m_nPlayerCnt = nPlayerCnt;
	            Int32 nLayer = AxModelKnockOut.GetLayer(m_nPlayerCnt);
                this.cbGroupSize.SelectedIndex = nLayer - 1;
            }
        }

	    public void SetStageName(String strStageName)
        {
            this.tbStageTitle.Text = strStageName;
        }

        public Int32 GetLayerCntPerGroup()
        {
            return this.cbGroupSize.SelectedIndex + 1;
        }

        public Int32 GetQualCntPerGroup()
        {
            return this.cbGroupCount.SelectedIndex + 1;
        }

        public String GetStageTitle()     //此阶段名称

        {
            String strTemp;
            strTemp = this.tbStageTitle.Text;
            return strTemp;
        }

        public Boolean isValued()         //所有设置是否合法,会弹出对话框提示
        {
            Int32 nPlayerCnt = (Int32)Math.Pow(2, GetLayerCntPerGroup());
            if (nPlayerCnt < GetQualCntPerGroup())
            {
                String strMsg = LocalizationRecourceManager.GetString(m_strSectionName, "KORankPlayerError");
                DevComponents.DotNetBar.MessageBoxEx.Show(strMsg);
                return false;
            }

            return true;
        }

        private void Localization()
        {
            this.lbStageTitle.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbStageTitle");
            this.lbGroupSize.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbMaxSize");
            this.lbGroupCount.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbRankSize");
        }

        private void InitCtrlStyleContent()
        {
            for (Int32 nCyc = 1; nCyc <= 8; nCyc++)
            {
                Int32 nSize = (Int32)Math.Pow(2, nCyc);
                this.cbGroupSize.Items.Add(nSize);
            }

            for (Int32 nCyc = 1; nCyc <= 8; nCyc++)
            {
                this.cbGroupCount.Items.Add(nCyc);
            }

            this.tbStageTitle.Text = LocalizationRecourceManager.GetString(m_strSectionName, "cbTypeKnockOut");
            this.cbGroupSize.SelectedIndex = 2;
            this.cbGroupCount.SelectedIndex = 2;
        }

        private void AxModelWizardKnockSingleForm_Load(object sender, EventArgs e)
        {
            Localization();
            InitCtrlStyleContent();
        }
    }
}
