
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
namespace AutoSports.OVRARPlugin
{
    public delegate void ARDataEntryUpdatedMatchInfo(AR_MatchInfo matchInfo);

    public partial class OVRARDataEntryForm : Office2007Form
    {
        public int m_nCurMatchID = -1;
        AR_MatchInfo CurMatchInfo = new AR_MatchInfo();
        public ARDataEntryUpdatedMatchInfo UpdatedMainFormMatchInfo;

        public OVRARDataEntryForm()
        {
            InitializeComponent();
        }

        #region 初始化
        private void Localization()
        {
            this.labX_MatchInfo.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_OVRARDataEntryForm_labX_MatchInfo");
            this.btnX_MatchSetting.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_OVRARDataEntryForm_btnX_MatchSetting");
            this.btnX_StatusSetting.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_OVRARDataEntryForm_btnX_StatusSetting");
            this.btnX_Exit.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_OVRARDataEntryForm_btnX_Exit");

            this.btnX_Draw.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_OVRARDataEntryForm_btnX_Edit");
            this.btnXOfficials.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_OVRARDataEntryForm_btnX_Officials");
            this.cbInterFace.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_OVRARDataEntryForm_labX_Interface");
            this.btnX_CheckResults.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_OVRARDataEntryForm_btnX_Check");
        
        }

        private void OVRARDataEntryForm_Load(object sender, EventArgs e)
        {
            GVAR.g_ManageDB.InitGame();
            Localization();
            this.UpdatedMainFormMatchInfo = new ARDataEntryUpdatedMatchInfo(UpdateMatchInfo);
            if (cbInterFace.Checked)
            {
                try
                {
                    ARUdpService.Start();
                }
                catch
                {
                    return;
                }
            }
        }

        public void OnMsgFlushSelMatch(int nWndMode, int nMatchID)
        {
            if (nMatchID <= 0)
            {
                MessageBoxEx.Show(LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "SelectMatchInfo"));
                return;
            }
            if (nMatchID == m_nCurMatchID)
                return;

            m_nCurMatchID = nMatchID;
            CurMatchInfo = AREntityOperation.GetCurMatchInfo(nMatchID);

            labX_MatchInfo.Text = CurMatchInfo.GetDisplayName();
            this.UpdateMatchStatus();

            InitMatchUserControl();


        }

        //初始化用户控件，排位赛/淘汰赛
        private void InitMatchUserControl()
        {
            panelEx4.Controls.Clear();
            if (CurMatchInfo.MatchCode == "QR")
            {
                UCQualification UCQualification = new AutoSports.OVRARPlugin.UCQualification(m_nCurMatchID);
                UCQualification.m_nCurMatchID = m_nCurMatchID;
                UCQualification.CurMatchInfo = this.CurMatchInfo;
                UCQualification.UpdatedMainFormMatchInfo = this.UpdatedMainFormMatchInfo;
                panelEx4.Controls.Add(UCQualification);

            }
            else
            {
                UCElimination UCElimination = new AutoSports.OVRARPlugin.UCElimination(m_nCurMatchID);
                UCElimination.m_nCurMatchID = m_nCurMatchID;
                UCElimination.CurMatchInfo = this.CurMatchInfo;
                UCElimination.UpdatedMainFormMatchInfo = this.UpdatedMainFormMatchInfo;
                panelEx4.Controls.Add(UCElimination);
            }
        }
        #endregion

        #region 报表
        /// 报表
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

        #region 比赛状态设置
        private void buttonItem_Scheduled_Click(object sender, EventArgs e)
        {
            SetttingMatchStatus(30);
        }
        private void buttonItem_StartList_Click(object sender, EventArgs e)
        {
            SetttingMatchStatus(40);
        }
        private void buttonItem_Running_Click(object sender, EventArgs e)
        {
            SetttingMatchStatus(50);
        }
        private void buttonItem_Suspend_Click(object sender, EventArgs e)
        {
            SetttingMatchStatus(60);
        }
        private void buttonItem_Unofficial_Click(object sender, EventArgs e)
        {
            SetttingMatchStatus(100);
        }
        private void buttonItem_Finished_Click(object sender, EventArgs e)
        {
            SetttingMatchStatus(110);
        }
        private void buttonItem_Revision_Click(object sender, EventArgs e)
        {
            SetttingMatchStatus(120);
        }
        private void buttonItem_Canceled_Click(object sender, EventArgs e)
        {
            SetttingMatchStatus(130);
        }

        private bool SetttingMatchStatus(int nMatchStatusID)
        {
            bool bReturn = GVAR.g_ManageDB.UpdateMatchStatus(m_nCurMatchID, nMatchStatusID);
            if (nMatchStatusID == 110 && bReturn)
            {
                bReturn = GVAR.g_ManageDB.AutoProgressMatch(m_nCurMatchID);
            }
            if (bReturn)
            {
                CurMatchInfo.MatchStatusID = nMatchStatusID;
                this.UpdateMatchStatus();
                if (CurMatchInfo.MatchCode == "QR")
                {
                    ((UCQualification)this.panelEx4.Controls[0]).UpdatedUserControlsHandler.Invoke(CurMatchInfo);
                }
                else
                {
                    ((UCElimination)this.panelEx4.Controls[0]).UpdatedUserControlsHandler.Invoke(CurMatchInfo);
                }

                GVAR.g_ARPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatus, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }

            return bReturn;
        }

