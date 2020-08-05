using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

using DevComponents.DotNetBar;
using AutoSports.OVRCommon;
using Sunny.UI;

namespace AutoSports.OVRRankMedal
{
    public partial class OVRGroupMatchPointForm : UIForm
    {
        private SqlConnection dbConnection;
        private String mPhaseID;
        public SqlConnection DBConnection
        {
            get { return dbConnection; }
            set { dbConnection = value; }
        }
        public String PhaseID
        {
            get { return mPhaseID; }
            set { mPhaseID = value; }
        }

        public OVRGroupMatchPointForm()
        {
            InitializeComponent();

            txtWinPoints.Text = "0";
            txtDrawPoints.Text = "0";
            txtLostPoints.Text = "0";
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            this.Close();
            if (UpdateGroupMatchPoint())
            {

                this.DialogResult = DialogResult.OK;
            }
            else this.DialogResult = DialogResult.Cancel;
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
            this.DialogResult = DialogResult.Cancel;
        }

        private void FrmGroupMatchPoint_Load(object sender, EventArgs e)
        {
            Localization();
            InitroupMatchPointByPhaseId(mPhaseID);
        }

        private void Localization()
        {
            this.btnOK.Tooltip = LocalizationRecourceManager.GetString("OVRRankMedal", "btnOK");
            this.btnCancel.Tooltip = LocalizationRecourceManager.GetString("OVRRankMedal", "btnCancel");
            this.lbWinPoints.Text = LocalizationRecourceManager.GetString("OVRRankMedal", "lbWinPoints");
            this.lbDrawPoints.Text = LocalizationRecourceManager.GetString("OVRRankMedal", "lbDrawPoints");
            this.lbLostPoints.Text = LocalizationRecourceManager.GetString("OVRRankMedal", "lbLostPoints");
        }

        bool UpdateGroupMatchPoint()
        {
            bool bResult = false;
            if (dbConnection.State != ConnectionState.Open)
            {
                dbConnection.Open();
            }

            SqlCommand cmdUpdateMatchPoint = new SqlCommand("Proc_UpdateGroupPhaseMatchPoint", dbConnection);
            cmdUpdateMatchPoint.CommandType = CommandType.StoredProcedure;
            cmdUpdateMatchPoint.Parameters.AddWithValue("@PhaseID", mPhaseID);
            cmdUpdateMatchPoint.Parameters.AddWithValue("@WonMatchPoint", txtWinPoints.Text);
            cmdUpdateMatchPoint.Parameters.AddWithValue("@DrawMatchPoint", txtDrawPoints.Text);
            cmdUpdateMatchPoint.Parameters.AddWithValue("@LostMatchPoint", txtLostPoints.Text);

            SqlParameter ParamOut = new SqlParameter();
            ParamOut.Direction = ParameterDirection.Output;
            ParamOut.ParameterName = "@Result";
            ParamOut.Size = 4;
            cmdUpdateMatchPoint.Parameters.Add(ParamOut);

            try
            {
                cmdUpdateMatchPoint.ExecuteNonQuery();
            }
            catch (System.Exception errorProc)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(errorProc.Message);
                return false;
            }

            string strText;
            int nRetValue = Convert.ToInt32(ParamOut.Value);
            switch (nRetValue)
            {
                case 0:
                    strText = AutoSports.OVRCommon.LocalizationRecourceManager.GetString("OVRRankMedal", "SetGrpPointsFailed");
                    DevComponents.DotNetBar.MessageBoxEx.Show(strText);
                    bResult = false;
                    break;
                case -1:
                    strText = AutoSports.OVRCommon.LocalizationRecourceManager.GetString("OVRRankMedal", "SetGrpPointsFailed_NotGrp");
                    DevComponents.DotNetBar.MessageBoxEx.Show(strText);
                    bResult = false;
                    break;
                default://其余的需要为修改成功！


                    bResult = true;
                    break;
            }

            return bResult;
        }

        void InitroupMatchPointByPhaseId(String strPhaseID)
        {
            if (dbConnection.State != ConnectionState.Open)
            {
                dbConnection.Open();
            }
            SqlCommand cmdGetMatchPoint = new SqlCommand("Proc_GetGroupPhaseMatchPoint", dbConnection);
            cmdGetMatchPoint.CommandType = CommandType.StoredProcedure;
            cmdGetMatchPoint.Parameters.AddWithValue("@PhaseID", mPhaseID);

            try
            {
                SqlDataReader matchPointRecords = cmdGetMatchPoint.ExecuteReader();

                if (matchPointRecords != null)
                {
                    while (matchPointRecords.Read())
                    {
                        txtWinPoints.Text = matchPointRecords["F_WonMatchPoint"].ToString();
                        txtDrawPoints.Text = matchPointRecords["F_DrawMatchPoint"].ToString();
                        txtLostPoints.Text = matchPointRecords["F_LostMatchPoint"].ToString();
                    }

                    matchPointRecords.Close();
                }
            }
            catch (System.Exception errorProc)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(errorProc.Message);
            }
        }
    }
}