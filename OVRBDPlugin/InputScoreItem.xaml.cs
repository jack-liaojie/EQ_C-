using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Data;
using System.Xml;
using System.IO;
namespace AutoSports.OVRBDPlugin
{
    /// <summary>
    /// Interaction logic for InputScoreItem.xaml
    /// </summary>
    public partial class InputScoreItem : UserControl,INotifyPropertyChanged
    {
        public InputScoreItem()
        {
            InitializeComponent();
        }

        public event PropertyChangedEventHandler PropertyChanged;

        private void NotifyPropertyChanged(String info)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(info));
            }
        }
        private int m_matchID;
        private ObservableCollection<SetScoreItem> m_gameScoreItems = new ObservableCollection<SetScoreItem>();
        private string courtName;
        private string matchName;
        private string matchID;
        private string matchScoreLeft;
        private string matchScoreRight;

        private string playerNameA;
        private string playerNameB;

        public string PlayerNameA
        {
            get
            {
                return this.playerNameA;
            }
            set
            {
                if (value != this.playerNameA)
                {
                    this.playerNameA = value;
                    NotifyPropertyChanged("PlayerNameA");
                    lbPlayerNameA.Content = this.playerNameA;
                }
            }
        }

        public string PlayerNameB
        {
            get
            {
                return this.playerNameB;
            }
            set
            {
                if (value != this.playerNameB)
                {
                    this.playerNameB = value;
                    NotifyPropertyChanged("PlayerNameB");
                    lbPlayerNameB.Content = this.PlayerNameB;
                }
            }
        }

       

        public string MatchScoreLeft
        {
            get
            {
                return this.matchScoreLeft;
            }
            set
            {
                if (value != this.matchScoreLeft)
                {
                    this.matchScoreLeft = value;
                    NotifyPropertyChanged("MatchScoreLeft");
                    tbMatchScoreA.Text = this.matchScoreLeft;
                }
            }
        }

        public string MatchScoreRight
        {
            get
            {
                return this.matchScoreRight;
            }
            set
            {
                if (value != this.matchScoreRight)
                {
                    this.matchScoreRight = value;
                    NotifyPropertyChanged("MatchScoreRight");
                    tbMatchScoreB.Text = this.matchScoreRight;
                }
            }
        }

        public string CourtName
        {
            get
            {
                return this.courtName;
            }
            set
            {
                if (value != this.courtName)
                {
                    this.courtName = value;
                    NotifyPropertyChanged("CourtName");
                    lbCourtName.Content = this.courtName;
                }
            }
        }

        public string MatchName
        {
            get
            {
                return this.matchName;
            }
            set
            {
                if (value != this.matchName)
                {
                    this.matchName = value;
                    NotifyPropertyChanged("MatchName");
                    lbMatchName.Content = this.matchName;
                }
            }
        }

        public string MatchID
        {
            get
            {
                return this.matchID;
            }
            set
            {
                if (value != this.matchID)
                {
                    this.matchID = value;
                    NotifyPropertyChanged("MatchID");
                    lbMatchID.Content = this.matchID;
                }
            }
        }

        public void UpdateData(int nMatchID)
        {
            m_matchID = nMatchID;
            DataTable dt = BDCommon.g_ManageDB.ReadMatchScore(nMatchID);
            if (dt == null || dt.Rows.Count == 0)
            {
                return;
            }
            DataRow firstRow = dt.Rows[0];
            CourtName = firstRow["CourtName"].ToString();
            MatchName = firstRow["MatchName"].ToString();
            MatchID = firstRow["MatchID"].ToString();
            PlayerNameA = firstRow["PlayerNameA"].ToString();
            PlayerNameB = firstRow["PlayerNameB"].ToString();
            MatchScoreLeft = firstRow["MatchScoreLeft"].ToString();
            MatchScoreRight = firstRow["MatchScoreRight"].ToString();
            if ( MatchScoreLeft == "")
            {
                MatchScoreLeft = "0";
            }

            if (MatchScoreRight == "")
            {
                MatchScoreRight = "0";
            }

            m_gameScoreItems.Clear();
            foreach ( DataRow dr in dt.Rows)
            {
                SetScoreItem scoreItem = new SetScoreItem();
                scoreItem.SetName = dr["SetName"].ToString();
                scoreItem.SetScoreLeft = dr["SetScoreLeft"].ToString();
                scoreItem.SetScoreRight = dr["SetScoreRight"].ToString();
                if (scoreItem.SetScoreLeft == "")
                {
                    scoreItem.SetScoreLeft = "0";
                }
                if (scoreItem.SetScoreRight == "")
                {
                    scoreItem.SetScoreRight = "0";
                }
                scoreItem.ScoreLeft1 = dr["GameScoreLeft1"].ToString();
                scoreItem.ScoreLeft2 = dr["GameScoreLeft2"].ToString();
                scoreItem.ScoreLeft3 = dr["GameScoreLeft3"].ToString();
                scoreItem.ScoreRight1 = dr["GameScoreRight1"].ToString();
                scoreItem.ScoreRight2 = dr["GameScoreRight2"].ToString();
                scoreItem.ScoreRight3 = dr["GameScoreRight3"].ToString();
                scoreItem.PlayerVSDes = dr["PlayerVSDes"].ToString();
                m_gameScoreItems.Add(scoreItem);
            }
            lvScore.ItemsSource = m_gameScoreItems;
        }

        public void UpdateData()
        {
            if ( m_matchID < 1)
            {
                return;
            }
            DataTable dt = BDCommon.g_ManageDB.ReadMatchScore(m_matchID);
            if (dt == null || dt.Rows.Count == 0)
            {
                return;
            }
            DataRow firstRow = dt.Rows[0];
            CourtName = firstRow["CourtName"].ToString();
            MatchName = firstRow["MatchName"].ToString();
            MatchID = firstRow["MatchID"].ToString();
            PlayerNameA = firstRow["PlayerNameA"].ToString();
            PlayerNameB = firstRow["PlayerNameB"].ToString();
            MatchScoreLeft = firstRow["MatchScoreLeft"].ToString();
            MatchScoreRight = firstRow["MatchScoreRight"].ToString();
            if (MatchScoreLeft == "")
            {
                MatchScoreLeft = "0";
            }

            if (MatchScoreRight == "")
            {
                MatchScoreRight = "0";
            }

            m_gameScoreItems.Clear();
            foreach (DataRow dr in dt.Rows)
            {
                SetScoreItem scoreItem = new SetScoreItem();
                scoreItem.SetName = dr["SetName"].ToString();
                scoreItem.SetScoreLeft = dr["SetScoreLeft"].ToString();
                scoreItem.SetScoreRight = dr["SetScoreRight"].ToString();
                if (scoreItem.SetScoreLeft == "")
                {
                    scoreItem.SetScoreLeft = "0";
                }
                if (scoreItem.SetScoreRight == "")
                {
                    scoreItem.SetScoreRight = "0";
                }
                scoreItem.ScoreLeft1 = dr["GameScoreLeft1"].ToString();
                scoreItem.ScoreLeft2 = dr["GameScoreLeft2"].ToString();
                scoreItem.ScoreLeft3 = dr["GameScoreLeft3"].ToString();
                scoreItem.ScoreRight1 = dr["GameScoreRight1"].ToString();
                scoreItem.ScoreRight2 = dr["GameScoreRight2"].ToString();
                scoreItem.ScoreRight3 = dr["GameScoreRight3"].ToString();
                scoreItem.PlayerVSDes = dr["PlayerVSDes"].ToString();
                m_gameScoreItems.Add(scoreItem);
            }
            lvScore.ItemsSource = m_gameScoreItems;
        }

        private void refreshClicked(object sender, RoutedEventArgs e)
        {
            UpdateData();
        }

        private void btnUpdate(object sender, RoutedEventArgs e)
        {
            if (MessageBoxResult.Cancel == MessageBox.Show("确定修改本场比赛的成绩吗？", "提示", MessageBoxButton.OKCancel, MessageBoxImage.Question))
            {
                return;
            }


        }

        private string GetMatchInfoXml()
        {
            string matchCode = TSDataExchangeTT_Service.GetMatchCodeFromID(m_matchID);
            if (matchCode == null || matchCode == "")
            {
                return "";
            }
            return "";
           /* MemoryStream stream = new MemoryStream();
            XmlTextWriter writter = new XmlTextWriter(stream, System.Text.Encoding.ASCII);
            writter.Formatting = Formatting.Indented;
            //顶层描述
            writter.WriteStartDocument();
            //第一级MatchInfo开始
            writter.WriteStartElement("MatchInfo");
            writter.WriteAttributeString("MatchCode", matchCode);
            //第二级Duel开始
            writter.WriteStartElement("Duel");
            //第二级属性
            writter.WriteAttributeString("DuelState", 5);
            writter.WriteAttributeString("DuelScoreA", MatchScoreLeft);
            writter.WriteAttributeString("DuelScoreB", MatchScoreRight);
            writter.WriteAttributeString("DuelTime", parser.GetDuelTime());
            writter.WriteAttributeString("DuelWLA", parser.DuelWLA.ToString());
            writter.WriteAttributeString("DuelWLB", parser.DuelWLB.ToString());
            writter.WriteAttributeString("DuelStatusA", parser.DuelJugeA);
            writter.WriteAttributeString("DuelStatusB", parser.DuelJugeB);

            //第三级SubMatch
            for (int iMatchNo = 1; iMatchNo <= parser.CurSubMatchNo; iMatchNo++)
            {
                //第三级开始
                writter.WriteStartElement("SubMatch");
                //第三级属性
                writter.WriteAttributeString("Match_No", iMatchNo.ToString());
                writter.WriteAttributeString("MatchScoreA", parser.GetSetScoreA(iMatchNo).ToString());
                writter.WriteAttributeString("MatchScoreB", parser.GetSetScoreB(iMatchNo).ToString());
                writter.WriteAttributeString("MatchTime", parser.GetSetTime(iMatchNo).ToString());
                writter.WriteAttributeString("MatchWLA", parser.GetSetWLA(iMatchNo).ToString());
                writter.WriteAttributeString("MatchWLB", parser.GetSetWLB(iMatchNo).ToString());
                writter.WriteAttributeString("MatchStatusA", parser.GetSetJudgeA(iMatchNo));
                writter.WriteAttributeString("MatchStatusB", parser.GetSetJudgeB(iMatchNo));
                writter.WriteAttributeString("MatchState", parser.GetSetState(iMatchNo).ToString());

                //第四级Game
                for (int iGameNo = 1; iGameNo <= parser.GetSetMaxGameCount(iMatchNo); iGameNo++)
                {
                    //第四级开始
                    writter.WriteStartElement("Game");
                    //第四级属性
                    writter.WriteAttributeString("Game_No", iGameNo.ToString());
                    writter.WriteAttributeString("GameScoreA", parser.GetGameScoreA(iMatchNo, iGameNo).ToString());
                    writter.WriteAttributeString("GameScoreB", parser.GetGameScoreB(iMatchNo, iGameNo).ToString());
                    writter.WriteAttributeString("GameTime", parser.GetGameTime(iMatchNo, iGameNo));
                    writter.WriteAttributeString("GameWLA", parser.GetGameWLA(iMatchNo, iGameNo).ToString());
                    writter.WriteAttributeString("GameWLB", parser.GetGameWLB(iMatchNo, iGameNo).ToString());
                    writter.WriteAttributeString("GameStatusA", parser.GetGameJudgeA(iMatchNo, iGameNo));
                    writter.WriteAttributeString("GameStatusB", parser.GetGameJudgeB(iMatchNo, iGameNo));
                    writter.WriteAttributeString("GameState", parser.GetGameState(iMatchNo, iGameNo).ToString());
                    writter.WriteEndElement();
                    //第四级结束
                }
                writter.WriteEndElement();
                //第三级结束
            }
            writter.WriteEndElement();
            //第二级结束
            writter.WriteEndElement();
            //第一级结束

            writter.Flush();
            writter.Close();
            byte[] data = stream.ToArray();
            stream.Close();
            return System.Text.Encoding.ASCII.GetString(data);*/
        }
    }

    public class SetScoreItem : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
	
	    private void NotifyPropertyChanged(String info)
	    {
		    if (PropertyChanged != null)
		    {
			    PropertyChanged(this, new PropertyChangedEventArgs(info));
		    }
	    }

        private string setName;

        public string SetName
        {
            get
		    {
			    return this.setName;
		    }
		    set
		    {
                if (value != this.setName)
                {
                    this.setName = value;
                    NotifyPropertyChanged("SetName");
                }
		    }
        }

        private string scoreLeft1;

        public string ScoreLeft1
        {
            get
		    {
			    return this.scoreLeft1;
		    }
		    set
		    {
                if (value != this.scoreLeft1)
                {
                    this.scoreLeft1 = value;
                    NotifyPropertyChanged("ScoreLeft1");
                }
		    }
        }

        private string scoreLeft2;

        public string ScoreLeft2
        {
            get
		    {
			    return this.scoreLeft2;
		    }
		    set
		    {
                if (value != this.scoreLeft2)
                {
                    this.scoreLeft2 = value;
                    NotifyPropertyChanged("ScoreLeft2");
                }
		    }
        }

        private string scoreLeft3;

        public string ScoreLeft3
        {
            get
		    {
			    return this.scoreLeft3;
		    }
		    set
		    {
                if (value != this.scoreLeft3)
                {
                    this.scoreLeft3 = value;
                    NotifyPropertyChanged("ScoreLeft3");
                }
		    }
        }

         private string scoreRight1;

        public string ScoreRight1
        {
            get
		    {
			    return this.scoreRight1;
		    }
		    set
		    {
                if (value != this.scoreRight1)
                {
                    this.scoreRight1 = value;
                    NotifyPropertyChanged("ScoreRight1");
                }
		    }
        }

        private string scoreRight2;

        public string ScoreRight2
        {
            get
		    {
			    return this.scoreRight2;
		    }
		    set
		    {
                if (value != this.scoreRight2)
                {
                    this.scoreRight2 = value;
                    NotifyPropertyChanged("ScoreRight2");
                }
		    }
        }

        private string scoreRight3;

        public string ScoreRight3
        {
            get
		    {
			    return this.scoreRight3;
		    }
		    set
		    {
                if (value != this.scoreRight3)
                {
                    this.scoreRight3 = value;
                    NotifyPropertyChanged("ScoreRight3");
                }
		    }
        }

        private string setScoreLeft;
        private string setScoreRight;

        public string SetScoreLeft
        {
            get
            {
                return this.setScoreLeft;
            }
            set
            {
                if (value != this.setScoreLeft)
                {
                    this.setScoreLeft = value;
                    NotifyPropertyChanged("SetScoreLeft");
                }
            }
        }

        public string SetScoreRight
        {
            get
            {
                return this.setScoreRight;
            }
            set
            {
                if (value != this.setScoreRight)
                {
                    this.setScoreRight = value;
                    NotifyPropertyChanged("SetScoreRight");
                }
            }
        }

        private string playerVSDes;

        public string PlayerVSDes
        {
            get
            {
                return this.playerVSDes;
            }
            set
            {
                if (value != this.playerVSDes)
                {
                    this.playerVSDes = value;
                    NotifyPropertyChanged("PlayerVSDes");
                }
            }
        }
    }
}
