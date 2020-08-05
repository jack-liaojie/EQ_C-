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

namespace AutoSports.OVRBDPlugin
{
    partial class frmOVRBDDataEntry
    {
        //Int32 m_nWndMode;

        Int32 m_nCurMatchID;
        Int32 m_nCurMatchType;

        Int32 m_nCurStatusID;
        Int32 m_nCurPlayIDA;
        Int32 m_nCurPlayIDB;
        Boolean m_bAService;
        Boolean m_bBService;
        Int32 m_nRegIDA;
        Int32 m_nRegIDB;
        Int32 m_nRegAPos;
        Int32 m_nRegBPos;

        Int32 m_nCurGameID;
        Int32 m_nCurTeamSplitID;
        RadioButton m_rbtnCurChkedGame;                             // Current selected Game CheckBox
        ButtonX m_rbtnCurChkedSplit;                                // Current selected Split CheckBox
        Int32 m_nCurGameOffset;                                     // Current selected Game CheckBox offset
        Int32 m_nCurSplitOffset;                                    // Current selected Split CheckBox offset

        Int32 m_nGamesCount;
        Int32 m_nTeamSplitCount;

        Int32 m_nDoubleRegisterA1;
        Int32 m_nDoubleRegisterA2;
        Int32 m_nDoubleRegisterB1;
        Int32 m_nDoubleRegisterB2;
        bool m_bIsDoubleMatch;
        bool m_bIsTeamMatch;

        ArrayList m_naTeamSplitIDs = new ArrayList();
        ArrayList m_naGameIDs = new ArrayList();

        Boolean m_bIsRunning = false;
        private OVRBDRule m_CurMatchRule = null;
        public OVRBDRule CurMatchRule
        {
            get { return m_CurMatchRule; }
        }

        String strSectionName = BDCommon.m_strSectionName;



        //文件监控
        FileSystemWatcher filewatcher = new FileSystemWatcher();
        //////////////////////////////////////////////////////////////////////////
        // Functions

        void StartMatch()
        {
            if (!InitSubMatchSplits())
                return;

            // Load all Splits IDs to array
            if (m_nCurMatchType == BDCommon.MATCH_TYPE_TEAM)
            {
                if (!LoadTeamSplitIDs()) return;
            }
            else
            {
                if (!LoadGameSplitIDs(0)) return;
            }

            m_bIsRunning = true;
            EnableMatchCtrlBtn(true);
            InitMatchDes();
            UpdateMatchStatus(false);
            m_bIsDoubleMatch = false;
            m_bIsTeamMatch = false;
            // Update Report Context
            BDCommon.g_BDPlugin.SetReportContext("MatchID", m_nCurMatchID.ToString());

            if (!BDCommon.g_ManageDB.IsTeamMatch(m_nCurMatchID))
            {
                if (BDCommon.g_ManageDB.IsDoubleMatch(m_nCurMatchID) == 1)
                {
                    System.Diagnostics.Trace.WriteLine("StartMatch:设置比赛为双打！");
                    m_bIsDoubleMatch = true;
                    List<int> ids = new List<int>();
                    if (BDCommon.g_ManageDB.GetDoubleMatchPlayerIDs(m_nCurMatchID, ref ids))
                    {
                        m_nDoubleRegisterA1 = ids[0];
                        m_nDoubleRegisterA2 = ids[1];
                        m_nDoubleRegisterB1 = ids[2];
                        m_nDoubleRegisterB2 = ids[3];

                    }
                }
                else
                {
                    System.Diagnostics.Trace.WriteLine("StartMatch:设置比赛为单打！");
                    m_bIsDoubleMatch = false;
                }
                System.Diagnostics.Trace.WriteLine("StartMatch:设置比赛为个人赛！");
                m_bIsTeamMatch = false;
            }
            else
            {
                if (BDCommon.g_ManageDB.IsDoubleMatch(m_nCurMatchID, 1) == 1)
                {
                    System.Diagnostics.Trace.WriteLine("StartMatch:设置比赛为双打！");
                    m_bIsDoubleMatch = true;
                    List<int> ids = new List<int>();
                    if (BDCommon.g_ManageDB.GetDoubleMatchPlayerIDs(m_nCurMatchID, ref ids, 1))
                    {
                        m_nDoubleRegisterA1 = ids[0];
                        m_nDoubleRegisterA2 = ids[1];
                        m_nDoubleRegisterB1 = ids[2];
                        m_nDoubleRegisterB2 = ids[3];

                    }
                }
                else
                {
                    System.Diagnostics.Trace.WriteLine("StartMatch:设置比赛为单打！");
                    m_bIsDoubleMatch = false;
                }
                System.Diagnostics.Trace.WriteLine("StartMatch:设置比赛为团体赛！");
                m_bIsTeamMatch = true;
            }
            lbCourtName.Text = BDCommon.g_ManageDB.GetMatchCourtName(m_nCurMatchID);
            lbMatchID.Text = m_nCurMatchID.ToString();
            lbMatchRsc.Text = BDCommon.g_ManageDB.GetRscStringFromMatchID(m_nCurMatchID);
            lbRuleName.Text = BDCommon.g_ManageDB.GetMatchRuleName(m_nCurMatchID);
            chkManual.Checked = false;
            chkEnableInput.Checked = false;
        }

