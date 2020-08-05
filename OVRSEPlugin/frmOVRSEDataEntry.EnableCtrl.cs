using System;
using System.Windows.Forms;
using System.Reflection;

namespace AutoSports.OVRSEPlugin
{        	
    // Ctrl Enable, DisEnable and Clear
    partial class frmOVRSEDataEntry
    {
        public Object ReflectVar(Type ParentType, String strVarName)
        {
            FieldInfo fi_Var = ParentType.GetField(strVarName, BindingFlags.Instance | BindingFlags.NonPublic);
            if (fi_Var != null)
            {
                return fi_Var.GetValue(this);
            }

            return null;
        }

        private void EnableMatchCtrlBtn(Boolean bEnable)
        {
            btnx_Official.Enabled = bEnable;
            btnx_Exit.Enabled = bEnable;
            btnx_Status.Enabled = bEnable;
            btnx_HomePlayer.Enabled = bEnable;
            btnx_VisitorPlayer.Enabled = bEnable;
        }

        private void EnableMatchAll(Boolean bEnable, Boolean bClear)
        {
            EnableMatchInfo(bEnable, bClear);
            EnableMatchDetail(bEnable, bClear);
        }

        private void EnableMatchInfo(Boolean bEnable, Boolean bClear)
        {
            if (bClear)
            {
                lb_SportDes.Text = "";
                lb_PhaseDes.Text = "";
                lb_DateDes.Text = "";
                lb_HomeDes.Text = "";
                lb_AwayDes.Text = "";
                lb_Home_Score.Text = "0";
                lb_Away_Score.Text = "0";
            }

            if (m_nCurStatusID == SECommon.STATUS_SCHEDULE && m_bIsRunning == true)
            {
                btnx_Modify_Result.Enabled = true;
            }
            else
            {
                btnx_Modify_Result.Enabled = bEnable;
            }

            if (m_nCurStatusID == SECommon.STATUS_UNOFFICIAL && m_bIsRunning == true)
            {
                btnx_ModifyTime.Enabled = true;
            }
            else
            {
                btnx_ModifyTime.Enabled = bEnable;
            }

            lb_Home_Score.Enabled = bEnable;
            lb_Away_Score.Enabled = bEnable;

            btnx_Home_Add.Enabled = bEnable;
            btnx_Home_Sub.Enabled = bEnable;
            btnx_Away_Add.Enabled = bEnable;
            btnx_Away_Sub.Enabled = bEnable;
        }

        private void CheckedTeamSetRbtn(Int32 nSplitCount)
        {
            btnx_Match1.Checked = nSplitCount == 1 ? true : false;
            btnx_Match2.Checked = nSplitCount == 2 ? true : false;
            btnx_Match3.Checked = nSplitCount == 3 ? true : false;
        }

        private void EnableMatchDetail(Boolean bEnable, Boolean bClear)
        {
            EnableGameDetail(bEnable, bClear);

            if (m_nCurMatchType != SECommon.MATCH_TYPE_TEAM)
            {
                EnableTeamSetRbtn(false, true);
            }
            else
            {
                EnableTeamSetRbtn(bEnable, bClear);
            }
        }

        private void EnableGameDetail(Boolean bEnable, Boolean bClear)
        {
            if (m_naSetIDs.Count > 0)
            {
                EnableStaticBtn(bEnable, bClear);
                EnableGamesRbtn(bEnable, bClear);
                EnalbeGamesResult(bEnable, bClear);
                EnalbeGamesTScore(bEnable, bClear);
                EnableServiceRbtn(bEnable);
            }
            else
            {
                EnableStaticBtn(false, bClear);
                EnableGamesRbtn(false, bClear);
                EnalbeGamesResult(false, bClear);
                EnalbeGamesTScore(false, bClear);
                EnableServiceRbtn(false);
            }
        }

