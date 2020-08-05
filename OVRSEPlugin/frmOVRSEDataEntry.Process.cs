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
using System.Reflection;
using System.Threading;

namespace AutoSports.OVRSEPlugin
{
    partial class frmOVRSEDataEntry : IDataProcess
    {
        Int32 m_nWndMode;

        Int32 m_nCurMatchID;
        Int32 m_nCurMatchType;
        Int32 m_nCurStatusID;
        Int32 m_nCurPlayIDA;
        Int32 m_nCurPlayIDB;
        Boolean m_bAService;
        Boolean m_bBService;
        Int32 m_nRegAPos;
        Int32 m_nRegBPos;

        Int32 m_nCurSetID;
        Int32 m_nCurTeamSplitID;
        RadioButton m_rbtnCurChkedSet;                             // Current selected Set CheckBox
        DevComponents.DotNetBar.ButtonX m_rbtnCurChkedSplit;       // Current selected Split CheckBox
        Int32 m_nCurSetOffset;                                     // Current selected set CheckBox offset
        Int32 m_nCurSplitOffset;                                   // Current selected Split CheckBox offset

        Int32 m_nSetsCount;
        Int32 m_nTeamSplitCount;

        ArrayList m_naTeamSplitIDs = new ArrayList();
        ArrayList m_naSetIDs = new ArrayList();

        Boolean m_bIsRunning = false;

        OVRSERule ovrRule;

        String strSectionName = SECommon.m_strSectionName;

        //文件监控
        FileSystemWatcher filewatcher = new FileSystemWatcher();
        Boolean bNetConnected;
        Int32 nOldTickCount = -1;
        String strOldFileName = "";
        Int32 m_nLimitCopyTimeSpan = 300;
        private Int32 TimeoutMillis = 4000; //定时器触发间隔

        QueueDataProcess<string> m_processer;

        String m_strFileImportPath = "";
        //////////////////////////////////////////////////////////////////////////
        // Functions

        void StartMatch()
        {
            if (m_nCurMatchID > 0)
            {
                lbMatchID.Text = m_nCurMatchID.ToString();
                lbCourt.Text = SECommon.g_ManageDB.GetMatchCourtName(m_nCurMatchID);
                lbRule.Text = SECommon.g_ManageDB.GetMatchRuleName(m_nCurMatchID);
                lbRSC.Text = SECommon.g_ManageDB.GetRscStringFromMatchID(m_nCurMatchID);
                if (!InitMatch())
                    return;

                m_bIsRunning = true;

                EnableMatchCtrlBtn(true);
                //EnableMatchAll(false, false);

                // Update Report Context
                SECommon.g_SEPlugin.SetReportContext("MatchID", m_nCurMatchID.ToString());
            }
        }

        void InitVariant()
        {
            SECommon.g_ManageDB.InitGame();

            m_nCurMatchType = -1;
            m_nCurStatusID = -1;
            m_nCurSetID = -1;
            m_nCurTeamSplitID = -1;
            m_nSetsCount = -1;
            m_nTeamSplitCount = -1;
            m_nCurPlayIDA = -1;
            m_nCurPlayIDB = -1;
            m_bAService = false;
            m_bBService = false;
            m_nRegAPos = -1;
            m_nRegBPos = -1;

            m_rbtnCurChkedSet = null;
            m_rbtnCurChkedSplit = null;
            m_nCurSetOffset = -1;
            m_nCurSplitOffset = -1;
        }

        bool InitMatch()
        {
            bool bResult = false;

            InitVariant();

            if (!SECommon.g_ManageDB.GetMatchRuleID(m_nCurMatchID))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbMatchRule"));
                bResult = false;
            }

            ovrRule = new OVRSERule(m_nCurMatchID);
            m_nCurMatchType = ovrRule.m_nMatchType;
            m_nCurStatusID = ovrRule.m_nMatchStatusID;

            if (!SECommon.g_ManageDB.GetMatchSplitCount(m_nCurMatchID, m_nCurMatchType, ref m_nSetsCount, ref m_nTeamSplitCount))
            {
                m_nSetsCount = ovrRule.m_nSetsCount;
                m_nTeamSplitCount = ovrRule.m_nTeamSplitCount;

                if (1 != SECommon.g_ManageDB.CreateMatchSplit(m_nCurMatchID, m_nCurMatchType, m_nSetsCount, m_nTeamSplitCount))
                {
                    MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbCreateSplit"));
                    EnableMatchInfo(false, false);
                    EnableMatchCtrlBtn(false);
                    bResult = false;
                }

                SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emSplitAdd, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }

            // Load Split IDs
            if (m_nCurMatchType == SECommon.MATCH_TYPE_REGU || m_nCurMatchType == SECommon.MATCH_TYPE_DOUBLE)
            {
                SECommon.g_bUseSetsRule = ovrRule.m_bSetRule;
                SECommon.g_bUseSplitsRule = ovrRule.m_bSplitRule;
                bResult = LoadSetSplitIDs(0);
            }
            else if (m_nCurMatchType == SECommon.MATCH_TYPE_TEAM)
            {
                SECommon.g_bUseSetsRule = ovrRule.m_bSetRule;
                SECommon.g_bUseSplitsRule = ovrRule.m_bSplitRule;
                bResult = LoadTeamSplitIDs();
            }

            InitMatchDes();
            UpdateMatchStatus(true);

            return bResult;
        }

        void InitMatchDes()
        {
            String strSportDes, strPhaseDes, strDateDes, strVenueDes, strPlayNameA, strPlayNameB, strHomeSet, strAwaySet;
            SECommon.g_ManageDB.GetOneMatchDes(m_nCurMatchID, out m_nCurPlayIDA, out m_nCurPlayIDB, out strPlayNameA, out strPlayNameB, out m_nCurStatusID,
                out strSportDes, out strPhaseDes, out strDateDes, out strVenueDes, out strHomeSet, out strAwaySet, out m_nRegAPos, out m_nRegBPos);

            lb_SportDes.Text = strSportDes;
            lb_PhaseDes.Text = strPhaseDes;
            lb_DateDes.Text = strDateDes;
            lb_HomeDes.Text = strPlayNameA;
            lb_AwayDes.Text = strPlayNameB;

            lb_Home_Score.Text = strHomeSet.Equals("") ? "0" : strHomeSet;
            lb_Away_Score.Text = strAwaySet.Equals("") ? "0" : strAwaySet;

            MatchScoreToSetsTotal();
        }