        void InitVariants()
        {
            BDCommon.g_ManageDB.InitDiscipline();

            m_nCurMatchType = -1;
            m_nCurStatusID = -1;
            m_nCurGameID = -1;
            m_nCurTeamSplitID = -1;
            m_nGamesCount = -1;
            m_nTeamSplitCount = -1;
            m_nCurPlayIDA = -1;
            m_nCurPlayIDB = -1;
            m_nRegIDA = -1;
            m_nRegIDB = -1;
            m_nRegAPos = -1;
            m_nRegBPos = -1;

            //m_rbtnCurChkedGame = null;
            //m_rbtnCurChkedSplit = null;
            m_nCurGameOffset = -1;
            m_nCurSplitOffset = -1;
        }

        bool InitSubMatchSplits()
        {
            Int32 nGamesCount = 0, nTeamSplitCount = 0;

            // Check validation of the match splits count in database, according to the match rule
            if (BDCommon.g_ManageDB.GetMatchSplitCount(m_nCurMatchID, m_nCurMatchType, ref nGamesCount, ref nTeamSplitCount))
            {
                if (m_nGamesCount == nGamesCount && m_nGamesCount != 0)                    
                    return true;
            }

            // Create new match splits
            if (1 != BDCommon.g_ManageDB.CreateMatchSplit(m_nCurMatchID, m_nCurMatchType, m_nGamesCount, m_nTeamSplitCount))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbCreateSplit"));
                EnableMatchInfo(false, false);
                EnableMatchCtrlBtn(false);
                return false;
            }

            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emSplitAdd, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            
 
            return true;
        }

        void InitMatchDes()
        {
            String strSportDes, strPhaseDes, strDateDes, strVenueDes, strPlayNameA, strPlayNameB, strHomeScore, strAwayScore;
            BDCommon.g_ManageDB.GetOneMatchDes(m_nCurMatchID, out m_nCurPlayIDA, out m_nCurPlayIDB, out strPlayNameA, out strPlayNameB, out m_nCurStatusID,
                out strSportDes, out strPhaseDes, out strDateDes, out strVenueDes, out strHomeScore, out strAwayScore, out m_nRegAPos, out m_nRegBPos);

            //lb_SportDes.Text = strSportDes;
            lb_PhaseDes.Text = strPhaseDes;
            lb_DateDes.Text = strDateDes;
           // lb_VenueDes.Text = strVenueDes;
            lb_HomeDes.Text = strPlayNameA;
            lb_AwayDes.Text = strPlayNameB;

            lb_Home_Score.Text = strHomeScore.Equals("") ? "0" : strHomeScore;
            lb_Away_Score.Text = strAwayScore.Equals("") ? "0" : strAwayScore;

            UI_MatchScoreToGamesTotal();
        }

