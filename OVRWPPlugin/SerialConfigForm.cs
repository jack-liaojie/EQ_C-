using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using DevComponents.DotNetBar.Controls;
using AutoSports.OVRCommon;
using System.IO;
using System.IO.Ports;
namespace AutoSports.OVRWPPlugin
{
    public partial class SerialConfigForm : Office2007Form
    {
        public DevComponents.DotNetBar.Controls.ComboBoxEx comboBox_COM_Port;
        public DevComponents.DotNetBar.Controls.ComboBoxEx comboBox_Baudrate;
        public DevComponents.DotNetBar.Controls.ComboBoxEx comboBox_Parity;
        public DevComponents.DotNetBar.Controls.ComboBoxEx comboBox_Databits;
        public DevComponents.DotNetBar.Controls.ComboBoxEx comboBox_Stopbits;
        public SerialConfigForm()
        {
            
            InitializeComponent();
        }
        
        private void SerialConfigForm_Load(object sender, EventArgs e)
        {
            Localization();
            GetComList();
            GetBaudrateList();
            GetDatabitsList();
            GetStopbitsList();
            GetParityList();
        }
        private void Localization()
        {
            String strSecName = GVAR.g_WPPlugin.GetSectionName();
            labelX_SerialPort.Text = LocalizationRecourceManager.GetString(strSecName, "labelX_SerialPort");
            labelX_Baudrate.Text = LocalizationRecourceManager.GetString(strSecName, "labelX_Baudrate");
            labelX_Parity.Text = LocalizationRecourceManager.GetString(strSecName, "labelX_Parity");
            labelX_Databits.Text = LocalizationRecourceManager.GetString(strSecName, "labelX_Databits");
            labelX_Stopbits.Text = LocalizationRecourceManager.GetString(strSecName, "labelX_Stopbits");
            btn_OK.Text = LocalizationRecourceManager.GetString(strSecName, "btnOK");
            btn_Cancel.Text = LocalizationRecourceManager.GetString(strSecName, "btnCancel");
        }
        public void GetComList()
        {
            comboBox_COM_Port.Items.Clear();
            String[] aryPortName = SerialPort.GetPortNames();
            comboBox_COM_Port.Items.AddRange(aryPortName);
            if (comboBox_COM_Port.Items.Count>0)
            {
                comboBox_COM_Port.SelectedIndex = 0;
            }
            else
            {
                comboBox_COM_Port.SelectedIndex = -1;
            }
        }
        public void GetBaudrateList()
        {
            comboBox_Baudrate.Items.Clear();
            comboBox_Baudrate.Items.Add(110);
            comboBox_Baudrate.Items.Add(300);
            comboBox_Baudrate.Items.Add(600);
            comboBox_Baudrate.Items.Add(1200);
            comboBox_Baudrate.Items.Add(2400);
            comboBox_Baudrate.Items.Add(4800);
            comboBox_Baudrate.Items.Add(9600);
            comboBox_Baudrate.Items.Add(14400);
            comboBox_Baudrate.Items.Add(19200);
            comboBox_Baudrate.Items.Add(38400);
            comboBox_Baudrate.Items.Add(56000);
            comboBox_Baudrate.Items.Add(57600);
            comboBox_Baudrate.Items.Add(115200);
            comboBox_Baudrate.Items.Add(128000);
            comboBox_Baudrate.Items.Add(256000);
            comboBox_Baudrate.SelectedItem= 9600;
        }
         public void GetDatabitsList()
        {
            comboBox_Databits.Items.Clear();
            comboBox_Databits.Items.Add(5);
            comboBox_Databits.Items.Add(6);
            comboBox_Databits.Items.Add(7);
            comboBox_Databits.Items.Add(8);
            comboBox_Databits.SelectedItem = 8;
        }
         public void GetStopbitsList()
         {
             comboBox_Stopbits.Items.Clear();
             comboBox_Stopbits.Items.Add(StopBits.One);
             comboBox_Stopbits.Items.Add(StopBits.Two);
             comboBox_Stopbits.Items.Add(StopBits.OnePointFive);
             comboBox_Stopbits.SelectedItem = StopBits.One;
         }
         public void GetParityList()
         {
             comboBox_Parity.Items.Clear();
             comboBox_Parity.Items.Add(Parity.None);
             comboBox_Parity.Items.Add(Parity.Odd);
             comboBox_Parity.Items.Add(Parity.Even);
             comboBox_Parity.Items.Add(Parity.Mark);
             comboBox_Parity.Items.Add(Parity.Space);
             comboBox_Parity.SelectedItem = Parity.None;
         }
        private void btn_OK_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void btn_Cancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        } 
    }
}
