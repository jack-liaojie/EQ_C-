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
using System.Xml.Serialization;
using System.IO;
using System.Net.Sockets;
using System.Net;
using System.Threading;
using System.Security.AccessControl;


namespace AutoSports.OVRGFPlugin
{
    public delegate void dlDataEntryChangeMatchRule();

    public partial class frmOVRGFDataEntry : DevComponents.DotNetBar.Office2007Form
    {
        private Int32 m_iCurMatchID;
        private Int32 m_iCurTeamMatchID;
        private Int32 m_iWndMode;
        private Int32 m_iCurStatusID;
        private Int32 m_iCurMatchRuleID;

        private Int32 m_iCurCompetitionPosition;
        private string m_strOldIRM;
        private Boolean m_bIsRunning = false;

        private System.Data.DataTable m_dtOldPlayer;
        private System.Data.DataTable m_dtHolePar;
        private System.Data.DataTable m_dtOldTeam;

        private System.Data.DataTable m_dtPlayOffGold;
        private System.Data.DataTable m_dtPlayOffSilver;
        private System.Data.DataTable m_dtPlayOffBronze;

        //TCP Data
        private Boolean m_bStartClient = false;
        private String m_strServerAddr;
        private Int32 m_iPort = 5678;
        private TcpClient m_client = null;
        private Thread m_ReveiveThread;
        private Thread m_ParseThread;

        dlDataEntryChangeMatchRule DataEntryChangeMatchRuleHandler;

        Boolean InitMatchInfo()
        {
            CreateMatchSplit();
            InitialMatchDes();
            UpdateMatchStatus();

            return true;
        }

        void InitMatchResult()
        {
            GetMatchHolePar();
            FillGridViewHolePar();
            FillGridViewPlayer();
            FillGridViewPlayerColor();
            FillGridViewTeam();

            FillGridViewPlayOffGold();
            FillGridViewPlayOffSilver();
            FillGridViewPlayOffBronze();
        }

        void ChangeMatchRule()
        {
            InitMatchInfo();
            InitMatchResult();
        }

        void EnableControlButton(Boolean bEnable, Boolean bClear)
        {
            btnx_CreateGroup.Enabled = bEnable;
            btnx_SetTee.Enabled = bEnable;
            btnx_ModifyGroup.Enabled = bEnable;
            btnx_Draw.Enabled = bEnable;
            btnx_Status.Enabled = bEnable;
            btnx_Course.Enabled = bEnable;
            btnx_Exit.Enabled = bEnable;

            if (bClear)
            {
                lb_SportDes.Text = "";
                lb_DateDes.Text = "";
            }
        }

        void EnablePreCompetition(Boolean bEnable)
        {
            btnx_Course.Enabled = bEnable;
            btnx_CreateGroup.Enabled = bEnable;
            btnx_SetTee.Enabled = bEnable;
            btnx_ModifyGroup.Enabled = bEnable;
            btnx_Draw.Enabled = bEnable;
        }

        void EnableTcpButton(Boolean bEnable)
        {
            tbIP.Enabled = bEnable;
            tbPort.Enabled = bEnable;
            btnx_Start.Enabled = bEnable;
        }

        void InitialMatchDes()
        {
            String strMatchDes;
            String strDateDes;

            GFCommon.g_ManageDB.GetMatchDes(m_iCurMatchID, out strMatchDes, out strDateDes, out m_iCurStatusID);
            UpdateMatchStatus();

            lb_SportDes.Text = strMatchDes;
            lb_DateDes.Text = strDateDes;
        }

        void GetMatchHolePar()
        {
            m_dtHolePar = new DataTable();

            GFCommon.g_ManageDB.GetMatchHolePar(m_iCurMatchID, ref m_dtHolePar);
        }

        void FillGridViewHolePar()
        {
            GFCommon.g_ManageDB.FillGridViewHolePar(m_iCurMatchID, dgvHolePar);
        }

        void FillGridViewPlayer()
        {
            m_dtOldPlayer = new DataTable();
            m_dtOldPlayer = GFCommon.g_ManageDB.FillGridViewPlayer(m_iCurMatchID, dgvPlayer);
        }

