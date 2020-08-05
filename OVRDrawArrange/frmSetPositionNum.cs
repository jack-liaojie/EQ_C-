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

namespace AutoSports.OVRDrawArrange
{
    public partial class frmSetPositionNum : UIForm
    {
        public bool m_bSetCompettionPos = false;

        public frmSetPositionNum()
        {
            InitializeComponent();
        }

        static string m_strSectionName = "OVRDrawArrange";
        public Int32 m_nPositionNum = 1;

        private void Localization()
        {
            if (m_bSetCompettionPos)
            {
                this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "frmSetPositionNum_CompetitionPos");
                this.lbPosNum.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPosNum_CompetitionPos");
            }
            else
            {
                this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "frmSetPositionNum");
                this.lbPosNum.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbPosNum");
            }
            this.tbPosNum.Text = "1";
        }

        private void frmSetPositionNum_Load(object sender, EventArgs e)
        {
            Localization();
        }

        private void btnOk_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
            m_nPositionNum = Convert.ToInt32(this.tbPosNum.Text);
            Close();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            Close();
        }

        private void tbPosNum_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                this.DialogResult = DialogResult.OK;
                m_nPositionNum = Convert.ToInt32(this.tbPosNum.Text);
                Close();
            }
        }
    }
}
