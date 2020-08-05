using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

using AutoSports.OVRCommon;

namespace AutoSports.OVRGeneralData
{
    public partial class OVRGeneralDataForm
    {
        private void BasicInfoLocalization()
        {
            string strSectionName = "GeneralDataBasicInfo";

            this.tabItemBasicInfo.Text = LocalizationRecourceManager.GetString(strSectionName, "tabItemBasicInfo");
            this.lbGameSetting.Text = LocalizationRecourceManager.GetString(strSectionName, "lbGameSetting");
            this.lbDiscSetting.Text = LocalizationRecourceManager.GetString(strSectionName, "lbDiscSetting");
            this.lbEventSetting.Text = LocalizationRecourceManager.GetString(strSectionName, "lbEventSetting");
            this.lbLanguage.Text = LocalizationRecourceManager.GetString(strSectionName, "lbLanguage");
            this.lbIRM.Text = LocalizationRecourceManager.GetString(strSectionName, "lbIRM");
            this.lbFunction.Text = LocalizationRecourceManager.GetString(strSectionName, "lbFunction");
            this.lbPosition.Text = LocalizationRecourceManager.GetString(strSectionName, "lbPosition");

            //this.btnGameNew.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnGameNew");
            //this.btnGameModify.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnGameModify");
            //this.btnGameDel.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnGameDel");
            //this.btnDiscNew.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnDiscNew");
            //this.btnDiscModify.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnDiscModify");
            //this.btnDiscDel.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnDiscDel");
            //this.btnEventNew.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnEventNew");
            //this.btnEventModify.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnEventModify");
            //this.btnEventDel.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnEventDel");

            //this.btnLanguageNew.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnLanguageNew");
            //this.btnLanguageModify.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnLanguageModify");
            //this.btnLanguageDel.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnLanguageDel");

            //this.btnIRMNew.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnIRMNew");
            //this.btnIRMModify.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnIRMModify");
            //this.btnIRMDel.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnIRMDel");

            //this.btnFunctionNew.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnFunctionNew");
            //this.btnFunctionModify.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnFunctionModify");
            //this.btnFunctionDel.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnFunctionDel");
            //this.btnPositionNew.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnPositionNew");
            //this.btnPositionModify.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnPositionModify");
            //this.btnPositionDel.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnPositionDel");
            this.btnRecord.Text = LocalizationRecourceManager.GetString(strSectionName, btnRecord.Name);
        }

