using System;
using System.Windows.Forms;
using System.Reflection;

namespace AutoSports.OVRSQPlugin
{        	
    // Ctrl Enable, DisEnable and Clear
    partial class frmOVRSQDataEntry
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

            if(m_nCurMatchType == SQCommon.MATCH_TYPE_TEAM)
            {
                btnx_Team.Enabled = bEnable;
            }
            else
            {
                btnx_Team.Enabled = false;
            }
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
                lb_VenueDes.Text = "";
                lb_HomeDes.Text = "";
                lb_AwayDes.Text = "";              
                lb_Home_Score.Text = "0";
                lb_Away_Score.Text = "0";
            }

            if (m_nCurStatusID == SQCommon.STATUS_SCHEDULE && m_bIsRunning == true)
            {
                btnx_Modify_Result.Enabled = true;
            }
            else
            {
                btnx_Modify_Result.Enabled = bEnable;
            }

            if (m_nCurStatusID == SQCommon.STATUS_UNOFFICIAL && m_bIsRunning == true)
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

        private void EnableMatchDetail(Boolean bEnable, Boolean bClear)
        {
            EnableSplitInfo(bEnable, bClear);
            EnableGameDetail(bEnable, bClear);

            if ( m_nCurMatchType != SQCommon.MATCH_TYPE_TEAM )
            {
                EnableTeamSetRbtn(false, true);
            }
            else
            {
                EnableTeamSetRbtn(bEnable, bClear);
            }
        }

        private void EnableSplitInfo(Boolean bEnable, Boolean bClear) 
        {
            if (bClear)
            {
                lb_PlayerA.Text = "";
                lb_PlayerB.Text = "";
                lb_NOCA.Text = "";
                lb_NOCB.Text = "";
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
            if (SQCommon.g_bUseSplitsRule)
            {
                Int32 nMatchScoreA = 0, nMatchScoreB = 0;
                if (m_nCurMatchType > 0 && ovrRule.GetMatchScoreFromTeamSplits(ref nMatchScoreA, ref nMatchScoreB))
                {
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
            btnx_Match4.Enabled = nEnableCount >= 4 ? bEnable : false;
            btnx_Match5.Enabled = nEnableCount >= 5 ? bEnable : false;
            btnx_SubMatch_Result.Enabled = nEnableCount > 0 ? bEnable : false;
        }

        private void CheckedTeamSetRbtn(Int32 nSplitCount)
        {
            btnx_Match1.Checked = nSplitCount == 1 ? true : false;
            btnx_Match2.Checked = nSplitCount == 2 ? true : false;
            btnx_Match3.Checked = nSplitCount == 3 ? true : false;
            btnx_Match4.Checked = nSplitCount == 4 ? true : false;
            btnx_Match5.Checked = nSplitCount == 5 ? true : false;
        }

        private void EnableGameDetail(Boolean bEnable, Boolean bClear)
        {
            if (m_naSetIDs.Count > 0)
            {
                EnableGamesRbtn(bEnable, bClear);
                EnalbeGamesTScore(bEnable, bClear);
                EnableServiceRbtn(bEnable, bClear);

                if (m_nServerType == SQCommon.PAR_TYPE_SCORE)
                {
                    EnableASetAddSubBtn(bEnable);
                    EnableBSetAddSubBtn(bEnable);
                }
                else if (m_nServerType == SQCommon.SOS_TYPE_SCORE)
                {
                    if(m_bAService)
                    {
                        EnableASetAddSubBtn(bEnable);
                        EnableBSetAddSubBtn(false);
                    }
                    else if (m_bBService)
                    {
                        EnableASetAddSubBtn(false);
                        EnableBSetAddSubBtn(bEnable);
                    }
                    else
                    {
                        EnableASetAddSubBtn(false);
                        EnableBSetAddSubBtn(false);
                    }
                }
            }
            else
            {
                EnableGamesRbtn(false, bClear);
                EnableASetAddSubBtn(false);
                EnableBSetAddSubBtn(false);
                EnalbeGamesTScore(false, bClear);
                EnableServiceRbtn(false, bClear);
            }
        }

        private void EnableGamesRbtn(Boolean bEnable, Boolean bClear)
        {
            if (bClear && m_rbtnCurChkedSet != null)
            {
                m_rbtnCurChkedSet.Checked = false;
            }

            Int32 nEnableCount = m_nSetsCount;
            if (SQCommon.g_bUseSetsRule)
            {
                Int32 nTotalScoreA = 0, nTotalScoreB = 0;
                Int32 nTeamSplitID = m_nCurMatchType == SQCommon.MATCH_TYPE_TEAM ? m_nCurTeamSplitID : 0;
                if ( ovrRule.GetTotalScoreFromSets(nTeamSplitID, ref nTotalScoreA, ref nTotalScoreB))
                {
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
            btnx_Game_Result.Enabled = nEnableCount > 0 ? bEnable : false;

            // Use Reflection 
            for (Int32 i = 0; i < 10; i++)
            {
                Type theType = typeof(frmOVRSQDataEntry);
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
        }

        private void EnableASetAddSubBtn(Boolean bEnable)
        {
            btnx_A_ADD.Enabled = bEnable;
            btnx_A_SUB.Enabled = bEnable;
        }

        private void EnableBSetAddSubBtn(Boolean bEnable)
        {           
            btnx_B_ADD.Enabled = bEnable;
            btnx_B_SUB.Enabled = bEnable;
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

        private void EnableServiceRbtn(Boolean bEnable, Boolean bClear)
        {
            if (bClear)
            {
                rad_ServerA.Checked = false;
                rad_ServerB.Checked = false;
            }

            rad_ServerA.Enabled = bEnable;
            rad_ServerB.Enabled = bEnable;
        }

        private void EnableExportImport(Boolean bEnable)
        {
            cmbFilterDate.Enabled = bEnable;
            tbExportPath.Enabled = bEnable;
            btnxExPathSel.Enabled = bEnable;
            btnxExAthlete.Enabled = bEnable;
            btnxExSchedule.Enabled = bEnable;

            tbImportPath.Enabled = bEnable;
            btnxImPathSel.Enabled = bEnable;
            btnxImportMatchInfo.Enabled = bEnable;
            btnxImportAction.Enabled = bEnable;
            chkAutoImport.Enabled = bEnable;
            tbImportMsg.Enabled = bEnable;

            tbImFilePath.Enabled = bEnable;
            btnxImFileSel.Enabled = bEnable;
            btnxImportMatchResult.Enabled = bEnable;
        }

        private void EnableAutoData(Boolean bEnable)
        {
            chkOuterData.Enabled = bEnable;
        }
    }
}