        bool GetMatchPlayerList()
        {
            SECommon.g_ManageDB.GetMatchPlayersList(m_nCurMatchID, m_nCurMatchType, 1, m_nCurTeamSplitID, dgvTeamA);
            SECommon.g_ManageDB.GetMatchPlayersList(m_nCurMatchID, m_nCurMatchType, 2, m_nCurTeamSplitID, dgvTeamB);
            SetGridStyle(dgvTeamA);
            SetGridStyle(dgvTeamB);

            dgvTeamA.ClearSelection();
            dgvTeamB.ClearSelection();

            return true;
        }

        private void SetGridStyle(DataGridView dgv)
        {
            dgv.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.CellSelect;

            if (dgv == dgvTeamA || dgv == dgvTeamB)
            {
                if (dgv.Columns["Active"] != null)
                {
                    dgv.Columns["Active"].ReadOnly = false;
                }
                if (dgv.Columns["PlayPos"] != null)
                {
                    dgv.Columns["PlayPos"].ReadOnly = false;
                }
            }
            else if (dgv == dgvHoopResult)
            {
                if (dgv.Columns["HD"] != null)
                {
                    dgv.Columns["HD"].ReadOnly = false;
                }
                if (dgv.Columns["IK"] != null)
                {
                    dgv.Columns["IK"].ReadOnly = false;
                }
                if (dgv.Columns["SH"] != null)
                {
                    dgv.Columns["SH"].ReadOnly = false;
                }
                if (dgv.Columns["KK"] != null)
                {
                    dgv.Columns["KK"].ReadOnly = false;
                }
                if (dgv.Columns["OK"] != null)
                {
                    dgv.Columns["OK"].ReadOnly = false;
                }
                if (dgv.Columns["CJ"] != null)
                {
                    dgv.Columns["CJ"].ReadOnly = false;
                }
                if (dgv.Columns["BF"] != null)
                {
                    dgv.Columns["BF"].ReadOnly = false;
                }
                if (dgv.Columns["IS"] != null)
                {
                    dgv.Columns["IS"].ReadOnly = false;
                }
            }
        }

        void AddActionStatisticList(Int32 nActionID, Int32 nPos, Int32 nPlayerID, bool bAdd)
        {
            // Get Current selected Set Edit 
            Int32 nOffset = m_nCurSetOffset;
            if (nOffset < 0 || nOffset >= m_naSetIDs.Count) return;

            Label plbSetA = (Label)ReflectVar(GetType(), "lb_A_Game" + (nOffset + 1).ToString());
            Label plbSetB = (Label)ReflectVar(GetType(), "lb_B_Game" + (nOffset + 1).ToString());

            if (plbSetA == null || plbSetB == null) return;

            Int32 nResultA = 0;
            Int32 nResultB = 0;
            Int32 nMatchA = 0;
            Int32 nMatchB = 0;
            Int32 nPointType = 0;
            try
            {
                nResultA = plbSetA.Text == String.Empty ? 0 : Convert.ToInt32(plbSetA.Text);
                nResultB = plbSetB.Text == String.Empty ? 0 : Convert.ToInt32(plbSetB.Text);
            }
            catch (System.Exception eFmt)
            {
                MessageBox.Show(eFmt.ToString());
            }

            if (bAdd && nPos == 1)
                plbSetA.Text = (nResultA + 1).ToString();
            else if (bAdd && nPos == 2)
                plbSetB.Text = (nResultB + 1).ToString();

            if (!UpdateSetsResult(false))
            {
                plbSetA.Text = nResultA.ToString();
                plbSetB.Text = nResultB.ToString();
                return;
            }

            nResultA = plbSetA.Text == String.Empty ? 0 : Convert.ToInt32(plbSetA.Text);
            nResultB = plbSetB.Text == String.Empty ? 0 : Convert.ToInt32(plbSetB.Text);
            nMatchA = lb_A_GameTotal.Text == String.Empty ? 0 : Convert.ToInt32(lb_A_GameTotal.Text);
            nMatchB = lb_B_GameTotal.Text == String.Empty ? 0 : Convert.ToInt32(lb_B_GameTotal.Text);

            ovrRule.StatGameMatchPoint(m_nCurSetOffset + 1, m_bAService, m_bBService, nResultA, nResultB, nMatchA, nMatchB, out nPointType);
            SECommon.g_ManageDB.AddActionList(nPos, m_nCurMatchID, m_nCurSetID, nPlayerID, nActionID, nResultA, nResultB, nPointType);
            SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatistic, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);

