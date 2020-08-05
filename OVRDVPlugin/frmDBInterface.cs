using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using AutoSports.OVRCommon;

namespace OVRDVPlugin
{
    public partial class frmDBInterface : DevComponents.DotNetBar.Office2007Form
    {
        private SqlConnection _OuterDBConnection;

        private string _ConnectionString = "";
        public string ConnectionString
        {
            get { return _ConnectionString; }

            set
            {
                _ConnectionString = value;

                int iSta, iEnd;
                iSta = _ConnectionString.IndexOf("Data Source=", 0, StringComparison.OrdinalIgnoreCase);
                if (iSta >= 0)
                {
                    iSta += 12;
                    iEnd = _ConnectionString.IndexOf(';', iSta);
                    if (iEnd < iSta)
                        txtServer.Text = _ConnectionString.Substring(iSta, _ConnectionString.Length - iSta).Trim();
                    else
                        txtServer.Text = _ConnectionString.Substring(iSta, iEnd - iSta).Trim();
                }

                iSta = _ConnectionString.IndexOf("User ID=", 0, StringComparison.OrdinalIgnoreCase);
                if (iSta >= 0)
                {
                    iSta += 8;
                    iEnd = _ConnectionString.IndexOf(';', iSta);
                    if (iEnd < iSta)
                        txtUser.Text = _ConnectionString.Substring(iSta, _ConnectionString.Length - iSta).Trim();
                    else
                        txtUser.Text = _ConnectionString.Substring(iSta, iEnd - iSta).Trim();
                }

                iSta = _ConnectionString.IndexOf("Password=", 0, StringComparison.OrdinalIgnoreCase);
                if (iSta >= 0)
                {
                    iSta += 9;
                    iEnd = _ConnectionString.IndexOf(';', iSta);
                    if (iEnd < iSta)
                        txtPassword.Text = _ConnectionString.Substring(iSta, _ConnectionString.Length - iSta).Trim();
                    else
                        txtPassword.Text = _ConnectionString.Substring(iSta, iEnd - iSta).Trim();
                }

                iSta = _ConnectionString.IndexOf("Initial Catalog=", 0, StringComparison.OrdinalIgnoreCase);
                if (iSta >= 0)
                {
                    iSta += 16;
                    iEnd = _ConnectionString.IndexOf(';', iSta);
                    if (iEnd < iSta)
                        cmbDatabase.Text = _ConnectionString.Substring(iSta, _ConnectionString.Length - iSta).Trim();
                    else
                        cmbDatabase.Text = _ConnectionString.Substring(iSta, iEnd - iSta).Trim();
                }

                iSta = _ConnectionString.IndexOf("Persist Security Info=True", 0, StringComparison.OrdinalIgnoreCase);
            }
        }

        private string m_strOutMatchCode;
        private string m_strInnerMatchID;
        private string m_strRoundNo;
        private bool m_bUpdateUI;

        public frmDBInterface(string iMatchID)
        {
            InitializeComponent();
            m_strRoundNo = "-1";
            m_strInnerMatchID = iMatchID;
            m_bUpdateUI = false;
        }

        private void frmDBInterface_Load(object sender, EventArgs e)
        {
            ConnectionString = ConfigurationManager.GetPluginSettingString("DV","ConnectionString").Trim();

            if (_ConnectionString.Length != 0)
            {
                btnConnect_Click(null, null);
            }

            SetDgvStyle();
            FillInnerMatchList();
        }

        private void btnConnect_Click(object sender, EventArgs e)
        {
            if (TestConnection())
            {
                DevComponents.DotNetBar.MessageBoxEx.Show("Connect DataBase Successed！", null, MessageBoxButtons.OK);

                ConfigurationManager.SetPluginSettingString("DV","ConnectionString", this.ConnectionString);

                if(_OuterDBConnection != null)
                {
                    _OuterDBConnection.Close();
                    _OuterDBConnection = null;
                }
                _OuterDBConnection = new SqlConnection(_ConnectionString);
                FillOuterMatchList();
            }
        }

