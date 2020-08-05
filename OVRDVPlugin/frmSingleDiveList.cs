using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;

namespace OVRDVPlugin
{
    public partial class SingleDiveListForm : Office2007Form
    {
        public Int32 m_iCurMatchID;
        public Int32 m_iSportID;
        public Int32 m_iDisciplineID;
        public Int32 m_iCurCompetitionPosition;
        public String m_strLanguageCode = "ENG";
        public String m_strRegisterName = "";
        public String m_strNOC = "";

        public SingleDiveListForm()
        {
            InitializeComponent();
            SetDgvSingleDiveList();
        }

        protected override void OnShown(EventArgs e)
        {
            base.OnShown(e);
            this.lb_RegisterDes.Text = m_strRegisterName + "(" + m_strNOC + ")";
            IntiMatchFixedDiveInfo();
            IntiSingleDiveList();
        }

        private void SetDgvSingleDiveList()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvSingleDiveList);
            dgvSingleDiveList.SelectionMode = DataGridViewSelectionMode.CellSelect;

            FontFamily fontFamily = new FontFamily("Arial");
            FontStyle fontStyle = new FontStyle();
            Font gridFont = new Font(fontFamily, 13, fontStyle);
            dgvSingleDiveList.Font = gridFont;
        }

        private void IntiMatchFixedDiveInfo()
        {
            String strFixedSplitsName = "";
            String strFixedDifficultyValue = "";
            DVCommon.g_DVDBManager.GetMatchFixedDiveInfo(m_iCurMatchID, ref strFixedSplitsName, ref strFixedDifficultyValue);
            this.lb_FixedSplits.Text = strFixedSplitsName;
            this.lb_FixedDifficultyValue.Text = strFixedDifficultyValue;
        }
        
        private void IntiSingleDiveList()
        {
            DVCommon.g_DVDBManager.IntiSingleDiveList(m_iCurMatchID, m_iCurCompetitionPosition, ref this.dgvSingleDiveList);

            if (dgvSingleDiveList.Columns[" "] != null)
            {
                dgvSingleDiveList.Columns[" "].Frozen = true;
            }

            if (dgvSingleDiveList.Columns["Round_1"] != null)
            {
                dgvSingleDiveList.Columns["Round_1"].ReadOnly = false;
            }

            if (dgvSingleDiveList.Columns["Round_2"] != null)
            {
                dgvSingleDiveList.Columns["Round_2"].ReadOnly = false;
            }

            if (dgvSingleDiveList.Columns["Round_3"] != null)
            {
                dgvSingleDiveList.Columns["Round_3"].ReadOnly = false;
            }

            if (dgvSingleDiveList.Columns["Round_4"] != null)
            {
                dgvSingleDiveList.Columns["Round_4"].ReadOnly = false;
            }

            if (dgvSingleDiveList.Columns["Round_5"] != null)
            {
                dgvSingleDiveList.Columns["Round_5"].ReadOnly = false;
            }

            if (dgvSingleDiveList.Columns["Round_6"] != null)
            {
                dgvSingleDiveList.Columns["Round_6"].ReadOnly = false;
            }

            for (int i = 0; i < this.dgvSingleDiveList.Columns.Count; i++)
            {
                this.dgvSingleDiveList.Columns[i].SortMode = DataGridViewColumnSortMode.NotSortable;
            }

            for (int i = 1; i < this.dgvSingleDiveList.Columns.Count; i++)
            {
                this.dgvSingleDiveList.Rows[1].Cells[i].Style.ForeColor = System.Drawing.Color.Blue;
                this.dgvSingleDiveList.Rows[2].Cells[i].Style.ForeColor = System.Drawing.Color.Red;
            }
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
        }

        private void btnCancle_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
        }

        private void dgvSingleDiveList_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex == 1 || e.RowIndex < 0 || e.ColumnIndex < 0)
                return;
            
            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;

            String strColumnName = dgvSingleDiveList.Columns[iColumnIndex].Name;

            DataGridViewCell CurCell = dgvSingleDiveList.Rows[iRowIndex].Cells[iColumnIndex];
            if (CurCell != null)
            {
                String strInputString = "";
                Int32 iRoundID = 0;
                if (CurCell.Value != null)
                {
                    strInputString = CurCell.Value.ToString();
                }
                else
                {
                    strInputString = "";
                }

                if (strColumnName.CompareTo("Round_1") == 0)
                {
                    iRoundID = 1;
                }
                else if (strColumnName.CompareTo("Round_2") == 0)
                {
                    iRoundID = 2;
                }
                else if (strColumnName.CompareTo("Round_3") == 0)
                {
                    iRoundID = 3;
                }
                else if (strColumnName.CompareTo("Round_4") == 0)
                {
                    iRoundID = 4;
                }
                else if (strColumnName.CompareTo("Round_5") == 0)
                {
                    iRoundID = 5;
                }
                else if (strColumnName.CompareTo("Round_6") == 0)
                {
                    iRoundID = 6;
                }

                if (e.RowIndex == 0)
                {
                    DVCommon.g_DVDBManager.UpdateOneDive(m_iCurMatchID, m_iCurCompetitionPosition, iRoundID, strInputString);
                }
                else if (e.RowIndex == 2)
                {
                    DVCommon.g_DVDBManager.UpdateOneDiveMixedDifficultyValue(m_iCurMatchID, m_iCurCompetitionPosition, iRoundID, strInputString);
                }

               
            }

            IntiSingleDiveList();
            this.dgvSingleDiveList.CurrentCell = this.dgvSingleDiveList.Rows[iRowIndex].Cells[iColumnIndex];

        }


        protected override bool ProcessCmdKey(ref Message msg, Keys keyData)
        {
            if (keyData == Keys.Enter)    //监听回车事件            
            {
                if (this.dgvSingleDiveList.IsCurrentCellInEditMode)   //如果当前单元格处于编辑模式 
                {
                    if (dgvSingleDiveList.CurrentCell.RowIndex == dgvSingleDiveList.Rows.Count - 1)
                    {
                        if (dgvSingleDiveList.CurrentCell.ColumnIndex != dgvSingleDiveList.Columns.Count - 1)
                        {
                            SendKeys.Send("{Tab}");
                        }
                    }
                    else
                    {
                        SendKeys.Send("{Up}");
                        if (dgvSingleDiveList.CurrentCell.ColumnIndex != dgvSingleDiveList.Columns.Count - 1)
                        {
                            SendKeys.Send("{Tab}");
                        }
                    }
                }
                else
                {
                    dgvSingleDiveList.BeginEdit(false);
           
                    return true;
                }
            }            
            //继续原来base.ProcessCmdKey中的处理  
            return base.ProcessCmdKey(ref msg, keyData);
        }

    }
}
