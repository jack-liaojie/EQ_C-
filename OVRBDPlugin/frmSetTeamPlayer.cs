using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.Xml;
using System.Collections;
using System.Data.SqlClient;
using AutoSports.OVRCommon;
using System.Text.RegularExpressions;

namespace AutoSports.OVRBDPlugin
{
    public partial class frmSetTeamPlayer : Office2007Form
    {
        public Int32 m_iMatchID;

        public OVRBDRule m_curMatchRule { private get; set; }

        public frmSetTeamPlayer(Int32 iMatchID)
        {
            InitializeComponent();

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvTeamPlayers);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvPosition);
            m_iMatchID = iMatchID;
        }

        private void frmSetTeamPlayer_Load(object sender, EventArgs e)
        {
            BDCommon.g_ManageDB.InitMatchSplitType(m_iMatchID);
            BDCommon.g_ManageDB.InitTeamMatchMember(m_iMatchID);

            InitPositionList();
            Localization();
            ResetTeamSplitPlayers();

            if (BDCommon.g_strDisplnCode == "BD")
            {
                this.Height = dgvPosition.Top;
            }
        }

        private void Localization()
        {
            String strSectionName = BDCommon.m_strSectionName;
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmSetTeamPlayers");
        }

        private void ResetTeamSplitPlayers()
        {
            BDCommon.g_ManageDB.InitTeamSplitsPlayersGrid(m_iMatchID, this.dgvTeamPlayers);
            SetGridStyle(dgvTeamPlayers);

        }

        private void dgvTeamPlayers_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            // Get current edited cell
            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            String strColumnName = dgvTeamPlayers.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvTeamPlayers.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                Int32 iMatchSplitID = GetFieldValue(dgvTeamPlayers, iRowIndex, "F_MatchSplitID");
                Int32 iPosA = GetFieldValue(dgvTeamPlayers, iRowIndex, "F_HomePosition");
                Int32 iPosB = GetFieldValue(dgvTeamPlayers, iRowIndex, "F_AwayPosition");

                Int32 iInputValue = 0;
                Int32 iInputKey = 0;
                if (CurCell is DGVCustomComboBoxCell)
                {
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                    iInputKey = Convert.ToInt32(CurCell1.Tag);
                }
                else
                {
                    iInputValue = Convert.ToInt32(CurCell.Value);
                }

                if (strColumnName.CompareTo("HomeName") == 0)
                {
                    BDCommon.g_ManageDB.UpdateTeamSplitMember(m_iMatchID, iMatchSplitID, iInputKey, iPosA);
                }
                else if (strColumnName.CompareTo("AwayName") == 0)
                {
                    BDCommon.g_ManageDB.UpdateTeamSplitMember(m_iMatchID, iMatchSplitID, iInputKey, iPosB);
                }
                else if (strColumnName.CompareTo("Type") == 0)
                {
                    BDCommon.g_ManageDB.SetMatchSplitType(m_iMatchID, iMatchSplitID, iInputKey);
                }
                else if (strColumnName.CompareTo("TechOrder") == 0)
                {
                    BDCommon.g_ManageDB.SetMatchSplitTechOrder(m_iMatchID, iMatchSplitID, CurCell.Value.ToString());
                }
                ResetTeamSplitPlayers();
                dgvTeamPlayers.Rows[iRowIndex].Selected = true;
            }
        }

        private void dgvTeamPlayers_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (!(dgvTeamPlayers.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn) || e.RowIndex < 0)
                return;

            Int32 iRowIndex = e.RowIndex;
            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iMatchSplitType = GetFieldValue(dgvTeamPlayers, iRowIndex, "F_MatchSplitType");
            Int32 iMatchSplitID = GetFieldValue(dgvTeamPlayers, iRowIndex, "F_MatchSplitID");
            Int32 iHomeID = GetFieldValue(dgvTeamPlayers, iRowIndex, "F_HomeID");
            Int32 iPosA = GetFieldValue(dgvTeamPlayers, iRowIndex, "F_HomePosition");
            Int32 iAwayID = GetFieldValue(dgvTeamPlayers, iRowIndex, "F_AwayID");
            Int32 iPosB = GetFieldValue(dgvTeamPlayers, iRowIndex, "F_AwayPosition");
            string strColumnName = dgvTeamPlayers.Columns[iColumnIndex].Name;

            if (strColumnName == "Type")
            {
                BDCommon.g_ManageDB.InitMatchSplitTypeDes(ref dgvTeamPlayers, iColumnIndex, m_curMatchRule.TeamSubMatchTypes);
                return;
            }

            SexType sexType = SexType.All;
            //根据比赛的SubMatch类型，获取过滤条件
            switch (iMatchSplitType)
            {
                case (int)TeamSubMatchType.TypeSubMatchMenSingle:
                case (int)TeamSubMatchType.TypeSubMatchMenDouble:
                    sexType = SexType.Men;
                    break;
                case (int)TeamSubMatchType.TypeSubMatchWomenSingle:
                case (int)TeamSubMatchType.TypeSubMatchWomenDouble:
                    sexType = SexType.Women;
                    break;
                case (int)TeamSubMatchType.TypeSubMatchMixedDouble:
                    sexType = SexType.All;//混合双打不应为Mixed，因为是从单人中临时选的组合
                    break;
            }

            if (iMatchSplitType == (int)TeamSubMatchType.TypeSubMatchMenSingle
                || iMatchSplitType == (int)TeamSubMatchType.TypeSubMatchWomenSingle) // Single
            {
                if (strColumnName == "HomeName")
                {
                    BDCommon.g_ManageDB.InitTeamMembersCombBox(ref dgvTeamPlayers, iColumnIndex, m_iMatchID, iPosA, sexType);
                }
                else if (strColumnName == "AwayName")
                {
                    BDCommon.g_ManageDB.InitTeamMembersCombBox(ref dgvTeamPlayers, iColumnIndex, m_iMatchID, iPosB, sexType);
                }

                return;
            }
            else if (iMatchSplitType == (int)TeamSubMatchType.TypeSubMatchMenDouble
                        || iMatchSplitType == (int)TeamSubMatchType.TypeSubMatchWomenDouble
                        || iMatchSplitType == (int)TeamSubMatchType.TypeSubMatchMixedDouble) // Double
            {
                if (strColumnName == "HomeName")
                {
                    frmSetDoublePair setdoubledlg = new frmSetDoublePair(m_iMatchID, iHomeID, iPosA, sexType);
                    setdoubledlg.InitTeamMembersListBox();
                    if (setdoubledlg.ShowDialog() == DialogResult.OK)
                    {
                        BDCommon.g_ManageDB.UpdateTeamSplitMember(m_iMatchID, iMatchSplitID, setdoubledlg.m_iPairRegID, iPosA);
                        ResetTeamSplitPlayers();
                        dgvTeamPlayers.Rows[iRowIndex].Selected = true;
                    }
                }
                else if (strColumnName == "AwayName")
                {
                    frmSetDoublePair setdoubledlg = new frmSetDoublePair(m_iMatchID, iAwayID, iPosB, sexType);
                    setdoubledlg.InitTeamMembersListBox();
                    if (setdoubledlg.ShowDialog() == DialogResult.OK)
                    {
                        BDCommon.g_ManageDB.UpdateTeamSplitMember(m_iMatchID, iMatchSplitID, setdoubledlg.m_iPairRegID, iPosB);
                        ResetTeamSplitPlayers();
                        dgvTeamPlayers.Rows[iRowIndex].Selected = true;
                    }
                }
            }

            e.Cancel = true; // Double and other not need combbox
        }

        private void SetGridStyle(DataGridView dgv)
        {
            dgv.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;

            if (dgv == dgvTeamPlayers)
            {
                if (dgvTeamPlayers.Columns["HomeName"] != null)
                {
                    dgvTeamPlayers.Columns["HomeName"].ReadOnly = false;
                }
                if (dgvTeamPlayers.Columns["AwayName"] != null)
                {
                    dgvTeamPlayers.Columns["AwayName"].ReadOnly = false;
                }
                if (dgvTeamPlayers.Columns["TechOrder"] != null)
                {
                    dgvTeamPlayers.Columns["TechOrder"].ReadOnly = false;
                }
            }
        }


        private Int32 GetFieldValue(DataGridView dgv, Int32 iRowIndex, String strFiledName)
        {
            Int32 iReturnValue = 0;
            if (dgv.Columns[strFiledName] == null || dgv.Rows[iRowIndex].Cells[strFiledName].Value.ToString() == "")
            {
                iReturnValue = 0;
            }
            else
            {
                iReturnValue = Convert.ToInt32(dgv.Rows[iRowIndex].Cells[strFiledName].Value);
            }
            return iReturnValue;
        }

        private String GetFieldStringValue(DataGridView dgv, Int32 iRowIndex, String strFiledName)
        {
            String iReturnValue = "";
            if (dgv.Columns[strFiledName] == null || dgv.Rows[iRowIndex].Cells[strFiledName].Value.ToString() == "")
            {
                iReturnValue = "";
            }
            else
            {
                iReturnValue = Convert.ToString(dgv.Rows[iRowIndex].Cells[strFiledName].Value);
            }
            return iReturnValue;
        }

        private void InitPositionList()
        {
            DataTable dt = BDCommon.g_ManageDB.GetMatchMemberPosition(m_iMatchID, 0);
            OVRDataBaseUtils.FillDataGridViewWithCmb(dgvPosition, dt, "Pos");
            if (dt != null && dt.Columns.Count >= 4)
            {
                dgvPosition.Columns[3].ReadOnly = false;
            }
        }

        private void dgvPositionCell_beginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            DataGridView dgv = sender as DataGridView;
            if (!(dgv.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn) || e.RowIndex < 0)
                return;
            DataTable dtPos = BDCommon.g_ManageDB.GetPositionList();
            DGVCustomComboBoxColumn dgvCol = dgv.Columns[e.ColumnIndex] as DGVCustomComboBoxColumn;
            dgvCol.FillComboBoxItems(dtPos, "F_PositionCode", "F_PositionID");
        }

        private void dgvPosition_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;
            DataGridView dgv = sender as DataGridView;
            // Get current edited cell
            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            String strColumnName = dgv.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgv.Rows[iRowIndex].Cells[iColumnIndex];
            DataGridViewCell regCell = dgv.Rows[iRowIndex].Cells[0];
            if (CurCell is DGVCustomComboBoxCell)
            {
                DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                int posID = Convert.ToInt32(CurCell1.Tag);
                int regID = Convert.ToInt32(regCell.Value);
                BDCommon.g_ManageDB.UpdateMatchPosition(m_iMatchID, regID, posID);
            }
        }

        private void btnAutoSetPlayer_Click(object sender, EventArgs e)
        {
            if (!BDCommon.g_ManageDB.AutoSetMatchMember(m_iMatchID))
            {
                MessageBoxEx.Show("Set match player failed!");
            }
            else
            {
                ResetTeamSplitPlayers();
            }
        }

        private void btnAutoSetPlayerOG_Click(object sender, EventArgs e)
        {
            if (!BDCommon.g_ManageDB.AutoSetMatchMemberForOG(m_iMatchID))
            {
                MessageBoxEx.Show("Set match player failed!");
            }
            else
            {
                ResetTeamSplitPlayers();
            }
        }
    }
}