        private bool TestConnection()
        {
            string strPassword = txtPassword.Text;

            _ConnectionString = String.Format(@"Data Source={0};User ID={1};Password={2};Initial Catalog={3};Persist Security Info={4}"
                                            , txtServer.Text, txtUser.Text, strPassword, cmbDatabase.Text, "TRUE");

            using (SqlConnection sqlCon = new SqlConnection(_ConnectionString))
            {
                try
                {
                    sqlCon.Open();
                    sqlCon.Close();
                }
                catch (SqlException ex)
                {
                    string strMsg = "";
                    for (int i = 0; i < ex.Errors.Count; i++)
                    {
                        string strTemp = String.Format("Index #{0}\nErrorNumber: {1}\nMessage: {2}\nLineNumber: {3}\n",
                                                       i, ex.Errors[i].Number, ex.Errors[i].Message, ex.Errors[i].LineNumber);
                        strTemp += "Source: " + ex.Errors[i].Source + "\n" + "Procedure: " + ex.Errors[i].Procedure + "\n";

                        strMsg += strTemp;
                    }
                    string strCaption = LocalizationRecourceManager.GetString("OVRLogin", "DBConnectingError");
                    DevComponents.DotNetBar.MessageBoxEx.Show(strMsg, strCaption, MessageBoxButtons.OK);
                    return false;
                }
                return true;
            }

        }

        private void cmbDatabase_DropDown(object sender, EventArgs e)
        {
            string strPassword = txtPassword.Text;

            _ConnectionString = String.Format(@"Data Source={0};User ID={1};Password={2};Persist Security Info={3}"
                                            , txtServer.Text, txtUser.Text, strPassword, "TRUE");

            using (SqlConnection sqlCon = new SqlConnection(_ConnectionString))
            {
                try
                {
                    sqlCon.Open();

                    DataTable table = sqlCon.GetSchema("Databases");

                    cmbDatabase.DisplayMember = "database_name";
                    cmbDatabase.ValueMember = "database_name";
                    cmbDatabase.DataSource = table;

                    sqlCon.Close();
                }
                catch (SqlException ex)
                {
                    string strMsg = "";
                    for (int i = 0; i < ex.Errors.Count; i++)
                    {
                        string strTemp = String.Format("Index #{0}\nErrorNumber: {1}\nMessage: {2}\nLineNumber: {3}\n",
                                                       i, ex.Errors[i].Number, ex.Errors[i].Message, ex.Errors[i].LineNumber);
                        strTemp += "Source: " + ex.Errors[i].Source + "\n" + "Procedure: " + ex.Errors[i].Procedure + "\n";

                        strMsg += strTemp;
                    }
                    string strCaption = LocalizationRecourceManager.GetString("OVRLogin", "DBConnectingError");
                    DevComponents.DotNetBar.MessageBoxEx.Show(strMsg, strCaption, MessageBoxButtons.OK);
                    return;
                }
            }
        }

        private void cmbRoundNo_SelectionChangeCommitted(object sender, EventArgs e)
        {
            if (cmbRoundNo.SelectedIndex < 0)
                return;

            m_strRoundNo = cmbRoundNo.SelectedValue.ToString();
        }

        private void SetDgvStyle()
        {
            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvOuterMatchList);
            FontFamily fontFamily = new FontFamily("Arial");
            FontStyle fontStyle = new FontStyle();
            Font gridFont = new Font(fontFamily, 13, fontStyle);
            dgvOuterMatchList.Font = gridFont;

            OVRDataBaseUtils.SetDataGridViewStyle(this.dgvMatchList);
            dgvMatchList.Font = gridFont;
        }

        private void FillInnerMatchList()
        {
            m_bUpdateUI = true;
            DVCommon.g_DVDBManager.GetInnerMatchList(ref dgvMatchList);
            dgvMatchList.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;

            if (m_strInnerMatchID.Length > 0 && m_strInnerMatchID != null)
            {
                for (int iRow = 0; iRow < dgvMatchList.Rows.Count; iRow++)
                {
                    if (m_strInnerMatchID == dgvMatchList.Rows[iRow].Cells[1].Value.ToString())
                    {
                        dgvMatchList.FirstDisplayedScrollingRowIndex = iRow;
                        dgvMatchList.Rows[iRow].Selected = true;
                        txtInnerMatchID.Text = m_strInnerMatchID;
                        InitRoundCmb();
                        break;
                    }
                }
            } 
            m_bUpdateUI = false;
        }

