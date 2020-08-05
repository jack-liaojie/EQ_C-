using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.Data.SqlClient;
using AutoSports.OVRCommon;

namespace AutoSports.OVRGFPlugin
{
    public partial class frmModifyGroup : DevComponents.DotNetBar.Office2007Form
    {
        public Int32 m_iCurMatchID;
        public Int32 m_iGroup;
        public Int32 m_iTee;
        public string m_strStartTime;

        public frmModifyGroup()
        {
            InitializeComponent();
        }

        private void Localization()
        {
            this.lb_Group.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbGroup");
            this.lb_StartTee.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbStartTee");
            this.lb_StartTime.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbStartTime");
        }

        private void frmModifyGroup_Load(object sender, EventArgs e)
        {
            Localization();

            FillGroupInfo();
        }

        private void FillGroupInfo()
        {
            GFCommon.g_ManageDB.FillGroupInfo(m_iCurMatchID, m_iGroup, out m_iTee, out m_strStartTime);

            tb_Group.Text = Convert.ToString(m_iGroup);
            tb_Tees.Text = Convert.ToString(m_iTee);
            dti_StartTime.Text = m_strStartTime;
        }

        private void tb_Tees_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar != 8 && !Char.IsDigit(e.KeyChar) && e.KeyChar != 13)
            {
                e.Handled = true;
            }
        }

        private void btnx_OK_Click(object sender, EventArgs e)
        {
            m_iTee = GFCommon.ConvertStrToInt(tb_Tees.Text);
            m_strStartTime = dti_StartTime.Text;

            Boolean bResult = GFCommon.g_ManageDB.UpdateMatchGroup(m_iCurMatchID, m_iGroup, m_iTee, m_strStartTime);

            if (bResult)
            {
                this.DialogResult = DialogResult.OK;
            }

            this.Close();
        }

        private void btnx_Cancel_Click(object sender, EventArgs e)
        {
            this.Close();
        } 
    }
}
