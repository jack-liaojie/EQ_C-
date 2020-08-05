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
using System.IO;
using Sunny.UI;

namespace AutoSports.OVRDrawArrange
{
    public partial class SetEventModelForm : UIForm
    {
        public Int32 m_iEventID { get; set; }
        public Int32 m_iOpearateTypeID { get; set; }//0表示操作未指定，1表示参数化创建模型，2表示使用自定义模板。
        public String m_strLanguageCode { get; set; }
        public SqlConnection m_DatabaseConnection { get; set; }

        private string m_strSectionName = "OVRDrawArrange";

        public SetEventModelForm()
        {
            InitializeComponent();
            Localization();
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvModels);

            m_iOpearateTypeID = 0;
            this.dgvModels.Enabled = false;
            this.btnImportEventModel.Enabled = false;
            this.btnExportEventModel.Enabled = false;
            this.btnDelEventModel.Enabled = false;
            this.RadioByParameter.Checked = true;
        }

        protected override void OnShown(EventArgs e)
        {
            base.OnShown(e);
            FillModels();
        }

        private void FillModels()
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "Proc_GetModels";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                OVRDataBaseUtils.FillDataGridViewWithCmb(dgvModels, sdr, "");
                dgvModels.AutoResizeColumns();
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            if (m_iOpearateTypeID == 2)
            {
                Int32 iModelID;
                Int32 iRow;
                if (dgvModels.SelectedRows == null || dgvModels.SelectedRows.Count == 0)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgLoadEventModel1"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }
                else
                {
                    string message = LocalizationRecourceManager.GetString(m_strSectionName, "MsgLoadEventModel2");
                    string caption = "Draw Arrange";
                    MessageBoxButtons buttons = MessageBoxButtons.YesNo;
                    if (DevComponents.DotNetBar.MessageBoxEx.Show(message, caption, buttons, MessageBoxIcon.Question) == DialogResult.Yes)
                    {
                        iRow = dgvModels.SelectedRows[0].Index;
                        iModelID = GetFieldValue(dgvModels, iRow, "F_ModelID");
                    }
                    else
                    {
                        return;
                    }
                }

                try
                {
                    Int32 iResult;
                    SqlCommand oneSqlCommand = new SqlCommand();
                    oneSqlCommand.Connection = m_DatabaseConnection;
                    oneSqlCommand.CommandText = "proc_SetEventModelFromModel";
                    oneSqlCommand.CommandType = CommandType.StoredProcedure;

                    SqlParameter cmdParameter1 = new SqlParameter(
                                 "@EventID", SqlDbType.Int, 4,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, m_iEventID);
                    oneSqlCommand.Parameters.Add(cmdParameter1);

                    SqlParameter cmdParameter2 = new SqlParameter(
                                 "@ModelID", SqlDbType.Int, 4,
                                 ParameterDirection.Input, true, 0, 0, "",
                                 DataRowVersion.Current, iModelID);
                    oneSqlCommand.Parameters.Add(cmdParameter2);

                    SqlParameter cmdParameterResult = new SqlParameter(
                                "@Result", SqlDbType.Int, 4,
                                ParameterDirection.Output, true, 0, 0, "",
                                DataRowVersion.Current, 0);

                    oneSqlCommand.Parameters.Add(cmdParameterResult);

                    if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                    {
                        m_DatabaseConnection.Open();
                    }

                    if (oneSqlCommand.ExecuteNonQuery() != 0)
                    {
                        iResult = (Int32)cmdParameterResult.Value;
                        switch (iResult)
                        {
                            case 0:
                                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgLoadEventModel3"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.Error);
                                break;
                            default://其余的需要为添加成功！
                                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgLoadEventModel4"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.None);
                                break;
                        }
                    }
                }
                catch (Exception ex)
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                }
            }
            this.DialogResult = DialogResult.OK;
        }

        private void btnCancle_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
        }

        private void RadioByParameter_CheckedChanged(object sender, EventArgs e)
        {
            m_iOpearateTypeID = 1;
            this.dgvModels.Enabled = false;
            this.dgvModels.ForeColor = Color.Gray;
            //this.dgvModels.Columnheader.ForeColor = Color.Gray;
            this.btnImportEventModel.Enabled = false;
            this.btnExportEventModel.Enabled = false;
            this.btnDelEventModel.Enabled = false;
        }

        private void RadioFromModel_CheckedChanged(object sender, EventArgs e)
        {
            m_iOpearateTypeID = 2;
            this.dgvModels.Enabled = true;
            this.dgvModels.ForeColor = Color.Black;
            //this.dgvModels.Columnheader.ForeColor = Color.Gray;
            this.btnImportEventModel.Enabled = true;
            this.btnExportEventModel.Enabled = true;
            this.btnDelEventModel.Enabled = true;
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "frmSetEventModel");
            this.RadioByParameter.Text = LocalizationRecourceManager.GetString(m_strSectionName, "RadioByParameter");
            this.RadioFromModel.Text = LocalizationRecourceManager.GetString(m_strSectionName, "RadioFromModel");
            this.btnOK.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnOK");
            this.btnCancle.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnClose");
            this.btnImportEventModel.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnImportEventModel");
            this.btnDelEventModel.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnDelEventModel");
            this.btnExportEventModel.Tooltip = LocalizationRecourceManager.GetString(m_strSectionName, "btnExportEventModel");
            this.lbModelList.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbModelList");
        }

        private void btnImportEventModel_Click(object sender, EventArgs e)
        {
            try
            {
                String strInPut = "";
                OpenFileDialog DlgOpenFile = new OpenFileDialog();
                DlgOpenFile.ShowDialog();
                String strPath = DlgOpenFile.FileName;
                if (File.Exists(strPath))
                {
                    StreamReader sr = new StreamReader(strPath);
                    String strLine;
                    while ((strLine = sr.ReadLine()) != null)
                    {
                        strInPut = strInPut + strLine;
                    }

                    sr.Close();
                }
                else
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgImportEventModel1"));
                    return;
                }

                Int32 iResult;

                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "proc_ImportModelFromXML";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@ModelName", SqlDbType.NVarChar, 100,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@ModelComment", SqlDbType.NVarChar, 200,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, DBNull.Value);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@ModelXML", SqlDbType.NVarChar, 9000000,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strInPut);
                oneSqlCommand.Parameters.Add(cmdParameter3);


                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iResult = Convert.ToInt32(cmdParameterResult.Value);
                    switch (iResult)
                    {
                        case 0:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgImportEventModel2"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            break;
                        default://其余的需要为添加成功！
                            FillModels();
                            break;
                    }
                }

            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnExportEventModel_Click(object sender, EventArgs e)
        {
            Int32 iModelID;
            Int32 iRow;
            String strPath;
            String strFileName;
            if (dgvModels.SelectedRows == null || dgvModels.SelectedRows.Count == 0)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgExportEventModel1"));
                return;
            }
            else
            {
                iRow = dgvModels.SelectedRows[0].Index;
                iModelID = GetFieldValue(dgvModels, iRow, "F_ModelID");
                strFileName = GetFieldStringValue(dgvModels, iRow, "F_ModelName");
                FolderBrowserDialog DlgFolderBrowser = new FolderBrowserDialog();
                DlgFolderBrowser.ShowDialog();
                strPath = DlgFolderBrowser.SelectedPath;
                if (strPath == "")
                {
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgExportEventModel2"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                strPath = strPath + "\\" + strFileName + ".xml";
            }

            try
            {
                String strOutPut;
                SqlCommand oneSqlCommand = new SqlCommand();

                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "proc_CreateModel2XML";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@ModelID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iModelID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@ModelXML", SqlDbType.NVarChar, 9000000,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    strOutPut = Convert.ToString(cmdParameterResult.Value);
                    if (File.Exists(strPath))
                    {
                        File.Delete(strPath);
                    }
                    StreamWriter OneStreamWriter = File.CreateText(strPath);
                    OneStreamWriter.WriteLine(strOutPut);
                    OneStreamWriter.Close();
                    DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgExportEventModel3"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.None);
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message, "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnDelEventModel_Click(object sender, EventArgs e)
        {
            Int32 iModelID;
            Int32 iRow;
            if (dgvModels.SelectedRows == null || dgvModels.SelectedRows.Count == 0)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelEventModel1"));
                return;
            }
            else
            {
                string message = LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelEventModel2");
                if (DevComponents.DotNetBar.MessageBoxEx.Show(message, "Draw Arrange", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                {
                    iRow = dgvModels.SelectedRows[0].Index;
                    iModelID = GetFieldValue(dgvModels, iRow, "F_ModelID");
                }
                else
                {
                    return;
                }
            }

            try
            {
                Int32 iResult;
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = m_DatabaseConnection;
                oneSqlCommand.CommandText = "proc_DelModelByID";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                             "@ModelID", SqlDbType.Int, 4,
                             ParameterDirection.Input, true, 0, 0, "",
                             DataRowVersion.Current, iModelID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);

                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (m_DatabaseConnection.State == System.Data.ConnectionState.Closed)
                {
                    m_DatabaseConnection.Open();
                }

                if (oneSqlCommand.ExecuteNonQuery() != 0)
                {
                    iResult = (Int32)cmdParameterResult.Value;
                    switch (iResult)
                    {
                        case 0:
                            DevComponents.DotNetBar.MessageBoxEx.Show(LocalizationRecourceManager.GetString(m_strSectionName, "MsgDelEventModel3"), "Draw Arrange", MessageBoxButtons.OK, MessageBoxIcon.Question);
                            break;
                        default://其余的需要为添加成功！
                            FillModels();
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
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

        private String GetFieldStringValue(DataGridView dgv, Int32 iRowIndex, String strFiledName)
        {
            String iReturnValue = "";
            if (dgv.Columns[strFiledName] == null || dgv.Rows[iRowIndex].Cells[strFiledName].Value.ToString() == "")
            {
                iReturnValue = "";
            }
            else
            {
                iReturnValue = Convert.ToString(dgv.Rows[iRowIndex].Cells[strFiledName].Value);
            }
            return iReturnValue;
        }
    }
}