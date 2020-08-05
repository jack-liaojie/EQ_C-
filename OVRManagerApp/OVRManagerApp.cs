using System;
using System.Collections.Generic;
using System.Windows.Forms;
using Sunny.UI;
using AutoSports.OVRCommon;

namespace AutoSports.OVRManagerApp
{
    
    static class OVRManagerApp
    {

        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            ConfigurationManager.LoadConfiguration(System.IO.Path.GetDirectoryName(Application.ExecutablePath) + "\\OVRManagerApp.cfg");

            using (frmMain frmMainForm = new frmMain())
            {
                DialogResult drResult;
                frmMainForm.Show();
                

                using (OVRLoginForm fmlogin = new OVRLoginForm())
                {
                    fmlogin.ShowDialog();
                    frmMainForm.SqlCon = fmlogin.SqlCon;
                    frmMainForm.RoleID = fmlogin.RoleID;
                    frmMainForm.DiscCode = fmlogin.DiscCode;
                    drResult = fmlogin.DialogResult;
                    frmMainForm.SqlCon = fmlogin.SqlCon;
                }

                if (drResult == DialogResult.OK)
                {
                    frmMainForm.SystemOpen();
                    Application.Run(frmMainForm);

                }
            }

            ConfigurationManager.SaveConfiguration();
        }
    }
}