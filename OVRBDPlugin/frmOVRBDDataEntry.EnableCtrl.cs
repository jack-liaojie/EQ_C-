using System;
using System.Windows.Forms;
using System.Reflection;

namespace AutoSports.OVRBDPlugin
{        	
    // Ctrl Enable, DisEnable and Clear
    partial class frmOVRBDDataEntry
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

            if(m_nCurMatchType == BDCommon.MATCH_TYPE_TEAM)
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
               // lb_SportDes.Text = "";
                lb_PhaseDes.Text = "";
                lb_DateDes.Text = "";
               // lb_VenueDes.Text = "";
                lb_HomeDes.Text = "";
                lb_AwayDes.Text = "";              
                lb_Home_Score.Text = "0";
                lb_Away_Score.Text = "0";
            }

            if (m_nCurStatusID == BDCommon.STATUS_SCHEDULE && m_bIsRunning == true)
            {
                btnx_Modify_Result.Enabled = true;
            }
            else
            {
                btnx_Modify_Result.Enabled = bEnable;
            }

            if (m_nCurStatusID == BDCommon.STATUS_UNOFFICIAL && m_bIsRunning == true)
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
            chkManual.Enabled = bEnable;
            //btnSendBye.Enabled = bEnable;
        }

        private void EnableMatchDetail(Boolean bEnable, Boolean bClear)
        {
            EnableSplitInfo(bEnable, bClear);
            EnableGameDetail(bEnable, bClear);

            if ( m_nCurMatchType != BDCommon.MATCH_TYPE_TEAM )
            {
                EnableTeamSplitRbtn(false, true);
            }
            else
            {
                EnableTeamSplitRbtn(bEnable, bClear);
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

        private void EnableTeamSplitRbtn(Boolean bEnable, Boolean bClear)
        {
            if (bClear && m_nCurTeamSplitID > 0)
            {
                if (m_rbtnCurChkedSplit != null)
                {
                    m_rbtnCurChkedSplit.Checked = false;
                }
            }

            // Get enable games count
            Int32 nEnableCount = m_nTeamSplitCount;            
            if (m_CurMatchRule != null)
            {
                String strMatchScoreA, strMatchScoreB;
                BDCommon.g_ManageDB.GetMatchScore(m_nCurMatchID, out strMatchScoreA, out strMatchScoreB);
                Int32 nMatchScoreA = BDCommon.Str2Int(strMatchScoreA);
                Int32 nMatchScoreB = BDCommon.Str2Int(strMatchScoreB);
                
                if (m_CurMatchRule.IsMatchScoreFinished(nMatchScoreA, nMatchScoreB))
                {
                    nEnableCount = nMatchScoreA + nMatchScoreB;
                }
                else
                {
                    nEnableCount = nMatchScoreA + nMatchScoreB + 1;
                }
            }
            
            btnx_Split1.Enabled = nEnableCount >= 1 ? bEnable : false;
            btnx_Split2.Enabled = nEnableCount >= 2 ? bEnable : false;
            btnx_Split3.Enabled = nEnableCount >= 3 ? bEnable : false;
            btnx_Split4.Enabled = nEnableCount >= 4 ? bEnable : false;
            btnx_Split5.Enabled = nEnableCount >= 5 ? bEnable : false;
            btnx_SubMatch_Result.Enabled = nEnableCount > 0 ? bEnable : false;
        }

        private void CheckedTeamSplitRbtn(Int32 nSplitCount)
        {
            btnx_Split1.Checked = nSplitCount == 1 ? true : false;
            btnx_Split2.Checked = nSplitCount == 2 ? true : false;
            btnx_Split3.Checked = nSplitCount == 3 ? true : false;
            btnx_Split4.Checked = nSplitCount == 4 ? true : false;
            btnx_Split5.Checked = nSplitCount == 5 ? true : false;
        }

        private void EnableGameDetail(Boolean bEnable, Boolean bClear)
        {
            if (m_naGameIDs.Count > 0)
            {
                EnableGamesRbtnsAndLabels(bEnable, bClear);
                EnalbeGamesAddSubBtn(bEnable);
                EnalbeGamesTScore(bEnable, bClear);
                EnableServiceRbtn(bEnable, bClear);
            }
            else
            {
                EnableGamesRbtnsAndLabels(false, bClear);
                EnalbeGamesAddSubBtn(false);
                EnalbeGamesTScore(false, bClear);
                EnableServiceRbtn(false, bClear);
            }
        }

        private void EnableGamesRbtnsAndLabels(Boolean bEnable, Boolean bClear)
        {
            if (bClear && m_rbtnCurChkedGame != null)
            {
                m_rbtnCurChkedGame.Checked = false;
            }

            // Get enable games count
            int nEnableCount = m_nGamesCount;
            if (m_CurMatchRule != null)
            {
                int nTotalScoreA = BDCommon.Str2Int(lb_A_GameTotal.Text);
                int nTotalScoreB = BDCommon.Str2Int(lb_B_GameTotal.Text);
                if (m_CurMatchRule.IsGamesTotalScoreFinished(nTotalScoreA, nTotalScoreB))
                {
                    nEnableCount = nTotalScoreA + nTotalScoreB;
                }
                else
                {
                    nEnableCount = nTotalScoreA + nTotalScoreB + 1;
                }
            }

            btnx_Game_Result.Enabled = nEnableCount > 0 ? bEnable : false;

            // Use Reflection
            Type theType = typeof(frmOVRBDDataEntry);
            for (Int32 i = 1; i < 10; i++)
            {
                String strVarNameA = "lb_A_Game" + i.ToString();
                String strVarNameB = "lb_B_Game" + i.ToString();
                String strVarRadBtnName = "rad_Game" + i.ToString();

                FieldInfo fi_VarA = theType.GetField(strVarNameA, BindingFlags.Instance | BindingFlags.NonPublic);
                FieldInfo fi_VarB = theType.GetField(strVarNameB, BindingFlags.Instance | BindingFlags.NonPublic);
                FieldInfo fi_VarRadBtn = theType.GetField(strVarRadBtnName, BindingFlags.Instance | BindingFlags.NonPublic);
                if (fi_VarA == null || fi_VarB == null || fi_VarRadBtn == null) 
                    break;
                
                Label lbTempA = (Label)fi_VarA.GetValue(this);
                Label lbTempB = (Label)fi_VarB.GetValue(this);
                RadioButton rbtnTemp = (RadioButton)fi_VarRadBtn.GetValue(this);

                if (i <= nEnableCount)
                {
                    lbTempA.Enabled = bEnable;
                    lbTempB.Enabled = bEnable;
                    rbtnTemp.Enabled = bEnable;

                    if (bClear)
                    {
                        lbTempA.Text = "0";
                        lbTempB.Text = "0";
                    }
                }
                else
                {
                    lbTempA.Enabled = false;
                    lbTempB.Enabled = false;
                    rbtnTemp.Enabled = false;
                    //lbTempA.Text = "0";
                    //lbTempB.Text = "0";
                }                
            }
        }

        private void EnalbeGamesAddSubBtn(bool bEnable)
        {
            btnx_A_ADD.Enabled = bEnable;
            btnx_A_SUB.Enabled = bEnable;
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

                m_bAService = false;
                m_bBService = false;
            }

            rad_ServerA.Enabled = bEnable;
            rad_ServerB.Enabled = bEnable;
        }

        private void EnableExportImport(Boolean bEnable)
        {
            //cmbFilterDate.Enabled = bEnable;
            //tbExportPath.Enabled = bEnable;
            //btnxExPathSel.Enabled = bEnable;
            //btnxExAthlete.Enabled = bEnable;
            //btnxExSchedule.Enabled = bEnable;

            //tbImportPath.Enabled = bEnable;
          //  btnxImPathSel.Enabled = bEnable;
            btnxImportMatchInfo.Enabled = bEnable;
            btnxImportAction.Enabled = bEnable;
            //chkAutoImport.Enabled = bEnable;
            btnAutoImport.Enabled = bEnable;
            btnStartTcpListener.Enabled = bEnable;
            tbTcpPort.ReadOnly = !bEnable;
            lstboxClients.Enabled = bEnable;
            radModeTCP.Enabled = bEnable;
            radModeUDP.Enabled = bEnable;
            if (m_tsTTconfig != null && m_tsTTconfig.ImportType == "1" && bEnable)
            {
                btnAutoImport.Enabled = bEnable;
            }
            else
            {
                btnAutoImport.Enabled = false;
            }
            return;


            if ( m_tsTTconfig != null && m_tsTTconfig.ImportType == "1" && bEnable)
            {
                btnAutoImport.Enabled = bEnable;
            }
            else
            {
                btnAutoImport.Enabled = false;
            }
        
            if ( m_tsTTconfig != null && m_tsTTconfig.ImportType == "2" && bEnable)
            {
                btnStartTcpListener.Enabled = bEnable;
                lstboxClients.Enabled = bEnable;
                tbTcpPort.ReadOnly = !bEnable;
            }
            else
            {
                btnStartTcpListener.Enabled = false;
                lstboxClients.Enabled = false;
                tbTcpPort.ReadOnly = true;
            }
           
            //tbImportMsg.Enabled = bEnable;
        }

        private void EnableAutoData(Boolean bEnable)
        {
            chkOuterData.Enabled = bEnable;
        }

        private void HideNotUsedUICtrl()
        {
            // Hide not used splits
            if (m_nTeamSplitCount > 5) return;

            btnx_Split1.Visible = m_nTeamSplitCount >= 1;
            btnx_Split2.Visible = m_nTeamSplitCount >= 2;
            btnx_Split3.Visible = m_nTeamSplitCount >= 3;
            btnx_Split4.Visible = m_nTeamSplitCount >= 4;
            btnx_Split5.Visible = m_nTeamSplitCount >= 5;
            btnx_SubMatch_Result.Visible = m_nTeamSplitCount >= 1;

            // Hide not used games
            if (m_nGamesCount > 7) return;
            Type theType = typeof(frmOVRBDDataEntry);
            for (Int32 i = 1; i <= 7; i++)
            {
                String strVarNameA = "lb_A_Game" + i.ToString();
                String strVarNameB = "lb_B_Game" + i.ToString();
                String strVarRadBtnName = "rad_Game" + i.ToString();

                FieldInfo fi_VarA = theType.GetField(strVarNameA, BindingFlags.Instance | BindingFlags.NonPublic);
                FieldInfo fi_VarB = theType.GetField(strVarNameB, BindingFlags.Instance | BindingFlags.NonPublic);
                FieldInfo fi_VarRadBtn = theType.GetField(strVarRadBtnName, BindingFlags.Instance | BindingFlags.NonPublic);
                if (fi_VarA == null || fi_VarB == null || fi_VarRadBtn == null)
                    break;

                Label lbTempA = (Label)fi_VarA.GetValue(this);
                Label lbTempB = (Label)fi_VarB.GetValue(this);
                RadioButton rbtnTemp = (RadioButton)fi_VarRadBtn.GetValue(this);

                if (i <= m_nGamesCount)
                {
                    lbTempA.Visible = true;
                    lbTempB.Visible = true;
                    rbtnTemp.Visible = true;
                }
                else
                {
                    lbTempA.Visible = false;
                    lbTempB.Visible = false;
                    rbtnTemp.Visible = false;
                }
            }
        }
    }
}
