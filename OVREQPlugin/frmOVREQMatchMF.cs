using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Collections;
using DevComponents.DotNetBar;
using DevComponents.DotNetBar.Controls;
using System.Data.SqlClient;
using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
    public partial class OVREQMatchMF : UIForm
    {
        #region Property
        private int m_iMatchConfigID;
        public int MatchConfigID
        {
            get { return m_iMatchConfigID; }
            set { m_iMatchConfigID = value; }
        }

        private string m_strMatchConfigCode;
        public string MatchConfigCode
        {
            get { return m_strMatchConfigCode; }
            set { m_strMatchConfigCode = value; }
        }

        private string m_strMatchRuleCode;
        public string MatchRuleCode
        {
            get { return m_strMatchRuleCode; }
            set { m_strMatchRuleCode = value; }
        }

        private String m_strLanguageCode = "ENG";
        public String LanguageCode
        {
            get { return m_strLanguageCode; }
            set { m_strLanguageCode = value; }
        }
        #endregion

        #region Constructor
        public OVREQMatchMF()
        {
            InitializeComponent();
            Localization();
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchMF);
        }

        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "OVREQMatchMF");
        }
        #endregion

        #region FormLoad
        private void OVREQMatchMF_Load(object sender, EventArgs e)
        {
            OVRDataBaseUtils.FillDataGridViewWithCmb(this.dgvMatchMF, GVAR.g_EQDBManager.GetMatchMFs(MatchConfigID), "F_MFLongName", "F_MovementType");

            //设置列标题名
            this.dgvMatchMF.Columns["F_MFCode"].HeaderText = "Order";
            this.dgvMatchMF.Columns["F_MFCodeDes"].HeaderText = "Code";
            this.dgvMatchMF.Columns["F_MFLongName"].HeaderText = "Description";
            this.dgvMatchMF.Columns["F_Coefficient"].HeaderText = "Coefficient";
            this.dgvMatchMF.Columns["F_MovementType"].HeaderText = "Type";
            this.dgvMatchMF.Columns["F_SubFences"].HeaderText = "SubFences";
            this.dgvMatchMF.Columns["F_SubFencesDes"].HeaderText = "SubFencesDes";

            //列宽

            //可编辑
            this.dgvMatchMF.Columns["F_MFCodeDes"].ReadOnly = false;
            this.dgvMatchMF.Columns["F_Coefficient"].ReadOnly = false;
            this.dgvMatchMF.Columns["F_SubFences"].ReadOnly = false;
            this.dgvMatchMF.Columns["F_SubFencesDes"].ReadOnly = false;

            //隐藏列
            this.dgvMatchMF.Columns["F_MatchConfigID"].Visible = false;
            this.dgvMatchMF.Columns["F_MFID"].Visible = false;

            //如果是盛装舞步
            if (MatchRuleCode.Equals("DR"))
            {
                this.dgvMatchMF.Columns["F_SubFences"].Visible = false;
                this.dgvMatchMF.Columns["F_SubFencesDes"].Visible = false;
                btnx_MF.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_Movement");
                this.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "OVREQMatchMovement");

            }
            else
            {
                this.dgvMatchMF.Columns["F_Coefficient"].Visible = false;
                this.dgvMatchMF.Columns["F_MovementType"].Visible = false;
                btnx_MF.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_Fence");
                this.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "OVREQMatchFence");
            }
        }
        #endregion

        #region MatchMF DGV

        private void InitMovementTypeCombBox(ref UIDataGridView GridCtrl, Int32 iColumnIndex)
        {
            DataTable dtMovementType = new DataTable();
            dtMovementType.Columns.Add("Value");
            DataRow drMovementType;
            drMovementType = dtMovementType.NewRow();
            drMovementType[0] = "M";
            dtMovementType.Rows.Add(drMovementType);
            drMovementType = dtMovementType.NewRow();
            drMovementType[0] = "C";
            dtMovementType.Rows.Add(drMovementType);

            //往combobox添加item
            (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dtMovementType, 0, 0);
            dtMovementType.Dispose();
        }

        private void dgvMatchMF_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            Int32 iMFCode = Convert.ToInt32(dgvMatchMF.Rows[iRowIndex].Cells["F_MFCode"].Value.ToString());
            String strColumnName = dgvMatchMF.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvMatchMF.Rows[iRowIndex].Cells[iColumnIndex];
            if (CurCell != null)
            {
                Int32 iInputValue = 1;
                Int32 iInputKey = 0;
                String strInputString = "";

                //基于列进行判断
                if(strColumnName.CompareTo("F_MovementType")==0)
                {
                    strInputString = "'" + CurCell.Value.ToString() + "'";
                    GVAR.g_EQDBManager.UpdateMovementType(MatchConfigID, iMFCode, strInputString);
                }
                if (strColumnName.CompareTo("F_MFLongName") == 0)
                {
                    DGVCustomComboBoxCell CurCell1 = CurCell as DGVCustomComboBoxCell;
                    iInputKey = Convert.ToInt32(CurCell1.Tag);
                    GVAR.g_EQDBManager.UpdateMatchMFLongName(MatchConfigID, iMFCode, iInputKey);

                }
                if (strColumnName.CompareTo("F_SubFencesDes") == 0||strColumnName.CompareTo("F_MFCodeDes") == 0)
                {
                    strInputString = "'" + CurCell.Value.ToString() + "'";
                    GVAR.g_EQDBManager.UpdateMatchMF(MatchConfigID, iMFCode, strColumnName, strInputString);
                }
                if (strColumnName.CompareTo("F_SubFences") == 0 || strColumnName.CompareTo("F_Coefficient") == 0)
                {
                    if (CurCell.Value != null)
                    {
                        strInputString = CurCell.Value.ToString();
                        try
                        {
                            iInputValue = Convert.ToInt32(CurCell.Value);
                        }
                        catch (System.Exception ex)
                        {
                            iInputValue = 1;
                            DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
                        }
                    }
                    else
                    {
                        iInputValue = 1;
                    }
                    GVAR.g_EQDBManager.UpdateMatchMF(MatchConfigID, iMFCode, strColumnName, iInputValue);
                }
                //如果舞步系数修改，则同时更新config中的MaxMovementScore
                if (m_strMatchRuleCode.Equals("DR")&&strColumnName.CompareTo("F_Coefficient") == 0)
                {
                    GVAR.g_EQDBManager.UpdateMatchMaxMovementScore(MatchConfigID);
                }
            }
        }

        private void dgvMatchMF_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            //当编辑combobox时，初始化列表
            if (dgvMatchMF.Columns[e.ColumnIndex] is DGVCustomComboBoxColumn)
            {
                Int32 iRowIndex = e.RowIndex;
                Int32 iColumnIndex = e.ColumnIndex;

                String strLanguageCode = m_strLanguageCode;
                //初始化舞步下拉列表
                if (dgvMatchMF.Columns[iColumnIndex].Name.CompareTo("F_MFLongName") == 0)
                {
                    GVAR.g_EQDBManager.InitMFLongNameCombBox(ref dgvMatchMF, iColumnIndex, MatchConfigID, strLanguageCode);
                }
                //初始化舞步类型下拉列表
                if (dgvMatchMF.Columns[iColumnIndex].Name.CompareTo("F_MovementType") == 0)
                {
                    InitMovementTypeCombBox(ref dgvMatchMF, iColumnIndex);
                }
            }
        }

        #endregion

        #region ButtonClick
        private void btnx_MF_Click(object sender, EventArgs e)
        {

            OVRDesInfoListForm frmOVRMFDesInfoList = new OVRDesInfoListForm(this.Name);
            frmOVRMFDesInfoList.MatchConfigID = MatchConfigID;
            frmOVRMFDesInfoList.DBConnect = GVAR.g_adoDataBase.DBConnect;
            frmOVRMFDesInfoList.m_emInfoType = EMInfoType.emMF;
            frmOVRMFDesInfoList.LanguageCode = m_strLanguageCode;
            frmOVRMFDesInfoList.ShowDialog();

            //InitMFCombox();


        }
        #endregion
    }
}