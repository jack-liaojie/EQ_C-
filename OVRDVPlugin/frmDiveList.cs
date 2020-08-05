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
using System.Data.SqlClient;
using System.IO;

namespace OVRDVPlugin
{
    public partial class DiveListForm : Office2007Form
    {
        public Int32 m_iCurMatchID;
        public Int32 m_iSportID;
        public Int32 m_iDisciplineID;
        public String m_strLanguageCode = "ENG";

        private Int32 m_iSelRegister = -1;
        public DiveListForm()
        {
            InitializeComponent();
            SetdgvMatchDiveList();
        }

        private void SetdgvMatchDiveList()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchDiveList);
            FontFamily fontFamily = new FontFamily("Arial");
            FontStyle fontStyle = new FontStyle();
            Font gridFont = new Font(fontFamily, 13, fontStyle);
            dgvMatchDiveList.Font = gridFont;

        }

        protected override void OnShown(EventArgs e)
        {
            base.OnShown(e);
            IntiMatchDiveList();
            IntiMatchFixedDiveInfo();
            this.WindowState = FormWindowState.Maximized;
        }

        private void IntiMatchDiveList()
        {
            DVCommon.g_DVDBManager.InitMatchDiveList(m_iCurMatchID, ref this.dgvMatchDiveList);
            DgvMatchDiveListCustomizing();

            if (0 < m_iSelRegister && m_iSelRegister < dgvMatchDiveList.RowCount)
            {
                dgvMatchDiveList.FirstDisplayedScrollingRowIndex = m_iSelRegister;
                dgvMatchDiveList.Rows[m_iSelRegister].Selected = true;
            }
        }

        private void IntiMatchFixedDiveInfo()
        {
            String strFixedSplitsName = "";
            String strFixedDifficultyValue = "";
            DVCommon.g_DVDBManager.GetMatchFixedDiveInfo(m_iCurMatchID, ref strFixedSplitsName, ref strFixedDifficultyValue);
            this.lb_FixedSplits.Text = strFixedSplitsName;
            this.lb_FixedDifficultyValue.Text = strFixedDifficultyValue;
        }

        private void DgvMatchDiveListCustomizing()
        {
            Int32 iRowCount = dgvMatchDiveList.RowCount;
            Int32 iColumnCount = dgvMatchDiveList.ColumnCount;
            for (Int32 i = 0; i < iColumnCount; i++)
            {
                String strColumnName = dgvMatchDiveList.Columns[i].Name;
                if(strColumnName.CompareTo(" ") == 0)
                {
                    //难度系数字体颜色为红色
                    for (Int32 j = 0; j < iRowCount; j++)
                    {
                        dgvMatchDiveList.Rows[j].Cells[i].Style.ForeColor = System.Drawing.Color.Red;
                    }
                }
                else if (strColumnName.CompareTo("F_RegisterID") == 0 || strColumnName.CompareTo("F_MatchID") == 0 || strColumnName.CompareTo("F_CompetitionPosition") == 0)
                {
                    dgvMatchDiveList.Columns[i].Visible = false;
                }
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

        private void btn_CreateDiveList_Click(object sender, EventArgs e)
        {
            DVCommon.g_DVDBManager.CreateMatchDiveList(m_iCurMatchID);
            IntiMatchDiveList();
        }

        private void btn_CleanDiveList_Click(object sender, EventArgs e)
        {
            string strMessage = "You are going to clean this match's dive list, Are you sure to do this?";
            string strCaption = "Dive List";
            MessageBoxButtons buttons = MessageBoxButtons.YesNo;
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMessage, strCaption, buttons, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                DVCommon.g_DVDBManager.CleanMatchDiveList(m_iCurMatchID);
            }

            IntiMatchDiveList();
        }

        private void dgvMatchDiveList_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0)
            {
                return;
            }
            m_iSelRegister = e.RowIndex;
            String value = dgvMatchDiveList.Rows[e.RowIndex].Cells["F_CompetitionPosition"].Value.ToString();


            SingleDiveListForm frmSingleDiveList = new SingleDiveListForm();

            frmSingleDiveList.m_iCurMatchID = m_iCurMatchID;
            frmSingleDiveList.m_iSportID = m_iSportID;
            frmSingleDiveList.m_iDisciplineID = m_iDisciplineID;
            frmSingleDiveList.m_strLanguageCode = "ENG";
            frmSingleDiveList.m_iCurCompetitionPosition = Convert.ToInt32(value);
            frmSingleDiveList.m_strRegisterName = dgvMatchDiveList.Rows[e.RowIndex].Cells["Name"].Value.ToString();
            frmSingleDiveList.m_strNOC = dgvMatchDiveList.Rows[e.RowIndex].Cells["NOC"].Value.ToString();

            frmSingleDiveList.ShowDialog();

            IntiMatchDiveList();

        }

        private void btn_SetFixedDiveInfo_Click(object sender, EventArgs e)
        {
            FixedDiveInfoForm frmFixedDiveInfo = new FixedDiveInfoForm();
            frmFixedDiveInfo.m_iCurMatchID = m_iCurMatchID;
            frmFixedDiveInfo.m_iSportID = m_iSportID;
            frmFixedDiveInfo.m_iDisciplineID = m_iDisciplineID;
            frmFixedDiveInfo.m_strLanguageCode = "ENG";

            frmFixedDiveInfo.ShowDialog();

            IntiMatchFixedDiveInfo();
        }

        private void btnOutputDiveList_Click(object sender, EventArgs e)
        {
            String strEventName = "", strMatchName = "", strDateDes = "", strVenueDes = "";
            Int32 iDisciplineID = 0, iCurStatusID = 0, iCurMatchRuleID = 0;
            DVCommon.g_DVDBManager.GetMatchInfo(m_iCurMatchID, ref strEventName, ref strMatchName, ref strDateDes, ref strVenueDes, ref iDisciplineID, ref iCurStatusID, ref iCurMatchRuleID);

            String strFileName = null;
            saveResultDlg.FileName = strEventName +" "+ strMatchName + " Dive List.csv";

            if (saveResultDlg.ShowDialog() == DialogResult.OK)
            {
                strFileName = saveResultDlg.FileName;

                SqlDataReader srDiveList = null;
                DVCommon.g_DVDBManager.GetMatchDiveList(m_iCurMatchID, ref srDiveList);

                bool bRet = DataReaderToCSVFile(srDiveList, strFileName, ";");
                if (bRet)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show("Output this match's DiveList succeeded!");
                }
                else
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show("Output this match's DiveList failed!");
                }

                srDiveList.Close();
                srDiveList.Dispose();
            }
        }

        public bool DataReaderToCSVFile(SqlDataReader tableRecords, String SavePath, String splitToken)
        {
            if (tableRecords.FieldCount <= 0) return false;

            try
            {
                StreamWriter fileWriter = new StreamWriter(SavePath, false, Encoding.Default);

                // Fill the field names
                String strFieldName = "";
                for (int i = 0; i < tableRecords.FieldCount; i++)
                {
                    strFieldName += tableRecords.GetName(i) + splitToken;
                }
                fileWriter.WriteLine(strFieldName);

                // File the Records               
                while (tableRecords.Read())
                {
                    String strRecord = "";
                    for (int i = 0; i < tableRecords.FieldCount; i++)
                    {
                        strRecord += tableRecords[i].ToString() + splitToken;
                    }
                    fileWriter.WriteLine(strRecord);
                }

                fileWriter.Flush();
                fileWriter.Close();
            }
            catch (System.Exception eFile)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(eFile.Message);
                return false;
            }

            return true;
        }

        private void btnImportDiveList_Click(object sender, EventArgs e)
        {
            string strMessage = "You are going to upate this match's dive list by CSV File, Are you sure to do this?";
            string strCaption = "Dive List";
            MessageBoxButtons buttons = MessageBoxButtons.YesNo;
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMessage, strCaption, buttons, MessageBoxIcon.Question) == DialogResult.No)
            {
                return;
            }

            OpenFileDialog DlgOpenFile = new OpenFileDialog();
            DlgOpenFile.ShowDialog();
            String strPath = DlgOpenFile.FileName;
            if (File.Exists(strPath))
            {
                StreamReader sr = new StreamReader(strPath);
                String strLine;
                while ((strLine = sr.ReadLine()) != null)
                {
                    Int32 iResult = DVCommon.g_DVDBManager.ExcuteDV_ImportOneDiveList(m_iCurMatchID, strLine);
                    switch (iResult)
                    {
                        case 0:
                            DevComponents.DotNetBar.MessageBoxEx.Show("Import Dive List Failed!");
                            break;
                        case 1:
                            //DevComponents.DotNetBar.MessageBoxEx.Show("Import Dive List Succeeded!");
                            break;
                        case -1:
                            DevComponents.DotNetBar.MessageBoxEx.Show("Import Dive List Failed! This Match's Status doesn't allow you to do this Operate!");
                            break;
                        case -2:
                            DevComponents.DotNetBar.MessageBoxEx.Show("Import Dive List Failed! This is the Title Info!");
                            break;
                        case -3:
                            DevComponents.DotNetBar.MessageBoxEx.Show("Import Dive List Failed! Invalidate CompetitionPosition!");
                            break;
                        default:
                            break;
                    }
                }

                sr.Close();
            }
            else
            {
                DevComponents.DotNetBar.MessageBoxEx.Show("Please select validated DiveList File!","", MessageBoxButtons.OK);
                return;
            }

            IntiMatchDiveList();
        }

        private void btnUpdateDofDByHeight_Click(object sender, EventArgs e)
        {
            string strMessage = "You are going to upate this match's dive list by this match's Height, Are you sure to do this?";
            string strCaption = "Dive List";
            MessageBoxButtons buttons = MessageBoxButtons.YesNo;
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMessage, strCaption, buttons, MessageBoxIcon.Question) == DialogResult.No)
            {
                return;
            }


            Int32 iResult = DVCommon.g_DVDBManager.ExcuteDV_UpdateDofDByHeight(m_iCurMatchID);
            switch (iResult)
            {
                case 0:
                    DevComponents.DotNetBar.MessageBoxEx.Show("Update Dive List by this match's Height Failed!");
                    break;
                case 1:
                    //DevComponents.DotNetBar.MessageBoxEx.Show("Update Dive List by this match's Height Succeeded!");
                    break;
                case -1:
                    DevComponents.DotNetBar.MessageBoxEx.Show("Update Dive List by this match's Height Failed! This Match's Status doesn't allow you to do this Operate!");
                    break;
                default:
                    break;
            }

            IntiMatchDiveList();
        }

        private void btnUpdateFixDofD_Click(object sender, EventArgs e)
        {
            string strMessage = "You are going to upate this match's fix dive's Degree of Difficulty, Are you sure to do this?";
            string strCaption = "Dive List";
            MessageBoxButtons buttons = MessageBoxButtons.YesNo;
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMessage, strCaption, buttons, MessageBoxIcon.Question) == DialogResult.No)
            {
                return;
            }


            Int32 iResult = DVCommon.g_DVDBManager.ExcuteDV_UpdateFixDiveDofD(m_iCurMatchID);
            switch (iResult)
            {
                case 0:
                    DevComponents.DotNetBar.MessageBoxEx.Show("upate this match's fix dive's Degree of Difficulty Failed!");
                    break;
                case 1:
                    //DevComponents.DotNetBar.MessageBoxEx.Show("upate this match's fix dive's Degree of Difficulty Succeeded!");
                    break;
                case -1:
                    DevComponents.DotNetBar.MessageBoxEx.Show("upate this match's fix dive's Degree of Difficulty Failed! This Match's Status doesn't allow you to do this Operate!");
                    break;
                default:
                    break;
            }

            IntiMatchDiveList();
        }

        private void btnCopyFromPrevious_Click(object sender, EventArgs e)
        {
            string strMessage = "You are going to upate this match's Dive List by copy from previous match, Are you sure to do this?";
            string strCaption = "Dive List";
            MessageBoxButtons buttons = MessageBoxButtons.YesNo;
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMessage, strCaption, buttons, MessageBoxIcon.Question) == DialogResult.No)
            {
                return;
            }


            CopyPreviousDiveListForm frmCopyPreviousDiveList = new CopyPreviousDiveListForm();

            frmCopyPreviousDiveList.m_iCurMatchID = m_iCurMatchID;
            frmCopyPreviousDiveList.m_iSportID = m_iSportID;
            frmCopyPreviousDiveList.m_iDisciplineID = m_iDisciplineID;
            frmCopyPreviousDiveList.m_strLanguageCode = "ENG";

            if (frmCopyPreviousDiveList.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                Int32 iPreviousMatchID = 0;
                iPreviousMatchID = frmCopyPreviousDiveList.m_iSelectedMatchID;

                Int32 iResult = DVCommon.g_DVDBManager.ExcuteDV_CopyDiveListFromPrevious(m_iCurMatchID, iPreviousMatchID);
                switch (iResult)
                {
                    case 0:
                        DevComponents.DotNetBar.MessageBoxEx.Show("upate this match's Dive List by copy from previous match Failed!");
                        break;
                    case 1:
                        //DevComponents.DotNetBar.MessageBoxEx.Show("upate this match's Dive List by copy from previous match Succeeded!");
                        break;
                    case -1:
                        DevComponents.DotNetBar.MessageBoxEx.Show("upate this match's Dive List by copy from previous match Failed! This Match's Status doesn't allow you to do this Operate!");
                        break;
                    default:
                        break;
                }
            }

            IntiMatchDiveList();
        }
    }
}