        private void EnableTeamSetRbtn(Boolean bEnable, Boolean bClear)
        {
            if (bClear && m_nCurTeamSplitID > 0)
            {
                if (m_rbtnCurChkedSplit != null)
                {
                    m_rbtnCurChkedSplit.Checked = false;
                }
            }

            Int32 nEnableCount = m_nTeamSplitCount;
            if (SECommon.g_bUseSplitsRule)
            {
                Int32 nMatchScoreA, nMatchScoreB;
                if (m_nCurMatchType > 0)
                {
                    nMatchScoreA = Convert.ToInt32(lb_Home_Score.Text);
                    nMatchScoreB = Convert.ToInt32(lb_Away_Score.Text);
                    if (ovrRule.IsTotalScoreFinished(m_nTeamSplitCount, nMatchScoreA, nMatchScoreB))
                    {
                        nEnableCount = nMatchScoreA + nMatchScoreB;
                    }
                    else
                    {
                        nEnableCount = nMatchScoreA + nMatchScoreB + 1;
                    }
                }
            }

            btnx_Match1.Enabled = nEnableCount >= 1 ? bEnable : false;
            btnx_Match2.Enabled = nEnableCount >= 2 ? bEnable : false;
            btnx_Match3.Enabled = nEnableCount >= 3 ? bEnable : false;
        }

        private void EnableStaticBtn(Boolean bEnable, Boolean bClear)
        {
            if(m_nCurSetOffset >= 0)
            {
                btnx_A_Add.Enabled = bEnable;
                btnx_B_Add.Enabled = bEnable;
                btnx_Undo.Enabled = bEnable;
                dgvTeamA.Enabled = bEnable;
                dgvTeamB.Enabled = bEnable;

                if (SECommon.g_ManageDB.GetUndoStatus(m_nCurMatchID, m_nCurSetID))
                {
                    btnx_Undo.Enabled = false;
                }
            }
            else
            {
                btnx_A_Add.Enabled = false;
                btnx_B_Add.Enabled = false;
                btnx_Undo.Enabled = false;
                dgvTeamA.Enabled = false;
                dgvTeamB.Enabled = false;
            }

            if(bClear)
            {
                dgvTeamA.Rows.Clear();
                dgvTeamB.Rows.Clear();
            }
        }

        private void EnableGamesRbtn(Boolean bEnable, Boolean bClear)
        {
            if (bClear && m_rbtnCurChkedSet != null)
            {
                m_rbtnCurChkedSet.Checked = false;
            }

            Int32 nEnableCount = m_nSetsCount;
            if (SECommon.g_bUseSetsRule)
            {
                Int32 nTotalScoreA, nTotalScoreB;
                if (m_nCurMatchType > 0)
                {
                    nTotalScoreA = lb_A_GameTotal.Text == String.Empty ? 0 : Convert.ToInt32(lb_A_GameTotal.Text);
                    nTotalScoreB = lb_B_GameTotal.Text == String.Empty ? 0 : Convert.ToInt32(lb_B_GameTotal.Text);
                    if (ovrRule.IsTotalScoreFinished(m_nSetsCount, nTotalScoreA, nTotalScoreB))
                    {
                        nEnableCount = nTotalScoreA + nTotalScoreB;
                    }
                    else
                    {
                        nEnableCount = nTotalScoreA + nTotalScoreB + 1;
                    }
                }
            }

            rad_Game1.Enabled = nEnableCount >= 1 ? bEnable : false;
            rad_Game2.Enabled = nEnableCount >= 2 ? bEnable : false;
            rad_Game3.Enabled = nEnableCount >= 3 ? bEnable : false;
            rad_Game4.Enabled = nEnableCount >= 4 ? bEnable : false;
            rad_Game5.Enabled = nEnableCount >= 5 ? bEnable : false;
        }

