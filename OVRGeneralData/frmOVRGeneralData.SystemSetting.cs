using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRGeneralData
{
    public partial class OVRGeneralDataForm:UIPage
    {
        private void SystemSettingLocalization()
        {
            string strSectionName = "GeneralDataSystemSetting";

            this.tabSystemSetting.Text = LocalizationRecourceManager.GetString(strSectionName, "tabSystemSetting");
            this.lbWeather.Text = LocalizationRecourceManager.GetString(strSectionName, "lbWeather");
            this.lbRegtype.Text = LocalizationRecourceManager.GetString(strSectionName, "lbRegtype");
            this.lbCitySetting.Text = LocalizationRecourceManager.GetString(strSectionName, "lbCitySetting");
            this.lbVenueSetting.Text = LocalizationRecourceManager.GetString(strSectionName, "lbVenueSetting");
            this.lbCourtSetting.Text = LocalizationRecourceManager.GetString(strSectionName, "lbCourtSetting");

            //this.btnWeatherNew.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnWeatherNew");
            //this.btnWeatherModify.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnWeatherModify");
            //this.btnWeatherDel.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnWeatherDel");
            //this.btnRegtypeNew.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnRegtypeNew");
            //this.btnRegtypeModify.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnRegtypeModify");
            //this.btnRegtypeDel.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnRegtypeDel");

            //this.btnCityNew.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnCityNew");
            //this.btnCityModify.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnCityModify");
            //this.btnCityDel.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnCityDel");
            //this.btnVenueNew.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnVenueNew");
            //this.btnVenueModify.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnVenueModify");
            //this.btnVenueDel.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnVenueDel");
            //this.btnDisciplineVenue.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnDisciplineVenue");

            //this.btnCourtNew.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnCourtNew");
            //this.btnCourtModify.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnCourtModify");
            //this.btnCourtDel.Tooltip = LocalizationRecourceManager.GetString(strSectionName, "btnCourtDel");

            this.lbOtherSetting.Text = LocalizationRecourceManager.GetString(strSectionName, "lbOtherSetting");
            this.btnImageEdit.Text = LocalizationRecourceManager.GetString(strSectionName, "btnImageEdit");

            this.btnVenueSet.Text = LocalizationRecourceManager.GetString(strSectionName, "btnVenueSet");
        }

        private void InitGridViewStyleInSystemSetting()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvWeather);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvRegtype);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvCityInfo);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvVenueInfo);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvCourtInfo);
        }

        private void SystemSettingTabLoad()
        {
            UpdateWeatherGrid();
            UpdateRegtypeGrid();
            UpdateCityGrid();
            UpdateVenueGrid();
            UpdateCourtGrid();
        }

        private void SystemSettingTabLanguageChange()
        {
            UpdateWeatherGrid();
            UpdateRegtypeGrid();
            UpdateCityGrid();
            UpdateVenueGrid();
            UpdateCourtGrid(); 
        }

        private void UpdateWeatherGrid()
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            #region DML Command Setup for daWeather

            SqlCommand cmd = new SqlCommand("Proc_GetWeatherTypes", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.UpdatedRowSource = UpdateRowSource.None;

            SqlParameter cmdParameter1 = new SqlParameter(
                         "@LanguageCode", SqlDbType.Char, 3,
                         ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                         DataRowVersion.Current, GetCurActivedLanguageCode());

            cmd.Parameters.Add(cmdParameter1);
            #endregion

            SqlDataReader dr = cmd.ExecuteReader();
            UpdateGridView(dgvWeather, dr);
            dr.Close();
        }

        private void UpdateRegtypeGrid()
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            #region DML Command Setup for daRegTypes

            SqlCommand cmd = new SqlCommand("Proc_GetRegTypes", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.UpdatedRowSource = UpdateRowSource.None;

            SqlParameter cmdParameter1 = new SqlParameter(
                         "@LanguageCode", SqlDbType.Char, 3,
                         ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                         DataRowVersion.Current, GetCurActivedLanguageCode());

            cmd.Parameters.Add(cmdParameter1);
            #endregion

            SqlDataReader dr = cmd.ExecuteReader();
            UpdateGridView(dgvRegtype, dr);
            dr.Close();
        }

        private int GetCurSelWeatherID()
        {
            return GetCurSelItemID(dgvWeather);
        }

     
        private int GetCurSelRegtypeID()
        {
            return GetCurSelItemID(dgvRegtype);
        }

        private int GetCurSelCityID()
        {
            return GetCurSelItemID(dgvCityInfo);
        }

        private int GetCurSelVenueID()
        {
            return GetCurSelItemID(dgvVenueInfo);
        }

        private int GetCurSelCourtID()
        {
            return GetCurSelItemID(dgvCourtInfo);
        }

        private void UpdateCityGrid()
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            #region DML Command Setup for daCity

            SqlCommand cmd = new SqlCommand("Proc_GetCities", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.UpdatedRowSource = UpdateRowSource.None;

            SqlParameter cmdParameter1 = new SqlParameter(
                         "@LanguageCode", SqlDbType.Char, 3,
                         ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                         DataRowVersion.Current, GetCurActivedLanguageCode());

            cmd.Parameters.Add(cmdParameter1);
            #endregion

            SqlDataReader dr = cmd.ExecuteReader();
            UpdateGridView(dgvCityInfo, dr);
            dr.Close();
        }

        private void UpdateVenueGrid()
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            #region DML Command Setup for daVenue

            SqlCommand cmd = new SqlCommand("Proc_GetCityVenues", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.UpdatedRowSource = UpdateRowSource.None;

            SqlParameter cmdParameter1 = new SqlParameter(
                        "@CityID", SqlDbType.Int, 0,
                         ParameterDirection.Input, false, 0, 0, "@CityID",
                        DataRowVersion.Current, GetCurSelCityID());

            SqlParameter cmdParameter2 = new SqlParameter(
                         "@LanguageCode", SqlDbType.Char, 3,
                         ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                         DataRowVersion.Current, GetCurActivedLanguageCode());

            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);
            #endregion

            SqlDataReader dr = cmd.ExecuteReader();
            UpdateGridView(dgvVenueInfo, dr);
            dr.Close();
        }

        private void UpdateCourtGrid()
        {
            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }

            #region DML Command Setup for daCourt

            SqlCommand cmd = new SqlCommand("Proc_GetVenueCourts", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.UpdatedRowSource = UpdateRowSource.None;

            SqlParameter cmdParameter1 = new SqlParameter(
                        "@VenueID", SqlDbType.Int, 0,
                         ParameterDirection.Input, false, 0, 0, "@VenueID",
                        DataRowVersion.Current, GetCurSelVenueID());

            SqlParameter cmdParameter2 = new SqlParameter(
                         "@LanguageCode", SqlDbType.Char, 3,
                         ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                         DataRowVersion.Current, GetCurActivedLanguageCode());

            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);
            #endregion

            SqlDataReader dr = cmd.ExecuteReader();
            UpdateGridView(dgvCourtInfo, dr);
            dr.Close();
        }


        private void OnNotifySelChangedCityGrid(object sender, EventArgs e)
        {
            if (m_bUpdatingUI)
                return;

            UpdateVenueGrid();
            UpdateCourtGrid();
        }

        private void OnNotifySelChangedVenueGrid(object sender, EventArgs e)
        {
            if (m_bUpdatingUI)
                return;

            UpdateCourtGrid();
        }

        private void OnBtnCityNew(object sender, EventArgs e)
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
                    #region DML Command Setup for proc_AddCity

                    SqlCommand cmd = new SqlCommand("proc_AddCity", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                "@CityCode", SqlDbType.NVarChar, 10,
                                 ParameterDirection.Input, false, 0, 0, "@CityCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                "@languageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@languageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@CityLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@CityLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@CityShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@CityShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@CityComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@CityComment",
                                DataRowVersion.Current, DBNull.Value);

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
                                ParameterDirection.Output, false, 0, 0, "@Result",
                                DataRowVersion.Default, null);

                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);
                    cmd.Parameters.Add(cmdParameter3);
                    cmd.Parameters.Add(cmdParameter4);
                    cmd.Parameters.Add(cmdParameter5);
                    cmd.Parameters.Add(cmdParameterResult);
                    cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                    #endregion

                    cmd.ExecuteNonQuery();
                    int nRetValue = (int)cmd.Parameters["@Result"].Value;

                    string strPromotion;
                    string strSectionName = "GeneralDataSystemSetting";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAddCityFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateCityGrid();
                    UpdateVenueGrid();
                    UpdateCourtGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnCityModify(object sender, EventArgs e)
        {
            Int32 iCityID = GetCurSelCityID();
            if (iCityID == -1)
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
            sDlgParam.bEnableOrder = false;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = false;
            sDlgParam.bEnableLanguage = false;
            sDlgParam.bVisibleGroup = false;
            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = strLanCode;

            SqlCommand cmd = new SqlCommand("Proc_GetCityByID", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter1 = new SqlParameter("@CityID", SqlDbType.Int);
            SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
            cmdParameter1.Value = iCityID;
            cmdParameter2.Value = strLanCode;
            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);

            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    sBasicItemInfo.strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_CityLongName");
                    sBasicItemInfo.strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_CityShortName");
                    sBasicItemInfo.strComment = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_CityComment");
                    sBasicItemInfo.strRegCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_CityCode");
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

                    cmd = new SqlCommand("proc_EditCity", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    cmdParameter1 = new SqlParameter(
                                "@CityID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@CityID",
                                DataRowVersion.Current, iCityID);

                    cmdParameter2 = new SqlParameter(
                                "@CityCode", SqlDbType.NVarChar, 10,
                                 ParameterDirection.Input, false, 0, 0, "@CityCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@languageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@languageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@CityLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@CityLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@CityShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@CityShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter6 = new SqlParameter(
                                "@CityComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@CityComment",
                                DataRowVersion.Current, DBNull.Value);

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
                    string strSectionName = "GeneralDataSystemSetting";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModifyCityFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -1:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModifyCityFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateCityGrid();
                    UpdateVenueGrid();
                    UpdateCourtGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnCityDel(object sender, EventArgs e)
        {
            Int32 iCityID = GetCurSelCityID();
            if (iCityID == -1)
                return;

            string strMsgBox;
            string strSectionName = "GeneralDataSystemSetting";
            strMsgBox = LocalizationRecourceManager.GetString(strSectionName, "DelMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }
            try
            {
                #region DML Command Setup for proc_DelCity

                SqlCommand cmd = new SqlCommand("proc_DelCity", m_genDataModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@CityID", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@CityID",
                            DataRowVersion.Current, iCityID);

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
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelCityFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelCityFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelCityFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                }
                UpdateCityGrid();
                UpdateVenueGrid();
                UpdateCourtGrid();
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void OnBtnVenueNew(object sender, EventArgs e)
        {
            Int32 iCityID = GetCurSelCityID();
            if (iCityID == -1)
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
                    #region DML Command Setup for proc_AddVenue

                    SqlCommand cmd = new SqlCommand("proc_AddVenue", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                "@VenueCode", SqlDbType.NVarChar, 10,
                                 ParameterDirection.Input, false, 0, 0, "@VenueCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                "@CityID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@CityID",
                                DataRowVersion.Current, iCityID);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@languageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@languageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@VenueLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@VenueLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@VenueShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@VenueShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter6 = new SqlParameter(
                                "@VenueComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@VenueComment",
                                DataRowVersion.Current, DBNull.Value);

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
                    string strSectionName = "GeneralDataSystemSetting";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAddVenueFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -1:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAddVenueFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateVenueGrid();
                    UpdateCourtGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnVenueModify(object sender, EventArgs e)
        {
            Int32 iCityID = -1;
            Int32 iVenueID = GetCurSelVenueID();
            if (iVenueID == -1)
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
            sDlgParam.bEnableOrder = false;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = false;
            sDlgParam.bEnableLanguage = false;
            sDlgParam.bVisibleGroup = false;
            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = strLanCode;

            SqlCommand cmd = new SqlCommand("Proc_GetVenueByID", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter1 = new SqlParameter("@VenueID", SqlDbType.Int);
            SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
            cmdParameter1.Value = iVenueID;
            cmdParameter2.Value = strLanCode;
            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);

            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    sBasicItemInfo.strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_VenueLongName");
                    sBasicItemInfo.strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_VenueShortName");
                    sBasicItemInfo.strComment = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_VenueComment");
                    sBasicItemInfo.strRegCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_VenueCode");
                    iCityID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_CityID");
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
                    #region DML Command Setup for proc_EditVenue

                    cmd = new SqlCommand("proc_EditVenue", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    cmdParameter1 = new SqlParameter(
                                "@VenueID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@VenueID",
                                DataRowVersion.Current, iVenueID);

                    cmdParameter2 = new SqlParameter(
                                "@VenueCode", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@VenueCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@CityID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@CityID",
                                DataRowVersion.Current, iCityID);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@languageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@languageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@VenueLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@VenueLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter6 = new SqlParameter(
                                "@VenueShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@VenueShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter7 = new SqlParameter(
                                "@VenueComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@VenueComment",
                                DataRowVersion.Current, DBNull.Value);

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
                    string strSectionName = "GeneralDataSystemSetting";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModifyVenueFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -1:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModifyVenueFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -2:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModifyVenueFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateVenueGrid();
                    UpdateCourtGrid();

                    m_genDataModule.DataChangedNotify(OVRDataChangedType.emVenueInfo, -1, -1, -1, -1, iVenueID, null);
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnVenueDel(object sender, EventArgs e)
        {
            Int32 iVenueID = GetCurSelVenueID();
            if (iVenueID == -1)
                return;

            string strMsgBox;
            string strSectionName = "GeneralDataSystemSetting";
            strMsgBox = LocalizationRecourceManager.GetString(strSectionName, "DelMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }
            try
            {
                #region DML Command Setup for proc_DelVenue

                SqlCommand cmd = new SqlCommand("proc_DelVenue", m_genDataModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@VenueID", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@VenueID",
                            DataRowVersion.Current, iVenueID);

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
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelVenueFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelVenueFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelVenueFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -3:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelVenueFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                }
                UpdateVenueGrid();
                UpdateCourtGrid();
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void OnBtnSetDisciplineVenue(object sender, EventArgs e)
        {
            OVRDisciplineVenueEditForm frmDisciplineVenue = new OVRDisciplineVenueEditForm();
            frmDisciplineVenue.DatabaseConnection = m_genDataModule.DatabaseConnection;
            frmDisciplineVenue.m_strLanguageCode = GetCurActivedLanguageCode();
            frmDisciplineVenue.module = m_genDataModule;
            frmDisciplineVenue.ShowDialog();
        }

        private void OnBtnCourtNew(object sender, EventArgs e)
        {
            Int32 iVenueID = GetCurSelVenueID();
            if (iVenueID == -1)
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
                    #region DML Command Setup for proc_AddCourt

                    SqlCommand cmd = new SqlCommand("proc_AddCourt", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                "@VenueID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@VenueID",
                                DataRowVersion.Current, iVenueID);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                "@languageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@languageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@CourtLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@CourtLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@CourtShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@CourtShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@CourtComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@CourtComment",
                                DataRowVersion.Current, DBNull.Value);

                    SqlParameter cmdParameter6 = new SqlParameter(
                               "@CourtCode", SqlDbType.NVarChar, 100,
                                ParameterDirection.Input, false, 0, 0, "@CourtCode",
                               DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    object courtOder = DBNull.Value;
                    if (sBasicItemInfo.strOrder != "")
                    {
                        courtOder = Convert.ToInt32(sBasicItemInfo.strOrder);
                    }
                    SqlParameter cmdParameter7 = new SqlParameter(
                                "@CourtOrder", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@CourtOrder",
                                DataRowVersion.Current, courtOder);

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
                    string strSectionName = "GeneralDataSystemSetting";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAddCourtFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -1:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAddCourtFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -2:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAddCourtFailed2");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateCourtGrid();

                    m_genDataModule.DataChangedNotify(OVRDataChangedType.emCourtAdd, -1, -1, -1, -1, nRetValue, null);
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnCourtModify(object sender, EventArgs e)
        {
            Int32 iVenueID = -1;
            Int32 iCourtID = GetCurSelCourtID();
            if (iCourtID == -1)
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
            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = strLanCode;

            SqlCommand cmd = new SqlCommand("Proc_GetCourtByID", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter1 = new SqlParameter("@CourtID", SqlDbType.Int);
            SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
            cmdParameter1.Value = iCourtID;
            cmdParameter2.Value = strLanCode;
            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);

            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    sBasicItemInfo.strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_CourtLongName");
                    sBasicItemInfo.strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_CourtShortName");
                    sBasicItemInfo.strComment = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_CourtComment");
                    sBasicItemInfo.strRegCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_CourtCode");
                    sBasicItemInfo.strOrder = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_Order");
                    iVenueID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, "F_VenueID");
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
                    #region DML Command Setup for proc_EditCourt

                    cmd = new SqlCommand("proc_EditCourt", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    cmdParameter1 = new SqlParameter(
                                "@CourtID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@CourtID",
                                DataRowVersion.Current, iCourtID);

                    cmdParameter2 = new SqlParameter(
                                "@VenueID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@VenueID",
                                DataRowVersion.Current, iVenueID);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@languageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@languageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@CourtLongName", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@CourtLongName",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@CourtShortName", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@CourtShortName",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter6 = new SqlParameter(
                                "@CourtComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@CourtComment",
                                DataRowVersion.Current, DBNull.Value);

                    SqlParameter cmdParameter7 = new SqlParameter(
                                "@CourtCode", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@CourtCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    object courtOder = DBNull.Value;
                    if (sBasicItemInfo.strOrder != "")
                    {
                        courtOder = Convert.ToInt32(sBasicItemInfo.strOrder);
                    }
                    SqlParameter cmdParameter8 = new SqlParameter(
                                "@CourtOrder", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@CourtOrder",
                                DataRowVersion.Current, courtOder);

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
                    string strSectionName = "GeneralDataSystemSetting";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModifyCourtFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -1:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModifyCourtFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -2:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModifyCourtFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -3:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModifyCourtFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateCourtGrid();

                    m_genDataModule.DataChangedNotify(OVRDataChangedType.emCourtInfo, -1, -1, -1, -1, iCourtID, null);
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnCourtDel(object sender, EventArgs e)
        {
            Int32 iCourtID = GetCurSelCourtID();
            if (iCourtID == -1)
                return;

            string strMsgBox;
            string strSectionName = "GeneralDataSystemSetting";
            strMsgBox = LocalizationRecourceManager.GetString(strSectionName, "DelMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }
            try
            {
                #region DML Command Setup for proc_DelCourt

                SqlCommand cmd = new SqlCommand("proc_DelCourt", m_genDataModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@CourtID", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@CourtID",
                            DataRowVersion.Current, iCourtID);

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
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelCourtFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelCourtFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDelCourtFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                }
                UpdateCourtGrid();

                m_genDataModule.DataChangedNotify(OVRDataChangedType.emCourtDel, -1, -1, -1, -1, iCourtID, null);
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

    
        private void OnBtnWeatherNew(object sender, EventArgs e)
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
                    #region DML Command Setup for Proc_AddWeatherType

                    SqlCommand cmd = new SqlCommand("Proc_AddWeatherType", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                "@LanguageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                "@WeatherCode", SqlDbType.NVarChar, 10,
                                 ParameterDirection.Input, false, 0, 0, "@WeatherCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@WeatherTypeLongDescription", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@WeatherTypeLongDescription",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@WeatherTypeShortDescription", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@WeatherTypeShortDescription",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

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
                    string strSectionName = "GeneralDataSystemSetting";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAdd") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbWeather") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateWeatherGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnWeatherModify(object sender, EventArgs e)
        {
            Int32 iWeatherID = GetCurSelWeatherID();
            if (iWeatherID == -1)
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
            sDlgParam.bEnableOrder = false;
            sDlgParam.bEnableRegCode = true;
            sDlgParam.bEnableCompetitionType = false;
            sDlgParam.bEnableLanguage = false;
            sDlgParam.bVisibleGroup = false;
            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = strLanCode;

            SqlCommand cmd = new SqlCommand("Proc_GetWeatherTypeByID", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
            SqlParameter cmdParameter2 = new SqlParameter("@WeatherTypeID", SqlDbType.Int);

            cmdParameter1.Value = strLanCode;
            cmdParameter2.Value = iWeatherID;
            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);

            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    sBasicItemInfo.strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_WeatherTypeLongDescription");
                    sBasicItemInfo.strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_WeatherTypeShortDescription");
                    sBasicItemInfo.strRegCode = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_WeatherCode");
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
                    #region DML Command Setup for Proc_EditWeatherType

                    cmd = new SqlCommand("Proc_EditWeatherType", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    cmdParameter1 = new SqlParameter(
                                "@WeatherTypeID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@WeatherTypeID",
                                DataRowVersion.Current, iWeatherID);

                    cmdParameter2 = new SqlParameter(
                                "@LanguageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@WeatherCode", SqlDbType.NVarChar, 10,
                                 ParameterDirection.Input, false, 0, 0, "@WeatherCode",
                                DataRowVersion.Current, sBasicItemInfo.strRegCode);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@WeatherTypeLongDescription", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@WeatherTypeLongDescription",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@WeatherTypeShortDescription", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@WeatherTypeShortDescription",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
                                ParameterDirection.Output, false, 0, 0, "@Result",
                                DataRowVersion.Default, null);

                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);
                    cmd.Parameters.Add(cmdParameter3);
                    cmd.Parameters.Add(cmdParameter4);
                    cmd.Parameters.Add(cmdParameter5);

                    cmd.Parameters.Add(cmdParameterResult);
                    cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                    #endregion

                    cmd.ExecuteNonQuery();
                    int nRetValue = (int)cmd.Parameters["@Result"].Value;

                    string strPromotion;
                    string strSectionName = "GeneralDataSystemSetting";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModify") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbWeather") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -1:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModify") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbWeather") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateWeatherGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnWeatherDel(object sender, EventArgs e)
        {
            Int32 iWeatherID = GetCurSelWeatherID();
            if (iWeatherID == -1)
                return;

            string strMsgBox;
            string strSectionName = "GeneralDataSystemSetting";
            strMsgBox = LocalizationRecourceManager.GetString(strSectionName, "DelMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }
            try
            {
                #region DML Command Setup for Proc_DelWeatherType

                SqlCommand cmd = new SqlCommand("Proc_DelWeatherType", m_genDataModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@WeatherTypeID", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@WeatherTypeID",
                            DataRowVersion.Current, iWeatherID);

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
                UpdateWeatherGrid();
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void OnBtnRegtypeNew(object sender, EventArgs e)
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
            sDlgParam.bEnableOrder = false;
            sDlgParam.bEnableRegCode = false;
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
                    #region DML Command Setup for Proc_AddRegType

                    SqlCommand cmd = new SqlCommand("Proc_AddRegType", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                "@LanguageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                "@RegTypeLongDescription", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@RegTypeLongDescription",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@RegTypeShortDescription", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@RegTypeShortDescription",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@RegTypeComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@RegTypeComment",
                                DataRowVersion.Current, DBNull.Value);

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
                    string strSectionName = "GeneralDataSystemSetting";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionAdd") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbRegtype") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateRegtypeGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnRegtypeModify(object sender, EventArgs e)
        {
            Int32 iRegtypeID = GetCurSelRegtypeID();
            if (iRegtypeID == -1)
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
            sDlgParam.bEnableOrder = false;
            sDlgParam.bEnableRegCode = false;
            sDlgParam.bEnableCompetitionType = false;
            sDlgParam.bEnableLanguage = false;
            sDlgParam.bVisibleGroup = false;
            frmItemEdit.m_sDlgParam = sDlgParam;

            //fill sBasicItemInfo
            OVRBasicItemEditForm.sBasicItemInfo sBasicItemInfo = new OVRBasicItemEditForm.sBasicItemInfo();
            sBasicItemInfo.strLanguageCode = strLanCode;

            SqlCommand cmd = new SqlCommand("Proc_GetRegTypeByID", m_genDataModule.DatabaseConnection);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
            SqlParameter cmdParameter2 = new SqlParameter("@RegTypeID", SqlDbType.Int);

            cmdParameter1.Value = strLanCode;
            cmdParameter2.Value = iRegtypeID;
            cmd.Parameters.Add(cmdParameter1);
            cmd.Parameters.Add(cmdParameter2);

            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.HasRows)
            {
                while (dr.Read())
                {
                    sBasicItemInfo.strLongName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_RegTypeLongDescription");
                    sBasicItemInfo.strShortName = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_RegTypeShortDescription");
                    sBasicItemInfo.strComment = OVRDataBaseUtils.GetFieldValue2String(ref dr, "F_RegTypeComment");
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
                    #region DML Command Setup for Proc_EditRegType

                    cmd = new SqlCommand("Proc_EditRegType", m_genDataModule.DatabaseConnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.UpdatedRowSource = UpdateRowSource.None;

                    cmdParameter1 = new SqlParameter(
                                "@RegTypeID", SqlDbType.Int, 0,
                                 ParameterDirection.Input, false, 0, 0, "@RegTypeID",
                                DataRowVersion.Current, iRegtypeID);

                    cmdParameter2 = new SqlParameter(
                                "@LanguageCode", SqlDbType.Char, 3,
                                 ParameterDirection.Input, false, 0, 0, "@LanguageCode",
                                DataRowVersion.Current, sBasicItemInfo.strLanguageCode);

                    SqlParameter cmdParameter3 = new SqlParameter(
                                "@RegTypeLongDescription", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@RegTypeLongDescription",
                                DataRowVersion.Current, sBasicItemInfo.strLongName);

                    SqlParameter cmdParameter4 = new SqlParameter(
                                "@RegTypeShortDescription", SqlDbType.NVarChar, 50,
                                 ParameterDirection.Input, false, 0, 0, "@RegTypeShortDescription",
                                DataRowVersion.Current, sBasicItemInfo.strShortName);

                    SqlParameter cmdParameter5 = new SqlParameter(
                                "@RegTypeComment", SqlDbType.NVarChar, 100,
                                 ParameterDirection.Input, false, 0, 0, "@RegTypeComment",
                                DataRowVersion.Current, DBNull.Value);

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 0,
                                ParameterDirection.Output, false, 0, 0, "@Result",
                                DataRowVersion.Default, null);

                    cmd.Parameters.Add(cmdParameter1);
                    cmd.Parameters.Add(cmdParameter2);
                    cmd.Parameters.Add(cmdParameter3);
                    cmd.Parameters.Add(cmdParameter4);
                    cmd.Parameters.Add(cmdParameter5);
                    cmd.Parameters.Add(cmdParameterResult);
                    cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                    #endregion

                    cmd.ExecuteNonQuery();
                    int nRetValue = (int)cmd.Parameters["@Result"].Value;

                    string strPromotion;
                    string strSectionName = "GeneralDataSystemSetting";
                    switch (nRetValue)
                    {
                        case 0:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModify") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbRegtype") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                        case -1:
                            strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionModify") +
                                            LocalizationRecourceManager.GetString(strSectionName, "lbRegtype") +
                                             LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                            DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                            return;
                    }
                    UpdateRegtypeGrid();
                }
                catch (System.Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
        }

        private void OnBtnRegtypeDel(object sender, EventArgs e)
        {
            Int32 iRegtypeID = GetCurSelRegtypeID();
            if (iRegtypeID == -1)
                return;

            string strMsgBox;
            string strSectionName = "GeneralDataSystemSetting";
            strMsgBox = LocalizationRecourceManager.GetString(strSectionName, "DelMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            if (m_genDataModule.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                m_genDataModule.DatabaseConnection.Open();
            }
            try
            {
                #region DML Command Setup for Proc_DelRegType

                SqlCommand cmd = new SqlCommand("Proc_DelRegType", m_genDataModule.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@RegTypeID", SqlDbType.Int, 0,
                             ParameterDirection.Input, false, 0, 0, "@RegTypeID",
                            DataRowVersion.Current, iRegtypeID);

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
                                        LocalizationRecourceManager.GetString(strSectionName, "lbRegtype") +
                                         LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDel") +
                                        LocalizationRecourceManager.GetString(strSectionName, "lbRegtype") +
                                         LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(strSectionName, "PromotionDel") +
                                        LocalizationRecourceManager.GetString(strSectionName, "lbRegtype") +
                                         LocalizationRecourceManager.GetString(strSectionName, "PromotionFailed");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return;
                }
                UpdateRegtypeGrid();
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void OnBtnImageEdit(object sender, EventArgs e)
        {
            OVRPictureEditForm frmPictureEdit = new OVRPictureEditForm();
            frmPictureEdit.DatabaseConnection = m_genDataModule.DatabaseConnection;
            frmPictureEdit.ShowDialog();
        }

        private void btnVenueSet_Click(object sender, EventArgs e)
        {
            OVRVenueListForm frmVenueList = new OVRVenueListForm();
            frmVenueList.DatabaseConnection = m_genDataModule.DatabaseConnection;
            frmVenueList.ShowDialog();

            if (lbVenueSet.Text != frmVenueList.VenueCode)
            {
                lbVenueSet.Text = frmVenueList.VenueCode;
                m_genDataModule.NotifyMainFrame(OVRModule2FrameEventType.emVenueChanged, lbVenueSet.Text);
            }
        }

    }
}