        void FillGridViewTeam()
        {
            m_dtOldTeam = new DataTable();
            m_dtOldTeam = GFCommon.g_ManageDB.FillGridViewTeam(m_iCurMatchID, dgvTeam);
        }

        void FillGridViewPlayerColor()
        {
            for (int j = 0; j < dgvPlayer.RowCount; j++)
            {
                for (int m = 0; m < dgvPlayer.Columns.Count; m++)
                {
                    string strColName = dgvPlayer.Columns[m].Name;

                    if (strColName == "OUT")
                    {
                        dgvPlayer.Rows[j].Cells[m].Style.BackColor = System.Drawing.Color.Violet;
                    }
                    else if (strColName == "IN")
                    {
                        dgvPlayer.Rows[j].Cells[m].Style.BackColor = System.Drawing.Color.Violet;
                    }
                    else if (strColName == "F_CompetitionPosition" || strColName == "Order" || strColName == "NOC" || strColName == "Name" || strColName == "Group"
                        || strColName == "Sides" || strColName == "Tee" || strColName == "Time" || strColName == "Round Rank" || strColName == "Total" || strColName == "Pos")
                    {
                    }
                    else
                    {
                        string strPar = m_dtHolePar.Rows[0][strColName].ToString();
                        Int32 nPar = GFCommon.ConvertStrToInt(strPar);

                        string strHole = dgvPlayer.Rows[j].Cells[m].Value.ToString();

                        if (strHole != "" && strHole != "0")
                        {
                            Int32 nHoleNum = GFCommon.ConvertStrToInt(strHole);
                            Int32 nSub = nHoleNum - nPar;

                            if (nSub == 0)
                            {
                                dgvPlayer.Rows[j].Cells[m].Style.ForeColor = System.Drawing.Color.Black;
                            }
                            else if (nSub == -1)
                            {
                                dgvPlayer.Rows[j].Cells[m].Style.ForeColor = System.Drawing.Color.Red;
                            }
                            else if (nSub < -1)
                            {
                                dgvPlayer.Rows[j].Cells[m].Style.ForeColor = System.Drawing.Color.Red;
                                dgvPlayer.Rows[j].Cells[m].Style.BackColor = System.Drawing.Color.Yellow;
                            }
                            else if (nSub == 1)
                            {
                                dgvPlayer.Rows[j].Cells[m].Style.ForeColor = System.Drawing.Color.Blue;
                            }
                            else if (nSub > 1)
                            {
                                dgvPlayer.Rows[j].Cells[m].Style.ForeColor = System.Drawing.Color.White;
                                dgvPlayer.Rows[j].Cells[m].Style.BackColor = System.Drawing.Color.Blue;
                            }
                        }
                        else
                        {
                            if (j % 2 == 0)
                            {
                                dgvPlayer.Rows[j].Cells[m].Style.BackColor = System.Drawing.Color.FromArgb(230, 239, 248);
                            }
                            else
                            {
                                dgvPlayer.Rows[j].Cells[m].Style.BackColor = System.Drawing.Color.FromArgb(202, 221, 238);
                            }
                        }
                    }
                }
            }
        }

