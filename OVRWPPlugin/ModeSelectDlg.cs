using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
namespace AutoSports.OVRWPPlugin
{
    public enum Modetype
    {
        emUnKnow = -1,
        emSingleMachine = 1,
        emMul_Monitor = 2,
        emMul_Admin = 3,
        emMul_Substitute = 4,
        emMul_WhiteStat = 5,
        emMul_BlueStat = 6,
        emMul_DoubleTeamStat = 7,
    }
    public partial class ModeSelectDlg : Office2007Form
    {
        public int m_nMatchID;
        private Modetype m_emMode = Modetype.emUnKnow;
        public Modetype Mode
        {
            get
            {
                return m_emMode;
            } 
        }
        public ModeSelectDlg()
        {
            InitializeComponent();
            Localization();
            m_nMatchID = -1;
        }
         private void Localization()
        {
            String strSecName = GVAR.g_WPPlugin.GetSectionName();

            this.Text = LocalizationRecourceManager.GetString(strSecName, "frm_ModeSel");
            lbModeDesc.Text = LocalizationRecourceManager.GetString(strSecName, "lbModeDesc");
            lb_MultipleMode.Text = LocalizationRecourceManager.GetString(strSecName, "lb_MultipleMode");
            rd_BlueStat.Text = LocalizationRecourceManager.GetString(strSecName, "rd_BlueStat");
            rd_DoubleStat.Text = LocalizationRecourceManager.GetString(strSecName, "rd_DoubleStat");
            rd_WhiteStat.Text = LocalizationRecourceManager.GetString(strSecName, "rd_WhiteStat");
            rd_Substitute.Text = LocalizationRecourceManager.GetString(strSecName, "rd_Substitute");
            rd_Admin.Text = LocalizationRecourceManager.GetString(strSecName, "rd_Admin");
            rd_Monitor.Text = LocalizationRecourceManager.GetString(strSecName, "rd_Monitor");
            rd_SingleMode.Text = LocalizationRecourceManager.GetString(strSecName, "rd_SingleMode");
            btnOK.Text = LocalizationRecourceManager.GetString(strSecName, "btnOK");
            btnCancel.Text = LocalizationRecourceManager.GetString(strSecName, "btnCancel");
        }
         private void ModeSelectDlg_Load(object sender, EventArgs e)
         {
             if (m_nMatchID > 0)
             {
                 rd_Monitor.Checked = true; 
                 btnOK.Focus();
             }
         }

         private void btnOK_Click(object sender, EventArgs e)
         {
            this.DialogResult = DialogResult.OK;
            this.Close();
         }

         private void btnCancel_Click(object sender, EventArgs e)
         {
             this.DialogResult = DialogResult.Cancel;
             this.Close();
         }
         private void Mode_CheckedChanged(object sender, EventArgs e)
         {
             if (rd_SingleMode.Checked)
             {
                 m_emMode = Modetype.emSingleMachine;
             }
             else if(rd_Monitor.Checked)
             {
                 m_emMode = Modetype.emMul_Monitor;
             }
             else if (rd_Admin.Checked)
             {
                 m_emMode = Modetype.emMul_Admin;
             }
             else if (rd_Substitute.Checked)
             {
                 m_emMode = Modetype.emMul_Substitute;
             }
             else if (rd_WhiteStat.Checked)
             {
                 m_emMode = Modetype.emMul_WhiteStat;
             }
             else if (rd_BlueStat.Checked)
             {
                 m_emMode = Modetype.emMul_BlueStat;
             }
             else if (rd_DoubleStat.Checked)
             {
                 m_emMode = Modetype.emMul_DoubleTeamStat;
             }
         }
    }
}
