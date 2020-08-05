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
using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
    public enum EMInfoType
    {
        emUnKnown = -1,
        emNation = 0,
        emClub = 1,
        emColor = 2,
        emFederation = 3,
        emNOC = 4,
        emDelegation = 5,
        emMF =6,
    }

    public partial class OVRDesInfoListForm : UIForm
    {
        #region Property
        private SqlConnection m_dbConnect;
        public SqlConnection DBConnect
        {
            get { return m_dbConnect; }
            set { m_dbConnect = value; }
        }

        public EMInfoType m_emInfoType = EMInfoType.emUnKnown;

        private string m_strLanguageCode = "";
        public string LanguageCode
        {
            get { return m_strLanguageCode; }
            set { m_strLanguageCode = value; }
        }

        private string strInfoValue = "";
        private int m_iSelRowIdx = -1;

        private int m_iMatchConfigID;
        public int MatchConfigID
        {
            get { return m_iMatchConfigID; }
            set { m_iMatchConfigID = value; }
        }

        private bool m_bModified = false;
        #endregion

        #region Constructor
        public OVRDesInfoListForm(string strName)
        {
            InitializeComponent();
            this.Name = strName;
            Localization();
            
        }

        private void Localization()
        {
            //this.Text = LocalizationRecourceManager.GetString(this.Name, "InfoListFrm");
            this.lbLanguage.Text = LocalizationRecourceManager.GetString(this.Name, "lbLanguage");

            switch (Convert.ToInt32(m_emInfoType))
            {
                case 6:
                    strInfoValue = LocalizationRecourceManager.GetString("OVREQPlugin", "lbListInfo_MF");
                    break;
            }
            this.Text = strInfoValue;
        }
        #endregion

        #region FormLoad
        private void OVRDesInfoListForm_Load(object sender, EventArgs e)
        {
            InitLanguageCombBox();
            InitGridStyle();
            switch(Convert.ToInt32(m_emInfoType))
            {
                case 6:
                    FillInfoGridOfMF();
                    break;
                default:
                    break;
            }
        }

        private void InitGridStyle()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvInfo);
            dgvInfo.RowHeadersVisible = true;
        }

        private void InitLanguageCombBox()
        {
            if (m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for lbLanguage Combo
                SqlCommand cmd = new SqlCommand("Proc_GetLanguageCode", m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataReader dr = cmd.ExecuteReader();
                #endregion

                GVAR.FillCombox(cmbLanguage, dr, 0, 1, m_strLanguageCode);
                dr.Close();
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }
        #endregion

        #region FormClosed
        private void OVRDesInfoListForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            if (m_bModified)
                this.DialogResult = DialogResult.OK;
        }
        #endregion

        #region EventHandler
        private void cmbLanguage_SelectionChangeCommitted(object sender, EventArgs e)
        {
            if (cmbLanguage.SelectedItem == null)
                return;

            int iSelectIdx = cmbLanguage.SelectedIndex;
            m_strLanguageCode = ((OVRCustomComboBoxItem)cmbLanguage.Items[iSelectIdx]).Value.ToString();
            switch (Convert.ToInt32(m_emInfoType))
            {
                case 6:
                    FillInfoGridOfMF();
                    break;
                default:
                    break;
            }
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            OVRDesInfoEditForm frmDesInfoEdit = new OVRDesInfoEditForm(this.Name);
            frmDesInfoEdit.MatchConfigID = MatchConfigID;
            frmDesInfoEdit.DBConnect = DBConnect;
            frmDesInfoEdit.OperateType = 1;
            frmDesInfoEdit.m_emInfoType = m_emInfoType;
            frmDesInfoEdit.LanguageCode = m_strLanguageCode;
            frmDesInfoEdit.ShowDialog();
          
            if (frmDesInfoEdit.DialogResult == DialogResult.OK)
            {
                m_bModified = true;

                m_iSelRowIdx = dgvInfo.Rows.Count;
                switch (Convert.ToInt32(m_emInfoType))
                {
                    case 6:
                        FillInfoGridOfMF();
                        return;
                    default:
                        break;
                }
            }
        }

        private void btnDel_Click(object sender, EventArgs e)
        {
            if (dgvInfo.SelectedRows.Count < 1)
                return;

            int nRowIdx = dgvInfo.SelectedRows[0].Index;

            string strMsgBox = LocalizationRecourceManager.GetString("OVRRegisterInfo", "DelInfoMsgBox");
            if (DevComponents.DotNetBar.MessageBoxEx.Show(strMsgBox, "", MessageBoxButtons.YesNo) != DialogResult.Yes)
                return;

            int iInfoID = 0;
            iInfoID = Convert.ToInt32(dgvInfo.Rows[nRowIdx].Cells["ID"].Value);

            if (nRowIdx == dgvInfo.Rows.Count - 1)
            {
                m_iSelRowIdx = nRowIdx - 1;
            }
            else
            {
                m_iSelRowIdx = nRowIdx;
            }
            switch (Convert.ToInt32(m_emInfoType))
            {
                case 6:
                    DelInfoOfMF(iInfoID);
                    FillInfoGridOfMF();
                    break;
                default:
                    break;
            }
        }

        private void btnEdit_Click(object sender, EventArgs e)
        {
            if (dgvInfo.SelectedRows.Count <= 0)
                return;

            OVRDesInfoEditForm frmDesInfoEdit = new OVRDesInfoEditForm(this.Name);
            frmDesInfoEdit.DBConnect = DBConnect;
            frmDesInfoEdit.OperateType = 2;
            frmDesInfoEdit.m_emInfoType = m_emInfoType;
            frmDesInfoEdit.LanguageCode = m_strLanguageCode;
           
            int nRowIdx = dgvInfo.SelectedRows[0].Index;
            if (m_emInfoType == EMInfoType.emMF)
            {
                frmDesInfoEdit.InfoID = Convert.ToInt32(dgvInfo.Rows[nRowIdx].Cells["ID"].Value);

                frmDesInfoEdit.LongName = dgvInfo.Rows[nRowIdx].Cells["Long Name"].Value.ToString();
                frmDesInfoEdit.ShortName = dgvInfo.Rows[nRowIdx].Cells["Short Name"].Value.ToString();
                frmDesInfoEdit.Comment = dgvInfo.Rows[nRowIdx].Cells["Comment"].Value.ToString();
            }
            frmDesInfoEdit.ShowDialog();

            if (frmDesInfoEdit.DialogResult == DialogResult.OK)
            {
                m_bModified = true;

                m_iSelRowIdx = nRowIdx;
                switch (Convert.ToInt32(m_emInfoType))
                {
                    case 6:
                        FillInfoGridOfMF();
                        return;
                }
            }
        }
        #endregion

        #region DataBase Functions

        private void FillInfoGridOfMF()
        {
            if (m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for NOC Info
                SqlCommand cmd = new SqlCommand("Proc_EQ_GetMFList", m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter0 = new SqlParameter("@MatchConfigID", SqlDbType.Int);
                SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
                cmdParameter0.Value = MatchConfigID;
                cmd.Parameters.Add(cmdParameter0);
                cmdParameter1.Value = m_strLanguageCode;
                cmd.Parameters.Add(cmdParameter1);
                SqlDataReader dr = cmd.ExecuteReader();
                #endregion

                OVRDataBaseUtils.FillDataGridView(dgvInfo, dr, null, null);
                dr.Close();
                //隐藏ID列
                dgvInfo.Columns[0].Visible = false;
                if (dgvInfo.Rows.Count > 0)
                {
                    if (m_iSelRowIdx < 0)
                    {
                        return;
                    }
                    else if (m_iSelRowIdx > dgvInfo.RowCount - 1)
                    {
                        m_iSelRowIdx = dgvInfo.RowCount - 1;
                    }
                    dgvInfo.Rows[m_iSelRowIdx].Selected = true;
                    dgvInfo.FirstDisplayedScrollingRowIndex = m_iSelRowIdx;
                }

            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
        }

        private bool DelInfoOfMF(int nInfoID)
        {
            if (m_dbConnect.State == System.Data.ConnectionState.Closed)
            {
                m_dbConnect.Open();
            }

            try
            {
                #region DML Command Setup for Del Color

                SqlCommand cmd = new SqlCommand("Proc_EQ_DelMF", m_dbConnect);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter("@MFID", SqlDbType.Int);
                SqlParameter cmdParameter2 = new SqlParameter("@Result", SqlDbType.Int);
                cmdParameter1.Value = nInfoID;
                cmdParameter2.Direction = ParameterDirection.Output;

                cmd.Parameters.Add(cmdParameter1);
                cmd.Parameters.Add(cmdParameter2);
                cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;
                #endregion

                cmd.ExecuteNonQuery();
                int nRetValue = (int)cmdParameter2.Value;
                string strPromotion;
                switch (nRetValue)
                {
                    case 0:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "FailedMsgBox");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -1:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelFailed_ID");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    case -2:
                        strPromotion = LocalizationRecourceManager.GetString(this.Name, "DelMF_Used");
                        DevComponents.DotNetBar.MessageBoxEx.Show(strPromotion);
                        return false;
                    default://其余的为修改成功
                        m_bModified = true;
                        return true;
                }
            }
            catch (System.Exception e)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
            }
            return false;
        }

        #endregion

    }
}