        void FillHoleColor(Int32 nRowIndex, Int32 nColIndex, Int32 nHole, Int32 nHoleNum, string strColName)
        {
            string strPar = m_dtHolePar.Rows[0][strColName].ToString();
            Int32 nPar = GFCommon.ConvertStrToInt(strPar);

            if (nHoleNum > 0)
            {
                Int32 nSub = nHoleNum - nPar;

                if (nSub == 0)
                {
                    dgvPlayer.Rows[nRowIndex].Cells[nColIndex].Style.ForeColor = System.Drawing.Color.Black;

                    if (nRowIndex % 2 == 0)
                    {
                        dgvPlayer.Rows[nRowIndex].Cells[nColIndex].Style.BackColor = System.Drawing.Color.FromArgb(230, 239, 248);
                    }
                    else
                    {
                        dgvPlayer.Rows[nRowIndex].Cells[nColIndex].Style.BackColor = System.Drawing.Color.FromArgb(202, 221, 238);
                    }
                }
                else if (nSub == -1)
                {
                    dgvPlayer.Rows[nRowIndex].Cells[nColIndex].Style.ForeColor = System.Drawing.Color.Red;

                    if (nRowIndex % 2 == 0)
                    {
                        dgvPlayer.Rows[nRowIndex].Cells[nColIndex].Style.BackColor = System.Drawing.Color.FromArgb(230, 239, 248);
                    }
                    else
                    {
                        dgvPlayer.Rows[nRowIndex].Cells[nColIndex].Style.BackColor = System.Drawing.Color.FromArgb(202, 221, 238);
                    }
                }
                else if (nSub < -1)
                {
                    dgvPlayer.Rows[nRowIndex].Cells[nColIndex].Style.ForeColor = System.Drawing.Color.Red;
                    dgvPlayer.Rows[nRowIndex].Cells[nColIndex].Style.BackColor = System.Drawing.Color.Yellow;
                }
                else if (nSub == 1)
                {
                    dgvPlayer.Rows[nRowIndex].Cells[nColIndex].Style.ForeColor = System.Drawing.Color.Blue;

                    if (nRowIndex % 2 == 0)
                    {
                        dgvPlayer.Rows[nRowIndex].Cells[nColIndex].Style.BackColor = System.Drawing.Color.FromArgb(230, 239, 248);
                    }
                    else
                    {
                        dgvPlayer.Rows[nRowIndex].Cells[nColIndex].Style.BackColor = System.Drawing.Color.FromArgb(202, 221, 238);
                    }
                }
                else if (nSub > 1)
                {
                    dgvPlayer.Rows[nRowIndex].Cells[nColIndex].Style.ForeColor = System.Drawing.Color.White;
                    dgvPlayer.Rows[nRowIndex].Cells[nColIndex].Style.BackColor = System.Drawing.Color.Blue;
                }
            }
            else
            {
                dgvPlayer.Rows[nRowIndex].Cells[nColIndex].Style.ForeColor = System.Drawing.Color.Black;

                if (nRowIndex % 2 == 0)
                {
                    dgvPlayer.Rows[nRowIndex].Cells[nColIndex].Style.BackColor = System.Drawing.Color.FromArgb(230, 239, 248);
                }
                else
                {
                    dgvPlayer.Rows[nRowIndex].Cells[nColIndex].Style.BackColor = System.Drawing.Color.FromArgb(202, 221, 238);
                }
            }
        }

        void FillPlayerOUTIN(Int32 nRowIndex)
        {
            Int32 nOUT = 0;
            Int32 nIN = 0;
            Int32 nColumn = m_dtHolePar.Columns.Count / 2;

            for (Int32 i = 0; i < nColumn; i++)
            {
                string strOUT = Convert.ToString(i + 1);
                string strIN = Convert.ToString(nColumn + i + 1);

                string strOUTValue = m_dtOldPlayer.Rows[nRowIndex][strOUT].ToString();
                string strINValue = m_dtOldPlayer.Rows[nRowIndex][strIN].ToString();

                nOUT += GFCommon.ConvertStrToInt(strOUTValue);
                nIN += GFCommon.ConvertStrToInt(strINValue);
            }

            dgvPlayer.Rows[nRowIndex].Cells["OUT"].Value = GFCommon.ConvertIntToStr(nOUT);
            dgvPlayer.Rows[nRowIndex].Cells["IN"].Value = GFCommon.ConvertIntToStr(nIN);
        }

        void FillPlayerRank()
        {
            if (GFCommon.g_GFPlugin != null)
                GFCommon.g_GFPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_iCurMatchID, m_iCurMatchID, null);

            GFCommon.g_ManageDB.UpdatePlayerRank(m_iCurMatchID, dgvPlayer);
        }

