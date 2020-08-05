using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;

namespace AutoSports.OVRBDPlugin
{
    public partial class btnSendSetFrm : Office2007Form
    {
        private int m_iMatchID = -1;
        private int m_selMatchSplitID = -1;
        private string m_strSendDestination = "";
        public btnSendSetFrm(int matchID, string strSendAddrDes)
        {
            m_iMatchID = matchID;
            m_strSendDestination = strSendAddrDes;
            InitializeComponent();
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvTeamPlayers);
            dgvTeamPlayers.MultiSelect = false;
            lbSendDes.Text =  "Send To:  " + strSendAddrDes;
        }

        public int SelMatchID
        {
            get { return m_iMatchID; }
        }

        public int SelMatchSplitID
        {
            get { return m_selMatchSplitID; }
        }

        public string IPAddr
        {
            get { return (m_strSendDestination.Split('('))[0]; }
        }
        private void btnSendSetFrm_Load(object sender, EventArgs e)
        {
            ResetTeamSplitPlayers();
        }

        private void ResetTeamSplitPlayers()
        {
            BDCommon.g_ManageDB.InitTeamSplitsPlayersForSend(m_iMatchID, this.dgvTeamPlayers);
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            if (dgvTeamPlayers.SelectedRows.Count < 1 )
            {
                MessageBoxEx.Show("Please select the set which you want to send!");
                return;
            }
            DataGridViewRow dgvr = dgvTeamPlayers.SelectedRows[0];
            m_selMatchSplitID = Convert.ToInt32(dgvr.Cells["F_MatchSplitID"].Value);
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

    }
}
