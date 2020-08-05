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
using System.Threading;

namespace AutoSports.OVRSQPlugin
{
    partial class frmOVRSQDataEntry
    {
        Int32 m_nWndMode;

        Int32 m_nCurMatchID;
        Int32 m_nCurMatchType;
        Int32 m_nAdvantage;
        Int32 m_nCurStatusID;
        Int32 m_nCurPlayIDA;
        Int32 m_nCurPlayIDB;
        Int32 m_nServerType;
        Boolean m_bAService;
        Boolean m_bBService;
        Int32 m_nRegIDA;
        Int32 m_nRegIDB;
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
        OVRSQRule ovrRule = new OVRSQRule(0);
        String strSectionName = SQCommon.m_strSectionName;

        //文件监控
        FileSystemWatcher filewatcher = new FileSystemWatcher();
        Boolean bNetConnected;
        Int32 nOldTickCount = -1;
	    String strOldFileName = "";
        Int32 m_nLimitCopyTimeSpan = 300;
        private Int32 TimeoutMillis = 2000; //定时器触发间隔
        String m_strFileImportPath = "";
        //////////////////////////////////////////////////////////////////////////
        // Functions

        void StartMatch()
        {
            if (m_nCurMatchID > 0)
            {
                if (!InitMatch())
                    return;

                m_bIsRunning = true;
                EnableMatchCtrlBtn(true);
                EnableMatchAll(false, false);
                
                // Update Report Context
                SQCommon.g_SQPlugin.SetReportContext("MatchID", m_nCurMatchID.ToString());
            }
        }

        void InitVariant()
        {
            SQCommon.g_ManageDB.InitGame();

            m_nCurMatchType = -1;
            m_nAdvantage = -1;
            m_nCurStatusID = -1;
            m_nCurSetID = -1;
            m_nCurTeamSplitID = -1;
            m_nSetsCount = -1;
            m_nTeamSplitCount = -1;
            m_nCurPlayIDA = -1;
            m_nCurPlayIDB = -1;
            m_nRegIDA = -1;
            m_nRegIDB = -1;
            m_nRegAPos = -1;
            m_nRegBPos = -1;

            m_rbtnCurChkedSet = null;
            m_rbtnCurChkedSplit = null;
            m_nCurSetOffset = -1;
            m_nCurSplitOffset = -1;
        }

        bool InitMatch()
        {
            InitVariant();

            if (!SQCommon.g_ManageDB.GetMatchRuleID(m_nCurMatchID))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbMatchRule"));
                return false;
            }

            ovrRule = new OVRSQRule(m_nCurMatchID);
            m_nCurMatchType = ovrRule.m_nMatchType;
            m_nAdvantage = ovrRule.m_nAdvantage;
            m_nCurStatusID = ovrRule.m_nMatchStatusID;
            m_nServerType = ovrRule.m_nServerType;

            if ( !SQCommon.g_ManageDB.GetMatchSplitCount(m_nCurMatchID, m_nCurMatchType, ref m_nSetsCount, ref m_nTeamSplitCount) )
            {
                m_nSetsCount = ovrRule.m_nSetsCount;
                m_nTeamSplitCount = ovrRule.m_nTeamSplitCount;

                if (1 != SQCommon.g_ManageDB.CreateMatchSplit(m_nCurMatchID, m_nCurMatchType, m_nSetsCount, m_nTeamSplitCount))
                {
                    MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbCreateSplit"));
                    EnableMatchInfo(false, false);
                    EnableMatchCtrlBtn(false);
                    return false;
                }

                SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emSplitAdd, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }

            InitMatchDes();
            UpdateMatchStatus();

            // Load Split IDs
            if (m_nCurMatchType == SQCommon.MATCH_TYPE_SINGLE)
            {
                SQCommon.g_bUseSetsRule = ovrRule.m_bSetRule;
                SQCommon.g_bUseSplitsRule = ovrRule.m_bSplitRule;
                return LoadSetSplitIDs(0);
            }
            else if (m_nCurMatchType == SQCommon.MATCH_TYPE_TEAM)
            {
                SQCommon.g_bUseSetsRule = ovrRule.m_bSetRule;
                SQCommon.g_bUseSplitsRule = ovrRule.m_bSplitRule;
                return LoadTeamSplitIDs();
            }

            return false;
        }

