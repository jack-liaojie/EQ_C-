using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows;
using System.Windows.Forms;
using System.Data.SqlClient;
using AutoSports.OVRCommon;
using Microsoft.VisualBasic.Devices;
using AutoSports.OVRDrawModel;
using DevComponents.DotNetBar;
using AutoSports.OVRRegister;
using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    public partial class OVRDrawArrangeForm
    {
        private string m_strLastSelDrawTreeNodeKey;
        private Int32 m_iSelDrawTreeEventID = -1;
        private Int32 m_iSelDrawTreePhaseID = -1;
        private Int32 m_iSelDrawTreeNodeType = -4;
        private Int32 m_iSelDrawTreeMatchID = -1;

        private void InitDrawLocalization()
        {
            this.lbDrawPlayer.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbDrawPlayers");
            this.lbAvailablePlayer.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbAvailablePlayers");
            this.btnAutoDraw.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnAutoDraw");
            this.btnCleanDraw.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnCleanDraw");
            this.btnChosePhaseComp.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnChosePhaseCompetitors");
            this.btnMatchUp.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnCreateMatchUp");
            this.btnCleanMatchUp.Text = LocalizationRecourceManager.GetString(m_strSectionName, "btnCleanMatchUp");
            this.MenuAddPosition.Text = LocalizationRecourceManager.GetString(m_strSectionName, "menuAddPosition");
            this.MenuDelPosition.Text = LocalizationRecourceManager.GetString(m_strSectionName, "menuDelPosition");
            this.MenuaddMultiPosition.Text = LocalizationRecourceManager.GetString(m_strSectionName, "menuAddMultiPosition");
            this.MenuDelDrawPos.Text = LocalizationRecourceManager.GetString(m_strSectionName, "menuDelDrawPos");
            this.MenuDelInscription.Text = LocalizationRecourceManager.GetString(m_strSectionName, "menuDelInscription");

            SetButtonEnable(false);

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvDrawInfo);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvPlayers);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvTeamMember);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchList);
            this.dgvDrawInfo.DefaultCellStyle.Font = new Font("Arial Bold", 12);
            this.dgvPlayers.DefaultCellStyle.Font = new Font("Arial Bold", 12);
            this.dgvTeamMember.DefaultCellStyle.Font = new Font("Arial Bold", 12);
            this.dgvMatchList.DefaultCellStyle.Font = new Font("Arial Bold", 12);

            this.dgvPlayers.RowHeadersVisible = true;
            this.dgvTeamMember.RowHeadersVisible = true;

            this.dgvPlayers.MultiSelect = false;
            this.dgvTeamMember.MultiSelect = false;
        }

        #region User Interface Operation

        private void btnDrawRefresh_Click(object sender, EventArgs e)
        {
            OVRDataBaseUtils.GetActiveInfo(m_drawArrangeModule.DatabaseConnection, out m_iSportID, out m_iDisciplineID, out m_strLanguageCode);
            UpdateDrawPhaseTree();
        }

        private void tvDrawPhaseTree_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                // Get right click node!
                DevComponents.AdvTree.Node SelNode = this.tvDrawPhaseTree.GetNodeAt(this.PointToClient(this.PointToScreen(new Point(e.X, e.Y))));
                if (SelNode != null)
                {
                    SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
                    switch (oneSNodeInfo.iNodeType)
                    {
                        case -1://Event
                            SetEventModelDraw.Enabled = true;
                            break;
                        default://其余的不需要处理!
                            SetEventModelDraw.Enabled = false;
                            break;
                    }
                }
                else
                {
                    //DevComponents.DotNetBar.MessageBoxEx.Show("Right Click on Nothing!");
                }
            }
        }

        private void tvDrawPhaseTree_AfterNodeSelect(object sender, DevComponents.AdvTree.AdvTreeNodeEventArgs e)
        {
            if (tvDrawPhaseTree.SelectedNodes.Count > 0)
            {
                DevComponents.AdvTree.Node SelNode = tvDrawPhaseTree.SelectedNodes[0];
                SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;

                m_strLastSelDrawTreeNodeKey = oneSNodeInfo.strNodeKey;
                m_iSelDrawTreeNodeType = oneSNodeInfo.iNodeType;
                m_iSelDrawTreeEventID = oneSNodeInfo.iEventID;
                m_iSelDrawTreePhaseID = oneSNodeInfo.iPhaseID;
                m_iSelDrawTreeMatchID = oneSNodeInfo.iMatchID;

                if (oneSNodeInfo.iNodeType == -1 || oneSNodeInfo.iNodeType == 0)
                    SetButtonEnable(true);
                else
                    SetButtonEnable(false);

                UpdatePhaseCompetitors();
                UpdatePhaseCompetitorsPosition();
                UpdateMatchList();

                // Update Report Context
                m_drawArrangeModule.SetReportContext("SportID", oneSNodeInfo.iSportID.ToString());
                m_drawArrangeModule.SetReportContext("DisciplineID", oneSNodeInfo.iDisciplineID.ToString());
                m_drawArrangeModule.SetReportContext("EventID", oneSNodeInfo.iEventID.ToString());
                m_drawArrangeModule.SetReportContext("PhaseID", oneSNodeInfo.iPhaseID.ToString());
            }
            else
            {
                m_iSelDrawTreeNodeType = -4;
                m_iSelDrawTreeEventID = -1;
                m_iSelDrawTreePhaseID = -1;

                UpdatePhaseCompetitors();
                UpdatePhaseCompetitorsPosition();
                UpdateMatchList();

                m_drawArrangeModule.SetReportContext("SportID", "-1");
                m_drawArrangeModule.SetReportContext("DisciplineID", "-1");
                m_drawArrangeModule.SetReportContext("EventID", "-1");
                m_drawArrangeModule.SetReportContext("PhaseID", "-1");
            }
        }

        private void btnChosePhaseComp_Click(object sender, EventArgs e)
        {
            frmChosePhaseCompetitors frmChosePhaseComp = new frmChosePhaseCompetitors(m_iSelDrawTreeEventID, m_iSelDrawTreePhaseID, m_iSelDrawTreeNodeType, m_strLanguageCode);
            frmChosePhaseComp.DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
            frmChosePhaseComp.ShowDialog();
            UpdatePhaseCompetitors();
        }

        private void btnAutoDraw_MouseDown(object sender, MouseEventArgs e)
        {
            if (IsPhasePositionNotNull())
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDrawPositionExist"));
                return;
            }

            try
            {
                Int32 iType = 0;

                if (e.Button == MouseButtons.Right)
                {
                    iType = 1;
                }

                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_AutoSwitch_AutoDrawPhasePosition";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@EventID", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@EventID",
                                                             DataRowVersion.Default, m_iSelDrawTreeEventID);
                SqlParameter cmdParameter2 = new SqlParameter("@PhaseID", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@PhaseID",
                                                             DataRowVersion.Default, m_iSelDrawTreePhaseID);
                SqlParameter cmdParameter3 = new SqlParameter("@NodeType", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@NodeType",
                                                             DataRowVersion.Default, m_iSelDrawTreeNodeType);
                SqlParameter cmdParameter4 = new SqlParameter("@Type", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@Type",
                                                             DataRowVersion.Default, iType);
                SqlParameter cmdParameter5 = new SqlParameter("@Result", SqlDbType.Int, 4,
                                                             ParameterDirection.Output, false, 0, 0, "@Result",
                                                             DataRowVersion.Default, DBNull.Value);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameter3);
                oneSqlCommand.Parameters.Add(cmdParameter4);
                oneSqlCommand.Parameters.Add(cmdParameter5);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                SqlDataReader dr = oneSqlCommand.ExecuteReader();
                dr.Close();

                UpdatePhaseCompetitors();
                UpdatePhaseCompetitorsPosition();
                UpdateTeamMembers();
            }
            catch (System.Exception ee)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ee.Message);
            }
        }

        private void btnCleanDraw_Click(object sender, EventArgs e)
        {
            if (DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgCleanDrawPosition"), LocalizationRecourceManager.GetString(m_strSectionName, "MsgCleanPosition"), MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
            {
                return;
            }
            else
            {
                try
                {
                    SqlCommand oneSqlCommand = new SqlCommand();
                    oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                    oneSqlCommand.CommandText = "Proc_CleanDrawPhasePosition";
                    oneSqlCommand.CommandType = CommandType.StoredProcedure;

                    SqlParameter cmdParameter1 = new SqlParameter("@EventID", SqlDbType.Int, 4,
                                                                 ParameterDirection.Input, false, 0, 0, "@EventID",
                                                                 DataRowVersion.Default, m_iSelDrawTreeEventID);
                    SqlParameter cmdParameter2 = new SqlParameter("@PhaseID", SqlDbType.Int, 4,
                                                                 ParameterDirection.Input, false, 0, 0, "@PhaseID",
                                                                 DataRowVersion.Default, m_iSelDrawTreePhaseID);
                    SqlParameter cmdParameter3 = new SqlParameter("@NodeType", SqlDbType.Int, 4,
                                                                 ParameterDirection.Input, false, 0, 0, "@NodeType",
                                                                 DataRowVersion.Default, m_iSelDrawTreeNodeType);
                    SqlParameter cmdParameter5 = new SqlParameter("@Result", SqlDbType.Int, 4,
                                                                 ParameterDirection.Output, false, 0, 0, "@Result",
                                                                 DataRowVersion.Default, DBNull.Value);

                    oneSqlCommand.Parameters.Add(cmdParameter1);
                    oneSqlCommand.Parameters.Add(cmdParameter2);
                    oneSqlCommand.Parameters.Add(cmdParameter3);
                    oneSqlCommand.Parameters.Add(cmdParameter5);


                    if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                    {
                        m_drawArrangeModule.DatabaseConnection.Open();
                    }

                    SqlDataReader dr = oneSqlCommand.ExecuteReader();
                    dr.Close();

                    UpdatePhaseCompetitors();
                    UpdatePhaseCompetitorsPosition();
                }
                catch (System.Exception ee)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ee.Message);
                }
            }
        }

        private void btnMatchUp_Click(object sender, EventArgs e)
        {
            if (tvDrawPhaseTree.SelectedNodes.Count > 0)
            {
                DevComponents.AdvTree.Node SelNode = tvDrawPhaseTree.SelectedNodes[0];
                if (SelNode != null)
                {
                    SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
                    switch (oneSNodeInfo.iNodeType)
                    {
                        case -3://Sport
                        case -2://Discipline
                            break;
                        case -1://Event   
                        case 0://Phase
                            {
                                m_iSelDrawTreeEventID = oneSNodeInfo.iEventID;
                                m_iSelDrawTreePhaseID = oneSNodeInfo.iPhaseID;

                                try
                                {
                                    SqlCommand oneSqlCommand = new SqlCommand();
                                    oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                                    oneSqlCommand.CommandText = "Proc_UpdatePhasePosition2Match";

                                    oneSqlCommand.CommandType = CommandType.StoredProcedure;

                                    SqlParameter cmdParameter1 = new SqlParameter("@EventID", SqlDbType.Int);
                                    SqlParameter cmdParameter2 = new SqlParameter("@PhaseID", SqlDbType.Int);
                                    SqlParameter cmdParameter3 = new SqlParameter("@NodeType", SqlDbType.Int);
                                    SqlParameter cmdParameterResult = new SqlParameter(
                                             "@Result", SqlDbType.Int, 4,
                                             ParameterDirection.Output, false, 0, 0, "@Result",
                                             DataRowVersion.Default, DBNull.Value);

                                    cmdParameter1.Value = m_iSelDrawTreeEventID;
                                    cmdParameter2.Value = m_iSelDrawTreePhaseID;
                                    cmdParameter3.Value = m_iSelDrawTreeNodeType;

                                    oneSqlCommand.Parameters.Add(cmdParameter1);
                                    oneSqlCommand.Parameters.Add(cmdParameter2);
                                    oneSqlCommand.Parameters.Add(cmdParameter3);
                                    oneSqlCommand.Parameters.Add(cmdParameterResult);

                                    if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                                    {
                                        m_drawArrangeModule.DatabaseConnection.Open();
                                    }

                                    if (oneSqlCommand.ExecuteNonQuery() != 0)
                                    {
                                        Int32 iOperateResult = (Int32)cmdParameterResult.Value;
                                        switch (iOperateResult)
                                        {
                                            case 0:
                                                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgUpdatePhasePosition2Match1"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.Error);
                                                break;
                                            case -1:
                                                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgUpdatePhasePosition2Match2"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.Error);
                                                break;
                                            default://其余为添加成功！
                                                UpdateCompetitors();
                                                UpdateMatches();
                                                UpdateMatchList();
                                                this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emPhaseDraw, -1, -1, m_iSelDrawTreePhaseID, -1, m_iSelDrawTreePhaseID, null);
                                                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgUpdatePhasePosition2Match3"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.None);
                                                break;
                                        }
                                    }
                                }
                                catch (System.Exception ex)
                                {
                                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                                }
                                break;
                            }
                        case 1://Match  
                            break;
                        default://其余的不需要处理!
                            break;
                    }
                }
            }
        }

        private void btnCleanMatchUp_Click(object sender, EventArgs e)
        {
            if (tvDrawPhaseTree.SelectedNodes.Count > 0)
            {
                DevComponents.AdvTree.Node SelNode = tvDrawPhaseTree.SelectedNodes[0];
                if (SelNode != null)
                {
                    SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
                    switch (oneSNodeInfo.iNodeType)
                    {
                        case -3://Sport
                        case -2://Discipline
                            break;
                        case -1://Event   
                        case 0://Phase
                            {
                                m_iSelDrawTreeEventID = oneSNodeInfo.iEventID;
                                m_iSelDrawTreePhaseID = oneSNodeInfo.iPhaseID;

                                try
                                {
                                    SqlCommand oneSqlCommand = new SqlCommand();
                                    oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                                    oneSqlCommand.CommandText = "Proc_CleanMatchCompetitorFormPositiion";

                                    oneSqlCommand.CommandType = CommandType.StoredProcedure;

                                    SqlParameter cmdParameter1 = new SqlParameter("@EventID", SqlDbType.Int);
                                    SqlParameter cmdParameter2 = new SqlParameter("@PhaseID", SqlDbType.Int);
                                    SqlParameter cmdParameter3 = new SqlParameter("@NodeType", SqlDbType.Int);
                                    SqlParameter cmdParameterResult = new SqlParameter(
                                             "@Result", SqlDbType.Int, 4,
                                             ParameterDirection.Output, false, 0, 0, "@Result",
                                             DataRowVersion.Default, DBNull.Value);

                                    cmdParameter1.Value = m_iSelDrawTreeEventID;
                                    cmdParameter2.Value = m_iSelDrawTreePhaseID;
                                    cmdParameter3.Value = m_iSelDrawTreeNodeType;

                                    oneSqlCommand.Parameters.Add(cmdParameter1);
                                    oneSqlCommand.Parameters.Add(cmdParameter2);
                                    oneSqlCommand.Parameters.Add(cmdParameter3);
                                    oneSqlCommand.Parameters.Add(cmdParameterResult);

                                    if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                                    {
                                        m_drawArrangeModule.DatabaseConnection.Open();
                                    }

                                    if (oneSqlCommand.ExecuteNonQuery() != 0)
                                    {
                                        Int32 iOperateResult = (Int32)cmdParameterResult.Value;
                                        switch (iOperateResult)
                                        {
                                            case 0:
                                                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgCleanMatchCompetitorFromPostion1"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.Error);
                                                break;
                                            case -1:
                                                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgCleanMatchCompetitorFromPostion2"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.Error);
                                                break;
                                            default://其余为添加成功！
                                                UpdateCompetitors();
                                                UpdateMatches();
                                                UpdateMatchList();
                                                this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emPhaseDraw, -1, -1, m_iSelDrawTreePhaseID, -1, m_iSelDrawTreePhaseID, null);
                                                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgCleanMatchCompetitorFromPostion3"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.None);
                                                break;
                                        }
                                    }
                                }
                                catch (System.Exception ex)
                                {
                                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                                }
                                break;
                            }
                        case 1://Match  
                            break;
                        default://其余的不需要处理!
                            break;
                    }
                }
            }
        }

        private void dgvDrawInfo_MouseDown(object sender, MouseEventArgs e)
        {
            dgvDrawInfo.ContextMenuStrip = null;

            if ((e.Button == MouseButtons.Right) && (m_iSelDrawTreeNodeType == -1 || m_iSelDrawTreeNodeType == 0))
            {
                MenuDelPosition.Enabled = false;

                if (dgvDrawInfo.SelectedRows.Count > 0)
                {
                    MenuDelPosition.Enabled = true;
                }

                dgvDrawInfo.ContextMenuStrip = DrawInfoMenuStrip;
            }
        }

        private void dgvPlayers_MouseDown(object sender, MouseEventArgs e)
        {
            dgvPlayers.ContextMenuStrip = null;

            if ((e.Button == MouseButtons.Right) && (m_iSelDrawTreeNodeType == -1 || m_iSelDrawTreeNodeType == 0))
            {
                dgvPlayers.Focus();
                DataGridView.HitTestInfo hitTestInfo;
                hitTestInfo = dgvPlayers.HitTest(e.X, e.Y);

                if (hitTestInfo.RowIndex < 0 && dgvPlayers.SelectedRows.Count == 0)
                {
                    MenuDelDrawPos.Enabled = false;
                    dgvPlayers.ContextMenuStrip = TeamInfoMenuStrip;
                }
                else
                {
                    if (hitTestInfo.RowIndex >= 0)
                    {
                        dgvPlayers.ClearSelection();
                        dgvPlayers.Rows[hitTestInfo.RowIndex].Selected = true;
                        dgvPlayers.CurrentCell = dgvPlayers.Rows[hitTestInfo.RowIndex].Cells[hitTestInfo.ColumnIndex];
                    }

                    MenuDelDrawPos.Enabled = true;
                    dgvPlayers.ContextMenuStrip = TeamInfoMenuStrip;
                }
            }
        }

        private void MenuDelDrawPos_Click(object sender, EventArgs e)
        {
            if (DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgCancelDrawRegister"), LocalizationRecourceManager.GetString(m_strSectionName, "MsgCancelDraw"), MessageBoxButtons.YesNo) == DialogResult.No)
            {
                return;
            }

            DataGridViewRow row = new DataGridViewRow();

            if (dgvPlayers.SelectedRows.Count == 1)
            {
                Int32 iRowIdx = dgvPlayers.CurrentRow.Index;
                Int32 iColIndex = dgvPlayers.Columns["RegisterID"].Index;

                string strRegisterID = dgvPlayers.Rows[iRowIdx].Cells[iColIndex].Value.ToString();
                Int32 nRegisterID = Convert.ToInt32(strRegisterID);

                frmChosePhaseCompetitors frmChoseCompetitors = new frmChosePhaseCompetitors(m_iSelDrawTreeEventID, m_iSelDrawTreePhaseID, m_iSelDrawTreeNodeType, m_strLanguageCode);
                frmChoseCompetitors.DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
                frmChoseCompetitors.DelPhaseCompetitors(m_iSelDrawTreePhaseID, nRegisterID);

                UpdatePhaseCompetitors();
            }
        }

        private void MenuDelInscription_Click(object sender, EventArgs e)
        {
            if (DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelInscription"), LocalizationRecourceManager.GetString(m_strSectionName, "MsgCancelInscription"), MessageBoxButtons.YesNo) == DialogResult.No)
            {
                return;
            }

            if (dgvPlayers.SelectedRows.Count == 1)
            {
                Int32 iRowIdx = dgvPlayers.CurrentRow.Index;
                Int32 iColIndex = dgvPlayers.Columns["RegisterID"].Index;

                string strRegisterID = dgvPlayers.Rows[iRowIdx].Cells[iColIndex].Value.ToString();
                string strEventID = m_iSelDrawTreeEventID.ToString();

                DelRegisterEvent(strRegisterID, strEventID);
                UpdatePhaseCompetitors();

            }
        }
        private void dgvPlayers_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvPlayers.SelectedRows.Count != 1)
                return;

            UpdateTeamMembers();
        }

        private void dgvTeamMember_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            MemberEditForm frmMemberEdit = new MemberEditForm("OVRRegisterInfo");
            frmMemberEdit.DatabaseConnection = m_drawArrangeModule.DatabaseConnection;

            if (dgvTeamMember.SelectedRows.Count != 1)
                return;

            Int32 iRegisterIDColIdx = dgvTeamMember.Columns["TeamID"].Index;
            Int32 iDelegationIDColIdx = dgvTeamMember.Columns["DelegationID"].Index;
            Int32 iNameColIdx = dgvTeamMember.Columns["Name"].Index;
            Int32 iSexIDColIdx = dgvTeamMember.Columns["SexCode"].Index;

            DataGridViewRow row = new DataGridViewRow();
            row = dgvTeamMember.SelectedRows[0];
            Int32 iRowIdx = row.Index;

            String strRegisterID = dgvTeamMember.Rows[iRowIdx].Cells[iRegisterIDColIdx].Value.ToString();
            String strDelegationID = dgvTeamMember.Rows[iRowIdx].Cells[iDelegationIDColIdx].Value.ToString();
            String strName = dgvTeamMember.Rows[iRowIdx].Cells[iNameColIdx].Value.ToString();
            String strSexCode = dgvTeamMember.Rows[iRowIdx].Cells[iSexIDColIdx].Value.ToString();

            frmMemberEdit.m_iGroupType = 4;
            frmMemberEdit.m_strGroupID = strDelegationID;

            frmMemberEdit.m_strRegisterID = strRegisterID;
            frmMemberEdit.m_strLanguageCode = m_strLanguageCode;
            frmMemberEdit.m_strRegisterName = strName;
            frmMemberEdit.m_strSexCode = strSexCode;
            frmMemberEdit.ShowDialog();

            UpdateTeamMembers();
        }

        private void MenuAddPosition_Click(object sender, EventArgs e)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "proc_ManualAddDrawPosition";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@EventID", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@EventID",
                                                             DataRowVersion.Default, m_iSelDrawTreeEventID);
                SqlParameter cmdParameter2 = new SqlParameter("@PhaseID", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@PhaseID",
                                                             DataRowVersion.Default, m_iSelDrawTreePhaseID);
                SqlParameter cmdParameter3 = new SqlParameter("@NodeType", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@NodeType",
                                                             DataRowVersion.Default, m_iSelDrawTreeNodeType);
                SqlParameter cmdParameter4 = new SqlParameter("@Result", SqlDbType.Int, 4,
                                                             ParameterDirection.Output, false, 0, 0, "@Result",
                                                             DataRowVersion.Default, DBNull.Value);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameter3);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                SqlDataReader dr = oneSqlCommand.ExecuteReader();
                dr.Close();

                UpdatePhaseCompetitors();
                UpdatePhaseCompetitorsPosition();
            }
            catch (System.Exception ee)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ee.Message);
            }
        }

        private void MenuDelPosition_Click(object sender, EventArgs e)
        {
            if (DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelDrawPosition"), LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelPosition"), MessageBoxButtons.YesNo) == DialogResult.No)
            {
                return;
            }

            DataGridViewRow row = new DataGridViewRow();

            if (dgvDrawInfo.SelectedRows.Count > 0)
            {
                try
                {
                    SqlCommand oneSqlCommand = new SqlCommand();
                    oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                    oneSqlCommand.CommandText = "proc_ManualDelDrawPosition";
                    oneSqlCommand.CommandType = CommandType.StoredProcedure;

                    SqlParameter cmdParameter0 = new SqlParameter("@ItemID", SqlDbType.Int);
                    SqlParameter cmdParameter2 = new SqlParameter("@NodeType", SqlDbType.Int);
                    SqlParameter cmdParameter1 = new SqlParameter(
                             "@Result", SqlDbType.Int, 4,
                             ParameterDirection.Output, false, 0, 0, "@Result",
                             DataRowVersion.Default, DBNull.Value);

                    oneSqlCommand.Parameters.Add(cmdParameter0);
                    oneSqlCommand.Parameters.Add(cmdParameter2);
                    oneSqlCommand.Parameters.Add(cmdParameter1);

                    cmdParameter2.Value = m_iSelDrawTreeNodeType;

                    Int32 iItemIDIdx = dgvDrawInfo.Columns["ItemID"].Index;
                    
                    for (int i = 0; i < dgvDrawInfo.SelectedRows.Count; i++)
                    {
                        row = dgvDrawInfo.SelectedRows[i];
                        Int32 iRowIdx = row.Index;

                        string strItemID = dgvDrawInfo.Rows[iRowIdx].Cells[iItemIDIdx].Value.ToString();

                        if (strItemID != "")
                        {
                            Int32 nItemID = Convert.ToInt32(strItemID);
                            cmdParameter0.Value = nItemID;

                            if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                            {
                                m_drawArrangeModule.DatabaseConnection.Open();
                            }

                            SqlDataReader dr = oneSqlCommand.ExecuteReader();
                            dr.Close();
                        }
                    }

                    UpdatePhaseCompetitors();
                    UpdatePhaseCompetitorsPosition();
                }
                catch (System.Exception ee)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ee.Message);
                }
            }
        }

        private void addMultiPosition_Click(object sender, EventArgs e)
        {
            frmSetPositionNum setPositionNum = new frmSetPositionNum();
            setPositionNum.ShowDialog();

            if (setPositionNum.DialogResult == DialogResult.Cancel)
                return;

            Int32 nPostionNum = setPositionNum.m_nPositionNum;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "proc_ManualAddDrawPosition";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@EventID", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@EventID",
                                                             DataRowVersion.Default, m_iSelDrawTreeEventID);
                SqlParameter cmdParameter2 = new SqlParameter("@PhaseID", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@PhaseID",
                                                             DataRowVersion.Default, m_iSelDrawTreePhaseID);
                SqlParameter cmdParameter3 = new SqlParameter("@NodeType", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@NodeType",
                                                             DataRowVersion.Default, m_iSelDrawTreeNodeType);
                SqlParameter cmdParameter4 = new SqlParameter("@Result", SqlDbType.Int, 4,
                                                             ParameterDirection.Output, false, 0, 0, "@Result",
                                                             DataRowVersion.Default, DBNull.Value);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameter3);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                for (Int32 i = 0; i < nPostionNum; i++)
                {
                    SqlDataReader dr = oneSqlCommand.ExecuteReader();
                    dr.Close();
                }

                UpdatePhaseCompetitors();
                UpdatePhaseCompetitorsPosition();
            }
            catch (System.Exception ee)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ee.Message);
            }
        }

        private void dgvDrawInfo_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            if (dgvDrawInfo.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn || e.RowIndex < 0)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                Int32 iRegisterID = GetFieldValue(dgvDrawInfo, iRowIndex, "RegisterID");
                Int32 iSourcePhaseID = GetFieldValue(dgvDrawInfo, iRowIndex, "SourcePhaseID");
                String strLanguageCode = m_strLanguageCode;

                if (dgvDrawInfo.Columns[iColumnIndex].Name.CompareTo("LongName") == 0)
                {
                    InitPositionCompetitorsCombBox(ref dgvDrawInfo, iColumnIndex, m_iSelDrawTreeEventID, m_iSelDrawTreePhaseID, m_iSelDrawTreeNodeType, iRegisterID, strLanguageCode);
                }
                else if (dgvDrawInfo.Columns[iColumnIndex].Name.CompareTo("StartPhaseName") == 0)
                {
                    InitPositionPhaseCombBox(ref dgvDrawInfo, iColumnIndex, m_iSelDrawTreeEventID, m_iSelDrawTreePhaseID, strLanguageCode);
                }
                else if (dgvDrawInfo.Columns[iColumnIndex].Name.CompareTo("SourcePhaseName") == 0)
                {
                    InitPositionPhaseCombBox(ref dgvDrawInfo, iColumnIndex, m_iSelDrawTreeEventID, m_iSelDrawTreePhaseID, strLanguageCode);
                }
                else if (dgvDrawInfo.Columns[iColumnIndex].Name.CompareTo("SourceMatchName") == 0)
                {
                    InitPositionMatchCombBox(ref dgvDrawInfo, iColumnIndex, m_iSelDrawTreeEventID, m_iSelDrawTreePhaseID, iSourcePhaseID, strLanguageCode);
                }
            }
        }

        private void dgvDrawInfo_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            String strColumnName = dgvDrawInfo.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvDrawInfo.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                Int32 iItemID = GetFieldValue(dgvDrawInfo, iRowIndex, "ItemID");
                Int32 iRegisterID = GetFieldValue(dgvDrawInfo, iRowIndex, "RegisterID");

                Int32 iInputValue = 0;
                Int32 iInputKey = 0;
                if (CurCell is DGVCustomComboBoxCell)
                {
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                    iInputKey = Convert.ToInt32(CurCell1.Tag);
                }
                else
                {
                    iInputValue = Convert.ToInt32(CurCell.Value);
                }

                if (strColumnName.CompareTo("DrawNumber") == 0)
                {
                    UpdateDrawNumber(m_iSelDrawTreePhaseID, iItemID, iInputValue, 0);
                }
                else if (strColumnName.CompareTo("StartPhasePosition") == 0)
                {
                    UpdateStartPhasePosition(iItemID, iInputValue);
                }
                else if (strColumnName.CompareTo("SourcePhaseRank") == 0)
                {
                    UpdateSourcePhaseRank(iItemID, iInputValue);
                }
                else if (strColumnName.CompareTo("SourceMatchRank") == 0)
                {
                    UpdateSourceMatchRank(iItemID, iInputValue);
                }
                else if (strColumnName.CompareTo("LongName") == 0)
                {
                    UpdatePositionSourceCompetitors(iItemID, m_iSelDrawTreeNodeType, iInputKey);
                }
                else if (strColumnName.CompareTo("StartPhaseName") == 0)
                {
                    UpdatePositionStartPhase(iItemID, iInputKey);
                }
                else if (strColumnName.CompareTo("SourcePhaseName") == 0)
                {
                    UpdatePositionSourcePhase(iItemID, iInputKey);
                }
                else if (strColumnName.CompareTo("SourceMatchName") == 0)
                {
                    UpdatePositionSourceMatch(iItemID, iInputKey);
                }

                UpdatePhaseCompetitors();
                UpdatePhaseCompetitorsPosition();
                dgvDrawInfo.Rows[iRowIndex].Selected = true;
            }
        }

        private void OVRDrawArrangeForm_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.F12)
            {
                try
                {
                    SqlCommand oneSqlCommand = new SqlCommand();
                    oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                    oneSqlCommand.CommandText = "Proc_CopyPhaseCompetitorsPosition";
                    oneSqlCommand.CommandType = CommandType.StoredProcedure;

                    SqlParameter cmdParameter1 = new SqlParameter("@EventID", SqlDbType.Int, 4,
                                                                 ParameterDirection.Input, false, 0, 0, "@EventID",
                                                                 DataRowVersion.Default, m_iSelDrawTreeEventID);
                    SqlParameter cmdParameter2 = new SqlParameter("@PhaseID", SqlDbType.Int, 4,
                                                                 ParameterDirection.Input, false, 0, 0, "@PhaseID",
                                                                 DataRowVersion.Default, m_iSelDrawTreePhaseID);
                    SqlParameter cmdParameter3 = new SqlParameter("@NodeType", SqlDbType.Int, 4,
                                                                 ParameterDirection.Input, false, 0, 0, "@NodeType",
                                                                 DataRowVersion.Default, m_iSelDrawTreeNodeType);
                    SqlParameter cmdParameter4 = new SqlParameter(
                                            "@Result", SqlDbType.Int, 4,
                                            ParameterDirection.Output, true, 0, 0, "",
                                            DataRowVersion.Current, 0);


                    oneSqlCommand.Parameters.Add(cmdParameter1);
                    oneSqlCommand.Parameters.Add(cmdParameter2);
                    oneSqlCommand.Parameters.Add(cmdParameter3);
                    oneSqlCommand.Parameters.Add(cmdParameter4);

                    if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                    {
                        m_drawArrangeModule.DatabaseConnection.Open();
                    }

                    SqlDataReader dr = oneSqlCommand.ExecuteReader();
                    dr.Close();
                }
                catch (System.Exception ee)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ee.Message);
                }
            }
        }

        private void SetEventModelDraw_Click(object sender, EventArgs e)
        {
            if (tvDrawPhaseTree.SelectedNodes.Count < 1 || tvDrawPhaseTree.SelectedNodes[0] == null)
                return;

            DevComponents.AdvTree.Node SelNode = tvDrawPhaseTree.SelectedNodes[0];
            SAxTreeNodeInfo oneSNodeInfo = (SAxTreeNodeInfo)SelNode.Tag;
            if (oneSNodeInfo.iNodeType == -1)
            {
                Int32 iEventID = oneSNodeInfo.iEventID;

                SetEventModelForm frmSetEventModel = new SetEventModelForm();
                frmSetEventModel.m_DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
                frmSetEventModel.m_strLanguageCode = m_strLanguageCode;
                frmSetEventModel.m_iEventID = iEventID;
                frmSetEventModel.ShowDialog();
                if (frmSetEventModel.DialogResult == DialogResult.OK)
                {
                    if (frmSetEventModel.m_iOpearateTypeID == 1)
                    {
                        if (DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelEventModel"), LocalizationRecourceManager.GetString(m_strSectionName, "MsgAutoEventModel"), MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
                        {
                            return;
                        }
                        else
                        {
                            if (DeleteEventPhases(iEventID))
                            {
                                AxDrawModelEvent modelEvent = AxModelMgr.CreateModelEvent();
                                AxOVRDrawModelHelper modelHelper = new AxOVRDrawModelHelper();
                                modelHelper.m_DatabaseConnection = m_drawArrangeModule.DatabaseConnection;
                                modelHelper.m_strLanguageCode = m_strLanguageCode;
                                bool bRet = modelHelper.CreteDrawEvent(iEventID, modelEvent);
                                if (bRet)
                                    m_strLastSelPhaseTreeNodeKey = "E" + iEventID.ToString();

                                UpdateDrawPhaseTree();

                                m_bUpdateDrawPhaseTree = true;

                                this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emEventModel, -1, iEventID, -1, -1, iEventID, null);
                            }
                        }
                    }
                    else if (frmSetEventModel.m_iOpearateTypeID == 2)
                    {
                        m_strLastSelPhaseTreeNodeKey = "E" + iEventID.ToString();

                        UpdateDrawPhaseTree();

                        m_bUpdateDrawPhaseTree = true;

                        this.m_drawArrangeModule.DataChangedNotify(OVRDataChangedType.emEventModel, -1, iEventID, -1, -1, iEventID, null);
                    }
                }
            }
        }

        #endregion

        #region Assist Functions

        private bool IsPhasePositionNotNull()
        {
            Boolean bResult = false;

            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetPhasePositionStatus";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@EventID", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@EventID",
                                                             DataRowVersion.Default, m_iSelDrawTreeEventID);
                SqlParameter cmdParameter2 = new SqlParameter("@PhaseID", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@PhaseID",
                                                             DataRowVersion.Default, m_iSelDrawTreePhaseID);
                SqlParameter cmdParameter3 = new SqlParameter("@NodeType", SqlDbType.Int, 4,
                                                             ParameterDirection.Input, false, 0, 0, "@NodeType",
                                                             DataRowVersion.Default, m_iSelDrawTreeNodeType);
                SqlParameter cmdParameter4 = new SqlParameter("@Result", SqlDbType.Int, 4,
                                                             ParameterDirection.Output, false, 0, 0, "@Result",
                                                             DataRowVersion.Default, DBNull.Value);

                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameter3);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameter4.Value;
                    switch (iOperateResult)
                    {
                        case 0:
                            bResult = false;
                            break;
                        case 1:
                            bResult = true;
                            break;
                        default:
                            bResult = false;
                            break;
                    }
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

            return bResult;
        }

        private void SetGridStyle(DataGridView dgv)
        {
            dgv.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;

            if (dgv == dgvDrawInfo)
            {
                if (dgvDrawInfo.Columns["DrawNumber"] != null)
                {
                    dgvDrawInfo.Columns["DrawNumber"].ReadOnly = false;
                }
                if (dgvDrawInfo.Columns["LongName"] != null)
                {
                    dgvDrawInfo.Columns["LongName"].ReadOnly = false;
                }
                if (dgvDrawInfo.Columns["StartPhaseName"] != null)
                {
                    dgvDrawInfo.Columns["StartPhaseName"].ReadOnly = false;
                }
                if (dgvDrawInfo.Columns["StartPhasePosition"] != null)
                {
                    dgvDrawInfo.Columns["StartPhasePosition"].ReadOnly = false;
                }
                if (dgvDrawInfo.Columns["SourcePhaseName"] != null)
                {
                    dgvDrawInfo.Columns["SourcePhaseName"].ReadOnly = false;
                }
                if (dgvDrawInfo.Columns["SourcePhaseRank"] != null)
                {
                    dgvDrawInfo.Columns["SourcePhaseRank"].ReadOnly = false;
                }
                if (dgvDrawInfo.Columns["SourceMatchName"] != null)
                {
                    dgvDrawInfo.Columns["SourceMatchName"].ReadOnly = false;
                }
                if (dgvDrawInfo.Columns["SourceMatchRank"] != null)
                {
                    dgvDrawInfo.Columns["SourceMatchRank"].ReadOnly = false;
                }
            }
        }

        private void SetButtonEnable(bool bEnable)
        {
            this.btnChosePhaseComp.Enabled = bEnable;
            this.btnAutoDraw.Enabled = bEnable;
            this.btnCleanDraw.Enabled = bEnable;
            this.btnMatchUp.Enabled = bEnable;
            this.btnCleanMatchUp.Enabled = bEnable;
        }

        private void InitPositionCompetitorsCombBox(ref UIDataGridView GridCtrl, Int32 iColumnIndex, Int32 iEventID, Int32 iPhaseID, Int32 iNodeType, Int32 iRegisterID, String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetPositionSourceCompetitors";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iEventID);
                oneSqlCommand.Parameters.Add(cmdParameter0);

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@NodeType", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iNodeType);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iRegisterID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(sdr, 0, 1);
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void InitPositionPhaseCombBox(ref UIDataGridView GridCtrl, Int32 iColumnIndex, Int32 iEventID, Int32 iPhaseID, String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetPositionSourcePhases";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iEventID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(sdr, 0, 1);
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void InitPositionMatchCombBox(ref UIDataGridView GridCtrl, Int32 iColumnIndex, Int32 iEventID, Int32 iPhaseID, Int32 iSourcePhaseID, String strLanguageCode)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetPositionSourceMatches";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iEventID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@PhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iPhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@SourcePhaseID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iSourcePhaseID);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(sdr, 0, 1);
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateDrawPhaseTree()
        {
            tvDrawPhaseTree.BeginUpdate();
            tvDrawPhaseTree.Nodes.Clear();
            DevComponents.AdvTree.Node oLastSelNode = null;
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetScheduleTree";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@ID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "@ID",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@Type", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "@Type",
                            DataRowVersion.Current, -5);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@Option", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "@Option",
                            DataRowVersion.Current, 1);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameter4 = new SqlParameter(
                            "@Option1", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "@Option1",
                            DataRowVersion.Current, 1);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                SqlParameter cmdParameter5 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strLanguageCode);

                oneSqlCommand.Parameters.Add(cmdParameter5);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                int cols = sdr.FieldCount;                                          //获取结果行中的列数


                object[] values = new object[cols];
                if (sdr.HasRows)
                {
                    while (sdr.Read())
                    {
                        String strNodeName = "";
                        String strNodeKey = "";
                        String strFatherNodeKey = "";
                        int iNodeType = -5;//-4表示所有Sport, -3表示Sport，-2表示Discipline，-1表示Event，0表示Phase
                        int iSportID = 0;
                        int iDisciplineID = 0;
                        int iEventID = 0;
                        int iPhaseID = 0;
                        int iPhaseType = 0;
                        int iPhaseSize = 0;
                        int iFatherPhaseID = 0;
                        int iMatchID = 0;
                        int nImage = 0;
                        int nSelectedImage = 0;

                        strNodeName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_NodeName");
                        strNodeKey = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_NodeKey");
                        strFatherNodeKey = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_FatherNodeKey");
                        iNodeType = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_NodeType");
                        iSportID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_SportID");
                        iDisciplineID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_DisciplineID");
                        iEventID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_EventID");
                        iPhaseID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_PhaseID");
                        iPhaseType = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_PhaseType");
                        iPhaseSize = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_PhaseSize");
                        iFatherPhaseID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_FatherPhaseID");
                        iMatchID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_MatchID");
                        nImage = iNodeType + 3;
                        nSelectedImage = iNodeType + 3;

                        SAxTreeNodeInfo oneSNodeInfo = new SAxTreeNodeInfo();
                        oneSNodeInfo.strNodeKey = strNodeKey;
                        oneSNodeInfo.iNodeType = iNodeType;
                        oneSNodeInfo.iSportID = iSportID;
                        oneSNodeInfo.iDisciplineID = iDisciplineID;
                        oneSNodeInfo.iEventID = iEventID;
                        oneSNodeInfo.iPhaseID = iPhaseID;
                        oneSNodeInfo.iPhaseType = iPhaseType;
                        oneSNodeInfo.iPhaseSize = iPhaseSize;
                        oneSNodeInfo.iFatherPhaseID = iFatherPhaseID;
                        oneSNodeInfo.iMatchID = iMatchID;

                        DevComponents.AdvTree.Node oneNode = new DevComponents.AdvTree.Node();
                        oneNode.Text = strNodeName;
                        oneNode.ImageIndex = nImage;
                        oneNode.ImageExpandedIndex = nSelectedImage;
                        oneNode.Tag = oneSNodeInfo;
                        oneNode.DataKey = strNodeKey;
                        oneNode.Expanded = false;

                        if (oneSNodeInfo.iNodeType == -3)
                        {
                            oneNode.Expanded = true;
                        }
                        if (oneSNodeInfo.iNodeType == -2 && oneSNodeInfo.iDisciplineID == m_iDisciplineID)
                        {
                            oneNode.Expanded = true;
                        }

                        DevComponents.AdvTree.Node FatherNode = tvDrawPhaseTree.FindNodeByDataKey(strFatherNodeKey);
                        if (FatherNode == null)
                        {
                            tvDrawPhaseTree.Nodes.Add(oneNode);
                        }
                        else
                        {
                            FatherNode.Nodes.Add(oneNode);
                        }

                        if (m_strLastSelDrawTreeNodeKey == strNodeKey)
                        {
                            oLastSelNode = oneNode;

                            // Expand All Parent Node
                            DevComponents.AdvTree.Node node = oLastSelNode;
                            while (node.Parent != null)
                            {
                                node.Parent.Expanded = true;
                                node = node.Parent;
                            }
                        }
                    }
                }

                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

            tvDrawPhaseTree.EndUpdate();
            tvDrawPhaseTree.SelectedNode = oLastSelNode;
        }

        private void UpdatePhaseCompetitors()
        {
            dgvPlayers.Rows.Clear();
            dgvPlayers.Columns.Clear();

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "proc_GetNoPositionCompetitors";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@EventID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@PhaseID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@NodeType", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = m_iSelDrawTreeEventID;
                cmdParameter1.Value = m_iSelDrawTreePhaseID;
                cmdParameter2.Value = m_iSelDrawTreeNodeType;
                cmdParameter3.Value = m_strLanguageCode;

                oneSqlCommand.Parameters.Add(cmdParameter0);
                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                SqlDataReader dr = oneSqlCommand.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();
                OVRDataBaseUtils.FillDataGridView(dgvPlayers, dt, null, null);

                UpdateTeamMembers();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private bool DelRegisterEvent(string strRegisterID, string strEventID)
        {
            if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_drawArrangeModule.DatabaseConnection.Open();
            }

            try
            {
                #region DML Command Setup for Del Register Event

                SqlCommand cmd = new SqlCommand("proc_DelInsription_DrawModel", m_drawArrangeModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@RegisterID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@RegisterID",
                             DataRowVersion.Current, Convert.ToInt32(strRegisterID));

                SqlParameter cmdParameter2 = new SqlParameter(
                         "@EventID", SqlDbType.Int, 4,
                         ParameterDirection.Input, false, 0, 0, "@EventID",
                         DataRowVersion.Current, Convert.ToInt32(strEventID));

                SqlParameter cmdParameter3 = new SqlParameter(
                             "@Result", SqlDbType.Int, 4,
                             ParameterDirection.Output, false, 0, 0, "@Result",
                             DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(m_strSectionName, "DelInscriptionPromotion_Failed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(m_strSectionName, "DelInscriptionPromotion_Uneffect");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(m_strSectionName, "DelInscriptionPromotion_HasMatch");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default://其余的为删除成功！

                        return true;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }


        private void UpdateTeamMembers()
        {
            dgvTeamMember.Rows.Clear();
            dgvTeamMember.Columns.Clear();

            if (dgvPlayers.SelectedRows.Count != 1)
                return;

            Int32 iColIdx = dgvPlayers.Columns["RegisterID"].Index;

            DataGridViewRow row = new DataGridViewRow();
            row = dgvPlayers.SelectedRows[0];
            Int32 iRowIdx = row.Index;

            string strRegisterID = dgvPlayers.Rows[iRowIdx].Cells[iColIdx].Value.ToString();
            Int32 nRegisterID = Convert.ToInt32(strRegisterID);

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetTeamMember_DrawModel";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = m_iDisciplineID;
                cmdParameter1.Value = nRegisterID;
                cmdParameter2.Value = m_strLanguageCode;

                oneSqlCommand.Parameters.Add(cmdParameter0);
                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                SqlDataReader dr = oneSqlCommand.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();
                OVRDataBaseUtils.FillDataGridView(dgvTeamMember, dt, null, null);
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void UpdateMatchList()
        {
            if (tvDrawPhaseTree.SelectedNodes.Count < 1)
            {
                dgvMatchList.Rows.Clear();
                dgvMatchList.Columns.Clear();
                return;
            }

            cmdSelMatches.Parameters[0].Value = m_iSelDrawTreeEventID;
            cmdSelMatches.Parameters[1].Value = m_iSelDrawTreePhaseID;
            cmdSelMatches.Parameters[2].Value = m_iSelDrawTreeMatchID;
            cmdSelMatches.Parameters[3].Value = m_iSelDrawTreeNodeType;
            cmdSelMatches.Parameters[4].Value = m_strLanguageCode;

            if (cmdSelMatches.Connection.State == System.Data.ConnectionState.Closed)
            {
                cmdSelMatches.Connection.Open();
            }

            SqlDataReader sdr = cmdSelMatches.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Load(sdr);
            sdr.Close();
            OVRDataBaseUtils.FillDataGridView(dgvMatchList, dt, null, null);
        }

        private void UpdatePhaseCompetitorsPosition()
        {
            dgvDrawInfo.Rows.Clear();
            dgvDrawInfo.Columns.Clear();

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "proc_GetPositionCompetitors";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@EventID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@PhaseID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@NodeType", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

                cmdParameter0.Value = m_iSelDrawTreeEventID;
                cmdParameter1.Value = m_iSelDrawTreePhaseID;
                cmdParameter2.Value = m_iSelDrawTreeNodeType;
                cmdParameter3.Value = m_strLanguageCode;

                oneSqlCommand.Parameters.Add(cmdParameter0);
                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                SqlDataReader dr = oneSqlCommand.ExecuteReader();
                OVRDataBaseUtils.FillDataGridViewWithCmb(dgvDrawInfo, dr, "LongName", "StartPhaseName", "SourcePhaseName", "SourceMatchName");
                dr.Close();

                SetGridStyle(dgvDrawInfo);
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        #endregion

        #region DataBase Functions

        private void UpdatePhaseCompetitorsPosition(Int32 iPhaseID, Int32 iRegisterID, string strPosition, Int32 iType)
        {
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_UpdatePhaseCompetitorsPosition";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@PhaseID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@RegisterID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@PhasePosition", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@Type", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter(
                                            "@Result", SqlDbType.Int, 4,
                                            ParameterDirection.Output, true, 0, 0, "",
                                            DataRowVersion.Current, 0);

                cmdParameter0.Value = iPhaseID;
                cmdParameter1.Value = iRegisterID;
                if (strPosition == "")
                {
                    cmdParameter2.Value = 0;
                }
                else
                {
                    cmdParameter2.Value = Convert.ToInt32(strPosition);
                }

                cmdParameter3.Value = iType;

                oneSqlCommand.Parameters.Add(cmdParameter0);
                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameter3);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameter4.Value;
                    switch (iOperateResult)
                    {
                        case -1:
                            {
                                if (DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgUpdatePosition"), LocalizationRecourceManager.GetString(m_strSectionName, "MsgEditPosition"), MessageBoxButtons.YesNo) == DialogResult.Yes)
                                {
                                    UpdatePhaseCompetitorsPosition(iPhaseID, iRegisterID, strPosition, 1);
                                }
                                else
                                {
                                    return;
                                }
                            }

                            break;
                        default:
                            break;
                    }
                }

                UpdatePhaseCompetitorsPosition();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void UpdatePositionSourceCompetitors(Int32 iItemID, Int32 iNodeType, Int32 iRegisterID)
        {
            String strSql;
            String strTableName;
            if (iNodeType == -1)
            {
                strTableName = "TS_Event_Position";
            }
            else if (iNodeType == 0)
            {
                strTableName = "TS_Phase_Position";
            }
            else
            {
                return;
            }

            if( iRegisterID == -2 )
            {
                strSql = "UPDATE " + strTableName + " SET F_RegisterID = NULL WHERE F_ItemID = " + iItemID;
            }
            else
            {
                strSql = "UPDATE " + strTableName + " SET F_RegisterID = " + iRegisterID + " WHERE F_ItemID = " + iItemID;
            }

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdatePositionStartPhase(Int32 iItemID, Int32 iPhaseID)
        {
            String strSql;

            if ( iPhaseID == -1 )
            {
                strSql = "UPDATE TS_Phase_Position SET F_StartPhaseID = NULL WHERE F_ItemID = " + iItemID;
            }
            else
            {
                strSql = "UPDATE TS_Phase_Position SET F_StartPhaseID = " + iPhaseID + " WHERE F_ItemID = " + iItemID;
            }

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdatePositionSourcePhase(Int32 iItemID, Int32 iPhaseID)
        {
            String strSql;

            if ( iPhaseID == -1 )
            {
                strSql = "UPDATE TS_Phase_Position SET F_SourcePhaseID = NULL WHERE F_ItemID = " + iItemID;
            }
            else
            {
                strSql = "UPDATE TS_Phase_Position SET F_SourcePhaseID = " + iPhaseID + " WHERE F_ItemID = " + iItemID;
            }

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdatePositionSourceMatch(Int32 iItemID, Int32 iMatchID)
        {
            String strSql;

            if ( iMatchID == -1 )
            {
                strSql = "UPDATE TS_Phase_Position SET F_SourceMatchID = NULL WHERE F_ItemID = " + iItemID;
            }
            else
            {
                strSql = "UPDATE TS_Phase_Position SET F_SourceMatchID = " + iMatchID + " WHERE F_ItemID = " + iItemID;
            }

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateDrawNumber(Int32 iPhaseID, Int32 iItemID, Int32 iDrawNumber, Int32 iType)
        {
            try
            {
                Int32 iOperateResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_UpdateDrawNumber";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@PhaseID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@ItemID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@PhasePosition", SqlDbType.Int);
                SqlParameter cmdParameter3 = new SqlParameter("@Type", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter(
                                            "@Result", SqlDbType.Int, 4,
                                            ParameterDirection.Output, true, 0, 0, "",
                                            DataRowVersion.Current, 0);

                cmdParameter0.Value = iPhaseID;
                cmdParameter1.Value = iItemID;
                cmdParameter2.Value = iDrawNumber;
                cmdParameter3.Value = iType;

                oneSqlCommand.Parameters.Add(cmdParameter0);
                oneSqlCommand.Parameters.Add(cmdParameter1);
                oneSqlCommand.Parameters.Add(cmdParameter2);
                oneSqlCommand.Parameters.Add(cmdParameter3);
                oneSqlCommand.Parameters.Add(cmdParameter4);

                if (m_drawArrangeModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_drawArrangeModule.DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iOperateResult = (Int32)cmdParameter4.Value;
                    switch (iOperateResult)
                    {
                        case -1:
                            {
                                if (DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgUpdatePosition"), LocalizationRecourceManager.GetString(m_strSectionName, "MsgEditPosition"), MessageBoxButtons.YesNo) == DialogResult.Yes)
                                {
                                    UpdateDrawNumber(iPhaseID, iItemID, iDrawNumber, 1);
                                }
                                else
                                {
                                    return;
                                }
                            }
                            break;
                        default:
                            break;
                    }
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void UpdateStartPhasePosition(Int32 iItemID, Int32 iPhasePosition)
        {
            String strSql;

            if (iPhasePosition == 0)
            {
                strSql = "UPDATE TS_Phase_Position SET F_StartPhasePosition = NULL WHERE F_ItemID = " + iItemID;
            }
            else
            {
                strSql = "UPDATE TS_Phase_Position SET F_StartPhasePosition = " + iPhasePosition + " WHERE F_ItemID = " + iItemID;
            }

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateSourcePhaseRank(Int32 iItemID, Int32 iPhaseRank)
        {
            String strSql;

            if (iPhaseRank == 0)
            {
                strSql = "UPDATE TS_Phase_Position SET F_SourcePhaseRank = NULL WHERE F_ItemID = " + iItemID;
            }
            else
            {
                strSql = "UPDATE TS_Phase_Position SET F_SourcePhaseRank = " + iPhaseRank + " WHERE F_ItemID = " + iItemID;
            }

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void UpdateSourceMatchRank(Int32 iItemID, Int32 iMatchRank)
        {
            String strSql;

            if (iMatchRank == 0)
            {
                strSql = "UPDATE TS_Phase_Position SET F_SourceMatchRank = NULL WHERE F_ItemID = " + iItemID;
            }
            else
            {
                strSql = "UPDATE TS_Phase_Position SET F_SourceMatchRank = " + iMatchRank + " WHERE F_ItemID = " + iItemID;
            }

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_drawArrangeModule.DatabaseConnection;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        #endregion
    }
}
