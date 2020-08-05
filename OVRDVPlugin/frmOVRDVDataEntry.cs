using System;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text.RegularExpressions;
using System.Windows.Forms;
using AutoSports.OVRCommon;
using OVRDVPlugin.TSInterface;

namespace OVRDVPlugin
{
    public partial class frmOVRDVDataEntry : DevComponents.DotNetBar.Office2007Form
    {
        private Int32 m_iCurRunningMatchSplitID;
        private Int32 m_iCurShowMatchSplitID;
        private Int32 m_iCurMatchID;
        private Int32 m_iSportID;
        private Int32 m_iDisciplineID;
        private String m_strLanguageCode = "ENG";
        private String m_strEventName = "";
        private String m_strMatchName = "";
        private String m_strDateDes = "";
        private String m_strVenueDes = "";
        private Boolean m_bIsRunning = false;

        private Int32 m_iCurStatusID;
        private Int32 m_iCurMatchRuleID;
        private Int32 m_iMatchRoundCount;
        private Int32[] m_arraySplitStatus;
        private String m_CurEditingCellPointFormate;

        private DVTSInterface m_dvTSInterface;

        private frmDBInterface m_DBInterfaceFrm = null;

        private System.Data.DataTable m_dataTableColumns = new DataTable("SplitResultColumns");

        public frmOVRDVDataEntry()
        {
            InitializeComponent();

            SetdgvMatchSplitResultStyle();
            SetDgvMatchResultStyle();

            m_dvTSInterface = new DVTSInterface();
            m_dvTSInterface.Owner = this;
            m_dvTSInterface.ConnectionChanged += new Action<bool>(m_dvTSInterface_ConnectionChanged);
            m_dvTSInterface.OnTSUpdateDB += UpdateUITriggeredByTS;
        }

        private void m_dvTSInterface_ConnectionChanged(bool bConnected)
        {
            if (bConnected)
            {
                btnTsInterface.BackColor = Color.FromArgb(0, 255, 0);
            }
            else
            {
                btnTsInterface.BackColor = Color.FromArgb(194, 217, 247);
            }
        }

        private void SetdgvMatchSplitResultStyle()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchSplitResult);
            dgvMatchSplitResult.SelectionMode = DataGridViewSelectionMode.CellSelect;

