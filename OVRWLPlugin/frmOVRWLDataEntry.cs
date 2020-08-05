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

namespace AutoSports.OVRWLPlugin
{
    public partial class OVRWLDataEntryForm : Office2007Form
    {
        public int m_nCurMatchID = -1;
        public string m_strEventCode = "";
        public string m_strPhaseCode = "";
        public string m_strMatchCode = "";
        public int m_nMatchStatusID = -1;
        //自动增加试举重量
        public bool bAutoAttempt = true;
        //自动接收计时记分数据
        public bool bAutoReceive = false;

        //9 is 1st attempt; 11is 2nd attempt ; 13 is 3rd attempt
        public int m_nColumnIndexRes = 9;
        //试举次数，默认值
        private int attemptTimes = 1;
        //textBox缺省输入
        private string defaultInput = string.Empty;
        private bool m_bImporting = false;

        public System.Data.DataTable m_dtRecord = null;


        public OVRWLDataEntryForm()
        {
            InitializeComponent();
        }

        private void Localization()
        {
            this.labX_MatchInfo.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_labX_MatchInfo");
            this.gbCurAthlete.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_labX_AtheleName");
            this.labXOrder.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_labX_Order");
            this.labXBib.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_labX_Bib");
            this.labXBodyWeight.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_labX_Weight");
            this.labXNOC.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_labX_NOC");
            this.labXIRM.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_labX_IRM");
            this.labXMatchName.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_labX_MatchName");
            this.labX1st.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_labX_1st");
            this.labX2nd.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_labX_2nd");
            this.labX3rd.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_labX_3rd");
            this.labXResult.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_labX_Result");

            this.btnX_StatusSetting.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_btnX_StatusSetting");
            this.btnX_Exit.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_btnX_Exit");
            this.btnXOfficials.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_btnX_Officials");
            this.btnX_Draw.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_btnX_Draw");
            this.btnXSetAttempt.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_btnX_Attempt");
            this.btnX_Current.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_btnX_CurrentAttempt");
            this.btnX_ResultStatus.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_btnX_LightStatus");
            this.btnX_Finished.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_btnX_Finished");
            this.btnX_1th.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_btnX_1st");
            this.btnX_2th.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_btnX_2nd");
            this.btnX_3th.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_btnX_3rd");

            this.cbTimeScoring.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_cbX_TS");
            this.cbTSMix.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_cbX_MixTS");
            this.cbAuto.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_cbX_Attempt");

        }

        private void OVRWLDataEntryForm_Load(object sender, EventArgs e)
        {
            GVWL.g_ManageDB.InitGame();
            Localization();
            UpdateRecordsDataGridView();
        }

        public void OnMsgFlushSelMatch(int nWndMode, int nMatchID)
        {
            if (nMatchID <= 0)
            {
                MessageBoxEx.Show(LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "SelectMatchInfo"));
                return;
            }
            if (nMatchID == m_nCurMatchID)
                return;
            // Intial Basic Info
            OVRDataBaseUtils.GetActiveInfo(GVWL.g_adoDataBase.DBConnect, out GVWL.g_SportID, out GVWL.g_DisciplineID, out GVWL.g_strLang);

            this.dgv_List.Columns.Clear();
            this.dgv_List.Rows.Clear();

            m_nCurMatchID = nMatchID;

            GVWL.g_WLPlugin.SetReportContext("MatchID", m_nCurMatchID.ToString());

            System.Data.DataTable dt = GVWL.g_ManageDB.GetMatchInfo(m_nCurMatchID);
            if (dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["EventCode"] != DBNull.Value)
                    m_strEventCode = dt.Rows[0]["EventCode"].ToString();
                else
                    m_strEventCode = "";
                if (dt.Rows[0]["PhaseCode"] != DBNull.Value)
                    m_strPhaseCode = dt.Rows[0]["PhaseCode"].ToString();
                else
                    m_strPhaseCode = "";
                if (dt.Rows[0]["MatchCode"] != DBNull.Value)
                    m_strMatchCode = dt.Rows[0]["MatchCode"].ToString();
                else
                    m_strMatchCode = "";

                string strInfo = "";
                if (dt.Rows[0]["EventName"] != DBNull.Value)
                    strInfo += dt.Rows[0]["EventName"].ToString();
                if (strInfo.Length != 0)
                    strInfo += "\n";
                if (dt.Rows[0]["PhaseName"] != DBNull.Value)
                    strInfo += dt.Rows[0]["PhaseName"].ToString();
                if (strInfo.Length != 0)
                    strInfo += " ";
                if (dt.Rows[0]["MatchName"] != DBNull.Value)
                    strInfo += dt.Rows[0]["MatchName"].ToString();
                {
                    labX_MatchInfo.Text = strInfo;
                    this.labXMatchName.Text = dt.Rows[0]["MatchName"].ToString();
                }


                if (dt.Rows[0]["MatchStatusID"] != DBNull.Value)
                    m_nMatchStatusID = int.Parse(dt.Rows[0]["MatchStatusID"].ToString());
                else
                    m_nMatchStatusID = -1;
            }
            else
            {
                labX_MatchInfo.Text = "";
                m_nMatchStatusID = -1;
            }

            this.m_dtRecord = GVWL.g_ManageDB.GetRecordList(m_nCurMatchID);

            this.UpdateMatchStatus();
            this.SettingControlsReadonly();
            this.InitRecordsDataGridView();
            this.UpdateRecordsDataGridView();
            this.InitListDataGridView();
            this.UpdateListDataGridView();
            if (dgv_List.SelectedRows.Count >= 1)
            {
                AutoSelectCurrentPlayer(dgv_List);
                this.UpdateCurrentAthleteData(dgv_List.SelectedRows[0]);
            }
            else this.UpdateCurrentAthleteData(new DataGridViewRow());
            this.UpdateListDataGridViewStyle();
            this.InitTotalDataGridView();
            this.UpdateTotalDataGridView();
            this.DataExchangeDeleteInvalidLightOrder();
            this.DataExchangeLightOrder();
            this.SetDefaultWeight();

