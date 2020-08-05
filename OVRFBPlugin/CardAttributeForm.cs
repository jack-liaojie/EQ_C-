using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace AutoSports.OVRFBPlugin
{
    public enum CardType
    {
        eYellow = 1,
        eRed = 2,
    }
    public partial class CardAttributeForm : Form
    {
       
        private CardAttributeForm()
        {
            InitializeComponent();
        }

        public CardAttributeForm(CardType etype,string strCurCode)
        {
            InitializeComponent();
            if (etype == CardType.eYellow)
            {
                DataTable dt = new DataTable();
                dt.Columns.Add("Value");
                dt.Columns.Add("Desc");
                dt.Rows.Add("", "");
                dt.Rows.Add("A", "A");
                dt.Rows.Add("B", "B");
                dt.Rows.Add("C", "C");
                dt.Rows.Add("D", "D");
                dt.Rows.Add("E", "E");
                dt.Rows.Add("F", "F");
                dt.Rows.Add("G", "G");
                dt.Rows.Add("H", "H");

                cbCode.DataSource = dt;
                cbCode.DisplayMember = "Desc";
                cbCode.ValueMember = "Value";

                cbCode.SelectedValue = strCurCode;
            }
            else if (etype == CardType.eRed)
            {
                DataTable dt = new DataTable();
                dt.Columns.Add("Value");
                dt.Columns.Add("Desc");
                dt.Rows.Add("", "");
                dt.Rows.Add("I", "I");
                dt.Rows.Add("J", "J");
                dt.Rows.Add("K", "K");
                dt.Rows.Add("L", "L");
                dt.Rows.Add("M", "M");
                dt.Rows.Add("N", "N");
                dt.Rows.Add("O", "O");

                cbCode.DataSource = dt;
                cbCode.DisplayMember = "Desc";
                cbCode.ValueMember = "Value";

                cbCode.SelectedValue = strCurCode;
            }

        }

        private void chkMissMatch1_CheckedChanged(object sender, EventArgs e)
        {
              if (chkMissMatch1.Checked)
              {
                  chkMissMatch2.Checked = false;
              }
        }

        private void chkMissMatch2_CheckedChanged(object sender, EventArgs e)
        {
            if (chkMissMatch2.Checked)
            {
                chkMissMatch1.Checked = false;
            }
        }

        public void SetCheckState(int iState)
        {
            if (iState == 0)
            {
                chkMissMatch1.Checked = false;
                chkMissMatch2.Checked = false;
            }
            else if (iState == 1)
            {
                chkMissMatch1.Checked = true;
                chkMissMatch2.Checked = false;
            }
            else if (iState == 2)
            {
                chkMissMatch1.Checked = false;
                chkMissMatch2.Checked = true;
            }
           
        }
        public int GetCheckState()
        {
            if (chkMissMatch1.Checked)
            {
                return 1;
            }
            if (chkMissMatch2.Checked)
            {
                return 2;
            }
            return 0;
        }
    }
}
