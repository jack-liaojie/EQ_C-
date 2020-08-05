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
    public partial class frmCreateGroup : DevComponents.DotNetBar.Office2007Form
    {
        public Int32 m_iCurMatchID;
        public Int32 m_iSides;

        public frmCreateGroup()
        {
            InitializeComponent();
        }

        private void Localization()
        {
            this.lb_Sides.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbSides");
        }

        private void frmCreateGroup_Load(object sender, EventArgs e)
        {
            Localization();
        }

        private void tb_Sides_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar != 8 && !Char.IsDigit(e.KeyChar) && e.KeyChar != 13)
            {
                e.Handled = true;
            }
        }

        private void btnx_OKCreateGroup_Click(object sender, EventArgs e)
        {
            m_iSides = GFCommon.ConvertStrToInt(tb_Sides.Text);

            String strMessage = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgGreateGroup1");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMessage, GFCommon.g_strSectionName, MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
            {
                return;
            }

            bool bResult = GFCommon.g_ManageDB.CreateMatchGroup(m_iCurMatchID, m_iSides);

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
