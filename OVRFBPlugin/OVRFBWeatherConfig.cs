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

namespace AutoSports.OVRFBPlugin
{
    public partial class OVRFBWeatherConfig : Office2007Form
    {
        public OVRFBWeatherConfig()
        {
            InitializeComponent();
            //initial the text for more languages.
            Localization();
        }

        #region Initialize
        private int m_MatchID;
        public int MatchID
        {
            get { return m_MatchID; }
            set { m_MatchID = value; }
        }
        //initial the text for more languages.
        private void Localization()
        {
            String strSecName = GVAR.g_FBPlugin.GetSectionName();
            this.Text = LocalizationRecourceManager.GetString(strSecName, "OVROWWeatherConfig");
            this.lbAirtemp.Text = LocalizationRecourceManager.GetString(strSecName, "lbAirtemp");
            this.lbWatertemp.Text = LocalizationRecourceManager.GetString(strSecName, "lbWatertemp");
            this.lbHumidity.Text = LocalizationRecourceManager.GetString(strSecName, "lbHumidity");

            this.lbWeatherConditionDes.Text = LocalizationRecourceManager.GetString(strSecName, "lbWeatherConditionDes");
            this.lbWindSpeed.Text = LocalizationRecourceManager.GetString(strSecName, "lbWindSpeed");
            this.lbUnit.Text = LocalizationRecourceManager.GetString(strSecName, "lbUnit");
            this.lbWindDirection.Text = LocalizationRecourceManager.GetString(strSecName, "lbWindDirection");
            this.btnOK.Text = LocalizationRecourceManager.GetString(strSecName, "btnOK");
            this.btnCancel.Text = LocalizationRecourceManager.GetString(strSecName, "btnCancel");
        }

        protected override void OnShown(EventArgs e)
        {
            base.OnShown(e);
            InitForm();
        }
        //==========================><==============================
        private void InitForm()
        {
            InitcmbWindDirection();
            InitcmbDescription();
            InitAllControls();
        }

        private DataTable tbWindDirection;//tabel WindDirection
        //Initialize the cmbWindDirection(cmbobox)
        private void InitcmbWindDirection()
        {
            //if (m_dataBase.DBConnect.State == ConnectionState.Closed)
            //{
            //    m_dataBase.DBConnect.Open();
            //}
            try
            {
                tbWindDirection = GVAR.g_ManageDB.GetWeatherWindDirection();
                if (tbWindDirection == null)
                    return;
                DataRow newRow = tbWindDirection.NewRow();
                newRow[0] = -1;
                newRow[1] = "NULL";
                //tbWindDirection.Rows.InsertAt(-1,"NULL");
                tbWindDirection.Rows.InsertAt(newRow, 0);
                cmbWindDirection.DisplayMember = "WindDirection";
                cmbWindDirection.ValueMember = "WindDirectionID";
                cmbWindDirection.DataSource = tbWindDirection;
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
                return;
            }
        }

        private DataTable tbDescription;//tabel WeatherDescription
        //Initialize the cmbDescription(cmbobox)
        private void InitcmbDescription()
        {
            try
            {
                tbDescription = GVAR.g_ManageDB.GetWeatherDescription();
                if (tbDescription == null)
                    return;

                cmbDescription.DisplayMember = "WeatherTypeShortDescription";
                cmbDescription.ValueMember = "WeatherTypeID";
                cmbDescription.DataSource = tbDescription;
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
                return;
            }
        }

        private DataTable tbWeatherControlData;//tabel WeatherControlData
        //Initialize All the controls' data
        private void InitAllControls()
        {
            try
            {
                tbWeatherControlData = GVAR.g_ManageDB.GetWeatherControlData(m_MatchID);
                if (tbWeatherControlData == null)
                    return;

                textAirtemp.Text = tbWeatherControlData.Rows[0]["AirTemp"].ToString();
                textWaterTemp.Text=tbWeatherControlData.Rows[0]["WaterTemp"].ToString();
                textHumidity.Text = tbWeatherControlData.Rows[0]["Humidity"].ToString();

                cmbDescription.Text = tbWeatherControlData.Rows[0]["WeatherTypeShortDescription"].ToString();
                textWindSpeed.Text = tbWeatherControlData.Rows[0]["WindSpeed"].ToString();
                cmbWindDirection.Text = tbWeatherControlData.Rows[0]["WindDirection"].ToString();
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
                return;
            }
        }
         #endregion
        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            SaveWeatherData();
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void SaveWeatherData()
        {
            try
            {
                string At = textAirtemp.Text;
                String Wt = textWaterTemp.Text;
                string Hm = textHumidity.Text;

                int WDes = (int)cmbDescription.SelectedValue;
                string Sp = textWindSpeed.Text;
               
                String WDir = cmbWindDirection.SelectedValue.ToString().Trim();
                GVAR.g_ManageDB.UpdateWeatherDataToDB(m_MatchID, At,Wt, Hm, WDes, Sp, WDir);
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
                return;
            }
        }
        private void textAirtemp_KeyDown(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == 13)
            {
                textWaterTemp.Focus();
                e.Handled = true;
            }
            if (e.KeyChar != 8 && e.KeyChar!= '.' &&e.KeyChar!= '-' &&
                !Char.IsDigit(e.KeyChar))
            {
                e.Handled = true;
            }
        }
        private void textWatertemp_KeyDown(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == 13)
            {
                textHumidity.Focus();
                e.Handled = true;
            }
            if (e.KeyChar != 8 && e.KeyChar != '.' && e.KeyChar != '-' &&
                !Char.IsDigit(e.KeyChar))
            {
                e.Handled = true;
            }
        }
        private void textHumidity_KeyDown(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == 13)
            {
               textWindSpeed.Focus();
               e.Handled = true;
            }

            if (e.KeyChar != 8 && e.KeyChar != '.' &&
               !Char.IsDigit(e.KeyChar))
            {
                e.Handled = true;
            }
        }

        private void cmbDescription_KeyDown(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar ==13)
                textAirtemp.Focus();
        }

        private void textWindSpeed_KeyDown(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == 13)
            {
                cmbWindDirection.Focus();
                e.Handled = true;
            }
            if (e.KeyChar != 8 && e.KeyChar != '.' &&
                !Char.IsDigit(e.KeyChar))
            {
                e.Handled = true;
            }
        }

        private void cmbWindDirection_KeyDown(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == 13)
                btnOK.Focus();
        }
    }
}