        void InitMatchDes()
        {
            String strSportDes, strPhaseDes, strDateDes, strVenueDes, strPlayNameA, strPlayNameB, strHomeSet, strAwaySet;
            SQCommon.g_ManageDB.GetOneMatchDes(m_nCurMatchID, out m_nCurPlayIDA, out m_nCurPlayIDB, out strPlayNameA, out strPlayNameB, out m_nCurStatusID,
                out strSportDes, out strPhaseDes, out strDateDes, out strVenueDes, out strHomeSet, out strAwaySet, out m_nRegAPos, out m_nRegBPos);

            lb_SportDes.Text = strSportDes;
            lb_PhaseDes.Text = strPhaseDes;
            lb_DateDes.Text = strDateDes;
            lb_VenueDes.Text = strVenueDes;
            lb_HomeDes.Text = strPlayNameA;
            lb_AwayDes.Text = strPlayNameB;

            lb_Home_Score.Text = strHomeSet.Equals("") ? "0" : strHomeSet;
            lb_Away_Score.Text = strAwaySet.Equals("") ? "0" : strAwaySet;

            MatchScoreToSetsTotal();
        }

        bool InitPlayerInfo()
        {
            Int32 nSplitID = -1;
            if (m_nCurMatchType == SQCommon.MATCH_TYPE_SINGLE)
            {
                nSplitID = m_nCurSetID;
            }
            else if (m_nCurMatchType == SQCommon.MATCH_TYPE_TEAM)
            {
                nSplitID = m_nCurTeamSplitID;
            }
            if (nSplitID <= 0) return false;

            // Get PlayerName
            STableRecordSet stRecords;
            if (!SQCommon.g_ManageDB.GetSplitResult(m_nCurMatchID, nSplitID, out stRecords)) return false;

            Int32 nPlayCount = stRecords.GetRecordCount();

            if(nPlayCount == 2)
            {
                Int32 nRegAID = stRecords.GetFieldValue(0, "F_RegisterID") == String.Empty ? 0 : Convert.ToInt32(stRecords.GetFieldValue(0, "F_RegisterID"));
                Int32 nRegBID = stRecords.GetFieldValue(1, "F_RegisterID") == String.Empty ? 0 : Convert.ToInt32(stRecords.GetFieldValue(1, "F_RegisterID"));
                String strName, strNOC;

                if (m_nCurMatchType == SQCommon.MATCH_TYPE_TEAM && (nRegAID <= 0 || nRegBID <= 0))
                {
                    return false;
                }

                if (SQCommon.g_ManageDB.GetPlayerInfo(nRegAID, out strName, out strNOC))
                {
                    m_nRegIDA = nRegAID;
                    lb_PlayerA.Text = strName;
                    lb_NOCA.Text = strNOC;
                }

                if (SQCommon.g_ManageDB.GetPlayerInfo(nRegBID, out strName, out strNOC))
                {
                    m_nRegIDB = nRegBID;
                    lb_PlayerB.Text = strName;
                    lb_NOCB.Text = strNOC;
                }
            }
            else
            {
                return false;
            }

            return true;
        }

        bool LoadTeamSplitIDs()
        {
            m_naTeamSplitIDs.Clear();

            STableRecordSet stRecords;
            if (!SQCommon.g_ManageDB.GetSubSplitInfo(m_nCurMatchID, 0, out stRecords)) return false;

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
            if (!SQCommon.g_ManageDB.GetSubSplitInfo(m_nCurMatchID, nFatherSplitID, out stRecords)) return false;

            Int32 nSetsCount = stRecords.GetRecordCount();
            for (Int32 i = 0; i < nSetsCount; i++)
            {
                String strID = stRecords.GetFieldValue(i, "F_MatchSplitID");
                m_naSetIDs.Add(Convert.ToInt32(strID));
            }

            return true;
        }

