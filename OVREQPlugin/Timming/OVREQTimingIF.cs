using System;
using System.Collections.Generic;
using System.Threading;
using System.IO;
using System.Windows.Forms;
using System.Text;
//using Framework.Data;
using System.Data;
//using Framework;
using AutoSports.OVRCommon;


namespace AutoSports.OVREQPlugin
{
    public delegate void OutputMessageHandler(string message);

    /// <summary>
    /// Byte type with enumeration constants for ASCII control codes.
    /// </summary>
    public enum ASCII : byte
    {
        NULL = 0x00,
        /// <summary>
        /// Start of Heading
        /// </summary>
        SOH = 0x01,
        /// <summary>
        /// Start of Text
        /// </summary>
        STX = 0x02,
        /// <summary>
        /// End of Text 
        /// </summary>
        ETX = 0x03,
        /// <summary>
        /// End of Transmission
        /// </summary>
        EOT = 0x04,
        ENQ = 0x05, ACK = 0x06, BELL = 0x07, BS = 0x08, HT = 0x09,
        /// <summary>
        /// Data Link Escape 
        /// </summary>
        DLE = 0x10,
        /// <summary>
        /// Line Feed 
        /// </summary>
        LF = 0x0A,
        VT = 0x0B, FF = 0x0C,
        /// <summary>
        /// Carriage Return 
        /// </summary>
        CR = 0x0D,
        SO = 0x0E, SI = 0x0F, DC1 = 0x11,
        DC2 = 0x12, DC3 = 0x13, DC4 = 0x14, NAK = 0x15, SYN = 0x16, ETB = 0x17, CAN = 0x18, EM = 0x19,
        SUB = 0x1A, ESC = 0x1B, FS = 0x1C, GS = 0x1D, RS = 0x1E, US = 0x1F, SP = 0x20, DEL = 0x7F
    }

    public class TimingIF : IDisposable
    {
        private const byte SOH = 0x01;
        private const byte STX = 0x02;
        private const byte EOT = 0x04;
        private const byte SYMBOL_FRAME_BEGIN = 0x02;
        private const byte SYMBOL_FRAME_END = 0x03;
        private const int FRAME_LENGTH = 512;
        private const int READ_BUFFER_SIZE = 1024;
        Byte[] frameDataBuffer;
        int frameDataBufferIndex;
        private Thread parseThread;

        private Object messageSignal;
        private Object messDealSignal;
        private bool expectedframeBeginIsSet;//Flag of beginning of one frame
        private bool expecteddataBeginIsSet;//Flag of beginning of one data section

        private Queue<string> messagesQueue;
        private int finishInternumber;

        public bool m_bFilterSlalom = false;

        public event OutputMessageHandler OutputMessage;

        public TimingIF()
        {
            frameDataBuffer = new Byte[FRAME_LENGTH];
            frameDataBufferIndex = 0;
            messageSignal = new Object();
            messDealSignal = new object();
            messagesQueue = new Queue<string>();
            parseThread = new Thread(new ThreadStart(ParseMessage));
            parseThread.Start();
        }

        public int FinishInternumber
        {
            get { return this.finishInternumber; }
            set { this.finishInternumber = value; }
        }


