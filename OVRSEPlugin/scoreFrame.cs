using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using AutoSports.OVRCommon;
using System.Text.RegularExpressions;

namespace AutoSports.OVRSEPlugin
{
    public partial class scoreFrame : Form
    {
        public scoreFrame()
        {
            InitializeComponent();
            OVRDataBaseUtils.SetDataGridViewStyle(dgViewScore);
            timer.Interval = 4000;
            timer.Tick += new EventHandler(timer_Tick);
        }

        void timer_Tick(object sender, EventArgs e)
        {
            btnRereshScore_Click(null, null);
        }
        Timer timer = new Timer();
        public bool UpdateUI(int matchID)
        {
            DataTable dt = SECommon.g_ManageDB.GetViewScore(matchID);
            if ( dt == null )
            {
                return false;
            }
            OVRDataBaseUtils.FillDataGridView(dgViewScore, dt);
            dgViewScore.Columns[0].Width = 50;
            foreach ( DataGridViewColumn col in dgViewScore.Columns)
            {
                col.SortMode = DataGridViewColumnSortMode.NotSortable;
                
            }
            lbMatchID.Text = matchID.ToString();
            lbMatchCourt.Text = SECommon.g_ManageDB.GetMatchCourtName(matchID);
            lbMatchRSC.Text = SECommon.g_ManageDB.GetRscStringFromMatchID(matchID);
            String strSportDes, strPhaseDes, strDateDes, strVenueDes, strPlayNameA, strPlayNameB, strHomeScore, strAwayScore;
            int m_nCurPlayIDA, m_nCurPlayIDB, m_nCurStatusID, m_nRegAPos, m_nRegBPos;
            SECommon.g_ManageDB.GetOneMatchDes(matchID, out m_nCurPlayIDA, out m_nCurPlayIDB, out strPlayNameA, out strPlayNameB, out m_nCurStatusID,
                out strSportDes, out strPhaseDes, out strDateDes, out strVenueDes, out strHomeScore, out strAwayScore, out m_nRegAPos, out m_nRegBPos);

            //lb_SportDes.Text = strSportDes;
            lbMatchTime.Text = strDateDes;
            this.Text = strPhaseDes;
            lbPlayerA.Text = strPlayNameA;
            lbPlayerB.Text = strPlayNameB;
            lbMatchScore.Text = SECommon.g_ManageDB.GetMatchScoreString(matchID);

            bool bFound = false;
            for (int i = 0; i < lsbMatchID.Items.Count;i++ )
            {
                if ( (string)lsbMatchID.Items[i] == matchID.ToString() )
                {
                    lsbMatchID.SelectedIndex = i;
                    bFound = true;
                    break;
                }
            }
            if ( !bFound)
            {
                lsbMatchID.SelectedIndex = -1;
            }
            
            return true;
        }

        private void formClosing(object sender, FormClosingEventArgs e)
        {
            e.Cancel = true;
            this.Visible = false;
        }

        private void btnAddMatch_Click(object sender, EventArgs e)
        {
            string strMatchID = tbInputMatchID.Text.Trim();
            if (strMatchID == "")
            {
                tbInputMatchID.Clear();
                tbInputMatchID.Focus();
                return;
            }
            if (Regex.IsMatch(strMatchID, "[^0-9]"))
            {
                MessageBox.Show("You can input number only!");
                tbInputMatchID.Clear();
                tbInputMatchID.Focus();
                return;
            }
            int matchID = 0;
            try
            {
                matchID = Convert.ToInt32(strMatchID);
                if (matchID <= 0)
                {
                    MessageBox.Show("MatchID is Invalid！");
                    tbInputMatchID.Clear();
                    tbInputMatchID.Focus();
                    return;
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
                tbInputMatchID.Clear();
                tbInputMatchID.Focus();
                return;
            }
            if (lsbMatchID.Items.Contains(strMatchID))
            {
                MessageBox.Show(string.Format("{0} is already added!", strMatchID));
                tbInputMatchID.Clear();
                tbInputMatchID.Focus();
                return;
            }
            if ( !UpdateUI(matchID))
            {
                MessageBox.Show(string.Format("{0} is not found in database!", matchID));
                tbInputMatchID.Clear();
                tbInputMatchID.Focus();
                return;
            }
            lsbMatchID.Items.Add(strMatchID);
            for (int i = 0; i < lsbMatchID.Items.Count;i++ )
            {
                if ( (string)lsbMatchID.Items[i] == strMatchID )
                {
                    lsbMatchID.SelectedIndex = i;
                    break;
                }
            }
            tbInputMatchID.Clear();
            tbInputMatchID.Focus();
        }


        private void btnRemoveMatchID_Click(object sender, EventArgs e)
        {
            if ( lsbMatchID.SelectedIndex >= 0 )
            {
                lsbMatchID.Items.RemoveAt(lsbMatchID.SelectedIndex);
            }
            else
            {
                MessageBox.Show("Please select the MatchID which you want to remove!");
                return;
            }
        }

        private void mouseClickViewScore(object sender, MouseEventArgs e)
        {
            if ( lsbMatchID.SelectedIndex >= 0 )
            {
                string strMatchID = (string)lsbMatchID.Items[lsbMatchID.SelectedIndex];
                int nMatchID = 0;
                try
                {
                    nMatchID = Convert.ToInt32(strMatchID);
                    UpdateUI(nMatchID);
                }
                catch (System.Exception ex)
                {
                	
                }
            }
        }

        private void btnRereshScore_Click(object sender, EventArgs e)
        {
            int nMatchID = 0;
            try
            {
                nMatchID = Convert.ToInt32(lbMatchID.Text);
                if ( nMatchID <= 0 )
                {
                    return;
                }
            }
            catch (System.Exception ex)
            {
            	return;
            }
            UpdateUI(nMatchID);
        }

        private void btnGetCurrentMatch_Click(object sender, EventArgs e)
        {
            List<string> strMatches = SECommon.g_ManageDB.GetAllRunningMatchID();
            if ( strMatches == null )
            {
                MessageBox.Show("Get running matches failed!");
                return;
            }
            lsbMatchID.Items.Clear();
            foreach ( string s in strMatches)
            {
                lsbMatchID.Items.Add(s);
            }
        }
      

        private void chkRefreshClicked(object sender, EventArgs e)
        {
            if (chkAutoRefresh.Checked)
            {
                timer.Start();
            }
            else
            {
                timer.Stop();
            }
        }




    }
}
