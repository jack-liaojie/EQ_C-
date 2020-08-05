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
    public partial class AxModelWizardFirstForm : UIForm
    {
        public AxModelWizardFirstForm()
        {
            InitializeComponent();
        }

        static string m_strSectionName = "OVRDrawModel";

        private void Localization()
        {
            this.cbType.Items.Clear();
            this.cbType.Items.Add(LocalizationRecourceManager.GetString(m_strSectionName, "SingleKnockOut"));
            this.cbType.Items.Add(LocalizationRecourceManager.GetString(m_strSectionName, "SingleRoundRobin"));
            this.cbType.Items.Add(LocalizationRecourceManager.GetString(m_strSectionName, "RoundRobinKnockOut"));
            this.cbType.Items.Add(LocalizationRecourceManager.GetString(m_strSectionName, "DoubleKnockOut"));
            this.cbType.Items.Add(LocalizationRecourceManager.GetString(m_strSectionName, "RoundRobinMultiKnockOut"));
            this.cbType.SelectedIndex = 0;

            this.lbPic.Image = global::AutoSports.OVRDrawModel.Properties.Resources.KnockOut;
        }

        public EUseEventModel GetEventModelType()
        {
            EUseEventModel eType;
            Int32 nCurSel = this.cbType.SelectedIndex;
            eType = (EUseEventModel)nCurSel;

            return eType;
        }

        public void SetEventModelType(EUseEventModel eType)
        {
            this.cbType.SelectedIndex = (Int32)eType;
        }

        private void cbType_SelectedIndexChanged(object sender, EventArgs e)
        {
            Int32 nIndexType = this.cbType.SelectedIndex;

            switch (nIndexType)
            {
            case 0:
                this.lbPic.Image = global::AutoSports.OVRDrawModel.Properties.Resources.KnockOut;
            	break;
            case 1:
                this.lbPic.Image = global::AutoSports.OVRDrawModel.Properties.Resources.Group;
                break;
            case 2:
                this.lbPic.Image = global::AutoSports.OVRDrawModel.Properties.Resources.mGtoK;
                break;
            case 3:
                this.lbPic.Image = global::AutoSports.OVRDrawModel.Properties.Resources.mKtoK;
                break;
            case 4:
                this.lbPic.Image = global::AutoSports.OVRDrawModel.Properties.Resources.mGtomK;
                break;
            default:
                break;
            }
        }

        private void AxModelWizardFirstForm_Load(object sender, EventArgs e)
        {
            Localization();
        }
    }
}