using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.Data.SqlClient;
using AutoSports.OVRCommon;

namespace AutoSports.OVRWLPlugin
{
    public partial class OVRWLSetting : Office2007Form
    {
        public OVRWLSetting()
        {
            InitializeComponent();

            Localization();
        }

        private void OVRWLAutoDrawForm_Load(object sender, EventArgs e)
        {
            string tsPath = ConfigurationManager.GetPluginSettingString("WL", "TimingScoringPath");
            txtFolder.Text = tsPath;
        }

        private void OVRWLAutoDrawForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (e.CloseReason == CloseReason.UserClosing)
            {
                if (this.Owner != null)
                    this.Owner.Activate();

                this.Visible = false;
                e.Cancel = true;
            }
        }

        #region Init Method
        private void Localization()
        {
            this.Text = "WL - Generate Lot Number";
            this.lbEvent.Text = LocalizationRecourceManager.GetString("OVRRegisterInfo", "lbEvent");
        }
        #endregion

        private void btnX_Browse_Click(object sender, EventArgs e)
        {
            DialogResult dgr = folderBrowserDialog1.ShowDialog();
            if (dgr == System.Windows.Forms.DialogResult.OK)
            {
                ConfigurationManager.SetPluginSettingString("WL", "TimingScoringPath", folderBrowserDialog1.SelectedPath);
                txtFolder.Text = folderBrowserDialog1.SelectedPath;
            }
        }

        private void btnXSave_Click(object sender, EventArgs e)
        {
            ConfigurationManager.SetPluginSettingString("WL", "TimingScoringPath", txtFolder.Text);
            ConfigurationManager.SaveConfiguration();
            this.Close();
        }
        
    }
}
