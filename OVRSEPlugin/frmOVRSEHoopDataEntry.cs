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
    partial class frmOVRSEDataEntry
    {
        private void EnableHoopCtrlBtn(Boolean bEnable, Boolean bClear)
        {
            btnxHoopOfficial.Enabled = bEnable;
            btnxHoopPlayer.Enabled = bEnable;
            btnxHoopExit.Enabled = bEnable;
            btnxHoopStatus.Enabled = bEnable;

            if (bClear)
            {
                lbHoopSportDes.Text = "";
                lbHoopPhaseDes.Text = "";
                lbHoopDate.Text = "";
                lbHoopVenue.Text = "";
                dgvHoopResult.Rows.Clear();
                dgvHoopResult.Columns.Clear();
            }
        }

        void StartHoopMatch()
        {
            if (m_nCurMatchID > 0)
            {
                if (!InitHoopMatch())
                    return;

                m_bIsRunning = true;

                EnableHoopCtrlBtn(true, false);
                FillMatchResultGridView();

                // Update Report Context
                SECommon.g_SEPlugin.SetReportContext("MatchID", m_nCurMatchID.ToString());
            }
        }

        bool InitHoopMatch()
        {
            bool bResult = false;

            if (!SECommon.g_ManageDB.GetMatchRuleID(m_nCurMatchID))
            {
                MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbMatchRule"));
                bResult = false;
            }

            ovrRule = new OVRSERule(m_nCurMatchID);
            m_nCurMatchType = ovrRule.m_nMatchType;
            m_nCurStatusID = ovrRule.m_nMatchStatusID;

            if (!SECommon.g_ManageDB.GetHoopMatchSplitCount(m_nCurMatchID, m_nCurMatchType, ref m_nSetsCount, ref m_nTeamSplitCount))
            {
                m_nSetsCount = ovrRule.m_nSetsCount;
                m_nTeamSplitCount = ovrRule.m_nTeamSplitCount;

                if (1 != SECommon.g_ManageDB.CreateHoopMatchSplit(m_nCurMatchID, m_nCurMatchType, m_nSetsCount, m_nTeamSplitCount))
                {
                    MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbCreateSplit"));
                    EnableHoopCtrlBtn(false, false);
                    bResult = false;
                }

                SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emSplitAdd, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }

            // Load Split IDs
            if (m_nCurMatchType == SECommon.MATCH_TYPE_HOOP)
            {
                bResult = LoadSetSplitIDs(0);
            }

            InitHoopMatchDes();
            UpdateHoopMatchStatus();
            return bResult;
        }

        void InitHoopMatchDes()
        {
            String strPhaseDes, strDateDes, strVenueDes, strPlayNameA;
            SECommon.g_ManageDB.GetHoopMatchDes(m_nCurMatchID, out strPlayNameA, out strPhaseDes, out strDateDes, out strVenueDes);

            lbHoopPhaseDes.Text = strPhaseDes;
            lbHoopDate.Text = strDateDes;
            lbHoopVenue.Text = strVenueDes;
            lbHoopSportDes.Text = strPlayNameA;
        }

        private void btnxHoopOfficial_Click(object sender, EventArgs e)
        {
            frmEntryOfficial frmOfficial = new frmEntryOfficial(m_nCurMatchID, m_nCurMatchType);
            frmOfficial.ShowDialog();
            SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emMatchOfficials, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void btnxHoopPlayer_Click(object sender, EventArgs e)
        {
            frmTeamPlayers frmHomePlayer = new frmTeamPlayers(m_nCurMatchID, m_nCurMatchType, 1);
            frmHomePlayer.ShowDialog();
            FillMatchResultGridView();
            SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emSplitCompetitor, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
        }

        private void btnxHoopExit_Click(object sender, EventArgs e)
        {
            if (!m_bIsRunning) return;

            if (MessageBox.Show(LocalizationRecourceManager.GetString(strSectionName, "mbExitMatch"), "", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                InitVariant();
                m_nCurMatchID = -1;
                m_bIsRunning = false;

                EnableHoopCtrlBtn(false, true);
            }
        }

        private void btnx_HoopStatus_Click(object sender, EventArgs e)
        {
            if (sender == btnx_HoopSchedule)
            {
                m_nCurStatusID = SECommon.STATUS_SCHEDULE;
            }
            else if (sender == btnx_HoopStartList)
            {
                m_nCurStatusID = SECommon.STATUS_STARTLIST;
            }
            else if (sender == btnx_HoopRunning)
            {
                m_nCurStatusID = SECommon.STATUS_RUNNING;
            }
            else if (sender == btnx_HoopSuspend)
            {
                m_nCurStatusID = SECommon.STATUS_SUSPEND;
            }
            else if (sender == btnx_HoopUnOfficial)
            {
                m_nCurStatusID = SECommon.STATUS_UNOFFICIAL;
            }
            else if (sender == btnx_HoopFinished)
            {
                m_nCurStatusID = SECommon.STATUS_FINISHED;
            }
            else if (sender == btnx_HoopRevision)
            {
                m_nCurStatusID = SECommon.STATUS_REVISION;
            }
            else if (sender == btnx_HoopCanceled)
            {
                m_nCurStatusID = SECommon.STATUS_CANCELED;
            }
            else
            {
                return;
            }

            Int32 iResult = OVRDataBaseUtils.ChangeMatchStatus(m_nCurMatchID, m_nCurStatusID, SECommon.g_adoDataBase.m_dbConnect, SECommon.g_SEPlugin);
            if (iResult == 1) UpdateHoopMatchStatus();
        }

        private void dgvHoopResult_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            String strColumnName = dgvHoopResult.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvHoopResult.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                Int32 iRegisterID = GetFieldValue(dgvHoopResult, iRowIndex, "F_RegisterID");

                Int32 iInputValue = 0;
                Int32 iInputKey = 0;
                if (CurCell is DGVCustomComboBoxCell)
                {
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                    iInputKey = Convert.ToInt32(CurCell1.Tag);
                }
                else
                {
                    try
                    {
                        iInputValue = Convert.ToInt32(CurCell.Value);
                        if (iInputValue >= 1 && iInputValue <= 3)
                        {
                            iInputValue *= 10;
                        }
                    }
                    catch (System.Exception ex)
                    {
                        FillMatchResultGridView();
                        return;
                    }
                }
                
                SECommon.g_ManageDB.UpdateHoopMatchResult(m_nCurMatchID, strColumnName, iRegisterID, iInputValue);
                FillMatchResultGridView();
                dgvHoopResult.Rows[iRowIndex].Selected = true;

                SECommon.g_SEPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
            }
        }



        private void FillMatchResultGridView()
        {
            if (m_nCurStatusID < 50)
            {
                SECommon.g_ManageDB.UpdateHoopPlayers(m_nCurMatchID);
            }

            SECommon.g_ManageDB.GetHoopMatchResult(m_nCurMatchID, m_nCurMatchType, dgvHoopResult);
            dgvHoopResult.Columns[0].Width = 0;
            dgvHoopResult.Columns[1].Width = 40;
            dgvHoopResult.Columns[2].Width = 50;
            dgvHoopResult.Columns[3].Width = 40;
            SetGridStyle(dgvHoopResult);
            dgvHoopResult.ClearSelection();
        }

        private void UpdateHoopMatchStatus()
        {
            btnx_HoopSchedule.Checked = false;
            btnx_HoopStartList.Checked = false;
            btnx_HoopRunning.Checked = false;
            btnx_HoopSuspend.Checked = false;
            btnx_HoopUnOfficial.Checked = false;
            btnx_HoopFinished.Checked = false;
            btnx_HoopRevision.Checked = false;
            btnx_HoopCanceled.Checked = false;

            switch (m_nCurStatusID)
            {
                case SECommon.STATUS_SCHEDULE:
                    {
                        btnx_HoopSchedule.Checked = true;
                        btnxHoopStatus.Text = btnx_HoopSchedule.Text;
                        btnxHoopStatus.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                case SECommon.STATUS_STARTLIST:
                    {
                        btnx_HoopStartList.Checked = true;
                        btnxHoopStatus.Text = btnx_HoopStartList.Text;
                        btnxHoopStatus.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                case SECommon.STATUS_RUNNING:
                    {
                        btnx_HoopRunning.Checked = true;
                        btnxHoopStatus.Text = btnx_HoopRunning.Text;
                        btnxHoopStatus.ForeColor = System.Drawing.Color.Red;
                        break;
                    }
                case SECommon.STATUS_SUSPEND:
                    {
                        btnx_HoopSuspend.Checked = true;
                        btnxHoopStatus.Text = btnx_HoopSuspend.Text;
                        btnxHoopStatus.ForeColor = System.Drawing.Color.Red;
                        break;
                    }
                case SECommon.STATUS_UNOFFICIAL:
                    {
                        SECommon.g_ManageDB.CreateHoopPhaseResult(m_nCurMatchID);

                        btnx_HoopUnOfficial.Checked = true;
                        btnxHoopStatus.Text = btnx_HoopUnOfficial.Text;
                        btnxHoopStatus.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case SECommon.STATUS_FINISHED:
                    {
                        SECommon.g_ManageDB.CreateHoopPhaseResult(m_nCurMatchID);

                        btnx_HoopFinished.Checked = true;
                        btnxHoopStatus.Text = btnx_HoopFinished.Text;
                        btnxHoopStatus.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case SECommon.STATUS_REVISION:
                    {
                        btnx_HoopRevision.Checked = true;
                        btnxHoopStatus.Text = btnx_HoopRevision.Text;
                        btnxHoopStatus.ForeColor = System.Drawing.Color.LimeGreen;
                        break;
                    }
                case SECommon.STATUS_CANCELED:
                    {
                        btnx_HoopCanceled.Checked = true;
                        btnxHoopStatus.Text = btnx_HoopCanceled.Text;
                        btnxHoopStatus.ForeColor = System.Drawing.SystemColors.ControlText;
                        break;
                    }
                default:
                    return;
            }
        }

        private void btnxHoopClear_Click(object sender, EventArgs e)
        {
            if ( m_nCurMatchID <= 0 )
            {
                MessageBoxEx.Show("Please enter a match first!");
                return;
            }
            if (DialogResult.Cancel == MessageBoxEx.Show("Are you sure to clear match results?", "warning", MessageBoxButtons.OKCancel, MessageBoxIcon.Question))
            {
                return;
            }
            string strErr = SECommon.g_ManageDB.ClearMatchResultHoop(m_nCurMatchID);
            if (strErr != null)
            {
                MessageBoxEx.Show(strErr);
                return;
            }
            else
            {
                m_nCurStatusID = SECommon.STATUS_SCHEDULE;

                List<OVRDataChanged> changedList = new List<OVRDataChanged>();
                changedList.Add(new OVRDataChanged(OVRDataChangedType.emMatchStatus, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null));
                SECommon.g_SEPlugin.DataChangedNotify(changedList);

                MessageBoxEx.Show("Clear Succeed!");

                InitVariant();
                m_nCurMatchID = -1;
                m_bIsRunning = false;

                EnableHoopCtrlBtn(false, true);
            }
        }
    }
}