            if (cbTimeScoring.Checked)
            {
                cbTimeScoring_CheckedChanged(new object(), new EventArgs());
            }
            if (cbTSMix.Checked)
            {
                SettingControls(false);
                this.dgv_List.ReadOnly = true;
            }
        }

        #region 报表
        public void QueryReportContext(OVRReportContextQueryArgs args)
        {
            if (args == null) return;
            switch (args.Name)
            {
                case "MatchID":
                    //if(m_nCurMatchID>0)
                    {
                        args.Value = m_nCurMatchID.ToString();
                        args.Handled = true;
                    }
                    break;
                default:
                    break;
            }
        }
        #endregion

        #region -- DataGridView函数，增改试举重量
        private void dgv_List_CellMouseDown(object sender, DataGridViewCellMouseEventArgs e)
        {
            if (m_nMatchStatusID >= 50 && m_nMatchStatusID <= 100 && !cbTimeScoring.Checked)
            {
                string columjName = dgv_List.Columns[e.ColumnIndex].Name;
                if (columjName.ToUpper() == "IRM")
                {
                    this.dgv_List.ContextMenuStrip = MenuStrip_IRM;
                }
                else if (columjName.ToLower().EndsWith("res"))
                {
                    this.dgv_List.ContextMenuStrip = MenuStrip_Res;
                    m_nColumnIndexRes = e.ColumnIndex;
                }
                else if (columjName.ToLower().EndsWith("status"))
                {
                    this.dgv_List.ContextMenuStrip = MenuStrip_Status;
                }
                else
                    this.dgv_List.ContextMenuStrip = null;
            }
            else
            {
                this.dgv_List.ContextMenuStrip = null;
            }
        }

        private void dgv_List_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            if (m_bImporting)
            {
                return;
            }
            bool isInValid = false;
            // return;//注释
            if ((dgv_List.Columns[e.ColumnIndex].Name.ToLower().EndsWith("attempt"))
                  && e.FormattedValue != null)
            {
                if (e.FormattedValue.ToString() == "")
                    return;
                //判断输入三次所要重量的正确性
                float attOut = 0;
                if (!float.TryParse(e.FormattedValue.ToString(), out attOut))
                {
                    isInValid = true;
                }
                //试举重量不能小于上次的重量
                else if (dgv_List.Columns[e.ColumnIndex].Name.ToLower().EndsWith("attempt") && dgv_List.Columns[e.ColumnIndex].Name.ToLower() != "1stattempt")
                {
                    //试举重量小于上一次试举重量，并且上次试举成功
                    string lastText = string.Empty;
                    if (dgv_List[e.ColumnIndex - 2, e.RowIndex].Value != null)
                        lastText = dgv_List[e.ColumnIndex - 2, e.RowIndex].Value.ToString();
                    if (dgv_List[e.ColumnIndex - 1, e.RowIndex].Value == null)
                    {
                        // e.Cancel = true;
                        return;
                    }
                    string lastRes = dgv_List[e.ColumnIndex - 1, e.RowIndex].Value.ToString();

                    float lastOut = 0;
                    if (float.TryParse(lastText, out lastOut))
                    {
                        if (attOut == lastOut && lastRes.Replace("0", "").Length > 1)
                        {
                            DevComponents.DotNetBar.MessageBoxEx.Show("The value of attempt can't equals last successful attempt!");
                            isInValid = true;
                        }
                        else if (attOut != 0.0 && attOut < lastOut)
                        {
                            DevComponents.DotNetBar.MessageBoxEx.Show("The value of attempt can't less than last attempt!");
                            isInValid = true;
                        }
                    }
                }
                //试举重量不能低于报名成绩15-20千克
                else if (dgv_List.Columns[e.ColumnIndex].Name.ToLower() == "1stattempt")
                {
                    string otherAttempt = "";
                    if (dgv_List.Rows[e.RowIndex].Cells["Other1stAttempt"].Value != null)
                        otherAttempt = dgv_List.Rows[e.RowIndex].Cells["Other1stAttempt"].Value.ToString();
                    float otherOut = 0;
                    if (float.TryParse(otherAttempt, out otherOut))
                    {
                        float fAttResult = otherOut + attOut;
                        string strInscriptionResult = "";
                        if (dgv_List.Rows[e.RowIndex].Cells["InscriptionResult"].Value != null)
                            strInscriptionResult = dgv_List.Rows[e.RowIndex].Cells["InscriptionResult"].Value.ToString();
                        float fInscriptionResult = 0;
                        if (float.TryParse(strInscriptionResult, out fInscriptionResult))
                        {
                            if (fAttResult < fInscriptionResult)
                            {
                                DevComponents.DotNetBar.MessageBoxEx.Show(string.Format("The value of attempt can't less than Inscription Result!"));
                                //isInValid = true;
                            }
                        }
                    }
                }
            }
            if ((dgv_List.Columns[e.ColumnIndex].Name.ToLower().EndsWith("weight"))
                  && e.FormattedValue != null)
            {
                if (e.FormattedValue.ToString() == "")
                    return;
                //判断输入体重的正确性
                float attOut = 0;
                if (!float.TryParse(e.FormattedValue.ToString(), out attOut))
                {

                    DevComponents.DotNetBar.MessageBoxEx.Show(string.Format("The value of body-weight must be digital!"));
                    dgv_List[e.ColumnIndex, e.RowIndex].Value = dgv_List[e.ColumnIndex, e.RowIndex].Tag;
                    //isInValid = true;
                }
            }
            e.Cancel = isInValid;
        }

        private void dgv_List_CellEnter(object sender, DataGridViewCellEventArgs e)
        {
            if (dgv_List[e.ColumnIndex, e.RowIndex].Value != null)
                dgv_List[e.ColumnIndex, e.RowIndex].Tag = dgv_List[e.ColumnIndex, e.RowIndex].Value;
            else dgv_List[e.ColumnIndex, e.RowIndex].Tag = string.Empty;
        }

        private void dgv_List_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            DataGridView dgv = this.dgv_List;
            string colName = dgv.Columns[e.ColumnIndex].Name;
            int nRowIndex = e.RowIndex;
            if (colName.ToLower().EndsWith("attempt") || colName.ToLower() == "weight")
            {
                this.DataExchangeLightOrder();
                this.DataExchangeStatus(false, true);
                this.DataExchangeBodyWeight();
                this.DataExchangeAttempt(nRowIndex);
                this.DataExchangeResult(nRowIndex);
                this.DataExchangeDeleteInvalidRecords(nRowIndex);
                this.DataExchangeMatchRank();
                this.DataExchangePhaseRank();
                this.DataExchangeEventRank();
                this.UpdateListDataGridViewStyle();
                this.AutoSelectCurrentPlayer(dgv);
                this.UpdateCurrentAthleteData(dgv.SelectedRows[0]);
                int nReturn = 1;
                if (nReturn == 1)
                {
                    GVWL.g_WLPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                }
            }
        }

        #endregion

        #region --试举结果
        private int GetAttemptIndex(DataGridViewRow dgvRow)
        {
            if (dgvRow.Cells["1stRes"].Value.ToString().Length < 1)
                return 1;
            else if (dgvRow.Cells["2ndRes"].Value.ToString().Length < 1)
                return 2;
            else if (dgvRow.Cells["3rdRes"].Value.ToString().Length < 1)
                return 3;
            else return 4;
        }

        private void toolStripMenuItem_Res_Comment(object sender, EventArgs e, string strLight)
        {
            DataGridView dgv = this.dgv_List;
            int columnIndex = m_nColumnIndexRes;

            bool bUpdate = false;
            DataGridViewRow dgvRow = dgv.SelectedRows[0];

            string strComPos = dgvRow.Cells["F_CompetitionPosition"].Value.ToString().Trim();
            bool bReturn = false;
            string columnName = dgvRow.Cells[columnIndex].OwningColumn.Name;
            object colAttempt = dgvRow.Cells[columnIndex - 1].Value;
            bool isFinishedAttempt = false;
            if ((colAttempt != null && !colAttempt.Equals("")) || strLight.Length == 0 || strLight == "222")
            {
                float atttmptWeight = 0;
                if (colAttempt != null && !colAttempt.Equals(""))
                    atttmptWeight = float.Parse(colAttempt.ToString());
                if (columnName == "1stRes")
                {
                    bReturn = GVWL.g_ManageDB.UpdateMatchResult(m_nCurMatchID, int.Parse(strComPos),
                    "-1", strLight, "-1", "-1", "-1", "-1",
                    "-1", "-1", "-1", "-1");
                    if (bReturn)
                    {
                        bUpdate = true;
                        dgvRow.Cells["1stRes"].Value = strLight;
                        if (strLight == "222") dgvRow.Cells["1stRes"].Value = "Gave up";
                        if (strLight != "222" && strLight.Length > 0)
                        {
                            isFinishedAttempt = true;
                            dgvRow.Cells["Status"].Value = "4";
                        }

                        //自动填入下一次试举重量，如本次成功，下次重量+1，如失败，下次依然举当前重量
                        if (bAutoAttempt)
                        {
                            if ((dgvRow.Cells[columnIndex + 1].Value == null || dgvRow.Cells[columnIndex + 1].Value.Equals("")) && strLight.Length > 0)
                            {
                                if (strLight.Replace('0', ' ').Trim().Length > 1)
                                    dgvRow.Cells[columnIndex + 1].Value = atttmptWeight + 1;
                                else
                                    dgvRow.Cells[columnIndex + 1].Value = atttmptWeight;
                            }
                        }

                        this.DataExchangeAttempt(dgvRow.Index);
                        this.DataExchangeResult(dgvRow.Index);
                        this.DataExchangeDeleteInvalidRecords(dgvRow.Index);
                        this.DataExchangeRecord(dgvRow.Index);
                        this.UpdateRecordsDataGridView();
                        //更新试举次数
                        dgvRow.Cells["AttemptTime"].Value = GetAttemptIndex(dgvRow);
                        UpdateCurrentAthleteData(dgvRow);
                    }
                }
                else if (columnName == "2ndRes")
                {
                    bReturn = GVWL.g_ManageDB.UpdateMatchResult(m_nCurMatchID, int.Parse(strComPos),
                   "-1", "-1", "-1", strLight, "-1", "-1",
                   "-1", "-1", "-1", "-1");
                    if (bReturn)
                    {
                        bUpdate = true;
                        dgvRow.Cells["2ndRes"].Value = strLight;
                        if (strLight == "222") dgvRow.Cells["2ndRes"].Value = "Gave up";
                        if (strLight != "222" && strLight.Length > 0)
                        {
                            isFinishedAttempt = true;
                            dgvRow.Cells["Status"].Value = "4";
                        }

                        //自动填入下一次试举重量，如本次成功，下次重量+1，如失败，下次依然举当前重量
                        if (bAutoAttempt)
                        {
                            if ((dgvRow.Cells[columnIndex + 1].Value == null || dgvRow.Cells[columnIndex + 1].Value.Equals("")) && strLight.Length > 0)
                            {
                                if (strLight.Replace('0', ' ').Trim().Length > 1)
                                    dgvRow.Cells[columnIndex + 1].Value = atttmptWeight + 1;
                                else
                                    dgvRow.Cells[columnIndex + 1].Value = atttmptWeight;
                            }
                        }

                        this.DataExchangeAttempt(dgvRow.Index);
                        this.DataExchangeResult(dgvRow.Index);
                        this.DataExchangeDeleteInvalidRecords(dgvRow.Index);
                        this.DataExchangeRecord(dgvRow.Index);
                        this.UpdateRecordsDataGridView();
                        //更新试举次数
                        dgvRow.Cells["AttemptTime"].Value = GetAttemptIndex(dgvRow);
                        UpdateCurrentAthleteData(dgvRow);
                    }
                }
                else if (columnName == "3rdRes")
                {
                    bReturn = GVWL.g_ManageDB.UpdateMatchResult(m_nCurMatchID, int.Parse(strComPos),
                    "-1", "-1", "-1", "-1", "-1", strLight,
                    "-1", "-1", "-1", "-1");
                    if (bReturn)
                    {
                        bUpdate = true;
                        dgvRow.Cells["3rdRes"].Value = strLight;
                        if (strLight == "222") dgvRow.Cells["3rdRes"].Value = "Gave up";
                        if (strLight != "222" && strLight.Length > 0)
                        {
                            isFinishedAttempt = true;
                            dgvRow.Cells["Status"].Value = "4";
                        }

                        this.DataExchangeResult(dgvRow.Index);
                        this.DataExchangeDeleteInvalidRecords(dgvRow.Index);
                        this.DataExchangeRecord(dgvRow.Index);
                        this.UpdateRecordsDataGridView();
                        this.DataExchangeFinishOrder(dgvRow.Index);
                        //更新试举次数
                        dgvRow.Cells["AttemptTime"].Value = GetAttemptIndex(dgvRow);

                        this.UpdateCurrentAthleteData(dgvRow);
                    }
                }
            }
            if (bUpdate)
            {
                this.DataExchangeLightOrder();
                this.DataExchangeStatus(isFinishedAttempt, true);
                this.DataExchangeBodyWeight();
                this.DataExchangeMatchRank();
                this.DataExchangePhaseRank();
                this.DataExchangeEventRank();
                this.UpdateListDataGridViewStyle();
                this.AutoSelectCurrentPlayer(dgv);

                //比赛成绩有变化，需要发送消息通知
                if (m_nMatchStatusID > 40)
                {
                    GVWL.g_WLPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                    //GVWL.g_WLPlugin.DataChangedNotify(OVRDataChangedType.emMatchOrderInRound, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                }
            }
        }
        private void toolStripMenuItem_ResSucc_111_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Res_Comment(sender, e, "111");
        }
        private void toolStripMenuItem_ResSucc_110_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Res_Comment(sender, e, "110");
        }
        private void toolStripMenuItem_ResSucc_101_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Res_Comment(sender, e, "101");
        }
        private void toolStripMenuItem_ResSucc_011_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Res_Comment(sender, e, "011");
        }
        private void toolStripMenuItem_ResFail_000_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Res_Comment(sender, e, "000");
        }
        private void toolStripMenuItem_ResFail_001_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Res_Comment(sender, e, "001");
        }
        private void toolStripMenuItem_ResFail_010_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Res_Comment(sender, e, "010");
        }
        private void toolStripMenuItem_ResFail_100_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Res_Comment(sender, e, "100");
        }

        private void toolStripMenuItem_ResNull_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Res_Comment(sender, e, "");
        }

        private void toolStripMenuItem_ResGiveUp_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Res_Comment(sender, e, "222");
        }

        #endregion

        #region --IRM处理 (DNS,DSQ,DNF OR OK)
        private void toolStripMenuItem_IRM_Comment(object sender, EventArgs e, string strIRM)
        {
            DataGridView dgv = this.dgv_List;

            DataGridViewRow myRow = dgv.SelectedRows[0];
            bool bUpdate = false;

            string strComPos = myRow.Cells["F_CompetitionPosition"].Value.ToString().Trim();
            bool bReturn = GVWL.g_ManageDB.UpdateMatchResult(m_nCurMatchID, int.Parse(strComPos),
                "-1", "-1", "-1",
                "-1", "-1", "-1", "-1", "-1", "-1", strIRM);
            if (bReturn)
            {
                bUpdate = true;
                myRow.Cells["Result"].Value = "";
                myRow.Cells["IRM"].Value = strIRM;
                myRow.Cells["Status"].Value = "4";
                switch (strIRM)
                {
                    case "DNS":
                        btnX_IRMS.Text = "DNS";
                        break;
                    case "DNF":
                        btnX_IRMS.Text = "DNF";
                        break;
                    case "DSQ":
                        btnX_IRMS.Text = "DSQ";
                        break;
                    default:
                        btnX_IRMS.Text = "--";
                        break;

                }
                this.DataExchangeResult(myRow.Index);
                this.DataExchangeDeleteInvalidRecords(myRow.Index);
                if (string.IsNullOrEmpty(strIRM))
                    dgv.SelectedRows[0].ReadOnly = false;
                else
                    dgv.SelectedRows[0].ReadOnly = true;
            }
            if (bUpdate)
            {
                this.DataExchangeLightOrder();
                this.DataExchangeStatus(true, true);
                this.DataExchangeBodyWeight();
                this.DataExchangeMatchRank();
                this.DataExchangePhaseRank();
                this.DataExchangeEventRank();
                this.AutoSelectCurrentPlayer(dgv);
                this.UpdateCurrentAthleteData(dgv.SelectedRows[0]);
                if (m_nMatchStatusID > 40)
                    GVWL.g_WLPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }
        }
        private void toolStripMenuItem_DNS_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_IRM_Comment(sender, e, "DNS");
        }
        private void toolStripMenuItem_DSQ_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_IRM_Comment(sender, e, "DSQ");
        }
        private void toolStripMenuItem_DNF_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_IRM_Comment(sender, e, "DNF");
        }
        private void toolStripMenuItem_OK_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_IRM_Comment(sender, e, "");
        }

        private void btnX_IRM_Click(object sender, EventArgs e)
        {
            ButtonItem btni = (ButtonItem)sender;
            string curIRM = btni.Tag.ToString();
            toolStripMenuItem_IRM_Comment(sender, e, curIRM);
        }
        #endregion

        #region --运动员状态设置 0刚举过；1当前试举；2下次试举；3待举
        private void toolStripMenuItem_Status_Comment(object sender, EventArgs e, string strStatus)
        {
            DataGridView dgv = this.dgv_List;

            DataGridViewRow myRow = dgv.SelectedRows[0];
            myRow.Cells["Status"].Value = strStatus;

            foreach (DataGridViewRow dr in dgv.Rows)
            {
                if (dr.Index != myRow.Index && dr.Cells["Status"].Value.Equals(strStatus))
                {
                    dr.Cells["Status"].Value = 3;
                    break;
                }
                else if (dr.Index != myRow.Index && dr.Cells["Status"].Value.ToString().Contains(strStatus))
                {
                    dr.Cells["Status"].Value = dr.Cells["Status"].Value.ToString().Replace(strStatus, "");
                    break;
                }
            }

            this.DataExchangeStatus(false, false);
            if (m_nMatchStatusID > 40)
                GVWL.g_WLPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void toolStripMenuItem_Previous_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Status_Comment(sender, e, "0");
        }

        private void toolStripMenuItem_Current_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Status_Comment(sender, e, "1");
        }

        private void toolStripMenuItem_Next_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Status_Comment(sender, e, "2");
        }

        private void toolStripMenuItem_Other_Click(object sender, EventArgs e)
        {
            toolStripMenuItem_Status_Comment(sender, e, "3");
        }
        #endregion

        #region -- 退出、抽签、官员设置等按钮函数
        private void btnX_Exit_Click(object sender, EventArgs e)
        {
            m_nCurMatchID = -1;
            m_strEventCode = "";
            m_strPhaseCode = "";
            m_strMatchCode = "";
            m_nMatchStatusID = -1;

            this.dgv_List.EndEdit();
            this.dgv_List.Columns.Clear();
            this.dgv_List.Rows.Clear();

            this.dgv_Total.Columns.Clear();
            this.dgv_Total.Rows.Clear();

            this.dgv_Records.Columns.Clear();
            this.dgv_Records.Rows.Clear();

            this.UpdateCurrentAthleteData(new DataGridViewRow());

            this.labX_MatchInfo.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_labX_MatchInfo");
            this.btnX_StatusSetting.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRWLPlugin_OVRWLDataEntryForm_btnX_StatusSetting");
        }

        private void btnX_Officials_Click(object sender, EventArgs e)
        {
            frmOVROfficialEntry OfficialForm = new frmOVROfficialEntry(m_nCurMatchID);
            OfficialForm.m_strLanguageCode = GVWL.g_strLang;
            OfficialForm.m_iDisciplineID = GVWL.g_DisciplineID;
            OfficialForm.ShowDialog();
        }

        private void btnX_Draw_Click(object sender, EventArgs e)
        {
            OVRWLAutoDrawForm m_OVRWLAutoDrawForm = new OVRWLAutoDrawForm();
            m_OVRWLAutoDrawForm.Owner = this;
            m_OVRWLAutoDrawForm.ResetRegisterGrid(true);
            m_OVRWLAutoDrawForm.Show();
        }
        #endregion

        #region -- 比赛状态设置
        private void buttonItem_MatchStatus_Comment(object sender, EventArgs e, int nStatus)
        {
            bool bReturn = GVWL.g_ManageDB.UpdateMatchStatus(m_nCurMatchID, nStatus);
            if (bReturn)
            {
                m_nMatchStatusID = nStatus;
                this.UpdateMatchStatus();
                this.SettingControlsReadonly();
                //GVWL.g_WLPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatus, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }
        }
        private void buttonItem_Scheduled_Click(object sender, EventArgs e)
        {
            SettingInputControls(false);
            buttonItem_MatchStatus_Comment(sender, e, 30);
        }
        private void buttonItem_StartList_Click(object sender, EventArgs e)
        {
            SettingInputControls(true);
            buttonItem_MatchStatus_Comment(sender, e, 40);
            GVWL.g_WLPlugin.DataChangedNotify(OVRDataChangedType.emMatchInfo, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);

        }
        private void buttonItem_Running_Click(object sender, EventArgs e)
        {
            SettingInputControls(true);
            buttonItem_MatchStatus_Comment(sender, e, 50);
        }
        private void buttonItem_Suspend_Click(object sender, EventArgs e)
        {
            buttonItem_MatchStatus_Comment(sender, e, 60);
        }
        private void buttonItem_Unofficial_Click(object sender, EventArgs e)
        {
            SettingInputControls(true);
            buttonItem_MatchStatus_Comment(sender, e, 100);
        }
        private void buttonItem_Finished_Click(object sender, EventArgs e)
        {
            SettingInputControls(false);
            bool bReturn = false;
            bReturn = GVWL.g_ManageDB.UpdateMatchStatus(m_nCurMatchID, 110);
            if (bReturn)
            {
                bReturn = GVWL.g_ManageDB.AutoProgressMatch(m_nCurMatchID);
            }
            if (bReturn)
            {
                m_nMatchStatusID = 110;
                this.UpdateMatchStatus();
                this.SettingControlsReadonly();
                GVWL.g_WLPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }
        }
        private void buttonItem_Revision_Click(object sender, EventArgs e)
        {
            SettingInputControls(true);
            buttonItem_MatchStatus_Comment(sender, e, 120);
        }
        private void buttonItem_Canceled_Click(object sender, EventArgs e)
        {
            SettingInputControls(false);
            buttonItem_MatchStatus_Comment(sender, e, 130);
        }

        private void SettingInputControls(bool isUsed)
        {
            txtBodyWeight.Enabled = isUsed;
            txt1th.Enabled = isUsed;
            txt2th.Enabled = isUsed;
            txt3th.Enabled = isUsed;
        }

        private void SettingControlsReadonly()
        {
            if (m_nMatchStatusID > 100)
            {
                dgv_List.ReadOnly = true;
                dgv_List.ContextMenuStrip = null;
            }
            else
            {
                dgv_List.ReadOnly = false;
            }
        }

        private void SettingControls(bool canUsed)
        {
            btnX_Finished.Enabled = canUsed;
            btnX_ResultStatus.Enabled = canUsed;
            btnX_IRMS.Enabled = canUsed;
            btnX_Current.Enabled = canUsed;
            LED1.Enabled = canUsed;
            LED2.Enabled = canUsed;
            LED3.Enabled = canUsed;
            btnXSetAttempt.Enabled = canUsed;
            btnXMin.Enabled = canUsed;
            btnXAdd.Enabled = canUsed;

            btnX_1th.Enabled = canUsed;
            btnX_2th.Enabled = canUsed;
            btnX_3th.Enabled = canUsed;

            cbAuto.Enabled = canUsed;
        }
        #endregion

        #region 处理当前运动员

        private void dgv_List_SelectionChanged(object sender, EventArgs e)
        {
            if (dgv_List.SelectedRows.Count > 0)
            {
                DataGridViewRow dr = dgv_List.SelectedRows[0];
                UpdateCurrentAthleteData(dr);
            }
        }

        private void UpdateCurrentAthleteData(DataGridViewRow dr)
        {
            try
            {
                if (dr != null && dr.Cells != null && dr.Index >= 0)
                {
                    this.gbCurAthlete.Tag = dr;
                    //运动员名字
                    if (dr.Cells["Name"].Value == null)
                        gbCurAthlete.Text = "--";
                    else gbCurAthlete.Text = dr.Cells["Name"].Value.ToString();
                    //试举顺序
                    if (dr.Cells["LightOrder"].Value == null)
                        txtOrder.Text = "--";
                    else txtOrder.Text = dr.Cells["LightOrder"].Value.ToString();
                    //Bib号
                    if (dr.Cells["Bib"].Value == null)
                        txtBib.Text = "--";
                    else txtBib.Text = dr.Cells["Bib"].Value.ToString();
                    //体重
                    if (dr.Cells["Weight"].Value == null)
                        txtBodyWeight.Text = "--";
                    else
                    {
                        if (dr.Cells["Weight"].Value.ToString() != "")
                            txtBodyWeight.Text = Convert.ToDouble(dr.Cells["Weight"].Value).ToString("F2");
                    }
                    //国籍代码
                    if (dr.Cells["NOC"].Value == null)
                        txtNOC.Text = "--";
                    else txtNOC.Text = dr.Cells["NOC"].Value.ToString();
                    //IRM状态 ： DNS,DNF,DSQ
                    if (dr.Cells["IRM"].Value == null)
                        btnX_IRMS.Text = "--";
                    else
                    {
                        string strIRM = dr.Cells["IRM"].Value.ToString();
                        switch (strIRM)
                        {
                            case "DNS":
                                btnX_IRMS.Text = "DNS";
                                break;
                            case "DNF":
                                btnX_IRMS.Text = "DNF";
                                break;
                            case "DSQ":
                                btnX_IRMS.Text = "DSQ";
                                break;
                            default:
                                btnX_IRMS.Text = "--";
                                break;

                        }
                    }
                    //抓举或挺举总成绩
                    if (dr.Cells["Result"].Value == null)
                        txtResult.Text = "--";
                    else txtResult.Text = dr.Cells["Result"].Value.ToString();
                    //各次试举成绩及结果状态
                    if (dr.Cells["1stAttempt"].Value != null)
                        txt1th.Text = dr.Cells["1stAttempt"].Value.ToString();
                    else txt1th.Text = "";
                    if (dr.Cells["1stRes"].Value != null)
                    {
                        string light1 = dr.Cells["1stRes"].Value.ToString();
                        if (light1.Length > 0)
                            txt1th.ForeColor = light1.Replace('0', ' ').Trim().Length > 1 ? Color.Blue : Color.Red;
                        else txt1th.ForeColor = Color.Black;
                    }
                    if (dr.Cells["2ndAttempt"].Value != null)
                        txt2th.Text = dr.Cells["2ndAttempt"].Value.ToString();
                    else txt2th.Text = "";
                    if (dr.Cells["2ndRes"].Value != null)
                    {
                        string light2 = dr.Cells["2ndRes"].Value.ToString();
                        if (light2.Length > 0)
                            txt2th.ForeColor = light2.Replace('0', ' ').Trim().Length > 1 ? Color.Blue : Color.Red;
                        else txt2th.ForeColor = Color.Black;
                    }
                    if (dr.Cells["3rdAttempt"].Value != null)
                        txt3th.Text = dr.Cells["3rdAttempt"].Value.ToString();
                    else txt3th.Text = "";
                    if (dr.Cells["3rdRes"].Value != null)
                    {
                        string light3 = dr.Cells["3rdRes"].Value.ToString();
                        if (light3.Length > 0)
                            txt3th.ForeColor = light3.Replace('0', ' ').Trim().Length > 1 ? Color.Blue : Color.Red;
                        else txt3th.ForeColor = Color.Black;
                    }
                    //记录
                    if (dr.Cells["Record"].Value != null)
                        labelXRecords.Text = dr.Cells["Record"].Value.ToString();
                    //试举次数
                    if (dr.Cells["AttemptTime"].Value != null)
                    {
                        if (dr.Cells["AttemptTime"].Value.ToString() != "")
                            attemptTimes = Convert.ToInt32(dr.Cells["AttemptTime"].Value.ToString());
                        else attemptTimes = 1;
                    }
                    switch (attemptTimes)
                    {
                        case 1:
                            btnX_th_Click(btnX_1th, new EventArgs());
                            break;
                        case 2:
                            btnX_th_Click(btnX_2th, new EventArgs());
                            break;
                        case 3:
                            btnX_th_Click(btnX_3th, new EventArgs());
                            break;
                        case 4:
                            btnX_th_Click(new ButtonX(), new EventArgs());
                            break;
                    }
                }
                else
                {
                    #region 退出比赛，当前运动员信息置空
                    //运动员名字
                    gbCurAthlete.Text = "";
                    //试举顺序
                    txtOrder.Text = "--";
                    //Bib号
                    txtBib.Text = "--";
                    //体重
                    txtBodyWeight.Text = "";
                    //国籍代码
                    txtNOC.Text = "--";
                    //IRM状态 ： DNS,DNF,DSQ
                    btnX_IRMS.Text = "--";
                    //抓举或挺举总成绩
                    txtResult.Text = "--";
                    //各次试举成绩及结果状态
                    txt1th.Text = "";
                    txt2th.Text = "";
                    txt3th.Text = "";

                    //记录
                    labelXRecords.Text = "";
                    btnX_th_Click(new ButtonX(), new EventArgs());
                    SetLightStatus("111");
                    UpdateFinishedStatus("111");
                    SettingControls(false);
                    #endregion
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void btnX_th_Click(object sender, EventArgs e)
        {
            ButtonX btnTH = (ButtonX)sender;
            btnX_1th.ColorTable = eButtonColor.Blue;
            btnX_2th.ColorTable = eButtonColor.Blue;
            btnX_3th.ColorTable = eButtonColor.Blue;

            btnTH.ColorTable = eButtonColor.BlueWithBackground;
            if (btnTH.Tag != null)
            {
                m_nColumnIndexRes = int.Parse(btnTH.Tag.ToString());
                foreach (DataGridViewCell dgc in dgv_List.SelectedRows[0].Cells)
                {
                    dgc.Style.SelectionBackColor = Color.Empty;
                }
                dgv_List.SelectedRows[0].Cells[m_nColumnIndexRes - 1].Style.SelectionBackColor = Color.Green;
                dgv_List.SelectedRows[0].Cells[m_nColumnIndexRes].Style.SelectionBackColor = Color.Green;
            }
        }

        private void AutoSelectCurrentPlayer(DataGridView dgv)
        {
            bool hasCurrent = false;
            foreach (DataGridViewRow myRow in dgv.Rows)
            {
                DataGridViewCell dgvCell = myRow.Cells["Status"];
                if (dgvCell.Value != null)
                {
                    if (dgvCell.Value.ToString() != "")
                    {
                        int curValue = Convert.ToInt32(dgvCell.Value);
                        if (dgvCell.Value.ToString().Contains("1"))
                        {
                            //dgv.SelectedRows[0].Selected = false;
                            myRow.Selected = true;
                            hasCurrent = true;
                            break;
                        }
                    }
                }
            }
            //没有当前待举状态，按LightOrder找当前人
            if (!hasCurrent)
            {
                foreach (DataGridViewRow myRow in dgv.Rows)
                {
                    DataGridViewCell dgvCell = myRow.Cells["LightOrder"];
                    if (dgvCell.Value != null)
                    {
                        if (dgvCell.Value.ToString() != "")
                        {
                            int curValue = Convert.ToInt32(dgvCell.Value);
                            if (curValue == 1)
                            {
                                //dgv.SelectedRows[0].Selected = false;
                                myRow.Selected = true;
                                break;
                            }
                        }
                    }
                }
            }
            this.UpdateCurrentAthleteData(dgv.SelectedRows[0]);
        }

        private void btnX_Current_Click(object sender, EventArgs e)
        {
            this.AutoSelectCurrentPlayer(dgv_List);
        }

        #endregion

        #region 红/白灯处理
        private void SetLightStatus(string status)
        {
            char[] lightstatus = status.ToCharArray();
            if (lightstatus[0] == '1')
                LED1.BackColor = Color.White;
            else
                LED1.BackColor = Color.Red;
            if (lightstatus[1] == '1')
                LED2.BackColor = Color.White;
            else
                LED2.BackColor = Color.Red;
            if (lightstatus[2] == '1')
                LED3.BackColor = Color.White;
            else
                LED3.BackColor = Color.Red;
        }

        private string GetLightStatus()
        {
            string lightStatus = string.Empty;
            if (LED1.BackColor != Color.White)
                lightStatus += "0";
            else lightStatus += "1";
            if (LED2.BackColor != Color.White)
                lightStatus += "0";
            else lightStatus += "1";
            if (LED3.BackColor != Color.White)
                lightStatus += "0";
            else lightStatus += "1";
            if (lightStatus.Length < 3)
                lightStatus = "000";
            return lightStatus;
        }

        private void UpdateFinishedStatus(string finishedStatus)
        {
            switch (finishedStatus)
            {
                case "111":
                    this.btnX_ResultStatus.Text = "All White";
                    break;
                case "000":
                    this.btnX_ResultStatus.Text = "All Red";
                    break;
                default:
                    this.btnX_ResultStatus.Text = finishedStatus;
                    break;
            }
        }

        private void buttonItem_Click(object sender, EventArgs e)
        {
            ButtonItem btni = (ButtonItem)sender;
            string curStatus = btni.Tag.ToString();
            SetLightStatus(curStatus);
            UpdateFinishedStatus(curStatus);
        }

        private void LED_Click(object sender, EventArgs e)
        {
            ButtonX LED = (ButtonX)sender;
            Color nowColor = LED.BackColor;
            if (nowColor != Color.White)
                LED.BackColor = Color.White;
            else LED.BackColor = Color.Red;

            string currentLightStatus = GetLightStatus();
            UpdateFinishedStatus(currentLightStatus);
        }

        private void btnX_Finished_Click(object sender, EventArgs e)
        {
            string lightStatus = GetLightStatus();
            if (m_nMatchStatusID > 40 && m_nMatchStatusID < 110)
                toolStripMenuItem_Res_Comment(sender, e, lightStatus);
        }

        #endregion

        #region 处理TextBox函数
        private void ValidatingNumeric(object sender, int digit)
        {
            try
            {
                TextBox tb = (TextBox)sender;
                string temp = tb.Text;
                if (!StringFunctions.IsNumeric(temp))
                {
                    tb.Text = defaultInput;
                }
                else
                {
                    int dotIndex = temp.Trim().IndexOf('.');
                    int dotDigit = dotIndex == -1 ? digit : temp.Length - 1 - dotIndex;
                    if (dotDigit > digit || dotIndex == 0)
                        tb.Text = defaultInput;
                }
            }
            catch (Exception ex) { DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message); }
        }

        private void txtBodyWeight_TextChanged(object sender, EventArgs e)
        {
            //ValidatingNumeric(sender, 2);
        }
        private void txtBodyWeight_Leave(object sender, EventArgs e)
        {
            string bodyweight = this.txtBodyWeight.Text.Trim();
            DataGridViewRow dgr = (DataGridViewRow)gbCurAthlete.Tag;
            int rowIndex = dgv_List.Rows.IndexOf(dgr);
            double docbleWeight = 0;

            if (!string.IsNullOrEmpty(bodyweight))
            {
                docbleWeight = double.Parse(bodyweight);

                dgv_List.Rows[rowIndex].Cells["Weight"].Value = docbleWeight.ToString("F2");
                this.DataExchangeBodyWeight();
                this.DataExchangeMatchRank();
                this.DataExchangePhaseRank();
                this.DataExchangeEventRank();
            }
        }

        private void txt_Enter(object sender, EventArgs e)
        {
            TextBox tb = (TextBox)sender;
            defaultInput = tb.Text;
        }

        private void txtth_TextChanged(object sender, EventArgs e)
        {
            //ValidatingNumeric(sender, 1);
            //TextBox tb = (TextBox)sender;
            //tb.Text = defaultInput;
        }

        #endregion

        #region 自动增加重量
        private void btnXMin_Click(object sender, EventArgs e)
        {
            int currentAtt = Convert.ToInt32(lbX_AttemptWeight.Text);
            if (currentAtt > 1)
                currentAtt -= 1;
            lbX_AttemptWeight.Text = currentAtt.ToString();
        }

        private void btnXAdd_Click(object sender, EventArgs e)
        {
            int currentAtt = Convert.ToInt32(lbX_AttemptWeight.Text);
            currentAtt += 1;
            lbX_AttemptWeight.Text = currentAtt.ToString();
        }

        private void SetDefaultWeight()
        {
            if (dgv_List.Rows.Count > 0)
            {
                float FistWeight = 999;
                foreach (DataGridViewRow dr in dgv_List.Rows)
                {
                    if (dr.Cells["1stAttempt"].Value != null)
                    {
                        if (!dr.Cells["1stAttempt"].Value.Equals(""))
                        {
                            float tmpWeight = float.Parse(dr.Cells["1stAttempt"].Value.ToString());
                            if (tmpWeight < FistWeight)
                                FistWeight = tmpWeight;
                        }
                    }
                }

                string defaultWeight = lbX_AttemptWeight.Text;
                if (defaultWeight.Contains("."))
                    defaultWeight = defaultWeight.Substring(0, defaultWeight.LastIndexOf("."));
                int currentAtt = Convert.ToInt32(defaultWeight);
                if (FistWeight != currentAtt && FistWeight != 999 && FistWeight != 0)
                {
                    string firstWeight = FistWeight.ToString();
                    if (firstWeight.Contains("."))
                        firstWeight = firstWeight.Substring(0, firstWeight.LastIndexOf("."));
                    lbX_AttemptWeight.Text = firstWeight.ToString();
                }
            }
        }

        private void btnXSetAttempt_Click(object sender, EventArgs e)
        {
            if (dgv_List.SelectedRows.Count > 0)
            {
                DataGridViewRow dgvRow = dgv_List.SelectedRows[0];

                //试举次数
                int attemptTimes = m_nColumnIndexRes;
                dgvRow.Cells[m_nColumnIndexRes - 1].Value = lbX_AttemptWeight.Text;

                this.DataExchangeLightOrder();
                this.DataExchangeStatus(false, true);
                this.DataExchangeAttempt(dgvRow.Index);
                this.DataExchangeResult(dgvRow.Index);
                this.DataExchangeDeleteInvalidRecords(dgvRow.Index);
                this.DataExchangeMatchRank();
                this.DataExchangePhaseRank();
                this.DataExchangeEventRank();
                this.UpdateListDataGridViewStyle();

                //this.DataExchangeRecord(dgvRow.Index);
                //更新试举次数
                dgvRow.Cells["AttemptTime"].Value = GetAttemptIndex(dgvRow);
                UpdateCurrentAthleteData(dgvRow);
                if (m_nMatchStatusID > 40)
                {
                    GVWL.g_WLPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                }
            }
        }

        private void cbAuto_CheckedChanged(object sender, EventArgs e)
        {
            if (cbAuto.Checked)
                bAutoAttempt = true;
            else bAutoAttempt = false;
        }

        #endregion

        #region 计时记分接口

        private void UpdateRecData(DataTable ts_dt)
        {
            if (m_nMatchStatusID < 50)
            {
                m_nMatchStatusID = 50;
                bool bReturn = GVWL.g_ManageDB.UpdateMatchStatus(m_nCurMatchID, m_nMatchStatusID);
                if (bReturn)
                    this.Invoke(new UpdateDataEventHandler(UpdateMatchStatus), new object[] { });
            }
            this.UpdateListTimingScoringData(ts_dt);
            //this.UpdateTotalTimingScoringData(ts_dt);
            this.DataExchangeLightOrder();
            this.DataExchangeStatusForInterface();
            this.DataExchangeBodyWeight();
            this.Invoke(new UpdateDataEventHandler(DataExchangeMatchRank), new object[] { });
            this.Invoke(new UpdateDataEventHandler(DataExchangePhaseRank), new object[] { });
            this.Invoke(new UpdateDataEventHandler(DataExchangeEventRank), new object[] { });
            this.Invoke(new UpdateDataEventHandler(UpdateListDataGridViewStyle), new object[] { });
            this.Invoke(new UpdateDataViewEventHandler(AutoSelectCurrentPlayer), new object[] { dgv_List });

            //比赛成绩有变化，需要发送消息通知
            if (m_nMatchStatusID > 40)
            {
                GVWL.g_WLPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }
        }

        private void UpdateListTimingScoringData(DataTable dt)
        {
            m_bImporting = true;
            try
            {
                //更新界面数据
                if (dgv_List.Rows.Count > 0)
                {
                    for (int rowIdx = 0; rowIdx < dgv_List.Rows.Count; rowIdx++)
                    {
                        DataGridViewRow dvr = dgv_List.Rows[rowIdx];
                        //获取界面数据
                        ObjectEx objEx = null;
                        GetDataGridViewData(this.dgv_List, dvr.Index, out objEx);

                        if (objEx.m_nLotNo != 0)
                        {
                            string strComPos = objEx.m_strComPos;
                            string strRank = objEx.m_strRank;
                            string strResult = objEx.m_strResult;
                            string strRegisterID = objEx.m_strRegisterID;

                            DataRow curRow = DTHelpFunctions.GetDataRowByFieldAndLotNo(dt, objEx.m_nLotNo.ToString());
                            if (curRow != null)
                            {
                                dgv_List.Rows[dvr.Index].Cells["Weight"].Value = DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "BodyWeight");
                                string satt1 = DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "Snatch1stAttempt");
                                string cjatt1 = DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "CJerk1stAttempt");
                                GVWL.g_ManageDB.UpdatePlayerBodyWeight(m_nCurMatchID, int.Parse(strRegisterID), "-1", (satt1 != "0" ? satt1 : ""), (cjatt1 != "0" ? cjatt1 : ""));
                                #region Snatch
                                if (m_strMatchCode == "01")
                                {
                                    string attempt = DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "Snatch1stAttempt");
                                    dgv_List.Rows[dvr.Index].Cells["1stAttempt"].Value = attempt != "0" ? attempt : "";
                                    dgv_List.Rows[dvr.Index].Cells["1stRes"].Value = GetLightStatus(DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "Snatch1stRes"));
                                    attempt = DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "Snatch2ndAttempt");
                                    dgv_List.Rows[dvr.Index].Cells["2ndAttempt"].Value = attempt != "0" ? attempt : "";
                                    dgv_List.Rows[dvr.Index].Cells["2ndRes"].Value = GetLightStatus(DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "Snatch2ndRes"));
                                    attempt = DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "Snatch3rdAttempt");
                                    dgv_List.Rows[dvr.Index].Cells["3rdAttempt"].Value = attempt != "0" ? attempt : "";
                                    dgv_List.Rows[dvr.Index].Cells["3rdRes"].Value = GetLightStatus(DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "Snatch3rdRes"));

                                    strRank = DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "SnatchRank");
                                    strResult = DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "SnatchResult");

                                    dgv_List.Rows[dvr.Index].Cells["IRM"].Value =
                                        GetIRMStatus(DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "Snatch1stRes"),
                                        DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "Snatch2ndRes")
                                        , DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "Snatch3rdRes"));
                                }
                                #endregion
                                #region Clean&Jerk
                                else if (m_strMatchCode == "02")
                                {
                                    string attempt = DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "CJerk1stAttempt");
                                    dgv_List.Rows[dvr.Index].Cells["1stAttempt"].Value = attempt != "0" ? attempt : "";
                                    dgv_List.Rows[dvr.Index].Cells["1stRes"].Value = GetLightStatus(DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "CJerk1stRes"));
                                    attempt = DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "CJerk2ndAttempt");
                                    dgv_List.Rows[dvr.Index].Cells["2ndAttempt"].Value = attempt != "0" ? attempt : "";
                                    dgv_List.Rows[dvr.Index].Cells["2ndRes"].Value = GetLightStatus(DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "CJerk2ndRes"));
                                    attempt = DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "CJerk3rdAttempt");
                                    dgv_List.Rows[dvr.Index].Cells["3rdAttempt"].Value = attempt != "0" ? attempt : "";
                                    dgv_List.Rows[dvr.Index].Cells["3rdRes"].Value = GetLightStatus(DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "CJerk3rdRes"));

                                    strRank = DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "CJerkRank");
                                    strResult = DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "CJerkResult");

                                    dgv_List.Rows[dvr.Index].Cells["IRM"].Value =
                                        GetIRMStatus(DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "CJerk1stRes"),
                                        DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "CJerk2ndRes")
                                        , DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "CJerk3rdRes"));
                                }
                                #endregion
                                dgv_List.Rows[dvr.Index].Cells["Result"].Value = strResult == "0" ? "" : strResult;
                                //Setting attempt status
                                string interStatus = DTHelpFunctions.GetStringByDataRowAndFieldName(curRow, "Status");
                                if (interStatus == "1" || interStatus == "2")
                                {
                                    foreach (DataGridViewRow dr in dgv_List.Rows)
                                    {
                                        if (dr.Index != dvr.Index)
                                            dr.Cells["Status"].Value = 3;
                                        else
                                            dr.Cells["Status"].Value = "0";
                                    }
                                }
                                //更新试举次数
                                dgv_List.Rows[dvr.Index].Cells["AttemptTime"].Value = GetAttemptIndex(dvr);
                            }
                            this.DataExchangeAttempt(dvr.Index);
                            this.DataExchangeResult(dvr.Index);
                            this.DataExchangeTimingScoring(dvr.Index);
                            this.DataExchangeDeleteInvalidRecords(dvr.Index);
                            this.DataExchangeRecord(dvr.Index);
                        }
                    }
                }
            }
            catch (System.Exception ex)
            {
                //DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
            finally
            {
                m_bImporting = false;
            }
        }

        private string GetLightStatus(string GN)
        {
            if (GN == "0")
                return null;
            else if (GN == "1")
                return "111";
            else if (GN == "2")
                return "000";
            else if (GN == "3")
                return "222";
            return "";
        }
        private string GetIRMStatus(string GN1, string GN2, string GN3)
        {
            if ((GN1 != "1" && GN1 != "") && (GN2 != "1" && GN2 != "") && (GN3 != "1" && GN3 != ""))
                return "DNF";
            else if (GN1 == "3" && GN2 == "3" && GN3 == "3" && m_strMatchCode == "01")
                return "DNS";
            else if (GN1 == "3" && GN2 == "3" && GN3 == "3" && m_strMatchCode == "02")
                return "DNF";
            return "";
        }
        private void cbTimeScoring_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                if (cbTimeScoring.Checked)
                {
                    WLUdpService.Start();
                    SettingControls(false);
                    this.dgv_List.ReadOnly = true;
                    this.cbTSMix.Enabled = false;
                    WLUdpService.ReceivedData = new ReceiveDataEventHandler(UpdateRecData);
                }
                else
                {
                    WLUdpService.Stop();
                    SettingControls(true);
                    this.dgv_List.ReadOnly = false;
                    this.cbTSMix.Enabled = true;
                    WLUdpService.ReceivedData -= new ReceiveDataEventHandler(UpdateRecData);
                }
            }
            catch
            {
                return;
            }
        }


        private void UpdateRecDataToDB()
        {
            this.Invoke(new UpdateDataEventHandler(UpdateListDataGridView), new object[] { });
            this.Invoke(new UpdateDataEventHandler(UpdateListDataGridViewStyle), new object[] { });
            this.Invoke(new UpdateDataEventHandler(UpdateTotalDataGridView), new object[] { });
            this.Invoke(new UpdateDataViewEventHandler(AutoSelectCurrentPlayer), new object[] { dgv_List });

            //比赛成绩有变化，需要发送消息通知
            if (m_nMatchStatusID > 40)
            {
                GVWL.g_WLPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }
        }
        private void cbTSMix_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                if (cbTSMix.Checked)
                {
                    WLUdpService.toDB = true;
                    WLUdpService.Start();
                    SettingControls(false);
                    this.dgv_List.ReadOnly = true;
                    this.cbTimeScoring.Enabled = false;
                    WLUdpService.ToDBReceivedData = new ToDBReceiveDataEventHandler(UpdateRecDataToDB);
                }
                else
                {
                    WLUdpService.toDB = false;
                    WLUdpService.Stop();
                    SettingControls(true);
                    this.dgv_List.ReadOnly = false;
                    this.cbTimeScoring.Enabled = true;
                    WLUdpService.ToDBReceivedData -= new ToDBReceiveDataEventHandler(UpdateRecDataToDB);
                }
            }
            catch
            {
                return;
            }

        }

        #endregion


    }
}