        private void UpdateMatchStatus()
        {
            switch (CurMatchInfo.MatchStatusID)
            {
                case 30:
                    this.btnX_StatusSetting.Text = this.buttonItem_Scheduled.Text;
                    break;
                case 40:
                    this.btnX_StatusSetting.Text = this.buttonItem_StartList.Text;
                    break;
                case 50:
                    this.btnX_StatusSetting.Text = this.buttonItem_Running.Text;
                    break;
                case 60:
                    this.btnX_StatusSetting.Text = this.buttonItem_Suspend.Text;
                    break;
                case 100:
                    this.btnX_StatusSetting.Text = this.buttonItem_Unofficial.Text;
                    break;
                case 110:
                    this.btnX_StatusSetting.Text = this.buttonItem_Finished.Text;
                    break;
                case 120:
                    this.btnX_StatusSetting.Text = this.buttonItem_Revision.Text;
                    break;
                case 130:
                    this.btnX_StatusSetting.Text = this.buttonItem_Canceled.Text;
                    break;
                default:
                    this.btnX_StatusSetting.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_OVRARDataEntryForm_btnX_StatusSetting");
                    break;
            }
        }
        #endregion

        #region 规则设置
        private void btnX_MatchSetting_Click(object sender, EventArgs e)
        {
            if (CurMatchInfo.MatchStatusID < 100 && CurMatchInfo.MatchStatusID > 0)
            {
                if (m_nCurMatchID <= 0)
                    return;

                MatchSettingFrom frmMatchSetting = new MatchSettingFrom();
                frmMatchSetting.CurMatchInfo = this.CurMatchInfo;
                frmMatchSetting.ShowDialog();
                if (frmMatchSetting.DialogResult == DialogResult.OK)
                {
                    if (frmMatchSetting.CurMatchInfo.EndCount != CurMatchInfo.EndCount ||
                        frmMatchSetting.CurMatchInfo.ArrowCount != CurMatchInfo.ArrowCount)
                    {
                        this.CurMatchInfo = frmMatchSetting.CurMatchInfo;
                        this.InitMatchUserControl();
                    }
                }
                else if (frmMatchSetting.DialogResult == DialogResult.Yes)
                {
                    this.InitMatchUserControl();
                }
            }
        }

        private void UpdateMatchInfo(AR_MatchInfo curMatchInfo)
        {
            this.CurMatchInfo = curMatchInfo;
        }
        #endregion

        #region 退出比赛
        private void btnX_Exit_Click(object sender, EventArgs e)
        {
            m_nCurMatchID = -1;
            CurMatchInfo.EventCode = "";
            CurMatchInfo.PhaseCode = "";
            CurMatchInfo.MatchCode = "";
            CurMatchInfo.EndCount = 0;
            CurMatchInfo.ArrowCount = 0;
            CurMatchInfo.MatchStatusID = -1;
            CurMatchInfo.MatchID = -1;
            CurMatchInfo.PhaseID = -1;
            CurMatchInfo.PlayerA = 0;
            CurMatchInfo.PlayerB = 0;
            CurMatchInfo.TargetA = string.Empty;
            CurMatchInfo.TargetB = string.Empty;
            ARUdpService.CurMatchInfo = CurMatchInfo;
            //this.dgv_List.Columns.Clear();
            //this.dgv_List.Rows.Clear();

            this.labX_MatchInfo.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_OVRARDataEntryForm_labX_MatchInfo");
            this.btnX_StatusSetting.Text = LocalizationRecourceManager.GetString(GVAR.g_ARPlugin.GetSectionName(), "OVRARPlugin_OVRARDataEntryForm_btnX_StatusSetting");
            panelEx4.Controls.Clear();
        }
        #endregion

        #region 官员
        private void btnXOfficials_Click(object sender, EventArgs e)
        {
            frmOVROfficialEntry OfficialForm = new frmOVROfficialEntry(m_nCurMatchID);
            OfficialForm.m_strLanguageCode = GVAR.g_strLang;
            OfficialForm.m_iDisciplineID = GVAR.g_ManageDB.GetDisplnID(GVAR.g_strDisplnCode); ;
            OfficialForm.ShowDialog();
        }

        private void btnX_Draw_Click(object sender, EventArgs e)
        {
            frmOVREditEntry m_OVRWLAutoDrawForm = new frmOVREditEntry();
            m_OVRWLAutoDrawForm.Owner = this;
            m_OVRWLAutoDrawForm.ResetRegisterGrid(true);
            m_OVRWLAutoDrawForm.Show();
        }
        private void btnX_CheckResults_Click(object sender, EventArgs e)
        {
            frmOVRCheckResults m_OVRARChecking = new frmOVRCheckResults(CurMatchInfo); 
            m_OVRARChecking.Owner = this;
            m_OVRARChecking.ResetRegisterGrid(true);
            m_OVRARChecking.Show();
        }

        #endregion

        #region 接口

        private void cbInterFace_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                if (cbInterFace.Checked)
                {
                    ARUdpService.Start();
                }
                else ARUdpService.Stop();
            }
            catch
            {
                return;
            }
        }

        #endregion

    }
}
