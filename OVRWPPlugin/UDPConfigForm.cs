using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using DevComponents.DotNetBar.Controls;
using AutoSports.OVRCommon;
using System.IO;
using System.IO.Ports;
namespace AutoSports.OVRWPPlugin
{
    public partial class UDPConfigForm : Office2007Form
    {
        public UDPConfigForm()
        {
            
            InitializeComponent();
        }
        
        private void SerialConfigForm_Load(object sender, EventArgs e)
        {
            Localization();
        }
        private void Localization()
        {
            String strSecName = GVAR.g_WPPlugin.GetSectionName();
            //lb_UDP.Text = LocalizationRecourceManager.GetString(strSecName, "labelX_Stopbits");
            btn_OK.Text = LocalizationRecourceManager.GetString(strSecName, "btnOK");
            btn_Cancel.Text = LocalizationRecourceManager.GetString(strSecName, "btnCancel");
        }
        private void btn_OK_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
            this.Close();
        }
        private void btn_Cancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

        private void UDP_Port_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == 8 || Char.IsDigit(e.KeyChar) || e.KeyChar == 13)
            {
                if (e.KeyChar == 13)
                {
                    btn_OK.Focus();
                    e.Handled = true;
                }
            }
            else
            {
                e.Handled = true;
            }
        }
    }
}
