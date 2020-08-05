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

namespace AutoSports.OVRMatchSchedule
{
    public partial class EditDateForm
    {
        private void dgv_Date_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            for (int nColIndex = 0; nColIndex < this.dgv_Date.Columns.Count; nColIndex++)
            {
                try
                {
                    m_dtOldDate.Rows[0][nColIndex] = this.dgv_Date.Rows[e.RowIndex].Cells[nColIndex].Value;
                }
                catch
                {
                    m_dtOldDate.Rows[0][nColIndex] = DBNull.Value;
                }
            }
        }

        private void dgv_Date_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (dgv_Date.Columns[e.ColumnIndex].Name.CompareTo("Order") == 0)
            {
                string strOldData = m_dtOldDate.Rows[0]["Order"].ToString();
                string strNewData = "";
                if (dgv_Date.Rows[e.RowIndex].Cells["Order"].Value != null)
                {
                    strNewData = dgv_Date.Rows[e.RowIndex].Cells["Order"].Value.ToString();

                    bool bIsInt = true;
                    for (int i = 0; i < strNewData.Length; i++)
                    {
                        if (!Char.IsNumber(strNewData, i))
                            bIsInt = false;
                    }
                    if (!bIsInt)
                    {
                        dgv_Date.Rows[e.RowIndex].Cells["Order"].Value = strOldData;
                        return;
                    }
                }
                if (strNewData == strOldData)
                    return;
                m_dtOldDate.Rows[0]["Order"] = strNewData;
            }
            else if (dgv_Date.Columns[e.ColumnIndex].Name.CompareTo("Date") == 0)
            {
                string strOldData = m_dtOldDate.Rows[0]["Date"].ToString();
                string strNewData = "";
                if (dgv_Date.Rows[e.RowIndex].Cells["Date"].Value != null)
                {
                    strNewData = dgv_Date.Rows[e.RowIndex].Cells["Date"].Value.ToString();
                    try
                    {
                        DateTime dtTemp = Convert.ToDateTime(strNewData);
                    }
                    catch
                    {
                        dgv_Date.Rows[e.RowIndex].Cells["Date"].Value = strOldData;
                        return;
                    }
                }
                if (strNewData == strOldData)
                    return;
                m_dtOldDate.Rows[0]["Date"] = strNewData;
            }
            else if (dgv_Date.Columns[e.ColumnIndex].Name.CompareTo("Long Description") == 0)
            {
                string strOldData = m_dtOldDate.Rows[0]["Long Description"].ToString();
                string strNewData = "";
                if (dgv_Date.Rows[e.RowIndex].Cells["Long Description"].Value != null)
                {
                    strNewData = dgv_Date.Rows[e.RowIndex].Cells["Long Description"].Value.ToString();
                }
                if (strNewData == strOldData)
                    return;
                m_dtOldDate.Rows[0]["Long Description"] = strNewData;
            }
            else if (dgv_Date.Columns[e.ColumnIndex].Name.CompareTo("Short Description") == 0)
            {
                string strOldData = m_dtOldDate.Rows[0]["Short Description"].ToString();
                string strNewData = "";
                if (dgv_Date.Rows[e.RowIndex].Cells["Short Description"].Value != null)
                {
                    strNewData = dgv_Date.Rows[e.RowIndex].Cells["Short Description"].Value.ToString();
                }
                if (strNewData == strOldData)
                    return;
                m_dtOldDate.Rows[0]["Short Description"] = strNewData;
            }
            else if (dgv_Date.Columns[e.ColumnIndex].Name.CompareTo("Comment") == 0)
            {
                string strOldData = m_dtOldDate.Rows[0]["Comment"].ToString();
                string strNewData = "";
                if (dgv_Date.Rows[e.RowIndex].Cells["Comment"].Value != null)
                {
                    strNewData = dgv_Date.Rows[e.RowIndex].Cells["Comment"].Value.ToString();
                }
                if (strNewData == strOldData)
                    return;
                m_dtOldDate.Rows[0]["Comment"] = strNewData;
            }
           else
                return;

            string strDateID = "";
            if (dgv_Date.Rows[e.RowIndex].Cells["F_DisciplineDateID"].Value != null)
                strDateID = dgv_Date.Rows[e.RowIndex].Cells["F_DisciplineDateID"].Value.ToString();
             string strOrder = "";
            if (dgv_Date.Rows[e.RowIndex].Cells["Order"].Value != null)
                strOrder = dgv_Date.Rows[e.RowIndex].Cells["Order"].Value.ToString();
           string strDate = "";
            if (dgv_Date.Rows[e.RowIndex].Cells["Date"].Value != null)
                strDate = dgv_Date.Rows[e.RowIndex].Cells["Date"].Value.ToString();
            string strLongName = "";
            if (dgv_Date.Rows[e.RowIndex].Cells["Long Description"].Value != null)
                strLongName = dgv_Date.Rows[e.RowIndex].Cells["Long Description"].Value.ToString();
            string strShortName = "";
            if (dgv_Date.Rows[e.RowIndex].Cells["Short Description"].Value != null)
                strShortName = dgv_Date.Rows[e.RowIndex].Cells["Short Description"].Value.ToString();
            string strComment = "";
            if (dgv_Date.Rows[e.RowIndex].Cells["Comment"].Value != null)
                strComment = dgv_Date.Rows[e.RowIndex].Cells["Comment"].Value.ToString();

            this.UpdateDate(strDateID, strOrder, strDate, strLongName, strShortName, strComment);
        }
    }
}