        private void EnalbeGamesResult(Boolean bEnable, Boolean bClear)
        {
            Int32 nEnableCount = m_nSetsCount;
            if (SECommon.g_bUseSetsRule)
            {
                Int32 nTotalScoreA, nTotalScoreB;
                if (m_nCurMatchType > 0)
                {
                    nTotalScoreA = lb_A_GameTotal.Text == String.Empty ? 0 : Convert.ToInt32(lb_A_GameTotal.Text);
                    nTotalScoreB = lb_B_GameTotal.Text == String.Empty ? 0 : Convert.ToInt32(lb_B_GameTotal.Text);
                    if (ovrRule.IsTotalScoreFinished(m_nSetsCount, nTotalScoreA, nTotalScoreB))
                    {
                        nEnableCount = nTotalScoreA + nTotalScoreB;
                    }
                    else
                    {
                        nEnableCount = nTotalScoreA + nTotalScoreB + 1;
                    }
                }
            }

            ////////////////////////////////////////////////////////////////////////
            // Use Reflection 
            for (Int32 i = 0; i < 10; i++)
            {
                Type theType = typeof(frmOVRSEDataEntry);
                String strVarName = "lb_" + (i < 5 ? "A" : "B") + "_Game" + (i % 5 + 1).ToString();
                FieldInfo fi_Var = theType.GetField(strVarName, BindingFlags.Instance | BindingFlags.NonPublic);
                if (fi_Var != null)
                {
                    Label lbTemp = (Label)fi_Var.GetValue(this);

                    if (i % 5 < nEnableCount)
                    {
                        lbTemp.Enabled = bEnable;
                        if (bClear) lbTemp.Text = "0";
                    }
                    else
                    {
                        lbTemp.Enabled = false;
                        lbTemp.Text = "0";
                    }
                }
            }

            for (Int32 i = 0; i < 3; i++)
            {
                Type theType = typeof(frmOVRSEDataEntry);
                String strVarName = "tbx_TimeGame" + (i % 3 + 1).ToString();
                FieldInfo fi_Var = theType.GetField(strVarName, BindingFlags.Instance | BindingFlags.NonPublic);
                if (fi_Var != null)
                {
                    DevComponents.DotNetBar.Controls.TextBoxX txtboxTemp = (DevComponents.DotNetBar.Controls.TextBoxX)fi_Var.GetValue(this);

                    if (i % 3 < nEnableCount)
                    {
                        if (bClear) txtboxTemp.Text = "";
                    }
                    else
                    {
                        txtboxTemp.Text = "";
                    }

                    if (i == m_nCurSetOffset)
                    {
                        txtboxTemp.Enabled = bEnable;
                    }
                    else
                    {
                        txtboxTemp.Enabled = false;
                    }
                }
            }
        }

        private void EnalbeGamesTScore(Boolean bEnable, Boolean bClear)
        {
            if (bClear)
            {
                lb_A_GameTotal.Text = "0";
                lb_B_GameTotal.Text = "0";
            }

            lb_A_GameTotal.Enabled = bEnable;
            lb_B_GameTotal.Enabled = bEnable;
        }

        private void EnableServiceRbtn(Boolean bEnable)
        {
            if (m_nCurSetOffset >= 0)
            {
                rad_ServerA.Enabled = bEnable;
                rad_ServerB.Enabled = bEnable;
            }
            else
            {
                rad_ServerA.Enabled = false;
                rad_ServerB.Enabled = false;
            }
        }

        private void EnableExportImport(Boolean bEnable)
        {
            cmbFilterDate.Enabled = bEnable;
            tbExportPath.Enabled = bEnable;
            btnxExPathSel.Enabled = bEnable;
            btnxExAthlete.Enabled = bEnable;
            btnxExSchedule.Enabled = bEnable;
            btnx_ExportHoopSchedule.Enabled = bEnable;
            btnxHoopCompList.Enabled = bEnable;
            btnxExTeam.Enabled = bEnable;

            tbImportPath.Enabled = bEnable;
            btnxImPathSel.Enabled = bEnable;
            btnxImportMatchInfo.Enabled = bEnable;
            btnxImportAction.Enabled = bEnable;
            btnxImStatistic.Enabled = bEnable;
            btnxImHoopMatchInfo.Enabled = bEnable;
            chkAutoImport.Enabled = bEnable;
            tbImportMsg.Enabled = bEnable;
            tbManualPath.Enabled = bEnable;
            btnxManualPathSel.Enabled = bEnable;
        }
    }
}
