using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;

namespace AutoSports.OVRBDPlugin
{
    public class TTXmlExtraData
    {
        public TTXmlExtraData( TcpClient tcpClient, object extraData)
        {
            UserTcp = tcpClient;
            Data = extraData;
        }
        public TTXmlExtraData( IPEndPoint remoteIp, object extraData)
        {
            UdpUserIp = remoteIp;
            Data = extraData;
        }

        public TcpClient UserTcp;
        public IPEndPoint UdpUserIp;
        public object Data;
    }
    public class TTXmlItem
    {
        public enum TTXmlItemType
        {
            FileShare,
            NetTcp,
            NetUdp,
        }
        public TTXmlItem(string strData, long size, string oldPath, string newPath, TTXmlItemType itemType, TTXmlExtraData extraData, bool bAllowSame = false)
        {
            StrData = strData;
            FileLength = size;
            OldPath = oldPath;
            NewPath = newPath;
            ItemType = itemType;
            ExtraData = extraData;
            BAllowSame = bAllowSame;
        }
        public string StrData;
        public long FileLength;
        public string OldPath;
        public string NewPath;
        public TTXmlItemType ItemType;
        public bool BAllowSame;
        public object ExtraData;
    }
    public class DiffQueue : Queue<TTXmlItem>
    {
        private string lastString_;
        private long lastSize_;
        private string lastNoneHeartString_;
        private long lastNoneHeartSize_;
        public DiffQueue()
        {
            lastSize_ = -1;
            lastString_ = "";
            lastNoneHeartSize_ = -1;
            lastNoneHeartString_ = "";
        }
        public bool Enqueue(TTXmlItem item)
        {
            if ( item.FileLength == lastSize_ && item.StrData == lastString_ && !item.BAllowSame )
            {
                return false;
            }
            //加强检查除心跳包以外的
            if ( item.FileLength >= 8 )
            {
                if (item.FileLength == lastNoneHeartSize_ && item.StrData == lastNoneHeartString_ && !item.BAllowSame )
                {
                    return false;
                }
            }
            base.Enqueue(item);
            lastSize_ = item.FileLength;
            lastString_ = item.StrData;
            //更新心跳包以外的包
            if ( item.FileLength >= 8 )
            {
                lastNoneHeartSize_ = item.FileLength;
                lastNoneHeartString_ = item.StrData;
            }
          
            return true;
        }
        public void MakeDiff()
        {
            lastSize_ = -1;
            lastNoneHeartSize_ = -1;
        }
    }
}
