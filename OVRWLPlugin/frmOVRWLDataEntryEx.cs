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
namespace AutoSports.OVRWLPlugin
{
    public partial class OVRWLDataEntryForm : Office2007Form
    {
        #region 数据接口
        //数据接口
        public class ObjectEx
        {
            public int m_nRowIdx = -1;
            public string m_strComPos = "";
            public string m_strRegisterID = "";
            public string m_strBib = "";
            public int m_nLotNo = 0;
            public string m_strGroup = "";
            public string m_strName = "";
            public string m_strNoc = "";
            public string m_strLightOrder = "";
            public string m_str1stAttempt = "";
            public string m_str2ndAttempt = "";
            public string m_str3rdAttempt = "";
            public string m_str1stRes = "";
            public string m_str2ndRes = "";
            public string m_str3rdRes = "";
            public int m_nAttemptIdx = -1;
            public string m_strAttempt = "";
            public string m_strResult = "";
            public string m_strBodyWeight = "";
            public string m_strIRM = "";
            public string m_strStatus = "";
            public string m_strFinishOrder = "";
            public string m_strRecord = "";
            public string m_strLastAttempt = "";
            public string m_strSnatchLastAttempt = "";
            public int m_nResultTimes = 0;
            public int m_nSnatchResultTimes = 0;
            public int m_nIsContinue = 0;

            public string m_strSnatchResult = "";
            public string m_strSnatchRank = "";
            public string m_strSnatchIRM = "";
            public string m_strCleanJerkResult = "";
            public string m_strCleanJerkRank = "";
            public string m_strCleanJerkIRM = "";
            public string m_strTotalResult = "";
            public string m_strTotalIRM = "";
            public string m_strTotalRank = "";

            public string m_strRank = "";
            public string m_strDisplayPosition = "";
            public int m_nAge = 0;

        }
        #endregion

        #region 初始化/更新界面展现
        //界面展现
        private void UpdateMatchStatus()
        {
            switch (m_nMatchStatusID)
            {
                case 30:
                    this.btnX_StatusSetting.Text = this.buttonItem_Scheduled.Text;
                    SettingControls(false);
                    break;
                case 40:
                    this.btnX_StatusSetting.Text = this.buttonItem_StartList.Text;
                    SettingControls(false);
                    break;
                case 50:
                    this.btnX_StatusSetting.Text = this.buttonItem_Running.Text;
                    SettingControls(true);
                    break;
                case 60:
                    this.btnX_StatusSetting.Text = this.buttonItem_Suspend.Text;
                    break;
                case 100:
                    this.btnX_StatusSetting.Text = this.buttonItem_Unofficial.Text;
                    break;
                case 110:
                    this.btnX_StatusSetting.Text = this.buttonItem_Finished.Text;
                    dgv_List.ReadOnly = true;
                    break;
                case 120:
                    this.btnX_StatusSetting.Text = this.buttonItem_Revision.Text;
                    break;
                case 130:
                    this.btnX_StatusSetting.Text = this.buttonItem_Canceled.Text;
                    break;
                default:
                    this.btnX_StatusSetting.Text = LocalizationRecourceManager.GetString(GVWL.g_WLPlugin.GetSectionName(), "OVRSGPlugin_OVRSGDataEntryForm_btnX_StatusSetting");
                    break;
            }
        }

        private void InitRecordsDataGridView()
        {
            DataGridView dgv = this.dgv_Records;
            dgv.Columns.Clear();
            DataGridViewColumn col = null;

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "F_EventID";
            col.Name = "F_EventID";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "F_RecordID";
            col.Name = "F_RecordID";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "F_RecordTypeID";
            col.Name = "F_RecordTypeID";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.Frozen = false;
            col.HeaderText = "Type";
            col.Name = "Type";
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 80;
            col.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.Frozen = false;
            col.HeaderText = "Lift";
            col.Name = "Lift";
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 35;
            col.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.Frozen = false;
            col.HeaderText = "Result";
            col.Name = "Result";
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 45;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.Frozen = false;
            col.HeaderText = "Name";
            col.Name = "Name";
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.True;
            col.MinimumWidth = 100;
            col.Width = 122;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.Frozen = false;
            col.HeaderText = "NOC";
            col.Name = "NOC";
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 25;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = "Date";
            col.Name = "Date";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.True;
            col.Width = 60;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Place";
            col.Name = "Place";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.True;
            col.Width = 40;
            dgv.Columns.Add(col);

        }

        private void UpdateRecordsDataGridView()
        {
            DataGridView dgv = this.dgv_Records;

            System.Data.DataTable dt = GVWL.g_ManageDB.GetRecords(m_nCurMatchID);
            dgv.Rows.Clear();
            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row.CreateCells(dgv);
                row.Selected = false;

                int nCol = 0;
                string strFieldName = "";

                strFieldName = "F_EventID";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "F_RecordID";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "F_RecordTypeID";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Type";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Lift";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;


                strFieldName = "Result";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Name";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "NOC";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Date";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Place";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;
                dgv.Rows.Add(row);
            }
        }