        private void UpdateMatchStatus()
        {
            btnx_Schedule.Checked = false;
            btnx_StartList.Checked = false;
            btnx_Running.Checked = false;
            btnx_Suspend.Checked = false;
            btnx_Unofficial.Checked = false;
            btnx_Official.Checked = false;
            btnx_Revision.Checked = false;
            btnx_Canceled.Checked = false;

            btnx_Schedule.Enabled = false;
            btnx_StartList.Enabled = false;
            btnx_Running.Enabled = false;
            btnx_Suspend.Enabled = false;
            btnx_Unofficial.Enabled = false;
            btnx_Official.Enabled = false;
            btnx_Revision.Enabled = false;
            btnx_Canceled.Enabled = false;

            EnablePreCompetition(false);

            switch (m_iCurStatusID)
            {
                case GFCommon.STATUS_SCHEDULE:
                    {
                        btnx_StartList.Enabled = true;

                        EnablePreCompetition(true);

                        btnx_Schedule.Checked = true;
                        btnx_Status.Text = btnx_Schedule.Text;
                        btnx_Status.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                case GFCommon.STATUS_STARTLIST:
                    {
                        btnx_Running.Enabled = true;

                        btnx_StartList.Checked = true;
                        btnx_Status.Text = btnx_StartList.Text;
                        btnx_Status.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                case GFCommon.STATUS_RUNNING:
                    {
                        btnx_Suspend.Enabled = true;
                        btnx_Unofficial.Enabled = true;

                        btnx_Running.Checked = true;
                        btnx_Status.Text = btnx_Running.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.Red;
                        break;
                    }
                case GFCommon.STATUS_SUSPEND:
                    {
                        btnx_Running.Enabled = true;

                        btnx_Suspend.Checked = true;
                        btnx_Status.Text = btnx_Suspend.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.Red;
                        break;
                    }
                case GFCommon.STATUS_UNOFFICIAL:
                    {
                        btnx_Official.Enabled = true;
                        btnx_Revision.Enabled = true;

                        btnx_Unofficial.Checked = true;
                        btnx_Status.Text = btnx_Unofficial.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case GFCommon.STATUS_OFFICIAL:
                    {
                        btnx_Revision.Enabled = true;

                        btnx_Official.Checked = true;
                        btnx_Status.Text = btnx_Official.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case GFCommon.STATUS_REVISION:
                    {
                        btnx_Unofficial.Enabled = true;
                        btnx_Official.Enabled = true;

                        btnx_Revision.Checked = true;
                        btnx_Status.Text = btnx_Revision.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case GFCommon.STATUS_CANCELED:
                    {
                        btnx_Canceled.Checked = true;
                        btnx_Status.Text = btnx_Canceled.Text;
                        btnx_Status.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                default:
                    return;
            }
        }

        private void CreateMatchSplit()
        {
            m_iCurMatchRuleID = GFCommon.g_ManageDB.GetMatchRuleID(m_iCurMatchID);
            Boolean bMatchSplit = GFCommon.g_ManageDB.IsMatchCreateSplit(m_iCurMatchID);

            if (m_iCurMatchRuleID > 0 && !bMatchSplit)
            {
                GFCommon.g_ManageDB.ApplayCourse(m_iCurMatchID, m_iCurMatchRuleID);
            }
        }

        private Boolean IsMatchPositionNull()
        {
            return GFCommon.g_ManageDB.IsMatchPositionNull(m_iCurMatchID);
        }

        private Boolean IsMatchGroupNull()
        {
            return GFCommon.g_ManageDB.IsMatchGroupNull(m_iCurMatchID);
        }

        private Boolean InitialMatchPlayer()
        {
            return GFCommon.g_ManageDB.InitialMatchPlayer(m_iCurMatchID);
        }

        private void SetIRM_MenuStrip(String strIRMCode)
        {
            IRM_DQ.Checked = false;
            IRM_RTD.Checked = false;
            IRM_WD.Checked = false;
            IRM_OK.Checked = false;

            switch (strIRMCode)
            {
                case GFCommon.PLAYER_STATUS_DQ://DQ
                    IRM_DQ.Checked = true;
                    break;
                case GFCommon.PLAYER_STATUS_RTD://RTD
                    IRM_RTD.Checked = true;
                    break;
                case GFCommon.PLAYER_STATUS_WD://WD
                    IRM_WD.Checked = true;
                    break;
                default:
                    IRM_OK.Checked = true;
                    break;
            }
        }

        private void UpdatePlayerIRM(string strIRM)
        {
            if (m_strOldIRM == strIRM)
                return;

            GFCommon.g_ManageDB.UpdatePlayerIRM(m_iCurMatchID, m_iCurCompetitionPosition, strIRM);
            FillPlayerRank();
        }

        public static void SetDataGridViewStyle(DataGridView dgv)
        {
            if (dgv == null) return;
            dgv.AlternatingRowsDefaultCellStyle.BackColor = System.Drawing.Color.FromArgb(202, 221, 238);
            dgv.DefaultCellStyle.BackColor = System.Drawing.Color.FromArgb(230, 239, 248);
            dgv.BackgroundColor = System.Drawing.Color.FromArgb(212, 228, 242);
            dgv.GridColor = System.Drawing.Color.FromArgb(208, 215, 229);
            dgv.BorderStyle = BorderStyle.Fixed3D;
            dgv.CellBorderStyle = DataGridViewCellBorderStyle.Single;
            dgv.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgv.MultiSelect = false;
            dgv.RowHeadersVisible = false;
            dgv.ColumnHeadersHeight = 25;
            dgv.RowHeadersWidthSizeMode = DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            dgv.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            dgv.AllowUserToAddRows = false;
            dgv.AllowUserToDeleteRows = false;
            dgv.AllowUserToOrderColumns = false;
            dgv.AllowUserToResizeRows = false;

            //选择状态的行的颜色 
            dgv.DefaultCellStyle.SelectionBackColor = Color.Cyan;//System.Drawing.Color.FromArgb(128, 255, 128);
            dgv.DefaultCellStyle.SelectionForeColor = Color.Black;
        }

        public void SetTCPInfo()
        {
            m_bStartClient = false;
            m_iPort = 5678;
            tbPort.Text = "5678";
            pb_Connect.Image = global::AutoSports.OVRGFPlugin.Properties.Resources.DisConnected;

            EnableTcpButton(false);
        }

        public bool IsOnLive(string strData)
        {
            String strStart = strData.Substring(10, 2);
            Int32 nStart = strData.IndexOf("|");
            if (nStart == 12 && strStart == "PI")
            {
                return true;
            }
            return false;
        }

        public void DealTcpData(string strData, int nDoRank)
        {
            String strInfo = "", strSexCode = "", strEventCode = "", strRound = "", strGroup = "", strRegisterCode = "", strScore = "", strCourt = "", strHole = "";
            Int32 nStart, nEnd, nIndex;

            string strEndFlag = "\r\n\u0003\u0004";
            nEnd = strData.IndexOf(strEndFlag);
            nStart = strData.IndexOf("|");

            if (nStart == 11 && nEnd > nStart)
            {
                strInfo = strData.Substring(nStart - 1, nEnd - nStart + 1);
                nIndex = strInfo.Length - strInfo.Replace("|", "").Length;

                if (nIndex != 8)
                    return;

                Int32 nPos, nCount = 0;
                while (strInfo.IndexOf("|") >= 0)
                {
                    nPos = strInfo.IndexOf("|");

                    switch (nCount)
                    {
                        case 0:
                            strSexCode = strInfo.Substring(0, nPos);
                            break;
                        case 1:
                            strEventCode = strInfo.Substring(0, nPos);
                            break;
                        case 2:
                            strRound = strInfo.Substring(0, nPos);
                            break;
                        case 3:
                            strGroup = strInfo.Substring(0, nPos);
                            break;
                        case 4:
                            strRegisterCode = strInfo.Substring(0, nPos);
                            break;
                        case 5:
                            strScore = strInfo.Substring(0, nPos);
                            break;
                        case 6:
                            strCourt = strInfo.Substring(0, nPos);
                            break;
                        case 7:
                            strHole = strInfo.Substring(0, nPos);
                            break;
                        default:
                            break;
                    }

                    strInfo = strInfo.Substring(nPos + 1, strInfo.Length - nPos - 1);
                    nCount++;
                }

                //将接收到的数据写入数据库
                UpdateMatchHoleNumFromTcp(strSexCode, strEventCode, strRound, strRegisterCode, strHole, strScore, nDoRank);
            }
        }

        public void UpdateMatchHoleNumFromTcp(String strSexCode, String strEventCode, String strRound, String strRegisterCode, String strHole, String strScore, int nDoRank)
        {
            Int32 nMatchID, nCompetitionID, nHole, nHoleNum;

            nMatchID = GFCommon.g_ManageDB.GetTcpMatchID(strSexCode, strEventCode, strRound);
            nHole = GFCommon.ConvertStrToInt(strHole);
            nHoleNum = GFCommon.ConvertStrToInt(strScore);

            if (nMatchID > 0)
            {
                nCompetitionID = GFCommon.g_ManageDB.GetTcpCompetitionID(nMatchID, strRegisterCode);

                if (nCompetitionID > 0)
                {
                    Boolean bResult = false;
                    bResult = GFCommon.g_ManageDB.UpdatePlayerHoleNum(nMatchID, nCompetitionID, nHole, nHoleNum, nDoRank);

                    if (bResult && nMatchID == m_iCurMatchID && m_bIsRunning)
                    {
                        Int32 nRow, nCol, iHole, iHoleNum;

                        iHole = GFCommon.ConvertStrToInt(strHole);
                        iHoleNum = GFCommon.ConvertStrToInt(strScore);

                        int n = 0;
                        for (n = 0; n < dgvPlayer.RowCount; n++)
                        {
                            string strTempCompetitionID = dgvPlayer.Rows[n].Cells["F_CompetitionPosition"].Value.ToString();
                            if (strTempCompetitionID == nCompetitionID.ToString())
                                break;
                        }
                        nRow = n;
                        nCol = 0;

                        if (iHole > 0 && iHole < 10)
                        {
                            nCol = 9 + iHole;
                        }
                        else if (iHole > 9 && iHole < 19)
                        {
                            nCol = 10 + iHole;
                        }

                        if (dgvPlayer.Rows[nRow].Cells[strHole].Value != null)
                        {
                            dgvPlayer.Rows[nRow].Cells[strHole].Value = strScore;
                            if (strScore.Length == 0)
                                m_dtOldPlayer.Rows[nRow][strHole] = DBNull.Value;
                            else
                                m_dtOldPlayer.Rows[nRow][strHole] = strScore;


                            FillHoleColor(nRow, nCol, iHole, iHoleNum, strHole);
                            FillPlayerOUTIN(nRow);
                            FillPlayerRank();
                            FillDataGridViewTeamForTcp();
                        }
                    }
                    else
                    {
                        if (GFCommon.g_GFPlugin != null)
                            GFCommon.g_GFPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, nMatchID, nMatchID, null);
                    }
                }
            }
        }

        void FillDataGridViewTeamForTcp()
        {
            if (this.dgvTeam.InvokeRequired)
            {
                SetTeamGridView text = new SetTeamGridView(FillDataGridViewTeamForTcp);
                this.Invoke(text);
            }
            else
            {
                GFCommon.g_ManageDB.FillGridViewTeam(m_iCurMatchID, this.dgvTeam);
            }
        }

        private void btnX_GoldSetting_Click(object sender, EventArgs e)
        {
            frmPlayOffSetting frmThePlayOffSetting = new frmPlayOffSetting();
            frmThePlayOffSetting.m_iCurMatchID = m_iCurMatchID;

            string strHoleSec = "";
            GFCommon.g_ManageDB.GetMatchPlayOffInfo(m_iCurMatchID, 1, out strHoleSec);
            frmThePlayOffSetting.m_strHoleSec = strHoleSec;
            frmThePlayOffSetting.ShowDialog();

            if (frmThePlayOffSetting.DialogResult == DialogResult.OK)
            {
                string strNewHoleSec = frmThePlayOffSetting.m_strHoleSec;
                if (strHoleSec != strNewHoleSec)
                {
                    GFCommon.g_ManageDB.SetMatchPlayOffInfo(m_iCurMatchID, 1, strNewHoleSec);
                    FillGridViewPlayOffGold();
                }
            }
        }

        private void btnX_SilverSetting_Click(object sender, EventArgs e)
        {
            frmPlayOffSetting frmThePlayOffSetting = new frmPlayOffSetting();
            frmThePlayOffSetting.m_iCurMatchID = m_iCurMatchID;

            string strHoleSec = "";
            GFCommon.g_ManageDB.GetMatchPlayOffInfo(m_iCurMatchID, 2, out strHoleSec);
            frmThePlayOffSetting.m_strHoleSec = strHoleSec;
            frmThePlayOffSetting.ShowDialog();

            if (frmThePlayOffSetting.DialogResult == DialogResult.OK)
            {
                string strNewHoleSec = frmThePlayOffSetting.m_strHoleSec;
                if (strHoleSec != strNewHoleSec)
                {
                    GFCommon.g_ManageDB.SetMatchPlayOffInfo(m_iCurMatchID, 2, strNewHoleSec);
                    FillGridViewPlayOffSilver();
                }
            }
        }

        private void btnX_BronzeSetting_Click(object sender, EventArgs e)
        {
            frmPlayOffSetting frmThePlayOffSetting = new frmPlayOffSetting();
            frmThePlayOffSetting.m_iCurMatchID = m_iCurMatchID;

            string strHoleSec = "";
            GFCommon.g_ManageDB.GetMatchPlayOffInfo(m_iCurMatchID, 3, out strHoleSec);
            frmThePlayOffSetting.m_strHoleSec = strHoleSec;
            frmThePlayOffSetting.ShowDialog();

            if (frmThePlayOffSetting.DialogResult == DialogResult.OK)
            {
                string strNewHoleSec = frmThePlayOffSetting.m_strHoleSec;
                if (strHoleSec != strNewHoleSec)
                {
                    GFCommon.g_ManageDB.SetMatchPlayOffInfo(m_iCurMatchID, 3, strNewHoleSec);
                    FillGridViewPlayOffBronze();
                }
            }
        }

        void FillGridViewPlayOffGold()
        {
            m_dtPlayOffGold = new DataTable();
            m_dtPlayOffGold = GFCommon.g_ManageDB.FillGridViewPlayOff(m_iCurMatchID, 1, dgvPlayOffGold);
        }

        void FillGridViewPlayOffSilver()
        {
            m_dtPlayOffSilver = new DataTable();
            m_dtPlayOffSilver = GFCommon.g_ManageDB.FillGridViewPlayOff(m_iCurMatchID, 2, dgvPlayOffSilver);
        }

        void FillGridViewPlayOffBronze()
        {
            m_dtPlayOffBronze = new DataTable();
            m_dtPlayOffBronze = GFCommon.g_ManageDB.FillGridViewPlayOff(m_iCurMatchID, 3, dgvPlayOffBronze);
        }

        private void dgvPlayOffGold_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            if (e.ColumnIndex > 3)
            {
                if (e.FormattedValue != null)
                {
                    string strText = e.FormattedValue.ToString();
                    int nOut = 0;
                    if (e.FormattedValue.ToString().Length != 0 &&
                        !int.TryParse(e.FormattedValue.ToString(), out nOut))
                        e.Cancel = true;
                    if (nOut < 0 || nOut > 99)
                        e.Cancel = true;
                }
            }
        }

        private void dgvPlayOffSilver_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            if (e.ColumnIndex > 3)
            {
                if (e.FormattedValue != null)
                {
                    string strText = e.FormattedValue.ToString();
                    int nOut = 0;
                    if (e.FormattedValue.ToString().Length != 0 &&
                        !int.TryParse(e.FormattedValue.ToString(), out nOut))
                        e.Cancel = true;
                    if (nOut < 0 || nOut > 99)
                        e.Cancel = true;
                }
            }
        }

        private void dgvPlayOffBronze_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            if (e.ColumnIndex > 3)
            {
                if (e.FormattedValue != null)
                {
                    string strText = e.FormattedValue.ToString();
                    int nOut = 0;
                    if (e.FormattedValue.ToString().Length != 0 &&
                        !int.TryParse(e.FormattedValue.ToString(), out nOut))
                        e.Cancel = true;
                    if (nOut < 0 || nOut > 99)
                        e.Cancel = true;
                }
            }
        }


        private void dgvPlayOffGold_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex <= 3)
            {
                return;
            }

            DataGridView dgv = this.dgvPlayOffGold;
            int nHoleCount = dgv.ColumnCount-4;
            int nRowIndex = e.RowIndex;

            string strHoleSec = "";
            for (int n = 1; n <= nHoleCount; n++)
            {
                Object obValue = dgv.Rows[nRowIndex].Cells[3+n].Value;
                int nColIdx = n - 1;
                if (obValue == null)
                {
                    strHoleSec += "00";
                }
                else
                {
                    string strValue = obValue.ToString();
                    strValue.Trim();
                    if (strValue.Length == 0)
                        strHoleSec += "00";
                    else
                    {
                        strHoleSec += string.Format("{0:D2}", int.Parse(strValue));
                    }
                }
            }

            String strRegisterID = dgv.Rows[nRowIndex].Cells[0].Value.ToString();
            int nRegisterID = 0;
            if (int.TryParse(strRegisterID, out nRegisterID))
            {
                GFCommon.g_ManageDB.SetMatchPlayOffPlayer(m_iCurMatchID, 1, nRegisterID, strHoleSec);
                FillPlayerRank();
            }
        }

