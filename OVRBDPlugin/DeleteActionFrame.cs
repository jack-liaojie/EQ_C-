using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace AutoSports.OVRBDPlugin
{
    public partial class DeleteActionFrame : Form
    {
        public DeleteActionFrame()
        {
            InitializeComponent();
        }
        public int SelSetNo;
        private void btnOK_Click(object sender, EventArgs e)
        {
            string strNo = tbSetNo.Text.Trim();
            if ( strNo == "")
            {
                MessageBox.Show("请输入要删除的盘号！");
                return;
            }
            try
            {
                int setNo = Convert.ToInt32(strNo);
                if ( setNo == -1 || ( setNo >= 1 && setNo <= 5 ) )
                {
                    SelSetNo = setNo;
                }
                else
                {
                    MessageBox.Show("盘号必须为-1或1-5");
                    return;
                }
            }
            catch (System.Exception ex)
            {
            	MessageBox.Show("盘号必须为-1或1-5");
                return;
            }
            this.DialogResult = DialogResult.OK;
            this.Close();
        }


    }
}