        private void UpdateMatchStatus()
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
                case SQCommon.STATUS_SCHEDULE:
                    {
                        btnx_StartList.Enabled = true;
                        btnx_Unofficial.Enabled = true;
                        btnx_Finished.Enabled = true;
                        btnx_Schedule.Checked = true;
                        btnx_Status.Text = btnx_Schedule.Text;
                        btnx_Status.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                case SQCommon.STATUS_STARTLIST:
                    {
                        if (m_nSetsCount > 0 && m_nTeamSplitCount >= 0)
                        {
                            btnx_Running.Enabled = true;
                        }

                        btnx_StartList.Checked = true;
                        btnx_Status.Text = btnx_StartList.Text;
                        btnx_Status.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                case SQCommon.STATUS_RUNNING:
                    {
                        EnableMatchAll(true, false);
                        btnx_Suspend.Enabled = true;
                        btnx_Unofficial.Enabled = true;

                        UpdateSplitStatus(SQCommon.STATUS_RUNNING);

                        btnx_Running.Checked = true;
                        btnx_Status.Text = btnx_Running.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.Red;
                        break;
                    }
                case SQCommon.STATUS_SUSPEND:
                    {
                        EnableMatchAll(false, false);

                        btnx_Running.Enabled = true;
                        btnx_Suspend.Checked = true;
                        btnx_Status.Text = btnx_Suspend.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.Red;
                        break;
                    }
                case SQCommon.STATUS_UNOFFICIAL:
                    {
                        EnableMatchAll(false, false);

                        SQCommon.g_ManageDB.UpdateMatchRankSets(m_nCurMatchID);
                        SQCommon.g_ManageDB.CreateGroupResult(m_nCurMatchID);
                        OVRDataBaseUtils.AutoProgressMatch(m_nCurMatchID, SQCommon.g_adoDataBase.m_dbConnect, SQCommon.g_SQPlugin);//自动晋级
                        SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);

                        Int32 iPhaseID = SQCommon.g_ManageDB.GetPhaseID(m_nCurMatchID);
                        SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, iPhaseID, -1, iPhaseID, null);

                        btnx_Finished.Enabled = true;
                        btnx_Revision.Enabled = true;
                        btnx_Unofficial.Checked = true;
                        btnx_Status.Text = btnx_Unofficial.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    } 
                case SQCommon.STATUS_FINISHED:
                    {
                        EnableMatchAll(false, false);

                        if (m_nCurMatchType == SQCommon.MATCH_TYPE_SINGLE)
                        {
                            UpdateSetsResult(true);
                        }

                        SQCommon.g_ManageDB.UpdateMatchRankSets(m_nCurMatchID);
                        SQCommon.g_ManageDB.CreateGroupResult(m_nCurMatchID);
                        OVRDataBaseUtils.AutoProgressMatch(m_nCurMatchID, SQCommon.g_adoDataBase.m_dbConnect, SQCommon.g_SQPlugin);//自动晋级
                        SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                        
                        Int32 iPhaseID = SQCommon.g_ManageDB.GetPhaseID(m_nCurMatchID);
                        SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, iPhaseID, -1, iPhaseID, null);

                        btnx_Revision.Enabled = true;
                        btnx_Finished.Checked = true;
                        btnx_Status.Text = btnx_Finished.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case SQCommon.STATUS_REVISION:
                    {
                        EnableMatchAll(true, false);

                        btnx_Finished.Enabled = true;
                        btnx_Revision.Checked = true;
                        btnx_Status.Text = btnx_Revision.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case SQCommon.STATUS_CANCELED:
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

            if (!InitPlayerInfo())
            {
                EnableSplitInfo(false, true);
                EnableGameDetail(false, true);
                CheckedTeamSetRbtn(0);

                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbSetTeamPlayers"));
                return false;
            }

            UpdateSetsResult(true);

            // Select 1st Set
            CheckedTeamSetRbtn(nSplit + 1);
            EnableGameDetail(true, false);

            rad_Game1.Checked = true;
            m_nCurSetOffset = 0;
            m_nCurSetID = (Int32)m_naSetIDs[0];
            UpdateSplitStatus(SQCommon.STATUS_RUNNING);

            return true;
        }

        void MatchScoreToSetsTotal()
        {
            if (m_nCurMatchType == SQCommon.MATCH_TYPE_TEAM || m_nCurMatchType <= 0) return;

            lb_A_GameTotal.Text = lb_Home_Score.Text;
            lb_B_GameTotal.Text = lb_Away_Score.Text;

            SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
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
                    if (SQCommon.g_ManageDB.GetSplitResult(m_nCurMatchID, nSplitID, out stRecords))
                    {
                        if (stRecords.GetRecordCount() != 2)
                            return false;

                        String strSplitPointsA = stRecords.GetFieldValue(0, "F_Points");
                        String strSplitPointsB = stRecords.GetFieldValue(1, "F_Points");

                        String strEditVarNameA = "lb_A_Game" + (i + 1).ToString();
                        String strEditVarNameB = "lb_B_Game" + (i + 1).ToString();

                        Type dlgType = typeof(frmOVRSQDataEntry);
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
                if (m_nCurMatchType == SQCommon.MATCH_TYPE_TEAM)
                {
                    UpdateTeamSplitResult(true);
                }
                else
                {
                    MatchScoreToSetsTotal();
                }
            }

            return true;
        }