        private void dgvPlayOffSilver_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex <= 3)
            {
                return;
            }

            DataGridView dgv = this.dgvPlayOffSilver;
            int nHoleCount = dgv.ColumnCount - 4;
            int nRowIndex = e.RowIndex;

            string strHoleSec = "";
            for (int n = 1; n <= nHoleCount; n++)
            {
                Object obValue = dgv.Rows[nRowIndex].Cells[3 + n].Value;
                int nColIdx = n - 1;
                if (obValue == null)
                {
                    strHoleSec += "00";
                }
                else
                {
                    string strValue = obValue.ToString();
                    strValue.Trim();
                    if (strValue.Length == 0)
                        strHoleSec += "00";
                    else
                    {
                        strHoleSec += string.Format("{0:D2}", int.Parse(strValue));
                    }
                }
            }

            String strRegisterID = dgv.Rows[nRowIndex].Cells[0].Value.ToString();
            int nRegisterID = 0;
            if (int.TryParse(strRegisterID, out nRegisterID))
            {
                GFCommon.g_ManageDB.SetMatchPlayOffPlayer(m_iCurMatchID, 2, nRegisterID, strHoleSec);
                FillPlayerRank();
            }
        }

        private void dgvPlayOffBronze_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex <= 3)
            {
                return;
            }

            DataGridView dgv = this.dgvPlayOffBronze;
            int nHoleCount = dgv.ColumnCount - 4;
            int nRowIndex = e.RowIndex;

            string strHoleSec = "";
            for (int n = 1; n <= nHoleCount; n++)
            {
                Object obValue = dgv.Rows[nRowIndex].Cells[3 + n].Value;
                int nColIdx = n - 1;
                if (obValue == null)
                {
                    strHoleSec += "00";
                }
                else
                {
                    string strValue = obValue.ToString();
                    strValue.Trim();
                    if (strValue.Length == 0)
                        strHoleSec += "00";
                    else
                    {
                        strHoleSec += string.Format("{0:D2}", int.Parse(strValue));
                    }
                }
            }

            String strRegisterID = dgv.Rows[nRowIndex].Cells[0].Value.ToString();
            int nRegisterID = 0;
            if (int.TryParse(strRegisterID, out nRegisterID))
            {
                GFCommon.g_ManageDB.SetMatchPlayOffPlayer(m_iCurMatchID, 3, nRegisterID, strHoleSec);
                FillPlayerRank();
            }
        }
    }
}
