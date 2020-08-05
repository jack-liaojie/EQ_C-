using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRRegister
{
    public delegate void OrientateSelPlayerDelegate(string strGroupID, string strPlayerID);
    public delegate void UpdateRegisterDisplayDelegate(bool bUpdateSel);

    public partial class OVRRegisterForm
    {
        static string strInscriptionName = "OVRInscriptionInfo";
        private int m_iInscriptionType = 0;   //0: Inscription by Event, 1:Inscription by Player
        private int m_iSelEventID = -1;
        private string m_strSelGroupID_Ins = "";
        private int m_iCurSelIndex = -1;

        private DataTable m_dtEvent = new DataTable();
        private DataTable m_dtFederation = new DataTable();
        private DataTable m_tbRegType = new DataTable();

        OVRRegisterDisplayForm m_frmOVRRegisterDisplay;

        UpdateRegisterDisplayDelegate m_dgUpdatePlayerGrid;

        private void InitGridViewStyleInInscription()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvFederation);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvAvailable);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvPlayer);

            dgvAvailable.RowHeadersVisible = true;
            dgvPlayer.RowHeadersVisible = true;
        }

        private void InscriptionLabLocalization()
        {
            this.tabInscription.Text = LocalizationRecourceManager.GetString(strInscriptionName, "tabInscription");
            this.gbInscriptionType.Text = LocalizationRecourceManager.GetString(strInscriptionName, "GroupBox");
            this.radioEvent.Text = LocalizationRecourceManager.GetString(strInscriptionName, "RadioEvent");
            this.radioRegister.Text = LocalizationRecourceManager.GetString(strInscriptionName, "RadioRegister");
            this.btnAllInscribe.Text = LocalizationRecourceManager.GetString(strInscriptionName, "btnAllRegister");
            this.btn_Register.Text = LocalizationRecourceManager.GetString(strInscriptionName, "btnRegister");
            this.lbEvent.Text = LocalizationRecourceManager.GetString(strInscriptionName, "lbEvent");
            this.lbAvailable.Text = LocalizationRecourceManager.GetString(strInscriptionName, "lbAvailable");
            this.lbRegister.Text = LocalizationRecourceManager.GetString(strInscriptionName, "lbRegister");
            this.btnAdd.Text = LocalizationRecourceManager.GetString(strInscriptionName, "btnInscribe");
            this.btnAddAll.Text = LocalizationRecourceManager.GetString(strInscriptionName, "btnInscribeAll");
            this.btnDel.Text = LocalizationRecourceManager.GetString(strInscriptionName, "btnRemove");
            this.btnDelAll.Text = LocalizationRecourceManager.GetString(strInscriptionName, "btnRemoveAll");
            this.lbRegTypeFliter.Text = LocalizationRecourceManager.GetString(strRegisterSectionName, "lbFliter");
            this.MenuAdd.Text = LocalizationRecourceManager.GetString(strInscriptionName, "MenuAddRegister");
            this.MenuEdit.Text = LocalizationRecourceManager.GetString(strInscriptionName, "MenuEditRegister");
            this.MenuDelete.Text = LocalizationRecourceManager.GetString(strInscriptionName, "MenuDeleteRegister");

            this.HorseInscription.Text = LocalizationRecourceManager.GetString(strInscriptionName, "HorseInscription");
        }

        #region User Interface Operation

        private void InscriptionLoadData()
        {
            UpdateAthleteFilterCombo();
            UpdateRegTypeCombo();

            UpdateEventCombo();
            UpdateFederationList();
            UpdateAvailableGrid();
            UpdatePlayerGrid();

            m_frmOVRRegisterDisplay = new OVRRegisterDisplayForm("OVRRegisterInfo");
            m_frmOVRRegisterDisplay.Owner = this;
            m_frmOVRRegisterDisplay.DatabaseConnection = m_RegisterModule.DatabaseConnection;

            m_dgUpdatePlayerGrid = m_frmOVRRegisterDisplay.ResetRegisterGrid;
        }

        public void OrientateToSelPlayer(string strGroupID, string strPlayerID)
        {
            if(m_iInscriptionType == 0)
            {
                radioRegister.Checked = true;
                radioRegister_Click(null, null);
            }

            dgvFederation.ClearSelection();
            dgvAvailable.ClearSelection();

            for(int i = 0; i< dgvFederation.Rows.Count; i++)
            {
                string strTempGropID = dgvFederation.Rows[i].Cells["ID"].Value.ToString();
                if (strTempGropID == strGroupID)
                {
                    
                    dgvFederation.FirstDisplayedScrollingRowIndex = i;
                    dgvFederation.Rows[i].Selected = true;

                    m_iCurSelIndex = i;
                    m_strSelGroupID_Ins = strGroupID;
                    break;
                }
            }

            for (int i = 0; i < dgvAvailable.Rows.Count; i++)
            {
                string strTempPlayerID = dgvAvailable.Rows[i].Cells["RegisterID"].Value.ToString();
                if(strTempPlayerID == strPlayerID)
                {
                    dgvAvailable.FirstDisplayedScrollingRowIndex = i;
                    dgvAvailable.Rows[i].Selected = true;

                    break;
                }
            }
        }

        private void btnRefresh_Click(object sender, EventArgs e)
        {
            InscriptionLoadData();
        }

        private void btn_Register_Click(object sender, EventArgs e)
        {
            if (!m_frmOVRRegisterDisplay.Visible)
                m_frmOVRRegisterDisplay.Show();
        }

        private void radioEvent_Click(object sender, EventArgs e)
        {
            this.lbAvailable.Text = LocalizationRecourceManager.GetString(strInscriptionName, "lbAvailable");
            this.lbRegister.Text = LocalizationRecourceManager.GetString(strInscriptionName, "lbRegister");

            m_iInscriptionType = 0;
            m_iSelEventID = cmbEvent.SelectedItem == null ? -1 : Convert.ToInt32(cmbEvent.SelectedValue);
            cmbEvent.Enabled = true;
            btnAllInscribe.Enabled = true;

            lbRegTypeFliter.Hide();
            cmbAthleteFliter.Hide();
            cmbRegTypeFliter.Hide();
            btnAdd.Show();
            btnAddAll.Show();
            btnDel.Show();
            btnDelAll.Show();

            UpdateAvailableGrid();
            UpdatePlayerGrid();
        }

        private void radioRegister_Click(object sender, EventArgs e)
        {
            this.lbAvailable.Text = LocalizationRecourceManager.GetString(strInscriptionName, "lbAllRegister");
            this.lbRegister.Text = LocalizationRecourceManager.GetString(strInscriptionName, "lbAllEvent");

            m_iInscriptionType = 1;
            m_iSelEventID = -1;
            cmbEvent.Enabled = false;
            btnAllInscribe.Enabled = false;

            lbRegTypeFliter.Show();
            cmbAthleteFliter.Show();
            cmbRegTypeFliter.Show();
            btnAdd.Hide();
            btnAddAll.Hide();
            btnDel.Hide();
            btnDelAll.Hide();

            UpdateAvailableGrid();
            UpdatePlayerGrid();
        }

        private void cmbEvent_SelectionChangeCommitted(object sender, EventArgs e)
        {
            if (cmbEvent.SelectedItem == null)
                m_iSelEventID = -1;
            else
                m_iSelEventID = Convert.ToInt32(cmbEvent.SelectedValue);

            m_RegisterModule.SetReportContext("EventID", m_iSelEventID.ToString());

            if (m_iInscriptionType == 0)
            {
                UpdateAvailableGrid();
                UpdatePlayerGrid();
            }
        }

        private void cmbAthleteFilter_SelectionChangeCommitted(object sender, EventArgs e)
        {
            if (m_iInscriptionType == 0)
                return;

            UpdateRegTypeCombo();
            UpdateAvailableGrid();
        }

        private void cmbRegTypeFliter_SelectionChangeCommitted(object sender, EventArgs e)
        {
            if (m_iInscriptionType == 0)
                return;

            UpdateAvailableGrid();
        }

        private void dgvFederation_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvFederation.SelectedRows.Count < 1)
            {
                m_strSelGroupID_Ins = "";
                m_iCurSelIndex = -1;

                if (m_iSportGroupType == 1)
                    m_RegisterModule.SetReportContext("FederationID", "-1");
                else if (m_iSportGroupType == 2)
                    m_RegisterModule.SetReportContext("NOCID", "-1");
                else if (m_iSportGroupType == 3)
                    m_RegisterModule.SetReportContext("ClubID", "-1");
                else if (m_iSportGroupType == 4)
                    m_RegisterModule.SetReportContext("DelegationID", "-1");
                return;
            }

            int irow = dgvFederation.SelectedRows[0].Index;
            m_iCurSelIndex = irow;
            m_strSelGroupID_Ins = dgvFederation.Rows[irow].Cells["ID"].Value.ToString();

            UpdateAvailableGrid();
            UpdatePlayerGrid();

            if (m_iSportGroupType == 1)
                m_RegisterModule.SetReportContext("FederationID", m_strSelGroupID_Ins);
            else if (m_iSportGroupType == 2)
                m_RegisterModule.SetReportContext("NOCID", m_strSelGroupID_Ins);
            else if (m_iSportGroupType == 3)
                m_RegisterModule.SetReportContext("ClubID", m_strSelGroupID_Ins);
            else if (m_iSportGroupType == 4)
                m_RegisterModule.SetReportContext("DelegationID", m_strSelGroupID_Ins);
        }

        private void btnAllInscribe_Click(object sender, EventArgs e)
        {
            if (m_iSelEventID < 0)
                return;
            string strMsgBox = LocalizationRecourceManager.GetString(strInscriptionName, "MsgInscribeAll");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;
            
            if (!AllRegisterInscribe(m_iSelEventID)) return;

            UpdateAvailableGrid();
            UpdatePlayerGrid();

            m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterInscription, m_iActiveDiscipline, m_iSelEventID, -1, -1, -1, null);
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            if (!AddRegisterEvent()) return;

            m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterInscription, m_iActiveDiscipline, m_iSelEventID, -1, -1, -1, null);
        }

        private void dgvAvailable_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            if (m_iInscriptionType != 0)
                return;

            if (!AddRegisterEvent()) return;

            m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterInscription, m_iActiveDiscipline, m_iSelEventID, -1, -1, -1, null);
        }

        private bool AddRegisterEvent()
        {
            if (cmbEvent.SelectedItem == null || dgvFederation.SelectedRows.Count < 1)
                return false;

            for (int i = 0; i < dgvAvailable.SelectedRows.Count; i++)
            {
                int iRowIdx = dgvAvailable.SelectedRows[i].Index;

                if (dgvAvailable.Rows[iRowIdx].Cells["RegisterID"].Value != null)
                {
                    string strRegisterID = dgvAvailable.Rows[iRowIdx].Cells["RegisterID"].Value.ToString();
                    string strEventID = m_iSelEventID.ToString();

                    if (!AddRegisterEvent(strRegisterID, strEventID))
                    {
                        UpdateAvailableGrid();
                        UpdatePlayerGrid();

                        if (dgvAvailable.Rows.Count > 0)
                        {
                            dgvAvailable.Rows[0].Selected = true;
                        }
                        // If i == 0 , No Register Added, Else Partial Registers Added but Not All
                        return i != 0;
                    }
                }
            }

            UpdateAvailableGrid();
            UpdatePlayerGrid();

            if(dgvAvailable.Rows.Count > 0)
            {
                dgvAvailable.Rows[0].Selected = true; 
            }
            return true;
        }

        private void btnAddAll_Click(object sender, EventArgs e)
        {
            if (cmbEvent.SelectedItem == null || dgvFederation.SelectedRows.Count < 1)
                return;

            for (int i = 0; i < dgvAvailable.Rows.Count; i++)
            {
                int iRowIdx = dgvAvailable.Rows[i].Index;
                string strRegisterID = dgvAvailable.Rows[iRowIdx].Cells["RegisterID"].Value.ToString();
                string strEventID = m_iSelEventID.ToString();

                if (!AddRegisterEvent(strRegisterID, strEventID))
                {
                    if (i == 0)  return; // No Register Added, 
                    else  break;         // Partial Registers Added but Not All
                }
            }

            UpdateAvailableGrid();
            UpdatePlayerGrid();

            m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterInscription, m_iActiveDiscipline, m_iSelEventID, -1, -1, -1, null);
        }

        private void btnDel_Click(object sender, EventArgs e)
        {
            if (!DelRegisterEvent()) return;

            m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterInscription, m_iActiveDiscipline, m_iSelEventID, -1, -1, -1, null);
        }

        private bool DelRegisterEvent()
        {
            if (cmbEvent.SelectedItem == null || dgvFederation.SelectedRows.Count < 1)
                return false;

            if (dgvPlayer.SelectedRows.Count <= 0)
                return false;

            string strPromotion = LocalizationRecourceManager.GetString(strInscriptionName, "DelInscription");

            if (DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return false;

            for (int i = 0; i < dgvPlayer.SelectedRows.Count; i++)
            {
                int iRowIdx = dgvPlayer.SelectedRows[i].Index;
                string strRegisterID = dgvPlayer.Rows[iRowIdx].Cells["RegisterID"].Value.ToString();
                string strEventID = m_iSelEventID.ToString();

                if (!DelRegisterEvent(strRegisterID, strEventID))
                {
                    UpdateAvailableGrid();
                    UpdatePlayerGrid();

                    if (dgvPlayer.Rows.Count > 0)
                    {
                        dgvPlayer.Rows[0].Selected = true;
                    }
                    // If i == 0 , No Register Deleted, Else Partial Registers Deleted but Not All
                    return i != 0;
                }
            }

            UpdateAvailableGrid();
            UpdatePlayerGrid();


            if (dgvPlayer.Rows.Count > 0)
            {
                dgvPlayer.Rows[0].Selected = true;
            }
            return true;
        }

        private void btnDelAll_Click(object sender, EventArgs e)
        {
            if (cmbEvent.SelectedItem == null || dgvFederation.SelectedRows.Count < 1)
                return;

            string strPromotion = LocalizationRecourceManager.GetString(strInscriptionName, "DelInscription");

            if (DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            for (int i = 0; i < dgvPlayer.Rows.Count; i++)
            {
                int iRowIdx = dgvPlayer.Rows[i].Index;
                string strRegisterID = dgvPlayer.Rows[iRowIdx].Cells["RegisterID"].Value.ToString();
                string strEventID = m_iSelEventID.ToString();

                if (!DelRegisterEvent(strRegisterID, strEventID))
                {
                    if (i == 0) return; // No Register Deleted, 
                    else break;         // Partial Registers Deleted but Not All
                }
            }
            UpdateAvailableGrid();
            UpdatePlayerGrid();

            m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterInscription, m_iActiveDiscipline, m_iSelEventID, -1, -1, -1, null);
        }

        private void dgvAvailable_SelectionChanged(object sender, EventArgs e)
        {
            if (m_iInscriptionType != 1 || dgvAvailable.SelectedRows.Count < 1)
                return;

            UpdatePlayerGrid();
        }

        private void dgvAvailable_MouseDown(object sender, MouseEventArgs e)
        {
            dgvAvailable.ContextMenuStrip = null;

            if (e.Button != MouseButtons.Right)
                return;

            dgvAvailable.Focus();
            DataGridView.HitTestInfo hitTestInfo;
            hitTestInfo = dgvAvailable.HitTest(e.X, e.Y);

            if (hitTestInfo.RowIndex < 0 && dgvAvailable.SelectedRows.Count == 0)
            {
                MenuAdd.Enabled = true;
                MenuEdit.Enabled = false;
                MenuDelete.Enabled = false;

                //For EQ
                HorseInscription.Enabled = false;

                dgvAvailable.ContextMenuStrip = RegistercontextMenu;
            }
            else
            {
                if (hitTestInfo.RowIndex >= 0)
                {
                    dgvAvailable.ClearSelection();
                    dgvAvailable.Rows[hitTestInfo.RowIndex].Selected = true;
                    dgvAvailable.CurrentCell = dgvAvailable.Rows[hitTestInfo.RowIndex].Cells[hitTestInfo.ColumnIndex];
                }
                MenuAdd.Enabled = true;
                MenuEdit.Enabled = true;
                MenuDelete.Enabled = true;

                //For EQ
                HorseInscription.Enabled = false;

                dgvAvailable.ContextMenuStrip = RegistercontextMenu;
            }
        }

        private void dgvPlayer_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (m_iInscriptionType != 1)
                return;
            if (e.RowIndex >= dgvPlayer.RowCount || e.RowIndex < 0)
                return;
            if (e.ColumnIndex != dgvPlayer.Columns["Active"].Index)
                return;

            string strRegisterID = dgvPlayer.Rows[e.RowIndex].Cells["RegisterID"].Value.ToString();
            string strEventID = dgvPlayer.Rows[e.RowIndex].Cells["EventID"].Value.ToString();

            if (Convert.ToInt32(dgvPlayer.Rows[e.RowIndex].Cells[e.ColumnIndex].Value) == 1)
            {
                DelRegisterEvent(strRegisterID, strEventID);
                UpdatePlayerGrid();
            }
            else
            {
                AddRegisterEvent(strRegisterID, strEventID);
                UpdatePlayerGrid();
            }

            if(dgvPlayer.Rows.Count > 0)
            {
                dgvPlayer.Rows[e.RowIndex].Selected = true;
            }
            int iEventID = Convert.ToInt32(strEventID);
            m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterInscription, m_iActiveDiscipline, iEventID, -1, -1, -1, null);
        }

        private void dgvPlayer_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            int iColumnIndex = e.ColumnIndex;
            if (iColumnIndex < 0)
                return;

            if (dgvPlayer.Columns[iColumnIndex].Name.CompareTo("Reserve") == 0)
            {
                FillReserveCombo();
            }
        }

        private void dgvPlayer_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= dgvPlayer.RowCount || e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            int iRegisterColIdx = dgvPlayer.Columns["RegisterID"].Index;
            string strRegisterID = dgvPlayer.Rows[e.RowIndex].Cells[iRegisterColIdx].Value.ToString();

            string strEventID;
            if (m_iInscriptionType == 1)
            {
                int iEventColIdx = dgvPlayer.Columns["EventID"].Index;
                strEventID = dgvPlayer.Rows[e.RowIndex].Cells[iEventColIdx].Value.ToString();
            }
            else
                strEventID = m_iSelEventID.ToString();

            int iEventID = Convert.ToInt32(strEventID);
            int iRegisterID = Convert.ToInt32(strRegisterID);

            int iColIdx = e.ColumnIndex;
            string strEditValue = "";
            if (dgvPlayer.Rows[e.RowIndex].Cells[iColIdx].Value != null)
            {
                strEditValue = dgvPlayer.Rows[e.RowIndex].Cells[iColIdx].Value.ToString();
            }

            bool bUpdateResult = true;
            if (dgvPlayer.Columns[e.ColumnIndex].HeaderText.CompareTo("Seed") == 0)
            {
                bUpdateResult = UpdateInscriptionSeed(strRegisterID, strEventID, strEditValue);

                if(bUpdateResult) 
                    m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterModify, m_iActiveDiscipline, iEventID, -1, -1, iRegisterID, null);
            }
            else if (dgvPlayer.Columns[e.ColumnIndex].HeaderText.CompareTo("InscriptionResult") == 0)
            {
                bUpdateResult = UpdateInscriptionResult(strRegisterID, strEventID, strEditValue);

                if (bUpdateResult) 
                    m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterModify, m_iActiveDiscipline, iEventID, -1, -1, iRegisterID, null);
            }
            else if (dgvPlayer.Columns[e.ColumnIndex].HeaderText.CompareTo("InscriptionNum") == 0)
            {
                bUpdateResult = UpdateInscriptionNum(strRegisterID, strEventID, strEditValue);

                if (bUpdateResult) 
                    m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterModify, m_iActiveDiscipline, iEventID, -1, -1, iRegisterID, null);
            }
            else if (dgvPlayer.Columns[e.ColumnIndex].HeaderText.CompareTo("InscriptionRank") == 0)
            {
                bUpdateResult = UpdateInscriptionRank(strRegisterID, strEventID, strEditValue);

                if (bUpdateResult) 
                    m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterModify, m_iActiveDiscipline, iEventID, -1, -1, iRegisterID, null);
            }
            else if(dgvPlayer.Columns[e.ColumnIndex].HeaderText.CompareTo("Reserve") == 0)
            {
                DGVCustomComboBoxCell CurCell = dgvPlayer.Rows[e.RowIndex].Cells[e.ColumnIndex] as DGVCustomComboBoxCell;
                int  iInputKey = Convert.ToInt32(CurCell.Tag);

                bUpdateResult = UpdateInscriptionReserve(strRegisterID, strEventID, iInputKey);
                if (bUpdateResult)
                    m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterModify, m_iActiveDiscipline, iEventID, -1, -1, iRegisterID, null);

            }

            if(!bUpdateResult)
            {
                int iSelIdex = e.RowIndex;
                UpdatePlayerGrid();
                if(dgvPlayer.Rows.Count > 0)
                {
                    dgvPlayer.ClearSelection();
                    if (iSelIdex < 0 || iSelIdex >= dgvPlayer.Rows.Count)
                    {
                        iSelIdex = 0;
                    }
                    dgvPlayer.Rows[iSelIdex].Selected = true;
                    dgvPlayer.FirstDisplayedScrollingRowIndex = iSelIdex;

                }
            }
        }

        private void dgvPlayer_MouseDown(object sender, MouseEventArgs e)
        {
            dgvPlayer.ContextMenuStrip = null;

            if (m_iInscriptionType != 0)
                return;

            if (e.Button != MouseButtons.Right)
                return;

            dgvPlayer.Focus();
            DataGridView.HitTestInfo hitTestInfo;
            hitTestInfo = dgvPlayer.HitTest(e.X, e.Y);

            if (hitTestInfo.RowIndex >= 0 || dgvPlayer.SelectedRows.Count > 0)
            {
                if(hitTestInfo.RowIndex >= 0)
                {
                    dgvPlayer.ClearSelection();
                    dgvPlayer.Rows[hitTestInfo.RowIndex].Selected = true;
                    dgvPlayer.CurrentCell = dgvPlayer.Rows[hitTestInfo.RowIndex].Cells[hitTestInfo.ColumnIndex];
                }
                MenuAdd.Enabled = false;
                MenuEdit.Enabled = true;
                MenuDelete.Enabled = false;

                //For EQ
                HorseInscription.Enabled = true;

                dgvPlayer.ContextMenuStrip = RegistercontextMenu;
            }
        }

        private void MenuAdd_Click(object sender, EventArgs e)
        {
            int iSelRowIndex = 0;
            if(dgvAvailable.SelectedRows.Count != 0)
            {
                iSelRowIndex = dgvAvailable.SelectedRows[0].Index;
            }

            RegisterEditForm frmRegisterEdit = new RegisterEditForm(strRegisterSectionName);
            frmRegisterEdit.DatabaseConnection = m_RegisterModule.DatabaseConnection;
            frmRegisterEdit.module = m_RegisterModule;

            sDlgParam sAdd = new sDlgParam();
            sAdd.bAddDlg = true;
            frmRegisterEdit.m_stDlgParam = sAdd;

            int iGroupType = m_iSportGroupType;
            if (iGroupType == 1)
            {
                frmRegisterEdit.m_strFederationID = m_strSelGroupID_Ins;
            }
            else if (iGroupType == 2)
            {
                frmRegisterEdit.m_strNOCCode = m_strSelGroupID_Ins;
            }
            else if (iGroupType == 3)
            {
                frmRegisterEdit.m_strClubID = m_strSelGroupID_Ins;
            }
            else if (iGroupType == 4)
            {
                frmRegisterEdit.m_strDelegationID = m_strSelGroupID_Ins;
            }
            frmRegisterEdit.m_strLanguageCode = m_strActiveLanguage;
            frmRegisterEdit.m_iAtciveDesciplineID = m_iActiveDiscipline;
            frmRegisterEdit.m_iGroupType = iGroupType;

            if (m_iInscriptionType == 0)
            {
                string strEventSex = "";
                string strEventRegType = "";
                if (m_iSelEventID >= 0)
                {
                    GetEventInfo(m_iSelEventID, ref strEventSex, ref strEventRegType);
                }
                frmRegisterEdit.m_strRegTypeID = strEventRegType;
                frmRegisterEdit.m_strSexCode = strEventSex;
            }
            frmRegisterEdit.ShowDialog();

            if (frmRegisterEdit.DialogResult == DialogResult.OK)
            {
                UpdateAvailableGrid();

                if (null != m_dgUpdatePlayerGrid)
                {
                    m_dgUpdatePlayerGrid(true);
                }


                dgvAvailable.ClearSelection();
                if (dgvAvailable.Rows.Count > 0)
                {
                    if (iSelRowIndex >= 0)
                    {
                        dgvAvailable.Rows[iSelRowIndex].Selected = true;
                        dgvAvailable.FirstDisplayedScrollingRowIndex = iSelRowIndex;
                    }
                    else
                    {
                        dgvAvailable.Rows[0].Selected = true;
                        dgvAvailable.FirstDisplayedScrollingRowIndex = 0;
                    }
                }
               
                // Cause Data Update In RegisterInfo
                m_bRegTab_RegChanged = true;
            }
        }

        private void MenuDelete_Click(object sender, EventArgs e)
        {
            string strMsgBox = LocalizationRecourceManager.GetString(strRegisterSectionName, "DelAthleteMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            int iRowIdx = dgvAvailable.CurrentRow.Index;
            int iRegisterID = Convert.ToInt32(dgvAvailable.Rows[iRowIdx].Cells["RegisterID"].Value);

            bool bResult = false;
            bResult = DeleteRegister(iRegisterID);
            if (bResult)
            {
                UpdateAvailableGrid();

                if (null != m_dgUpdatePlayerGrid)
                {
                    m_dgUpdatePlayerGrid(true);
                }
                // Cause Data Update In RegisterInfo
                m_bRegTab_RegChanged = true;

                m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterDel, m_iActiveDiscipline, -1, -1, -1, iRegisterID, null);

                if(dgvAvailable.Rows.Count > 0)
                {
                    if (iRowIdx >= dgvAvailable.Rows.Count)
                        iRowIdx = dgvAvailable.Rows.Count - 1;

                    dgvAvailable.ClearSelection();

                    if (iRowIdx >= 0)
                    {
                        dgvAvailable.Rows[iRowIdx].Selected = true;
                        dgvAvailable.CurrentCell = dgvAvailable.Rows[iRowIdx].Cells[1];
                        dgvAvailable.FirstDisplayedScrollingRowIndex = iRowIdx;
                    }
                }
               
            }
        }

        private void MenuEdit_Click(object sender, EventArgs e)
        {
            DataGridView dgTemp = new DataGridView();

            if (dgvAvailable.Focused)
            {
                dgTemp = dgvAvailable;
            }
            else if (dgvPlayer.Focused)
            {
                dgTemp = dgvPlayer;
            }

            int iRowIdx = dgTemp.CurrentRow.Index;
            int iRegTypeID = Convert.ToInt32(dgTemp.Rows[iRowIdx].Cells["RegTypeID"].Value);
            int iRegisterID = Convert.ToInt32(dgTemp.Rows[iRowIdx].Cells["RegisterID"].Value);

            RegisterEditForm frmRegisterEdit = new RegisterEditForm(strRegisterSectionName);
            frmRegisterEdit.DatabaseConnection = m_RegisterModule.DatabaseConnection;
            frmRegisterEdit.module = m_RegisterModule;

            if (iRegTypeID != 2 && iRegTypeID != 3)
            {
                sDlgParam sEditCompetitor = new sDlgParam();
                sEditCompetitor.bEditCompetitorDlg = true;
                frmRegisterEdit.m_stDlgParam = sEditCompetitor;
            }
            else
            {
                sDlgParam sEditMember = new sDlgParam();
                sEditMember.bEditMemberDlg = true;
                frmRegisterEdit.m_stDlgParam = sEditMember;
            }

            int iGroupType = m_iSportGroupType;
            if (iGroupType == 1)
            {
                frmRegisterEdit.m_strFederationID = m_strSelGroupID_Ins;
            }
            else if (iGroupType == 2)
            {
                frmRegisterEdit.m_strNOCCode = m_strSelGroupID_Ins;
            }
            else if (iGroupType == 3)
            {
                frmRegisterEdit.m_strClubID = m_strSelGroupID_Ins;
            }
            else if (iGroupType == 4)
            {
                frmRegisterEdit.m_strDelegationID = m_strSelGroupID_Ins;
            }
            frmRegisterEdit.m_strRegID = iRegisterID.ToString();
            frmRegisterEdit.m_strRegTypeID = iRegTypeID.ToString();
            frmRegisterEdit.m_iGroupType = iGroupType;
            frmRegisterEdit.m_strLanguageCode = m_strActiveLanguage;
            frmRegisterEdit.ShowDialog();

            if (frmRegisterEdit.DialogResult == DialogResult.OK)
            {
                if (dgTemp == dgvAvailable)
                    UpdateAvailableGrid();
                else
                    UpdatePlayerGrid();

                if (null != m_dgUpdatePlayerGrid)
                {
                    m_dgUpdatePlayerGrid(true);
                }

                // Cause Data Update In RegisterInfo
                m_bRegTab_RegChanged = true;

                m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterModify, m_iActiveDiscipline, -1, -1, -1, iRegisterID, null);
            }

            if(dgTemp.Rows.Count > 0)
            {
                dgTemp.ClearSelection();
                dgTemp.Rows[iRowIdx].Selected = true;
                dgTemp.CurrentCell = dgTemp.Rows[iRowIdx].Cells[1];
                dgTemp.FirstDisplayedScrollingRowIndex = iRowIdx;

            }
        }

        #endregion

        #region UI Update Functions

        private void UpdateEventCombo()
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            try
            {
                #region DML Command Setup for daEvent
                SqlCommand cmd = new SqlCommand("Proc_GetEventList", m_RegisterModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                           "@DisciplineID", SqlDbType.Int, 0,
                            ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                           DataRowVersion.Current, m_iActiveDiscipline);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strActiveLanguage);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                m_dtEvent.Clear();
                m_dtEvent.Load(dr);
                dr.Close();

                cmbEvent.DisplayMember = "F_Name";
                cmbEvent.ValueMember = "F_Key";
                cmbEvent.DataSource = m_dtEvent;

                if (cmbEvent.Items.Count > 0)
                {
                    if (m_iSelEventID > 0)
                        cmbEvent.SelectedValue = m_iSelEventID;
                    else
                        cmbEvent.SelectedItem = null;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void UpdateAthleteFilterCombo()
        {
            this.cmbAthleteFliter.Items.Clear();
            this.cmbAthleteFliter.Items.Add(LocalizationRecourceManager.GetString(strRegisterSectionName, "cmbFliter_None"));
            this.cmbAthleteFliter.Items.Add(LocalizationRecourceManager.GetString(strRegisterSectionName, "cmbFliter_Athlete"));
            this.cmbAthleteFliter.Items.Add(LocalizationRecourceManager.GetString(strRegisterSectionName, "cmbFliter_NonAthlete"));

            cmbAthleteFliter.SelectedIndex = 0;
        }

        private void UpdateRegTypeCombo()
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            try
            {
                SqlCommand cmd = new SqlCommand("Proc_GetRegTypeInfo_WithAthlete", m_RegisterModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter2 = new SqlParameter("@AthleteFliterID", SqlDbType.Int);
                cmdParameter1.Value = m_strActiveLanguage;
                cmdParameter2.Value = cmbAthleteFliter.SelectedIndex;
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);

                SqlDataReader dr = cmd.ExecuteReader();
                m_tbRegType.Clear();
                m_tbRegType.Load(dr);
                dr.Close();
                string strNone = LocalizationRecourceManager.GetString(strRegisterSectionName, "cmbFliter_None");
                m_tbRegType.Rows.Add(strNone, -1);

                cmbRegTypeFliter.DisplayMember = "F_RegTypeLongDescription";
                cmbRegTypeFliter.ValueMember = "F_RegTypeID";
                cmbRegTypeFliter.DataSource = m_tbRegType;

                cmbRegTypeFliter.SelectedValue = -1;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void FillReserveCombo()
        {
            DataTable table = new DataTable();
            table.Columns.Add("F_Reserve", typeof(string));
            table.Columns.Add("F_Vaule", typeof(int));

            table.Rows.Add("Yes", "1");
            table.Rows.Add("No", "0");
            table.Rows.Add("", "-1");
            (dgvPlayer.Columns["Reserve"] as DGVCustomComboBoxColumn).FillComboBoxItems(table, "F_Reserve", "F_Vaule");
        }

        private void UpdateFederationList()
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get Federation List
                SqlCommand cmd = new SqlCommand("Proc_GetActiveGroupInfo", m_RegisterModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                          "@DisciplineID", SqlDbType.Int, 0,
                           ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                          DataRowVersion.Current, m_iActiveDiscipline);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, m_strActiveLanguage);
                SqlParameter cmdParameter3 = new SqlParameter(
                          "@GroupType", SqlDbType.Int, 0,
                          ParameterDirection.Input, false, 0, 0, "@GroupType",
                          DataRowVersion.Current, m_iSportGroupType);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();
                OVRDataBaseUtils.FillDataGridView(dgvFederation, dt, null, null);

                if(dgvFederation.Rows.Count > 0)
                {
                    dgvFederation.ClearSelection();
                    if (m_iCurSelIndex >= 0 && m_iCurSelIndex < dgvFederation.RowCount)
                    {
                        dgvFederation.Rows[m_iCurSelIndex].Selected = true;
                        dgvFederation.FirstDisplayedScrollingRowIndex = m_iCurSelIndex;
                    }
                }
              
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void UpdateAvailableGrid()
        {
            if (m_iInscriptionType == 0)
            {
                if (dgvFederation.SelectedRows.Count > 0 && cmbEvent.SelectedItem != null && cmbEvent.SelectedIndex != 0)
                {
                    int iEventID = Convert.ToInt32(cmbEvent.SelectedValue);
                    string strSelGroupID = dgvFederation.SelectedRows[0].Cells["ID"].Value.ToString();
                    UpdateAvailableGrid(iEventID, strSelGroupID);
                }
                else
                {
                    dgvAvailable.Rows.Clear();
                }
            }
            else
            {
                if (dgvFederation.SelectedRows.Count > 0)
                {
                    string strSelGroupID = dgvFederation.SelectedRows[0].Cells["ID"].Value.ToString();
                    UpdateAvailableGrid(strSelGroupID);
                }
                else
                {
                    dgvAvailable.Rows.Clear();
                }
            }
        }

        private void UpdateAvailableGrid(int iEventID, string strGroupID)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get AvailableRegister List

                SqlCommand cmd = new SqlCommand("Proc_Register_GetEventNoInscription", m_RegisterModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@EventID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@GroupID", SqlDbType.NVarChar,9);
                SqlParameter cmdParameter3 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter4 = new SqlParameter("@GroupType", SqlDbType.Int);
                cmdParameter1.Value = iEventID;
                cmdParameter2.Value = strGroupID;
                cmdParameter3.Value = m_strActiveLanguage;
                cmdParameter4.Value = m_iSportGroupType;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();
                OVRDataBaseUtils.FillDataGridView(dgvAvailable, dt, null, null);

                if (dgvAvailable.Columns["RegTypeID"] != null)
                {
                    dgvAvailable.Columns["RegTypeID"].Visible = false;
                }
                if (dgvAvailable.Columns["SexCode"] != null)
                {
                    dgvAvailable.Columns["SexCode"].Visible = false;
                }
                if(dgvAvailable.Columns["RegisterID"] != null)
                {
                    dgvAvailable.Columns["RegisterID"].Visible = false;
                }
                dgvAvailable.ClearSelection();

                UpdateGridCellToolTip(ref dgvAvailable);
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }

        }

        private void UpdateAvailableGrid(string strGroupID)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            try
            {
                int iSelAthleteID = cmbAthleteFliter.SelectedIndex;
                int iSelRegTypeID = Convert.ToInt32(cmbRegTypeFliter.SelectedValue);

                SqlCommand cmd = new SqlCommand("Proc_Register_GetGroupAllRegister", m_RegisterModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@GroupType", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@GroupID", SqlDbType.NVarChar, 9);
                SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter3 = new SqlParameter("@DisciplineID", SqlDbType.Int);
                SqlParameter cmdParameter4 = new SqlParameter("@RegTypeID", SqlDbType.Int);
                SqlParameter cmdParameter5 = new SqlParameter("@AthleteID", SqlDbType.Int);

                cmdParameter0.Value = m_iSportGroupType;
                cmdParameter1.Value = strGroupID;
                cmdParameter2.Value = m_strActiveLanguage;
                cmdParameter3.Value = m_iActiveDiscipline;
                if (iSelRegTypeID == -1)
                {
                    cmdParameter4.Value = DBNull.Value;
                }
                else
                {
                    cmdParameter4.Value = iSelRegTypeID;
                }
                cmdParameter5.Value = iSelAthleteID;

                cmd.Parameters.Add(cmdParameter0);
                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameter5);

                SqlDataReader dr = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(dr);
                dr.Close();
                OVRDataBaseUtils.FillDataGridView(dgvAvailable, dt, null, null);

                if (dgvAvailable.Columns["RegTypeID"] != null)
                {
                    dgvAvailable.Columns["RegTypeID"].Visible = false;
                }
                if (dgvAvailable.Columns["SexCode"] != null)
                {
                    dgvAvailable.Columns["SexCode"].Visible = false;
                }
                if (dgvAvailable.Columns["RegisterID"] != null)
                {
                    dgvAvailable.Columns["RegisterID"].Visible = false;
                }

               dgvAvailable.ClearSelection();

                UpdateGridCellToolTip(ref dgvAvailable);
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void UpdatePlayerGrid()
        {
            if (m_iInscriptionType == 0)
            {
                if (dgvFederation.SelectedRows.Count > 0 && cmbEvent.SelectedItem != null && cmbEvent.SelectedIndex != 0)
                {
                    int iEventID = Convert.ToInt32(cmbEvent.SelectedValue);
                    string strSelGroupID = dgvFederation.SelectedRows[0].Cells["ID"].Value.ToString();
                    UpdatePlayerGrid(iEventID, strSelGroupID);
                }
                else
                {
                    dgvPlayer.Rows.Clear();
                }
            }
            else
            {
                if (dgvAvailable.SelectedRows.Count > 0)
                {
                    string strRegisterID = dgvAvailable.SelectedRows[0].Cells["RegisterID"].Value.ToString();
                    UpdatePlayerGrid(Convert.ToInt32(strRegisterID));
                }
                else
                {
                    dgvPlayer.Rows.Clear();
                }
            }
        }

        private void UpdatePlayerGrid(int iEventID, string strGroupID)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            try
            {
                #region DML Command Setup for Get Player List

                SqlCommand cmd = new SqlCommand("Proc_Register_GetEventInscription", m_RegisterModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@EventID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@GroupID", SqlDbType.NVarChar, 9);
                SqlParameter cmdParameter3 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                SqlParameter cmdParameter4 = new SqlParameter("@GroupType", SqlDbType.Int);
                cmdParameter1.Value = iEventID;
                cmdParameter2.Value = strGroupID;
                cmdParameter3.Value = m_strActiveLanguage;
                cmdParameter4.Value = m_iSportGroupType;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridViewWithCmb(dgvPlayer, dr, 8);

                if (dgvPlayer.Columns["RegTypeID"] != null)
                {
                    dgvPlayer.Columns["RegTypeID"].Visible = false;
                }
                if (dgvPlayer.Columns["EventID"] != null)
                {
                    dgvPlayer.Columns["EventID"].Visible = false;
                }
                if (dgvPlayer.Columns["RegisterID"] != null)
                {
                    dgvPlayer.Columns["RegisterID"].Visible = false;
                }

                dgvPlayer.ClearSelection();
                dr.Close();

                if (dgvPlayer.Columns.Count <= 0) return;

                dgvPlayer.Columns["Seed"].ReadOnly = false;
                dgvPlayer.Columns["InscriptionResult"].ReadOnly = false;
                dgvPlayer.Columns["InscriptionNum"].ReadOnly = false;
                dgvPlayer.Columns["InscriptionRank"].ReadOnly = false;
                dgvPlayer.Columns["Reserve"].ReadOnly = false;

                UpdateGridCellToolTip(ref dgvPlayer);
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void UpdatePlayerGrid(int iRegisterID)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }
            try
            {
                #region DML Command Setup for daInscription

                SqlCommand cmd = new SqlCommand("Proc_GetRegisterInscription", m_RegisterModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@RegisterID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@RegisterID",
                             DataRowVersion.Current, iRegisterID);
                cmd.Parameters.Add(cmdParameter1);
                #endregion

                SqlDataReader dr = cmd.ExecuteReader();

                List<OVRCheckBoxColumn> lstChkColumns = new List<OVRCheckBoxColumn>();
                lstChkColumns.Add(new OVRCheckBoxColumn(0, 1, 0));
                
                List<int> lstCmbColumns = new List<int>();
                lstCmbColumns.Add(7);
                OVRDataBaseUtils.FillDataGridView(dgvPlayer, dr, lstCmbColumns, lstChkColumns);
                
                if (dgvPlayer.Columns["RegTypeID"] != null)
                {
                    dgvPlayer.Columns["RegTypeID"].Visible = false;
                }
                if (dgvPlayer.Columns["EventID"] != null)
                {
                    dgvPlayer.Columns["EventID"].Visible = false;
                }
                if (dgvPlayer.Columns["RegisterID"] != null)
                {
                    dgvPlayer.Columns["RegisterID"].Visible = false;
                }

                dgvPlayer.ClearSelection();
                dr.Close();

                for (int i = 0; i < dgvPlayer.Rows.Count; i++)
                {
                    string strActive = dgvPlayer.Rows[i].Cells[0].Value.ToString();
                    if (strActive == "1")
                    {
                        dgvPlayer.Rows[i].Cells["Seed"].ReadOnly = false;
                        dgvPlayer.Rows[i].Cells["InscriptionResult"].ReadOnly = false;
                        dgvPlayer.Rows[i].Cells["InscriptionNum"].ReadOnly = false;
                        dgvPlayer.Rows[i].Cells["InscriptionRank"].ReadOnly = false;
                        dgvPlayer.Rows[i].Cells["Reserve"].ReadOnly = false;

                    }
                    else
                    {
                        dgvPlayer.Rows[i].Cells["Seed"].ReadOnly = true;
                        dgvPlayer.Rows[i].Cells["InscriptionResult"].ReadOnly = true;
                        dgvPlayer.Rows[i].Cells["InscriptionNum"].ReadOnly = true;
                        dgvPlayer.Rows[i].Cells["InscriptionRank"].ReadOnly = true;
                        dgvPlayer.Rows[i].Cells["Reserve"].ReadOnly = true;

                    }
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void UpdateGridCellToolTip(ref UIDataGridView dgv)
        {
            if (dgv.RowCount == 0)
                return;

            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            try
            {
                for (int i = 0; i < dgv.RowCount; i++)
                {
                    int iRegisterID = Convert.ToInt32(dgv.Rows[i].Cells["RegisterID"].Value);

                    SqlCommand cmd = new SqlCommand("Proc_GetRegisterMemberName", m_RegisterModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;

                    SqlParameter cmdParameter1 = new SqlParameter("@RegisterID", SqlDbType.Int);
                    SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);


                    cmdParameter1.Value = iRegisterID;
                    cmdParameter2.Value = m_strActiveLanguage;
                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);

                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.HasRows)
                    {
                        while (dr.Read())
                        {
                            dgv.Rows[i].Cells[0].ToolTipText = OVRDataBaseUtils.GetFieldValue2String(ref dr, 0);
                            dgv.Rows[i].Cells[1].ToolTipText = OVRDataBaseUtils.GetFieldValue2String(ref dr, 0);
                            dgv.Rows[i].Cells[2].ToolTipText = OVRDataBaseUtils.GetFieldValue2String(ref dr, 0);
                            dgv.Rows[i].Cells[3].ToolTipText = OVRDataBaseUtils.GetFieldValue2String(ref dr, 0);
                            dgv.Rows[i].Cells[4].ToolTipText = OVRDataBaseUtils.GetFieldValue2String(ref dr, 0);
                        }
                    }
                    dr.Close();
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        #endregion

        #region DataBase Functions

        private bool UpdateInscriptionSeed(string strRegisterID, string strEventID, string strEditValue)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            try
            {
                #region DML Command Setup for UpdateInscriptionSeed
                string strSQLDes;

                if (strEditValue.Length == 0)
                {
                    strSQLDes = String.Format("UPDATE TR_Inscription SET F_Seed = NULL WHERE F_RegisterID = '{0}' AND F_EventID = '{1}'", strRegisterID, strEventID);
                }
                else
                {
                    int iEditValue = -1;
                    try
                    {
                        iEditValue = Convert.ToInt32(strEditValue);
                    }
                    catch (System.Exception ex)
                    {
                        string strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "Number_Msg");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    }
                    strSQLDes = String.Format("UPDATE TR_Inscription SET F_Seed = {0} WHERE F_RegisterID = '{1}' AND F_EventID = '{2}'", iEditValue, strRegisterID, strEventID);
                }
                SqlCommand cmd = new SqlCommand(strSQLDes, m_RegisterModule.DatabaseConnection);
                cmd.ExecuteNonQuery();
                #endregion
                return true;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }

        private bool UpdateInscriptionReserve(string strRegisterID, string strEventID, int iReserve)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            try
            {
                #region DML Command Setup for UpdateInscriptionSeed
                string strSQLDes;
                if(iReserve == -1)
                {
                    strSQLDes = String.Format("UPDATE TR_Inscription SET F_Reserve = NULL WHERE F_RegisterID = '{1}' AND F_EventID = '{2}'", iReserve, strRegisterID, strEventID);
                }
                else
                {
                    strSQLDes = String.Format("UPDATE TR_Inscription SET F_Reserve = {0} WHERE F_RegisterID = '{1}' AND F_EventID = '{2}'", iReserve, strRegisterID, strEventID);
                }
                SqlCommand cmd = new SqlCommand(strSQLDes, m_RegisterModule.DatabaseConnection);
                cmd.ExecuteNonQuery();
                #endregion
                return true;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }

        private bool UpdateInscriptionResult(string strRegisterID, string strEventID, string strValue)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            if (strValue.Length > 100)   //长度不能大于100
            {
                strValue = strValue.Substring(0, 100);
            }

            try
            {
                string strSQLDes = string.Format("UPDATE TR_Inscription SET F_InscriptionResult = '{0}' WHERE F_RegisterID = '{1}' AND F_EventID = '{2}'", strValue, strRegisterID, strEventID);
                SqlCommand cmd = new SqlCommand(strSQLDes, m_RegisterModule.DatabaseConnection);
                cmd.ExecuteNonQuery();

                return true;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }

        private bool UpdateInscriptionNum(string strRegisterID, string strEventID, string strEditValue)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }
            try
            {
                #region DML Command Setup for UpdateInscriptionNum
                string strSQLDes;

                if (strEditValue.Length == 0)
                {
                    strSQLDes = String.Format("UPDATE TR_Inscription SET F_InscriptionNum = NULL WHERE F_RegisterID = '{0}' AND F_EventID = '{1}'", strRegisterID, strEventID);
                }
                else
                {
                    int iEditValue = -1;
                    try
                    {
                        iEditValue = Convert.ToInt32(strEditValue);
                    }
                    catch (System.Exception ex)
                    {
                        string strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "Number_Msg");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    }

                    strSQLDes = String.Format("UPDATE TR_Inscription SET F_InscriptionNum = {0} WHERE F_RegisterID = '{1}' AND F_EventID = '{2}'", iEditValue, strRegisterID, strEventID);
                }
                SqlCommand cmd = new SqlCommand(strSQLDes, m_RegisterModule.DatabaseConnection);
                cmd.ExecuteNonQuery();
                #endregion
                return true;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }

        private bool UpdateInscriptionRank(string strRegisterID, string strEventID, string strEditValue)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }
            try
            {
                #region DML Command Setup for UpdateInscriptionRank
                string strSQLDes;

                if (strEditValue.Length == 0)
                {
                    strSQLDes = String.Format("UPDATE TR_Inscription SET F_InscriptionRank = NULL WHERE F_RegisterID = '{0}' AND F_EventID = '{1}'", strRegisterID, strEventID);
                }
                else
                {
                    int iEditValue = -1;
                    try
                    {
                        iEditValue = Convert.ToInt32(strEditValue);
                    }
                    catch (System.Exception ex)
                    {
                        string strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "Number_Msg");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    }

                    strSQLDes = String.Format("UPDATE TR_Inscription SET F_InscriptionRank = {0} WHERE F_RegisterID = '{1}' AND F_EventID = '{2}'", iEditValue, strRegisterID, strEventID);
                }
                SqlCommand cmd = new SqlCommand(strSQLDes, m_RegisterModule.DatabaseConnection);
                cmd.ExecuteNonQuery();
                #endregion
                return true;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }

        private bool DelRegisterEvent(string strRegisterID, string strEventID)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            try
            {
                #region DML Command Setup for Del Register Event

                SqlCommand cmd = new SqlCommand("proc_DelInsription", m_RegisterModule.DatabaseConnection);
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
                        strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "DelInscriptionPromotion_Failed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "DelInscriptionPromotion_Uneffect");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "DelInscriptionPromotion_HasMatch");
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

        private bool AddRegisterEvent(string strRegisterID, string strEventID)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            try
            {
                #region DML Command Setup for Del Register Event

                SqlCommand cmd = new SqlCommand("proc_InsertInscription", m_RegisterModule.DatabaseConnection);
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
                        strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "InsertInscriptionPromotion_Failed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "InsertInscriptionPromotion_Uneffect");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "InsertInscriptionPromotion_OverExist");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default://其余的为添加成功！


                        return true;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }

        private bool AllRegisterInscribe(int iEventID)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }

            try
            {
                #region DML Command Setup for Del Register Event

                SqlCommand cmd = new SqlCommand("Proc_InscriptionAllRegister", m_RegisterModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@EventID", SqlDbType.Int, 4,
                             ParameterDirection.Input, false, 0, 0, "@EventID",
                             DataRowVersion.Current, iEventID);

                SqlParameter cmdParameter2 = new SqlParameter(
                         "@LanguageCode", SqlDbType.NVarChar, 3,
                         ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                         DataRowVersion.Current, m_strActiveLanguage);

                SqlParameter cmdParameter3 = new SqlParameter(
                           "@GroupType", SqlDbType.Int, 4,
                           ParameterDirection.Input, false, 0, 0, "@GroupType",
                           DataRowVersion.Current, m_iSportGroupType);
                
                SqlParameter cmdParameterResult = new SqlParameter(
                           "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "InsertInscriptionPromotion_Failed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "InsertInscriptionPromotion_Uneffect");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(strRegisterSectionName, "InsertInscriptionPromotion_OverExist");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default://其余的为添加成功！


                        return true;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
                return false;
            }
        }

        private void GetEventInfo(int iEventID, ref string strEventSex, ref string strEventRegType)
        {
            if (m_RegisterModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_RegisterModule.DatabaseConnection.Open();
            }
            try
            {
                string strSQLDes;
                strSQLDes = String.Format("SELECT F_SexCode, F_PlayerRegTypeID FROM TS_Event WHERE F_EventID = {0}", iEventID);

                SqlCommand cmd = new SqlCommand(strSQLDes, m_RegisterModule.DatabaseConnection);
                cmd.ExecuteNonQuery();

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.HasRows && dr.Read())
                {
                    strEventSex = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_SexCode");
                    strEventRegType = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_PlayerRegTypeID");
                }
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        #endregion

        //HorseInscription
        private void HorseInscription_Click(object sender, EventArgs e)
        {
            int iRowIdx = dgvPlayer.CurrentRow.Index;
            int iEventID = Convert.ToInt32(dgvPlayer.Rows[iRowIdx].Cells["EventID"].Value);
            int iRegisterID = Convert.ToInt32(dgvPlayer.Rows[iRowIdx].Cells["RegisterID"].Value);

            HorseInscriptionForm frmHorseInscription = new HorseInscriptionForm(iEventID, iRegisterID, m_strActiveLanguage);
            frmHorseInscription.DatabaseConnection = m_RegisterModule.DatabaseConnection;
            frmHorseInscription.ShowDialog();

            UpdatePlayerGrid();

            if (null != m_dgUpdatePlayerGrid)
            {
                m_dgUpdatePlayerGrid(true);
            }

            // Cause Data Update In RegisterInfo
            m_bRegTab_RegChanged = true;

            m_RegisterModule.DataChangedNotify(OVRDataChangedType.emRegisterModify, m_iActiveDiscipline, -1, -1, -1, iRegisterID, null);


            if (dgvPlayer.Rows.Count > 0)
            {
                dgvPlayer.ClearSelection();
                dgvPlayer.Rows[iRowIdx].Selected = true;
                dgvPlayer.CurrentCell = dgvPlayer.Rows[iRowIdx].Cells[1];
                dgvPlayer.FirstDisplayedScrollingRowIndex = iRowIdx;

            }
        }

    }
}