        private void InitGridViewStyleInBasicInfo()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvSportInfo);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvDisciplineInfo);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvEventInfo);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvLanguage);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvIRM);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvFunction);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvPosition);
        }

        private void BasicInfoTabLoad()
        {
            UpdateSportGrid();
            UpdateDisciplineGrid();
            UpdateEventGrid();
            UpdateLanguageGrid();
            UpdateIRMGrid();
            UpdateFunctionGrid();
            UpdatePositionGrid();
        }

        private void BasicInfoTabLanguageChange()
        {
            UpdateSportGrid();
            UpdateDisciplineGrid();
            UpdateEventGrid();
            UpdateIRMGrid();
            UpdateFunctionGrid();
            UpdatePositionGrid();
        }

        //private void SystemSettingTabDisciplineChanged()
        //{
        //    UpdateFunctionGrid();
        //    UpdatePositionGrid();
        //    UpdateIRMGrid();
        //}


        private void UpdateSportGrid()
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            #region DML Command Setup for daSport

            SqlCommand cmd = new SqlCommand("Proc_GetSports", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.UpdatedRowSource = UpdateRowSource.None;

            SqlParameter cmdParameter1 = new SqlParameter(
                         "@LanguageCode", SqlDbType.Char, 3,
                         ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                         DataRowVersion.Current, GetCurActivedLanguageCode());

            cmd.Parameters.Add(cmdParameter1);
            #endregion

            SqlDataReader dr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Load(dr);
            dr.Close();

            UpdateGridViewWithChk(dgvSportInfo, dt, 0, 1, 0);
        }

        private void UpdateDisciplineGrid()
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            #region DML Command Setup for daDiscipline

            SqlCommand cmd = new SqlCommand("Proc_GetSportDisciplines", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.UpdatedRowSource = UpdateRowSource.None;

            SqlParameter cmdParameter1 = new SqlParameter(
                        "@SportID", SqlDbType.Int, 0,
                         ParameterDirection.Input, false, 0, 0, "@SportID",
                        DataRowVersion.Current, GetCurSelSportID());

            SqlParameter cmdParameter2 = new SqlParameter(
                         "@LanguageCode", SqlDbType.Char, 3,
                         ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                         DataRowVersion.Current, GetCurActivedLanguageCode());

            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);
            #endregion

            SqlDataReader dr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Load(dr);
            dr.Close();

            UpdateGridViewWithChk(dgvDisciplineInfo, dt, 0, "1", "0");
        }

        private void UpdateEventGrid()
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            #region DML Command Setup for daEvent

            SqlCommand cmd = new SqlCommand("Proc_GetDisciplineEvents", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.UpdatedRowSource = UpdateRowSource.None;

            SqlParameter cmdParameter1 = new SqlParameter(
                        "@DisciplineID", SqlDbType.Int, 0,
                         ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                        DataRowVersion.Current, GetCurSelDisciplineID());

            SqlParameter cmdParameter2 = new SqlParameter(
                         "@LanguageCode", SqlDbType.Char, 3,
                         ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                         DataRowVersion.Current, GetCurActivedLanguageCode());

            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);
            #endregion

            SqlDataReader dr = cmd.ExecuteReader();
            DataTable dt = new DataTable();
            dt.Load(dr);
            dr.Close();

            Int32 iCurSel = -1;
            if (dgvEventInfo.SelectedRows.Count != 0)
                iCurSel = dgvEventInfo.SelectedRows[0].Index;

            OVRDataBaseUtils.FillDataGridViewWithCmb(dgvEventInfo, dt, 4);

            while (iCurSel >= dgvEventInfo.Rows.Count)
                iCurSel--;

            if (iCurSel != -1)
            {
                dgvEventInfo.Rows[iCurSel].Selected = true;
                dgvEventInfo.FirstDisplayedScrollingRowIndex = iCurSel;
            }

            //UpdateGridView(dgvEventInfo, dr);
        }

        private void UpdateLanguageGrid()
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            #region DML Command Setup for daLanguage

            SqlCommand cmd = new SqlCommand("Proc_GetLanguages", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.UpdatedRowSource = UpdateRowSource.None;

            #endregion

            SqlDataReader dr = cmd.ExecuteReader();
            UpdateGridViewWithChk(dgvLanguage, dr, 0, 1, 0);
            dr.Close();
        }

        private void UpdateIRMGrid()
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            #region DML Command Setup for daIRM

            SqlCommand cmd = new SqlCommand("Proc_GetIRMs", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.UpdatedRowSource = UpdateRowSource.None;

            SqlParameter cmdParameter1 = new SqlParameter(
                         "@LanguageCode", SqlDbType.Char, 3,
                         ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                         DataRowVersion.Current, GetCurActivedLanguageCode());

            SqlParameter cmdParameter2 = new SqlParameter(
                     "@DisciplineID", SqlDbType.Int, 0,
                     ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                     DataRowVersion.Current, GetCurSelDisciplineID());

            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);
            #endregion

            SqlDataReader dr = cmd.ExecuteReader();
            UpdateGridView(dgvIRM, dr);
            dr.Close();
        }

        private void UpdateFunctionGrid()
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            #region DML Command Setup for daFunction

            SqlCommand cmd = new SqlCommand("Proc_GetFunctions", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.UpdatedRowSource = UpdateRowSource.None;

            SqlParameter cmdParameter1 = new SqlParameter(
                         "@DisciplineID", SqlDbType.Int, 0,
                         ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                         DataRowVersion.Current, GetCurSelDisciplineID());

            SqlParameter cmdParameter2 = new SqlParameter(
                         "@LanguageCode", SqlDbType.Char, 3,
                         ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                         DataRowVersion.Current, GetCurActivedLanguageCode());

            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);
            #endregion

            SqlDataReader dr = cmd.ExecuteReader();
            UpdateGridView(dgvFunction, dr);
            dr.Close();
        }

        private void UpdatePositionGrid()
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            #region DML Command Setup for daPosition

            SqlCommand cmd = new SqlCommand("Proc_GetPositions", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.UpdatedRowSource = UpdateRowSource.None;

            SqlParameter cmdParameter1 = new SqlParameter(
                         "@DisciplineID", SqlDbType.Int, 0,
                         ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                         DataRowVersion.Current, GetCurSelDisciplineID());

            SqlParameter cmdParameter2 = new SqlParameter(
                         "@LanguageCode", SqlDbType.Char, 3,
                         ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                         DataRowVersion.Current, GetCurActivedLanguageCode());

            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);
            #endregion

            SqlDataReader dr = cmd.ExecuteReader();
            UpdateGridView(dgvPosition, dr);
            dr.Close();
        }

        private int GetCurSelSportID()
        {
            return GetCurSelItemID(dgvSportInfo);
        }

        private int GetCurSelDisciplineID()
        {
            return GetCurSelItemID(dgvDisciplineInfo);
        }

        private int GetCurSelEventID()
        {
            return GetCurSelItemID(dgvEventInfo);
        }

        private string GetCurSelLanguageCode()
        {
            Int32 iColIdxID = dgvLanguage.Columns["Code"].Index;
            if (dgvLanguage.SelectedRows.Count == 0)
                return "";

            return dgvLanguage.SelectedRows[0].Cells[iColIdxID].Value.ToString();
        }

        private int GetCurSelIRMID()
        {
            return GetCurSelItemID(dgvIRM);
        }

        private int GetCurSelFunctionID()
        {
            return GetCurSelItemID(dgvFunction);
        }

        private int GetCurSelPositionID()
        {
            return GetCurSelItemID(dgvPosition);
        }

        private int GetCurSelItemID(DataGridView dgv)
        {
            Int32 iColIdxID = dgv.Columns["ID"].Index;
            if (dgv.SelectedRows.Count == 0)
                return -1;

            return Convert.ToInt32(dgv.SelectedRows[0].Cells[iColIdxID].Value);
        }

        private void OnNotifySelChangedSportGrid(object sender, EventArgs e)
        {
            if (m_bUpdatingUI)
                return;

            UpdateDisciplineGrid();
            UpdateEventGrid();

            if (dgvSportInfo.SelectedRows.Count > 0)
            {
                string strValue = GetCurSelItemID(dgvSportInfo).ToString();
                m_genDataModule.SetReportContext("SportID", strValue);
            }
            else
                m_genDataModule.SetReportContext("SportID", "-1");
        }

        private void OnNotifySelChangedDisciplineGrid(object sender, EventArgs e)
        {
            if (m_bUpdatingUI)
                return;
            UpdateEventGrid();

            UpdateFunctionGrid();
            UpdatePositionGrid();
            UpdateIRMGrid();

            if (dgvDisciplineInfo.SelectedRows.Count > 0)
            {
                string strValue = GetCurSelItemID(dgvDisciplineInfo).ToString();
                m_genDataModule.SetReportContext("DisciplineID", strValue);
            }
            else
                m_genDataModule.SetReportContext("DisciplineID", "-1");
        }

        private void OnNotifySelChangedEventGrid(object sender, EventArgs e)
        {
            if (dgvEventInfo.SelectedRows.Count > 0)
            {
                string strValue = GetCurSelItemID(dgvEventInfo).ToString();
                m_genDataModule.SetReportContext("EventID", strValue);
            }
            else
                m_genDataModule.SetReportContext("EventID", "-1");
        }

        private void OnBtnGameNew(object sender, EventArgs e)
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            OVRBasicItemEditForm frmItemEdit = new OVRBasicItemEditForm();
            frmItemEdit.DatabaseConnection = m_genDataModule.DatabaseConnection;

            //fill sDlgParam
            OVRBasicItemEditForm.sDlgParam sDlgParam = new OVRBasicItemEditForm.sDlgParam();

            sDlgParam.bEnableDate = true;
            sDlgParam.bEnableSex = false;
            sDlgParam.bEnableRegType = false;
            sDlgParam.bEnableOrder = true;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = false;
            sDlgParam.bEnableLanguage = true;
            sDlgParam.bEnableComment = true;
            sDlgParam.bVisibleGroup = true;

            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = GetCurActivedLanguageCode();
            sBasicItemInfo.iGroupType = 4;
            frmItemEdit.m_sBasicItem = sBasicItemInfo;

            frmItemEdit.ShowDialog();

            if (frmItemEdit.DialogResult == DialogResult.OK)
            {
                sBasicItemInfo = frmItemEdit.m_sBasicItem;
                try
                {
                    #region DML Command Setup for Proc_AddSport

                    SqlCommand cmd = new SqlCommand("Proc_AddSport", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                "@SportCode", SqlDbType.NVarChar, 10,
                                 ParameterDirection.Input, false, 0, 0, "@SportCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                 "@OpenDate", SqlDbType.DateTime, 0,
                                 ParameterDirection.Input, false, 0, 0, "@OpenDate",
                                 DataRowVersion.Current, sBasicItemInfo.strStartTime);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@CloseDate", SqlDbType.DateTime, 0,
                                 ParameterDirection.Input, false, 0, 0, "@CloseDate",
                                DataRowVersion.Current, sBasicItemInfo.strEndTime);

                    SqlParameter cmdParameter4 = new SqlParameter("@Order", SqlDbType.Int, 0);
                    if (sBasicItemInfo.strOrder == "")
                        cmdParameter4.Value = DBNull.Value;
                    else
                        cmdParameter4.Value = sBasicItemInfo.strOrder;

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@SportInfo", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@SportInfo",
                                DataRowVersion.Current, DBNull.Value);

                    SqlParameter cmdParameter6 = new SqlParameter(
                                "@languageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@languageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter7 = new SqlParameter(
                                "@SportLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@SportLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter8 = new SqlParameter(
                                "@SportShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@SportShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter9 = new SqlParameter(
                                "@SportComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@SportComment",
                                DataRowVersion.Current, sBasicItemInfo.strComment);
                    
                    SqlParameter cmdParameter10 = new SqlParameter(
                               "@SportConfigValue", SqlDbType.NVarChar, 100,
                                ParameterDirection.Input, false, 0, 0, "@SportConfigValue",
                               DataRowVersion.Current, sBasicItemInfo.iGroupType);

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
                                ParameterDirection.Output, false, 0, 0, "@Result",
                                DataRowVersion.Default, null);

                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);
                    cmd.Parameters.Add(cmdParameter3);
                    cmd.Parameters.Add(cmdParameter4);
                    cmd.Parameters.Add(cmdParameter5);
                    cmd.Parameters.Add(cmdParameter6);
                    cmd.Parameters.Add(cmdParameter7);
                    cmd.Parameters.Add(cmdParameter8);
                    cmd.Parameters.Add(cmdParameter9);
                    cmd.Parameters.Add(cmdParameter10);
                    cmd.Parameters.Add(cmdParameterResult);
                    cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                    #endregion

                    cmd.ExecuteNonQuery();
                    int nRetValue = (int)cmd.Parameters["@Result"].Value;

                    string strPromotion;
                    string strSectionName = "GeneralDataBasicInfo";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAddSportFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateSportGrid();
                    UpdateDisciplineGrid();
                    UpdateEventGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnGameModify(object sender, EventArgs e)
        {
            Int32 iSportID = GetCurSelSportID();
            if (iSportID == -1)
                return;

            string strLanCode = GetCurActivedLanguageCode();

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            OVRBasicItemEditForm frmItemEdit = new OVRBasicItemEditForm();
            //fill sDlgParam
            OVRBasicItemEditForm.sDlgParam sDlgParam = new OVRBasicItemEditForm.sDlgParam();
            frmItemEdit.DatabaseConnection = m_genDataModule.DatabaseConnection;
            sDlgParam.bEnableDate = true;
            sDlgParam.bEnableSex = false;
            sDlgParam.bEnableRegType = false;
            sDlgParam.bEnableOrder = true;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = false;
            sDlgParam.bEnableLanguage = false;
            sDlgParam.bEnableComment = true;
            sDlgParam.bVisibleGroup = true;

            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = strLanCode;

            SqlCommand cmd = new SqlCommand("Proc_GetSportByID", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter1 = new SqlParameter("@SportID", SqlDbType.Int);
            SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
            cmdParameter1.Value = iSportID;
            cmdParameter2.Value = strLanCode;
            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);

            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    sBasicItemInfo.strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_SportLongName");
                    sBasicItemInfo.strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_SportShortName");
                    sBasicItemInfo.strComment = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_SportComment");
                    sBasicItemInfo.strRegCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_SportCode");
                    sBasicItemInfo.strStartTime = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_OpenDate");
                    sBasicItemInfo.strEndTime = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_CloseDate");
                    sBasicItemInfo.strOrder = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Order");
                    sBasicItemInfo.strInfo = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_SportInfo");

                    if (dr["F_ConfigValue"] is DBNull)
                    {
                        sBasicItemInfo.iGroupType = 4;
                    }
                    else
                    {
                        sBasicItemInfo.iGroupType = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_ConfigValue");
                    }
                }
            }
            dr.Close();
            frmItemEdit.m_sBasicItem = sBasicItemInfo;

            frmItemEdit.ShowDialog();

            if (frmItemEdit.DialogResult == DialogResult.OK)
            {
                sBasicItemInfo = frmItemEdit.m_sBasicItem;
                try
                {
                    #region DML Command Setup for proc_EditSport

                    cmd = new SqlCommand("proc_EditSport", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    SqlParameter cmdParameter0 = new SqlParameter(
                                "@SportID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@SportID",
                                DataRowVersion.Current, iSportID);

                    cmdParameter1 = new SqlParameter(
                                "@SportCode", SqlDbType.NVarChar, 10,
                                 ParameterDirection.Input, false, 0, 0, "@SportCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    cmdParameter2 = new SqlParameter(
                                 "@OpenDate", SqlDbType.DateTime, 0,
                                 ParameterDirection.Input, false, 0, 0, "@OpenDate",
                                 DataRowVersion.Current, sBasicItemInfo.strStartTime);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@CloseDate", SqlDbType.DateTime, 0,
                                 ParameterDirection.Input, false, 0, 0, "@CloseDate",
                                DataRowVersion.Current, sBasicItemInfo.strEndTime);

                    SqlParameter cmdParameter4 = new SqlParameter("@Order", SqlDbType.Int, 0);
                    if (sBasicItemInfo.strOrder == "")
                        cmdParameter4.Value = DBNull.Value;
                    else
                        cmdParameter4.Value = sBasicItemInfo.strOrder;

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@SportInfo", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@SportInfo",
                                DataRowVersion.Current, DBNull.Value);

                    SqlParameter cmdParameter6 = new SqlParameter(
                                "@languageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@languageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter7 = new SqlParameter(
                                "@SportLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@SportLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter8 = new SqlParameter(
                                "@SportShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@SportShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter9 = new SqlParameter(
                                "@SportComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@SportComment",
                                DataRowVersion.Current, sBasicItemInfo.strComment);

                    SqlParameter cmdParameter10 = new SqlParameter(
                               "@SportConfigValue", SqlDbType.NVarChar, 100,
                                ParameterDirection.Input, false, 0, 0, "@SportConfigValue",
                               DataRowVersion.Current, sBasicItemInfo.iGroupType);

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
                                ParameterDirection.Output, false, 0, 0, "@Result",
                                DataRowVersion.Default, null);

                    cmd.Parameters.Add(cmdParameter0);
                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);
                    cmd.Parameters.Add(cmdParameter3);
                    cmd.Parameters.Add(cmdParameter4);
                    cmd.Parameters.Add(cmdParameter5);
                    cmd.Parameters.Add(cmdParameter6);
                    cmd.Parameters.Add(cmdParameter7);
                    cmd.Parameters.Add(cmdParameter8);
                    cmd.Parameters.Add(cmdParameter9);
                    cmd.Parameters.Add(cmdParameter10);
                    cmd.Parameters.Add(cmdParameterResult);
                    cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                    #endregion
                    cmd.ExecuteNonQuery();
                    int nRetValue = (int)cmd.Parameters["@Result"].Value;

                    string strPromotion;
                    string strSectionName = "GeneralDataBasicInfo";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModifySportFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateSportGrid();
                    UpdateDisciplineGrid();
                    UpdateEventGrid();

                    m_genDataModule.DataChangedNotify(OVRDataChangedType.emSportInfo, -1, -1, -1, -1, iSportID, null);
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnGameDel(object sender, EventArgs e)
        {
            Int32 iSportID = GetCurSelSportID();
            if (iSportID == -1)
                return;

            string strMsgBox;
            string strSectionName = "GeneralDataBasicInfo";
            strMsgBox = LocalizationRecourceManager.GetString(strSectionName, "DelMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }
            try
            {
                #region DML Command Setup for Proc_DelSport

                SqlCommand cmd = new SqlCommand("Proc_DelSport", m_genDataModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@SportID", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@SportID",
                            DataRowVersion.Current, iSportID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;

                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelSportFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelSportFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelSportFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                }
                UpdateSportGrid();
                UpdateDisciplineGrid();
                UpdateEventGrid();
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void OnBtnDiscNew(object sender, EventArgs e)
        {
            Int32 iSportID = GetCurSelSportID();
            if (iSportID == -1)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            OVRBasicItemEditForm frmItemEdit = new OVRBasicItemEditForm();
            frmItemEdit.DatabaseConnection = m_genDataModule.DatabaseConnection;
            //fill sDlgParam
            OVRBasicItemEditForm.sDlgParam sDlgParam = new OVRBasicItemEditForm.sDlgParam();
            sDlgParam.bEnableDate = false;
            sDlgParam.bEnableSex = false;
            sDlgParam.bEnableRegType = false;
            sDlgParam.bEnableOrder = true;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = false;
            sDlgParam.bEnableLanguage = true;
            sDlgParam.bVisibleGroup = false;
            sDlgParam.bEnableComment = true;

            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = GetCurActivedLanguageCode();
            frmItemEdit.m_sBasicItem = sBasicItemInfo;

            frmItemEdit.ShowDialog();

            if (frmItemEdit.DialogResult == DialogResult.OK)
            {
                sBasicItemInfo = frmItemEdit.m_sBasicItem;
                try
                {
                    #region DML Command Setup for proc_AddDiscipline

                    SqlCommand cmd = new SqlCommand("proc_AddDiscipline", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                "@SportID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@SportID",
                                DataRowVersion.Current, iSportID);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                "@DisciplineCode", SqlDbType.NVarChar, 2,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter3 = new SqlParameter("@Order", SqlDbType.Int, 0);
                    if (sBasicItemInfo.strOrder == "")
                        cmdParameter3.Value = DBNull.Value;
                    else
                        cmdParameter3.Value = sBasicItemInfo.strOrder;

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@DisciplineInfo", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineInfo",
                                DataRowVersion.Current, DBNull.Value);

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@languageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@languageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter6 = new SqlParameter(
                                "@DisciplineLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter7 = new SqlParameter(
                                "@DisciplineShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter8 = new SqlParameter(
                                "@DisciplineComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineComment",
                                DataRowVersion.Current, sBasicItemInfo.strComment);

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
                                ParameterDirection.Output, false, 0, 0, "@Result",
                                DataRowVersion.Default, null);

                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);
                    cmd.Parameters.Add(cmdParameter3);
                    cmd.Parameters.Add(cmdParameter4);
                    cmd.Parameters.Add(cmdParameter5);
                    cmd.Parameters.Add(cmdParameter6);
                    cmd.Parameters.Add(cmdParameter7);
                    cmd.Parameters.Add(cmdParameter8);
                    cmd.Parameters.Add(cmdParameterResult);
                    cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                    #endregion

                    cmd.ExecuteNonQuery();
                    int nRetValue = (int)cmd.Parameters["@Result"].Value;

                    string strPromotion;
                    string strSectionName = "GeneralDataBasicInfo";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAddDiscFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -1:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAddDiscFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -2:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAddDiscFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateDisciplineGrid();
                    UpdateEventGrid();

                    UpdateIRMGrid();
                    UpdatePositionGrid();
                    UpdateFunctionGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnDiscModify(object sender, EventArgs e)
        {
            Int32 iSportID = -1;
            Int32 iDiscID = GetCurSelDisciplineID();
            if (iDiscID == -1)
                return;

            string strLanCode = GetCurActivedLanguageCode();

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            OVRBasicItemEditForm frmItemEdit = new OVRBasicItemEditForm();
            frmItemEdit.DatabaseConnection = m_genDataModule.DatabaseConnection;
            //fill sDlgParam
            OVRBasicItemEditForm.sDlgParam sDlgParam = new OVRBasicItemEditForm.sDlgParam();
            sDlgParam.bEnableDate = false;
            sDlgParam.bEnableSex = false;
            sDlgParam.bEnableRegType = false;
            sDlgParam.bEnableOrder = true;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = false;
            sDlgParam.bEnableLanguage = false;
            sDlgParam.bVisibleGroup = false;
            sDlgParam.bEnableComment = true;
            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = strLanCode;

            SqlCommand cmd = new SqlCommand("Proc_GetDisciplineByID", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter1 = new SqlParameter("@DisciplineID", SqlDbType.Int);
            SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
            cmdParameter1.Value = iDiscID;
            cmdParameter2.Value = strLanCode;
            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);

            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    sBasicItemInfo.strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DisciplineLongName");
                    sBasicItemInfo.strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DisciplineShortName");
                    sBasicItemInfo.strComment = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DisciplineComment"); 
                    sBasicItemInfo.strRegCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DisciplineCode");
                    sBasicItemInfo.strOrder = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Order");
                    sBasicItemInfo.strInfo = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_DisciplineInfo");
                    iSportID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_SportID");
                }
            }
            dr.Close();
            frmItemEdit.m_sBasicItem = sBasicItemInfo;

            frmItemEdit.ShowDialog();

            if (frmItemEdit.DialogResult == DialogResult.OK)
            {
                sBasicItemInfo = frmItemEdit.m_sBasicItem;
                try
                {
                    #region DML Command Setup for proc_EditDiscipline

                    cmd = new SqlCommand("proc_EditDiscipline", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    cmdParameter1 = new SqlParameter(
                                "@DisciplineID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                                DataRowVersion.Current, iDiscID);

                    cmdParameter2 = new SqlParameter(
                                "@SportID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@SportID",
                                DataRowVersion.Current, iSportID);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@DisciplineCode", SqlDbType.NVarChar, 2,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter4 = new SqlParameter("@Order", SqlDbType.Int, 0);
                    if (sBasicItemInfo.strOrder == "")
                        cmdParameter4.Value = DBNull.Value;
                    else
                        cmdParameter4.Value = sBasicItemInfo.strOrder;

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@DisciplineInfo", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineInfo",
                                DataRowVersion.Current, DBNull.Value);

                    SqlParameter cmdParameter6 = new SqlParameter(
                                "@languageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@languageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter7 = new SqlParameter(
                                "@DisciplineLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter8 = new SqlParameter(
                                "@DisciplineShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter9 = new SqlParameter(
                                "@DisciplineComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineComment",
                                DataRowVersion.Current, sBasicItemInfo.strComment);

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
                                ParameterDirection.Output, false, 0, 0, "@Result",
                                DataRowVersion.Default, null);

                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);
                    cmd.Parameters.Add(cmdParameter3);
                    cmd.Parameters.Add(cmdParameter4);
                    cmd.Parameters.Add(cmdParameter5);
                    cmd.Parameters.Add(cmdParameter6);
                    cmd.Parameters.Add(cmdParameter7);
                    cmd.Parameters.Add(cmdParameter8);
                    cmd.Parameters.Add(cmdParameter9);
                    cmd.Parameters.Add(cmdParameterResult);
                    cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                    #endregion

                    cmd.ExecuteNonQuery();
                    int nRetValue = (int)cmd.Parameters["@Result"].Value;

                    string strPromotion;
                    string strSectionName = "GeneralDataBasicInfo";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModifyDiscFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -1:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModifyDiscFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -2:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModifyDiscFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateDisciplineGrid();
                    UpdateEventGrid();

                    UpdateIRMGrid();
                    UpdatePositionGrid();
                    UpdateFunctionGrid();


                    m_genDataModule.DataChangedNotify(OVRDataChangedType.emDisciplineInfo, iDiscID, -1, -1, -1, iDiscID, null);
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnDiscDel(object sender, EventArgs e)
        {
            Int32 iDiscID = GetCurSelDisciplineID();
            if (iDiscID == -1)
                return;

            string strMsgBox;
            string strSectionName = "GeneralDataBasicInfo";
            strMsgBox = LocalizationRecourceManager.GetString(strSectionName, "DelMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }
            try
            {
                #region DML Command Setup for proc_DelDiscipline

                SqlCommand cmd = new SqlCommand("proc_DelDiscipline", m_genDataModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@DisciplineID", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                            DataRowVersion.Current, iDiscID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;

                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelDiscFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelDiscFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelDiscFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                }
                UpdateDisciplineGrid();
                UpdateEventGrid();

                UpdateIRMGrid();
                UpdatePositionGrid();
                UpdateFunctionGrid();
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void OnBtnEventNew(object sender, EventArgs e)
        {
            Int32 iDiscID = GetCurSelDisciplineID();
            if (iDiscID == -1)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            OVRBasicItemEditForm frmItemEdit = new OVRBasicItemEditForm();
            frmItemEdit.DatabaseConnection = m_genDataModule.DatabaseConnection;
            //fill sDlgParam
            OVRBasicItemEditForm.sDlgParam sDlgParam = new OVRBasicItemEditForm.sDlgParam();
            sDlgParam.bEnableDate = true;
            sDlgParam.bEnableSex = true;
            sDlgParam.bEnableRegType = true;
            sDlgParam.bEnableOrder = true;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = true;
            sDlgParam.bEnableLanguage = true;
            sDlgParam.bVisibleGroup = false;
            sDlgParam.bEnableComment = true;
            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = GetCurActivedLanguageCode();
            frmItemEdit.m_sBasicItem = sBasicItemInfo;

            frmItemEdit.ShowDialog();

            if (frmItemEdit.DialogResult == DialogResult.OK)
            {
                sBasicItemInfo = frmItemEdit.m_sBasicItem;
                try
                {
                    #region DML Command Setup for proc_AddEvent

                    SqlCommand cmd = new SqlCommand("proc_AddEvent", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                "@DisciplineID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                                DataRowVersion.Current, iDiscID);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                "@EventCode", SqlDbType.NVarChar, 10,
                                 ParameterDirection.Input, false, 0, 0, "@EventCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                 "@OpenDate", SqlDbType.DateTime, 0,
                                 ParameterDirection.Input, false, 0, 0, "@OpenDate",
                                 DataRowVersion.Current, sBasicItemInfo.strStartTime);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@CloseDate", SqlDbType.DateTime, 0,
                                 ParameterDirection.Input, false, 0, 0, "@CloseDate",
                                DataRowVersion.Current, sBasicItemInfo.strEndTime);

                    SqlParameter cmdParameter5 = new SqlParameter("@Order", SqlDbType.Int, 0);
                    if (sBasicItemInfo.strOrder == "")
                        cmdParameter5.Value = DBNull.Value;
                    else
                        cmdParameter5.Value = sBasicItemInfo.strOrder;

                    SqlParameter cmdParameter6 = new SqlParameter(
                                "@SexCode", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@SexCode",
                                DataRowVersion.Current, Convert.ToInt32(sBasicItemInfo.strSexID));

                    SqlParameter cmdParameter7 = new SqlParameter(
                                "@PlayerRegTypeID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@PlayerRegTypeID",
                                DataRowVersion.Current, Convert.ToInt32(sBasicItemInfo.strRegTypeID));

                    SqlParameter cmdParameter8 = new SqlParameter(
                                "@EventInfo", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@EventInfo",
                                DataRowVersion.Current, DBNull.Value);

                    SqlParameter cmdParameter9 = new SqlParameter(
                                "@languageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@languageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter10 = new SqlParameter(
                                "@EventLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@EventLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter11 = new SqlParameter(
                                "@EventShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@EventShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter12 = new SqlParameter(
                                "@EventComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@EventComment",
                                DataRowVersion.Current, sBasicItemInfo.strComment);

                    SqlParameter cmdParameter13 = new SqlParameter(
                                "@CompetitionType", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@CompetitionType",
                                DataRowVersion.Current, Convert.ToInt32(sBasicItemInfo.strCompetitionTypeID));

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
                                ParameterDirection.Output, false, 0, 0, "@Result",
                                DataRowVersion.Default, null);

                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);
                    cmd.Parameters.Add(cmdParameter3);
                    cmd.Parameters.Add(cmdParameter4);
                    cmd.Parameters.Add(cmdParameter5);
                    cmd.Parameters.Add(cmdParameter6);
                    cmd.Parameters.Add(cmdParameter7);
                    cmd.Parameters.Add(cmdParameter8);
                    cmd.Parameters.Add(cmdParameter9);
                    cmd.Parameters.Add(cmdParameter10);
                    cmd.Parameters.Add(cmdParameter11);
                    cmd.Parameters.Add(cmdParameter12);
                    cmd.Parameters.Add(cmdParameter13);
                    cmd.Parameters.Add(cmdParameterResult);
                    cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                    #endregion

                    cmd.ExecuteNonQuery();
                    int nRetValue = (int)cmd.Parameters["@Result"].Value;

                    string strPromotion;
                    string strSectionName = "GeneralDataBasicInfo";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAddEventFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -1:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAddEventFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateEventGrid();

                    int iDisciplineID = GetCurSelDisciplineID();
                    m_genDataModule.DataChangedNotify(OVRDataChangedType.emEventAdd, iDisciplineID, nRetValue, -1, -1, nRetValue, null);
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnEventModify(object sender, EventArgs e)
        {
            Int32 iDiscID = -1;
            Int32 iEventID = GetCurSelEventID();
            if (iEventID == -1)
                return;

            string strLanCode = GetCurActivedLanguageCode();

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            OVRBasicItemEditForm frmItemEdit = new OVRBasicItemEditForm();
            frmItemEdit.DatabaseConnection = m_genDataModule.DatabaseConnection;
            //fill sDlgParam
            OVRBasicItemEditForm.sDlgParam sDlgParam = new OVRBasicItemEditForm.sDlgParam();
            sDlgParam.bEnableDate = true;
            sDlgParam.bEnableSex = true;
            sDlgParam.bEnableRegType = true;
            sDlgParam.bEnableOrder = true;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = true;
            sDlgParam.bEnableLanguage = false;
            sDlgParam.bVisibleGroup = false;
            sDlgParam.bEnableComment = true;
            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = strLanCode;

            SqlCommand cmd = new SqlCommand("Proc_GetEventByID", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter1 = new SqlParameter("@EventID", SqlDbType.Int);
            SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
            cmdParameter1.Value = iEventID;
            cmdParameter2.Value = strLanCode;
            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);

            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    sBasicItemInfo.strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_EventLongName");
                    sBasicItemInfo.strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_EventShortName");
                    sBasicItemInfo.strComment = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_EventComment");
                    sBasicItemInfo.strRegCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_EventCode");
                    sBasicItemInfo.strStartTime = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_OpenDate");
                    sBasicItemInfo.strEndTime = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_CloseDate");
                    sBasicItemInfo.strSexID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_SexCode");
                    sBasicItemInfo.strRegTypeID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_RegTypeID");
                    sBasicItemInfo.strCompetitionTypeID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_CompetitionTypeID");
                    sBasicItemInfo.strOrder = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Order");
                    sBasicItemInfo.strInfo = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_EventInfo");
                    iDiscID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_DisciplineID");
                }
            }
            dr.Close();
            frmItemEdit.m_sBasicItem = sBasicItemInfo;

            frmItemEdit.ShowDialog();

            if (frmItemEdit.DialogResult == DialogResult.OK)
            {
                sBasicItemInfo = frmItemEdit.m_sBasicItem;
                try
                {
                    #region DML Command Setup for proc_EditEvent

                    cmd = new SqlCommand("proc_EditEvent", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    cmdParameter1 = new SqlParameter(
                                "@EventID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@EventID",
                                DataRowVersion.Current, iEventID);

                    cmdParameter2 = new SqlParameter(
                                "@DisciplineID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                                DataRowVersion.Current, iDiscID);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@EventCode", SqlDbType.NVarChar, 10,
                                 ParameterDirection.Input, false, 0, 0, "@EventCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                 "@OpenDate", SqlDbType.DateTime, 0,
                                 ParameterDirection.Input, false, 0, 0, "@OpenDate",
                                 DataRowVersion.Current, sBasicItemInfo.strStartTime);

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@CloseDate", SqlDbType.DateTime, 0,
                                 ParameterDirection.Input, false, 0, 0, "@CloseDate",
                                DataRowVersion.Current, sBasicItemInfo.strEndTime);

                    SqlParameter cmdParameter6 = new SqlParameter("@Order", SqlDbType.Int, 0);
                    if (sBasicItemInfo.strOrder == "")
                        cmdParameter6.Value = DBNull.Value;
                    else
                        cmdParameter6.Value = sBasicItemInfo.strOrder;

                    SqlParameter cmdParameter7 = new SqlParameter(
                                "@SexCode", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@SexCode",
                                DataRowVersion.Current, Convert.ToInt32(sBasicItemInfo.strSexID));

                    SqlParameter cmdParameter8 = new SqlParameter(
                                "@PlayerRegTypeID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@PlayerRegTypeID",
                                DataRowVersion.Current, Convert.ToInt32(sBasicItemInfo.strRegTypeID));

                    SqlParameter cmdParameter9 = new SqlParameter(
                                "@EventInfo", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@EventInfo",
                                DataRowVersion.Current, DBNull.Value);

                    SqlParameter cmdParameter10 = new SqlParameter(
                                "@languageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@languageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter11 = new SqlParameter(
                                "@EventLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@EventLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter12 = new SqlParameter(
                                "@EventShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@EventShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter13 = new SqlParameter(
                                "@EventComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@EventComment",
                                DataRowVersion.Current, sBasicItemInfo.strComment);

                    SqlParameter cmdParameter14 = new SqlParameter(
                                "@CompetitionType", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@CompetitionType",
                                DataRowVersion.Current, Convert.ToInt32(sBasicItemInfo.strCompetitionTypeID));

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
                                ParameterDirection.Output, false, 0, 0, "@Result",
                                DataRowVersion.Default, null);

                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);
                    cmd.Parameters.Add(cmdParameter3);
                    cmd.Parameters.Add(cmdParameter4);
                    cmd.Parameters.Add(cmdParameter5);
                    cmd.Parameters.Add(cmdParameter6);
                    cmd.Parameters.Add(cmdParameter7);
                    cmd.Parameters.Add(cmdParameter8);
                    cmd.Parameters.Add(cmdParameter9);
                    cmd.Parameters.Add(cmdParameter10);
                    cmd.Parameters.Add(cmdParameter11);
                    cmd.Parameters.Add(cmdParameter12);
                    cmd.Parameters.Add(cmdParameter13);
                    cmd.Parameters.Add(cmdParameter14);
                    cmd.Parameters.Add(cmdParameterResult);
                    cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                    #endregion

                    cmd.ExecuteNonQuery();
                    int nRetValue = (int)cmd.Parameters["@Result"].Value;

                    string strPromotion;
                    string strSectionName = "GeneralDataBasicInfo";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModifyEventFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -1:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModifyEventFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateEventGrid();

                    int iDisciplineID = GetCurSelDisciplineID();
                    m_genDataModule.DataChangedNotify(OVRDataChangedType.emEventInfo, iDisciplineID, iEventID, -1, -1, iEventID, null);
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }

        }

        private void OnBtnEventDel(object sender, EventArgs e)
        {
            Int32 iEventID = GetCurSelEventID();
            if (iEventID == -1)
                return;

            string strMsgBox;
            string strSectionName = "GeneralDataBasicInfo";
            strMsgBox = LocalizationRecourceManager.GetString(strSectionName, "DelMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }
            try
            {
                #region DML Command Setup for proc_DelEvent

                SqlCommand cmd = new SqlCommand("proc_DelEvent", m_genDataModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@EventID", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@EventID",
                            DataRowVersion.Current, iEventID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;

                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelEventFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelEventFailed1");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelEventFailed2");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -3:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelEventFailed3");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -4:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelEventFailed4");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -5:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelEventFailed5");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                }
                UpdateEventGrid();

                int iDisciplineID = GetCurSelDisciplineID();
                m_genDataModule.DataChangedNotify(OVRDataChangedType.emEventDel, iDisciplineID, iEventID, -1, -1, iEventID, null);
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void btnRecord_Click(object sender, EventArgs e)
        {
            Int32 iEventID = GetCurSelEventID();
            if (iEventID == -1)
                return;

            OVREventRecordsForm EventRecordsForm = new OVREventRecordsForm(iEventID, m_genDataModule.DatabaseConnection);
            EventRecordsForm.ShowDialog();
        }

        private void dgvEventInfo_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            int iColumnIndex = e.ColumnIndex;
            if(e.RowIndex < 0 )
            {
                return;
            }
            if (dgvEventInfo.Columns[iColumnIndex].Name.CompareTo("Status") == 0)
            {
                FillEStatusComboBox();
            }
            else
            {
                return;
            }
        }

        private void dgvEventInfo_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex < 0 || e.RowIndex < 0)
                return;

            int iColumnIndex = e.ColumnIndex;
            int iRowIndex = e.RowIndex;
            String strColumnName = dgvEventInfo.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvEventInfo.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                int iInputKey = 0;
                if (CurCell is DGVCustomComboBoxCell)
                {
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                    iInputKey = Convert.ToInt32(CurCell1.Tag);
                }

                int iEventID = Convert.ToInt32(dgvEventInfo.Rows[iRowIndex].Cells["ID"].Value);
                UpdateEventStatus(iEventID, iInputKey);

                m_genDataModule.DataChangedNotify(OVRDataChangedType.emEventStatus, -1, iEventID, -1, -1, iEventID, null);
            }
        }

        private void UpdateEventStatus(int nEventID, int nStatusID)
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            try
            {
                string strSQL;
                strSQL = String.Format("UPDATE TS_Event SET F_EventStatusID = {0} WHERE F_EventID = {1} ", nStatusID, nEventID);
                SqlCommand cmd = new SqlCommand(strSQL, m_genDataModule.DatabaseConnection);
                cmd.ExecuteNonQuery();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void FillEStatusComboBox()
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            try
            {
                #region DML Command Setup for Fill Status combo

                SqlCommand cmd = new SqlCommand("Proc_GetEventStatusList", m_genDataModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter1.Value = GetCurActivedLanguageCode();

                cmd.Parameters.Add(cmdParameter1);
                SqlDataReader dr = cmd.ExecuteReader();
                #endregion

                DataTable table = new DataTable();
                table.Columns.Add("F_StatusLongName", typeof(string));
                table.Columns.Add("F_StatusID", typeof(int));
                table.Load(dr);

                (dgvEventInfo.Columns["Status"] as DGVCustomComboBoxColumn).FillComboBoxItems(table, "F_StatusLongName", "F_StatusID");
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void OnBtnLanguageNew(object sender, EventArgs e)
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            OVRBasicItemEditForm frmItemEdit = new OVRBasicItemEditForm();
            frmItemEdit.DatabaseConnection = m_genDataModule.DatabaseConnection;

            //fill sDlgParam
            OVRBasicItemEditForm.sDlgParam sDlgParam = new OVRBasicItemEditForm.sDlgParam();

            sDlgParam.bEnableDate = false;
            sDlgParam.bEnableSex = false;
            sDlgParam.bEnableRegType = false;
            sDlgParam.bEnableOrder = true;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = false;
            sDlgParam.bEnableLanguage = false;
            sDlgParam.bVisibleGroup = false;
            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            frmItemEdit.m_sBasicItem = sBasicItemInfo;

            frmItemEdit.ShowDialog();

            if (frmItemEdit.DialogResult == DialogResult.OK)
            {
                sBasicItemInfo = frmItemEdit.m_sBasicItem;
                try
                {
                    #region DML Command Setup for Proc_AddLanguage

                    SqlCommand cmd = new SqlCommand("Proc_AddLanguage", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                "@LanguageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                "@LanguageDescription", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@LanguageDescription",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter3 = new SqlParameter("@Order", SqlDbType.Int, 0);
                    if (sBasicItemInfo.strOrder == "")
                        cmdParameter3.Value = DBNull.Value;
                    else
                        cmdParameter3.Value = sBasicItemInfo.strOrder;

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
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
                    string strSectionName = "GeneralDataBasicInfo";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAdd") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbLanguage") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateLanguageGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnLanguageModify(object sender, EventArgs e)
        {
            string strLanguageID = GetCurSelLanguageCode();
            if (strLanguageID == "")
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            OVRBasicItemEditForm frmItemEdit = new OVRBasicItemEditForm();
            //fill sDlgParam
            OVRBasicItemEditForm.sDlgParam sDlgParam = new OVRBasicItemEditForm.sDlgParam();
            frmItemEdit.DatabaseConnection = m_genDataModule.DatabaseConnection;
            sDlgParam.bEnableDate = false;
            sDlgParam.bEnableSex = false;
            sDlgParam.bEnableRegType = false;
            sDlgParam.bEnableOrder = true;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = false;
            sDlgParam.bEnableLanguage = false;
            sDlgParam.bVisibleGroup = false;
            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();

            SqlCommand cmd = new SqlCommand("Proc_GetLanguageByCode", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
            cmdParameter1.Value = strLanguageID;
            cmd.Parameters.Add(cmdParameter1);

            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    sBasicItemInfo.strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_LanguageDescription");
                    sBasicItemInfo.strRegCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_LanguageCode");
                    sBasicItemInfo.strOrder = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Order");
                }
            }
            dr.Close();
            frmItemEdit.m_sBasicItem = sBasicItemInfo;

            frmItemEdit.ShowDialog();

            if (frmItemEdit.DialogResult == DialogResult.OK)
            {
                sBasicItemInfo = frmItemEdit.m_sBasicItem;
                try
                {
                    #region DML Command Setup for Proc_EditLanguage

                    cmd = new SqlCommand("Proc_EditLanguage", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    cmdParameter1 = new SqlParameter(
                                "@OldLanguageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@OldLanguageCode",
                                DataRowVersion.Current, strLanguageID);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                "@NewLanguageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@NewLanguageCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@LanguageDescription", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@LanguageDescription",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter4 = new SqlParameter("@Order", SqlDbType.Int, 0);
                    if (sBasicItemInfo.strOrder == "")
                        cmdParameter4.Value = DBNull.Value;
                    else
                        cmdParameter4.Value = sBasicItemInfo.strOrder;

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
                                ParameterDirection.Output, false, 0, 0, "@Result",
                                DataRowVersion.Default, null);

                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);
                    cmd.Parameters.Add(cmdParameter3);
                    cmd.Parameters.Add(cmdParameter4);
                    cmd.Parameters.Add(cmdParameterResult);
                    cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                    #endregion
                    cmd.ExecuteNonQuery();
                    int nRetValue = (int)cmd.Parameters["@Result"].Value;

                    string strPromotion;
                    string strSectionName = "GeneralDataBasicInfo";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModify") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbLanguage") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateLanguageGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnLanguageDel(object sender, EventArgs e)
        {
            string strLanguageID = GetCurSelLanguageCode();
            if (strLanguageID == "")
                return;

            string strMsgBox;
            string strSectionName = "GeneralDataBasicInfo";
            strMsgBox = LocalizationRecourceManager.GetString(strSectionName, "DelMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }
            try
            {
                #region DML Command Setup for Proc_DelLanguage

                SqlCommand cmd = new SqlCommand("Proc_DelLanguage", m_genDataModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                             ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, strLanguageID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;

                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDel") +
                                        LocalizationRecourceManager.GetString(strSectionName, "lbLanguage") +
                                         LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDel") +
                                        LocalizationRecourceManager.GetString(strSectionName, "lbLanguage") +
                                         LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDel") +
                                        LocalizationRecourceManager.GetString(strSectionName, "lbLanguage") +
                                         LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                }
                UpdateLanguageGrid();
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void OnBtnIRMNew(object sender, EventArgs e)
        {
            Int32 iDiscID = GetCurSelDisciplineID();
            if (iDiscID == -1)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            OVRBasicItemEditForm frmItemEdit = new OVRBasicItemEditForm();
            frmItemEdit.DatabaseConnection = m_genDataModule.DatabaseConnection;
            //fill sDlgParam
            OVRBasicItemEditForm.sDlgParam sDlgParam = new OVRBasicItemEditForm.sDlgParam();
            sDlgParam.bEnableDate = false;
            sDlgParam.bEnableSex = false;
            sDlgParam.bEnableRegType = false;
            sDlgParam.bEnableOrder = true;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = false;
            sDlgParam.bEnableLanguage = true;
            sDlgParam.bVisibleGroup = false;
            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = GetCurActivedLanguageCode();
            frmItemEdit.m_sBasicItem = sBasicItemInfo;

            frmItemEdit.ShowDialog();

            if (frmItemEdit.DialogResult == DialogResult.OK)
            {
                sBasicItemInfo = frmItemEdit.m_sBasicItem;
                try
                {
                    #region DML Command Setup for Proc_AddIRM

                    SqlCommand cmd = new SqlCommand("Proc_AddIRM", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                "@LanguageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter2 = new SqlParameter("@Order", SqlDbType.Int, 0);
                    if (sBasicItemInfo.strOrder == "")
                        cmdParameter2.Value = DBNull.Value;
                    else
                        cmdParameter2.Value = sBasicItemInfo.strOrder;

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@IRMCode", SqlDbType.NVarChar, 20,
                                 ParameterDirection.Input, false, 0, 0, "@IRMCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@IRMLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@IRMLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@IRMShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@IRMShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter6 = new SqlParameter(
                                "@IRMComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@IRMComment",
                                DataRowVersion.Current, DBNull.Value);


                    SqlParameter cmdParameter7 = new SqlParameter(
                                "@DisciplineID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                                DataRowVersion.Current, iDiscID);

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
                                ParameterDirection.Output, false, 0, 0, "@Result",
                                DataRowVersion.Default, null);

                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);
                    cmd.Parameters.Add(cmdParameter3);
                    cmd.Parameters.Add(cmdParameter4);
                    cmd.Parameters.Add(cmdParameter5);
                    cmd.Parameters.Add(cmdParameter6);
                    cmd.Parameters.Add(cmdParameter7);
                    cmd.Parameters.Add(cmdParameterResult);
                    cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                    #endregion

                    cmd.ExecuteNonQuery();
                    int nRetValue = (int)cmd.Parameters["@Result"].Value;

                    string strPromotion;
                    string strSectionName = "GeneralDataBasicInfo";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAdd") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbIRM") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateIRMGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnIRMModify(object sender, EventArgs e)
        {
            Int32 iIRMID = GetCurSelIRMID();
            if (iIRMID == -1)
                return;

            Int32 iDiscID = -1;
            string strLanCode = GetCurActivedLanguageCode();

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            OVRBasicItemEditForm frmItemEdit = new OVRBasicItemEditForm();
            frmItemEdit.DatabaseConnection = m_genDataModule.DatabaseConnection;
            //fill sDlgParam
            OVRBasicItemEditForm.sDlgParam sDlgParam = new OVRBasicItemEditForm.sDlgParam();
            sDlgParam.bEnableDate = false;
            sDlgParam.bEnableSex = false;
            sDlgParam.bEnableRegType = false;
            sDlgParam.bEnableOrder = true;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = false;
            sDlgParam.bEnableLanguage = false;
            sDlgParam.bVisibleGroup = false;
            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = strLanCode;

            SqlCommand cmd = new SqlCommand("Proc_GetIRMByID", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
            SqlParameter cmdParameter2 = new SqlParameter("@IRMID", SqlDbType.Int);

            cmdParameter1.Value = strLanCode;
            cmdParameter2.Value = iIRMID;
            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);

            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    sBasicItemInfo.strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_IRMLongName");
                    sBasicItemInfo.strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_IRMShortName");
                    sBasicItemInfo.strRegCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_IRMCode");
                    sBasicItemInfo.strOrder = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Order");
                    sBasicItemInfo.strComment = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_IRMComment");
                    iDiscID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_DisciplineID");
                }
            }
            dr.Close();
            frmItemEdit.m_sBasicItem = sBasicItemInfo;

            frmItemEdit.ShowDialog();

            if (frmItemEdit.DialogResult == DialogResult.OK)
            {
                sBasicItemInfo = frmItemEdit.m_sBasicItem;
                try
                {
                    #region DML Command Setup for Proc_EditIRM

                    cmd = new SqlCommand("Proc_EditIRM", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    cmdParameter1 = new SqlParameter(
                                "@IRMID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@IRMID",
                                DataRowVersion.Current, iIRMID);

                    cmdParameter2 = new SqlParameter(
                                "@LanguageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter3 = new SqlParameter("@Order", SqlDbType.Int, 0);
                    if (sBasicItemInfo.strOrder == "")
                        cmdParameter3.Value = DBNull.Value;
                    else
                        cmdParameter3.Value = sBasicItemInfo.strOrder;

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@IRMCode", SqlDbType.NVarChar, 20,
                                 ParameterDirection.Input, false, 0, 0, "@IRMCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@IRMLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@IRMLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter6 = new SqlParameter(
                                "@IRMShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@IRMShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter7 = new SqlParameter(
                                "@IRMComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@IRMComment",
                                DataRowVersion.Current, DBNull.Value);

                    SqlParameter cmdParameter8 = new SqlParameter(
                         "@DisciplineID", SqlDbType.Int, 0,
                          ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                         DataRowVersion.Current, iDiscID);

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
                                ParameterDirection.Output, false, 0, 0, "@Result",
                                DataRowVersion.Default, null);

                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);
                    cmd.Parameters.Add(cmdParameter3);
                    cmd.Parameters.Add(cmdParameter4);
                    cmd.Parameters.Add(cmdParameter5);
                    cmd.Parameters.Add(cmdParameter6);
                    cmd.Parameters.Add(cmdParameter7);
                    cmd.Parameters.Add(cmdParameter8);
                    cmd.Parameters.Add(cmdParameterResult);
                    cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                    #endregion

                    cmd.ExecuteNonQuery();
                    int nRetValue = (int)cmd.Parameters["@Result"].Value;

                    string strPromotion;
                    string strSectionName = "GeneralDataBasicInfo";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModify") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbIRM") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -1:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModify") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbIRM") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateIRMGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnIRMDel(object sender, EventArgs e)
        {
            Int32 iIRMID = GetCurSelIRMID();
            if (iIRMID == -1)
                return;

            string strMsgBox;
            string strSectionName = "GeneralDataBasicInfo";
            strMsgBox = LocalizationRecourceManager.GetString(strSectionName, "DelMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }
            try
            {
                #region DML Command Setup for Proc_DelIRM

                SqlCommand cmd = new SqlCommand("Proc_DelIRM", m_genDataModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@IRMID", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@IRMID",
                            DataRowVersion.Current, iIRMID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;

                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDel") +
                                        LocalizationRecourceManager.GetString(strSectionName, "lbIRM") +
                                         LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDel") +
                                        LocalizationRecourceManager.GetString(strSectionName, "lbIRM") +
                                         LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDel") +
                                        LocalizationRecourceManager.GetString(strSectionName, "lbIRM") +
                                         LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                }
                UpdateIRMGrid();
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }


        private void OnBtnFunctionNew(object sender, EventArgs e)
        {
            Int32 iDiscID = GetCurSelDisciplineID();
            if (iDiscID == -1)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            OVRBasicItemEditForm frmItemEdit = new OVRBasicItemEditForm();
            frmItemEdit.DatabaseConnection = m_genDataModule.DatabaseConnection;
            //fill sDlgParam
            OVRBasicItemEditForm.sDlgParam sDlgParam = new OVRBasicItemEditForm.sDlgParam();
            sDlgParam.bEnableDate = false;
            sDlgParam.bEnableSex = false;
            sDlgParam.bEnableRegType = true;
            sDlgParam.bEnableOrder = false;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = false;
            sDlgParam.bEnableLanguage = true;
            sDlgParam.bVisibleGroup = false;
            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = GetCurActivedLanguageCode();
            frmItemEdit.m_sBasicItem = sBasicItemInfo;

            //fill ItemType
            frmItemEdit.ItemType = EItemype.emFunction;
            frmItemEdit.ShowDialog();

            if (frmItemEdit.DialogResult == DialogResult.OK)
            {
                sBasicItemInfo = frmItemEdit.m_sBasicItem;
                try
                {
                    #region DML Command Setup for Proc_AddFunction

                    SqlCommand cmd = new SqlCommand("Proc_AddFunction", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                "@LanguageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                "@DisciplineID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                                DataRowVersion.Current, iDiscID);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@FunctionLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@FunctionLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@FunctionShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@FunctionShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@FunctionComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@FunctionComment",
                                DataRowVersion.Current, DBNull.Value);

                    SqlParameter cmdParameter6 = new SqlParameter(
                               "@FunctionCode", SqlDbType.NVarChar, 10,
                                ParameterDirection.Input, false, 0, 0, "@FunctionCode",
                               DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter7 = new SqlParameter(
                               "@FunctionCategoryCode", SqlDbType.NVarChar, 50,
                                ParameterDirection.Input, false, 0, 0, "@FunctionCategoryCode",
                               DataRowVersion.Current, sBasicItemInfo.strRegTypeID);

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
                                ParameterDirection.Output, false, 0, 0, "@Result",
                                DataRowVersion.Default, null);

                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);
                    cmd.Parameters.Add(cmdParameter3);
                    cmd.Parameters.Add(cmdParameter4);
                    cmd.Parameters.Add(cmdParameter5);
                    cmd.Parameters.Add(cmdParameter6);
                    cmd.Parameters.Add(cmdParameter7);
                    cmd.Parameters.Add(cmdParameterResult);
                    cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                    #endregion

                    cmd.ExecuteNonQuery();
                    int nRetValue = (int)cmd.Parameters["@Result"].Value;

                    string strPromotion;
                    string strSectionName = "GeneralDataBasicInfo";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAdd") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbFunction") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -1:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionFunction_Code");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateFunctionGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnFunctionModify(object sender, EventArgs e)
        {
            Int32 iFunctionID = GetCurSelFunctionID();
            if (iFunctionID == -1)
                return;

            Int32 iDiscID = -1;

            string strLanCode = GetCurActivedLanguageCode();

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            OVRBasicItemEditForm frmItemEdit = new OVRBasicItemEditForm();
            frmItemEdit.DatabaseConnection = m_genDataModule.DatabaseConnection;
            //fill sDlgParam
            OVRBasicItemEditForm.sDlgParam sDlgParam = new OVRBasicItemEditForm.sDlgParam();
            sDlgParam.bEnableDate = false;
            sDlgParam.bEnableSex = false;
            sDlgParam.bEnableRegType = true;
            sDlgParam.bEnableOrder = false;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = false;
            sDlgParam.bEnableLanguage = false;
            sDlgParam.bVisibleGroup = false;
            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = strLanCode;

            frmItemEdit.ItemType = EItemype.emFunction;

            SqlCommand cmd = new SqlCommand("Proc_GetFunctionByID", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
            SqlParameter cmdParameter2 = new SqlParameter("@FunctionID", SqlDbType.Int);

            cmdParameter1.Value = strLanCode;
            cmdParameter2.Value = iFunctionID;
            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);

            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    sBasicItemInfo.strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_FunctionLongName");
                    sBasicItemInfo.strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_FunctionShortName");
                    sBasicItemInfo.strComment = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_FunctionComment");
                    sBasicItemInfo.strRegCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_FunctionCode");
                    sBasicItemInfo.strRegTypeID = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_FunctionCategoryCode");
                    iDiscID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_DisciplineID");
                }
            }
            dr.Close();
            frmItemEdit.m_sBasicItem = sBasicItemInfo;

            frmItemEdit.ShowDialog();

            if (frmItemEdit.DialogResult == DialogResult.OK)
            {
                sBasicItemInfo = frmItemEdit.m_sBasicItem;
                try
                {
                    #region DML Command Setup for Proc_EditFunction

                    cmd = new SqlCommand("Proc_EditFunction", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    cmdParameter1 = new SqlParameter(
                                "@FunctionID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@FunctionID",
                                DataRowVersion.Current, iFunctionID);

                    cmdParameter2 = new SqlParameter(
                                "@LanguageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@DisciplineID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                                DataRowVersion.Current, iDiscID);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@FunctionLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@FunctionLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@FunctionShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@FunctionShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter6 = new SqlParameter(
                                "@FunctionComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@FunctionComment",
                                DataRowVersion.Current, DBNull.Value);

                    SqlParameter cmdParameter7 = new SqlParameter(
                              "@FunctionCode", SqlDbType.NVarChar, 10,
                               ParameterDirection.Input, false, 0, 0, "@FunctionCode",
                              DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter8 = new SqlParameter(
                               "@FunctionCategoryCode", SqlDbType.NVarChar, 50,
                                ParameterDirection.Input, false, 0, 0, "@FunctionCategoryCode",
                               DataRowVersion.Current, sBasicItemInfo.strRegTypeID);

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
                                ParameterDirection.Output, false, 0, 0, "@Result",
                                DataRowVersion.Default, null);

                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);
                    cmd.Parameters.Add(cmdParameter3);
                    cmd.Parameters.Add(cmdParameter4);
                    cmd.Parameters.Add(cmdParameter5);
                    cmd.Parameters.Add(cmdParameter6);
                    cmd.Parameters.Add(cmdParameter7);
                    cmd.Parameters.Add(cmdParameter8);
                    cmd.Parameters.Add(cmdParameterResult);
                    cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                    #endregion

                    cmd.ExecuteNonQuery();
                    int nRetValue = (int)cmd.Parameters["@Result"].Value;

                    string strPromotion;
                    string strSectionName = "GeneralDataBasicInfo";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModify") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbFunction") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -1:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModify") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbFunction") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -2:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionFunction_Code");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateFunctionGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnFunctionDel(object sender, EventArgs e)
        {
            Int32 iFunctionID = GetCurSelFunctionID();
            if (iFunctionID == -1)
                return;

            string strMsgBox;
            string strSectionName = "GeneralDataBasicInfo";
            strMsgBox = LocalizationRecourceManager.GetString(strSectionName, "DelMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }
            try
            {
                #region DML Command Setup for Proc_DelFunction

                SqlCommand cmd = new SqlCommand("Proc_DelFunction", m_genDataModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@FunctionID", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@FunctionID",
                            DataRowVersion.Current, iFunctionID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;

                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDel") +
                                        LocalizationRecourceManager.GetString(strSectionName, "lbFunction") +
                                         LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDel") +
                                        LocalizationRecourceManager.GetString(strSectionName, "lbFunction") +
                                         LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDel") +
                                        LocalizationRecourceManager.GetString(strSectionName, "lbFunction") +
                                         LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                }
                UpdateFunctionGrid();
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void OnBtnPositionNew(object sender, EventArgs e)
        {
            Int32 iDiscID = GetCurSelDisciplineID();
            if (iDiscID == -1)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            OVRBasicItemEditForm frmItemEdit = new OVRBasicItemEditForm();
            frmItemEdit.DatabaseConnection = m_genDataModule.DatabaseConnection;
            //fill sDlgParam
            OVRBasicItemEditForm.sDlgParam sDlgParam = new OVRBasicItemEditForm.sDlgParam();
            sDlgParam.bEnableDate = false;
            sDlgParam.bEnableSex = false;
            sDlgParam.bEnableRegType = false;
            sDlgParam.bEnableOrder = false;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = false;
            sDlgParam.bEnableLanguage = true;
            sDlgParam.bVisibleGroup = false;
            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = GetCurActivedLanguageCode();
            frmItemEdit.m_sBasicItem = sBasicItemInfo;

            frmItemEdit.ShowDialog();

            if (frmItemEdit.DialogResult == DialogResult.OK)
            {
                sBasicItemInfo = frmItemEdit.m_sBasicItem;
                try
                {
                    #region DML Command Setup for Proc_AddPosition

                    SqlCommand cmd = new SqlCommand("Proc_AddPosition", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                "@LanguageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                "@DisciplineID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                                DataRowVersion.Current, iDiscID);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@PositionLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@PositionLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@PositionShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@PositionShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@PositionComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@PositionComment",
                                DataRowVersion.Current, DBNull.Value);

                    SqlParameter cmdParameter6 = new SqlParameter(
                           "@PositionCode", SqlDbType.NVarChar, 10,
                            ParameterDirection.Input, false, 0, 0, "@PositionCode",
                           DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
                                ParameterDirection.Output, false, 0, 0, "@Result",
                                DataRowVersion.Default, null);

                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);
                    cmd.Parameters.Add(cmdParameter3);
                    cmd.Parameters.Add(cmdParameter4);
                    cmd.Parameters.Add(cmdParameter5);
                    cmd.Parameters.Add(cmdParameter6);
                    cmd.Parameters.Add(cmdParameterResult);
                    cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                    #endregion

                    cmd.ExecuteNonQuery();
                    int nRetValue = (int)cmd.Parameters["@Result"].Value;

                    string strPromotion;
                    string strSectionName = "GeneralDataBasicInfo";
                    switch (nRetValue)
                    {
                        case 0:
                        case -1:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAdd") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbPosition") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdatePositionGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnPositionModify(object sender, EventArgs e)
        {
            Int32 iPositionID = GetCurSelPositionID();
            if (iPositionID == -1)
                return;

            Int32 iDiscID = -1;

            string strLanCode = GetCurActivedLanguageCode();

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            OVRBasicItemEditForm frmItemEdit = new OVRBasicItemEditForm();
            frmItemEdit.DatabaseConnection = m_genDataModule.DatabaseConnection;
            //fill sDlgParam
            OVRBasicItemEditForm.sDlgParam sDlgParam = new OVRBasicItemEditForm.sDlgParam();
            sDlgParam.bEnableDate = false;
            sDlgParam.bEnableSex = false;
            sDlgParam.bEnableRegType = false;
            sDlgParam.bEnableOrder = false;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = false;
            sDlgParam.bEnableLanguage = false;
            sDlgParam.bVisibleGroup = false;
            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = strLanCode;

            SqlCommand cmd = new SqlCommand("Proc_GetPositionByID", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
            SqlParameter cmdParameter2 = new SqlParameter("@PositionID", SqlDbType.Int);

            cmdParameter1.Value = strLanCode;
            cmdParameter2.Value = iPositionID;
            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);

            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    sBasicItemInfo.strRegCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_PositionCode");
                    sBasicItemInfo.strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_PositionLongName");
                    sBasicItemInfo.strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_PositionShortName");
                    sBasicItemInfo.strComment = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_PositionComment");
                    iDiscID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_DisciplineID");
                }
            }
            dr.Close();
            frmItemEdit.m_sBasicItem = sBasicItemInfo;

            frmItemEdit.ShowDialog();

            if (frmItemEdit.DialogResult == DialogResult.OK)
            {
                sBasicItemInfo = frmItemEdit.m_sBasicItem;
                try
                {
                    #region DML Command Setup for Proc_EditPosition

                    cmd = new SqlCommand("Proc_EditPosition", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    cmdParameter1 = new SqlParameter(
                                "@PositionID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@PositionID",
                                DataRowVersion.Current, iPositionID);

                    cmdParameter2 = new SqlParameter(
                                "@LanguageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@DisciplineID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                                DataRowVersion.Current, iDiscID);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@PositionLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@PositionLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@PositionShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@PositionShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter6 = new SqlParameter(
                                "@PositionComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@PositionComment",
                                DataRowVersion.Current, DBNull.Value);

                    SqlParameter cmdParameter7 = new SqlParameter(
                                "@PositionCode", SqlDbType.NVarChar, 10,
                                 ParameterDirection.Input, false, 0, 0, "@PositionCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
                                ParameterDirection.Output, false, 0, 0, "@Result",
                                DataRowVersion.Default, null);

                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);
                    cmd.Parameters.Add(cmdParameter3);
                    cmd.Parameters.Add(cmdParameter4);
                    cmd.Parameters.Add(cmdParameter5);
                    cmd.Parameters.Add(cmdParameter6);
                    cmd.Parameters.Add(cmdParameter7);
                    cmd.Parameters.Add(cmdParameterResult);
                    cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                    #endregion

                    cmd.ExecuteNonQuery();
                    int nRetValue = (int)cmd.Parameters["@Result"].Value;

                    string strPromotion;
                    string strSectionName = "GeneralDataBasicInfo";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModify") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbPosition") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -1:
                        case -2:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModify") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbPosition") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdatePositionGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnPositionDel(object sender, EventArgs e)
        {
            Int32 iPositionID = GetCurSelPositionID();
            if (iPositionID == -1)
                return;

            string strMsgBox;
            string strSectionName = "GeneralDataBasicInfo";
            strMsgBox = LocalizationRecourceManager.GetString(strSectionName, "DelMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }
            try
            {
                #region DML Command Setup for Proc_DelPosition

                SqlCommand cmd = new SqlCommand("Proc_DelPosition", m_genDataModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@PositionID", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@PositionID",
                            DataRowVersion.Current, iPositionID);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmd.Parameters["@Result"].Value;

                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDel") +
                                        LocalizationRecourceManager.GetString(strSectionName, "lbPosition") +
                                         LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDel") +
                                        LocalizationRecourceManager.GetString(strSectionName, "lbPosition") +
                                         LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDel") +
                                        LocalizationRecourceManager.GetString(strSectionName, "lbPosition") +
                                         LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                }
                UpdatePositionGrid();
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }


        private void OnCellContentClickDgvSport(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex == 0 && e.RowIndex != -1)
            {
                bool bChecked = (bool)dgvSportInfo.Rows[e.RowIndex].Cells[0].EditedFormattedValue;
                Int32 iChecked = bChecked ? 1 : 0;

                Int32 iColIdxID = dgvSportInfo.Columns["ID"].Index;
                Int32 iSportID = Convert.ToInt32(dgvSportInfo.Rows[e.RowIndex].Cells[iColIdxID].Value);
                if (iSportID <= 0)
                    return;

                if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_genDataModule.DatabaseConnection.Open();
                }

                #region DML Command Setup for Proc_UpdateSportActive

                SqlCommand cmd = new SqlCommand("Proc_UpdateSportActive", m_genDataModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@SportID", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@SportID",
                            DataRowVersion.Current, iSportID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@Active", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@Active",
                            DataRowVersion.Current, iChecked);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();

                UpdateSportGrid();
                UpdateDisciplineGrid();
                UpdateEventGrid();

                m_genDataModule.DataChangedNotify(OVRDataChangedType.emSportActive, -1, -1, -1, -1, iSportID, null);
            }
        }

        private void OnCellContentClickDgvLanguage(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex == 0 && e.RowIndex != -1)
            {
                bool bChecked = (bool)dgvLanguage.Rows[e.RowIndex].Cells[0].EditedFormattedValue;
                Int32 iChecked = bChecked ? 1 : 0;

                Int32 iColIdxID = dgvLanguage.Columns["Code"].Index;
                string strLanguageCode = dgvLanguage.Rows[e.RowIndex].Cells[iColIdxID].Value.ToString();
                if (strLanguageCode == "")
                    return;

                if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_genDataModule.DatabaseConnection.Open();
                }

                #region DML Command Setup for Proc_UpdateLanguageActive

                SqlCommand cmd = new SqlCommand("Proc_UpdateLanguageActive", m_genDataModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                             ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                            DataRowVersion.Current, strLanguageCode);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@Active", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@Active",
                            DataRowVersion.Current, iChecked);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();

                UpdateLanguageGrid();

                SystemSettingTabLanguageChange();
                BasicInfoTabLanguageChange();

                m_genDataModule.DataChangedNotify(OVRDataChangedType.emLangActive,  -1, -1, -1, -1, strLanguageCode, null);
            }
        }

        private void OnCellContentClickDgvDisc(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex == 0 && e.RowIndex != -1)
            {
                bool bChecked = (bool)dgvDisciplineInfo.Rows[e.RowIndex].Cells[0].EditedFormattedValue;
                Int32 iChecked = bChecked ? 1 : 0;
                Int32 iColIdxID = dgvDisciplineInfo.Columns["ID"].Index;
                Int32 iDiscID = Convert.ToInt32(dgvDisciplineInfo.Rows[e.RowIndex].Cells[iColIdxID].Value);
                if (iDiscID <= 0)
                    return;

                if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_genDataModule.DatabaseConnection.Open();
                }

                #region DML Command Setup for Proc_UpdateDisciplineActive

                SqlCommand cmd = new SqlCommand("Proc_UpdateDisciplineActive", m_genDataModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@DisciplineID", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@DisciplineID",
                            DataRowVersion.Current, iDiscID);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@Active", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@Active",
                            DataRowVersion.Current, iChecked);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 0,
                            ParameterDirection.Output, false, 0, 0, "@Result",
                            DataRowVersion.Default, null);

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();

                UpdateDisciplineGrid();
                UpdateEventGrid();
                //SystemSettingTabDisciplineChanged();

                m_genDataModule.DataChangedNotify(OVRDataChangedType.emDisciplineActive, iDiscID, -1, -1, -1, iDiscID, null);
            }
        }
    }
}