        private void FillOuterMatchList()
        {
             try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = _OuterDBConnection;

                string strSQL;
                strSQL = ConfigurationManager.GetPluginSettingString("DV", "SQL_MatchList");
                if (strSQL.Length == 0)
                {
                    strSQL = @"SELECT EventNameI, EventID FROM dvEvent";
                    ConfigurationManager.SetPluginSettingString("DV", "SQL_MatchList", strSQL);
                }
                oneSqlCommand.CommandText = strSQL;
                oneSqlCommand.CommandType = CommandType.Text;

                if (_OuterDBConnection.State == System.Data.ConnectionState.Closed)
                {
                    _OuterDBConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                OVRDataBaseUtils.FillDataGridView(dgvOuterMatchList, sdr);
                sdr.Close();

                 dgvOuterMatchList.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void dgvOuterMatchList_SelectionChanged(object sender, EventArgs e)
        {
            if(dgvOuterMatchList.SelectedRows.Count <= 0)
                return;

            int iRowIndex = dgvOuterMatchList.SelectedRows[0].Index;
            if (iRowIndex < 0 || iRowIndex > dgvOuterMatchList.Rows.Count)
            {
                return;
            }

            m_strOutMatchCode = dgvOuterMatchList.Rows[iRowIndex].Cells[1].Value.ToString();

            txtOuterMatchCode.Text = m_strOutMatchCode;
        }

        private void dgvMatchList_SelectionChanged(object sender, EventArgs e)
        {
            if (m_bUpdateUI)
                return;

            if (dgvMatchList.SelectedRows.Count <= 0)
                return;

            int iRowIndex = dgvMatchList.SelectedRows[0].Index;
            if (iRowIndex < 0 || iRowIndex > dgvMatchList.Rows.Count)
            {
                return;
            }
            m_strInnerMatchID = dgvMatchList.Rows[iRowIndex].Cells[1].Value.ToString();
            txtInnerMatchID.Text = m_strInnerMatchID;
            InitRoundCmb();
        }

        private void InitRoundCmb()
        {
            DVCommon.g_DVDBManager.GetRoundNo(m_strInnerMatchID, (ComboBox)cmbRoundNo);

            cmbRoundNo.SelectedIndex = -1;
        }

        private void btnShowActionCode_Click(object sender, EventArgs e)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = _OuterDBConnection;

                string strSQL;                
                strSQL = ConfigurationManager.GetPluginSettingString("DV", "SQL_ActionCode");
                if (strSQL.Length == 0)
                {
                    strSQL = @"SELECT A.EventID, A.RoundNo, B.OrderNo, A.DiveCode1,A.DiveDiff, A.DiveHeight,c.DiverNameI, d.DiverNameI
	                  FROM dvRound AS  A LEFT JOIN dvOrder AS B ON A.DiverID1 = B.DiverID1 AND (A.DiverID2 IS NULL OR A.DiverID2 = '' OR A.DiverID2 = B.DiverID2) AND A.EventID = B.EventID 
	                  Left join dvDiver as c on a.DiverID1 = c.DiverID
	                  Left join dvDiver as d on a.DiverID2 = d.DiverID
	                  WHERE A.EventID = '@MatchCode' ORDER BY B.OrderNo, A.RoundNo";

                    ConfigurationManager.SetPluginSettingString("DV", "SQL_ActionCode",strSQL);
                }
                strSQL = strSQL.Replace("@MatchCode", m_strOutMatchCode);
                oneSqlCommand.CommandText = strSQL;
                oneSqlCommand.CommandType = CommandType.Text;

                if (_OuterDBConnection.State == System.Data.ConnectionState.Closed)
                {
                    _OuterDBConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                OVRDataBaseUtils.FillDataGridView(dgvImportInfo, sdr);
                sdr.Close();

                for (int i = 0; i < dgvImportInfo.Rows.Count; i++)
                {
                    for (int j = 0; j < dgvImportInfo.Columns.Count; j++)
                    {
                        dgvImportInfo.Rows[i].Cells[j].ReadOnly = false;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void btnImportActionList_Click(object sender, EventArgs e)
        {
            TxtMsg.Clear();

            for (int iRowIndx = 0; iRowIndx < dgvImportInfo.Rows.Count -1; iRowIndx++)
            {
                string strRoundNo = dgvImportInfo.Rows[iRowIndx].Cells["RoundNo"].Value.ToString();
                string strOrderNo = dgvImportInfo.Rows[iRowIndx].Cells["OrderNo"].Value.ToString();

                string strActionCode, strDiveDiff,strDiveHeight;
                if (dgvImportInfo.Rows[iRowIndx].Cells["DiveCode1"].Value == null)
                {
                    strActionCode = "-1";
                }
                else
                {
                    strActionCode = dgvImportInfo.Rows[iRowIndx].Cells["DiveCode1"].Value.ToString();
                }
                if (dgvImportInfo.Rows[iRowIndx].Cells["DiveDiff"].Value == null)
                {
                    strDiveDiff = "-1";
                }
                else
                {
                    strDiveDiff = dgvImportInfo.Rows[iRowIndx].Cells["DiveDiff"].Value.ToString();
                }

                if (dgvImportInfo.Rows[iRowIndx].Cells["DiveHeight"].Value == null)
                {
                    strDiveHeight = "-1";
                }
                else
                {
                    strDiveHeight = dgvImportInfo.Rows[iRowIndx].Cells["DiveHeight"].Value.ToString();
                }

                int nResult = DVCommon.g_DVDBManager.UpdateActionCode(m_strInnerMatchID, strRoundNo, strOrderNo, strActionCode, strDiveDiff, strDiveHeight);

                string strMsg = "";
                switch (nResult)
                {
                    case 0:
                        strMsg = string.Format("Update ActionCode Failed! OrderNo: {0} in RoundNo: {1} ", strOrderNo,strRoundNo);
                        WriteLog(strMsg);
                        break;
                    case 1:
                        strMsg = string.Format("Update OrderNo: {0} in the RoundNo: {1} ActionCode Success! ", strOrderNo, strRoundNo);
                        WriteLog(strMsg);
                        break;
                    case -1:
                        strMsg = "Update ActionCode Failed, for the wrong MatchID: " + m_strInnerMatchID;
                        WriteLog(strMsg);
                        break;
                    case -2:
                        strMsg = "Update ActionCode Failed, for the wrong RoundNo: " + strRoundNo;
                        WriteLog(strMsg);
                        break;
                    case -3:
                        strMsg = "Update ActionCode Failed, for the wrong OrderNo: " + strOrderNo;
                        WriteLog(strMsg);
                        break;
                    case -4:
                        strMsg = "Update ActionCode Failed, for the wrong ActionCode: " + strActionCode;
                        WriteLog(strMsg);
                        break;
                }
            }
        }

        private void btnShowMatchResult_Click(object sender, EventArgs e)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = _OuterDBConnection;


                string strSQL;
                strSQL = ConfigurationManager.GetPluginSettingString("DV", "SQL_MatchResult");

                if (strSQL.Length == 0)
                {
                    strSQL = @"SELECT EventID, A.OrderNo, A.EventPoint, A.EventPlace, A.Qualified, A.Nonuser FROM dvOrder AS A  WHERE A.EventID = '@MatchCode' ORDER BY EventPlace";

                    ConfigurationManager.SetPluginSettingString("DV", "SQL_MatchResult", strSQL);
                }
                strSQL = strSQL.Replace("@MatchCode", m_strOutMatchCode);

                oneSqlCommand.CommandText = strSQL;
                oneSqlCommand.CommandType = CommandType.Text;

                if (_OuterDBConnection.State == System.Data.ConnectionState.Closed)
                {
                    _OuterDBConnection.Open();
                }


                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                OVRDataBaseUtils.FillDataGridView(dgvImportInfo, sdr);
                sdr.Close();

                for (int i = 0; i < dgvImportInfo.Rows.Count; i++)
                {
                    for (int j = 0; j < dgvImportInfo.Columns.Count; j++)
                    {
                        dgvImportInfo.Rows[i].Cells[j].ReadOnly = false;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void btnImprotMatchResult_Click(object sender, EventArgs e)
        {
            TxtMsg.Clear();

            for (int iRowIndx = 0; iRowIndx < dgvImportInfo.Rows.Count - 1; iRowIndx++)
            {
                string strOrderNo = dgvImportInfo.Rows[iRowIndx].Cells["OrderNo"].Value.ToString();

                string strEventPoint, strEventPlace, strQualified, strIRM;
                if (dgvImportInfo.Rows[iRowIndx].Cells["EventPoint"].Value == null)
                {
                    strEventPoint = "-1";
                }
                else
                {
                    strEventPoint = dgvImportInfo.Rows[iRowIndx].Cells["EventPoint"].Value.ToString();
                }

                if (dgvImportInfo.Rows[iRowIndx].Cells["EventPlace"].Value == null)
                {
                    strEventPlace = "-1";
                }
                else
                {
                    strEventPlace = dgvImportInfo.Rows[iRowIndx].Cells["EventPlace"].Value.ToString();
                }

                if (dgvImportInfo.Rows[iRowIndx].Cells["Qualified"].Value == null)
                {
                    strQualified = "-1";
                }
                else
                {
                    strQualified = dgvImportInfo.Rows[iRowIndx].Cells["Qualified"].Value.ToString();
                }

                if (dgvImportInfo.Rows[iRowIndx].Cells["Nonuser"].Value == null)
                {
                    strIRM = "-1";
                }
                else
                {
                    strIRM = dgvImportInfo.Rows[iRowIndx].Cells["Nonuser"].Value.ToString();
                }

                int nResult = DVCommon.g_DVDBManager.UpdateMatchResult(m_strInnerMatchID, strOrderNo, strEventPoint, strEventPlace, strQualified,strIRM);

                string strMsg = "";
                switch (nResult)
                {
                    case 0:
                       strMsg =  "Update MatchResult Failed! OrderNo: " + strOrderNo;
                       WriteLog(strMsg);
                       break;
                    case 1:
                       strMsg = string.Format("Update MatchResult Success! OrderNo: {0}", strOrderNo);
                       WriteLog(strMsg);
                        break;
                    case -1:
                        strMsg = "Update MatchResult Failed, for the wrong MatchID: " + m_strInnerMatchID;
                        WriteLog(strMsg);
                        break;
                    case -2:
                        strMsg = "Update MatchResult Failed, for the wrong OrderNo: " + strOrderNo;
                        WriteLog(strMsg);
                        break;
                }
            }
        }

        private void btnShowDetailResult_Click(object sender, EventArgs e)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = _OuterDBConnection;
                string strSQL;

                strSQL = ConfigurationManager.GetPluginSettingString("DV", "SQL_DetailMatchResult");
                if (strSQL.Length == 0)
                {
                    strSQL = @"SELECT A.EventID AS EventCode
                                        , CAST(B.RoundNo AS NVARCHAR(20)) AS RoundNo
                                        , A.OrderNo AS OrderNo
                                        , DivePoint AS DivePoints
                                        , DiveRank AS DiveRank
                                        , B.EventPoint AS EventPoint
                                        , B.EventPlace AS EventRank
                                        , 10 AS MatchsplitTypeID
                                        , NULL AS JudgeGroup
                                        , NULL AS JudgePanel
                                        FROM dvOrder AS A LEFT JOIN dvRound AS B ON A.EventID = B.EventID AND A.DiverID1 = B.DiverID1 AND (A.DiverID2 IS NULL OR A.DiverID2 = ''  OR A.DiverID2 = B.DiverID2)
                                         WHERE A.EventID = '@MatchCode' AND (@RoundNo= 0 OR B.RoundNo = @RoundNo )
                                        UNION 
                                        SELECT A.EventID AS EventCode
                                        , CAST(B.RoundNo AS NVARCHAR(20)) + '0'+ CAST(B.JudgeGroup AS NVARCHAR(20)) + '0' + CAST (B.JudgePanelDes AS NVARCHAR(20)) RoundNo
                                        , B.OrderNo AS OrderNo
                                        , B.JudgeAward AS DivePoints
                                        , NULL AS DiveRank 
                                        , NULL AS EventPoint 
                                        , NULL AS EventRank
                                        , 31 AS MatchsplitTypeID
                                        , B.JudgeGroup AS JudgeGroup
                                        , B.JudgePanelDes AS JudgePanel
                                        FROM dvOrder AS A 
                                         LEFT JOIN (SELECT RoundNo, OrderNo, EventID, JudgeAward, JudgeGroup, ROW_NUMBER() OVER(PARTITION BY EventID, RoundNo,OrderNo,JudgeGroup ORDER BY JudgePanel) AS JudgePanelDes FROM dvAward ) AS B ON A.OrderNo = B.OrderNo AND A.EventID = B.EventID
                                        WHERE A.EventID = '@MatchCode' AND (@RoundNo  = 0 OR B.RoundNo = @RoundNo) ORDER BY OrderNo";

                    ConfigurationManager.SetPluginSettingString("DV", "SQL_DetailMatchResult",strSQL);
                }
                strSQL = strSQL.Replace("@MatchCode", m_strOutMatchCode);
                strSQL = strSQL.Replace("@RoundNo", m_strRoundNo);


                oneSqlCommand.CommandText = strSQL;
                oneSqlCommand.CommandType = CommandType.Text;
                if (_OuterDBConnection.State == System.Data.ConnectionState.Closed)
                {
                    _OuterDBConnection.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                OVRDataBaseUtils.FillDataGridView(dgvImportInfo, sdr);
                sdr.Close();

                for (int i = 0; i < dgvImportInfo.Rows.Count; i++)
                {
                    for (int j = 0; j < dgvImportInfo.Columns.Count; j++)
                    {
                        dgvImportInfo.Rows[i].Cells[j].ReadOnly = false;
                    }
                }
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }

        private void btnImportDetailResult_Click(object sender, EventArgs e)
        {
            TxtMsg.Clear();

            for (int iRowIndx = 0; iRowIndx < dgvImportInfo.Rows.Count - 1; iRowIndx++)
            {
                string strRoundNo = dgvImportInfo.Rows[iRowIndx].Cells["RoundNo"].Value.ToString();
                string strOrderNo = dgvImportInfo.Rows[iRowIndx].Cells["OrderNo"].Value.ToString();

                string strDivePoint, strDiveRank, strEventRank, strEventPoint, strDiveHeight;
                if (dgvImportInfo.Rows[iRowIndx].Cells["DivePoints"].Value == null)
                {
                    strDivePoint = "-1";
                }
                else
                {
                    strDivePoint = dgvImportInfo.Rows[iRowIndx].Cells["DivePoints"].Value.ToString();
                }

                if (dgvImportInfo.Rows[iRowIndx].Cells["DiveRank"].Value == null)
                {
                    strDiveRank = "-1";
                }
                else
                {
                    strDiveRank = dgvImportInfo.Rows[iRowIndx].Cells["DiveRank"].Value.ToString();
                }

                if (dgvImportInfo.Rows[iRowIndx].Cells["EventPoint"].Value == null)
                {
                    strEventPoint = "-1";
                }
                else
                {
                    strEventPoint = dgvImportInfo.Rows[iRowIndx].Cells["EventPoint"].Value.ToString();
                }

                if (dgvImportInfo.Rows[iRowIndx].Cells["EventRank"].Value == null)
                {
                    strEventRank = "-1";
                }
                else
                {
                    strEventRank = dgvImportInfo.Rows[iRowIndx].Cells["EventRank"].Value.ToString();
                }

                string strMatchTypeID = dgvImportInfo.Rows[iRowIndx].Cells["MatchsplitTypeID"].Value.ToString();

                int nResult = DVCommon.g_DVDBManager.UpdateDetailMatchResult(m_strInnerMatchID, strRoundNo, strOrderNo, strDivePoint, strDiveRank, strEventPoint, strEventRank,strMatchTypeID);

                string strMsg = "";
                switch (nResult)
                {
                    case 0:
                        strMsg = string.Format("Update OrderNo: {0} in RoundNo: {1} DetailResult Failed!",strOrderNo, strRoundNo);
                        WriteLog(strMsg);
                        break;
                    case 1:
                        strMsg = string.Format("Update OrderNo: {0} in RoundNo: {1} DetailResult Success!",strOrderNo, strRoundNo);
                        WriteLog(strMsg);
                        break;
                    case -1:
                        strMsg = "Update DetailResult Failed, for the wrong MatchID: " + m_strInnerMatchID;
                        WriteLog(strMsg);
                        break;
                    case -2:
                        strMsg = "Update DetailResult Failed, for the wrong RoundNo: " + strRoundNo;
                        WriteLog(strMsg);
                        break;
                    case -3:
                        strMsg = "Update DetailResult Failed, for the wrong OrderNo: " + strOrderNo;
                        WriteLog(strMsg);
                        break;
                }
            }
        }

        private void WriteLog(string strEroMsg)
        {
            string strDateTime = DateTime.Now.ToString("u");
            strDateTime = strDateTime.TrimEnd('Z');

            string strMsg = "";
            strMsg = string.Format("日志信息：{0}", strEroMsg);

            TxtMsg.AppendText(strMsg + "\r\n");
        }

        private void frmDBInterface_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (e.CloseReason == CloseReason.UserClosing)
            {
                if (this.Owner != null)
                    this.Owner.Activate();

                this.Visible = false;
                e.Cancel = true;
            }
        }
    }
}