            SetServerStatus(nResultA, nResultB, nPos);
        }

        void DeleteActionList()
        {
            Int32 nPosition, nSub;
            SECommon.g_ManageDB.GetGameLastActive(m_nCurMatchID, m_nCurSetID, out nPosition, out nSub);

            if (nSub == 1)
            {
                // Get Current selected Set Edit 
                Int32 nOffset = m_nCurSetOffset;
                if (nOffset < 0 || nOffset >= m_naSetIDs.Count) return;

                Label plbSetA = (Label)ReflectVar(GetType(), "lb_A_Game" + (nOffset + 1).ToString());
                Label plbSetB = (Label)ReflectVar(GetType(), "lb_B_Game" + (nOffset + 1).ToString());

                if (plbSetA == null || plbSetB == null) return;

                Int32 nResultA = 0;
                Int32 nResultB = 0;
                Int32 nMatchA = 0;
                Int32 nMatchB = 0;
                try
                {
                    nResultA = plbSetA.Text == String.Empty ? 0 : Convert.ToInt32(plbSetA.Text);
                    nResultB = plbSetB.Text == String.Empty ? 0 : Convert.ToInt32(plbSetB.Text);
                }
                catch (System.Exception eFmt)
                {
                    MessageBox.Show(eFmt.ToString());
                }

                if (nPosition == 1 && (nResultA > 0))
                    plbSetA.Text = (nResultA - 1).ToString();
                else if (nPosition == 2 && (nResultB > 0))
                    plbSetB.Text = (nResultB - 1).ToString();

                if (!UpdateSetsResult(false))
                {
                    plbSetA.Text = nResultA.ToString();
                    plbSetB.Text = nResultB.ToString();
                    return;
                }

                nResultA = plbSetA.Text == String.Empty ? 0 : Convert.ToInt32(plbSetA.Text);
                nResultB = plbSetB.Text == String.Empty ? 0 : Convert.ToInt32(plbSetB.Text);
                nMatchA = lb_A_GameTotal.Text == String.Empty ? 0 : Convert.ToInt32(lb_A_GameTotal.Text);
                nMatchB = lb_B_GameTotal.Text == String.Empty ? 0 : Convert.ToInt32(lb_B_GameTotal.Text);
            }

            SECommon.g_ManageDB.DeleteAcitonList(m_nCurMatchID, m_nCurSetID);
            SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatistic, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);

            if (SECommon.g_ManageDB.GetUndoStatus(m_nCurMatchID, m_nCurSetID))
            {
                btnx_Undo.Enabled = false;
            }
        }

        bool LoadTeamSplitIDs()
        {
            m_naTeamSplitIDs.Clear();

            STableRecordSet stRecords;
            if (!SECommon.g_ManageDB.GetSubSplitInfo(m_nCurMatchID, 0, out stRecords)) return false;

            Int32 nCount = stRecords.GetRecordCount();
            for (Int32 i = 0; i < nCount; i++)
            {
                String strID = stRecords.GetFieldValue(i, "F_MatchSplitID");
                m_naTeamSplitIDs.Add(Convert.ToInt32(strID));
            }

            return true;
        }

        bool LoadSetSplitIDs(Int32 nFatherSplitID)
        {
            m_naSetIDs.Clear();

            STableRecordSet stRecords;
            if (!SECommon.g_ManageDB.GetSubSplitInfo(m_nCurMatchID, nFatherSplitID, out stRecords)) return false;

            Int32 nSetsCount = stRecords.GetRecordCount();
            for (Int32 i = 0; i < nSetsCount; i++)
            {
                String strID = stRecords.GetFieldValue(i, "F_MatchSplitID");
                m_naSetIDs.Add(Convert.ToInt32(strID));
            }

            return true;
        }

        /// <summary>
        /// 更新比赛状态
        /// </summary>
        /// <param name="bUpdateFromInit">更新是否来自初始化</param>
        private void UpdateMatchStatus(bool bUpdateFromInit = false)
        {
            btnx_Schedule.Checked = false;
            btnx_StartList.Checked = false;
            btnx_Running.Checked = false;
            btnx_Suspend.Checked = false;
            btnx_Unofficial.Checked = false;
            btnx_Finished.Checked = false;
            btnx_Revision.Checked = false;
            btnx_Canceled.Checked = false;

            btnx_Schedule.Enabled = false;
            btnx_StartList.Enabled = false;
            btnx_Running.Enabled = false;
            btnx_Suspend.Enabled = false;
            btnx_Unofficial.Enabled = false;
            btnx_Finished.Enabled = false;
            btnx_Revision.Enabled = false;

            switch (m_nCurStatusID)
            {
                case SECommon.STATUS_SCHEDULE:
                    {
                        btnx_StartList.Enabled = true;
                        btnx_Finished.Enabled = true;
                        btnx_Schedule.Checked = true;
                        btnx_Status.Text = btnx_Schedule.Text;
                        btnx_Status.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                case SECommon.STATUS_STARTLIST:
                    {
                        if (m_nSetsCount > 0)
                        {
                            btnx_Running.Enabled = true;
                        }

                        btnx_StartList.Checked = true;
                        btnx_Status.Text = btnx_StartList.Text;
                        btnx_Status.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                case SECommon.STATUS_RUNNING:
                    {
                        EnableMatchAll(true, false);
                        btnx_Suspend.Enabled = true;
                        btnx_Unofficial.Enabled = true;

                        if (m_nCurMatchType != SECommon.MATCH_TYPE_TEAM)
                        {
                            GetMatchPlayerList();
                            UpdateSetsResult(true);
                        }

                        //比赛处于正在进行，则不改变状态
                        if (!bUpdateFromInit)
                        {
                            UpdateSplitStatus(SECommon.STATUS_RUNNING);
                        }

                        btnx_Running.Checked = true;
                        btnx_Status.Text = btnx_Running.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.Red;
                        break;
                    }
                case SECommon.STATUS_SUSPEND:
                    {
                        EnableMatchAll(false, false);
                        btnx_Running.Enabled = true;
                        btnx_Suspend.Checked = true;
                        btnx_Status.Text = btnx_Suspend.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.Red;
                        break;
                    }
                case SECommon.STATUS_UNOFFICIAL:
                    {
                        EnableMatchAll(false, false);

                        if (m_nCurMatchType == SECommon.MATCH_TYPE_REGU || m_nCurMatchType == SECommon.MATCH_TYPE_DOUBLE)
                        {
                            UpdateSetsResult(true);
                        }

                        SECommon.g_ManageDB.UpdateMatchRankSets(m_nCurMatchID);
                        SECommon.g_ManageDB.CreateGroupResult(m_nCurMatchID);
                        OVRDataBaseUtils.AutoProgressMatch(m_nCurMatchID, SECommon.g_adoDataBase.m_dbConnect, SECommon.g_SEPlugin);//自动晋级
                        SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);

                        Int32 iPhaseID = SECommon.g_ManageDB.GetPhaseID(m_nCurMatchID);
                        SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, iPhaseID, -1, iPhaseID, null);

                        btnx_Finished.Enabled = true;
                        btnx_Revision.Enabled = true;
                        btnx_Unofficial.Checked = true;
                        btnx_Status.Text = btnx_Unofficial.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case SECommon.STATUS_FINISHED:
                    {
                        EnableMatchAll(false, false);

                        if (m_nCurMatchType == SECommon.MATCH_TYPE_REGU || m_nCurMatchType == SECommon.MATCH_TYPE_DOUBLE)
                        {
                            UpdateSetsResult(true);
                        }

                        SECommon.g_ManageDB.UpdateMatchRankSets(m_nCurMatchID);
                        SECommon.g_ManageDB.CreateGroupResult(m_nCurMatchID);
                        OVRDataBaseUtils.AutoProgressMatch(m_nCurMatchID, SECommon.g_adoDataBase.m_dbConnect, SECommon.g_SEPlugin);//自动晋级
                        SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);

                        Int32 iPhaseID = SECommon.g_ManageDB.GetPhaseID(m_nCurMatchID);
                        SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, iPhaseID, -1, iPhaseID, null);

                        btnx_Revision.Enabled = true;
                        btnx_Finished.Checked = true;
                        btnx_Status.Text = btnx_Finished.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case SECommon.STATUS_REVISION:
                    {
                        if (m_nCurMatchType != SECommon.MATCH_TYPE_TEAM)
                        {
                            GetMatchPlayerList();
                        }

                        EnableMatchAll(true, false);
                        btnx_Unofficial.Enabled = true;
                        btnx_Finished.Enabled = true;
                        btnx_Revision.Checked = true;
                        btnx_Status.Text = btnx_Revision.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case SECommon.STATUS_CANCELED:
                    {
                        EnableMatchAll(false, false);
                        btnx_Canceled.Checked = true;
                        btnx_Status.Text = btnx_Canceled.Text;
                        btnx_Status.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                default:
                    return;
            }
        }

        bool ChangeTeamSplit(Int32 nSplit)
        {
            // Get Current Split ID
            m_nCurTeamSplitID = (Int32)m_naTeamSplitIDs[nSplit];

            LoadSetSplitIDs(m_nCurTeamSplitID);
            SECommon.g_ManageDB.UpdateTeamSplitStatus(m_nCurMatchID, m_nCurTeamSplitID, SECommon.STATUS_RUNNING);

            GetMatchPlayerList();
            UpdateSetsResult(true);

            // Select 1st Set
            CheckedTeamSetRbtn(nSplit + 1);
            bool oldState = rad_Game1.Checked;
            rad_Game1.Checked = true;
            m_nCurSetOffset = 0;

            //如果已经是选中状态，不会触发Set的改变，需要手动调用
            if (oldState)
            {
                OnRbtnSetRange(rad_Game1, null);
            }

            EnableGameDetail(true, false);
            return true;
        }

        void MatchScoreToSetsTotal()
        {
            if (m_nCurMatchType == SECommon.MATCH_TYPE_TEAM || m_nCurMatchType <= 0) return;

            lb_A_GameTotal.Text = lb_Home_Score.Text;
            lb_B_GameTotal.Text = lb_Away_Score.Text;

            SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        void SetServerStatus(Int32 nResultA, Int32 nResultB, Int32 nPos)
        {
            ///东南亚运动会，进行修改，3分进行交换，当14-14平时，则一分进行交换
            if (ovrRule.IsSetScoreFinished(m_nCurSetOffset + 1, nResultA, nResultB))
            {
                rad_ServerA.Checked = false;
                rad_ServerB.Checked = false;

                m_bAService = false;
                m_bBService = false;
            }
            else if (nResultA >= 20 && nResultB >= 20)   //当20平时，每得一分，就行换球权
            {
                rad_ServerA.Checked = m_bBService == true ? true : false;
                //rad_ServerB.Checked = m_bAService == true ? true : false;
                rad_ServerB.Checked = !rad_ServerA.Checked;

                m_bAService = rad_ServerA.Checked;
                m_bBService = rad_ServerB.Checked;
            }
            else if (nPos != 0)
            {
                if ((nResultB + nResultA) % 3 == 0)
                {
                    m_bAService = !m_bAService;
                    m_bBService = !m_bBService;

                    rad_ServerA.Checked = m_bAService == true ? true : false;
                    rad_ServerB.Checked = m_bBService == true ? true : false;
                }

                //rad_ServerA.Checked = nPos == 1 ? true : false;
                //rad_ServerB.Checked = nPos == 2 ? true : false;

                //m_bAService = nPos == 1 ? true : false;
                //m_bBService = nPos == 2 ? true : false;
            }

            UpdateService(false);
        }

        bool UpdateService(bool bFromDB)
        {
            if (m_nCurSetID <= 0) return false;
            STableRecordSet stRecords;

            if (bFromDB)
            {
                // Update the Service
                if (!SECommon.g_ManageDB.GetSplitResult(m_nCurMatchID, m_nCurSetID, out stRecords)) return false;

                String strAService = stRecords.GetFieldValue(0, "F_Service");
                String strBService = stRecords.GetFieldValue(1, "F_Service");

                m_bAService = strAService == "1" ? true : false;
                m_bBService = strBService == "1" ? true : false;

                rad_ServerA.Checked = m_bAService;
                rad_ServerB.Checked = m_bBService;
            }
            else
            {
                bool bResultA = SECommon.g_ManageDB.SetSplitService(m_nCurMatchID, m_nCurSetID, m_nRegAPos, m_bAService);
                bool bResultB = SECommon.g_ManageDB.SetSplitService(m_nCurMatchID, m_nCurSetID, m_nRegBPos, m_bBService);
                if (!bResultA || !bResultB)
                {
                    MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbUpdateServer"));
                    return false;
                }

                SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }

            return true;
        }

        bool UpdateSetsResult(bool bFromDB)
        {
            STableRecordSet stRecords;
            Int32 nSetsCount = m_naSetIDs.Count;

            if (bFromDB)
            {
                for (Int32 i = 0; i < nSetsCount; i++)
                {
                    Int32 nSplitID = (Int32)m_naSetIDs[i];

                    // Update the Result
                    if (SECommon.g_ManageDB.GetSplitResult(m_nCurMatchID, nSplitID, out stRecords))
                    {
                        String strSplitPointsA = stRecords.GetFieldValue(0, "F_Points");
                        String strSplitPointsB = stRecords.GetFieldValue(1, "F_Points");

                        String strEditVarNameA = "lb_A_Game" + (i + 1).ToString();
                        String strEditVarNameB = "lb_B_Game" + (i + 1).ToString();

                        Type dlgType = typeof(frmOVRSEDataEntry);
                        Label editBoxA = (Label)ReflectVar(dlgType, strEditVarNameA);
                        Label editBoxB = (Label)ReflectVar(dlgType, strEditVarNameB);
                        if (editBoxA != null && editBoxB != null)
                        {
                            editBoxA.Text = strSplitPointsA == String.Empty ? "0" : strSplitPointsA;
                            editBoxB.Text = strSplitPointsB == String.Empty ? "0" : strSplitPointsB;
                        }
                    }
                }

                // Update SetTotalScore to UI
                if (m_nCurMatchType == SECommon.MATCH_TYPE_TEAM)
                {
                    UpdateTeamSplitResult(true);
                }
                else
                {
                    MatchScoreToSetsTotal();
                }
            }
            else
            {
                //for (Int32 i = 0; i < nSetsCount; i++)
                //{
                //  Int32 nSplitID = (Int32)m_naSetIDs[i];

                Int32 nSplitID = m_nCurSetID;
                int i = m_nCurSetOffset;

                // Get the UI Points
                String strEditVarNameA = "lb_A_Game" + (i + 1).ToString();
                String strEditVarNameB = "lb_B_Game" + (i + 1).ToString();

                Type dlgType = typeof(frmOVRSEDataEntry);
                Label editBoxA = (Label)ReflectVar(dlgType, strEditVarNameA);
                Label editBoxB = (Label)ReflectVar(dlgType, strEditVarNameB);
                if (editBoxA != null && editBoxB != null)
                {
                    Int32 nSplitPointsA = editBoxA.Text == String.Empty ? 0 : Convert.ToInt32(editBoxA.Text);
                    Int32 nSplitPointsB = editBoxB.Text == String.Empty ? 0 : Convert.ToInt32(editBoxB.Text);

                    if (!ovrRule.IsValidSetScore(i + 1, nSplitPointsA, nSplitPointsB)) return false;

                    bool bReturnA = SECommon.g_ManageDB.SetSplitPoints(m_nCurMatchID, nSplitID, m_nRegAPos, nSplitPointsA);
                    bool bReturnB = SECommon.g_ManageDB.SetSplitPoints(m_nCurMatchID, nSplitID, m_nRegBPos, nSplitPointsB);
                    if (!bReturnA || !bReturnB)
                    {
                        MessageBox.Show("Update Result Failed");
                        return false;
                    }
                }
                // }

                GetSetsTotalWriteToDB();

                SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emSplitResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }

            return true;
        }

        bool UpdateTeamSplitResult(bool bFromDB)
        {
            if (m_nCurTeamSplitID <= 0 || m_nCurMatchType != SECommon.MATCH_TYPE_TEAM) return false;

            STableRecordSet stRecords;
            Int32 nTeamSplitID = m_nCurTeamSplitID;

            if (bFromDB)
            {
                // Update the Result
                if (SECommon.g_ManageDB.GetSplitResult(m_nCurMatchID, nTeamSplitID, out stRecords))
                {
                    String strSplitPointsA = stRecords.GetFieldValue(0, "F_Points");
                    String strSplitPointsB = stRecords.GetFieldValue(1, "F_Points");

                    lb_A_GameTotal.Text = strSplitPointsA == "" ? "0" : strSplitPointsA;
                    lb_B_GameTotal.Text = strSplitPointsB == "" ? "0" : strSplitPointsB;
                    return true;
                }
            }
            else
            {
                return GetSetsTotalWriteToDB();
            }

            return false;
        }

        bool GetSetsTotalWriteToDB() // Write the Total Sets Score to the UI Edit Window, and Send EN_UPDATE notify
        {
            Int32 nTotalScoreA = 0;
            Int32 nTotalScoreB = 0;
            Int32 nSplitOffset = m_nCurSplitOffset == -1 ? 0 : m_nCurSplitOffset;

            Int32 nTeamSplitID = m_nCurMatchType == SECommon.MATCH_TYPE_TEAM ? m_nCurTeamSplitID : 0;

            if (!ovrRule.GetTotalScoreFromSets(nSplitOffset, nTeamSplitID, ref nTotalScoreA, ref nTotalScoreB)) return false;

            lb_A_GameTotal.Text = nTotalScoreA.ToString();
            lb_B_GameTotal.Text = nTotalScoreB.ToString();

            UpdateSetTotalResult();

            return true;
        }

        void UpdateSetTotalResult()
        {
            String strSetATScore, strSetBTScore;
            Int32 iSetATScore, iSetBTScore;

            strSetATScore = lb_A_GameTotal.Text;
            strSetBTScore = lb_B_GameTotal.Text;

            iSetATScore = strSetATScore == String.Empty ? 0 : Convert.ToInt32(strSetATScore);
            iSetBTScore = strSetBTScore == String.Empty ? 0 : Convert.ToInt32(strSetBTScore);

            if (m_nCurMatchType == SECommon.MATCH_TYPE_TEAM && m_nCurTeamSplitID > 0)
            {
                if (!ovrRule.UpdateTeamSplitResultToDB(m_nCurTeamSplitID, iSetATScore, iSetBTScore, m_nRegAPos, m_nRegBPos))
                {
                    UpdateTeamSplitResult(true); // Recover if not valid
                    return;
                }

                // Statistic Match Score and Update to DB
                Int32 nMatchScoreA = 0;
                Int32 nMatchScoreB = 0;
                if (ovrRule.GetMatchScoreFromTeamSplits(ref nMatchScoreA, ref nMatchScoreB))
                {
                    // Update match result
                    if (ovrRule.UpdateMatchResultToDB(nMatchScoreA, nMatchScoreB, m_nRegAPos, m_nRegBPos))
                    {
                        lb_Home_Score.Text = Convert.ToString(nMatchScoreA);
                        lb_Away_Score.Text = Convert.ToString(nMatchScoreB);
                    }
                }
            }
            else
            {
                // Update match result
                if (ovrRule.UpdateMatchResultToDB(iSetATScore, iSetBTScore, m_nRegAPos, m_nRegBPos))
                {
                    lb_Home_Score.Text = strSetATScore;
                    lb_Away_Score.Text = strSetBTScore;
                }
                else // Recover from Match result
                {
                    MatchScoreToSetsTotal();
                }
            }

            EnableMatchDetail(true, false);
        }

        //Statistic
        bool IsSetScoreFinished()
        {
            // Get Current selected Set Edit 
            Int32 nOffset = m_nCurSetOffset;
            if (nOffset < 0 || nOffset >= m_naSetIDs.Count) return false;

            Label plbSetA = (Label)ReflectVar(GetType(), "lb_A_Game" + (nOffset + 1).ToString());
            Label plbSetB = (Label)ReflectVar(GetType(), "lb_B_Game" + (nOffset + 1).ToString());

            if (plbSetA == null || plbSetB == null) return false;

            Int32 nResultA = 0;
            Int32 nResultB = 0;
            try
            {
                nResultA = plbSetA.Text == String.Empty ? 0 : Convert.ToInt32(plbSetA.Text);
                nResultB = plbSetB.Text == String.Empty ? 0 : Convert.ToInt32(plbSetB.Text);
            }
            catch (System.Exception eFmt)
            {
                MessageBox.Show(eFmt.ToString());
            }

            // If Result is Finished then not Add any more
            if (ovrRule.IsSetScoreFinished(nOffset + 1, nResultA, nResultB)) return false;

            return true;
        }

        //Split Status
        void UpdateSplitStatus(Int32 nSplitStatus)
        {
            Int32 nTeamSplitID = m_nCurMatchType == SECommon.MATCH_TYPE_TEAM ? m_nCurTeamSplitID : 0;

            SECommon.g_ManageDB.UpdateAllSplitStatus(m_nCurMatchID, nTeamSplitID);
            SECommon.g_ManageDB.UpdateSplitStatus(m_nCurMatchID, m_nCurSetID, nSplitStatus);
            SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
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

        //比赛信息导入导出
        void InitDateList()
        {
            cmbFilterDate.DataSource = null;
            cmbFilterDate.Items.Clear();

            if (!SECommon.g_ManageDB.GetDisciplineDateList(cmbFilterDate)) return;
        }

        void ExportAthleteXml()
        {
            String strExportPath = tbExportPath.Text;
            if (!Directory.Exists(strExportPath))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgExportPath"));
                return;
            }

            String strExportFile = strExportPath.TrimEnd('\\') + "\\" + SECommon.g_strExAthleteFileName + ".xml";
            SECommon.g_ManageDB.ExportAthleteXml(strExportFile);
        }

        void ExportScheduleXml()
        {
            String strExportPath = tbExportPath.Text;
            if (!Directory.Exists(strExportPath))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgExportPath"));
                return;
            }

            if (cmbFilterDate.SelectedIndex < 0)
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgSelectDate"));
                MessageBoxEx.Show("Please Select Date First!");
                return;
            }

            String strDate = cmbFilterDate.Text;
            Int32 nDateID = Convert.ToInt32(cmbFilterDate.SelectedValue);

            if (strDate.Length == 10)
            {
                strDate = strDate.Substring(2, strDate.Length - 2);
            }

            strDate = strDate.Replace("-", "");
            String strExportFile = strExportPath.TrimEnd('\\') + "\\" + SECommon.g_strExSchduleFileName + strDate + ".xml";
            SECommon.g_ManageDB.ExportScheduleXml(strExportFile, nDateID);
        }

        void ExportHoopScheduleXml()
        {
            String strExportPath = tbExportPath.Text;
            if (!Directory.Exists(strExportPath))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgExportPath"));
                return;
            }

            if (cmbFilterDate.SelectedIndex < 0)
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgSelectDate"));
                MessageBoxEx.Show("Please Select Date First!");
                return;
            }

            String strDate = cmbFilterDate.Text;
            Int32 nDateID = Convert.ToInt32(cmbFilterDate.SelectedValue);

            if (strDate.Length == 10)
            {
                strDate = strDate.Substring(2, strDate.Length - 2);
            }

            strDate = strDate.Replace("-", "");
            String strExportFile = strExportPath.TrimEnd('\\') + "\\" + SECommon.g_strExSchduleFileName + strDate + ".xml";
            SECommon.g_ManageDB.ExportHoopScheduleXml(strExportFile, nDateID);
        }

        void ExportHoopCompListXml()
        {
            String strExportPath = tbExportPath.Text;
            if (!Directory.Exists(strExportPath))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgExportPath"));
                return;
            }

            String strExportFile = strExportPath.TrimEnd('\\') + "\\" + SECommon.g_strExCompListFileName + ".xml";
            SECommon.g_ManageDB.ExportHoopCompListXml(strExportFile);
        }

        void ExportTeamXml()
        {
            String strExportPath = tbExportPath.Text;
            if (!Directory.Exists(strExportPath))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgExportPath"));
                return;
            }

            String strExportFile = strExportPath.TrimEnd('\\') + "\\" + SECommon.g_strExTeamFileName + ".xml";
            SECommon.g_ManageDB.ExportTeamXml(strExportFile);
        }

        bool CreateFileSystermWatcher()
        {
            filewatcher.Path = tbImportPath.Text;
            filewatcher.NotifyFilter = NotifyFilters.LastWrite;
            filewatcher.IncludeSubdirectories = false;

            // Add event handlers.
            bNetConnected = true;
            filewatcher.Changed += new FileSystemEventHandler(OnChanged);
            filewatcher.Error += new ErrorEventHandler(OnError);
            filewatcher.EnableRaisingEvents = true;

            //Timer for network path
            timerNetPath.Interval = TimeoutMillis;
            timerNetPath.Start();

            return true;
        }


        void ImportOuterDataInfo(String strPath)
        {
            String strFileName = strPath.Substring(strPath.LastIndexOf("\\") + 1, strPath.Length - strPath.LastIndexOf("\\") - 1);
            Int32 nIndex = strFileName.IndexOf("_");

            if (nIndex < 0)
            {
                return;
            }

            //strFileName = strFileName.Substring(0, strFileName.IndexOf("_"));
            strFileName = Path.GetFileNameWithoutExtension(strFileName);
            string[] nameArray = strFileName.Split('_');
            strFileName = nameArray[0];

            if (strFileName == "MatchInfo")
            {
                ImportMatchInfo(strPath);
                return;
            }
            else if (strFileName == "ScoreList")
            {
                ImportActionList(strPath);
                return;
            }
            else if (strFileName == "PlayerStat")
            {
                ImportStatisticList(strPath);
                return;
            }
            else if (strFileName == "HoopMatchInfo")
            {
                ImportHoopMatchInfo(strPath);
                return;
            }
        }

        void ImportHoopMatchInfo(String strImprotFile)
        {
            if (!File.Exists(strImprotFile))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgFilePath"));
                return;
            }

            //String strInPut = "";
            //StreamReader sr = new StreamReader(strImprotFile);
            //String strLine;
            //while ((strLine = sr.ReadLine()) != null)
            //{
            //    strInPut = strInPut + strLine;
            //}

            //sr.Close();
            string strInPut = File.ReadAllText(strImprotFile, System.Text.Encoding.UTF8);

            Int32 nMatchID;
            Int32 nStatusID;
            // Output Prompt

            if (SECommon.g_ManageDB.ImportHoopMatchInfoXml(strInPut, out nMatchID, out nStatusID))
            {
                String strMsg = LocalizationRecourceManager.GetString(strSectionName, "msgImportMatchInfoSuc") + nMatchID.ToString() + "\r\n";
                SetTextBoxText(strMsg);
            }
            else
            {
                String strMsg = LocalizationRecourceManager.GetString(strSectionName, "msgImportMatchInfo") + "\r\n";
                SetTextBoxText(strMsg);
            }

            if (nMatchID > 0)
            {
                if (nStatusID == SECommon.STATUS_UNOFFICIAL || nStatusID == SECommon.STATUS_FINISHED)
                {
                    SECommon.g_ManageDB.CreateHoopPhaseResult(m_nCurMatchID);

                    Int32 iPhaseID = SECommon.g_ManageDB.GetPhaseID(nMatchID);
                    SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, iPhaseID, -1, iPhaseID, null);
                }

                SqlConnection sqlConnection = new SqlConnection(SECommon.g_adoDataBase.m_strConnection);

                if (sqlConnection.State == System.Data.ConnectionState.Closed)
                {
                    sqlConnection.Open();
                }

                OVRDataBaseUtils.ChangeMatchStatus(nMatchID, nStatusID, sqlConnection, SECommon.g_SEPlugin);

                //增加刷新界面
                if (nMatchID == m_nCurMatchID && m_nCurMatchType == SECommon.MATCH_TYPE_HOOP )
                {
                    m_nCurStatusID = nStatusID;
                    if (  m_nCurStatusID == SECommon.STATUS_RUNNING || m_nCurStatusID == SECommon.STATUS_UNOFFICIAL )
                    {
                        Action action = () =>
                        {
                            UpdateHoopMatchStatus();
                            FillMatchResultGridView();
                        };
                        this.Invoke(action);
                    }
                }

                if (sqlConnection != null)
                {
                    sqlConnection.Close();
                }

                SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, nMatchID, nMatchID, null);
            }
        }

        void ImportMatchInfo(String strImprotFile)
        {
            if (!File.Exists(strImprotFile))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgFilePath"));
                return;
            }

            string strInPut = File.ReadAllText(strImprotFile, System.Text.Encoding.UTF8);

            Int32 nMatchID;
            Int32 nStatusID;
            // Output Prompt

            if (SECommon.g_ManageDB.ImportMatchInfoXml(strInPut, out nMatchID, out nStatusID))
            {
                String strMsg = LocalizationRecourceManager.GetString(strSectionName, "msgImportMatchInfoSuc") + nMatchID.ToString() + "\r\n";
                SetTextBoxText(strMsg);
            }
            else
            {
                String strMsg = LocalizationRecourceManager.GetString(strSectionName, "msgImportMatchInfo") + "\r\n";
                SetTextBoxText(strMsg);
            }

            if (nMatchID > 0)
            {
                if (nStatusID == SECommon.STATUS_UNOFFICIAL || nStatusID == SECommon.STATUS_FINISHED)
                {
                    SECommon.g_ManageDB.UpdateMatchRankSets(nMatchID);
                    SECommon.g_ManageDB.CreateGroupResult(nMatchID);

                    Int32 iPhaseID = SECommon.g_ManageDB.GetPhaseID(nMatchID);
                    SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, iPhaseID, -1, iPhaseID, null);
                }

                SqlConnection sqlConnection = new SqlConnection(SECommon.g_adoDataBase.m_strConnection);

                if (sqlConnection.State == System.Data.ConnectionState.Closed)
                {
                    sqlConnection.Open();
                }

                OVRDataBaseUtils.ChangeMatchStatus(nMatchID, nStatusID, sqlConnection, SECommon.g_SEPlugin);
                OVRDataBaseUtils.AutoProgressMatch(nMatchID, sqlConnection, SECommon.g_SEPlugin);//自动晋级

                if (sqlConnection != null)
                {
                    sqlConnection.Close();
                }

                SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, nMatchID, nMatchID, null);
            }
        }

        void ImportActionList(String strImprotFile)
        {
            if (!File.Exists(strImprotFile))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgFilePath"));
                return;
            }

            string strInPut = File.ReadAllText(strImprotFile, System.Text.Encoding.UTF8);

            Int32 nMatchID;

            if (SECommon.g_ManageDB.ImportActionListXml(strInPut, out nMatchID))
            {
                String strMsg = LocalizationRecourceManager.GetString(strSectionName, "msgImportActionSuc") + nMatchID.ToString() + "\r\n";
                SetTextBoxText(strMsg);
            }
            else
            {
                String strMsg = LocalizationRecourceManager.GetString(strSectionName, "msgImportAction") + "\r\n";
                SetTextBoxText(strMsg);
            }

            if (nMatchID > 0)
            {
                SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, nMatchID, nMatchID, null);
            }
        }

        void ImportStatisticList(String strImprotFile)
        {
            if (!File.Exists(strImprotFile))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgFilePath"));
                return;
            }

            string strInPut = File.ReadAllText(strImprotFile, System.Text.Encoding.UTF8);

            Int32 nMatchID;

            if (SECommon.g_ManageDB.ImportStatisticXml(strInPut, out nMatchID))
            {
                String strMsg = LocalizationRecourceManager.GetString(strSectionName, "msgImportStatisticSuc") + nMatchID.ToString() + "\r\n";
                SetTextBoxText(strMsg);
            }
            else
            {
                String strMsg = LocalizationRecourceManager.GetString(strSectionName, "msgImportStatistic") + "\r\n";
                SetTextBoxText(strMsg);
            }

            if (nMatchID > 0)
            {
                SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatistic, -1, -1, -1, nMatchID, nMatchID, null);
            }
        }

        //增加重复判断机制，如果连续两次变化小于3秒，则认定为重复
        private string m_lastChangeContent = "";
        private DateTime m_dtLastSameDT = DateTime.Now;

        //判断是否为同样的变化
        private bool IsSecondChange(string strPath)
        {
            string strFileCnt = File.ReadAllText(strPath, Encoding.UTF8);
            if ( strFileCnt == m_lastChangeContent 
                && ( DateTime.Now - m_dtLastSameDT < TimeSpan.FromSeconds(3) )
                )
            {
                return true;
            }
            m_lastChangeContent = strFileCnt;
            m_dtLastSameDT = DateTime.Now;
            return false;
        }
        //文件监控
        void OnChanged(object source, FileSystemEventArgs e)
        {
            //if (!IsFileNeedtoCopy(e.FullPath))
            //    return;

            //while (true)
            //{
            //    if (File.Exists(e.FullPath))
            //    {
            //        Thread.Sleep(50);
            //        break;
            //    }

            //    Thread.Sleep(100);
            //}

            //2013-12-07，重写该逻辑，增加稳定性

            m_processer.AddTask(e.FullPath);
           
        }

        public bool ProcessData(object task)
        {
            string strPath = (string)task;

            if (!File.Exists(strPath))
            {
                return false;
            }

            string strBakFilePath = "";
            //连续10次移动失败则放弃该文件
            if (!TryMoveFileToBak(strPath, 5, ref strBakFilePath))
            {
                return false;
            }

            String strDesFile = "";

            if (CopyXmlToSpecFolder(strBakFilePath, ref strDesFile))
            {
                //if (IsSecondChange(strDesFile))
                //{
                //    MessageBox.Show("第二次变化");
                //    return false;
                //}
                ImportOuterDataInfo(strDesFile);
            }
            else
            {
            }
            return true;
        }

        private delegate bool CreateWatcherDelegate();
        void OnError(object sender, ErrorEventArgs e)
        {
            bNetConnected = false;
            if (!bNetConnected)
            {
                if (Directory.Exists(m_strFileImportPath))
                {
                    this.Invoke(new CreateWatcherDelegate(CreateFileSystermWatcher));
                }
            }
        }

        //bool IsFileNeedtoCopy(String strFileName)
        //{
        //    if (nOldTickCount < 0) // First time init variant
        //    {
        //        nOldTickCount = System.Environment.TickCount;
        //        strOldFileName = strFileName;
        //        return true;
        //    }

        //    Int32 nNewTickCount = System.Environment.TickCount;
        //    Int32 nTickCountSpan = nNewTickCount - nOldTickCount;

        //    if (strFileName == strOldFileName && nTickCountSpan < m_nLimitCopyTimeSpan) // File with the same name not need be copy within 
        //        return false;
        //    else
        //    {
        //        nOldTickCount = nNewTickCount;
        //        strOldFileName = strFileName;
        //        return true;
        //    }
        //}

        public void SetTextBoxText(String strMsg)
        {
            if (this.tbImportMsg.InvokeRequired)
            {
                SetTextBoxMsg text = new SetTextBoxMsg(SetTextBoxText);
                this.BeginInvoke(text, strMsg);//改为异步委托，防止界面卡住线程

            }
            else
            {
                if (this.tbImportMsg.TextLength > 500)
                {
                    this.tbImportMsg.Text = "";
                }

                this.tbImportMsg.Text = this.tbImportMsg.Text + strMsg;
            }
        }

        private bool TryMoveFileToBak(string strSrcFile, int tryCount, ref string newFilePath)
        {
            if ( !File.Exists(strSrcFile) )
            {
                return false;
            }
            string folder = Path.GetDirectoryName(strSrcFile);
            string fileName = Path.GetFileName(strSrcFile);
            string newDesFile = Path.Combine(folder, "BAK", fileName);
            newFilePath = newDesFile;
            System.Threading.Thread.Sleep(10);//先延迟10ms
            for (int i = 0; i < tryCount; i++ )
            { 
                try
                {
                    if ( File.Exists(newFilePath) )
                    {
                        File.Delete(newFilePath);
                    }
                    File.Move(strSrcFile, newDesFile);
                    return true;
                }
                catch (System.Exception ex)
                {

                }
                //移动失败，则延迟50ms再试
                System.Threading.Thread.Sleep(50);
            }
            return false;
        }

        private bool CopyXmlToSpecFolder(String strXmlFile, ref String strDesFile)
        {
            String strParsedPath = "C:\\" + SECommon.g_strParsedFolderName;
            String strParsedFile = strParsedPath + strXmlFile.Substring(strXmlFile.LastIndexOf('\\'));
            strDesFile = strParsedFile;
            try
            {
                // Create the specified folder in the import file path
                if (!Directory.Exists(strParsedPath))
                {
                    Directory.CreateDirectory(strParsedPath);
                }

                if (!File.Exists(strXmlFile)) return false;

                if (File.Exists(strParsedFile)) File.Delete(strParsedFile);
                File.Copy(strXmlFile, strParsedFile, true);
            }
            catch (System.Exception ex)
            {
                return false;
            }

            return true;
        }

        public string LastErrorMessage
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

 
    }
}
