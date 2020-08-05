using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace RomoteControl
{
    public partial class RemoteUI : Form
    {
        public RemoteUI( string strRemoteIp, int nPort, int iframe)
        {
            InitializeComponent();
            m_ip = strRemoteIp;
            m_port = nPort;
            if ( iframe < 1 )
            {
                m_iframe = 1;
            }
            else if ( iframe > 50 )
            {
                m_iframe = 50;
            }
            else 
            {
                m_iframe = iframe;
            }
        }
        public void SetIpAndFrameRate(string strIP, int iframe)
        {
            m_ip = strIP;
            if (iframe < 1)
            {
                m_iframe = 1;
            }
            else if (iframe > 50)
            {
                m_iframe = 50;
            }
            else
            {
                m_iframe = iframe;
            }
        }
        private static TcpExchangeClient m_client = null;
        private string m_ip;
        private int m_port;
        private int m_iframe;
        public string LastErrorMsg;
        public bool ConnectToServer()
        {
            if ( m_client == null )
            {
                m_client = new TcpExchangeClient();
                m_client.SocketExitEvent += new TcpExchangeClient.ExitDelegate(m_client_SocketExitEvent);
            }
            if ( !m_client.Connect(m_ip,m_port) )
            {
                LastErrorMsg = "连接服务器失败！";
                return false;
            }
            m_client.SetUI(this);
            byte[] data = DataProtocol.GetRequestControlPackage(m_iframe);
            m_client.SendData(DataProtocol.MakePackage(data));
            return true;
        }

        void m_client_SocketExitEvent()
        {
            MessageBox.Show("远程桌面已停止，与被控端连接断开！");
            chkControlSwitch.Checked = false;
            //this.Visible = false;
            this.Hide();
        }

        public void SetMonitorImage(Bitmap map)
        {
            
            pictureBox1.Size = map.Size;
            pictureBox1.BackgroundImage = map;
           // m_graphic.DrawImage(map,0,0);
        }

        private void remoteUIClosing(object sender, FormClosingEventArgs e)
        {
            m_client.Disconnect();
            e.Cancel = true;
            this.Visible = false;
            //Close();
        }

        public void SetNoControl()
        {
            chkControlSwitch.Checked = false;
        }

        private void SendMouseMessage(MouseClickType type, int x, int y)
        {
            byte[] data = DataProtocol.GetMouseClickPackage(type, x, y);
            byte[] sendData = DataProtocol.MakePackage(data);
            m_client.SendData(sendData);
        }

        private void OnMouseClick(object sender, MouseEventArgs e)
        {
            return; 
            if ( !chkControlSwitch.Checked)
            {
                return;
            }
            if ( e.Button == MouseButtons.Left )
            {
                SendMouseMessage(MouseClickType.ClickTypeLeftClick, e.X, e.Y);
            }
            else if ( e.Button == MouseButtons.Right)
            {
                SendMouseMessage(MouseClickType.ClickTypeRightClick, e.X, e.Y);
            }
        }

        private void OnMouseDbClicked(object sender, MouseEventArgs e)
        {
            return;
            if( !chkControlSwitch.Checked)
            {
                return;
            }
            if ( e.Button == MouseButtons.Left)
            {
                SendMouseMessage(MouseClickType.ClickTypeLeftDoubleClick, e.X, e.Y);
            }
            else if( e.Button == MouseButtons.Right)
            {
                SendMouseMessage(MouseClickType.ClickTypeRightDoubleClick, e.X, e.Y);
            }
        }

        private void OnMouseDown(object sender, MouseEventArgs e)
        {
            if (!chkControlSwitch.Checked)
            {
                return;
            }
            if ( e.Button == MouseButtons.Left)
            {
                SendMouseMessage(MouseClickType.ClickTypeMouseLeftDown, e.X, e.Y);
            }
            else if(e.Button == MouseButtons.Right)
            {
                SendMouseMessage(MouseClickType.ClickTypeMouseRightDown, e.X, e.Y);
            }
        }

        private void OnMouseUp(object sender, MouseEventArgs e)
        {
            if (!chkControlSwitch.Checked)
            {
                return;
            }
            if (e.Button == MouseButtons.Left)
            {
                SendMouseMessage(MouseClickType.ClickTypeMouseLeftUp, e.X, e.Y);
            }
            else if (e.Button == MouseButtons.Right)
            {
                SendMouseMessage(MouseClickType.ClickTypeMouseRightUp, e.X, e.Y);
            }
        }

        private void OnKeyDown(object sender, PreviewKeyDownEventArgs e)
        {
            return;
            byte[] data = DataProtocol.GetKeyBdPackage( Convert.ToByte(e.KeyValue), PackageType.KeybdEventDown);
            byte[] sendData = DataProtocol.MakePackage(data);
            m_client.SendData(sendData);
        }

        private void OnFrameKeyDown(object sender, KeyEventArgs e)
        {
            if (!chkControlSwitch.Checked)
            {
                return;
            }
            byte[] data = DataProtocol.GetKeyBdPackage(Convert.ToByte(e.KeyValue), PackageType.KeybdEventDown);
            byte[] sendData = DataProtocol.MakePackage(data);
            m_client.SendData(sendData);
        }

        private void OnFrameKeyUp(object sender, KeyEventArgs e)
        {
            if (!chkControlSwitch.Checked)
            {
                return;
            }
            byte[] data = DataProtocol.GetKeyBdPackage(Convert.ToByte(e.KeyValue), PackageType.KeybdEventUp);
            byte[] sendData = DataProtocol.MakePackage(data);
            m_client.SendData(sendData);
        }
        DateTime m_lastDateTime = DateTime.Now;
        private void OnMouseMove(object sender, MouseEventArgs e)
        {
            if (!chkControlSwitch.Checked)
            {
                return;
            }
            TimeSpan timeSpan = DateTime.Now - m_lastDateTime;
            //if ( timeSpan.TotalMilliseconds < 50)
            //{
            //    return;
            //}
            m_lastDateTime = DateTime.Now;
            byte[] data = DataProtocol.GetMouseMovePackage(e.X, e.Y);
            byte[] sendData = DataProtocol.MakePackage(data);
            m_client.SendData(sendData);
        }

        private void OnMouseEnter(object sender, EventArgs e)
        {
            //System.Windows.Forms.Cursor.Hide();
        }

        private void OnMouseLeave(object sender, EventArgs e)
        {
            //System.Windows.Forms.Cursor.Show();
        }

        private void OnFrameLoaded(object sender, EventArgs e)
        {
            this.Text = m_ip + " 的远程桌面";
        }
    }
}