        bool InitPlayerInfo()
        {
            Int32 nSplitID = -1;
            if (m_nCurMatchType == BDCommon.MATCH_TYPE_TEAM)
            {
                nSplitID = m_nCurTeamSplitID;
            }
            else 
            {
                nSplitID = m_nCurGameID;
            }
            if (nSplitID <= 0) return false;

            // Get PlayerName
            STableRecordSet stRecords;
            if (!BDCommon.g_ManageDB.GetMatchSplitResult(m_nCurMatchID, nSplitID, out stRecords)) return false;

            Int32 nPlayCount = stRecords.GetRecordCount();

            if(nPlayCount == 2)
            {
                Int32 nRegAID = stRecords.GetFieldValue(0, "F_RegisterID") == String.Empty ? 0 : Convert.ToInt32(stRecords.GetFieldValue(0, "F_RegisterID"));
                Int32 nRegBID = stRecords.GetFieldValue(1, "F_RegisterID") == String.Empty ? 0 : Convert.ToInt32(stRecords.GetFieldValue(1, "F_RegisterID"));
                String strName, strNOC;

                if (m_nCurMatchType == BDCommon.MATCH_TYPE_TEAM && (nRegAID <= 0 || nRegBID <= 0))
                {
                    return false;
                }

                if (BDCommon.g_ManageDB.GetPlayerInfo(nRegAID, out strName, out strNOC))
                {
                    m_nRegIDA = nRegAID;
                    lb_PlayerA.Text = strName;
                    lb_NOCA.Text = strNOC;
                    //由于团体双打是临时组合，没有代表团，因此如果是临时组合，取Team的delegation Code
                    if ( string.IsNullOrEmpty( strNOC ) )
                    {
                        string strTeamName, strTeamNoc;
                        if ( BDCommon.g_ManageDB.GetPlayerInfo( m_nCurPlayIDA, out strTeamName, out strTeamNoc) )
                        {
                            lb_NOCA.Text = strTeamNoc;
                        }
                    }
                }

                if (BDCommon.g_ManageDB.GetPlayerInfo(nRegBID, out strName, out strNOC))
                {
                    m_nRegIDB = nRegBID;
                    lb_PlayerB.Text = strName;
                    lb_NOCB.Text = strNOC;
                    //由于团体双打是临时组合，没有代表团，因此如果是临时组合，取Team的delegation Code
                    if (string.IsNullOrEmpty(strNOC))
                    {
                        string strTeamName, strTeamNoc;
                        if (BDCommon.g_ManageDB.GetPlayerInfo(m_nCurPlayIDB, out strTeamName, out strTeamNoc))
                        {
                            lb_NOCB.Text = strTeamNoc;
                        }
                    }
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
            if (!BDCommon.g_ManageDB.GetSubSplitInfo(m_nCurMatchID, 0, out stRecords)) return false;

            Int32 nCount = stRecords.GetRecordCount();
            for (Int32 i = 0; i < nCount; i++)
            {
                String strID = stRecords.GetFieldValue(i, "F_MatchSplitID");
                m_naTeamSplitIDs.Add(Convert.ToInt32(strID));
            }

            return true;
        }

        bool LoadGameSplitIDs(Int32 nFatherSplitID)
        {
            m_naGameIDs.Clear();

            STableRecordSet stRecords;
            if (!BDCommon.g_ManageDB.GetSubSplitInfo(m_nCurMatchID, nFatherSplitID, out stRecords)) return false;

            Int32 nGamesCount = stRecords.GetRecordCount();
            for (Int32 i = 0; i < nGamesCount; i++)
            {
                String strID = stRecords.GetFieldValue(i, "F_MatchSplitID");
                m_naGameIDs.Add(Convert.ToInt32(strID));
            }

            return true;
        }

        private void UpdateMatchStatus(bool bAllowReCalculateResult = true)
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
                case BDCommon.STATUS_SCHEDULE:
                    {
                        btnx_StartList.Enabled = true;
                        btnx_Unofficial.Enabled = true;
                        btnx_Finished.Enabled = true;
                        btnx_Schedule.Checked = true;
                        btnx_Status.Text = btnx_Schedule.Text;
                        btnx_Status.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                case BDCommon.STATUS_STARTLIST:
                    {
                        chkEnableInput.Checked = false;
                        chkEnableInput.Enabled = false;
                        if (m_nGamesCount > 0 && m_nTeamSplitCount >= 0)
                        {
                            btnx_Running.Enabled = true;
                        }

                        btnx_StartList.Checked = true;
                        btnx_Status.Text = btnx_StartList.Text;
                        btnx_Status.ForeColor = System.Drawing.SystemColors.ControlText;
                        BDCommon.g_ManageDB.SetCurrentSplitFlag(m_nCurMatchID, 1, 1);//设置比赛即将开始状态
                        break;
                    }
                case BDCommon.STATUS_RUNNING:
                    {
                        //chkEnableInput.Checked = false;
                        chkEnableInput.Enabled = true;
                        btnx_Suspend.Enabled = true;
                        btnx_Unofficial.Enabled = true;

                        if (bAllowReCalculateResult)
                        {
                            UpdateAllMatchSplitStatus(BDCommon.STATUS_RUNNING);
                        }

                        btnx_Running.Checked = true;
                        btnx_Status.Text = btnx_Running.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.Red;
                        
                        if ( chkEnableInput.Checked)
                        {
                            BDCommon.g_ManageDB.SetCurrentSplitFlag(m_nCurMatchID, 1, 2);//设置比赛运行状态
                        }
                        break;
                    }
                case BDCommon.STATUS_SUSPEND:
                    {
                       // EnableMatchAll(false, false);

                        btnx_Running.Enabled = true;
                        btnx_Suspend.Checked = true;
                        btnx_Status.Text = btnx_Suspend.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.Red;
                        break;
                    }
                case BDCommon.STATUS_UNOFFICIAL:
                    {
                        Int32 iPhaseID = BDCommon.g_ManageDB.GetPhaseID(m_nCurMatchID);
                        chkEnableInput.Checked = false;
                        chkEnableInput.Enabled = false;
                        //EnableMatchAll(false, false);

                        if (bAllowReCalculateResult)
                        {
                            BDCommon.g_ManageDB.UpdateMatchRankSets(m_nCurMatchID);
                            BDCommon.g_ManageDB.CreateGroupResult(m_nCurMatchID);
                            OVRDataBaseUtils.AutoProgressMatch(m_nCurMatchID, BDCommon.g_adoDataBase.m_dbConnect, BDCommon.g_BDPlugin);//自动晋级
                            BDCommon.g_ManageDB.SetPhaseCompetitors(iPhaseID);
                        }

                        btnx_Finished.Enabled = true;
                        btnx_Revision.Enabled = true;
                        btnx_Unofficial.Checked = true;
                        btnx_Status.Text = btnx_Unofficial.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;

                        if ( bAllowReCalculateResult )
                        {
                            BDCommon.g_ManageDB.UpdateAllSplitStatus(m_nCurMatchID, m_nCurStatusID);
                            BDCommon.g_ManageDB.SetCurrentSplitFlag(m_nCurMatchID, -1, 3);//设置比赛结束

                           // BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);

                            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, iPhaseID, -1, iPhaseID, null);
                            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                        }
                        
                        break;
                    } 
                case BDCommon.STATUS_FINISHED:
                    {
                        Int32 iPhaseID = BDCommon.g_ManageDB.GetPhaseID(m_nCurMatchID);
                        chkEnableInput.Checked = false;
                        chkEnableInput.Enabled = false;
                        if (m_nCurMatchType != BDCommon.MATCH_TYPE_TEAM)
                        {
                            GetAllGamesResultFromDB();
                        }

                        if ( bAllowReCalculateResult )
                        {
                            BDCommon.g_ManageDB.UpdateMatchRankSets(m_nCurMatchID);
                            BDCommon.g_ManageDB.CreateGroupResult(m_nCurMatchID);
                            OVRDataBaseUtils.AutoProgressMatch(m_nCurMatchID, BDCommon.g_adoDataBase.m_dbConnect, BDCommon.g_BDPlugin);//自动晋级
                            BDCommon.g_ManageDB.SetPhaseCompetitors(iPhaseID);
                        }
                        
                        btnx_Revision.Enabled = true;
                        btnx_Finished.Checked = true;
                        btnx_Status.Text = btnx_Finished.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        if ( bAllowReCalculateResult)
                        {
                            BDCommon.g_ManageDB.UpdateAllSplitStatus(m_nCurMatchID, m_nCurStatusID);
                            BDCommon.g_ManageDB.SetCurrentSplitFlag(m_nCurMatchID, -1, 3);//设置比赛结束

                           // BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                            
                            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emPhaseResult, -1, -1, iPhaseID, -1, iPhaseID, null);
                            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                        }
                        break;
                    }
                case BDCommon.STATUS_REVISION:
                    {
                        //EnableMatchAll(true, false);
                        chkEnableInput.Enabled = true;
                        if (m_nCurMatchType != BDCommon.MATCH_TYPE_TEAM)
                        {
                            GetAllGamesResultFromDB();
                        }

                        btnx_Finished.Enabled = true;
                        btnx_Revision.Checked = true;
                        btnx_Status.Text = btnx_Revision.Text;
                        btnx_Status.ForeColor = System.Drawing.Color.LimeGreen;
                        BDCommon.g_ManageDB.SetCurrentSplitFlag(m_nCurMatchID, 1, 2);//设置比赛运行状态
                        break;
                    }
                case BDCommon.STATUS_CANCELED:
                    {
                        chkEnableInput.Checked = false;
                        chkEnableInput.Enabled = false;
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

            LoadGameSplitIDs(m_nCurTeamSplitID);

            if (!InitPlayerInfo())
            {
                EnableSplitInfo(false, true);
                EnableGameDetail(false, true);
                CheckedTeamSplitRbtn(0);

                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbSetTeamPlayers"));
                return false;
            }

            GetAllGamesResultFromDB();

            // Select 1st Game
            CheckedTeamSplitRbtn(nSplit + 1);
            EnableGameDetail(true, false);

            rad_Game1.Checked = true;
            m_nCurGameOffset = 0;
            m_nCurGameID = (Int32)m_naGameIDs[0];
            UpdateAllMatchSplitStatus(BDCommon.STATUS_RUNNING);
            return true;
        }

        void UI_MatchScoreToGamesTotal()
        {
            if (m_nCurMatchType == BDCommon.MATCH_TYPE_TEAM || m_nCurMatchType <= 0) return;

            lb_A_GameTotal.Text = lb_Home_Score.Text;
            lb_B_GameTotal.Text = lb_Away_Score.Text;

          //  BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        bool GetAllGamesResultFromDB()
        {
            STableRecordSet stRecords;
            Int32 nGamesCount = m_naGameIDs.Count;

            for (Int32 i = 0; i < nGamesCount; i++)
            {
                Int32 nSplitID = (Int32)m_naGameIDs[i];

                // Update the Result
                if (BDCommon.g_ManageDB.GetMatchSplitResult(m_nCurMatchID, nSplitID, out stRecords))
                {
                    if (stRecords.GetRecordCount() != 2)
                        return false;

                    String strSplitPointsA = stRecords.GetFieldValue(0, "F_Points");
                    String strSplitPointsB = stRecords.GetFieldValue(1, "F_Points");

                    String strEditVarNameA = "lb_A_Game" + (i + 1).ToString();
                    String strEditVarNameB = "lb_B_Game" + (i + 1).ToString();

                    Type dlgType = typeof(frmOVRBDDataEntry);
                    Label editBoxA = (Label)ReflectVar(dlgType, strEditVarNameA);
                    Label editBoxB = (Label)ReflectVar(dlgType, strEditVarNameB);
                    if (editBoxA != null && editBoxB != null)
                    {
                        editBoxA.Text = strSplitPointsA == String.Empty ? "0" : strSplitPointsA;
                        editBoxB.Text = strSplitPointsB == String.Empty ? "0" : strSplitPointsB;
                    }
                    if ( IsDouble())
                    {
                        if ( editBoxA.Text == "0" && editBoxB.Text == "0" )
                        {
                            rad_ServerA.Enabled = true;
                            rad_ServerB.Enabled = true;
                            rad_ServerA.Checked = false;
                            rad_ServerB.Checked = false;
                        }
                    }
                }
            }

            // Update GameTotalScore to UI
            if (m_nCurMatchType == BDCommon.MATCH_TYPE_TEAM)
            {
                UpdateTeamSplitResult(true);
            }
            else
            {
                UI_MatchScoreToGamesTotal();
            }


            return true;
        }

        bool SetCurOneGameResultToDB(Int32 nPointA, Int32 nPointB)
        {
            if (!m_CurMatchRule.IsValidGameScore(nPointA, nPointB)) return false;

            Int32 nRankA = -1, nRankB = -1, nResultA = -1, nResultB = -1;
            bool bFinish = m_CurMatchRule.IsGameScoreFinished(nPointA, nPointB);

            if (bFinish)
            {
                m_CurMatchRule.PointsToRankResult(nPointA, nPointB, out nRankA, out nRankB, out nResultA, out nResultB);
            }

            if (!BDCommon.g_ManageDB.SetMatchSplitPointsAndResults(m_nCurMatchID, m_nCurGameID, m_nRegAPos, nPointA, nResultA, nRankA, bFinish))
                return false;
            if (!BDCommon.g_ManageDB.SetMatchSplitPointsAndResults(m_nCurMatchID, m_nCurGameID, m_nRegBPos, nPointB, nResultB, nRankB, bFinish))
                return false;

            if (bFinish)
            {
                CountGamesTotalToUI();
                UIGamesTotal2MatchResultsToDB();
            }

          //  BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            
            return true;
        }

        bool UpdateService(bool bFromDB)
        {
            if (m_nCurGameID <= 0) return false;
            STableRecordSet stRecords;

            if (bFromDB)
            {
                // Update the Service
                if (!BDCommon.g_ManageDB.GetMatchSplitResult(m_nCurMatchID, m_nCurGameID, out stRecords)) return false;

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
                bool bResultA = BDCommon.g_ManageDB.SetMatchSplitService(m_nCurMatchID, m_nCurGameID, m_nRegAPos, m_bAService);
                bool bResultB = BDCommon.g_ManageDB.SetMatchSplitService(m_nCurMatchID, m_nCurGameID, m_nRegBPos, m_bBService);
                if (!bResultA || !bResultB)
                {
                    MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbUpdateServer"));
                    return false;
                }
            }
            //这里暂时不需要，于2011-1-10注释掉
            //BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            return true;
        }

        bool UpdateTeamSplitResult(bool bFromDB)
        {
            if (m_nCurTeamSplitID <= 0 || m_nCurMatchType != BDCommon.MATCH_TYPE_TEAM) return false;

            STableRecordSet stRecords;
            Int32 nTeamSplitID = m_nCurTeamSplitID;

            if (bFromDB)
            {
                // Update the Result
                if (BDCommon.g_ManageDB.GetMatchSplitResult(m_nCurMatchID, nTeamSplitID, out stRecords))
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
                bool bRet = CountGamesTotalToUI();
                if (bRet)
                    UIGamesTotal2MatchResultsToDB();

                return bRet;
            }

            return false;
        }

        bool CountGamesTotalToUI() // Count GamesTotal Score from all games, then update to UI
        {
            Int32 nTotalScoreA = 0;
            Int32 nTotalScoreB = 0;
            Int32 nSplitOffset = m_nCurSplitOffset == -1 ? 0 : m_nCurSplitOffset;

            Int32 nTeamSplitID = m_nCurMatchType == BDCommon.MATCH_TYPE_TEAM ? m_nCurTeamSplitID : 0;

            if (!m_CurMatchRule.GetGamesTotalFromGames(nTeamSplitID, ref nTotalScoreA, ref nTotalScoreB)) return false;

            lb_A_GameTotal.Text = nTotalScoreA.ToString();
            lb_B_GameTotal.Text = nTotalScoreB.ToString();

            return true;
        }

        void UIGamesTotal2MatchResultsToDB()
        {
	        String strGameATScore, strGameBTScore;
            Int32 nGameATScore, nGameBTScore;

            strGameATScore = lb_A_GameTotal.Text;
            strGameBTScore = lb_B_GameTotal.Text;
            nGameATScore = BDCommon.Str2Int(strGameATScore);
            nGameBTScore = BDCommon.Str2Int(strGameBTScore);

	        if (m_nCurMatchType == BDCommon.MATCH_TYPE_TEAM && m_nCurTeamSplitID > 0)
	        {
                if (!m_CurMatchRule.UpdateTeamSplitResultsToDB(m_nCurTeamSplitID, nGameATScore, nGameBTScore, m_nRegAPos, m_nRegBPos))
		        {
			        UpdateTeamSplitResult(true); // Recover if not valid
			        return;
		        }

                if (m_CurMatchRule.IsGamesTotalScoreFinished(nGameATScore, nGameBTScore))
                {
		            // Statistic Match Score and Update to DB
		            Int32 nMatchScoreA = 0;
		            Int32 nMatchScoreB = 0;
                    if (m_CurMatchRule.GetMatchScoreFromTeamSplits(ref nMatchScoreA, ref nMatchScoreB))
		            {
			            // Update match result
                        if (m_CurMatchRule.UpdateMatchResultsToDB(nMatchScoreA, nMatchScoreB, m_nRegAPos, m_nRegBPos))
			            {
                            lb_Home_Score.Text = nMatchScoreA.ToString();
                            lb_Away_Score.Text = nMatchScoreB.ToString();
			            }
		            }
                    //还应该更新TeamSplit的状态
                    BDCommon.g_ManageDB.SetMatchSplitStatus(m_nCurMatchID, m_nCurTeamSplitID, BDCommon.STATUS_FINISHED);
                }
                else
                {
                    BDCommon.g_ManageDB.SetMatchSplitStatus(m_nCurMatchID, m_nCurTeamSplitID, BDCommon.STATUS_RUNNING);
                }

                EnableTeamSplitRbtn(true, false);
                EnableGamesRbtnsAndLabels(true, false);
	        }
	        else
	        { 
		        // Update match result
                if (m_CurMatchRule.UpdateMatchResultsToDB(nGameATScore, nGameBTScore, m_nRegAPos, m_nRegBPos))
		        {
                    lb_Home_Score.Text = strGameATScore;
                    lb_Away_Score.Text = strGameBTScore;
		        }
		        else // Recover from Match result
		        {
			        UI_MatchScoreToGamesTotal();
		        }

                EnableGamesRbtnsAndLabels(true, false);
	        }
        }

        //Action GamePoint MatchPoint
        bool AddActionList(Int32 nPosition, Int32 nRegisterID, Int32 nResultA, Int32 nResultB, Int32 nScore)
        {
            Int32 nPointType;
            Int32 nActionID;

            Int32 nMatchA = BDCommon.Str2Int(lb_A_GameTotal.Text);
            Int32 nMatchB = BDCommon.Str2Int(lb_B_GameTotal.Text);

            m_CurMatchRule.StatGameMatchPoint(nResultA, nResultB, nMatchA, nMatchB, out nPointType);
            nActionID = BDCommon.g_ManageDB.GetActionID(BDCommon.strAction_addScore);

            if ( IsDouble())
            {
                BDCommon.g_ManageDB.AddDoubleActionList(nPosition, m_nCurMatchID, m_nCurGameID, m_nDoubleRegisterA1,
                    m_nDoubleRegisterA2, m_nDoubleRegisterB1, m_nDoubleRegisterB2, nScore);
            }
            else
            {
                BDCommon.g_ManageDB.AddActionList(nPosition, m_nCurMatchID, m_nCurGameID, nRegisterID, nActionID, nScore, nPointType);
            }
            

            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatistic, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            return true;
        }

        bool DelActionList(Int32 nPosition, Int32 nRegisterID, Int32 nDelScore)
        {
            if ( IsDouble() )
            {
                BDCommon.g_ManageDB.DelActionList(nPosition, m_nCurMatchID, m_nCurGameID, nRegisterID, 2, nDelScore);
            }
            else
            {
                BDCommon.g_ManageDB.DelActionList(nPosition, m_nCurMatchID, m_nCurGameID, nRegisterID, 1, nDelScore);
            }
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatistic, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            return true;
        }

        //Split Status
        void UpdateAllMatchSplitStatus(Int32 nCurSplitStatus)
        {
            //BDCommon.g_ManageDB.ClearAllMatchSplitStatus(m_nCurMatchID);
            if ( m_nCurGameID <= 0 || m_nCurMatchID <= 0 )
            {
                return;
            }
            BDCommon.g_ManageDB.SetMatchSplitStatus(m_nCurMatchID, m_nCurGameID, nCurSplitStatus);
            
            
            BDCommon.g_BDPlugin.DataChangedNotify(OVRDataChangedType.emSplitInfo, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }
        
        //比赛信息导入导出
        void InitDateList()
        {
            cmbFilterDate.DataSource = null;
            cmbFilterDate.Items.Clear();

            if (!BDCommon.g_ManageDB.GetDisciplineDateList(cmbFilterDate)) return;
        }

        void ExportAthleteXml()
        {
            String strExportPath = tbExportPath.Text;
            if (!Directory.Exists(strExportPath))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "msgExportPath"));
                return;
            }

            String strExportFile = strExportPath.TrimEnd('\\') + "\\" + BDCommon.g_strExAthleteFileName + ".xml";
            
            string strXml = BDCommon.g_ManageDB.ExportAthleteXml(strExportFile);
            if( strXml == "" )
            {
                DevComponents.DotNetBar.MessageBoxEx.Show("Export athlete xml file failed!The data returned by db is empty.");
            }
            else if( strXml == null )
            {
                DevComponents.DotNetBar.MessageBoxEx.Show("An exception occured during exporting athlete xml file!");
            }
            else
            {
                try
                {
                    File.WriteAllText(strExportFile, strXml, System.Text.Encoding.UTF8);
                    DevComponents.DotNetBar.MessageBoxEx.Show("Export athlete xml file succeed!");
                }
                catch (System.Exception e)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(e.ToString());
                }
            }

            
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
            String strExportFile = strExportPath.TrimEnd('\\') + "\\" + BDCommon.g_strExSchduleFileName + strDate + ".xml";
            string strOut = BDCommon.g_ManageDB.ExportScheduleXml(strExportFile, nDateID);
            if ( strOut == "" )
            {
                DevComponents.DotNetBar.MessageBoxEx.Show("Export schedule xml file failed!The data returned by db is empty.");
            }
            else if ( strOut == null )
            {
                DevComponents.DotNetBar.MessageBoxEx.Show("An exception occured during exporting athlete xml file!");
            }
            else
            {
                try
                {
                    File.WriteAllText(strExportFile, strOut, System.Text.Encoding.UTF8);
                    DevComponents.DotNetBar.MessageBoxEx.Show("Export schedule xml file succeed!");
                }
                catch (System.Exception e)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(e.ToString());
                }
            }
        }

        string ExportScheduleXml2()
        {
            String strExportPath = tbExportPath.Text;
            if (!Directory.Exists(strExportPath))
            {
                return string.Format("{0}不存在", strExportPath);
            }

            if (cmbFilterDate.SelectedIndex < 0)
            {
                return string.Format("未选择导出的日期");
            }

            String strDate = cmbFilterDate.Text;
            Int32 nDateID = Convert.ToInt32(cmbFilterDate.SelectedValue);

            if (strDate.Length == 10)
            {
                strDate = strDate.Substring(2, strDate.Length - 2);
            }

            strDate = strDate.Replace("-", "");
            String strExportFile = strExportPath.TrimEnd('\\') + "\\" + BDCommon.g_strExSchduleFileName + strDate + ".xml";
            string strOut = BDCommon.g_ManageDB.ExportScheduleXml(strExportFile, nDateID);
            if (strOut == "")
            {
                return "Export schedule xml file failed!The data returned by db is empty.";
            }
            else if (strOut == null)
            {
                return "An exception occured during exporting athlete xml file!";
            }
            else
            {
                try
                {
                    File.WriteAllText(strExportFile, strOut, System.Text.Encoding.UTF8);
                    return "";
                }
                catch (System.Exception e)
                {
                    return string.Format("发生错误：{0}",e.ToString());
                }
            }
        }
       
    }
}