        /// <summary>
        /// Get frames from the array of bytes; for Slalom
        /// </summary>
        /// <param name="Bytes">The bytes to be analysised</param>
        /// <param name="dataLength">The length of the bytes</param>
        public void GetSlalomMessage(byte[] Bytes, int dataLength)
        {

            for (int i = 0; i < dataLength; i++)
            {
                if (Bytes[i] == SOH || Bytes[i] == STX)
                {
                    if (Bytes[i] == SOH)
                        expectedframeBeginIsSet = true;
                    if (expectedframeBeginIsSet == true && Bytes[i] == STX)
                    {
                        expecteddataBeginIsSet = true;
                        //Clear buffer and get ready for receiving data in the frame.
                        Array.Clear(frameDataBuffer, 0, FRAME_LENGTH);
                        frameDataBufferIndex = 0;
                    }
                    //i++;
                    continue;
                }
                if (Bytes[i] == EOT)
                {
                    //End of one frame. Set flag as false.
                    if (expecteddataBeginIsSet && expectedframeBeginIsSet)
                    {
                        expecteddataBeginIsSet = false;
                        expectedframeBeginIsSet = false;

                        //Convert one frame to message and add it to MessagesQueue.
                        //读到结束标志时，将有效数据帧添加到消息队列
                        AddMessage(frameDataBuffer, frameDataBufferIndex);
                        //Clear frameDataBuffer
                        Array.Clear(frameDataBuffer, 0, FRAME_LENGTH);
                        frameDataBufferIndex = 0;
                    }
                    continue;
                }
                //有效数据帧保存到buffer
                if (expectedframeBeginIsSet && expecteddataBeginIsSet)
                {
                    frameDataBuffer[frameDataBufferIndex] = Bytes[i];
                    frameDataBufferIndex++;
                }
            }
        }

        /// <summary>
        /// Add message with length of the data.
        /// </summary>
        /// <param name="Bytes"></param>
        /// <param name="dataLength"></param>
        /// <returns></returns>
        private bool AddMessage(byte[] Bytes, int dataLength)
        {
            try
            {
                string message = BytesToString(Bytes, dataLength);
                //完整消息添加到消息队列，消息队列的将由新线程ParseMessage()处理（使用lock()和Monitor）
                AddToMessageQueue(message);
                //Output the message
                if (OutputMessage != null)
                    OutputMessage(message);

            }
            catch (Exception)
            {
                return false;
            }

            return true;
        }

        private string BytesToString(byte[] Bytes)
        {
            // Convert array of bytes to string.
            return System.Text.Encoding.ASCII.GetString(Bytes);
        }

        /// <summary>
        /// Convert Bytes[] to String according to the length.
        /// </summary>
        /// <param name="Bytes">array of bytes to be converted</param>
        /// <param name="dataLength">the length of the array of bytes</param>
        /// <returns></returns>
        private string BytesToString(byte[] Bytes, int dataLength)
        {
            // Convert array of bytes to string.
            return System.Text.Encoding.ASCII.GetString(Bytes, 0, dataLength);
        }

        private void AddToMessageQueue(string message)
        {
            lock (messageSignal)//add a lock on queue in order to avoid the conflic of reading and writting
            {
                messagesQueue.Enqueue(message);// Add the message to the queue and wait to parse 
                Monitor.Pulse(messageSignal);//Notifies parseThread to start work.
            }
        }

        public void DealFilterSlalom()
        {
            lock (messDealSignal)//add a lock on queue in order to avoid the conflic of reading and writting
            {
                Monitor.Pulse(messDealSignal);//Notifies parseThread to start work.
            }
        }

