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
using System.Text.RegularExpressions;
using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
    public partial class OVREQMatchConfig : UIForm
    {
        #region Property
        private String m_strLanguageCode = "ENG";
        public String LanguageCode
        {
            get { return m_strLanguageCode; }
            set { m_strLanguageCode = value; }
        }

        private int m_iMatchID;
        public int MatchID
        {
            get { return m_iMatchID; }
            set { m_iMatchID = value; }
        }

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
        #endregion

        #region Constructor
        public OVREQMatchConfig()
        {
            InitializeComponent();
            Localization();
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchConfig);
        }

        //initial the text for more languages.
        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "OVREQMatchConfig");
            lb_MatchConfig.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "lb_MatchConfig");
        }
        #endregion

        #region FormLoad
        private void OVREQMatchConfig_Load(object sender, EventArgs e)
        {
            this.dgvMatchConfig.DataSource = GVAR.g_EQDBManager.GetMatchConfig(MatchID);
            //dgvMatchConfig.SelectionMode = DataGridViewSelectionMode.CellSelect;
            //设置列标题名
            for (int i = 0; i < dgvMatchConfig.Columns.Count; i++)
            {
                dgvMatchConfig.Columns[i].HeaderText = dgvMatchConfig.Columns[i].Name.ToString().Substring(2);
            }

            //可编辑
            this.dgvMatchConfig.Columns["F_MatchConfigID"].ReadOnly = true;
            this.dgvMatchConfig.Columns["F_MatchConfigCode"].ReadOnly = true;
            this.dgvMatchConfig.Columns["F_EventCode"].ReadOnly = true;
            this.dgvMatchConfig.Columns["F_PhaseCode"].ReadOnly = true;
            this.dgvMatchConfig.Columns["F_MatchCode"].ReadOnly = true;
            this.dgvMatchConfig.Columns["F_MatchRuleID"].ReadOnly = true;
            this.dgvMatchConfig.Columns["F_MatchRuleCode"].ReadOnly = true;
            this.dgvMatchConfig.Columns["F_EventConfigCode"].ReadOnly = true;

            //根据matchruleid，显示舞步或障碍配置按钮
            if (MatchRuleCode.Equals("DR"))
            {
                this.dgvMatchConfig.Columns["F_Obstacles"].Visible = false;
                this.dgvMatchConfig.Columns["F_Distance"].Visible = false;
                this.dgvMatchConfig.Columns["F_Speed"].Visible = false;
                this.dgvMatchConfig.Columns["F_TimeAllowed"].Visible = false;
                this.dgvMatchConfig.Columns["F_Seconds"].Visible = false;
                this.dgvMatchConfig.Columns["F_Penalties"].Visible = false;
                this.dgvMatchConfig.Columns["F_IsAgainstClock"].Visible = false;
                btnx_MFConfig.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_MovementConfig");
            }
            else 
            {   
                btnx_MFConfig.Text = LocalizationRecourceManager.GetString(GVAR.g_strSectionName, "btnx_FenceConfig");
                if (MatchRuleCode.Equals("ECC"))
                {
                    this.dgvMatchConfig.Columns["F_MAXMovementScore"].Visible = false;
                    this.dgvMatchConfig.Columns["F_Break"].Visible = false;
                }
                if (MatchRuleCode.Equals("JP"))
                {
                    this.dgvMatchConfig.Columns["F_MAXMovementScore"].Visible = false;
                    this.dgvMatchConfig.Columns["F_Break"].Visible = false;
                    this.dgvMatchConfig.Columns["F_RiderInterval"].Visible = false;
                }
            }
        }
        #endregion

        #region MatchConfig DGV
        private void dgvMatchConfig_CellValueChanged(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex < 0 || e.ColumnIndex < 0)
                return;

            Int32 iColumnIndex = e.ColumnIndex;
            Int32 iRowIndex = e.RowIndex;
            String strColumnName = dgvMatchConfig.Columns[iColumnIndex].Name;
            DataGridViewCell CurCell = dgvMatchConfig.Rows[iRowIndex].Cells[iColumnIndex];
            Int32 iInputValue = 0;
            decimal fInputValue = 0;
            String strInputString = "";
            //如果是combobox则保存CurCell的Tag
            if (CurCell.Value == null)
            {
                GVAR.g_EQDBManager.UpdateMatchConfigNull(MatchConfigID, strColumnName);
            }
            else
            {
                if (dgvMatchConfig.Columns[e.ColumnIndex].Name == "F_RiderInterval"
                    || dgvMatchConfig.Columns[e.ColumnIndex].Name == "F_Judge"
                    || dgvMatchConfig.Columns[e.ColumnIndex].Name == "F_Type")
                {
                    strInputString = "'" + CurCell.Value.ToString() + "'";
                    GVAR.g_EQDBManager.UpdateMatchConfig(MatchConfigID, strColumnName, strInputString);
                }
                else if (dgvMatchConfig.Columns[e.ColumnIndex].Name == "F_Penalties")
                {
                    try
                    {
                        fInputValue = Convert.ToDecimal(CurCell.Value);
                    }
                    catch (System.Exception ex)
                    {
                        fInputValue = 0;
                    }
                      GVAR.g_EQDBManager.UpdateMatchConfig(MatchConfigID, strColumnName, fInputValue);
                }
                else if (dgvMatchConfig.Columns[e.ColumnIndex].Name == "F_TimeAllowed" && m_iMatchConfigID == 7)
                {
                    try
                    {
                        iInputValue = GVAR.Str2Int(GVAR.StrTime2Decimal(CurCell.Value).ToString());
                        GVAR.g_EQDBManager.UpdateMatchConfig(MatchConfigID, strColumnName, iInputValue);
                    }
                    catch (System.Exception ex)
                    {
                        GVAR.g_EQDBManager.UpdateMatchConfigNull(MatchConfigID, strColumnName);
                    }
                }
                else
                {
                    try
                    {
                        iInputValue = Convert.ToInt32(CurCell.Value);
                        GVAR.g_EQDBManager.UpdateMatchConfig(MatchConfigID, strColumnName, iInputValue);
                    }
                    catch (System.Exception ex)
                    {
                        GVAR.g_EQDBManager.UpdateMatchConfigNull(MatchConfigID, strColumnName);
                    }
            }
            }

        }

        private void dgvMatchConfig_CellValidating(object sender, DataGridViewCellValidatingEventArgs e)
        {
            if (dgvMatchConfig.Columns[e.ColumnIndex].Name == "F_RiderInterval"
                && e.FormattedValue != null)
            {//DateTime
                DateTime dtOut;
                if (e.FormattedValue.ToString().Length != 0 &&
                    !DateTime.TryParse(e.FormattedValue.ToString(), out dtOut))
                    e.Cancel = true;
            }
            else if (dgvMatchConfig.Columns[e.ColumnIndex].Name == "F_Judge"
                && e.FormattedValue != null)
            {//E,H,C,M,B
                
            }
            else if (dgvMatchConfig.Columns[e.ColumnIndex].Name == "F_Type"
            && e.FormattedValue != null)
            {//text

            }
            else if (dgvMatchConfig.Columns[e.ColumnIndex].Name == "F_Penalties"
                 && e.FormattedValue != null)
            {//float
                float fOut = 0;
                if (e.FormattedValue.ToString().Length != 0 &&
                    !float.TryParse(e.FormattedValue.ToString(), out fOut))
                    e.Cancel = true;
            }
            //else if ((dgvMatchConfig.Columns[e.ColumnIndex].Name == "F_AddResult"
            //    || dgvMatchConfig.Columns[e.ColumnIndex].Name == "F_AddResultTeam")
            //     && e.FormattedValue != null)
            //{//只包含数字,且数字间使用","隔开的字符串
            //    string pattern = @"^([1-9]\d*,)*[1-9]\d*$";
            //    if (e.FormattedValue.ToString().Length != 0 &&
            //        !RegexDao.IsMatch(pattern, e.FormattedValue.ToString()))
            //        e.Cancel = true;
                
            //}
            else if (dgvMatchConfig.Columns[e.ColumnIndex].Name == "F_TimeAllowed"
                 && e.FormattedValue != null
                 && m_iMatchConfigID == 7)
            {
                string pattern = @"^\d{1,2}'\d{2}''$";
                if (e.FormattedValue.ToString().Length != 0 &&
                    !RegexDao.IsMatch(pattern, e.FormattedValue.ToString()))
                    e.Cancel = true;
            }
            else
            {//int
                int nOut;
                if (e.FormattedValue.ToString().Length != 0 &&
                    !int.TryParse(e.FormattedValue.ToString(), out nOut))
                    e.Cancel = true;
            }
        }
        #endregion

        #region ButtonClick
        private void btnx_MFs_Click(object sender, EventArgs e)
        {
            OVREQMatchMF frmMatchMF = new OVREQMatchMF();
            frmMatchMF.LanguageCode = m_strLanguageCode;
            frmMatchMF.MatchConfigID = m_iMatchConfigID;
            frmMatchMF.MatchConfigCode = m_strMatchConfigCode;
            frmMatchMF.MatchRuleCode = m_strMatchRuleCode;
            frmMatchMF.ShowDialog();

        }
        #endregion

    }
}