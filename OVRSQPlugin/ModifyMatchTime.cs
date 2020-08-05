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

namespace AutoSports.OVRSQPlugin
{
    public partial class ModifyMatchTime : Office2007Form
    {
        Int32 m_iMatchID;
        Int32 m_iMatchType;
        Int32 m_iMatchSplitID;

        public ModifyMatchTime(Int32 nMatchID, Int32 nMatchType)
        {
            InitializeComponent();

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchTime);
            m_iMatchID = nMatchID;
            m_iMatchType = nMatchType;
            m_iMatchSplitID = -1;
        }

        private void ModifyMatchTime_Load(object sender, EventArgs e)
        {
            if (m_iMatchType == 3)
            {
                cmb_Time_Regus.Enabled = true;
                m_iMatchSplitID = -1;
                SQCommon.g_ManageDB.GetRegusList(m_iMatchID, cmb_Time_Regus);
            }
            else
            {
                m_iMatchSplitID = 0;
                cmb_Time_Regus.Enabled = false;
                lb_Regu.Text = "";
            }

            Localization();
            ResetMatchTime();
        }

        private void Localization()
        {
            String strSectionName = SQCommon.m_strSectionName;
            this.Text = LocalizationRecourceManager.GetString(strSectionName, "frmModifyTime");
            lb_Regu.Text = LocalizationRecourceManager.GetString(strSectionName, "lbRegu");
        }

        private void ResetMatchTime()
        {
            SQCommon.g_ManageDB.GetMatchTime(m_iMatchID, m_iMatchSplitID, dgvMatchTime);
            SetGridStyle(dgvMatchTime);
        }

        private void SetGridStyle(DataGridView dgv)
        {
            dgv.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;

            if (dgv == dgvMatchTime)
            {
                if (dgvMatchTime.Columns["Game1"] != null)
                {
                    dgvMatchTime.Columns["Game1"].ReadOnly = false;
                }
                if (dgvMatchTime.Columns["Game2"] != null)
                {
                    dgvMatchTime.Columns["Game2"].ReadOnly = false;
                }
                if (dgvMatchTime.Columns["Game3"] != null)
                {
                    dgvMatchTime.Columns["Game3"].ReadOnly = false;
                }
                if (dgvMatchTime.Columns["Game4"] != null)
                {
                    dgvMatchTime.Columns["Game4"].ReadOnly = false;
                }
                if (dgvMatchTime.Columns["Game5"] != null)
                {
                    dgvMatchTime.Columns["Game5"].ReadOnly = false;
                }
                if (dgvMatchTime.Columns["Match"] != null)
                {
                    dgvMatchTime.Columns["Match"].ReadOnly = false;
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
                Int32 iSplitID = 0;

                strInputValue = Convert.ToString(CurCell.Value);

                if (strColumnName.CompareTo("Match") == 0)
                {
                    iSplitID = m_iMatchSplitID;
                }
                if (strColumnName.CompareTo("Game1") == 0)
                {
                    iSplitID = GetFieldValue(dgvMatchTime, iRowIndex, "F_Game1ID");
                }
                if (strColumnName.CompareTo("Game2") == 0)
                {
                    iSplitID = GetFieldValue(dgvMatchTime, iRowIndex, "F_Game2ID");
                }
                if (strColumnName.CompareTo("Game3") == 0)
                {
                    iSplitID = GetFieldValue(dgvMatchTime, iRowIndex, "F_Game3ID");
                }
                if (strColumnName.CompareTo("Game4") == 0)
                {
                    iSplitID = GetFieldValue(dgvMatchTime, iRowIndex, "F_Game4ID");
                }
                if (strColumnName.CompareTo("Game5") == 0)
                {
                    iSplitID = GetFieldValue(dgvMatchTime, iRowIndex, "F_Game5ID");
                }

                try
                {
                    DateTime dtTemp = Convert.ToDateTime(strInputValue);
                    SQCommon.g_ManageDB.UpdateMatchTime(m_iMatchID, iSplitID, strInputValue);
                }
                catch
                {
                }

                ResetMatchTime();
            }
        }

        private void cmb_Time_Regus_SelectionChangeCommitted(object sender, EventArgs e)
        {
            m_iMatchSplitID = -1;
            int nSelIdx = -1;

            if (cmb_Time_Regus.SelectedItem == null)
                return;

            nSelIdx = cmb_Time_Regus.SelectedIndex;
            m_iMatchSplitID = Convert.ToInt32(cmb_Time_Regus.SelectedValue);

            ResetMatchTime();
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
