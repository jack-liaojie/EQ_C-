using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Sockets;
using System.Threading;
using System.Net;
using DevComponents.DotNetBar;


namespace AutoSports.OVRWPPlugin
{
      public partial class frmOVRWPDataEntry : DevComponents.DotNetBar.Office2007Form
      {
          Byte[] m_TextBuffer = new Byte[1024];
          private UdpClient m_UDP;
          
          private IPEndPoint m_Server = new IPEndPoint(IPAddress.Any, 0);
          private const byte Time_Score_Head = 0xDF;
          private const byte Time_Score_Tail = 0xCF;
          private bool m_bUDPFrameStart = false;
          private int m_TextBufferIndex = 0;
          public delegate void MyInvoke(object obj, bool bEnbable);
          public delegate void ClearTextInvoke(object obj);
          public void UPdateUI(object obj, bool bEnbable)
          {
              ButtonX btn = (ButtonX)obj;
              btn.Enabled = bEnbable;
          }
          public void ClearText(object obj)
          {
              LabelX lb = (LabelX)obj;
              lb.Text = "";
          }
          public void ParseUDPThread()
          {
              try
              {
                  int itime = 0;
                  while (m_bParse)
                  {
                      Byte[] bytes = m_UDP.Receive(ref m_Server);

                      for (int i = 0; i < bytes.Length; i++)
                      {
                          if (bytes[i] == Time_Score_Head)
                          {
                              m_bUDPFrameStart = true;
                              m_TextBufferIndex = 0;
                              continue;
                          }
                          if (bytes[i] == Time_Score_Tail)
                          {
                              if (m_TextBufferIndex == 5)
                              {
                                  itime = m_TextBuffer[0] * 60 + m_TextBuffer[1];
                                  m_CCurMatch.MatchTime = itime.ToString();
                                  MatchTime.Text = GVAR.TranslateINT32toTime(itime);
                              }
                              m_bUDPFrameStart = false;
                              m_TextBufferIndex = 0;
                          }
                          if (m_bUDPFrameStart)
                          {
                              m_TextBuffer[m_TextBufferIndex] = bytes[i];
                              m_TextBufferIndex++;
                          }
                      }
                  }
              }
              catch (Exception ex)
              {
                  //MessageBoxEx.Show("Receive thread error happened!");
              }
              finally
              {
                  m_bParse = false;
                  m_ParseUDPThread = null;
                  if (m_UDP != null)
                  {
                      m_UDP.Close();
                      m_UDP = null;
                  }
                  m_bUDPFrameStart = false;
                  m_TextBufferIndex = 0;
                  MyInvoke mi=new MyInvoke(this.UPdateUI);
                  ClearTextInvoke Ci = new ClearTextInvoke(this.ClearText);
                  if (m_bIsCloseThreadManuel)
                  {
                      this.BeginInvoke(mi, new object[] { btn_start_receive, true });
                      m_bIsCloseThreadManuel = false;
                  }
                  else
                  {
                      this.BeginInvoke(mi, new object[] { btn_start_receive, false });
                      this.BeginInvoke(Ci, new object[] { Label_SelectedPort });
                  }
                  this.BeginInvoke(mi, new object[] { btn_stop_receive, false });
              }
          }
      }
}
