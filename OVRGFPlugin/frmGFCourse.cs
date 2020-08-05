using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.Data.SqlClient;
using AutoSports.OVRCommon;

namespace AutoSports.OVRGFPlugin
{
    public partial class frmGFCourse : DevComponents.DotNetBar.Office2007Form
    {
        public Int32 m_iCurMatchID;
        public Int32 m_iCurMatchRuleID;

        public dlDataEntryChangeMatchRule DataEntryChangeMatchRuleHandler;

        public frmGFCourse()
        {
            InitializeComponent();
        }

        private void Localization()
        {
            this.lb_Hole.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbHole");
            this.lb_CurRule.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "lbCurRule");
            this.btnx_CreateCourse.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxCreateCourse");
            this.btnx_DelCourse.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxDelCourse");
            this.btnx_ApplyCourse.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxApplayCourse");
            this.btnx_SaveXML.Text = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "btnxSaveXML");
        }

        private void frmGFCourse_Load(object sender, EventArgs e)
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvCourseList);
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvCourseDetail);

            Localization();

            InitMatchInfo();
            InitCourseInfo();

            InitCmbRules();
            cmbCourseList.SelectedValue = m_iCurMatchRuleID;
        }

        private void InitMatchInfo()
        {
            m_iCurMatchRuleID = GFCommon.g_ManageDB.GetMatchRuleID(m_iCurMatchID);
        }

        private void InitCourseInfo()
        {
            GFCommon.g_ManageDB.InitCourseInfo(this.dgvCourseList);
        }

        private void IntiCourseDetail(Int32 nRuleID)
        {
            GFCommon.g_ManageDB.IntiCourseDetail(nRuleID, this.dgvCourseDetail);
        }

        private void InitCmbRules()
        {
            GFCommon.g_ManageDB.InitCmbRules(cmbCourseList);
        }

        private void dgvCourseList_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvCourseList.SelectedRows.Count != 1)
            {
                return;
            }

            Int32 nRuleID = Convert.ToInt32(dgvCourseList.SelectedRows[0].Cells["F_CompetitionRuleID"].Value);
            IntiCourseDetail(nRuleID);
        }

        private void dgvCourseList_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            String strColumnName = dgvCourseList.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvCourseList.Rows[iRowIndex].Cells[iColumnIndex];
            if (CurCell != null)
            {
                Int32 iComepetitionRuleID = Convert.ToInt32(dgvCourseList.Rows[iRowIndex].Cells["F_CompetitionRuleID"].Value);

                String strInputString = "";

                if (CurCell.Value != null)
                {
                    strInputString = CurCell.Value.ToString();
                }

                GFCommon.g_ManageDB.UpdateCourseDes(iComepetitionRuleID, strColumnName, strInputString);

                //更新命名
                InitMatchInfo();
                InitCmbRules();
                cmbCourseList.SelectedValue = m_iCurMatchRuleID;
            }
        }

        private void btnx_CreateCourse_Click(object sender, EventArgs e)
        {
            Int32 nHoleNumber = tb_HoleNum.Text == "" ? 0 : Convert.ToInt32(tb_HoleNum.Text);

            if (nHoleNumber < 1)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgHoleNum"));
                return;
            }

            if (GFCommon.g_ManageDB.CreateCourse(nHoleNumber))
            {
                InitCourseInfo();

                //更新命名
                InitMatchInfo();
                InitCmbRules();
                cmbCourseList.SelectedValue = m_iCurMatchRuleID;
            }
        }

        private void btnx_DelCourse_Click(object sender, EventArgs e)
        {
            if (1 != dgvCourseList.SelectedRows.Count)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgDelRule4"));
                return;
            }

            String message = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgDelRule5");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(message, GFCommon.g_strSectionName, MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
            {
                return;
            }

            Int32 nRuleID = Convert.ToInt32(dgvCourseList.SelectedRows[0].Cells["F_CompetitionRuleID"].Value);

            if (GFCommon.g_ManageDB.DeleteCourse(nRuleID))
            {
                InitCourseInfo();

                //更新命名
                InitMatchInfo();
                InitCmbRules();
                cmbCourseList.SelectedValue = m_iCurMatchRuleID;
            }
        }

        private void btnx_ApplyCourse_Click(object sender, EventArgs e)
        {
            String strMessage = LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgApplySelRule1");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMessage, GFCommon.g_strSectionName, MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
            {
                return;
            }

            Int32 nRuleID = GFCommon.ConvertStrToInt(cmbCourseList.SelectedValue.ToString());

            if (GFCommon.g_ManageDB.ApplayCourse(m_iCurMatchID, nRuleID))
            {
                DataEntryChangeMatchRuleHandler.Invoke();

                InitMatchInfo();
                cmbCourseList.SelectedValue = m_iCurMatchRuleID;
            }
        }

        private void btnx_SaveXML_Click(object sender, EventArgs e)
        {
            SaveCompetitionRule2XML();
        }

        private void tb_HoleNum_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar != 8 && !Char.IsDigit(e.KeyChar) && e.KeyChar != 13)
            {
                e.Handled = true;
            }
        }

        private void SaveCompetitionRule2XML()
        {
            Int32  iColCount;
            String strHole;
            String strHoleName;
            String strPar;
            String strDistance;
            String strXML;

            if (dgvCourseDetail.Rows.Count != 2 || dgvCourseDetail.Columns.Count == 0)
                return;

            iColCount = dgvCourseDetail.Columns.Count;

            strHole = iColCount.ToString();
            strXML = "<CourseInfo NumHoles=\"" + strHole + "\">";

            for (Int32 iCol = 0; iCol < iColCount; iCol++)
            {
                strHoleName = dgvCourseDetail.Columns[iCol].Name;
                strPar = GFCommon.GetFieldValue(dgvCourseDetail, 0, iCol);
                strDistance = GFCommon.GetFieldValue(dgvCourseDetail, 1, iCol);

                strXML = strXML + "<HoleRule HoleNum=\"" + strHoleName + "\" HolePar=\"" + strPar + "\" HoleDistance=\"" + strDistance + "\" />";
            }

            strXML = strXML + "</CourseInfo>";

            if (1 != dgvCourseList.SelectedRows.Count)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(GFCommon.g_strSectionName, "MsgDelRule4"));
                return;
            }

            Int32 nRuleID = Convert.ToInt32(dgvCourseList.SelectedRows[0].Cells["F_CompetitionRuleID"].Value);
            GFCommon.g_ManageDB.UpdateCourseDetail(nRuleID, strXML);
        }
    }
}
