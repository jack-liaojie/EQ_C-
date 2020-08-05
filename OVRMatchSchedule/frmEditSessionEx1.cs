using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Collections;

using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRMatchSchedule
{
    public partial class EditSessionForm
    {
        private void dgv_Session_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            for (int nColIndex = 0; nColIndex < this.dgv_Session.Columns.Count; nColIndex++)
            {
                try
                {
                    m_dtOldSession.Rows[0][nColIndex] = this.dgv_Session.Rows[e.RowIndex].Cells[nColIndex].Value;
                }
                catch
                {
                    m_dtOldSession.Rows[0][nColIndex] = DBNull.Value;
                }
            }

            if (dgv_Session.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn)
            {
                if (dgv_Session.Columns[e.ColumnIndex].Name.CompareTo("Type") == 0)
                {
                    InitDgvTypeCombBox(ref dgv_Session, e.ColumnIndex);
                }
            }
        }
        private void InitDgvTypeCombBox(ref UIDataGridView GridCtrl, Int32 iColumnIndex)
        {
            System.Data.DataTable dt = GetTypeItemTable();
            (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dt, 1, 0);
        }


        private void dgv_Session_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (dgv_Session.Columns[e.ColumnIndex].Name.CompareTo("Number") == 0)
            {
                string strOldData = m_dtOldSession.Rows[0]["Number"].ToString();
                string strNewData = "";
                if (dgv_Session.Rows[e.RowIndex].Cells["Number"].Value != null)
                {
                    strNewData = dgv_Session.Rows[e.RowIndex].Cells["Number"].Value.ToString();

                    bool bIsInt = true;
                    for (int i = 0; i < strNewData.Length; i++)
                    {
                        if (!Char.IsNumber(strNewData, i))
                            bIsInt = false;
                    }
                    if (!bIsInt)
                    {
                        dgv_Session.Rows[e.RowIndex].Cells["Number"].Value = strOldData;
                        return;
                    }
                }
                if (strNewData == strOldData)
                    return;
                if (strNewData.Length == 0)
                    m_dtOldSession.Rows[0]["Number"] = DBNull.Value;
                else
                    m_dtOldSession.Rows[0]["Number"] = strNewData;
            }
            else if (dgv_Session.Columns[e.ColumnIndex].Name.CompareTo("StartTime") == 0)
            {
                string strOldData = m_dtOldSession.Rows[0]["StartTime"].ToString();
                string strNewData = "";
                if (dgv_Session.Rows[e.RowIndex].Cells["StartTime"].Value != null)
                {
                    strNewData = dgv_Session.Rows[e.RowIndex].Cells["StartTime"].Value.ToString();
                    try
                    {
                        DateTime dtTemp = Convert.ToDateTime(strNewData);
                    }
                    catch
                    {
                        dgv_Session.Rows[e.RowIndex].Cells["StartTime"].Value = strOldData;
                        return;
                    }
                }
                if (strNewData == strOldData)
                    return;
                if (strNewData.Length == 0)
                    m_dtOldSession.Rows[0]["StartTime"] = DBNull.Value;
                else
                    m_dtOldSession.Rows[0]["StartTime"] = strNewData;
            }
            else if (dgv_Session.Columns[e.ColumnIndex].Name.CompareTo("EndTime") == 0)
            {
                string strOldData = m_dtOldSession.Rows[0]["EndTime"].ToString();
                string strNewData = "";
                if (dgv_Session.Rows[e.RowIndex].Cells["EndTime"].Value != null)
                {
                    strNewData = dgv_Session.Rows[e.RowIndex].Cells["EndTime"].Value.ToString();
                    try
                    {
                        DateTime dtTemp = Convert.ToDateTime(strNewData);
                    }
                    catch
                    {
                        dgv_Session.Rows[e.RowIndex].Cells["EndTime"].Value = strOldData;
                        return;
                    }
                }
                if (strNewData == strOldData)
                    return;
                if (strNewData.Length == 0)
                    m_dtOldSession.Rows[0]["EndTime"] = DBNull.Value;
                else
                    m_dtOldSession.Rows[0]["EndTime"] = strNewData;
            }
            else if (dgv_Session.Columns[e.ColumnIndex].Name.CompareTo("Type") == 0)
            {
                string strOldData = m_dtOldSession.Rows[0]["F_SessionTypeID"].ToString();
                DGVCustomComboBoxCell boxCell = dgv_Session.Rows[e.RowIndex].Cells[e.ColumnIndex] as DGVCustomComboBoxCell;
                Int32 iKey = 0;
                iKey = Convert.ToInt32(boxCell.Tag);

                string strNewData = "";
                if (iKey == -1)
                    strNewData = "";
                else if (iKey == 0)
                    strNewData = strOldData;
                else
                    strNewData = iKey.ToString();

                if (strNewData == strOldData)
                    return;

                m_dtOldSession.Rows[0]["Type"] = boxCell.Value;
                if (strNewData.Length != 0)
                {
                    m_dtOldSession.Rows[0]["F_SessionTypeID"] = strNewData;
                    dgv_Session.Rows[e.RowIndex].Cells["F_SessionTypeID"].Value = strNewData;
                }
                else
                {
                    m_dtOldSession.Rows[0]["F_SessionTypeID"] = DBNull.Value;
                    dgv_Session.Rows[e.RowIndex].Cells["F_SessionTypeID"].Value = DBNull.Value;
                }
            }
            else
                return;

            string strSessionID = "";
            if (dgv_Session.Rows[e.RowIndex].Cells["F_SessionID"].Value != null)
                strSessionID = dgv_Session.Rows[e.RowIndex].Cells["F_SessionID"].Value.ToString();
            string strSessionDate = "";
            if (dgv_Session.Rows[e.RowIndex].Cells["Date"].Value != null)
                strSessionDate = dgv_Session.Rows[e.RowIndex].Cells["Date"].Value.ToString();
            string strSessionNumber = "";
            if (dgv_Session.Rows[e.RowIndex].Cells["Number"].Value != null)
                strSessionNumber = dgv_Session.Rows[e.RowIndex].Cells["Number"].Value.ToString();
            string strSessionTypeID = "";
            if (dgv_Session.Rows[e.RowIndex].Cells["F_SessionTypeID"].Value != null)
                strSessionTypeID = dgv_Session.Rows[e.RowIndex].Cells["F_SessionTypeID"].Value.ToString();
            string strSessionStartTime = "";
            if (dgv_Session.Rows[e.RowIndex].Cells["StartTime"].Value != null)
                strSessionStartTime = dgv_Session.Rows[e.RowIndex].Cells["StartTime"].Value.ToString();
            string strSessionEndTime = "";
            if (dgv_Session.Rows[e.RowIndex].Cells["EndTime"].Value != null)
                strSessionEndTime = dgv_Session.Rows[e.RowIndex].Cells["EndTime"].Value.ToString();

            this.UpdateSession(strSessionID, strSessionDate, strSessionNumber, strSessionTypeID, strSessionStartTime, strSessionEndTime);
        }
    }
}