        bool UpdateSetsResult(bool bFromDB, Int32 nPointA, Int32 nPointB)
        {
            if (!bFromDB)
            {
                if (!ovrRule.IsValidSetScore(nPointA, nPointB)) return false;

                Int32 nRankA = 0, nRankB = 0, nResultA = 3, nResultB = 3;
                bool bFinish = false;

                if ( ovrRule.IsSetScoreFinished(nPointA, nPointB))
                {
                    bFinish = true;
                    ovrRule.PointsToRankResult(nPointA, nPointB, out nRankA, out nRankB, out nResultA, out nResultB);
                }

                bool bReturnA = SQCommon.g_ManageDB.SetSplitPoints(m_nCurMatchID, m_nCurSetID, m_nRegAPos, nPointA, nResultA, nRankA, bFinish);
                bool bReturnB = SQCommon.g_ManageDB.SetSplitPoints(m_nCurMatchID, m_nCurSetID, m_nRegBPos, nPointB, nResultB, nRankB, bFinish);
                if (!bReturnA || !bReturnB)
                {
                    MessageBox.Show("Update Result Failed");
                    return false;
                }

                GetSetsTotalWriteToDB();

                SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }

            return true;
        }

        bool UpdateService(bool bFromDB)
        {
            if (m_nCurSetID <= 0) return false;
            STableRecordSet stRecords;

            if (bFromDB)
            {
                // Update the Service
                if (!SQCommon.g_ManageDB.GetSplitResult(m_nCurMatchID, m_nCurSetID, out stRecords)) return false;

                if (stRecords.GetRecordCount() != 2)
                    return false;

                String strAService = stRecords.GetFieldValue(0, "F_Service");
                String strBService = stRecords.GetFieldValue(1, "F_Service");

                m_bAService = strAService == "1" ? true : false;
                m_bBService = strBService == "1" ? true : false;

                rad_ServerA.Checked = m_bAService;
                rad_ServerB.Checked = m_bBService;
            }
            else
            {
                bool bResultA = SQCommon.g_ManageDB.SetSplitService(m_nCurMatchID, m_nCurSetID, m_nRegAPos, m_bAService);
                bool bResultB = SQCommon.g_ManageDB.SetSplitService(m_nCurMatchID, m_nCurSetID, m_nRegBPos, m_bBService);
                if (!bResultA || !bResultB)
                {
                    MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbUpdateServer"));
                    return false;
                }
            }

            SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            return true;
        }

