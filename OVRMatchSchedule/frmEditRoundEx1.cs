using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

using AutoSports.OVRCommon;

namespace AutoSports.OVRMatchSchedule
{
    public partial class EditRoundForm
    {

        private void dgv_Round_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            for (int nColIndex = 0; nColIndex < this.dgv_Round.Columns.Count; nColIndex++)
            {
                try
                {
                    m_dtOldRound.Rows[0][nColIndex] = this.dgv_Round.Rows[e.RowIndex].Cells[nColIndex].Value;
                }
                catch
                {
                    m_dtOldRound.Rows[0][nColIndex] = DBNull.Value;
                }
            }
        }

        private void dgv_Round_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            if (dgv_Round.Columns[e.ColumnIndex].Name.CompareTo("Order") == 0)
            {
                string strOldData = m_dtOldRound.Rows[0]["Order"].ToString();
                string strNewData = "";
                if (dgv_Round.Rows[e.RowIndex].Cells["Order"].Value != null)
                {
                    strNewData = dgv_Round.Rows[e.RowIndex].Cells["Order"].Value.ToString();

                    bool bIsInt = true;
                    for (int i = 0; i < strNewData.Length; i++)
                    {
                        if (!Char.IsNumber(strNewData, i))
                            bIsInt = false;
                    }
                    if (!bIsInt)
                    {
                        dgv_Round.Rows[e.RowIndex].Cells["Order"].Value = strOldData;
                        return;
                    }
                }
                if (strNewData == strOldData)
                    return;
                if (strNewData.Length ==0)
                    m_dtOldRound.Rows[0]["Order"] = DBNull.Value;
                else
                    m_dtOldRound.Rows[0]["Order"] = strNewData;
            }
            else if (dgv_Round.Columns[e.ColumnIndex].Name.CompareTo("Code") == 0)
            {
                string strOldData = m_dtOldRound.Rows[0]["Code"].ToString();
                string strNewData = "";
                if (dgv_Round.Rows[e.RowIndex].Cells["Code"].Value != null)
                {
                    strNewData = dgv_Round.Rows[e.RowIndex].Cells["Code"].Value.ToString();
                }
                if (strNewData == strOldData)
                    return;
                m_dtOldRound.Rows[0]["Code"] = strNewData;
            }
            else if (dgv_Round.Columns[e.ColumnIndex].Name.CompareTo("LongName") == 0)
            {
                string strOldData = m_dtOldRound.Rows[0]["LongName"].ToString();
                string strNewData = "";
                if (dgv_Round.Rows[e.RowIndex].Cells["LongName"].Value != null)
                {
                    strNewData = dgv_Round.Rows[e.RowIndex].Cells["LongName"].Value.ToString();
                }
                if (strNewData == strOldData)
                    return;
                m_dtOldRound.Rows[0]["LongName"] = strNewData;
            }
            else if (dgv_Round.Columns[e.ColumnIndex].Name.CompareTo("ShortName") == 0)
            {
                string strOldData = m_dtOldRound.Rows[0]["ShortName"].ToString();
                string strNewData = "";
                if (dgv_Round.Rows[e.RowIndex].Cells["ShortName"].Value != null)
                {
                    strNewData = dgv_Round.Rows[e.RowIndex].Cells["ShortName"].Value.ToString();
                }
                if (strNewData == strOldData)
                    return;
                m_dtOldRound.Rows[0]["ShortName"] = strNewData;
            }
            else if (dgv_Round.Columns[e.ColumnIndex].Name.CompareTo("Comment") == 0)
            {
                string strOldData = m_dtOldRound.Rows[0]["Comment"].ToString();
                string strNewData = "";
                if (dgv_Round.Rows[e.RowIndex].Cells["Comment"].Value != null)
                {
                    strNewData = dgv_Round.Rows[e.RowIndex].Cells["Comment"].Value.ToString();
                }
                if (strNewData == strOldData)
                    return;
                m_dtOldRound.Rows[0]["Comment"] = strNewData;
            }
            else
                return;

            string strRoundID = "";
            if (dgv_Round.Rows[e.RowIndex].Cells["F_RoundID"].Value != null)
                strRoundID = dgv_Round.Rows[e.RowIndex].Cells["F_RoundID"].Value.ToString();
            string strEventID = "";
            if (dgv_Round.Rows[e.RowIndex].Cells["F_EventID"].Value != null)
                strEventID = dgv_Round.Rows[e.RowIndex].Cells["F_EventID"].Value.ToString();
            string strOrder = "";
            if (dgv_Round.Rows[e.RowIndex].Cells["Order"].Value != null)
                strOrder = dgv_Round.Rows[e.RowIndex].Cells["Order"].Value.ToString();
            string strCode = "";
            if (dgv_Round.Rows[e.RowIndex].Cells["Code"].Value != null)
                strCode = dgv_Round.Rows[e.RowIndex].Cells["Code"].Value.ToString();
            string strComment = "";
            if (dgv_Round.Rows[e.RowIndex].Cells["Comment"].Value != null)
                strComment = dgv_Round.Rows[e.RowIndex].Cells["Comment"].Value.ToString();
            string strLongName = "";
            if (dgv_Round.Rows[e.RowIndex].Cells["LongName"].Value != null)
                strLongName = dgv_Round.Rows[e.RowIndex].Cells["LongName"].Value.ToString();
            string strShortName = "";
            if (dgv_Round.Rows[e.RowIndex].Cells["ShortName"].Value != null)
                strShortName = dgv_Round.Rows[e.RowIndex].Cells["ShortName"].Value.ToString();

            this.UpdateRound(strRoundID, strEventID, strOrder, strCode, strComment, strLongName, strShortName);
        }
    }
}