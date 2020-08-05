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
using System.Collections;

using DevComponents.DotNetBar;

namespace AutoSports.OVRSEPlugin
{
    public partial class frmModifyMatchTime : Office2007Form
    {
        Int32 m_iMatchID;
        Int32 m_iMatchType;

        public frmModifyMatchTime(Int32 nMatchID, Int32 nMatchType)
        {
            InitializeComponent();

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchTime);
            m_iMatchID = nMatchID;
            m_iMatchType = nMatchType;
        }

        private void frmModifyMatchTime_Load(object sender, EventArgs e)
        {
            Localization();
            ResetMatchTime();
        }

        private void Localization()
        {
            String strSectionName = SECommon.m_strSectionName;
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmModifyTime");
        }

        private void ResetMatchTime()
        {
            SECommon.g_ManageDB.GetMatchTime(m_iMatchID, m_iMatchType, dgvMatchTime);
            SetGridStyle(dgvMatchTime);
        }

        private void SetGridStyle(DataGridView dgv)
        {
            dgv.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;

            if (dgv == dgvMatchTime)
            {
                if (dgvMatchTime.Columns["MatchTime"] != null)
                {
                    dgvMatchTime.Columns["MatchTime"].ReadOnly = false;
                }
                if (dgvMatchTime.Columns["Match1Time"] != null)
                {
                    dgvMatchTime.Columns["Match1Time"].ReadOnly = false;
                }
                if (dgvMatchTime.Columns["Match2Time"] != null)
                {
                    dgvMatchTime.Columns["Match2Time"].ReadOnly = false;
                }
                if (dgvMatchTime.Columns["Match3Time"] != null)
                {
                    dgvMatchTime.Columns["Match3Time"].ReadOnly = false;
                }
            }
        }

        private void dgvMatchTime_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            String strColumnName = dgvMatchTime.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvMatchTime.Rows[iRowIndex].Cells[iColumnIndex];

            if (CurCell != null)
            {
                String strInputValue = "";
                Int32 nSplitID = -1;

                strInputValue = Convert.ToString(CurCell.Value);

                try
                {
                    DateTime dtTemp = Convert.ToDateTime(strInputValue);

                    if (strColumnName.CompareTo("MatchTime") == 0)
                    {
                        SECommon.g_ManageDB.UpdateMatchTime(m_iMatchID, 0, strInputValue);
                    }
                    else if (strColumnName.CompareTo("Match1Time") == 0)
                    {
                        nSplitID = GetFieldValue(dgvMatchTime, iRowIndex, "Match1ID");
                        SECommon.g_ManageDB.UpdateMatchTime(m_iMatchID, nSplitID, strInputValue);
                    }
                    else if (strColumnName.CompareTo("Match2Time") == 0)
                    {
                        nSplitID = GetFieldValue(dgvMatchTime, iRowIndex, "Match2ID");
                        SECommon.g_ManageDB.UpdateMatchTime(m_iMatchID, nSplitID, strInputValue);
                    }
                    else if (strColumnName.CompareTo("Match3Time") == 0)
                    {
                        nSplitID = GetFieldValue(dgvMatchTime, iRowIndex, "Match3ID");
                        SECommon.g_ManageDB.UpdateMatchTime(m_iMatchID, nSplitID, strInputValue);
                    }
                }
                catch
                {
                }

                ResetMatchTime();
            }
        }

        private Int32 GetFieldValue(DataGridView dgv, Int32 iRowIndex, String strFiledName)
        {
            Int32 iReturnValue = 0;
            if (dgv.Columns[strFiledName] == null || dgv.Rows[iRowIndex].Cells[strFiledName].Value.ToString() == "")
            {
                iReturnValue = 0;
            }
            else
            {
                iReturnValue = Convert.ToInt32(dgv.Rows[iRowIndex].Cells[strFiledName].Value);
            }
            return iReturnValue;
        }
    }
}
