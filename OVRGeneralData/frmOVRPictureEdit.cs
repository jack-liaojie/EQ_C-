using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.IO;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.Data.SqlClient;
using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRGeneralData
{
    public partial class OVRPictureEditForm : UIForm
    {
        private System.Data.SqlClient.SqlConnection sqlConnection;
        public System.Data.SqlClient.SqlConnection DatabaseConnection
        {
            get { return sqlConnection; }
            set { sqlConnection = value; }
        }

        private int m_iSelPicRowIndex = -1;
        private bool m_bUpdate = false;
        public OVRPictureEditForm()
        {
            InitializeComponent();
            InitGridStyle();
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(this.Name, "frmOVRPictureEdit");
            btnImport.Tooltip = LocalizationRecourceManager.GetString(this.Name, "btnImport");
            btnExport.Tooltip = LocalizationRecourceManager.GetString(this.Name, "btnExport");
            btnNewPic.Tooltip = LocalizationRecourceManager.GetString(this.Name, "btnNewPic");
            btnDeletePic.Tooltip = LocalizationRecourceManager.GetString(this.Name, "btnDeletePic");
        }

        private void frmOVRPictureEdit_Load(object sender, EventArgs e)
        {
            Localization();
            ResetPictureGrid();
        }

        private void InitGridStyle()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvPicture);
            //dgvPicture.RowHeadersVisible = true;
        }
        private void ResetPictureGrid()
        {
            if (this.DatabaseConnection.State == System.Data.ConnectionState.Closed)
            {
                this.DatabaseConnection.Open();
            }

            try
            {
                int iFirstDisplayedScrollingRowIndex = dgvPicture.FirstDisplayedScrollingRowIndex;
                int iFirstDisplayedScrollingColumnIndex = dgvPicture.FirstDisplayedScrollingColumnIndex;
                if (iFirstDisplayedScrollingRowIndex < 0) iFirstDisplayedScrollingRowIndex = 0;
                if (iFirstDisplayedScrollingColumnIndex < 0) iFirstDisplayedScrollingColumnIndex = 0;

                #region DML Command Setup for Get Picture List

                SqlCommand cmd = new SqlCommand("Proc_GetPictureInfo", this.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataReader dr = cmd.ExecuteReader();
                m_bUpdate = true;
                OVRDataBaseUtils.FillDataGridView(dgvPicture, dr, null, null);
                m_bUpdate = false;
                dr.Close();

                #endregion


                if (dgvPicture.Columns.Count <= 0) return;

                dgvPicture.Columns["FileCode"].ReadOnly = false;
                dgvPicture.Columns["FileComment"].ReadOnly = false;
                dgvPicture.Columns["FileType"].ReadOnly = false;
                dgvPicture.Columns["ID"].Visible = false;

                dgvPicture.ClearSelection();
                if (m_iSelPicRowIndex >= 0 && m_iSelPicRowIndex < dgvPicture.Rows.Count)
                {
                    dgvPicture.Rows[m_iSelPicRowIndex].Selected = true;
                }

                if (iFirstDisplayedScrollingRowIndex < dgvPicture.Rows.Count)
                    dgvPicture.FirstDisplayedScrollingRowIndex = iFirstDisplayedScrollingRowIndex;
                if (dgvPicture.FirstDisplayedScrollingColumnIndex < iFirstDisplayedScrollingColumnIndex &&
                    iFirstDisplayedScrollingColumnIndex < dgvPicture.Columns.Count)
                    dgvPicture.FirstDisplayedScrollingColumnIndex = iFirstDisplayedScrollingColumnIndex;
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private void dgvPicture_SelectionChanged(object sender, EventArgs e)
        {
            if (m_bUpdate || dgvPicture.SelectedRows.Count < 1)
                return;

            int irow = dgvPicture.SelectedRows[0].Index;
            m_iSelPicRowIndex = irow;
            int iSelPictureID = Convert.ToInt32(dgvPicture.Rows[irow].Cells["ID"].Value);

            String strSQLDes = string.Format("SELECT F_FileInfo FROM TC_PicFile_Info WHERE F_FileID = '{0}'", iSelPictureID);
            SqlCommand cmd = new SqlCommand(strSQLDes, this.DatabaseConnection);

            SqlDataReader dr = null;

            try
            {
                dr = cmd.ExecuteReader();
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        if (!(dr[0] is DBNull))
                        {
                            //将值强转为byte数组
                            byte[] MyData = (byte[])dr[0];

                            //将byte[]数组写入到流中

                            MemoryStream s = new MemoryStream();
                            s.Write(MyData, 0, MyData.Length);

                            //pictureBox加载得到的流
                            pictureBox.Image = Image.FromStream(s);
                            pictureBox.SizeMode = PictureBoxSizeMode.Zoom;
                        }
                        else
                        {
                            pictureBox.Image = null;
                        }
                    }
                }
                dr.Close();
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);

                if (dr != null && !dr.IsClosed)
                    dr.Close();
            }

             
        }

        private void btnNewPic_Click(object sender, EventArgs e)
        {
            string strPicPath = "";
            OpenFileDialog ofd = new OpenFileDialog();

            bool bImport = false;
            //选择图片后，点击确定按钮，加载图片



            if (ofd.ShowDialog() == DialogResult.OK)
            {
                bImport = true;
                strPicPath = ofd.FileName;
            }

            if (!bImport)
                return;

            FileStream fs = File.Open(strPicPath, FileMode.Open, FileAccess.Read);
            //将流转化为byte数组
            byte[] MyData = new byte[fs.Length];
            fs.Read(MyData, 0, MyData.Length);
            fs.Close();

            try
            {
                #region DML Command Setup for Insert Picture

                SqlCommand cmd = new SqlCommand("Proc_InsertPicture", this.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter1 = new SqlParameter("@PictureValue", SqlDbType.Binary);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmdParameter1.Value = MyData;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameterResult.Value;
                String strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    default://其余的为添加成功
                        m_iSelPicRowIndex = dgvPicture.Rows.Count;
                        ResetPictureGrid();
                        break;
                }

            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }


        private void btnDeletePic_Click(object sender, EventArgs e)
        {
            if (dgvPicture.SelectedRows.Count < 1)
            {
                return;
            }

            string strMsgBox;
            strMsgBox = LocalizationRecourceManager.GetString(this.Name, "DeleteMsgBox");

            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
            {
                return;
            }

            int irow = dgvPicture.SelectedRows[0].Index;
            if(irow == dgvPicture.Rows.Count -1)
            {
                if(dgvPicture.Rows.Count == 1)
                {
                    m_iSelPicRowIndex = -1;
                }
                else
                {
                    m_iSelPicRowIndex = dgvPicture.Rows.Count -2;
                }
            }
            else
            {
                m_iSelPicRowIndex = irow;
            }
            int iSelPicID = Convert.ToInt32(dgvPicture.Rows[irow].Cells["ID"].Value);

            try
            {
                #region DML Command Setup for Insert Picture

                SqlCommand cmd = new SqlCommand("Proc_DeletePicture", this.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@PictureID", SqlDbType.Int);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);
                cmdParameter1.Value = iSelPicID;
                cmdParameterResult.Direction = ParameterDirection.Output;
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameterResult);
                #endregion

                string strPromotion;
                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameterResult.Value;
                switch (nRetValue)
                {
                    case 0:
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    default://其余的为修改成功
                        ResetPictureGrid();
                        break;
                }
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void btnImport_Click(object sender, EventArgs e)
        {
            if (dgvPicture.SelectedRows.Count < 1)
                return;

            string  strPicPath = "";
            OpenFileDialog ofd = new OpenFileDialog();

            bool bImport = false;
            //选择图片后，点击确定按钮，加载图片


            if (ofd.ShowDialog() == DialogResult.OK)
            {
                bImport = true;
                strPicPath = ofd.FileName;
            }

            if (!bImport)
                return;

            FileStream fs = File.Open(strPicPath, FileMode.Open, FileAccess.Read);
            //将流转化为byte数组
            byte[] MyData = new byte[fs.Length];
            fs.Read(MyData, 0, MyData.Length);
            fs.Close();



            int irow = dgvPicture.SelectedRows[0].Index;
            int iSelPicID = Convert.ToInt32(dgvPicture.Rows[irow].Cells["ID"].Value);

            try
            {
                #region DML Command Setup for Update Picture

                SqlCommand cmd = new SqlCommand("Proc_UpdatePicture", this.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter1 = new SqlParameter("@PictureID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@PictureValue", SqlDbType.Binary);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmdParameter1.Value = iSelPicID;
                cmdParameter2.Value = MyData;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameterResult.Value;
                String strPromotion;
                switch (nRetValue)
                {
                    case 0:
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    default://其余的为修改成功
                        ResetPictureGrid();
                        break;
                }
     
            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }

        }

        private void btnExport_Click(object sender, EventArgs e)
        {
            if (dgvPicture.SelectedRows.Count < 1)
            {
                return;
            }

            int irow = dgvPicture.SelectedRows[0].Index;
            int iSelPicID = Convert.ToInt32(dgvPicture.Rows[irow].Cells["ID"].Value);
            String strFileType = dgvPicture.Rows[irow].Cells["FileType"].Value.ToString();

            if (pictureBox.Image == null)
            {
                return;
            }
            Image image = pictureBox.Image;

            String strPicPath = "";
            String strFilter;
            strFilter = String.Format("{0} files(*.{0})|*.{0}", strFileType);
            SaveFileDialog ofd = new SaveFileDialog();
            ofd.Filter = strFilter;   
            bool bExport = false;
            //选择图片后，点击确定按钮，保存图片


            if (ofd.ShowDialog() == DialogResult.OK)
            {
                bExport = true;
                strPicPath = ofd.FileName;
            }

            if (!bExport)
                return;
            image.Save(strPicPath);
        }

        private void dgvPicture_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (dgvPicture.SelectedRows.Count < 1)
            {
                return;
            }

            int irow = dgvPicture.SelectedRows[0].Index;
            m_iSelPicRowIndex = irow;
            int iSelPictureID = Convert.ToInt32(dgvPicture.Rows[irow].Cells["ID"].Value);

            String strPicCode = dgvPicture.Rows[irow].Cells["FileCode"].Value.ToString();
            String strPicComment = dgvPicture.Rows[irow].Cells["FileComment"].Value.ToString();
            String strPicType = dgvPicture.Rows[irow].Cells["FileType"].Value.ToString();

            try
            {
                #region DML Command Setup for Update Picture

                SqlCommand cmd = new SqlCommand("Proc_UpdatePictureInfo", this.DatabaseConnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter cmdParameter1 = new SqlParameter("@PictureID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@PictureCode", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter3 = new SqlParameter("@PictureComment", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameter4 = new SqlParameter("@PictureType", SqlDbType.NVarChar, 50);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);
                cmdParameterResult.Direction = ParameterDirection.Output;

                cmdParameter1.Value = iSelPictureID;
                cmdParameter2.Value = strPicCode;
                cmdParameter3.Value = strPicComment;
                cmdParameter4.Value = strPicType;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.Parameters.Add(cmdParameter3);
                cmd.Parameters.Add(cmdParameter4);
                cmd.Parameters.Add(cmdParameterResult);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameterResult.Value;
                String strPromotion;
                switch (nRetValue)
                {
                    case 0:
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        break;
                    default://其余的为修改成功
                        ResetPictureGrid();
                        break;
                }

            }
            catch (System.Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }
    }
}