        private void InitListDataGridView()
        {
            DataGridView dgv = this.dgv_List;
            dgv.Columns.Clear();
            DataGridViewColumn col = null;

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "F_CompetitionPosition";
            col.Name = "F_CompetitionPosition";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "F_RegisterID";
            col.Name = "F_RegisterID";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Order";
            col.Name = "LightOrder";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 40;
            col.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Bib";
            col.Name = "Bib";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 35;
            col.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "LotNo";
            col.Name = "LotNo";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 40;
            col.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = "Weight";
            col.Name = "Weight";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 50;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Name";
            col.Name = "Name";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.True;
            col.Width = 122;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "NOC";
            col.Name = "NOC";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 25;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = "1st\nAttempt";
            col.Name = "1stAttempt";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 60;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "1st\nRes";
            col.Name = "1stRes";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 40;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = "2nd\nAttempt";
            col.Name = "2ndAttempt";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 60;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "2nd\nRes";
            col.Name = "2ndRes";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 40;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = "3rd\nAttempt";
            col.Name = "3rdAttempt";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 60;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "3rd\nRes";
            col.Name = "3rdRes";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 40;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = false;
            col.HeaderText = "Result";
            col.Name = "Result";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 50;
            col.Visible = true;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Rank";
            col.Name = "Rank";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 40;
            col.Visible = true;
            col.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "IRM";
            col.Name = "IRM";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 35;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Status";
            col.Name = "Status";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 50;
            col.Visible = true;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Record";
            col.Name = "Record";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 50;
            col.MinimumWidth = 50;
            col.Visible = true;
            dgv.Columns.Add(col);


            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "SnatchResult";
            col.Name = "SnatchResult";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "SnatchIRM";
            col.Name = "SnatchIRM";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "CleanJerkResult";
            col.Name = "CleanJerkResult";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "CleanJerkIRM";
            col.Name = "CleanJerkIRM";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "TotalResult";
            col.Name = "TotalResult";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "TotalIRM";
            col.Name = "TotalIRM";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "AttemptTime";
            col.Name = "AttemptTime";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "ResultTimes";
            col.Name = "ResultTimes";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "LastAttempt";
            col.Name = "LastAttempt";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "IsContinue";
            col.Name = "IsContinue";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Other1stAttempt";
            col.Name = "Other1stAttempt";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "InscriptionResult";
            col.Name = "InscriptionResult";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Age";
            col.Name = "Age";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);
        }

        private void UpdateListDataGridView()
        {
            DataGridView dgv = this.dgv_List;

            System.Data.DataTable dt = GVWL.g_ManageDB.GetMatchPlayerList(m_nCurMatchID);

            dgv.Rows.Clear();
            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row.CreateCells(dgv);
                row.Selected = false;

                int nCol = 0;
                string strFieldName = "";

                strFieldName = "F_CompetitionPosition";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "F_RegisterID";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "LightOrder";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Bib";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "LotNo";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "BodyWeight";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Name";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "NOC";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "1stAttempt";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "1stRes";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "2ndAttempt";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "2ndRes";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "3rdAttempt";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "3rdRes";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Result";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Rank";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "IRM";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Status";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Record";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "SnatchResult";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "SnatchIRM";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "CleanJerkResult";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "CleanJerkIRM";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "TotalResult";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "TotalIRM";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "AttemptTime";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "ResultTimes";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "LastAttempt";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "IsContinue";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Other1stAttempt";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "InscriptionResult";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Age";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                if (dt.Rows[nRow]["IsContinue"].ToString() == "0")
                    dgv.Rows.Add(row);
                //if (dt.Rows[nRow]["IsContinue"].ToString() == "1")
                //{ 
                //    dgv.Rows[dgv.Rows.Count - 1].ReadOnly = true;
                //    dgv.Rows[dgv.Rows.Count - 1].DefaultCellStyle.BackColor = Color.BurlyWood;
                //}
            }
        }

        private void UpdateListDataGridViewStyle()
        {
            //获取界面数据
            DataGridView dgv = this.dgv_List;
            ArrayList aryObjectEx = null;
            GetDataGridViewData(dgv, out aryObjectEx);

            //处理Attepmt
            foreach (ObjectEx obj in aryObjectEx)
                CalculationAttempt(obj);

            //处理Order逻辑
            CalculationLightOrder(aryObjectEx);

            foreach (ObjectEx obj in aryObjectEx)
            {
                int RowIndex = obj.m_nRowIdx;

                string str1stRes = obj.m_str1stRes;
                string str2ndRes = obj.m_str2ndRes;
                string str3rdRes = obj.m_str3rdRes;

                if (this.CalculationLight(str1stRes) == 1)
                    dgv.Rows[RowIndex].Cells["1stAttempt"].Style.ForeColor = Color.Blue;
                else if (this.CalculationLight(str1stRes) == 0)
                    dgv.Rows[RowIndex].Cells["1stAttempt"].Style.ForeColor = Color.Red;
                else
                    dgv.Rows[RowIndex].Cells["1stAttempt"].Style.ForeColor = Color.Black;

                if (this.CalculationLight(str2ndRes) == 1)
                    dgv.Rows[RowIndex].Cells["2ndAttempt"].Style.ForeColor = Color.Blue;
                else if (this.CalculationLight(str2ndRes) == 0)
                    dgv.Rows[RowIndex].Cells["2ndAttempt"].Style.ForeColor = Color.Red;
                else
                    dgv.Rows[RowIndex].Cells["2ndAttempt"].Style.ForeColor = Color.Black;

                if (this.CalculationLight(str3rdRes) == 1)
                    dgv.Rows[RowIndex].Cells["3rdAttempt"].Style.ForeColor = Color.Blue;
                else if (this.CalculationLight(str3rdRes) == 0)
                    dgv.Rows[RowIndex].Cells["3rdAttempt"].Style.ForeColor = Color.Red;
                else
                    dgv.Rows[RowIndex].Cells["3rdAttempt"].Style.ForeColor = Color.Black;

                string strStatus = obj.m_strStatus;
                if (strStatus.Contains("0"))
                    this.dgv_List.Rows[RowIndex].DefaultCellStyle.BackColor = Color.BurlyWood;
                else
                    this.dgv_List.Rows[RowIndex].DefaultCellStyle.BackColor = Color.White;
                string strLightOrder = obj.m_strLightOrder;
                int nAttemptIdx = obj.m_nAttemptIdx;

                #region comment
                /*
                                if (strLightOrder == "1")
                                {
                                    if (nAttemptIdx == 1)
                                    {
                                        dgv.Rows[RowIndex].Cells["1stAttempt"].Style.BackColor = Color.Blue;
                                        dgv.Rows[RowIndex].Cells["1stRes"].Style.BackColor = Color.Blue;
                                        dgv.Rows[RowIndex].Cells["2ndAttempt"].Style.BackColor = Color.White;
                                        dgv.Rows[RowIndex].Cells["2ndRes"].Style.BackColor = Color.White;
                                        dgv.Rows[RowIndex].Cells["3rdAttempt"].Style.BackColor = Color.White;
                                        dgv.Rows[RowIndex].Cells["3rdRes"].Style.BackColor = Color.White;
                                    }
                                    else if (nAttemptIdx == 2)
                                    {
                                        dgv.Rows[RowIndex].Cells["1stAttempt"].Style.BackColor = Color.White;
                                        dgv.Rows[RowIndex].Cells["1stRes"].Style.BackColor = Color.White;
                                        dgv.Rows[RowIndex].Cells["2ndAttempt"].Style.BackColor = Color.Blue;
                                        dgv.Rows[RowIndex].Cells["2ndRes"].Style.BackColor = Color.Blue;
                                        dgv.Rows[RowIndex].Cells["3rdAttempt"].Style.BackColor = Color.White;
                                        dgv.Rows[RowIndex].Cells["3rdRes"].Style.BackColor = Color.White;
                                    }
                                    else if (nAttemptIdx == 3)
                                    {
                                        dgv.Rows[RowIndex].Cells["1stAttempt"].Style.BackColor = Color.White;
                                        dgv.Rows[RowIndex].Cells["1stRes"].Style.BackColor = Color.White;
                                        dgv.Rows[RowIndex].Cells["2ndAttempt"].Style.BackColor = Color.White;
                                        dgv.Rows[RowIndex].Cells["2ndRes"].Style.BackColor = Color.White;
                                        dgv.Rows[RowIndex].Cells["3rdAttempt"].Style.BackColor = Color.Blue;
                                        dgv.Rows[RowIndex].Cells["3rdRes"].Style.BackColor = Color.Blue;
                                    }
                                }
                                else
                                {
                                    dgv.Rows[RowIndex].Cells["1stAttempt"].Style.BackColor = Color.White;
                                    dgv.Rows[RowIndex].Cells["2ndAttempt"].Style.BackColor = Color.White;
                                    dgv.Rows[RowIndex].Cells["3rdAttempt"].Style.BackColor = Color.White;
                                    dgv.Rows[RowIndex].Cells["1stRes"].Style.BackColor = Color.White;
                                    dgv.Rows[RowIndex].Cells["2ndRes"].Style.BackColor = Color.White;
                                    dgv.Rows[RowIndex].Cells["3rdRes"].Style.BackColor = Color.White;
                                }
                 */
                #endregion
            }
        }

        private void InitTotalDataGridView()
        {
            DataGridView dgv = this.dgv_Total;
            dgv.Columns.Clear();
            DataGridViewColumn col = null;

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "F_RegisterID";
            col.Name = "F_RegisterID";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "TotalRank";
            col.Name = "TotalRank";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 65;
            col.Visible = true;
            col.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Group";
            col.Name = "Group";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 50;
            col.Visible = true;
            col.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Bib";
            col.Name = "Bib";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 40;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Weight";
            col.Name = "BodyWeight";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 50;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Name";
            col.Name = "Name";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.True;
            col.Width = 180;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "NOC";
            col.Name = "NOC";
            col.Frozen = true;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 25;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Snatch";
            col.Name = "SnatchResult";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 65;
            col.Visible = true;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "SnatchIRM";
            col.Name = "SnatchIRM";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "CleanJerk";
            col.Name = "CleanJerkResult";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 65;
            col.Visible = true;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "CleanJerkIRM";
            col.Name = "CleanJerkIRM";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Total";
            col.Name = "TotalResult";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 65;
            col.Visible = true;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "IRM";
            col.Name = "TotalIRM";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 35;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "FinishOrder";
            col.Name = "FinishOrder";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 80;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Record";
            col.Name = "Record";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 60;
            col.MinimumWidth = 60;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "ResultTimes";
            col.Name = "ResultTimes";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "LotNo";
            col.Name = "LotNo";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "LastAttempt";
            col.Name = "LastAttempt";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "IsContinue";
            col.Name = "IsContinue";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "Age";
            col.Name = "Age";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "SnatchRank";
            col.Name = "SnatchRank";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "CleanJerkRank";
            col.Name = "CleanJerkRank";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "SnatchResultTimes";
            col.Name = "SnatchResultTimes";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);

            col = new DataGridViewTextBoxColumn();
            col.ReadOnly = true;
            col.HeaderText = "SnatchLastAttempt";
            col.Name = "SnatchLastAttempt";
            col.Frozen = false;
            col.AutoSizeMode = DataGridViewAutoSizeColumnMode.None;
            col.SortMode = DataGridViewColumnSortMode.Programmatic;
            col.Resizable = DataGridViewTriState.False;
            col.Width = 0;
            col.Visible = false;
            dgv.Columns.Add(col);
        }

        private void UpdateTotalDataGridView()
        {
            DataGridView dgv = this.dgv_Total;

            System.Data.DataTable dt = GVWL.g_ManageDB.GetEventPlayerList(m_nCurMatchID);

            dgv.Rows.Clear();
            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                DataGridViewRow row = new DataGridViewRow();
                row.CreateCells(dgv);
                row.Selected = false;

                int nCol = 0;
                string strFieldName = "";

                strFieldName = "F_RegisterID";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "TotalRank";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Group";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Bib";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "BodyWeight";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Name";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "NOC";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;


                strFieldName = "SnatchResult";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "SnatchIRM";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "CleanJerkResult";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "CleanJerkIRM";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "TotalResult";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "TotalIRM";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "FinishOrder";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Record";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "ResultTimes";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "LotNo";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "LastAttempt";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "IsContinue";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "Age";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "SnatchRank";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "CleanJerkRank";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "SnatchResultTimes";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = "";
                nCol++;

                strFieldName = "SnatchLastAttempt";
                if (dt.Rows[nRow][strFieldName] != DBNull.Value)
                    row.Cells[nCol].Value = dt.Rows[nRow][strFieldName].ToString();
                else
                    row.Cells[nCol].Value = ""; 

                dgv.Rows.Add(row);
            }
        }

        private void UpdateTotalDataGridView(ArrayList aryObjectEx)
        {
            DataGridView dgv = this.dgv_Total;
            int nRowIdx = 0;
            foreach (ObjectEx obj in aryObjectEx)
            {
                dgv.Rows[nRowIdx].Cells["F_RegisterID"].Value = obj.m_strRegisterID;
                dgv.Rows[nRowIdx].Cells["TotalRank"].Value = obj.m_strTotalRank;
                dgv.Rows[nRowIdx].Cells["Group"].Value = obj.m_strGroup;
                dgv.Rows[nRowIdx].Cells["Bib"].Value = obj.m_strBib;
                dgv.Rows[nRowIdx].Cells["BodyWeight"].Value = obj.m_strBodyWeight;
                dgv.Rows[nRowIdx].Cells["Name"].Value = obj.m_strName;
                dgv.Rows[nRowIdx].Cells["NOC"].Value = obj.m_strNoc;
                dgv.Rows[nRowIdx].Cells["SnatchResult"].Value = obj.m_strSnatchResult;
                dgv.Rows[nRowIdx].Cells["SnatchIRM"].Value = obj.m_strSnatchIRM;
                dgv.Rows[nRowIdx].Cells["CleanJerkResult"].Value = obj.m_strCleanJerkResult;
                dgv.Rows[nRowIdx].Cells["CleanJerkIRM"].Value = obj.m_strCleanJerkIRM;
                dgv.Rows[nRowIdx].Cells["TotalResult"].Value = obj.m_strTotalResult;
                dgv.Rows[nRowIdx].Cells["TotalIRM"].Value = obj.m_strTotalIRM;
                dgv.Rows[nRowIdx].Cells["FinishOrder"].Value = obj.m_strFinishOrder;
                dgv.Rows[nRowIdx].Cells["ResultTimes"].Value = obj.m_nResultTimes;
                dgv.Rows[nRowIdx].Cells["LotNo"].Value = obj.m_nLotNo;
                dgv.Rows[nRowIdx].Cells["LastAttempt"].Value = obj.m_strLastAttempt;
                dgv.Rows[nRowIdx].Cells["IsContinue"].Value = obj.m_nIsContinue;
                dgv.Rows[nRowIdx].Cells["SnatchRank"].Value = obj.m_strSnatchRank;
                dgv.Rows[nRowIdx].Cells["CleanJerkRank"].Value = obj.m_strCleanJerkRank;
                dgv.Rows[nRowIdx].Cells["SnatchResultTimes"].Value = obj.m_nSnatchResultTimes;
                dgv.Rows[nRowIdx].Cells["SnatchLastAttempt"].Value = obj.m_strSnatchLastAttempt;

                nRowIdx++;
            }
        }
        #endregion

        #region 获取界面数据
        //获取界面数据
        public int GetDataGridViewData(DataGridView dgv, int RowIndex, out ObjectEx objEx)
        {
            string strComPos = "";
            if (dgv.Rows[RowIndex].Cells["F_CompetitionPosition"].Value != null)
                strComPos = dgv.Rows[RowIndex].Cells["F_CompetitionPosition"].Value.ToString().Trim();

            string strRegisterID = "";
            if (dgv.Rows[RowIndex].Cells["F_RegisterID"].Value != null)
                strRegisterID = dgv.Rows[RowIndex].Cells["F_RegisterID"].Value.ToString().Trim();

            string strLightOrder = "";
            if (dgv.Rows[RowIndex].Cells["LightOrder"].Value != null)
                strLightOrder = dgv.Rows[RowIndex].Cells["LightOrder"].Value.ToString();

            string str1stAttempt = "";
            if (dgv.Rows[RowIndex].Cells["1stAttempt"].Value != null)
                str1stAttempt = dgv.Rows[RowIndex].Cells["1stAttempt"].Value.ToString();

            string str1stRes = "";
            if (dgv.Rows[RowIndex].Cells["1stRes"].Value != null)
                str1stRes = dgv.Rows[RowIndex].Cells["1stRes"].Value.ToString();

            string str2ndAttempt = "";
            if (dgv.Rows[RowIndex].Cells["2ndAttempt"].Value != null)
                str2ndAttempt = dgv.Rows[RowIndex].Cells["2ndAttempt"].Value.ToString();

            string str2ndRes = "";
            if (dgv.Rows[RowIndex].Cells["2ndRes"].Value != null)
                str2ndRes = dgv.Rows[RowIndex].Cells["2ndRes"].Value.ToString();

            string str3rdAttempt = "";
            if (dgv.Rows[RowIndex].Cells["3rdAttempt"].Value != null)
                str3rdAttempt = dgv.Rows[RowIndex].Cells["3rdAttempt"].Value.ToString();

            string str3rdRes = "";
            if (dgv.Rows[RowIndex].Cells["3rdRes"].Value != null)
                str3rdRes = dgv.Rows[RowIndex].Cells["3rdRes"].Value.ToString();

            string strIRM = "";
            if (dgv.Rows[RowIndex].Cells["IRM"].Value != null)
                strIRM = dgv.Rows[RowIndex].Cells["IRM"].Value.ToString();

            string strStatus = "";
            if (dgv.Rows[RowIndex].Cells["Status"].Value != null)
                strStatus = dgv.Rows[RowIndex].Cells["Status"].Value.ToString();

            string strSnatchResult = "";
            if (dgv.Rows[RowIndex].Cells["SnatchResult"].Value != null)
                strSnatchResult = dgv.Rows[RowIndex].Cells["SnatchResult"].Value.ToString();

            string strCleanJerkResult = "";
            if (dgv.Rows[RowIndex].Cells["CleanJerkResult"].Value != null)
                strCleanJerkResult = dgv.Rows[RowIndex].Cells["CleanJerkResult"].Value.ToString();

            string strTotalResult = "";
            if (dgv.Rows[RowIndex].Cells["TotalResult"].Value != null)
                strTotalResult = dgv.Rows[RowIndex].Cells["TotalResult"].Value.ToString();

            string strBodyWeight = "";
            if (dgv.Rows[RowIndex].Cells["Weight"].Value != null)
                strBodyWeight = dgv.Rows[RowIndex].Cells["Weight"].Value.ToString();

            string strLotNo = "";
            if (dgv.Rows[RowIndex].Cells["LotNo"].Value != null)
                strLotNo = dgv.Rows[RowIndex].Cells["LotNo"].Value.ToString();

            string strAttemptTime = "";
            if (dgv.Rows[RowIndex].Cells["AttemptTime"].Value != null)
                strAttemptTime = dgv.Rows[RowIndex].Cells["AttemptTime"].Value.ToString();

            string strResultTimes = "";
            if (dgv.Rows[RowIndex].Cells["ResultTimes"].Value != null)
                strResultTimes = dgv.Rows[RowIndex].Cells["ResultTimes"].Value.ToString();

            string strLastAttempt = "";
            if (dgv.Rows[RowIndex].Cells["LastAttempt"].Value != null)
                strLastAttempt = dgv.Rows[RowIndex].Cells["LastAttempt"].Value.ToString();

            string strAge = "";
            if (dgv.Rows[RowIndex].Cells["Age"].Value != null)
                strAge = dgv.Rows[RowIndex].Cells["Age"].Value.ToString();

            string strResult = "";
            if (dgv.Rows[RowIndex].Cells["Result"].Value != null)
                strResult = dgv.Rows[RowIndex].Cells["Result"].Value.ToString();

            string strRank = "";
            if (dgv.Rows[RowIndex].Cells["Rank"].Value != null)
                strRank = dgv.Rows[RowIndex].Cells["Rank"].Value.ToString();

            ObjectEx objEx_Temp = new ObjectEx();
            objEx_Temp.m_nRowIdx = RowIndex;
            objEx_Temp.m_strComPos = strComPos;
            objEx_Temp.m_strRegisterID = strRegisterID;
            objEx_Temp.m_strLightOrder = strLightOrder;
            objEx_Temp.m_str1stAttempt = str1stAttempt;
            objEx_Temp.m_str2ndAttempt = str2ndAttempt;
            objEx_Temp.m_str3rdAttempt = str3rdAttempt;
            objEx_Temp.m_str1stRes = str1stRes;
            objEx_Temp.m_str2ndRes = str2ndRes;
            objEx_Temp.m_str3rdRes = str3rdRes;
            objEx_Temp.m_strIRM = strIRM;
            objEx_Temp.m_strStatus = strStatus;
            objEx_Temp.m_nAttemptIdx = Convert.ToInt32(string.IsNullOrEmpty(strAttemptTime) ? "1" : strAttemptTime);
            objEx_Temp.m_nLotNo = Convert.ToInt32(string.IsNullOrEmpty(strLotNo) ? "-1" : strLotNo);
            objEx_Temp.m_strRank = strRank;
            objEx_Temp.m_strResult = strResult;
            objEx_Temp.m_strSnatchResult = strSnatchResult;
            objEx_Temp.m_strCleanJerkResult = strCleanJerkResult;
            objEx_Temp.m_strTotalResult = strTotalResult;
            objEx_Temp.m_strBodyWeight = strBodyWeight;
            objEx_Temp.m_nResultTimes = Convert.ToInt32(strResultTimes);
            objEx_Temp.m_strLastAttempt = strLastAttempt;
            objEx_Temp.m_nAge = Convert.ToInt32(string.IsNullOrEmpty(strAge) ? "0" : strAge);

            objEx = objEx_Temp;

            return 1;
        }

        public int GetDataGridViewData(DataGridView dgv, out ArrayList aryObjectEx)
        {
            ArrayList aryObjectEx_Temp = new ArrayList();
            ObjectEx objEx = null;
            foreach (DataGridViewRow r in dgv.Rows)
            {
                GetDataGridViewData(dgv, r.Index, out objEx);
                aryObjectEx_Temp.Add(objEx);
            }

            aryObjectEx = aryObjectEx_Temp;

            return 1;
        }

        #region cuikai deleting : used property in the methods
        //public WeightLifting GetDataGridViewData(DataGridView dgv, int RowIndex)
        //{
        //    WeightLifting WL = new WeightLifting();
        //    string strComPos = "";
        //    if (dgv.Rows[RowIndex].Cells["F_CompetitionPosition"].Value != null)
        //        strComPos = dgv.Rows[RowIndex].Cells["F_CompetitionPosition"].Value.ToString().Trim();

        //    string strRegisterID = "";
        //    if (dgv.Rows[RowIndex].Cells["F_RegisterID"].Value != null)
        //        strRegisterID = dgv.Rows[RowIndex].Cells["F_RegisterID"].Value.ToString().Trim();

        //    string strLightOrder = "";
        //    if (dgv.Rows[RowIndex].Cells["LightOrder"].Value != null)
        //        strLightOrder = dgv.Rows[RowIndex].Cells["LightOrder"].Value.ToString();

        //    string str1stAttempt = "";
        //    if (dgv.Rows[RowIndex].Cells["1stAttempt"].Value != null)
        //        str1stAttempt = dgv.Rows[RowIndex].Cells["1stAttempt"].Value.ToString();

        //    string str1stRes = "";
        //    if (dgv.Rows[RowIndex].Cells["1stRes"].Value != null)
        //        str1stRes = dgv.Rows[RowIndex].Cells["1stRes"].Value.ToString();

        //    string str2ndAttempt = "";
        //    if (dgv.Rows[RowIndex].Cells["2ndAttempt"].Value != null)
        //        str2ndAttempt = dgv.Rows[RowIndex].Cells["2ndAttempt"].Value.ToString();

        //    string str2ndRes = "";
        //    if (dgv.Rows[RowIndex].Cells["2ndRes"].Value != null)
        //        str2ndRes = dgv.Rows[RowIndex].Cells["2ndRes"].Value.ToString();

        //    string str3rdAttempt = "";
        //    if (dgv.Rows[RowIndex].Cells["3rdAttempt"].Value != null)
        //        str3rdAttempt = dgv.Rows[RowIndex].Cells["3rdAttempt"].Value.ToString();

        //    string str3rdRes = "";
        //    if (dgv.Rows[RowIndex].Cells["3rdRes"].Value != null)
        //        str3rdRes = dgv.Rows[RowIndex].Cells["3rdRes"].Value.ToString();

        //    string strIRM = "";
        //    if (dgv.Rows[RowIndex].Cells["IRM"].Value != null)
        //        strIRM = dgv.Rows[RowIndex].Cells["IRM"].Value.ToString();

        //    string strStatus = "";
        //    if (dgv.Rows[RowIndex].Cells["Status"].Value != null)
        //        strStatus = dgv.Rows[RowIndex].Cells["Status"].Value.ToString();

        //    string strSnatchResult = "";
        //    if (dgv.Rows[RowIndex].Cells["SnatchResult"].Value != null)
        //        strSnatchResult = dgv.Rows[RowIndex].Cells["SnatchResult"].Value.ToString();

        //    string strCleanJerkResult = "";
        //    if (dgv.Rows[RowIndex].Cells["CleanJerkResult"].Value != null)
        //        strCleanJerkResult = dgv.Rows[RowIndex].Cells["CleanJerkResult"].Value.ToString();

        //    string strTotalResult = "";
        //    if (dgv.Rows[RowIndex].Cells["TotalResult"].Value != null)
        //        strTotalResult = dgv.Rows[RowIndex].Cells["TotalResult"].Value.ToString();

        //    string strBodyWeight = "";
        //    if (dgv.Rows[RowIndex].Cells["Weight"].Value != null)
        //        strBodyWeight = dgv.Rows[RowIndex].Cells["Weight"].Value.ToString();

        //    ObjectEx objEx_Temp = new ObjectEx();
        //    objEx_Temp.m_nRowIdx = RowIndex;
        //    objEx_Temp.m_strComPos = strComPos;
        //    objEx_Temp.m_strRegisterID = strRegisterID;
        //    objEx_Temp.m_strLightOrder = strLightOrder;
        //    objEx_Temp.m_str1stAttempt = str1stAttempt;
        //    objEx_Temp.m_str2ndAttempt = str2ndAttempt;
        //    objEx_Temp.m_str3rdAttempt = str3rdAttempt;
        //    objEx_Temp.m_str1stRes = str1stRes;
        //    objEx_Temp.m_str2ndRes = str2ndRes;
        //    objEx_Temp.m_str3rdRes = str3rdRes;
        //    objEx_Temp.m_strIRM = strIRM;
        //    objEx_Temp.m_strStatus = strStatus;
        //    //objEx_Temp.m_nAttemptIdx = nAttemptIdx;
        //    //objEx_Temp.m_strAttempt = strAttempt;
        //    //objEx_Temp.m_strResult = strResult;
        //    objEx_Temp.m_strSnatchResult = strSnatchResult;
        //    objEx_Temp.m_strCleanJerkResult = strCleanJerkResult;
        //    objEx_Temp.m_strTotalResult = strTotalResult;
        //    objEx_Temp.m_strBodyWeight = strBodyWeight;
        //    WL.RowIndex = RowIndex;
        //    WL.CompetitionPosition = strComPos;
        //    WL.RegisterID = strRegisterID;
        //    WL.LightOrder = strLightOrder;
        //    WL.FirstAttempt = str1stAttempt;
        //    WL.SecondAttempt = str2ndAttempt;
        //    WL.ThirdAttempt = str3rdAttempt;
        //    WL.FirstAttemptResult = str1stRes;
        //    WL.SecondAttemptResult = str2ndRes;
        //    WL.ThirdAttemptResult = str3rdRes;
        //    WL.IRM = strIRM;
        //    WL.Status = strStatus;
        //    //WL.AttemptTimes = nAttemptIdx;
        //    //WL.Attempt = strAttempt;
        //    //WL.AttemptResult = strResult;
        //    WL.SnatchResult = strSnatchResult;
        //    WL.CleanJerkResult = strCleanJerkResult;
        //    WL.TotalResult = strTotalResult;
        //    WL.BodyWeight = strBodyWeight;
        //    return WL;
        //}
        //public List<WeightLifting> GetDataGridViewData(DataGridView dgv)
        //{
        //    List<WeightLifting> WL_List = new List<WeightLifting>();
        //    foreach (DataGridViewRow row in dgv.Rows)
        //    {
        //        WeightLifting WL = GetDataGridViewData(dgv, row.Index);
        //        WL_List.Add(WL);
        //    }

        //    return WL_List;
        //}
        #endregion

        public int GetDataGridViewMatchResult(DataGridView dgv, int RowIndex, out ObjectEx objEx)
        {
            string strComPos = "";
            if (dgv.Rows[RowIndex].Cells["F_CompetitionPosition"].Value != null)
                strComPos = dgv.Rows[RowIndex].Cells["F_CompetitionPosition"].Value.ToString().Trim();

            string strLightOrder = "";
            if (dgv.Rows[RowIndex].Cells["LightOrder"].Value != null)
                strLightOrder = dgv.Rows[RowIndex].Cells["LightOrder"].Value.ToString();

            string strResult = "";
            if (dgv.Rows[RowIndex].Cells["Result"].Value != null)
                strResult = dgv.Rows[RowIndex].Cells["Result"].Value.ToString();

            string strBodyWeight = "";
            if (dgv.Rows[RowIndex].Cells["Weight"].Value != null)
                strBodyWeight = dgv.Rows[RowIndex].Cells["Weight"].Value.ToString();

            string strIRM = "";
            if (dgv.Rows[RowIndex].Cells["IRM"].Value != null)
                strIRM = dgv.Rows[RowIndex].Cells["IRM"].Value.ToString();

            string strResultTimes = "";
            if (dgv.Rows[RowIndex].Cells["ResultTimes"].Value != null)
                strResultTimes = dgv.Rows[RowIndex].Cells["ResultTimes"].Value.ToString();

            string strLastResult = "";
            if (dgv.Rows[RowIndex].Cells["LastAttempt"].Value != null)
                strLastResult = dgv.Rows[RowIndex].Cells["LastAttempt"].Value.ToString();

            string strLotNo = "";
            if (dgv.Rows[RowIndex].Cells["LotNo"].Value != null)
                strLotNo = dgv.Rows[RowIndex].Cells["LotNo"].Value.ToString();

            string strIsContinue = "";
            if (dgv.Rows[RowIndex].Cells["IsContinue"].Value != null)
                strIsContinue = dgv.Rows[RowIndex].Cells["IsContinue"].Value.ToString();

            ObjectEx objEx_Temp = new ObjectEx();
            objEx_Temp.m_nRowIdx = RowIndex;
            objEx_Temp.m_strComPos = strComPos;
            objEx_Temp.m_strLightOrder = strLightOrder;
            objEx_Temp.m_strResult = strResult;
            objEx_Temp.m_strBodyWeight = strBodyWeight;
            objEx_Temp.m_strIRM = strIRM;
            objEx_Temp.m_nResultTimes = Convert.ToInt32(strResultTimes);
            int nLotNo = 0;
            int.TryParse(strLotNo, out  nLotNo);
            objEx_Temp.m_nLotNo = nLotNo;
            objEx_Temp.m_strLastAttempt = strLastResult;
            objEx_Temp.m_nIsContinue = Convert.ToInt32(strIsContinue);

            dgv.Rows[RowIndex].Tag = objEx_Temp;
            objEx = objEx_Temp;

            return 1;
        }

        public int GetDataGridViewMatchResult(DataGridView dgv, out ArrayList aryObjectEx)
        {
            ArrayList aryObjectEx_Temp = new ArrayList();
            ObjectEx objEx = null;
            foreach (DataGridViewRow r in dgv.Rows)
            {
                GetDataGridViewMatchResult(dgv, r.Index, out objEx);
                aryObjectEx_Temp.Add(objEx);
            }

            aryObjectEx = aryObjectEx_Temp;

            return 1;
        }

        public int GetDataGridViewPhaseResult(DataGridView dgv, int RowIndex, out ObjectEx objEx)
        {
            string strRegisterID = "";
            if (dgv.Rows[RowIndex].Cells["F_RegisterID"].Value != null)
                strRegisterID = dgv.Rows[RowIndex].Cells["F_RegisterID"].Value.ToString().Trim();

            string strTotalResult = "";
            if (dgv.Rows[RowIndex].Cells["TotalResult"].Value != null)
                strTotalResult = dgv.Rows[RowIndex].Cells["TotalResult"].Value.ToString();
            strTotalResult = strTotalResult == "---" ? "" : strTotalResult;

            string strBodyWeight = "";
            if (dgv.Rows[RowIndex].Cells["BodyWeight"].Value != null)
                strBodyWeight = dgv.Rows[RowIndex].Cells["BodyWeight"].Value.ToString();


            string strTotalIRM = "";
            if (dgv.Rows[RowIndex].Cells["TotalIRM"].Value != null)
                strTotalIRM = dgv.Rows[RowIndex].Cells["TotalIRM"].Value.ToString();

            string strSnatchResult = "";
            if (dgv.Rows[RowIndex].Cells["SnatchResult"].Value != null)
                strSnatchResult = dgv.Rows[RowIndex].Cells["SnatchResult"].Value.ToString();
            strSnatchResult = strSnatchResult == "---" ? "" : strSnatchResult;

            string strCJResult = "";
            if (dgv.Rows[RowIndex].Cells["CleanJerkResult"].Value != null)
                strCJResult = dgv.Rows[RowIndex].Cells["CleanJerkResult"].Value.ToString();
            strCJResult = strCJResult == "---" ? "" : strCJResult;

            string strResultTimes = "";
            if (dgv.Rows[RowIndex].Cells["ResultTimes"].Value != null)
                strResultTimes = dgv.Rows[RowIndex].Cells["ResultTimes"].Value.ToString();

            string strLotNo = "";
            if (dgv.Rows[RowIndex].Cells["LotNo"].Value != null)
                strLotNo = dgv.Rows[RowIndex].Cells["LotNo"].Value.ToString();

            string strLastAttempt = "";
            if (dgv.Rows[RowIndex].Cells["LastAttempt"].Value != null)
                strLastAttempt = dgv.Rows[RowIndex].Cells["LastAttempt"].Value.ToString();

            string strIsContinue = "";
            if (dgv.Rows[RowIndex].Cells["IsContinue"].Value != null)
                strIsContinue = dgv.Rows[RowIndex].Cells["IsContinue"].Value.ToString();

            string strSnatchResultTimes = "";
            if (dgv.Rows[RowIndex].Cells["SnatchResultTimes"].Value != null)
                strSnatchResultTimes = dgv.Rows[RowIndex].Cells["SnatchResultTimes"].Value.ToString().Trim();

            string strSnatchLastAttempt = "";
            if (dgv.Rows[RowIndex].Cells["SnatchLastAttempt"].Value != null)
                strSnatchLastAttempt = dgv.Rows[RowIndex].Cells["SnatchLastAttempt"].Value.ToString().Trim();

            ObjectEx objEx_Temp = new ObjectEx();
            objEx_Temp.m_nRowIdx = RowIndex;
            //objEx_Temp.m_strComPos = strComPos;
            //objEx_Temp.m_strLightOrder = strLightOrder;
            objEx_Temp.m_strTotalResult = strTotalResult;
            objEx_Temp.m_strBodyWeight = strBodyWeight;
            objEx_Temp.m_strTotalIRM = strTotalIRM;

            objEx_Temp.m_strRegisterID = strRegisterID;
            objEx_Temp.m_strSnatchResult = strSnatchResult;
            objEx_Temp.m_strCleanJerkResult = strCJResult;
            objEx_Temp.m_nResultTimes = Convert.ToInt32(strResultTimes);
            int nLotNo = 0;
            int.TryParse(strLotNo, out  nLotNo);
            objEx_Temp.m_nLotNo = nLotNo;
            objEx_Temp.m_strLastAttempt = strLastAttempt;
            objEx_Temp.m_nIsContinue = Convert.ToInt32(strIsContinue);

            objEx_Temp.m_nSnatchResultTimes = Convert.ToInt32(string.IsNullOrEmpty(strSnatchResultTimes) ? "0" : strSnatchResultTimes);
            objEx_Temp.m_strSnatchLastAttempt = strSnatchLastAttempt;

            objEx = objEx_Temp;

            return 1;
        }

        public int GetDataGridViewPhaseResult(DataGridView dgv, out ArrayList aryObjectEx)
        {
            ArrayList aryObjectEx_Temp = new ArrayList();
            ObjectEx objEx = null;
            foreach (DataGridViewRow r in dgv.Rows)
            {
                if (r.Cells["Group"].Value != null)
                {
                    string groupCode = r.Cells["Group"].Value.ToString();
                    if (groupCode == m_strPhaseCode)
                    {
                        GetDataGridViewPhaseResult(dgv, r.Index, out objEx);
                        aryObjectEx_Temp.Add(objEx);
                    }
                }
            }

            aryObjectEx = aryObjectEx_Temp;

            return 1;
        }

        public int GetDataGridViewEventResult(DataGridView dgv, int RowIndex, out ObjectEx objEx)
        {
            string strRegisterID = "";
            if (dgv.Rows[RowIndex].Cells["F_RegisterID"].Value != null)
                strRegisterID = dgv.Rows[RowIndex].Cells["F_RegisterID"].Value.ToString().Trim();

            string strTotalResult = "";
            if (dgv.Rows[RowIndex].Cells["TotalResult"].Value != null)
                strTotalResult = dgv.Rows[RowIndex].Cells["TotalResult"].Value.ToString();
            strTotalResult = strTotalResult == "---" ? "" : strTotalResult;

            string strBodyWeight = "";
            if (dgv.Rows[RowIndex].Cells["Weight"].Value != null)
                strBodyWeight = dgv.Rows[RowIndex].Cells["Weight"].Value.ToString();

            string strTotalIRM = "";
            if (dgv.Rows[RowIndex].Cells["TotalIRM"].Value != null)
                strTotalIRM = dgv.Rows[RowIndex].Cells["TotalIRM"].Value.ToString();

            string strCJResult = "";
            if (dgv.Rows[RowIndex].Cells["CleanJerkResult"].Value != null)
                strCJResult = dgv.Rows[RowIndex].Cells["CleanJerkResult"].Value.ToString();
            strCJResult = strCJResult == "---" ? "" : strCJResult;

            string strResultTimes = "";
            if (dgv.Rows[RowIndex].Cells["ResultTimes"].Value != null)
                strResultTimes = dgv.Rows[RowIndex].Cells["ResultTimes"].Value.ToString();

            string strLotNo = "";
            if (dgv.Rows[RowIndex].Cells["LotNo"].Value != null)
                strLotNo = dgv.Rows[RowIndex].Cells["LotNo"].Value.ToString();

            string strLastAttempt = "";
            if (dgv.Rows[RowIndex].Cells["LastAttempt"].Value != null)
                strLastAttempt = dgv.Rows[RowIndex].Cells["LastAttempt"].Value.ToString();

            string strIsContinue = "";
            if (dgv.Rows[RowIndex].Cells["IsContinue"].Value != null)
                strIsContinue = dgv.Rows[RowIndex].Cells["IsContinue"].Value.ToString();

            string strSnatchResultTimes = "";
            if (dgv.Rows[RowIndex].Cells["SnatchResultTimes"].Value != null)
                strSnatchResultTimes = dgv.Rows[RowIndex].Cells["SnatchResultTimes"].Value.ToString().Trim();

            string strSnatchLastAttempt = "";
            if (dgv.Rows[RowIndex].Cells["SnatchLastAttempt"].Value != null)
                strSnatchLastAttempt = dgv.Rows[RowIndex].Cells["SnatchLastAttempt"].Value.ToString().Trim();

            ObjectEx objEx_Temp = new ObjectEx();
            objEx_Temp.m_nRowIdx = RowIndex;
            objEx_Temp.m_strRegisterID = strRegisterID;
            objEx_Temp.m_strTotalResult = strTotalResult;
            objEx_Temp.m_strBodyWeight = strBodyWeight;
            objEx_Temp.m_strTotalIRM = strTotalIRM;
            objEx_Temp.m_strCleanJerkResult = strCJResult;
            objEx_Temp.m_nResultTimes = Convert.ToInt32(strResultTimes);
            objEx_Temp.m_nLotNo = Convert.ToInt32(strLotNo);
            objEx_Temp.m_strLastAttempt = strLastAttempt;
            objEx_Temp.m_nIsContinue = Convert.ToInt32(strIsContinue);

            objEx_Temp.m_nSnatchResultTimes = Convert.ToInt32(string.IsNullOrEmpty(strSnatchResultTimes) ? "0" : strSnatchResultTimes);
            objEx_Temp.m_strSnatchLastAttempt = strSnatchLastAttempt;

            objEx = objEx_Temp;

            return 1;
        }

        public int GetDataGridViewEventResult(DataGridView dgv, out ArrayList aryObjectEx)
        {
            ArrayList aryObjectEx_Temp = new ArrayList();
            ObjectEx objEx = null;
            foreach (DataGridViewRow r in dgv.Rows)
            {
                GetDataGridViewEventResult(dgv, r.Index, out objEx);
                aryObjectEx_Temp.Add(objEx);
            }

            aryObjectEx = aryObjectEx_Temp;

            return 1;
        }

        public int GetTotalDataGridViewData(DataGridView dgv, int RowIndex, out ObjectEx objEx)
        {
            #region Get Data
            string strRegisterID = "";
            if (dgv.Rows[RowIndex].Cells["F_RegisterID"].Value != null)
                strRegisterID = dgv.Rows[RowIndex].Cells["F_RegisterID"].Value.ToString().Trim();

            string strTotalRank = "";
            if (dgv.Rows[RowIndex].Cells["TotalRank"].Value != null)
                strTotalRank = dgv.Rows[RowIndex].Cells["TotalRank"].Value.ToString().Trim();

            string strGroup = "";
            if (dgv.Rows[RowIndex].Cells["Group"].Value != null)
                strGroup = dgv.Rows[RowIndex].Cells["Group"].Value.ToString().Trim();

            string strBib = "";
            if (dgv.Rows[RowIndex].Cells["Bib"].Value != null)
                strBib = dgv.Rows[RowIndex].Cells["Bib"].Value.ToString().Trim();

            string strName = "";
            if (dgv.Rows[RowIndex].Cells["Name"].Value != null)
                strName = dgv.Rows[RowIndex].Cells["Name"].Value.ToString().Trim();

            string strNoc = "";
            if (dgv.Rows[RowIndex].Cells["Noc"].Value != null)
                strNoc = dgv.Rows[RowIndex].Cells["Noc"].Value.ToString().Trim();

            string strSnatchResult = "";
            if (dgv.Rows[RowIndex].Cells["SnatchResult"].Value != null)
                strSnatchResult = dgv.Rows[RowIndex].Cells["SnatchResult"].Value.ToString().Trim();
            strSnatchResult = strSnatchResult == "---" ? "" : strSnatchResult;

            string strCleanJerkResult = "";
            if (dgv.Rows[RowIndex].Cells["CleanJerkResult"].Value != null)
                strCleanJerkResult = dgv.Rows[RowIndex].Cells["CleanJerkResult"].Value.ToString().Trim();
            strCleanJerkResult = strCleanJerkResult == "---" ? "" : strCleanJerkResult;

            string strTotalResult = "";
            if (dgv.Rows[RowIndex].Cells["TotalResult"].Value != null)
                strTotalResult = dgv.Rows[RowIndex].Cells["TotalResult"].Value.ToString().Trim();
            strTotalResult = strTotalResult == "---" ? "" : strTotalResult;

            string strTotalIRM = "";
            if (dgv.Rows[RowIndex].Cells["TotalIRM"].Value != null)
                strTotalIRM = dgv.Rows[RowIndex].Cells["TotalIRM"].Value.ToString().Trim();

            string strBodyWeight = "";
            if (dgv.Rows[RowIndex].Cells["BodyWeight"].Value != null)
                strBodyWeight = dgv.Rows[RowIndex].Cells["BodyWeight"].Value.ToString();

            string strFinishOrder = "";
            if (dgv.Rows[RowIndex].Cells["FinishOrder"].Value != null)
                strFinishOrder = dgv.Rows[RowIndex].Cells["FinishOrder"].Value.ToString().Trim();

            string strResultTimes = "";
            if (dgv.Rows[RowIndex].Cells["ResultTimes"].Value != null)
                strResultTimes = dgv.Rows[RowIndex].Cells["ResultTimes"].Value.ToString();

            string strLotNo = "";
            if (dgv.Rows[RowIndex].Cells["LotNo"].Value != null)
                strLotNo = dgv.Rows[RowIndex].Cells["LotNo"].Value.ToString();

            string strLastAttempt = "";
            if (dgv.Rows[RowIndex].Cells["LastAttempt"].Value != null)
                strLastAttempt = dgv.Rows[RowIndex].Cells["LastAttempt"].Value.ToString();

            string strIsContinue = "";
            if (dgv.Rows[RowIndex].Cells["IsContinue"].Value != null)
                strIsContinue = dgv.Rows[RowIndex].Cells["IsContinue"].Value.ToString();

            string strAge = "";
            if (dgv.Rows[RowIndex].Cells["Age"].Value != null)
                strAge = dgv.Rows[RowIndex].Cells["Age"].Value.ToString();

            string strSnatchRank = "";
            if (dgv.Rows[RowIndex].Cells["SnatchRank"].Value != null)
                strSnatchRank = dgv.Rows[RowIndex].Cells["SnatchRank"].Value.ToString().Trim();

            string strCleanJerkRank = "";
            if (dgv.Rows[RowIndex].Cells["CleanJerkRank"].Value != null)
                strCleanJerkRank = dgv.Rows[RowIndex].Cells["CleanJerkRank"].Value.ToString().Trim();

            string strSnatchResultTimes = "";
            if (dgv.Rows[RowIndex].Cells["SnatchResultTimes"].Value != null)
                strSnatchResultTimes = dgv.Rows[RowIndex].Cells["SnatchResultTimes"].Value.ToString().Trim();

            string strSnatchLastAttempt = "";
            if (dgv.Rows[RowIndex].Cells["SnatchLastAttempt"].Value != null)
                strSnatchLastAttempt = dgv.Rows[RowIndex].Cells["SnatchLastAttempt"].Value.ToString().Trim();

            #endregion

            ObjectEx objEx_Temp = new ObjectEx();
            objEx_Temp.m_nRowIdx = RowIndex;
            objEx_Temp.m_strRegisterID = strRegisterID;
            objEx_Temp.m_strTotalRank = strTotalRank;
            objEx_Temp.m_strGroup = strGroup;
            objEx_Temp.m_strBib = strBib;
            objEx_Temp.m_strName = strName;
            objEx_Temp.m_strNoc = strNoc;
            objEx_Temp.m_strSnatchResult = strSnatchResult;
            objEx_Temp.m_strCleanJerkResult = strCleanJerkResult;
            objEx_Temp.m_strTotalResult = strTotalResult;
            objEx_Temp.m_strTotalIRM = strTotalIRM;
            objEx_Temp.m_strBodyWeight = strBodyWeight;
            objEx_Temp.m_strFinishOrder = strFinishOrder;
            objEx_Temp.m_nResultTimes = Convert.ToInt32(strResultTimes);
            int nLotNo = 0;
            int.TryParse(strLotNo, out  nLotNo);
            objEx_Temp.m_nLotNo = nLotNo;
            objEx_Temp.m_strLastAttempt = strLastAttempt;
            objEx_Temp.m_nIsContinue = Convert.ToInt32(strIsContinue);
            objEx_Temp.m_nAge = Convert.ToInt32(string.IsNullOrEmpty(strAge) ? "0" : strAge);
            objEx_Temp.m_strSnatchRank = strSnatchRank;
            objEx_Temp.m_strCleanJerkRank = strCleanJerkRank;
            objEx_Temp.m_nSnatchResultTimes = Convert.ToInt32(string.IsNullOrEmpty(strSnatchResultTimes) ? "0" : strSnatchResultTimes);
            objEx_Temp.m_strSnatchLastAttempt = strSnatchLastAttempt;

            objEx = objEx_Temp;

            return 1;
        }

        public int GetTotalDataGridViewData(DataGridView dgv, out ArrayList aryObjectEx)
        {
            ArrayList aryObjectEx_Temp = new ArrayList();
            ObjectEx objEx = null;
            foreach (DataGridViewRow r in dgv.Rows)
            {
                GetTotalDataGridViewData(dgv, r.Index, out objEx);
                aryObjectEx_Temp.Add(objEx);
            }

            aryObjectEx = aryObjectEx_Temp;

            return 1;
        }

        #endregion

        #region 业务逻辑/计算函数
        //业务逻辑
        public class ComparerEx : IComparer
        {
            public ComparerEx() { }

            int IComparer.Compare(Object obj1, Object obj2)
            {
                ObjectEx objEx1 = (ObjectEx)obj1;
                ObjectEx objEx2 = (ObjectEx)obj2;
                if (objEx1 == objEx2)
                    return 0;
                string test = string.Empty;
                if ((objEx1.m_nLotNo == 102 && objEx2.m_nLotNo == 201) || (objEx1.m_nLotNo == 201 && objEx2.m_nLotNo == 102))
                    test = "test";

                #region 不按FinishOrder排名
                //int nLightOrder1 = 0;
                //int nLightOrder2 = 0;

                //if (objEx1.m_strLightOrder.Length != 0)
                //    nLightOrder1 = int.Parse(objEx1.m_strLightOrder);
                //if (objEx2.m_strLightOrder.Length != 0)
                //    nLightOrder2 = int.Parse(objEx2.m_strLightOrder);

                //int nFinishOrder1 = 0;
                //int nFinishOrder2 = 0;

                //if (objEx1.m_strFinishOrder.Length != 0)
                //    nFinishOrder1 = int.Parse(objEx1.m_strFinishOrder);
                //if (objEx2.m_strFinishOrder.Length != 0)
                //    nFinishOrder2 = int.Parse(objEx2.m_strFinishOrder);
                #endregion

                #region 排序不考虑IRM状态
                //if (objEx1.m_strIRM.Length != 0 || objEx2.m_strIRM.Length != 0)
                //{
                //    //崔凯：比赛犯规，排序垫底
                //    if (objEx1.m_strIRM.Length != 0 && objEx2.m_strIRM.Length == 0)
                //            return 1;
                //    if (objEx1.m_strIRM.Length == 0 && objEx2.m_strIRM.Length != 0)
                //            return -1;
                //    return 0;

                //    //if (objEx1.m_strIRM.Length != 0 && objEx2.m_strIRM.Length == 0)
                //    //    return -1;
                //    //if (objEx1.m_strIRM.Length == 0 && objEx2.m_strIRM.Length != 0)
                //    //    return 1;

                //    //if (objEx1.m_strIRM != "DNF" && objEx2.m_strIRM == "DNF")
                //    //    return -1;
                //    //if (objEx1.m_strIRM == "DNF" && objEx2.m_strIRM != "DNF")
                //    //    return 1;

                //    //if (objEx1.m_strIRM == "DSQ" && objEx2.m_strIRM != "DSQ")
                //    //    return 1;
                //    //if (objEx1.m_strIRM != "DSQ" && objEx2.m_strIRM == "DSQ")
                //    //    return -1;

                //    //if (nFinishOrder1 > nFinishOrder2)
                //    //    return 1;
                //    //if (nFinishOrder1 < nFinishOrder2)
                //    //    return -1;

                //    //if (nLightOrder1 > nLightOrder2)
                //    //    return 1;
                //    //else if (nLightOrder1 < nLightOrder2)
                //    //    return -1;
                //    
                //}
                #endregion
                //崔凯：抓举比赛没完成，没成绩，不能参加挺举比赛，排序垫底
                if (objEx1.m_nIsContinue == 1 || objEx2.m_nIsContinue == 1)
                {
                    if (objEx1.m_nIsContinue == 1 && objEx2.m_nIsContinue == 0)
                        return -1;
                    if (objEx1.m_nIsContinue == 0 && objEx2.m_nIsContinue == 1)
                        return 1;
                }
                float fResult1 = 0.0f;
                float fResult2 = 0.0f;

                if (objEx1.m_strResult.Length != 0)
                    fResult1 = float.Parse(objEx1.m_strResult);
                else return 1;
                if (objEx2.m_strResult.Length != 0)
                    fResult2 = float.Parse(objEx2.m_strResult);
                else return -1;

                if (!float.Equals(fResult1, fResult2))
                {
                    if (fResult1 < fResult2)
                        return 1;
                    if (fResult1 > fResult2)
                        return -1;
                }
                else
                {
                    float fBodyWeight1 = 0.0f;
                    float fBodyWeight2 = 0.0f;

                    if (objEx1.m_strBodyWeight.Length != 0)
                        fBodyWeight1 = float.Parse(objEx1.m_strBodyWeight);
                    if (objEx2.m_strBodyWeight.Length != 0)
                        fBodyWeight2 = float.Parse(objEx2.m_strBodyWeight);

                    if (!float.Equals(fBodyWeight1, fBodyWeight2))
                    {
                        if (fBodyWeight1 > fBodyWeight2)
                            return 1;
                        if (fBodyWeight1 < fBodyWeight2)
                            return -1;
                    }
                    else
                    {//崔凯：成绩相等，体重也相等
                        #region 根据2010最新规则，总成绩排名将不再考虑最好挺举成绩
                        if (objEx1.m_strCleanJerkResult.Length != 0 && objEx2.m_strCleanJerkResult.Length != 0)
                        {//崔凯：计算总成绩时：判断挺举成绩
                            float fCleanJerkResult1 = 0.0f;
                            float fCleanJerkResult2 = 0.0f;

                            if (objEx1.m_strCleanJerkResult.Length != 0)
                                fCleanJerkResult1 = float.Parse(objEx1.m_strCleanJerkResult);
                            if (objEx2.m_strCleanJerkResult.Length != 0)
                                fCleanJerkResult2 = float.Parse(objEx2.m_strCleanJerkResult);

                            if (!float.Equals(fCleanJerkResult1, fCleanJerkResult2))
                            {
                                if (fCleanJerkResult1 > fCleanJerkResult2)
                                    return 1;
                                if (fCleanJerkResult1 < fCleanJerkResult2)
                                    return -1;
                            }
                        }
                        #endregion
                        //崔凯：最好成绩的试举次数，次数少的排名靠前
                        int resultTimes1 = objEx1.m_nResultTimes;
                        int resultTimes2 = objEx2.m_nResultTimes;
                        if (resultTimes1 != resultTimes2)
                        {
                            if (resultTimes1 > resultTimes2)
                                return 1;
                            if (resultTimes1 < resultTimes2)
                                return -1;
                        }
                        else
                        {//崔凯：最好成绩的试举次数也相等,判断上一次试举重量

                            float fLastAttempt1 = 0.0f;
                            float fLastAttempt2 = 0.0f;
                            //if (resultTimes1 > 1 && objEx1.m_strLastAttempt.Length == objEx2.m_strLastAttempt.Length)
                            if (resultTimes1 > 1)
                            {
                                if (objEx1.m_strLastAttempt.Length != 0)
                                    fLastAttempt1 = float.Parse(objEx1.m_strLastAttempt);
                                if (objEx2.m_strLastAttempt.Length != 0)
                                    fLastAttempt2 = float.Parse(objEx2.m_strLastAttempt);
                            }
                            if (!float.Equals(fLastAttempt1, fLastAttempt2))
                            {
                                if (fLastAttempt1 > fLastAttempt2)
                                    return 1;
                                if (fLastAttempt1 < fLastAttempt2)
                                    return -1;
                            }
                            else
                            {//崔凯：最后判断签号，小的排名靠前
                                int LotNo1 = 0;
                                int LotNo2 = 0;
                                if (objEx1.m_nLotNo != 0)
                                    LotNo1 = objEx1.m_nLotNo;
                                if (objEx2.m_nLotNo != 0)
                                    LotNo2 = objEx2.m_nLotNo;

                                if (LotNo1 > LotNo2)
                                    return 1;
                                if (LotNo1 <= LotNo2)
                                    return -1;
                            }
                        }
                        #region Comment FinishOder and LightOrder
                        //if (nFinishOrder1 > nFinishOrder2)
                        //    return 1;
                        //if (nFinishOrder1 < nFinishOrder2)
                        //    return -1;

                        //if (nLightOrder1 > nLightOrder2)
                        //    return 1;
                        //else if (nLightOrder1 < nLightOrder2)
                        //    return -1;
                        #endregion
                    }
                }
                return 0;
            }

            public static IComparer Sort()
            { return (IComparer)new ComparerEx(); }
        }

        private int CalculationAttempt(ObjectEx objEx)
        {
            string str1stAttempt = objEx.m_str1stAttempt;
            string str2ndAttempt = objEx.m_str2ndAttempt;
            string str3rdAttempt = objEx.m_str3rdAttempt;

            string str1stRes = objEx.m_str1stRes;
            string str2ndRes = objEx.m_str2ndRes;
            string str3rdRes = objEx.m_str3rdRes;

            int nAttemptIdx = objEx.m_nAttemptIdx;
            string strAttempt = "";
            float fAttempt = -1.0f;
            if (str1stAttempt.Length != 0 && str2ndAttempt.Length != 0 && str3rdAttempt.Length != 0 &&
                str1stRes.Length != 0 && str2ndRes.Length != 0 && str3rdRes.Length != 0)
            {
                //已经试举完成
                nAttemptIdx = 10000;
                strAttempt = "10000";
                fAttempt = 10000.0f;
            }
            else if (str1stAttempt.Length != 0 || str2ndAttempt.Length != 0 || str3rdAttempt.Length != 0)
            {
                //nAttemptIdx = 9999;
                nAttemptIdx = 1;
                fAttempt = 9999.0f;
                if (str1stAttempt.Length != 0 && str1stRes == "")
                {
                    fAttempt = Math.Min(fAttempt, float.Parse(str1stAttempt));
                }
                else if (str1stAttempt.Length != 0 && str1stRes.Length != 0)
                {
                    nAttemptIdx = 2;
                    if (str2ndAttempt.Length != 0 && str2ndRes == "")
                    {
                        fAttempt = Math.Min(fAttempt, float.Parse(str2ndAttempt));
                    }
                    else if (str2ndAttempt.Length != 0 && str2ndRes.Length != 0)
                    {
                        nAttemptIdx = 3;
                        if (str3rdAttempt.Length != 0 && str3rdRes == "")
                        {
                            fAttempt = Math.Min(fAttempt, float.Parse(str3rdAttempt));
                        }
                    }
                }

                if (float.Equals(fAttempt, 9999.0f))
                {
                    //完成部分试举，未选择下一次重量
                    //nAttemptIdx = 1;
                    strAttempt = "8888";
                    fAttempt = 0.0f;
                }
                else//要了重量按顺序进行
                    strAttempt = fAttempt.ToString("f1");
                //string.Format("{0:F}", nAttempt);
            }
            else if (str1stAttempt.Length == 0 && str2ndAttempt.Length == 0 && str3rdAttempt.Length == 0 &&
                str1stRes.Length == 0 && str2ndRes.Length == 0 && str3rdRes.Length == 0)
            {
                //还没有要任何重量
                nAttemptIdx = 1;
                strAttempt = "-1";
                fAttempt = -1.0f;
            }

            objEx.m_nAttemptIdx = nAttemptIdx;
            objEx.m_strAttempt = strAttempt;

            return 1;
        }

        private int CalculationLightOrder(ArrayList aryObjectEx)
        {
            ArrayList aryTmp = aryObjectEx;
            for (int t = 0; t < aryTmp.Count - 1; t++)
            {
                for (int j = aryTmp.Count - 1; j > t; j--)
                {
                    ObjectEx tmpA = (ObjectEx)aryTmp[j - 1];
                    ObjectEx tmpB = (ObjectEx)aryTmp[j];
                    if (IsExChange(tmpA, tmpB))
                    {
                        aryTmp[j] = tmpA;
                        aryTmp[j - 1] = tmpB;
                    }
                }
            }

            for (int n = 0; n < aryTmp.Count; n++)
            {
                ObjectEx curObj = (ObjectEx)aryTmp[n];
                foreach (ObjectEx obj in aryObjectEx)
                {
                    //if (obj.m_strLightOrder.Length != 0)
                    //continue;
                    if (obj.m_strAttempt.Length != 0 && obj.m_strRegisterID == curObj.m_strRegisterID)
                    {
                        obj.m_strLightOrder = (n + 1).ToString();
                        break;
                    }
                }
            }

            foreach (ObjectEx obj in aryObjectEx)
            {
                float fAttempt = 0.0f;
                bool isValid = true;
                if (obj.m_strAttempt.Length != 0)
                    isValid = float.TryParse(obj.m_strAttempt, out fAttempt);

                if (obj.m_strLightOrder.Length != 0 && obj.m_strAttempt.Length != 0)
                {
                    if (float.Equals(fAttempt, 10000.0f) || float.Equals(fAttempt, 8888.0f)
                        || obj.m_strAttempt == "-1" || obj.m_strAttempt == "0")
                        obj.m_strLightOrder = "";
                }
                else
                    obj.m_strLightOrder = "";
                if (obj.m_strIRM.Length > 0)
                    obj.m_strLightOrder = "";
            }

            return 1;
        }

        private bool IsExChange(ObjectEx objA, ObjectEx objB)
        {
            float fAttemptA = 0.0f;
            if (objA.m_strAttempt.Length != 0)
                float.TryParse(objA.m_strAttempt, out fAttemptA);
            float fAttemptB = 0.0f;
            if (objB.m_strAttempt.Length != 0)
                float.TryParse(objB.m_strAttempt, out fAttemptB);

            if (objA.m_strAttempt.Length == 0)
                return true;
            else if (objB.m_strAttempt.Length == 0)
                return false;

            if (objA.m_strAttempt.Length != 0 && objA.m_strAttempt == "-1")
                return true;
            else if (objB.m_strAttempt.Length != 0 && objB.m_strAttempt == "-1")
                return false;

            if (objA.m_strIRM.Length > 0)
                return true;
            else if (objB.m_strIRM.Length > 0)
                return false;

            if (float.Equals(fAttemptA, fAttemptB))
            {//==
                if (objB.m_nAttemptIdx < objA.m_nAttemptIdx)
                {
                    return true;
                }
                else if (objB.m_nAttemptIdx == objA.m_nAttemptIdx)
                {
                    if (objB.m_nAttemptIdx == 1 && objB.m_nLotNo < objA.m_nLotNo)
                        return true;
                    else if (objB.m_nAttemptIdx == 2)
                    {
                        float f1stAttemptA = 0.0f;
                        if (objA.m_str1stAttempt.Length != 0)
                            float.TryParse(objA.m_str1stAttempt, out f1stAttemptA);
                        float f1stAttemptB = 0.0f;
                        if (objB.m_str1stAttempt.Length != 0)
                            float.TryParse(objB.m_str1stAttempt, out f1stAttemptB);

                        //==
                        if (float.Equals(f1stAttemptA, f1stAttemptB) && objB.m_nLotNo < objA.m_nLotNo)
                            return true;

                        if (f1stAttemptB < f1stAttemptA)
                            return true;
                    }
                    else if (objB.m_nAttemptIdx == 3)
                    {
                        float f1stAttemptA = 0.0f;
                        if (objA.m_str1stAttempt.Length != 0)
                            float.TryParse(objA.m_str1stAttempt, out f1stAttemptA);
                        float f1stAttemptB = 0.0f;
                        if (objB.m_str1stAttempt.Length != 0)
                            float.TryParse(objB.m_str1stAttempt, out f1stAttemptB);

                        float f2ndAttemptA = 0.0f;
                        if (objA.m_str2ndAttempt.Length != 0)
                            float.TryParse(objA.m_str2ndAttempt, out f2ndAttemptA);
                        float f2ndAttemptB = 0.0f;
                        if (objB.m_str2ndAttempt.Length != 0)
                            float.TryParse(objB.m_str2ndAttempt, out f2ndAttemptB);

                        //==
                        if (float.Equals(f2ndAttemptA, f2ndAttemptB))
                        {
                            //==
                            if (float.Equals(f1stAttemptA, f1stAttemptB) && objB.m_nLotNo < objA.m_nLotNo)
                                return true;

                            if (f1stAttemptB < f1stAttemptA)
                                return true;
                        }

                        if (f2ndAttemptB < f2ndAttemptA)
                            return true;
                    }
                }
            }

            if (fAttemptB < fAttemptA)
                return true;

            return false;
        }

        /// 崔凯：设置运动员比赛状态：3等待试举或完成，0上一个试举运动员；1当前运动员；2下一个运动员；20为前后同一人
        private int CalculationStatus(ArrayList aryObjectEx, bool IsFinishedAttempt)
        {
            foreach (ObjectEx obj in aryObjectEx)
            {
                string strComPos = obj.m_strComPos;
                string strLightOrder = obj.m_strLightOrder;
                string strStatus = obj.m_strStatus;
                if (IsFinishedAttempt)
                {
                    if (strStatus == "0" || strStatus == "20" || strStatus == "10")
                    {//Last
                        strStatus = "3";
                        obj.m_strStatus = strStatus;
                    }
                    if (strStatus == "10")
                    {//Current to Last
                        strStatus = "0";
                        obj.m_strStatus = strStatus;
                    }
                }
                if (strStatus != "1" && strStatus != "4" && strStatus != "0" && strStatus != "10" && strStatus != "20")
                {//Back Waiting
                    strStatus = "3";
                    obj.m_strStatus = strStatus;
                }
                if (strStatus == "1" && strLightOrder != "1")
                {//Last
                    strStatus = "3";
                    obj.m_strStatus = strStatus;
                }
                if (strStatus == "10" && strLightOrder != "1")
                {//Last
                    strStatus = "0";
                    obj.m_strStatus = strStatus;
                }
                if (strStatus == "20" && strLightOrder != "2")
                {//Last
                    strStatus = "0";
                    obj.m_strStatus = strStatus;
                }
                if (strStatus == "4")
                {//Last
                    strStatus = "0";
                    obj.m_strStatus = strStatus;
                }
                if (strLightOrder == "1")
                {//Current
                    if (strStatus == "0" || strStatus == "20" || strStatus == "10")
                        strStatus = "10";
                    else strStatus = "1";
                    //strStatus = "1";
                    obj.m_strStatus = strStatus;
                }
                if (strLightOrder == "2")
                {//Next
                    if (strStatus == "0" || strStatus == "20")
                        strStatus = "20";
                    else strStatus = "2";
                    obj.m_strStatus = strStatus;
                }
            }

            return 1;
        }

        /// 崔凯：设置运动员比赛状态：3等待试举或完成，0上一个试举运动员；1当前运动员；2下一个运动员；20为前后同一人
        private int CalculationStatusForInterface(ArrayList aryObjectEx)
        {
            foreach (ObjectEx obj in aryObjectEx)
            {
                string strComPos = obj.m_strComPos;
                string strLightOrder = obj.m_strLightOrder;
                string strStatus = obj.m_strStatus;

                //Last
                if (strStatus.Contains("0") && strLightOrder == "1")
                    obj.m_strStatus = "10";
                else if (strStatus.Contains("0") && strLightOrder == "2")
                    obj.m_strStatus = "20";
                else if (strStatus.Contains("0") && strLightOrder != "1" && strLightOrder != "2")
                    obj.m_strStatus = "0";
                //Current
                else if (!strStatus.Contains("0") && strLightOrder == "1")
                    obj.m_strStatus = "1";
                //Next
                else if (!strStatus.Contains("0") && strLightOrder == "2")
                    obj.m_strStatus = "2";
                //Others
                else
                    obj.m_strStatus = "3";
            }

            return 1;
        }

        private int CalculationLight(string strLight)
        {
            if (strLight == "111" || strLight == "110" || strLight == "101" || strLight == "011")
                return 1;
            if (strLight == "000" || strLight == "001" || strLight == "010" || strLight == "100")
                return 0;
            return -1;
        }

        private int CalculationResult(ObjectEx objEx)
        {
            string str1stAttempt = objEx.m_str1stAttempt;
            string str2ndAttempt = objEx.m_str2ndAttempt;
            string str3rdAttempt = objEx.m_str3rdAttempt;

            string str1stRes = objEx.m_str1stRes;
            string str2ndRes = objEx.m_str2ndRes;
            string str3rdRes = objEx.m_str3rdRes;

            int nResultTimes = objEx.m_nResultTimes;
            string strLastAttempt = objEx.m_strLastAttempt;

            string strResult = "";
            float fResult = 0;

            if ((str1stAttempt.Length != 0 && CalculationLight(str1stRes) == 1) ||
                (str2ndAttempt.Length != 0 && CalculationLight(str2ndRes) == 1) ||
                (str3rdAttempt.Length != 0 && CalculationLight(str3rdRes) == 1))
            {
                if (str1stAttempt.Length != 0 && CalculationLight(str1stRes) == 1)
                {
                    fResult = Math.Max(fResult, float.Parse(str1stAttempt));
                    nResultTimes = 1;
                }
                if (str2ndAttempt.Length != 0 && CalculationLight(str2ndRes) == 1)
                {
                    strLastAttempt = str1stAttempt;
                    fResult = Math.Max(fResult, float.Parse(str2ndAttempt));
                    nResultTimes = 2;
                }
                if (str3rdAttempt.Length != 0 && CalculationLight(str3rdRes) == 1)
                {
                    strLastAttempt = str2ndAttempt + str1stAttempt;
                    fResult = Math.Max(fResult, float.Parse(str3rdAttempt));
                    nResultTimes = 3;
                }
                strResult = fResult.ToString().Contains(".") ? string.Format("{0:f1}", fResult) : fResult.ToString();
            }

            string strIRM = objEx.m_strIRM;

            if (strIRM.Length != 0)
                objEx.m_strResult = "";
            else
                objEx.m_strResult = strResult;
            objEx.m_strLastAttempt = strLastAttempt;
            objEx.m_nResultTimes = nResultTimes;

            return 1;
        }

        private int CalculationFinishOrder(ArrayList aryObjectEx)
        {
            int[] arFinishOrder = new int[aryObjectEx.Count];
            int i = 0;

            foreach (ObjectEx obj in aryObjectEx)
            {
                int nValue = 0;

                if (obj.m_strFinishOrder.Length == 0)
                    nValue = 50001 + i;
                else
                    nValue = 10001 + int.Parse(obj.m_strFinishOrder);

                obj.m_strFinishOrder = nValue.ToString();
                arFinishOrder[i++] = nValue;
            }
            Array.Sort(arFinishOrder);

            for (int n = 0; n < arFinishOrder.Length; n++)
            {
                foreach (ObjectEx obj in aryObjectEx)
                {
                    if (obj.m_strFinishOrder.Length != 0 && int.Parse(obj.m_strFinishOrder) < 10000)
                        continue;

                    if (obj.m_strFinishOrder.Length != 0 && int.Parse(obj.m_strFinishOrder) == arFinishOrder[n]
                        && int.Parse(obj.m_strFinishOrder) < 50000)
                    {
                        obj.m_strFinishOrder = (n + 1).ToString();
                        break;
                    }
                }
            }

            foreach (ObjectEx obj in aryObjectEx)
            {
                if (obj.m_strFinishOrder.Length != 0 && int.Parse(obj.m_strFinishOrder) > 50000)
                    obj.m_strFinishOrder = "";
            }

            return 1;
        }

        public string CalculationTotalIRM(string strSnatchIRM, string strCleanJerkIRM)
        {
            string strTotalIRM = "";

            if (strSnatchIRM.Length == 0)
            {
                strTotalIRM = strCleanJerkIRM;
            }
            else
            {
                if (strSnatchIRM == "DSQ")
                {
                    strTotalIRM = "DSQ";
                }
                else if (strSnatchIRM == "DNS")
                {
                    if (strCleanJerkIRM == "DSQ")
                        strTotalIRM = "DSQ";
                    else if (strCleanJerkIRM == "DNS")
                        strTotalIRM = "DNS";
                    else if (strCleanJerkIRM == "DNF")
                        strTotalIRM = "DNF";
                }
                else if (strSnatchIRM == "DNF")
                {
                    if (strCleanJerkIRM == "DSQ")
                        strTotalIRM = "DSQ";
                    else if (strCleanJerkIRM == "DNS")
                        strTotalIRM = "DNF";
                    else if (strCleanJerkIRM == "DNF")
                        strTotalIRM = "DNF";
                }
            }

            return strTotalIRM;
        }

        private int CalculationTotalResult(ObjectEx objEx)
        {
            string strSnatchResult = objEx.m_strSnatchResult;
            string strSnatchIRM = objEx.m_strSnatchIRM;

            string strCleanJerkResult = objEx.m_strCleanJerkResult;
            string strCleanJerkIRM = objEx.m_strCleanJerkIRM;

            if (strSnatchIRM == "DSQ" || strCleanJerkIRM == "DSQ")
            {//有任何一项比赛被取消资格
                objEx.m_strTotalIRM = "DSQ";
                objEx.m_strTotalResult = "";
            }
            else
            {
                if (strSnatchIRM.Length != 0)
                {//抓举有异常情况
                    //不计总成绩，并且不能参加挺举比赛
                    objEx.m_strTotalIRM = strSnatchIRM;
                    objEx.m_strTotalResult = ""; 
                }
                else
                {//抓举正常
                    if (strCleanJerkIRM.Length != 0)
                    {//挺举有异常情况:取抓举成绩
                        objEx.m_strTotalIRM = strCleanJerkIRM;
                        objEx.m_strTotalResult = ""; 
                    }
                    else
                    {//挺举正常:取两项总成绩 
                        if (strSnatchResult.Length == 0 || strCleanJerkResult.Length == 0)
                        {
                            objEx.m_strTotalIRM = "";
                            objEx.m_strTotalResult = "";
                        }
                        else
                        {
                            objEx.m_strTotalIRM = "";
                            float fTotalResult = 0;
                            if (strSnatchResult.Length != 0 || strCleanJerkResult.Length != 0)
                            {
                                if (strSnatchResult.Length != 0)
                                    fTotalResult += float.Parse(strSnatchResult);
                                if (strCleanJerkResult.Length != 0)
                                    fTotalResult += float.Parse(strCleanJerkResult);
                                objEx.m_strTotalResult = fTotalResult.ToString().Contains(".") ? string.Format("{0:f1}", fTotalResult) : fTotalResult.ToString();
                            }
                        }
                    }
                }
            }

            return 1;
        }

        private int CalculationRankAndDisplayPosition(ArrayList aryObjectEx)
        {
            int nDisplayPosition = 1;
            int nRank = 1;
            float fLastResult = 0.0f;
            float fLastBodyWeight = 0.0f;
            int nLastFinishOrder = 0;
            float fMinResult = 0.0f;
            foreach (ObjectEx obj in aryObjectEx)
            {
                if (nDisplayPosition == 1 && obj.m_strIRM.Length == 0 && obj.m_strResult.Length != 0)
                    fMinResult = float.Parse(obj.m_strResult);

                if (obj.m_strIRM.Length != 0)
                {
                    obj.m_strRank = "";
                }
                else if (obj.m_strResult.Length == 0)
                {
                    obj.m_strRank = "";
                }
                else if (float.Equals(float.Parse(obj.m_strResult), fLastResult)
                    && fLastBodyWeight == 0.0 && obj.m_strBodyWeight.Length == 0
                    && nLastFinishOrder == 0 && obj.m_strFinishOrder.Length == 0)
                {
                    obj.m_strRank = nRank.ToString();
                    fLastResult = float.Parse(obj.m_strResult);
                    if (obj.m_strBodyWeight.Length == 0)
                        fLastBodyWeight = 0.0f;
                    else
                        fLastBodyWeight = float.Parse(obj.m_strBodyWeight);
                    if (obj.m_strFinishOrder.Length == 0)
                        nLastFinishOrder = 0;
                    else
                        nLastFinishOrder = int.Parse(obj.m_strFinishOrder);
                }
                else if (float.Equals(float.Parse(obj.m_strResult), fLastResult)
                    && obj.m_strBodyWeight.Length != 0 && float.Equals(float.Parse(obj.m_strBodyWeight), fLastBodyWeight)
                    && obj.m_strFinishOrder.Length != 0 && int.Parse(obj.m_strFinishOrder) == nLastFinishOrder)
                {
                    obj.m_strRank = nRank.ToString();
                    fLastResult = float.Parse(obj.m_strResult);
                    if (obj.m_strBodyWeight.Length == 0)
                        fLastBodyWeight = 0.0f;
                    else
                        fLastBodyWeight = float.Parse(obj.m_strBodyWeight);
                    if (obj.m_strFinishOrder.Length == 0)
                        nLastFinishOrder = 0;
                    else
                        nLastFinishOrder = int.Parse(obj.m_strFinishOrder);
                }
                else
                {
                    if (nDisplayPosition != 1)
                        nRank++;
                    obj.m_strRank = nRank.ToString();
                    fLastResult = float.Parse(obj.m_strResult);
                    if (obj.m_strBodyWeight.Length == 0)
                        fLastBodyWeight = 0.0f;
                    else
                        fLastBodyWeight = float.Parse(obj.m_strBodyWeight);
                    if (obj.m_strFinishOrder.Length == 0)
                        nLastFinishOrder = 0;
                    else
                        nLastFinishOrder = int.Parse(obj.m_strFinishOrder);
                }

                if (obj.m_strRank.Length == 0 || obj.m_strIRM.Length != 0)
                {
                    obj.m_strDisplayPosition = "";
                }
                else
                {
                    obj.m_strDisplayPosition = nDisplayPosition.ToString();
                    nDisplayPosition++;
                }
            }

            return 1;
        }

        #endregion

        #region 数据交互函数
        //数据交互函数
        private int DataExchangeLightOrder()
        {
            //获取界面数据
            ArrayList aryObjectEx = null;
            GetDataGridViewData(this.dgv_List, out aryObjectEx);

            //处理Attepmt
            foreach (ObjectEx obj in aryObjectEx)
                CalculationAttempt(obj);

            //处理LightOrder逻辑
            CalculationLightOrder(aryObjectEx);

            //更新数据库
            foreach (ObjectEx obj in aryObjectEx)
            {
                string strComPos = obj.m_strRegisterID;
                string strLightOrder = obj.m_strLightOrder;
                bool bReturn = false;
                if (strComPos.Length > 0)
                    bReturn = GVWL.g_ManageDB.UpdatePlayerLightOrder(m_nCurMatchID, int.Parse(strComPos), strLightOrder);
            }

            //更新界面显示
            foreach (ObjectEx obj in aryObjectEx)
            {
                int RowIndex = obj.m_nRowIdx;
                string strLightOrder = obj.m_strLightOrder;
                this.dgv_List.Rows[RowIndex].Cells["LightOrder"].Value = strLightOrder;
            }

            return 1;
        }

        private void DataExchangeStatus(bool IsFinishedAttempt, bool bAuto)
        {
            //获取界面数据
            ArrayList aryObjectEx = null;
            GetDataGridViewData(this.dgv_List, out aryObjectEx);

            //处理Status逻辑
            if (bAuto)
                CalculationStatus(aryObjectEx, IsFinishedAttempt);

            //更新数据库
            foreach (ObjectEx obj in aryObjectEx)
            {
                string strComPos = obj.m_strRegisterID;
                string strStatus = obj.m_strStatus;
                bool bReturn = GVWL.g_ManageDB.UpdatePlayerStatus(m_nCurMatchID, int.Parse(strComPos), strStatus);
            }

            //更新界面显示
            foreach (ObjectEx obj in aryObjectEx)
            {
                int nRowIdx = obj.m_nRowIdx;
                string strStatus = obj.m_strStatus;
                this.dgv_List.Rows[nRowIdx].Cells["Status"].Value = strStatus;
                if (strStatus.Contains("0"))
                    this.dgv_List.Rows[nRowIdx].DefaultCellStyle.BackColor = Color.BurlyWood;
                else
                    this.dgv_List.Rows[nRowIdx].DefaultCellStyle.BackColor = Color.White;
            }
        }

        private void DataExchangeStatusForInterface()
        {
            //获取界面数据
            ArrayList aryObjectEx = null;
            GetDataGridViewData(this.dgv_List, out aryObjectEx);

            //处理Status逻辑 
            CalculationStatusForInterface(aryObjectEx);

            //更新数据库
            foreach (ObjectEx obj in aryObjectEx)
            {
                string strComPos = obj.m_strRegisterID;
                string strStatus = obj.m_strStatus;
                bool bReturn = GVWL.g_ManageDB.UpdatePlayerStatus(m_nCurMatchID, int.Parse(strComPos), strStatus);
            }

            //更新界面显示
            foreach (ObjectEx obj in aryObjectEx)
            {
                int nRowIdx = obj.m_nRowIdx;
                string strStatus = obj.m_strStatus;
                this.dgv_List.Rows[nRowIdx].Cells["Status"].Value = strStatus;
                if (strStatus.Contains("0"))
                    this.dgv_List.Rows[nRowIdx].DefaultCellStyle.BackColor = Color.BurlyWood;
                else
                    this.dgv_List.Rows[nRowIdx].DefaultCellStyle.BackColor = Color.White;
            }
        }

        private int DataExchangeAttempt(int RowIndex)
        {
            ObjectEx objEx = null;
            GetDataGridViewData(this.dgv_List, RowIndex, out objEx);

            string strComPos = objEx.m_strComPos;
            string str1stAttempt = objEx.m_str1stAttempt;
            string str2ndAttempt = objEx.m_str2ndAttempt;
            string str3rdAttempt = objEx.m_str3rdAttempt;

            bool bReturn = GVWL.g_ManageDB.UpdateMatchResult(m_nCurMatchID, int.Parse(strComPos),
                str1stAttempt, "-1", str2ndAttempt, "-1", str3rdAttempt, "-1",
                "-1", "-1", "-1", "-1");

            return 1;
        }

        private int DataExchangeResult(int RowIndex)
        {
            try
            {
                DataGridView dgv = this.dgv_List;
                ObjectEx objEx = null;
                GetDataGridViewData(dgv, RowIndex, out objEx);
                int tmpResultTimes = objEx.m_nResultTimes;
                string tmpLastAttempt = objEx.m_strLastAttempt;
                //处理Result
                CalculationResult(objEx);

                string strResult = objEx.m_strResult;
                string strIRM = objEx.m_strIRM;

                if (m_strMatchCode == "01")
                {
                    objEx.m_strSnatchResult = strResult;
                    objEx.m_strSnatchIRM = strIRM;
                }
                else if (m_strMatchCode == "02")
                {
                    objEx.m_strCleanJerkResult = strResult;
                    objEx.m_strCleanJerkIRM = strIRM;
                }
                //处理TotalResult
                CalculationTotalResult(objEx);

                string strSnatchResult = objEx.m_strSnatchResult;
                string strSnatchIRM = objEx.m_strSnatchIRM;
                string strCleanJerkResult = objEx.m_strCleanJerkResult;
                string strCleanJerkIRM = objEx.m_strCleanJerkIRM;
                string strTotalResult = objEx.m_strTotalResult;
                string strTotalIRM = objEx.m_strTotalIRM;
                string strResultTimes = objEx.m_nResultTimes.ToString();
                string strLastAttempt = objEx.m_strLastAttempt.ToString();

                //更新界面显示
                dgv.Rows[RowIndex].Cells["Result"].Value = strResult;
                dgv.Rows[RowIndex].Cells["SnatchResult"].Value = strSnatchResult;
                dgv.Rows[RowIndex].Cells["SnatchIRM"].Value = strSnatchIRM;
                dgv.Rows[RowIndex].Cells["CleanJerkResult"].Value = strCleanJerkResult;
                dgv.Rows[RowIndex].Cells["CleanJerkIRM"].Value = strCleanJerkIRM;
                dgv.Rows[RowIndex].Cells["TotalResult"].Value = strTotalResult;
                dgv.Rows[RowIndex].Cells["TotalIRM"].Value = strTotalIRM;
                dgv.Rows[RowIndex].Cells["ResultTimes"].Value = strResultTimes;
                dgv.Rows[RowIndex].Cells["LastAttempt"].Value = strLastAttempt;


                //更新总成绩表格显示 
                DataGridView dgvTotal = this.dgv_Total;
                ArrayList aryObjectEx = null;
                GetTotalDataGridViewData(this.dgv_Total, out aryObjectEx);
                foreach (ObjectEx objTotal in aryObjectEx)
                {
                    if (objTotal.m_strRegisterID == objEx.m_strRegisterID)
                    {
                        RowIndex = objTotal.m_nRowIdx;
                        dgvTotal.Rows[RowIndex].Cells["SnatchResult"].Value = strSnatchResult;
                        dgvTotal.Rows[RowIndex].Cells["CleanJerkResult"].Value = strCleanJerkResult;
                        dgvTotal.Rows[RowIndex].Cells["TotalResult"].Value = strTotalResult;
                        dgvTotal.Rows[RowIndex].Cells["TotalIRM"].Value = strTotalIRM;
                        int totalRt = objTotal.m_nResultTimes - (tmpResultTimes - objEx.m_nResultTimes);
                        string totalLastAtt = objTotal.m_strLastAttempt;
                        if (totalLastAtt != "" && strLastAttempt != "" && tmpLastAttempt != "" && totalLastAtt.LastIndexOf(tmpLastAttempt) >= 0)
                            totalLastAtt = totalLastAtt.Replace(tmpLastAttempt, strLastAttempt);
                        else if (strLastAttempt != "" && tmpLastAttempt == "")
                            totalLastAtt = strLastAttempt + totalLastAtt;

                        dgvTotal.Rows[RowIndex].Cells["ResultTimes"].Value = totalRt.ToString();
                        dgvTotal.Rows[RowIndex].Cells["LastAttempt"].Value = totalLastAtt;
                        if (m_strMatchCode == "01")
                        { 
                            dgvTotal.Rows[RowIndex].Cells["SnatchResultTimes"].Value = strResultTimes;
                            dgvTotal.Rows[RowIndex].Cells["SnatchLastAttempt"].Value = strLastAttempt;
                        }

                        break;
                    }
                }
            }
            catch (Exception ex) { DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message); }
            return 1;
        }

        private int DataExchangeRecord(int RowIndex)
        {
            System.Data.DataTable dt = this.m_dtRecord;
            ObjectEx objEx = null;

            //获取界面数据
            GetDataGridViewData(this.dgv_List, RowIndex, out objEx);
            //判断是否破单项纪录
            if (dt.Rows.Count == 0)
                return 1;
            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                if (m_strMatchCode == "01")
                {//抓举
                    float fOldSnatchResult = 0;
                    string strOldSnatchResult = "";
                    if (dt.Rows[nRow]["SnatchResult"] != DBNull.Value)
                        strOldSnatchResult = dt.Rows[nRow]["SnatchResult"].ToString();
                    if (strOldSnatchResult.Length != 0)
                        fOldSnatchResult = float.Parse(strOldSnatchResult);
                    int RecordTypeID = 0;
                    if (dt.Rows[nRow]["RecordTypeID"] != DBNull.Value)
                        RecordTypeID = int.Parse(dt.Rows[nRow]["RecordTypeID"].ToString());
                    string RecordTypeCode = string.Empty;
                    if (dt.Rows[nRow]["Record"] != DBNull.Value)
                        RecordTypeCode = dt.Rows[nRow]["Record"].ToString();
                    if (objEx.m_strSnatchResult.Length != 0 && !(float.Parse(objEx.m_strSnatchResult) < fOldSnatchResult))
                    {
                        if ((RecordTypeCode == "WRY" && ((objEx.m_nAge < 13 && objEx.m_nAge > 0) || objEx.m_nAge > 17))
                            || (RecordTypeCode == "WRJ" && ((objEx.m_nAge < 15 && objEx.m_nAge > 0) || objEx.m_nAge > 20)))
                            continue;
                        //更新数据库
                        string strComPos = objEx.m_strComPos;
                        string strResult = objEx.m_strSnatchResult;
                        int isEquals = float.Equals(float.Parse(objEx.m_strSnatchResult), fOldSnatchResult) ? 1 : 0;
                        bool bReturn = GVWL.g_ManageDB.UpdateRecord(m_nCurMatchID, int.Parse(strComPos),
                            "1", strResult, RecordTypeID, isEquals);

                        dt.Rows[nRow]["SnatchResult"] = objEx.m_strSnatchResult;
                        if (objEx.m_strRecord.Length == 0)
                            objEx.m_strRecord = dt.Rows[nRow]["Record"].ToString();
                        else
                            objEx.m_strRecord += ";" + dt.Rows[nRow]["Record"].ToString();
                        //GVWL.g_WLPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatistic, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                    }
                }
                else if (m_strMatchCode == "02")
                {//挺举
                    float nOldCleanJerkResult = 0;
                    string strOldCleanJerkResult = "";
                    if (dt.Rows[nRow]["CleanJerkResult"] != DBNull.Value)
                        strOldCleanJerkResult = dt.Rows[nRow]["CleanJerkResult"].ToString();
                    if (strOldCleanJerkResult.Length != 0)
                        nOldCleanJerkResult = float.Parse(strOldCleanJerkResult);
                    int RecordTypeID = 0;
                    if (dt.Rows[nRow]["RecordTypeID"] != DBNull.Value)
                        RecordTypeID = int.Parse(dt.Rows[nRow]["RecordTypeID"].ToString());
                    string RecordTypeCode = string.Empty;
                    if (dt.Rows[nRow]["Record"] != DBNull.Value)
                        RecordTypeCode = dt.Rows[nRow]["Record"].ToString();
                    if (objEx.m_strCleanJerkResult.Length != 0 &&
                        !(float.Parse(objEx.m_strCleanJerkResult) < nOldCleanJerkResult))
                    {
                        if ((RecordTypeCode == "WRY" && ((objEx.m_nAge < 13 && objEx.m_nAge > 0) || objEx.m_nAge > 17))
                           || (RecordTypeCode == "WRJ" && ((objEx.m_nAge < 15 && objEx.m_nAge > 0) || objEx.m_nAge > 20)))
                            continue;
                        //更新数据库
                        //更新数据库
                        string strComPos = objEx.m_strComPos;
                        string strResult = objEx.m_strCleanJerkResult;
                        int isEquals = float.Equals(float.Parse(objEx.m_strCleanJerkResult), nOldCleanJerkResult) ? 1 : 0;
                        bool bReturn = GVWL.g_ManageDB.UpdateRecord(m_nCurMatchID, int.Parse(strComPos),
                            "2", strResult, RecordTypeID, isEquals);

                        dt.Rows[nRow]["CleanJerkResult"] = objEx.m_strCleanJerkResult;
                        if (objEx.m_strRecord.Length == 0)
                            objEx.m_strRecord = dt.Rows[nRow]["Record"].ToString();
                        else
                            objEx.m_strRecord += ";" + dt.Rows[nRow]["Record"].ToString();
                        //GVWL.g_WLPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatistic, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                    }
                }
            }
            //更新界面显示
            this.dgv_List.Rows[RowIndex].Cells["Record"].Value = objEx.m_strRecord;


            ArrayList aryObjectEx = null;
            GetTotalDataGridViewData(this.dgv_Total, out aryObjectEx);
            foreach (ObjectEx obj in aryObjectEx)
            {
                if (obj.m_strRegisterID == objEx.m_strRegisterID)
                {
                    RowIndex = obj.m_nRowIdx;
                    ObjectEx obj_Temp = new ObjectEx();
                    obj_Temp = objEx;
                    objEx = obj;
                    objEx.m_strComPos = obj_Temp.m_strComPos;
                    break;
                }
            }
            //判断是否破总成绩纪录
            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                float fOldTotalResult = 0;
                string strOldTotalResult = "";
                if (dt.Rows[nRow]["TotalResult"] != DBNull.Value)
                    strOldTotalResult = dt.Rows[nRow]["TotalResult"].ToString();
                if (strOldTotalResult.Length != 0)
                    fOldTotalResult = float.Parse(strOldTotalResult);
                int RecordTypeID = 0;
                if (dt.Rows[nRow]["RecordTypeID"] != DBNull.Value)
                    RecordTypeID = int.Parse(dt.Rows[nRow]["RecordTypeID"].ToString());
                string RecordTypeCode = string.Empty;
                if (dt.Rows[nRow]["Record"] != DBNull.Value)
                    RecordTypeCode = dt.Rows[nRow]["Record"].ToString();
                if (objEx.m_strTotalResult.Length != 0
                    && !(float.Parse(objEx.m_strTotalResult) < fOldTotalResult))
                {
                    if ((RecordTypeCode == "WRY" && ((objEx.m_nAge < 13 && objEx.m_nAge > 0) || objEx.m_nAge > 17))
                            || (RecordTypeCode == "WRJ" && ((objEx.m_nAge < 15 && objEx.m_nAge > 0) || objEx.m_nAge > 20)))
                        continue;
                    //更新数据库
                    //更新数据库
                    string strComPos = objEx.m_strComPos;
                    string strResult = objEx.m_strTotalResult;
                    int isEquals = float.Equals(float.Parse(objEx.m_strTotalResult), fOldTotalResult) ? 1 : 0;
                    bool bReturn = GVWL.g_ManageDB.UpdateRecord(m_nCurMatchID, int.Parse(strComPos),
                        "3", strResult, RecordTypeID, isEquals);

                    dt.Rows[nRow]["TotalResult"] = objEx.m_strTotalResult;
                    if (objEx.m_strRecord.Length == 0)
                        objEx.m_strRecord = dt.Rows[nRow]["Record"].ToString();
                    else
                        objEx.m_strRecord += ";" + dt.Rows[nRow]["Record"].ToString();
                    GVWL.g_WLPlugin.DataChangedNotify(OVRDataChangedType.emMatchStatistic, -1, -1, -1, m_nCurMatchID, m_nCurMatchID, null);
                }
            }
            //更新界面显示
            this.dgv_Total.Rows[RowIndex].Cells["Record"].Value = objEx.m_strRecord;
            this.m_dtRecord = GVWL.g_ManageDB.GetRecordList(m_nCurMatchID);
            return 1;
        }

        private void DataExchangeFinishOrder(int RowIndex)
        {
            //获取界面数据
            ObjectEx objEx = null;
            GetDataGridViewData(this.dgv_List, RowIndex, out objEx);

            ArrayList aryObjectEx = null;
            GetTotalDataGridViewData(this.dgv_Total, out aryObjectEx);

            //查找变化对象
            foreach (ObjectEx obj in aryObjectEx)
            {
                if (obj.m_strRegisterID == objEx.m_strRegisterID)
                {
                    obj.m_strFinishOrder = "";
                    if (objEx.m_str1stRes.Length != 0 && objEx.m_str2ndRes.Length != 0 && objEx.m_str3rdRes.Length != 0)
                    {
                        if (m_strMatchCode == "01" && objEx.m_strCleanJerkResult.Length != 0)
                            obj.m_strFinishOrder = "10000";

                        if (m_strMatchCode == "02" && objEx.m_strSnatchResult.Length != 0)
                            obj.m_strFinishOrder = "10000";
                    }
                    break;
                }
            }

            //处理FinishOrder逻辑
            CalculationFinishOrder(aryObjectEx);

            //更新数据库


            foreach (ObjectEx obj in aryObjectEx)
            {
                string strRegisterID = obj.m_strRegisterID;
                string strFinishOrder = obj.m_strFinishOrder;

                bool bReturn = GVWL.g_ManageDB.UpdatePlayerFinishOrder(m_nCurMatchID, int.Parse(strRegisterID), strFinishOrder);
            }

            //更新界面显示
            foreach (ObjectEx obj in aryObjectEx)
            {
                int nRowIdx = obj.m_nRowIdx;
                string strFinishOrder = obj.m_strFinishOrder;
                this.dgv_Total.Rows[nRowIdx].Cells["FinishOrder"].Value = strFinishOrder;
            }
        }

        private void DataExchangeMatchRank()
        {
            //获取界面数据
            ArrayList aryObjectEx = null;
            GetDataGridViewMatchResult(this.dgv_List, out aryObjectEx);

            //处理排序逻辑
            aryObjectEx.Sort(ComparerEx.Sort());
            CalculationRankAndDisplayPosition(aryObjectEx);

            //更新数据库
            foreach (ObjectEx obj in aryObjectEx)
            {
                string strComPos = obj.m_strComPos;
                bool bReturn = GVWL.g_ManageDB.UpdateMatchResult(m_nCurMatchID, int.Parse(strComPos),
                    "-1", "-1", "-1", "-1", "-1", "-1",
                    obj.m_strResult, obj.m_strRank, obj.m_strDisplayPosition, "-1");
            }

            //更新界面显示
            foreach (ObjectEx obj in aryObjectEx)
            {
                this.dgv_List.Rows[obj.m_nRowIdx].Cells["Rank"].Value = obj.m_strRank;
            }
        }

        private void DataExchangePhaseRank()
        {
            //获取界面数据
            ArrayList aryObjectEx = null;
            GetDataGridViewPhaseResult(this.dgv_Total, out aryObjectEx);

            //处理排序逻辑
            foreach (ObjectEx obj in aryObjectEx)
            {
                obj.m_strResult = obj.m_strTotalResult;
                obj.m_strIRM = obj.m_strTotalIRM;
            }
            aryObjectEx.Sort(ComparerEx.Sort());
            CalculationRankAndDisplayPosition(aryObjectEx);

            //更新数据库
            foreach (ObjectEx obj in aryObjectEx)
            {
                string strComPos = obj.m_strRegisterID;
                bool bReturn = GVWL.g_ManageDB.UpdatePhaseResult(m_nCurMatchID, int.Parse(strComPos),
                                   obj.m_strSnatchResult, obj.m_strCleanJerkResult, obj.m_strResult, obj.m_strRank, obj.m_strDisplayPosition, obj.m_strTotalIRM);
            }
        }

        private void DataExchangeEventRank()
        {
            //获取界面数据
            ArrayList aryObjectEx = null;
            this.GetTotalDataGridViewData(this.dgv_Total, out aryObjectEx);
            ArrayList aryObjectEx1 = null;
            this.GetTotalDataGridViewData(this.dgv_Total, out aryObjectEx1);
            ArrayList aryObjectEx2 = null;
            this.GetTotalDataGridViewData(this.dgv_Total, out aryObjectEx2);

            //处理总成绩排序逻辑
            foreach (ObjectEx obj in aryObjectEx)
            {
                obj.m_strResult = obj.m_strTotalResult;
                obj.m_strIRM = obj.m_strTotalIRM;
            }
            aryObjectEx.Sort(ComparerEx.Sort());
            CalculationRankAndDisplayPosition(aryObjectEx);

            //处理抓举排序逻辑
            foreach (ObjectEx objs in aryObjectEx1)
            {
                objs.m_strResult = objs.m_strSnatchResult;
                objs.m_strIRM = objs.m_strSnatchIRM; 
                objs.m_strLastAttempt = objs.m_strSnatchLastAttempt;
                objs.m_nResultTimes = objs.m_nSnatchResultTimes;
            }
            aryObjectEx1.Sort(ComparerEx.Sort());
            CalculationRankAndDisplayPosition(aryObjectEx1);

            //处理挺举排序逻辑
            foreach (ObjectEx objc in aryObjectEx2)
            {
                objc.m_strResult = objc.m_strCleanJerkResult;
                objc.m_strIRM = objc.m_strCleanJerkIRM;
            }
            aryObjectEx2.Sort(ComparerEx.Sort());
            CalculationRankAndDisplayPosition(aryObjectEx2);

            //更新数据库
            foreach (ObjectEx obj in aryObjectEx)
            {
                //处理抓举排序逻辑
                foreach (ObjectEx objs in aryObjectEx1)
                {
                    if (obj.m_strRegisterID == objs.m_strRegisterID)
                    {
                        obj.m_strSnatchRank = objs.m_strRank;
                        break;
                    }
                }
                //处理挺举排序逻辑
                foreach (ObjectEx objc in aryObjectEx2)
                {
                    if (obj.m_strRegisterID == objc.m_strRegisterID)
                    {
                        obj.m_strCleanJerkRank = objc.m_strRank;
                        break;
                    }
                }
                string strRegisterID = obj.m_strRegisterID;
                bool bReturn = GVWL.g_ManageDB.UpdateEventResult(m_nCurMatchID, int.Parse(strRegisterID),
                    obj.m_strSnatchResult, obj.m_strSnatchRank, obj.m_strCleanJerkResult, obj.m_strCleanJerkRank, obj.m_strResult, obj.m_strRank, obj.m_strDisplayPosition, obj.m_strIRM);
            }

            UpdateTotalDataGridView();
        }

        private int DataExchangeBodyWeight()
        {
            //获取界面数据
            ArrayList aryObjectEx = null;
            GetDataGridViewData(this.dgv_List, out aryObjectEx);

            //更新数据库
            foreach (ObjectEx obj in aryObjectEx)
            {
                string registerID = obj.m_strRegisterID;
                string strBodyWeight = obj.m_strBodyWeight;
                double decBodyWeight = 0.00;
                bool bReturn = false;
                if (double.TryParse(strBodyWeight, out decBodyWeight))
                {
                    strBodyWeight = string.Format("{0:f2}", decBodyWeight);
                    if (!string.IsNullOrEmpty(registerID))
                        bReturn = GVWL.g_ManageDB.UpdatePlayerBodyWeight(m_nCurMatchID, int.Parse(registerID), strBodyWeight, "-1", "-1");
                }
                //更新界面显示
                int RowIndex = obj.m_nRowIdx;
                if (!bReturn && this.dgv_List.Rows[RowIndex].Cells["Weight"].Tag != null)
                    strBodyWeight = this.dgv_List.Rows[RowIndex].Cells["Weight"].Tag.ToString();
                this.dgv_List.Rows[RowIndex].Cells["Weight"].Value = strBodyWeight;

                //更新总成绩表格显示
                DataGridView dgvTotal = this.dgv_Total;
                ArrayList aryTObjectEx = null;
                GetTotalDataGridViewData(this.dgv_Total, out aryTObjectEx);
                foreach (ObjectEx objTotal in aryTObjectEx)
                {
                    if (objTotal.m_strRegisterID == obj.m_strRegisterID)
                    {
                        int TRowIndex = objTotal.m_nRowIdx;
                        dgvTotal.Rows[TRowIndex].Cells["BodyWeight"].Value = strBodyWeight;
                        break;
                    }
                }
            }

            return 1;
        }

        private int DataExchangeWeighinTime()
        {
            //获取界面数据
            //string strTime = this.dti_WeighInTime.Value.ToShortTimeString();
            string strTime = string.Empty;
            //更新数据库
            bool bReturn = false;
            if (m_nCurMatchID > 0)
                bReturn = GVWL.g_ManageDB.UpdateMatchWeighinTime(m_nCurMatchID, strTime);

            return 1;
        }

        //数据交互函数
        private int DataExchangeDeleteInvalidLightOrder()
        {
            //获取界面数据
            ArrayList aryObjectEx = null;
            this.GetTotalDataGridViewData(this.dgv_Total, out aryObjectEx);

            //更新数据库
            foreach (ObjectEx obj in aryObjectEx)
            {
                string strComPos = obj.m_strRegisterID;
                int nIsContinue = obj.m_nIsContinue;
                if (nIsContinue == 1)
                {
                    GVWL.g_ManageDB.UpdatePlayerLightOrder(m_nCurMatchID, int.Parse(strComPos), "");
                    GVWL.g_ManageDB.UpdatePlayerStatus(m_nCurMatchID, int.Parse(strComPos), "3");
                }
            }

            return 1;
        }

        private int DataExchangeDeleteInvalidRecords(int RowIndex)
        {
            System.Data.DataTable dt = this.m_dtRecord;
            ObjectEx objEx = null;

            //获取界面数据
            GetDataGridViewData(this.dgv_List, RowIndex, out objEx);

            string strComPos = objEx.m_strComPos;

            System.Data.DataTable dtp = GVWL.g_ManageDB.GetPlayerRecords(m_nCurMatchID, int.Parse(strComPos));
            for (int nRow = 0; nRow < dtp.Rows.Count; nRow++)
            {
                string recordValue = DTHelpFunctions.GetStringByFieldAndRowIndex(dtp, nRow, "NewRecordResult");
                string subEventCode = DTHelpFunctions.GetStringByFieldAndRowIndex(dtp, nRow, "SubEventCode");
                if (!IsValidRecord(objEx, subEventCode, recordValue))
                {
                    string recordID = DTHelpFunctions.GetStringByFieldAndRowIndex(dtp, nRow, "RecordID");
                    GVWL.g_ManageDB.DeleteMatchRecord(recordID);
                }
            }

            this.m_dtRecord = GVWL.g_ManageDB.GetRecordList(m_nCurMatchID);


            return 1;
        }

        private void DataExchangeTimingScoring(int RowIndex)
        {
            try
            {
                DataGridView dgv = this.dgv_List;
                ObjectEx objEx = null;
                GetDataGridViewData(dgv, RowIndex, out objEx);
                string strComPos = objEx.m_strComPos;

                string str1stAttempt = objEx.m_str1stAttempt == "" ? "-1" : objEx.m_str1stAttempt;
                string str2ndAttempt = objEx.m_str2ndAttempt == "" ? "-1" : objEx.m_str2ndAttempt;
                string str3rdAttempt = objEx.m_str3rdAttempt == "" ? "-1" : objEx.m_str3rdAttempt;

                string str1stRes = objEx.m_str1stRes;//== "" ? "-1" : objEx.m_str1stRes;
                string str2ndRes = objEx.m_str2ndRes;//== "" ? "-1" : objEx.m_str2ndRes;
                string str3rdRes = objEx.m_str3rdRes;//== "" ? "-1" : objEx.m_str3rdRes;

                string strMatchResult = objEx.m_strResult == "" ? "-1" : objEx.m_strResult;
                string strMatchRank = objEx.m_strRank == "" ? "-1" : objEx.m_strRank;

                string strIRM = objEx.m_strIRM;
                //更新抓举/挺举成绩
                GVWL.g_ManageDB.UpdateMatchResult(m_nCurMatchID, int.Parse(strComPos),
                  str1stAttempt, str1stRes, str2ndAttempt, str2ndRes, str3rdAttempt, str3rdRes,
                  strMatchResult, strMatchRank, objEx.m_strDisplayPosition, strIRM);

            }
            catch (Exception ex) { DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message); }
        }

        #endregion

        #region 辅助方法
        private bool IsValidRecord(ObjectEx objEx, string subEventCode, string resultValue)
        {
            string strIRM = objEx.m_strIRM;
            if (strIRM.Length > 0 && strIRM != "DNF")
                return false;

            string str1stAttempt = objEx.m_str1stAttempt;
            string str2ndAttempt = objEx.m_str2ndAttempt;
            string str3rdAttempt = objEx.m_str3rdAttempt;

            string str1stRes = objEx.m_str1stRes;
            string str2ndRes = objEx.m_str2ndRes;
            string str3rdRes = objEx.m_str3rdRes;

            if ((m_strMatchCode == "01" && subEventCode == "1") || (m_strMatchCode == "02" && subEventCode == "2"))
            {
                if (str1stAttempt == resultValue && CalculationLight(str1stRes) == 1)
                { return true; }
                if (str2ndAttempt == resultValue && CalculationLight(str2ndRes) == 1)
                { return true; }
                if (str3rdAttempt == resultValue && CalculationLight(str3rdRes) == 1)
                { return true; }

                return false;
            }
            else if (m_strMatchCode == "01" && subEventCode == "3")
            {
                string strCJReuslt = objEx.m_strCleanJerkResult;
                float fCJReuslt = float.Parse(strCJReuslt);
                float f1stAttempt = 0;
                float f2ndAttempt = 0;
                float f3rdAttempt = 0;
                if (str1stAttempt.Length > 0)
                    f1stAttempt = float.Parse(str1stAttempt);
                if (str2ndAttempt.Length > 0)
                    f2ndAttempt = float.Parse(str2ndAttempt);
                if (str3rdAttempt.Length > 0)
                    f3rdAttempt = float.Parse(str3rdAttempt);

                if ((f1stAttempt + fCJReuslt).Equals(float.Parse(resultValue)) && CalculationLight(str1stRes) == 1)
                { return true; }
                if ((f2ndAttempt + fCJReuslt).Equals(float.Parse(resultValue)) && CalculationLight(str2ndRes) == 1)
                { return true; }
                if ((f3rdAttempt + fCJReuslt).Equals(float.Parse(resultValue)) && CalculationLight(str3rdRes) == 1)
                { return true; }

                return false;
            }
            else if (m_strMatchCode == "02" && subEventCode == "3")
            {
                string strSnatchReuslt = objEx.m_strSnatchResult;
                float fSnatchReuslt = float.Parse(strSnatchReuslt);
                float f1stAttempt = 0;
                float f2ndAttempt = 0;
                float f3rdAttempt = 0;
                if (str1stAttempt.Length > 0)
                    f1stAttempt = float.Parse(str1stAttempt);
                if (str2ndAttempt.Length > 0)
                    f2ndAttempt = float.Parse(str2ndAttempt);
                if (str3rdAttempt.Length > 0)
                    f3rdAttempt = float.Parse(str3rdAttempt);

                if ((f1stAttempt + fSnatchReuslt).Equals(float.Parse(resultValue)) && CalculationLight(str1stRes) == 1)
                { return true; }
                if ((f2ndAttempt + fSnatchReuslt).Equals(float.Parse(resultValue)) && CalculationLight(str2ndRes) == 1)
                { return true; }
                if ((f3rdAttempt + fSnatchReuslt).Equals(float.Parse(resultValue)) && CalculationLight(str3rdRes) == 1)
                { return true; }

                return false;
            }
            return true;
        }
        #endregion

    }
}