        /// <summary>
        /// Get out one message from the queue and analysis the message
        /// </summary>
        public void ParseMessage()
        {
            try
            {
                string message = null;
                while (true)
                {
                    while (null == message)
                    {
                        lock (messageSignal)
                        {
                            if (0 != messagesQueue.Count)
                                message = messagesQueue.Dequeue();
                            else
                                Monitor.Wait(messageSignal);
                        }
                    }

                    while (true)
                    {
                        lock (messDealSignal)
                        {
                            if (GVAR.g_EQPlugin.m_frmEQPlugin.ReceData)
                            {
                                //Analysis the message for Slalom.
                                m_bFilterSlalom = true;
                                try
                                {
                                    FilterEQ(message);
                                }
                                catch (Exception ex)
                                {
                                    string strExMess = ex.Message.ToString();
                                    ;
                                }
                                m_bFilterSlalom = false;
                                //Set message=null to wait for the next message.
                                message = null;
                                break;
                            }
                            else
                            {
                                Monitor.Wait(messDealSignal);
                            }
                        }
                    }
                }
            }
            catch (IOException)
            {
                //abort the thread
                System.Threading.Thread.CurrentThread.Abort();
            }
            catch (ObjectDisposedException)
            {
                if (parseThread != null)
                {
                    parseThread = null;
                }
            }
        }
        //处理消息字符串，写入数据库，更新页面的显示
        public void FilterEQ(string message)
        {
            string strRevBib = message.Substring(1, 3).TrimStart(' ');
            string strMatchConfigCode = message.Substring(11, 6).TrimStart(' ');
            int iCurMatchID = GVAR.g_EQDBManager.GetMatchIDFromMatchConfigCode(strMatchConfigCode);
            int iCurRegisterID = GVAR.g_EQDBManager.GetRegisterIDFromBib(iCurMatchID, strRevBib);

            #region start or finish signal
            if (message.StartsWith("s"))
            {
                string strRevSignal = message.Substring(4, 7).TrimStart(' ');
                if (strRevSignal.Equals("start"))
                {
                    GVAR.g_EQPlugin.m_frmEQPlugin.UpdateWhenRegisterStatus2StartSafe(iCurMatchID,iCurRegisterID);
                }
                if (strRevSignal.Equals("finish"))
                {
                    GVAR.g_EQPlugin.m_frmEQPlugin.UpdateWhenRegisterStatus2FinishSafe(iCurMatchID,iCurRegisterID);
                }
            }
            #endregion

            else
            {
                #region Penalty
                if (message.StartsWith("p"))
                {
                    string strRevPen = message.Substring(4, 7);

                    int nRevPen = 0;
                    if (strRevPen.Length > 0)
                        nRevPen = int.Parse(strRevPen);

                    //使用收到的罚分计算并更新DB和dgvresult
                    decimal fInputValue = Convert.ToDecimal(nRevPen);
                    GVAR.g_EQDBManager.UpdateColumnPoint(iCurMatchID, iCurRegisterID, "F_CurJumpPen", fInputValue);
                }
                #endregion

                #region IRM
                if (message.StartsWith("i"))
                {
                    string strRevIRM = message.Substring(4, 7).TrimStart(' ');
                    GVAR.g_EQDBManager.UpdateIRM(iCurMatchID, iCurRegisterID, strRevIRM);
                }
                #endregion

                #region FinishTime
                if (message.StartsWith("f"))
                {
                    string strRevTimeSeconds = message.Substring(4, 4);
                    string strRevTimeMili = message.Substring(8, 3);

                    int nRevTimeSeconds = 0;
                    if (strRevTimeSeconds.Length > 0)
                        nRevTimeSeconds = int.Parse(strRevTimeSeconds);
                    int nRevTimeMili = 0;
                    if (strRevTimeMili.Length > 0)
                        nRevTimeMili = int.Parse(strRevTimeMili);
                    string strRevTime = nRevTimeSeconds.ToString() + "." + string.Format("{0:D3}", nRevTimeMili);

                    //使用收到的用时计算并更新DB和dgvresult
                    decimal fInputValue = Convert.ToDecimal(strRevTime);
                    GVAR.g_EQDBManager.UpdateCurTimePen(iCurMatchID, iCurRegisterID, fInputValue);
                }
                #endregion

                //计算Cur总分，并更新总分到result表
                GVAR.g_EQDBManager.UpdateCurPointsWhenScoreChanged(iCurMatchID, iCurRegisterID, 0);
                //计算Cur总分，并更新总分到result表
                GVAR.g_EQDBManager.UpdateTotPointsWhenCurPointsChanged(iCurMatchID, iCurRegisterID);

                GVAR.g_EQPlugin.m_frmEQPlugin.UpdateDgvMatchResultListSafe();
            }

            //发送成绩变更消息
            //EQCommon.g_EQPlugin.DataChangedNotify(OVRDataChangedType.emMatchResult, -1, -1, -1, nCurMatchID, nCurMatchID, null);
        }

        #region IDisposable Members

        public void Dispose()
        {
            CloseThread();//Close all thread.
        }

        private void CloseThread()
        {
            if (parseThread != null)
            {
                parseThread.Abort();
            }
        }

        #endregion
    }
}