        bool UpdateTeamSplitResult(bool bFromDB)
        {
            if (m_nCurTeamSplitID <= 0 || m_nCurMatchType != SQCommon.MATCH_TYPE_TEAM) return false;

            STableRecordSet stRecords;
            Int32 nTeamSplitID = m_nCurTeamSplitID;

            if (bFromDB)
            {
                // Update the Result
                if (SQCommon.g_ManageDB.GetSplitResult(m_nCurMatchID, nTeamSplitID, out stRecords))
                {
                    if (stRecords.GetRecordCount() != 2)
                        return false;

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

            Int32 nTeamSplitID = m_nCurMatchType == SQCommon.MATCH_TYPE_TEAM ? m_nCurTeamSplitID : 0;

            if (!ovrRule.GetTotalScoreFromSets(nTeamSplitID, ref nTotalScoreA, ref nTotalScoreB)) return false;

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

	        if (m_nCurMatchType == SQCommon.MATCH_TYPE_TEAM && m_nCurTeamSplitID > 0)
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

        //Action GamePoint MatchPoint
        bool AddActionList(Int32 nPosition, Int32 nRegisterID, Int32 nResultA, Int32 nResultB, Int32 nScore)
        {
            Int32 nPointType;
            Int32 nActionID;

            Int32 nMatchA = lb_A_GameTotal.Text == String.Empty ? 0 : Convert.ToInt32(lb_A_GameTotal.Text);
            Int32 nMatchB = lb_B_GameTotal.Text == String.Empty ? 0 : Convert.ToInt32(lb_B_GameTotal.Text);

            ovrRule.StatGameMatchPoint(nResultA, nResultB, nMatchA, nMatchB, out nPointType);
            nActionID = SQCommon.g_ManageDB.GetActionID(SQCommon.strAction_addScore);

            SQCommon.g_ManageDB.AddActionList(nPosition, m_nCurMatchID, m_nCurSetID, nRegisterID, nActionID, nScore, nPointType);

            SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatistic, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            return true;
        }

        bool DelActionList(Int32 nPosition, Int32 nRegisterID)
        {
            SQCommon.g_ManageDB.DelActionList(nPosition, m_nCurMatchID, m_nCurSetID, nRegisterID, 1);
            SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatistic, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            return true;
        }

        //Split Status
        void UpdateSplitStatus(Int32 nSplitStatus)
        {
            SQCommon.g_ManageDB.UpdateAllSplitStatus(m_nCurMatchID);
            SQCommon.g_ManageDB.UpdateSplitStatus(m_nCurMatchID, m_nCurSetID, nSplitStatus);
            SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }
        
        //比赛信息导入导出
        void InitDateList()
        {
            cmbFilterDate.DataSource = null;
            cmbFilterDate.Items.Clear();

            if (!SQCommon.g_ManageDB.GetDisciplineDateList(cmbFilterDate)) return;
        }

        void ExportAthleteXml()
        {
            String strExportPath = tbExportPath.Text;
            if (!Directory.Exists(strExportPath))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgExportPath"));
                return;
            }

            String strExportFile = strExportPath.TrimEnd('\\') + "\\" + SQCommon.g_strExAthleteFileName + ".xml";
            SQCommon.g_ManageDB.ExportAthleteXml(strExportFile);
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
            String strExportFile = strExportPath.TrimEnd('\\') + "\\" + SQCommon.g_strExSchduleFileName + strDate + ".xml";
            SQCommon.g_ManageDB.ExportScheduleXml(strExportFile, nDateID);
        }

        bool CreateFileSystermWatcher()
        {
            filewatcher.Path = tbImportPath.Text;
            filewatcher.NotifyFilter = NotifyFilters.LastWrite;
            filewatcher.IncludeSubdirectories = true;

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

            strFileName = strFileName.Substring(0, strFileName.IndexOf("_"));

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
        }

        void ImportMatchInfo(String strImprotFile)
        {
            if (!File.Exists(strImprotFile))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgFilePath"));
                return;
            }

            String strInPut = "";
            StreamReader sr = new StreamReader(strImprotFile);
            String strLine;
            while ((strLine = sr.ReadLine()) != null)
            {
                strInPut = strInPut + strLine;
            }

            sr.Close();

            Int32 nMatchID;
            Int32 nStatusID;
            // Output Prompt

            if (SQCommon.g_ManageDB.ImportMatchInfoXml(strInPut, out nMatchID, out nStatusID))
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
                if (nStatusID == SQCommon.STATUS_UNOFFICIAL || nStatusID == SQCommon.STATUS_FINISHED)
                {
                    SQCommon.g_ManageDB.UpdateMatchRankSets(nMatchID);
                    SQCommon.g_ManageDB.CreateGroupResult(nMatchID);

                    Int32 iPhaseID = SQCommon.g_ManageDB.GetPhaseID(nMatchID);
                    SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, iPhaseID, -1, iPhaseID, null);
                }

                SqlConnection sqlConnection = new SqlConnection(SQCommon.g_adoDataBase.m_strConnection);

                if (sqlConnection.State == System.Data.ConnectionState.Closed)
                {
                    sqlConnection.Open();
                }

                OVRDataBaseUtils.ChangeMatchStatus(nMatchID, nStatusID, sqlConnection, SQCommon.g_SQPlugin);
                OVRDataBaseUtils.AutoProgressMatch(nMatchID, sqlConnection, SQCommon.g_SQPlugin);

                if (sqlConnection != null)
                {
                    sqlConnection.Close();
                }

                SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, nMatchID, nMatchID, null);
                SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, nMatchID, nMatchID, null);
            }         
        }

        void ImportActionList(String strImprotFile)
        {
            if (!File.Exists(strImprotFile))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgFilePath"));
                return;
            }

            String strInPut = "";
            StreamReader sr = new StreamReader(strImprotFile);
            String strLine;
            while ((strLine = sr.ReadLine()) != null)
            {
                strInPut = strInPut + strLine;
            }

            sr.Close();

            Int32 nMatchID;

            if (SQCommon.g_ManageDB.ImportActionListXml(strInPut, out nMatchID))
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
                SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, nMatchID, nMatchID, null);
            }
        }

        void ImportMatchResult(String strImportFile)
        {
            if (!File.Exists(strImportFile))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgImportFile"));
                return;
            }

            Int32 nOrderIndex = strImportFile.ToUpper().IndexOf(".XML");
            if (nOrderIndex < 1)
            {
                return;
            }

            String strOrder = strImportFile[nOrderIndex - 1].ToString();

            Int32 nOrder = Convert.ToInt32(strOrder);

            if (nOrder < 1 || nOrder > 3)
            {
                return;
            }

            String strInPut = "";
            StreamReader sr = new StreamReader(strImportFile);
            String strLine;
            while ((strLine = sr.ReadLine()) != null)
            {
                strInPut = strInPut + strLine;
            }

            sr.Close();

            Int32 nMatchID;

            if (SQCommon.g_ManageDB.ImportMatchResultXML(strInPut, nOrder, out nMatchID))
            {
                String strMsg = LocalizationRecourceManager.GetString(strSectionName, "msgImportResultSuc") + nMatchID.ToString() + "\r\n";
                SetTextBoxText(strMsg);
            }
            else
            {
                String strMsg = LocalizationRecourceManager.GetString(strSectionName, "msgImportMatchResult") + "\r\n";
                SetTextBoxText(strMsg);
            }

            if (nMatchID > 0)
            {
                SQCommon.g_SQPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, nMatchID, nMatchID, null);
            }
        }

        //文件监控
        void OnChanged(object source, FileSystemEventArgs e)
        {
            if (!IsFileNeedtoCopy(e.FullPath))
                return;

            while (true)
            {
                if (File.Exists(e.FullPath))
                {
                    Thread.Sleep(50);
                    break;
                }

                Thread.Sleep(100);
            }

            String strDesFile = "";

            if ( MoveXmlToSpecFolder(e.FullPath, ref strDesFile) )
            {
                ImportOuterDataInfo(strDesFile);
            }
        }

        private delegate bool CreateWatcherDelegate();
        void OnError(object sender, ErrorEventArgs e)
        {
            bNetConnected = false;
            if(!bNetConnected)
            {
                if (Directory.Exists(m_strFileImportPath))
                {
                    this.Invoke(new CreateWatcherDelegate(CreateFileSystermWatcher));
                }
            }
        }

        bool IsFileNeedtoCopy(String strFileName)
        {
            if (nOldTickCount < 0) // First time init variant
            {
                nOldTickCount = System.Environment.TickCount;
                strOldFileName = strFileName;
                return true;
            }

            Int32 nNewTickCount = System.Environment.TickCount;
            Int32 nTickCountSpan = nNewTickCount - nOldTickCount;

            if (strFileName == strOldFileName && nTickCountSpan < m_nLimitCopyTimeSpan) // File with the same name not need be copy within 
                return false;
            else
            {
                nOldTickCount = nNewTickCount;
                strOldFileName = strFileName;
                return true;
            }
        }

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

        private bool MoveXmlToSpecFolder(String strXmlFile, ref String strDesFile)
        { 
            String strParsedPath = "C:\\" + SQCommon.g_strParsedFolderName;
            String strParsedFile = strParsedPath + strXmlFile.Substring(strXmlFile.LastIndexOf('\\'));
            strDesFile = strParsedFile;
            try
            {
                // Create the specified folder in the import file path
                if (!Directory.Exists(strParsedPath))
                {
                    Directory.CreateDirectory(strParsedPath);
                }

                if (!File.Exists(strXmlFile))
                {
                    return false;
                }

                if (File.Exists(strParsedFile)) File.Delete(strParsedFile);
                File.Copy(strXmlFile, strParsedFile, true);
            }
            catch (System.Exception errDir)
            {
                return false;
            }

            return true;
        }

        private String GetFileName(String strFilePath)
        {
            String strFileName = strFilePath.Substring(strFilePath.LastIndexOf("\\") + 1, strFilePath.Length - strFilePath.LastIndexOf("\\") - 1);
            Int32 nIndex = strFileName.IndexOf("_");

            if (nIndex < 0)
            {
                return "";
            }

            strFileName = strFileName.Substring(0, strFileName.IndexOf("_"));

            return strFileName;
        }
    }
}