            FontFamily fontFamily = new FontFamily("Arial");
            FontStyle fontStyle = new FontStyle();
            Font gridFont = new Font(fontFamily, 13, fontStyle);
            dgvMatchSplitResult.Font = gridFont;

        }

        private void SetDgvMatchResultStyle()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchResult);
            FontFamily fontFamily = new FontFamily("Arial");
            FontStyle fontStyle = new FontStyle();
            Font gridFont = new Font(fontFamily, 13, fontStyle);
            dgvMatchResult.Font = gridFont;
        }

        public void OnMsgFlushSelMatch(Int32 iWndMode, Int32 iMatchID)
        {
            // Is Running 
            if (m_bIsRunning)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(DVCommon.g_strSectionName, "mbRunningMatch"), DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            // Not valid MatchID
            if (iMatchID <= 0)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(DVCommon.g_strSectionName, "mbChooseMatch"), DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            m_bIsRunning = true;
            InitBtnEnableByMatchRunningStatus();

            m_iCurMatchID = iMatchID;
            m_iCurShowMatchSplitID = 0;
            m_iCurRunningMatchSplitID = 0;

            Int32 iDisciplineID;
            // Intial Basic Info
            OVRDataBaseUtils.GetActiveInfo(DVCommon.g_DataBaseCon, out m_iSportID, out iDisciplineID, out m_strLanguageCode);
            DVCommon.g_DVDBManager.GetActiveSportInfo();

            InitMatchInfo();
            InitialRoundBtns();

            ShowMatchStatus();
            ShowMatchSplitStatus();

            IntiMatchResult();
            InitMatchSplitResult();

            m_dvTSInterface.SetMatchID(m_iCurMatchID);
            return;
        }

        public void QueryReportContext(OVRReportContextQueryArgs args)
        {
            if (args == null) return;

            switch (args.Name)
            {
                case "MatchID":
                    {
                        args.Value = m_iCurMatchID.ToString();
                        args.Handled = true;
                    }
                    break;
                default:
                    break;
            }
        }


        private void InitMatchInfo()
        {
            DVCommon.g_DVDBManager.GetMatchInfo(m_iCurMatchID, ref m_strEventName, ref m_strMatchName, ref m_strDateDes, ref m_strVenueDes, ref m_iDisciplineID, ref m_iCurStatusID, ref m_iCurMatchRuleID);
            DVCommon.g_DVDBManager.GetMatchCompetitionRuleInfo(m_iCurMatchID, ref m_iMatchRoundCount);
            DVCommon.g_DVDBManager.GetMatchSplitStatus(m_iCurMatchID, m_iMatchRoundCount, ref m_arraySplitStatus);
            lb_EventDes.Text = m_strEventName;
            lb_MatchDes.Text = m_strMatchName;
            lb_DateDes.Text = m_strDateDes;

        }

        private void InitMatchSplitResult()
        {
            DataGridView thisdgv = dgvMatchSplitResult;

            Int32 iSelRowIndex;
            Int32 iSelColIndex;

            if (thisdgv.SelectedCells.Count > 0)
            {
                iSelRowIndex = thisdgv.SelectedCells[0].RowIndex;
                iSelColIndex = thisdgv.SelectedCells[0].ColumnIndex;
                if (iSelRowIndex < 0) iSelRowIndex = 0;
                if (iSelColIndex < 0) iSelColIndex = 0;
            }
            else
            {
                iSelRowIndex = 0;
                iSelColIndex = 0;
            }

            thisdgv.DataSource = null;

            DVCommon.g_DVDBManager.InitMatchSplitResultList(m_iCurMatchID, m_iCurShowMatchSplitID, ref this.dgvMatchSplitResult);

            m_dataTableColumns.Clear();
            DVCommon.g_DVDBManager.ExcuteDV_GetMatchSplitResult_Columns(m_iCurMatchID, m_iCurShowMatchSplitID, m_strLanguageCode, ref m_dataTableColumns);
            dgvMatchSplitResultCustomizing(ref m_dataTableColumns);


            DataTable dataTablePointsStatus = new DataTable("PointsStauts");
            dataTablePointsStatus.Clear();
            DVCommon.g_DVDBManager.ExcuteDV_GetMatchSplitResultStatus(m_iCurMatchID, m_iCurShowMatchSplitID, m_strLanguageCode, ref dataTablePointsStatus);

            dgvAutoSizeColumns(ref this.dgvMatchSplitResult);



            dgvMatchSplitResultUpdatePointsStatus(ref dataTablePointsStatus);

            DataTable dataTableCurrentStatus = new DataTable("CurrentStauts");
            dataTableCurrentStatus.Clear();

            DVCommon.g_DVDBManager.ExcuteDV_GetMatchSplitCurrentStatus(m_iCurMatchID, m_iCurShowMatchSplitID, ref dataTableCurrentStatus);

            dgvMatchSplitResultUpdateCurrentDiverStatus(ref dataTableCurrentStatus);


            try
            {
                if ((iSelRowIndex < thisdgv.Rows.Count) && (iSelColIndex < thisdgv.Columns.Count))
                {
                    thisdgv.Rows[iSelRowIndex].Cells[iSelColIndex].Selected = true;
                }
            }
            catch (Exception ex)
            {
                //DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }


        }

        private void dgvMatchSplitResultCustomizing(ref DataTable dataTableColumns)
        {
            DataGridView dgvCustom = dgvMatchSplitResult;
            Int32 iRowCount = dgvCustom.RowCount;
            Int32 iColumnCount = dgvCustom.ColumnCount;
            for (Int32 i = 0; i < iColumnCount; i++)
            {
                String strColumnName = dgvCustom.Columns[i].Name;

                string strExpression = String.Format("F_MatchSplitCode = '{0}'", strColumnName);
                DataRow[] drSelRows = dataTableColumns.Select(strExpression);

                if (drSelRows.Length > 0)
                {
                    Int32 iVisible = Convert.ToInt32(drSelRows[0]["F_Visable"].ToString());
                    dgvCustom.Columns[i].Visible = Convert.ToBoolean(iVisible);

                    Int32 iEditable = Convert.ToInt32(drSelRows[0]["F_Editable"].ToString());
                    dgvCustom.Columns[i].ReadOnly = !Convert.ToBoolean(iEditable);

                    string strHeaderText = drSelRows[0]["F_ColumnHeadText"].ToString();
                    dgvCustom.Columns[i].HeaderText = strHeaderText;


                    System.Drawing.SizeF sf = dgvCustom.CreateGraphics().MeasureString(strHeaderText, dgvCustom.Font);
                    dgvCustom.Columns[i].Width = System.Convert.ToInt32(sf.Width + 25f);

                }

                dgvCustom.Columns[i].SortMode = DataGridViewColumnSortMode.NotSortable;
            }
        }

        private void dgvMatchSplitResultUpdateCurrentDiverStatus(ref DataTable dataTableCurrentStatus)
        {
            DataGridView dgvCustom = dgvMatchSplitResult;
            Int32 iRowCount = dgvCustom.RowCount;

            for (Int32 iRowCursor = 0; iRowCursor < iRowCount; iRowCursor++)
            {
                Int32 iPosition = GetFieldValue(dgvMatchSplitResult, iRowCursor, "F_CompetitionPosition");
                string strExpression = String.Format("F_CompetitionPosition = {0}", iPosition);
                DataRow[] drSelRowsCurrentStatus = dataTableCurrentStatus.Select(strExpression);

                if (drSelRowsCurrentStatus.Length > 0)
                {
                    Int32 iPointsStatusID = Convert.ToInt32(drSelRowsCurrentStatus[0]["F_CurrentStatus"].ToString());

                    switch (iPointsStatusID)
                    {
                        case 1:
                            {
                                dgvCustom.Rows[iRowCursor].Cells[0].Style.BackColor = System.Drawing.Color.Red;
                                dgvCustom.Rows[iRowCursor].Cells[1].Style.BackColor = System.Drawing.Color.Red;
                                dgvCustom.Rows[iRowCursor].Cells[2].Style.BackColor = System.Drawing.Color.Red;
                                break;
                            }
                        case 2:
                            {
                                dgvCustom.Rows[iRowCursor].Cells[0].Style.BackColor = System.Drawing.Color.LightGreen;
                                dgvCustom.Rows[iRowCursor].Cells[1].Style.BackColor = System.Drawing.Color.LightGreen;
                                dgvCustom.Rows[iRowCursor].Cells[2].Style.BackColor = System.Drawing.Color.LightGreen;
                                break;
                            }
                        case 3:
                            {
                                dgvCustom.Rows[iRowCursor].Cells[0].Style.BackColor = System.Drawing.Color.Yellow;
                                dgvCustom.Rows[iRowCursor].Cells[1].Style.BackColor = System.Drawing.Color.Yellow;
                                dgvCustom.Rows[iRowCursor].Cells[2].Style.BackColor = System.Drawing.Color.Yellow;
                                break;
                            }
                        default:
                            break;
                    }
                }
            }
        }

        private void dgvMatchSplitResultUpdatePointsStatus(ref DataTable dataTablePointsStatus)
        {
            DataGridView dgvCustom = dgvMatchSplitResult;
            Int32 iRowCount = dgvCustom.RowCount;
            Int32 iColumnCount = dgvCustom.ColumnCount;
            for (Int32 iRowCursor = 0; iRowCursor < iRowCount; iRowCursor++)
            {
                Int32 iPosition = GetFieldValue(dgvMatchSplitResult, iRowCursor, "F_CompetitionPosition");

                string strExpression = String.Format("F_CompetitionPosition = {0}", iPosition);
                DataRow[] drSelRowsPointsStatus = dataTablePointsStatus.Select(strExpression);

                if (drSelRowsPointsStatus.Length > 0)
                {

                    strExpression = "F_MatchSplitType = 31";
                    DataRow[] drSelRowsColumns = m_dataTableColumns.Select(strExpression);

                    if (drSelRowsColumns.Length > 0)
                    {
                        for (Int32 iColCursor = 0; iColCursor < drSelRowsColumns.Length; iColCursor++)
                        {
                            String strColumnName = drSelRowsColumns[iColCursor]["F_MatchSplitCode"].ToString();
                            Int32 iPointsStatusID = Convert.ToInt32(drSelRowsPointsStatus[0][strColumnName].ToString());

                            //0表示是裁判还没有打分的成绩(NULL转化为0),
                            //1表示是有效的成绩,
                            //2表示是最高剔除的成绩,
                            //3表示是最低剔除的成绩,
                            //4表示是没有裁判打分

                            if (iPointsStatusID == 2)
                            {
                                dgvMatchSplitResult.Rows[iRowCursor].Cells[strColumnName].Style.ForeColor = System.Drawing.Color.Red;
                            }
                            else if (iPointsStatusID == 3)
                            {
                                dgvMatchSplitResult.Rows[iRowCursor].Cells[strColumnName].Style.ForeColor = System.Drawing.Color.Green;
                            }
                            else
                            {
                                dgvMatchSplitResult.Rows[iRowCursor].Cells[strColumnName].Style.ForeColor = System.Drawing.Color.Black;
                            }
                        }
                    }
                }

            }
        }


        private void IntiMatchResult()
        {
            DataGridView thisdgv = dgvMatchResult;

            Int32 iSelRowIndex;
            Int32 iSelColIndex;

            if (thisdgv.SelectedCells.Count > 0)
            {
                iSelRowIndex = thisdgv.SelectedCells[0].RowIndex;
                iSelColIndex = thisdgv.SelectedCells[0].ColumnIndex;
                if (iSelRowIndex < 0) iSelRowIndex = 0;
                if (iSelColIndex < 0) iSelColIndex = 0;
            }
            else
            {
                iSelRowIndex = 0;
                iSelColIndex = 0;
            }

            DVCommon.g_DVDBManager.InitMatchResultList(m_iCurMatchID, ref thisdgv);

            if ((iSelRowIndex < thisdgv.Rows.Count) && (iSelColIndex < thisdgv.Columns.Count))
            {
                thisdgv.Rows[iSelRowIndex].Cells[iSelColIndex].Selected = true;
            }

            dgvMatchResultCustomizing();
            dgvAutoSizeColumns(ref this.dgvMatchResult);
        }
        private void dgvAutoSizeColumns(ref DataGridView dgvCustom)
        {
            dgvCustom.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;
        }

        private void dgvMatchResultCustomizing()
        {
            DataGridView dgvCustom = dgvMatchResult;
            Int32 iRowCount = dgvCustom.RowCount;
            Int32 iColumnCount = dgvCustom.ColumnCount;
            for (Int32 i = 0; i < iColumnCount; i++)
            {
                String strColumnName = dgvCustom.Columns[i].Name;
                if (strColumnName.CompareTo("F_RegisterID") == 0 || strColumnName.CompareTo("F_MatchID") == 0
                    || strColumnName.CompareTo("F_CompetitionPosition") == 0 || strColumnName.CompareTo("F_DisplayPosition") == 0)
                {
                    dgvCustom.Columns[i].Visible = false;
                }

                dgvCustom.Columns[i].SortMode = DataGridViewColumnSortMode.NotSortable;
            }

            if (dgvCustom.Columns["Rank"] != null)
            {
                dgvCustom.Columns["Rank"].ReadOnly = false;
            }

            if (dgvCustom.Columns["Points"] != null)
            {
                dgvCustom.Columns["Points"].ReadOnly = false;
            }
        }


        private void InitialRoundBtns()
        {
            this.panelRoundBtn.Controls.Clear();
            Int32 iRoundNum = m_iMatchRoundCount;
            Int32 iBtnWidth = 101;
            Int32 iBtnHeight = 25;
            Int32 iBtnGap = 0;
            this.panelRoundBtn.Controls.Clear();
            this.panelRoundStatusBtn.Controls.Clear();
            for (Int32 i = 0; i < iRoundNum; i++)
            {
                DevComponents.DotNetBar.ButtonX btnRound = new DevComponents.DotNetBar.ButtonX();
                btnRound.Visible = true;
                btnRound.Name = String.Format("btnRound{0}", (i + 1));
                btnRound.Text = String.Format("Round {0}", (i + 1));
                btnRound.Location = new Point(i * iBtnWidth, 0);
                btnRound.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
                btnRound.Size = new Size(iBtnWidth, iBtnHeight);
                btnRound.Click += new EventHandler(btnRoundClick);
                btnRound.Tag = i + 1;

                this.panelRoundBtn.Controls.Add(btnRound);

                DevComponents.DotNetBar.ButtonX btnRoundStatus = new DevComponents.DotNetBar.ButtonX();
                btnRoundStatus.Visible = true;
                btnRoundStatus.Name = String.Format("btnRoundStatus{0}", (i + 1));
                btnRoundStatus.Location = new Point(i * iBtnWidth, 0);
                btnRoundStatus.Size = new Size(iBtnWidth, iBtnHeight);
                btnRoundStatus.Tag = i + 1;

                DevComponents.DotNetBar.ButtonItem btnx_StartList = new DevComponents.DotNetBar.ButtonItem();
                DevComponents.DotNetBar.ButtonItem btnx_Running = new DevComponents.DotNetBar.ButtonItem();
                DevComponents.DotNetBar.ButtonItem btnx_Finished = new DevComponents.DotNetBar.ButtonItem();

                btnx_StartList.Name = String.Format("btnx_StartList{0}", (i + 1));
                btnx_StartList.Text = "StartList";
                btnx_StartList.Tag = i + 1;
                btnx_StartList.Click += new System.EventHandler(this.btnx_Split_StartList_Click);

                btnx_Running.Name = String.Format("btnx_Running{0}", (i + 1));
                btnx_Running.Text = "Running";
                btnx_Running.Tag = i + 1;
                btnx_Running.Click += new System.EventHandler(this.btnx_Split_Running_Click);

                btnx_Finished.Name = String.Format("btnx_Finished{0}", (i + 1));
                btnx_Finished.Text = "Offical";
                btnx_Finished.Tag = i + 1;
                btnx_Finished.Click += new System.EventHandler(this.btnx_Split_Finished_Click);


                btnRoundStatus.AccessibleRole = System.Windows.Forms.AccessibleRole.PushButton;
                btnRoundStatus.ColorTable = DevComponents.DotNetBar.eButtonColor.OrangeWithBackground;

                btnRoundStatus.SubItems.AddRange(new DevComponents.DotNetBar.BaseItem[] {
                        btnx_StartList,
                        btnx_Running,
                        btnx_Finished});

                this.panelRoundStatusBtn.Controls.Add(btnRoundStatus);
            }


            DevComponents.DotNetBar.ButtonX btnSetCurRound = new DevComponents.DotNetBar.ButtonX();
            btnSetCurRound.Visible = true;
            btnSetCurRound.Name = "btnSetCurRound";
            btnSetCurRound.Text = "Set Current Round";
            btnSetCurRound.Location = new Point(iRoundNum * iBtnWidth, 0);
            btnSetCurRound.Font = new System.Drawing.Font("SimSun", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            btnSetCurRound.Size = new Size(136, iBtnHeight);
            btnSetCurRound.Tag = 100;
            btnSetCurRound.Click += new EventHandler(btnx_SetCurRound_Click);


            this.panelRoundBtn.Controls.Add(btnSetCurRound);
        }

        private void btnRoundClick(object sender, EventArgs e)
        {
            DevComponents.DotNetBar.ButtonX btn = (DevComponents.DotNetBar.ButtonX)sender;

            m_iCurShowMatchSplitID = (Int32)btn.Tag;

            InitMatchSplitResult();

            UpdateRoundBtnsStatus();
        }

        private void UpdateRoundBtnsStatus()
        {
            foreach (Control ctl in panelRoundBtn.Controls)
            {
                if (ctl.GetType().ToString() == "DevComponents.DotNetBar.ButtonX")
                {
                    DevComponents.DotNetBar.ButtonX btn = (DevComponents.DotNetBar.ButtonX)ctl;
                    if ((Int32)btn.Tag == m_iCurShowMatchSplitID)
                    {
                        btn.ForeColor = System.Drawing.Color.Red;
                    }
                    else if ((Int32)btn.Tag != 100)
                    {
                        btn.ForeColor = System.Drawing.Color.Gray;
                    }

                    if ((Int32)btn.Tag == m_iCurRunningMatchSplitID)
                    {
                        btn.ForeColor = System.Drawing.Color.Blue;
                    }

                }
            }
        }

        private void btnx_SetCurRound_Click(object sender, EventArgs e)
        {
            m_iCurRunningMatchSplitID = m_iCurShowMatchSplitID;
            UpdateRoundBtnsStatus();
        }

        private void cleanMatchInfo()
        {
            m_strEventName = "";
            m_strMatchName = "";
            m_strVenueDes = "";
            m_strDateDes = "";
            lb_EventDes.Text = null;
            lb_MatchDes.Text = null;
            lb_DateDes.Text = null;

            m_iMatchRoundCount = 0;
            this.panelRoundBtn.Controls.Clear();
            this.panelRoundStatusBtn.Controls.Clear();
        }

        private void cleanMatchSplitResultList()
        {
            this.dgvMatchSplitResult.Rows.Clear();
        }

        private void cleanMatchResultList()
        {
            this.dgvMatchResult.Rows.Clear();
        }

        private void InitBtnEnableByMatchRunningStatus()
        {
            btnx_Exit.Enabled = m_bIsRunning;
            btnx_Judges.Enabled = m_bIsRunning;
            btnx_Config.Enabled = m_bIsRunning;
            btnx_Status.Enabled = m_bIsRunning;
            btnx_DiveList.Enabled = m_bIsRunning;
        }

        private void btnx_Exit_Click(object sender, EventArgs e)
        {
            if (!m_bIsRunning) return;

            if (DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(DVCommon.g_strSectionName, "mbExitMatch"), DVCommon.g_strSectionName, MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                m_iCurMatchID = -1;

                m_bIsRunning = false;
                cleanMatchInfo();
                cleanMatchSplitResultList();
                cleanMatchResultList();
                InitBtnEnableByMatchRunningStatus();

                m_dvTSInterface.SetMatchID(m_iCurMatchID);
            }
        }

        private void btnx_Judges_Click(object sender, EventArgs e)
        {
            frmMatchJudge frm = new frmMatchJudge(m_iCurMatchID);
            frm.ShowDialog();

        }

        private void btnx_DiveList_Click(object sender, EventArgs e)
        {

            DiveListForm frmDiveList = new DiveListForm();

            frmDiveList.m_iCurMatchID = m_iCurMatchID;
            frmDiveList.m_iSportID = m_iSportID;
            frmDiveList.m_iDisciplineID = m_iDisciplineID;
            frmDiveList.m_strLanguageCode = "ENG";

            frmDiveList.ShowDialog();

            IntiMatchResult();
            InitMatchSplitResult();
        }

        private void btnx_Config_Click(object sender, EventArgs e)
        {
            frmMatchCompetitionRule FrmMatchCompetitionRule = new frmMatchCompetitionRule();
            FrmMatchCompetitionRule.m_iCurMatchID = m_iCurMatchID;
            FrmMatchCompetitionRule.m_iDisciplineID = m_iDisciplineID;
            FrmMatchCompetitionRule.m_iSportID = m_iSportID;
            FrmMatchCompetitionRule.m_strLanguageCode = m_strLanguageCode;

            FrmMatchCompetitionRule.ShowDialog();

            InitMatchInfo();
            InitialRoundBtns();
            IntiMatchResult();
            InitMatchSplitResult();
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


        protected override bool ProcessCmdKey(ref Message msg, Keys keyData)
        {
            if (keyData == Keys.Enter)    //监听回车事件            
            {

                if (this.dgvMatchSplitResult.IsCurrentCellInEditMode)   //如果当前单元格处于编辑模式 
                {
                    if (dgvMatchSplitResult.CurrentCell.RowIndex == dgvMatchSplitResult.Rows.Count - 1)
                    {
                        if (dgvMatchSplitResult.CurrentCell.ColumnIndex != dgvMatchSplitResult.Columns.Count - 1)
                        {
                            SendKeys.Send("{Tab}");
                        }
                    }
                    else
                    {
                        SendKeys.Send("{Up}");
                        if (dgvMatchSplitResult.CurrentCell.ColumnIndex != dgvMatchSplitResult.Columns.Count - 1)
                        {
                            SendKeys.Send("{Tab}");
                        }
                    }
                }
                else if (this.dgvMatchResult.IsCurrentCellInEditMode)   //如果当前单元格处于编辑模式 
                {
                    if (dgvMatchResult.CurrentCell.RowIndex == dgvMatchResult.Rows.Count - 1)
                    {
                        if (dgvMatchResult.CurrentCell.ColumnIndex != dgvMatchResult.Columns.Count - 1)
                        {
                            SendKeys.Send("{Tab}");
                        }
                    }
                    else
                    {
                        SendKeys.Send("{Up}");
                        if (dgvMatchResult.CurrentCell.ColumnIndex != dgvMatchResult.Columns.Count - 1)
                        {
                            SendKeys.Send("{Tab}");
                        }
                    }
                }
                else
                {
                    if (this.dgvMatchSplitResult.Focused)
                    {
                        dgvMatchSplitResult.BeginEdit(false);
                        return true;
                    }
                    else if (this.dgvMatchResult.Focused)
                    {
                        dgvMatchResult.BeginEdit(false);
                        return true;
                    }
                }
            }
            //继续原来base.ProcessCmdKey中的处理  
            return base.ProcessCmdKey(ref msg, keyData);
        }


        private void dgvMatchSplitResult_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;

            String strColumnName = dgvMatchSplitResult.Columns[iColumnIndex].Name;

            DataGridViewCell CurCell = dgvMatchSplitResult.Rows[iRowIndex].Cells[iColumnIndex];
            if (CurCell != null)
            {

                Int32 iMatchID = GetFieldValue(dgvMatchSplitResult, iRowIndex, "F_MatchID");
                Int32 iPosition = GetFieldValue(dgvMatchSplitResult, iRowIndex, "F_CompetitionPosition");
                Int32 iMatchSplitID = m_iCurShowMatchSplitID;
                Int32 iRegisterID = GetFieldValue(dgvMatchSplitResult, iRowIndex, "F_RegisterID");

                String strJudgeGroupCode = "";
                String strJudgeCode = "";
                String strPointCode = "";
                String strPointTypeCode = "";
                String strPoint = "";
                Int32 iInputValue = 0;
                Int32 iPointsStatusID = 1;
                Int32 iIsAutoCalcuate = 1;
                String strPointFormate = "";
                Int32 iMatchSplitType = 0;


                string strExpression = String.Format("F_MatchSplitCode = '{0}'", strColumnName);
                DataRow[] drSelRows = m_dataTableColumns.Select(strExpression);

                if (drSelRows.Length > 0)
                {

                    strJudgeGroupCode = drSelRows[0]["JudgeGroupCode"].ToString();
                    strJudgeCode = drSelRows[0]["JudgeCode"].ToString();
                    strPointFormate = drSelRows[0]["F_MatchSplitComment1"].ToString();
                    iMatchSplitType = Convert.ToInt32(drSelRows[0]["F_MatchSplitType"].ToString());
                }

                if (CurCell.Value != null)
                {
                    strPoint = CurCell.Value.ToString();
                    try
                    {
                        iInputValue = Convert.ToInt32(CurCell.Value);
                    }
                    catch (System.Exception ex)
                    {
                        iInputValue = -1;
                    }
                    iPointsStatusID = 1;
                }
                else
                {
                    strPoint = "";
                    iInputValue = -1;
                    iPointsStatusID = 0;
                }

                if (iMatchSplitType != 0)
                {
                    strPoint = strPoint.Replace(".", "");
                    strPoint = strPoint.Replace("-", "");
                    strPoint = GetValueFormatedString(strPoint, strPointFormate);

                    DVCommon.g_DVDBManager.ExcuteJudgePoint_UpdatePlayerPoint(m_iCurMatchID, iMatchSplitID, iRegisterID, strJudgeGroupCode, strJudgeCode, strPointCode, strPointTypeCode, strPoint, iPointsStatusID, iIsAutoCalcuate);

                    DVCommon.g_DVDBManager.ExcuteDV_CalcuateMatchSplitRank(m_iCurMatchID, iMatchSplitID);
                }
                else
                {
                    if (strColumnName == "Rank")
                    {
                        DVCommon.g_DVDBManager.ExcuteDV_UpdateSplitRank(m_iCurMatchID, iPosition, iMatchSplitID, iInputValue);
                    }
                }
            }

            InitMatchSplitResult();
            IntiMatchResult();
        }


        private void dgvMatchResult_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;

            String strColumnName = dgvMatchResult.Columns[iColumnIndex].Name;

            DataGridViewCell CurCell = dgvMatchResult.Rows[iRowIndex].Cells[iColumnIndex];
            if (CurCell != null)
            {

                Int32 iMatchID = GetFieldValue(dgvMatchResult, iRowIndex, "F_MatchID");
                Int32 iPosition = GetFieldValue(dgvMatchResult, iRowIndex, "F_CompetitionPosition");
                Int32 iRegisterID = GetFieldValue(dgvMatchResult, iRowIndex, "F_RegisterID");


                String strPoint = "";
                Int32 iInputValue = 0;
                String strPointFormate = "";


                string strExpression = String.Format("F_MatchSplitCode = '{0}'", "Tt.Points");
                DataRow[] drSelRows = m_dataTableColumns.Select(strExpression);

                Int32 iPointStatusID = 0;

                if (drSelRows.Length > 0)
                {
                    strPointFormate = drSelRows[0]["F_MatchSplitComment1"].ToString();
                }

                if (CurCell.Value != null)
                {
                    strPoint = CurCell.Value.ToString();
                    try
                    {
                        iInputValue = Convert.ToInt32(CurCell.Value);
                    }
                    catch (System.Exception ex)
                    {
                        iInputValue = -1;
                    }

                    iPointStatusID = 1;
                }
                else
                {
                    strPoint = "";
                    iInputValue = -1;
                    iPointStatusID = 0;
                }


                if (strColumnName == "Rank")
                {
                    DVCommon.g_DVDBManager.ExcuteDV_UpdateMatchRank(m_iCurMatchID, iPosition, iInputValue);
                }
                else if (strColumnName == "Points")
                {
                    strPoint = GetValueFormatedString(strPoint, strPointFormate);

                    DVCommon.g_DVDBManager.ExcuteJudgePoint_UpdatePlayerPoint(m_iCurMatchID, 0, iRegisterID, "", "", "", "", strPoint, iPointStatusID, 0);

                    DVCommon.g_DVDBManager.ExcuteDV_CalcuateMatchRank(m_iCurMatchID);
                }
            }


            IntiMatchResult();
        }

        public static string GetValueFormatedString(string strToFormated, string strRule)
        {
            if (Regex.IsMatch(strRule, @"S#.-"))
            {
                return "";
            }
            strRule = strRule.Replace('S', '#');

            string strVal = strToFormated;
            strVal = strVal.Replace(".", "");
            strVal = strVal.Replace("-", "");

            String strPureNumRule = "";
            strPureNumRule = strRule.Replace(".", "");
            strPureNumRule = strPureNumRule.Replace("-", "");

            if (strVal.Length < strPureNumRule.Length)
            {
                strVal = strVal.PadLeft(strPureNumRule.Length, '0');
            }
            else if (strVal.Length > strPureNumRule.Length)
            {
                strVal = strVal.Substring(0, strPureNumRule.Length);
            }


            String strPureNumRuleWithPoint = "";
            strPureNumRuleWithPoint = strRule.Replace("-", "");
            Int32 iPointPosition = strPureNumRuleWithPoint.IndexOf('.');

            if (strVal.Length > iPointPosition && strVal.Length > 0 && iPointPosition > 0)
            {
                strVal = strVal.Substring(0, iPointPosition) + "." + strVal.Substring(iPointPosition, (strVal.Length - iPointPosition));
            }
            else
            {
                strVal = "";
            }
            if (strRule.StartsWith("-"))
            {
                strVal = "-" + strVal;
            }

            return strVal;
        }

        #region Match Status Operate

        private void btnx_Schedule_Click(object sender, EventArgs e)
        {
            m_iCurStatusID = DVCommon.STATUS_SCHEDULE;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_iCurMatchID, m_iCurStatusID, DVCommon.g_DataBaseCon, DVCommon.g_DVPlugin);
            if (iResult == 1) ShowMatchStatus();
        }

        private void btnx_StartList_Click(object sender, EventArgs e)
        {
            m_iCurStatusID = DVCommon.STATUS_STARTLIST;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_iCurMatchID, m_iCurStatusID, DVCommon.g_DataBaseCon, DVCommon.g_DVPlugin);
            if (iResult == 1) ShowMatchStatus();
        }

        private void btnx_Running_Click(object sender, EventArgs e)
        {
            bool bIsMatchConfiged = DVCommon.g_DVDBManager.IsMatchConfiged(m_iCurMatchID);

            if (!bIsMatchConfiged)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(DVCommon.g_strSectionName, "MsgMatchNoConfiged1"), DVCommon.g_strSectionName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            bool bIsMatchOfficialConfiged = DVCommon.g_DVDBManager.IsMatchHasOfficial(m_iCurMatchID);
            if (!bIsMatchOfficialConfiged)
            {
                string strPromotion = LocalizationRecourceManager.GetString(DVCommon.g_strSectionName, "MsgMatchNoOfficial");
                if (DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion, DVCommon.g_strSectionName, MessageBoxButtons.YesNo, MessageBoxIcon.Question) != DialogResult.Yes)
                    return;
            }

            m_iCurStatusID = DVCommon.STATUS_RUNNING;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_iCurMatchID, m_iCurStatusID, DVCommon.g_DataBaseCon, DVCommon.g_DVPlugin);
            if (iResult == 1) ShowMatchStatus();
        }

        private void btnx_Suspend_Click(object sender, EventArgs e)
        {
            m_iCurStatusID = DVCommon.STATUS_SUSPEND;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_iCurMatchID, m_iCurStatusID, DVCommon.g_DataBaseCon, DVCommon.g_DVPlugin);
            if (iResult == 1) ShowMatchStatus();
        }

        private void btnx_Unofficial_Click(object sender, EventArgs e)
        {
            m_iCurStatusID = DVCommon.STATUS_UNOFFICIAL;

            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_iCurMatchID, m_iCurStatusID, DVCommon.g_DataBaseCon, DVCommon.g_DVPlugin);
            if (iResult == 1) ShowMatchStatus();

            DVCommon.g_DVDBManager.CalEventResult(m_iCurMatchID);
        }

        private void btnx_Finished_Click(object sender, EventArgs e)
        {
            m_iCurStatusID = DVCommon.STATUS_FINISHED;


            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_iCurMatchID, m_iCurStatusID, DVCommon.g_DataBaseCon, DVCommon.g_DVPlugin);
            if (iResult == 1) ShowMatchStatus();

            bool bResult = AutoSports.OVRCommon.OVRDataBaseUtils.AutoProgressMatch(m_iCurMatchID, DVCommon.g_DataBaseCon, DVCommon.g_DVPlugin);

            DVCommon.g_DVDBManager.CalEventResult(m_iCurMatchID);
        }

        private void btnx_Revision_Click(object sender, EventArgs e)
        {
            m_iCurStatusID = DVCommon.STATUS_REVISION;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_iCurMatchID, m_iCurStatusID, DVCommon.g_DataBaseCon, DVCommon.g_DVPlugin);
            if (iResult == 1) ShowMatchStatus();
        }

        private void btnx_Canceled_Click(object sender, EventArgs e)
        {
            m_iCurStatusID = DVCommon.STATUS_CANCELED;
            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_iCurMatchID, m_iCurStatusID, DVCommon.g_DataBaseCon, DVCommon.g_DVPlugin);
            if (iResult == 1) ShowMatchStatus();
        }

        private void btnx_Split_StartList_Click(object sender, EventArgs e)
        {
            DevComponents.DotNetBar.ButtonItem btnItem = (DevComponents.DotNetBar.ButtonItem)sender;
            Int32 iMatchSplitID = (Int32)btnItem.Tag;
            m_arraySplitStatus[iMatchSplitID - 1] = DVCommon.STATUS_STARTLIST;

            Int32 iResult = DVCommon.g_DVDBManager.UpdateMatchSplitStatus(m_iCurMatchID, iMatchSplitID, DVCommon.STATUS_STARTLIST);
            if (iResult == 1) ShowMatchSplitStatus();
        }

        private void btnx_Split_Running_Click(object sender, EventArgs e)
        {
            DevComponents.DotNetBar.ButtonItem btnItem = (DevComponents.DotNetBar.ButtonItem)sender;
            Int32 iMatchSplitID = (Int32)btnItem.Tag;
            m_arraySplitStatus[iMatchSplitID - 1] = DVCommon.STATUS_RUNNING;

            Int32 iResult = DVCommon.g_DVDBManager.UpdateMatchSplitStatus(m_iCurMatchID, iMatchSplitID, DVCommon.STATUS_RUNNING);
            if (iResult == 1) ShowMatchSplitStatus();
        }

        private void btnx_Split_Finished_Click(object sender, EventArgs e)
        {
            DevComponents.DotNetBar.ButtonItem btnItem = (DevComponents.DotNetBar.ButtonItem)sender;
            Int32 iMatchSplitID = (Int32)btnItem.Tag;
            m_arraySplitStatus[iMatchSplitID - 1] = DVCommon.STATUS_FINISHED;

            //每节比赛结束后都要进行当前节的DiveRank计算！
            DVCommon.g_DVDBManager.ExcuteDV_CalcuateMatchSplitRank(m_iCurMatchID, iMatchSplitID);

            Int32 iResult = DVCommon.g_DVDBManager.UpdateMatchSplitStatus(m_iCurMatchID, iMatchSplitID, DVCommon.STATUS_FINISHED);
            if (iResult == 1) ShowMatchSplitStatus();

        }

        private void ShowMatchStatus()
        {
            btnx_Schedule.Checked = false;
            btnx_StartList.Checked = false;
            btnx_Running.Checked = false;
            btnx_Suspend.Checked = false;
            btnx_Unofficial.Checked = false;
            btnx_Finished.Checked = false;
            btnx_Revision.Checked = false;
            btnx_Canceled.Checked = false;

            btnx_Schedule.Enabled = true;
            btnx_StartList.Enabled = true;
            btnx_Running.Enabled = false;
            btnx_Suspend.Enabled = false;
            btnx_Unofficial.Enabled = false;
            btnx_Finished.Enabled = false;
            btnx_Revision.Enabled = false;


            switch (m_iCurStatusID)
            {
                case DVCommon.STATUS_SCHEDULE:
                    {
                        btnx_StartList.Enabled = true;

                        btnx_Schedule.Checked = true;

                        btnx_Status.Text = btnx_Schedule.Text;
                        btnx_Status.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                case DVCommon.STATUS_STARTLIST:
                    {
                        btnx_Running.Enabled = true;

                        btnx_StartList.Checked = true;

                        btnx_Status.Text = btnx_StartList.Text;
                        btnx_Status.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                case DVCommon.STATUS_RUNNING:
                    {
                        btnx_Suspend.Enabled = true;
                        btnx_Unofficial.Enabled = true;

                        btnx_Running.Checked = true;
                        btnx_Status.Text = btnx_Running.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.Red;

                        break;
                    }
                case DVCommon.STATUS_SUSPEND:
                    {
                        btnx_Running.Enabled = true;

                        btnx_Suspend.Checked = true;
                        btnx_Status.Text = btnx_Suspend.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.Red;
                        break;
                    }
                case DVCommon.STATUS_UNOFFICIAL:
                    {
                        btnx_Finished.Enabled = true;
                        btnx_Revision.Enabled = true;

                        btnx_Unofficial.Checked = true;
                        btnx_Status.Text = btnx_Unofficial.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case DVCommon.STATUS_FINISHED:
                    {
                        btnx_Revision.Enabled = true;

                        btnx_Finished.Checked = true;
                        btnx_Status.Text = btnx_Finished.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case DVCommon.STATUS_REVISION:
                    {
                        btnx_Finished.Enabled = true;
                        btnx_Revision.Checked = true;
                        btnx_Status.Text = btnx_Revision.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case DVCommon.STATUS_CANCELED:
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


        private void ShowMatchSplitStatus()
        {

            foreach (Control ctl in panelRoundStatusBtn.Controls)
            {
                if (ctl.GetType().ToString() == "DevComponents.DotNetBar.ButtonX")
                {
                    DevComponents.DotNetBar.ButtonX btnSplitStatus = (DevComponents.DotNetBar.ButtonX)ctl;

                    Int32 iBtnTag = (Int32)btnSplitStatus.Tag;

                    foreach (DevComponents.DotNetBar.ButtonItem btnItem in btnSplitStatus.SubItems)
                    {
                        btnItem.Checked = false;

                        if (iBtnTag <= m_arraySplitStatus.Count())
                        {
                            switch (m_arraySplitStatus[iBtnTag - 1])
                            {
                                case DVCommon.STATUS_STARTLIST:
                                    {
                                        if (btnItem.Text == "StartList")
                                        {
                                            btnItem.Checked = true;
                                            btnSplitStatus.Text = btnItem.Text;
                                            btnSplitStatus.ForeColor = System.Drawing.SystemColors.ControlText;
                                        }
                                        break;
                                    }
                                case DVCommon.STATUS_RUNNING:
                                    {
                                        if (btnItem.Text == "Running")
                                        {
                                            btnItem.Checked = true;
                                            btnSplitStatus.Text = btnItem.Text;
                                            btnSplitStatus.ForeColor = System.Drawing.Color.Red;
                                        }
                                        break;
                                    }
                                case DVCommon.STATUS_FINISHED:
                                    {
                                        if (btnItem.Text == "Offical")
                                        {
                                            btnItem.Checked = true;
                                            btnSplitStatus.Text = btnItem.Text;
                                            btnSplitStatus.ForeColor = System.Drawing.Color.LimeGreen;
                                        }
                                        break;
                                    }
                                default:
                                    break;
                            }
                        }
                    }
                }
            }
        }

        #endregion

        private void MenuOK_Click(object sender, EventArgs e)
        {
            if (dgvMatchSplitResult.SelectedCells.Count < 1)
                return;

            Int32 iRowIndex = dgvMatchSplitResult.SelectedCells[0].RowIndex;

            Int32 iPosition = GetFieldValue(dgvMatchSplitResult, iRowIndex, "F_CompetitionPosition");

            if (m_iCurMatchID <= 0 || iPosition <= 0)
            {
                return;
            }

            if (DVCommon.g_DVDBManager.UpdateMatchIRM(m_iCurMatchID, iPosition, "OK") == 1)
            {
                IntiMatchResult();
                InitMatchSplitResult();
            }
        }

        private void MenuDNS_Click(object sender, EventArgs e)
        {
            if (dgvMatchSplitResult.SelectedCells.Count < 1)
                return;

            Int32 iRowIndex = dgvMatchSplitResult.SelectedCells[0].RowIndex;

            Int32 iPosition = GetFieldValue(dgvMatchSplitResult, iRowIndex, "F_CompetitionPosition");

            if (m_iCurMatchID <= 0 || iPosition <= 0)
            {
                return;
            }

            if (DVCommon.g_DVDBManager.UpdateMatchIRM(m_iCurMatchID, iPosition, "DNS") == 1)
            {
                IntiMatchResult();
                InitMatchSplitResult();
            }
        }

        private void MenuDNF_Click(object sender, EventArgs e)
        {
            if (dgvMatchSplitResult.SelectedCells.Count < 1)
                return;

            Int32 iRowIndex = dgvMatchSplitResult.SelectedCells[0].RowIndex;

            Int32 iPosition = GetFieldValue(dgvMatchSplitResult, iRowIndex, "F_CompetitionPosition");

            if (m_iCurMatchID <= 0 || iPosition <= 0)
            {
                return;
            }

            if (DVCommon.g_DVDBManager.UpdateMatchIRM(m_iCurMatchID, iPosition, "DNF") == 1)
            {
                IntiMatchResult();
                InitMatchSplitResult();
            }
        }

        private void MenuDSQ_Click(object sender, EventArgs e)
        {
            if (dgvMatchSplitResult.SelectedCells.Count < 1)
                return;

            Int32 iRowIndex = dgvMatchSplitResult.SelectedCells[0].RowIndex;

            Int32 iPosition = GetFieldValue(dgvMatchSplitResult, iRowIndex, "F_CompetitionPosition");

            if (m_iCurMatchID <= 0 || iPosition <= 0)
            {
                return;
            }

            if (DVCommon.g_DVDBManager.UpdateMatchIRM(m_iCurMatchID, iPosition, "DSQ") == 1)
            {
                IntiMatchResult();
                InitMatchSplitResult();
            }
        }

        private void btnx_OpenTSInterface(object sender, EventArgs e)
        {
            m_dvTSInterface.Show();
            m_dvTSInterface.Activate();
        }

        private void btn_SetCurDiver_Click(object sender, EventArgs e)
        {
            if (dgvMatchSplitResult.SelectedCells.Count < 1)
                return;

            Int32 iRowIndex = dgvMatchSplitResult.SelectedCells[0].RowIndex;

            Int32 iPosition = GetFieldValue(dgvMatchSplitResult, iRowIndex, "F_CompetitionPosition");

            if (m_iCurMatchID <= 0 || iPosition <= 0)
            {
                return;
            }

            if (DVCommon.g_DVDBManager.ExcuteDV_UpdateMatchSplitCurrentDiver(m_iCurMatchID, m_iCurShowMatchSplitID, iPosition) == 1)
            {
                IntiMatchResult();
                InitMatchSplitResult();
            }
        }

        private void btnOutPut2TS_Click(object sender, EventArgs e)
        {

        }

        private void UpdateUITriggeredByTS()
        {
            Action action = () => this.UpdateUIMatchResult();
            this.Invoke(action);
        }

        private void UpdateUIMatchResult()
        {
            //更新当前运动员需要进行重新比赛轮次信息更新
            DVCommon.g_DVDBManager.GetMatchSplitStatus(m_iCurMatchID, m_iMatchRoundCount, ref m_arraySplitStatus);
            //MessageBox.Show("计时计分更新成绩了,展现界面最好能够做到最少的刷新！");
            ShowMatchStatus();
            ShowMatchSplitStatus();

            IntiMatchResult();
            InitMatchSplitResult();
        }


        private void btnDBInterface_Click(object sender, EventArgs e)
        {
            if (m_DBInterfaceFrm == null)
            {
                m_DBInterfaceFrm = new frmDBInterface(m_iCurMatchID.ToString());
                m_DBInterfaceFrm.Owner = this;
                m_DBInterfaceFrm.Show();
            }
            else
            {
                m_DBInterfaceFrm.Show();
            }
        }
    }
}
