

namespace AutoSports.OVRWRPlugin
{
    public class OVRWRMatchResult_Individual
    {
        #region Fields

        private int m_nMatchID;				// -> TS_Match_Result.F_MatchID
        private int m_nSplitID;               //-> TS_Match_Result.F_MatchSplitID
        private int m_nColor;				// -> TS_Match_Result.F_CompetitionPositionDes1: 1 - red; 2 - Blue. 
        private int m_nCompPos;				// -> TS_Match_Result.F_CompetitionPosition
        private string m_strCompName;		// -> TS_Match_Resul.F_RegisterID -> TR_Register.F_LongName

        private int m_nHantei;				// -> TS_Match_Result.F_PointsCharDes1: 1 - Hantei; else - No Hantei.
        private int m_nSplitHantei;                 //->

        private string m_strIRMCode;
        private string m_strIRMCode1st;		// -> TS_Match_Split_Result.F_IRMID -> TC_IRM.F_IRMCode
        private string m_strIRMCode2nd;		// -> TS_Match_Split_Result.F_IRMID -> TC_IRM.F_IRMCode
        private string m_strIRMCode3rd;		// -> TS_Match_Split_Result.F_IRMID -> TC_IRM.F_IRMCode

        private int m_nResultID;			// -> TS_Match_Result.F_ResultID
        private int m_nRank;				// -> TS_Match_Result.F_Rank


        private int m_nResultIDSplit1st;     //->TS_Match_Split_Result.F_ResultID
        private int m_nResultIDSplit2nd;
        private int m_nResultIDSplit3rd;

        private int m_nPoints;              // -> TS_Match_Result.F_Points       
        private int m_nPointsSplit1st;          //-> TS_Match_split_Result.
        private int m_nPointsSplit2nd;
        private int m_nPointsSplit3rd;

        private int m_nPointsSplit1st_AddTime;
        private int m_nPointsSplit2nd_Addtime;
        private int m_nPointsSplit3rd_Addtime;


        private int m_nWinsets;

        private int m_nClassidicationPoints;
        #endregion

        #region property

        public int ClassidicationPoints
        {
            get { return m_nClassidicationPoints; }
            set { m_nClassidicationPoints = value; }
        }

        public int Hantai
        {
            get
            {
                return m_nHantei;
            }
            set
            {
                m_nHantei = value;
            }
        }

        public int SplitHantei
        {
            get { return m_nSplitHantei; }
            set { this.m_nSplitHantei = value; }
        }

        public string IRMCode
        {
            get { return m_strIRMCode; }
            set { m_strIRMCode = value; }
        }

        public string IRMCode1st
        {
            get
            {
                return m_strIRMCode1st;
            }
            set
            {
                m_strIRMCode1st = value;
            }
        }

        public string IRMCode2nd
        {
            get
            {
                return m_strIRMCode2nd;
            }
            set
            {
                m_strIRMCode2nd = value;
            }
        }

        public string IRMCode3rd
        {
            get
            {
                return m_strIRMCode3rd;
            }
            set
            {
                m_strIRMCode3rd = value;
            }
        }

        public int ResultID
        {
            get
            {
                return m_nResultID;
            }
            set
            {
                m_nResultID = value;
            }
        }

        public int ResultIDSplit1st
        {
            get { return m_nResultIDSplit1st; }
            set { m_nResultIDSplit1st = value; }
        }

        public int ResultIDSplit2nd
        {
            get { return m_nResultIDSplit2nd; }
            set { this.m_nResultIDSplit2nd = value; }

        }

        public int ResultIDSplit3rd
        {
            get { return m_nResultIDSplit3rd; }
            set { m_nResultIDSplit3rd = value; }
        }

        public int Rank
        {
            get
            {
                return m_nRank;
            }
            set
            {
                m_nRank = value;
            }
        }

        public string CompName
        {
            get
            {
                return m_strCompName;
            }
            set
            {
                m_strCompName = value;
            }
        }

        public int Points
        {
            get { return m_nPoints; }
            set { this.m_nPoints = value; }
        }

        public int PointsSplit1st
        {
            get { return m_nPointsSplit1st; }
            set { this.m_nPointsSplit1st = value; }
        }

        public int PointsSplit2nd
        {
            get { return m_nPointsSplit2nd; }
            set { m_nPointsSplit2nd = value; }
        }

        public int PointsSplit3rd
        {
            get { return m_nPointsSplit3rd; }
            set { m_nPointsSplit3rd = value; }
        }

        public int Winsets
        {
            get { return m_nWinsets; }
            set { m_nWinsets = value; }
        }

        public int PointsSplit1st_AddTime
        {
            get { return this.m_nPointsSplit1st_AddTime; }
            set { this.m_nPointsSplit1st_AddTime = value; }
        }

        public int PointsSplit2nd_AddTime
        {
            get { return m_nPointsSplit2nd_Addtime; }
            set { m_nPointsSplit2nd_Addtime = value; }
        }

        public int PointsSplit3rd_AddTime
        {
            get { return m_nPointsSplit3rd_Addtime; }
            set { m_nPointsSplit3rd_Addtime = value; }
        }
        #endregion

        #region  Constructor

        public OVRWRMatchResult_Individual()
        {

        }

        #endregion

        #region public Function

        public void UpdateMatchPoints(int nColor)
        {
            GVAR.g_ManageDB.UpdateMatchResultPoints(GVAR.g_matchID, nColor, m_nPoints, m_nPointsSplit1st, m_nPointsSplit2nd, m_nPointsSplit3rd, m_nPointsSplit1st_AddTime, m_nPointsSplit2nd_Addtime, m_nPointsSplit3rd_Addtime);

        }

        public void GetMatchResultPoints(int nColor)
        {
            GVAR.g_ManageDB.GetMatchResultPoints(GVAR.g_matchID, nColor, ref m_nPoints, ref m_nPointsSplit1st, ref m_nPointsSplit2nd, ref m_nPointsSplit3rd, ref m_nWinsets, ref m_nPointsSplit1st_AddTime, ref m_nPointsSplit2nd_Addtime, ref m_nPointsSplit3rd_Addtime);
        }

        public void UpdateMatchSplitResultIDandWinsets(int nColor)
        {
            GVAR.g_ManageDB.UpdateMatchSplitResultAndWinsets(GVAR.g_matchID, GVAR.g_matchSplitID, nColor, m_nResultIDSplit1st);
        }

        public void UpdateMatchIRMandHantei(int nColor)
        {
            GVAR.g_ManageDB.UpdateMatchIRMandHantei(GVAR.g_matchID, nColor, m_nHantei, m_strIRMCode);
        }

        public void GetMatchIRMandHantei(int nColor)
        {
            GVAR.g_ManageDB.GetMatchIRMandHantei(GVAR.g_matchID, nColor, ref m_nHantei, ref m_strIRMCode);
        }

        public void UpdateMatchResultandRank(int nColor)
        {
            GVAR.g_ManageDB.UpdateMatchResultandRank(GVAR.g_matchID, nColor, m_nResultID, m_nRank);
        }

        public void UpdateMatchClassidicationPoints(int nColor)
        {
            GVAR.g_ManageDB.UpdateMatchClassidicationPoints(GVAR.g_matchID, nColor, m_nClassidicationPoints);
        }

        public void GetMatchClassidicationPoints(int nColor)
        {
            GVAR.g_ManageDB.GetMatchClassidicationPoints(GVAR.g_matchID, nColor, ref m_nClassidicationPoints);
        }

        #endregion
    }

    public class OVRWRMatch_Individual
    {
        #region Fields

        private OVRWRMatchResult_Individual m_nRed = new OVRWRMatchResult_Individual();
        private OVRWRMatchResult_Individual m_nBlue = new OVRWRMatchResult_Individual();

        private int m_nMatchID;				// -> TS_Match_Result.F_MatchID
        private int m_nSplitID;

        private int m_nStatusID;
        private int m_nStatusIDSplit1st;
        private int m_nStatusIDSplit2nd;
        private int m_nStatusIDSplit3rd;

        private string m_strDecisionCode;
        private string m_strDecisionCodeSplit1st;
        private string m_strDecisionCodeSplit2nd;
        private string m_strDecisionCodeSplit3rd;

        private int m_nHanteiSplit_A;
        private int m_nHanteiSplit_B;

        private int m_nHantei_A;
        private int m_nHantei_B;

        #endregion

        #region Property

        public int ClassidicationPoints_Red
        {
            get { return m_nRed.ClassidicationPoints; }
            set { m_nRed.ClassidicationPoints = value; }
        }

        public int ClassidicationPoints_Blue
        {
            get { return m_nBlue.ClassidicationPoints; }
            set { m_nBlue.ClassidicationPoints = value; }
        }

        public string IRMCode_Red
        {
            get { return this.m_nRed.IRMCode; }
            set { this.m_nRed.IRMCode = value; }
        }

        public string IRMCode_Blue
        {
            get { return this.m_nBlue.IRMCode; }
            set { m_nBlue.IRMCode = value; }
        }

        public int StatusID
        {
            get { return m_nStatusID; }
            set { m_nStatusID = value; }

        }

        public int StatusIDSplit1st
        {
            get
            {

                if (m_nStatusIDSplit1st > 40) return m_nStatusIDSplit1st;
                else return 40;
            }
            set { m_nStatusIDSplit1st = value; }
        }

        public string DecisionCode
        {
            get { return m_strDecisionCode; }
            set { m_strDecisionCode = value; }
        }

        public string DecisionCodeSplit1st
        {
            get { return m_strDecisionCodeSplit1st; }
            set { m_strDecisionCodeSplit1st = value; }
        }

        public int PointsTotal_Red
        {
            get { return m_nRed.Points; }
            set { m_nRed.Points = value; }
        }

        public int PointsTotal_Blue
        {
            get { return m_nBlue.Points; }
            set { m_nBlue.Points = value; }
        }

        public int PointsSplit1st_AddTime_Red
        {
            get { return m_nRed.PointsSplit1st_AddTime; }
            set { m_nRed.PointsSplit1st_AddTime = value; }
        }

        public int PointsSplit2nd_AddTime_Red
        {
            get { return m_nRed.PointsSplit2nd_AddTime; }
            set { m_nRed.PointsSplit2nd_AddTime = value; }

        }

        public int PointsSplit3rd_AddTime_Red
        {
            get { return m_nRed.PointsSplit3rd_AddTime; }
            set { m_nRed.PointsSplit3rd_AddTime = value; }
        }

        public int PointsSplit1st_AddTime_Blue
        {
            get { return m_nBlue.PointsSplit1st_AddTime; }
            set { m_nBlue.PointsSplit1st_AddTime = value; }
        }

        public int PointsSplit2nd_AddTime_Blue
        {
            get { return m_nBlue.PointsSplit2nd_AddTime; }
            set { m_nBlue.PointsSplit2nd_AddTime = value; }
        }

        public int PointsSplit3rd_AddTime_Blue
        {
            get { return m_nBlue.PointsSplit3rd_AddTime; }
            set { m_nBlue.PointsSplit3rd_AddTime = value; }
        }

        public int PointsSplit1st_Red
        {
            get { return m_nRed.PointsSplit1st; }
            set { m_nRed.PointsSplit1st = value; }
        }

        public int PointsSplit2nd_Red
        {
            get { return m_nRed.PointsSplit2nd; }
            set { m_nRed.PointsSplit2nd = value; }
        }

        public int PointsSplit3rd_Red
        {
            get { return m_nRed.PointsSplit3rd; }
            set { m_nRed.PointsSplit3rd = value; }
        }

        public int PointsSplit1st_Blue
        {
            get { return m_nBlue.PointsSplit1st; }
            set { m_nBlue.PointsSplit1st = value; }
        }

        public int PointsSplit2nd_Blue
        {
            get { return m_nBlue.PointsSplit2nd; }
            set { m_nBlue.PointsSplit2nd = value; }
        }

        public int PointsSplit3rd_Blue
        {
            get { return m_nBlue.PointsSplit3rd; }
            set { m_nBlue.PointsSplit3rd = value; }
        }


        public int ResultID_A
        {
            get { return this.m_nRed.ResultID; }
            set { m_nRed.ResultID = value; }
        }

        public int ResultID_B
        {
            get { return this.m_nBlue.ResultID; }
            set { this.m_nBlue.ResultID = value; }
        }

        public int ResultSplitID_A
        {
            get { return this.m_nRed.ResultIDSplit1st; }
            set { this.m_nRed.ResultIDSplit1st = value; }
        }

        public int ResultSplitID_B
        {
            get { return this.m_nBlue.ResultIDSplit1st; }
            set { this.m_nBlue.ResultIDSplit1st = value; }
        }

        public int Hantei_A
        {
            get { return m_nRed.Hantai; }
            set { this.m_nRed.Hantai = value; }
        }

        public int Hantei_B
        {
            get { return this.m_nBlue.Hantai; }
            set { this.m_nBlue.Hantai = value; }
        }

        public int HanteiSplit_A
        {
            get { return this.m_nHanteiSplit_A; }
            set { this.m_nHanteiSplit_A = value; }
        }

        public int HanteiSplit_B
        {
            get { return m_nHanteiSplit_B; }
            set { m_nHanteiSplit_B = value; }
        }

        public int Winset_A
        {
            get { return m_nRed.Winsets; }
            set { m_nRed.Winsets = value; }
        }

        public int Winset_B
        {
            get { return m_nBlue.Winsets; }
            set { m_nBlue.Winsets = value; }
        }

        #endregion



        #region public function

        public void UpdateMatchResultPoints()
        {
            m_nRed.UpdateMatchPoints(1);
            m_nBlue.UpdateMatchPoints(2);
            GetMatchResultPoints();
        }

        public void GetMatchResultPoints()
        {
            m_nRed.GetMatchResultPoints(1);
            m_nBlue.GetMatchResultPoints(2);
        }


        public int GetMatchStatus(int nMatchSplitID)
        {
            return GVAR.g_ManageDB.GetMatchStatus(GVAR.g_matchID, nMatchSplitID);
        }

        public void UpdateSplitStatusAndDecisionCode()
        {
            GVAR.g_ManageDB.UpdateSplitStatusAndDecisionCode(GVAR.g_matchID, GVAR.g_matchSplitID, m_nStatusIDSplit1st, m_strDecisionCodeSplit1st);
        }

        public void GetSplitDecisionCodeAndSplitStatus()
        {
            GVAR.g_ManageDB.GetMatchSplitStatusAndDesicionCode(GVAR.g_matchID, GVAR.g_matchSplitID, ref m_nStatusIDSplit1st, ref m_strDecisionCodeSplit1st, ref m_nHanteiSplit_A, ref m_nHanteiSplit_B);
        }

        public void UpdateMatchSplitHantei()
        {
            GVAR.g_ManageDB.UpdateMatchSplitHantei(GVAR.g_matchID, GVAR.g_matchSplitID, m_nHanteiSplit_A, m_nHanteiSplit_B);
        }

        public void UpdateMatch_IRMandHantei()
        {
            m_nRed.UpdateMatchIRMandHantei(1);
            m_nBlue.UpdateMatchIRMandHantei(2);

            GetMatch_IRMandHantei();
        }

        public void GetMatch_IRMandHantei()
        {
            m_nRed.GetMatchIRMandHantei(1);
            m_nBlue.GetMatchIRMandHantei(2);
        }

        public void UpdateMatchResultandRank()
        {
            m_nRed.UpdateMatchResultandRank(1);
            m_nBlue.UpdateMatchResultandRank(2);
        }

        public void UpdateMatchDecisionCode()
        {
            GVAR.g_ManageDB.UpdateMatchDecision(GVAR.g_matchID, m_strDecisionCode);

            GetMatchDecisonCode();
        }

        public void GetMatchDecisonCode()
        {
            GVAR.g_ManageDB.GetMatchDecisionCode(GVAR.g_matchID, ref m_strDecisionCode);
        }

        public void UpdateMatchClassidicationPoints()
        {
            m_nRed.UpdateMatchClassidicationPoints(1);
            m_nBlue.UpdateMatchClassidicationPoints(2);

            GetMatchClassidicationPoints();
        }

        public void GetMatchClassidicationPoints()
        {
            m_nRed.GetMatchClassidicationPoints(1);
            m_nBlue.GetMatchClassidicationPoints(2);
        }

        #endregion

        #region 判定局、比赛胜负 Desicion

        private void Whowin_MatchSplit(int nWho)
        {
            if (nWho == 1)
            {
                m_nRed.ResultIDSplit1st = GVAR.RESULT_TYPE_WIN;
                m_nBlue.ResultIDSplit1st = GVAR.RESULT_TYPE_LOSE;

            }
            else if (nWho == 2)
            {
                m_nBlue.ResultIDSplit1st = GVAR.RESULT_TYPE_WIN;
                m_nRed.ResultIDSplit1st = GVAR.RESULT_TYPE_LOSE;
            }
            else
            {
                m_nRed.ResultIDSplit1st = GVAR.RESULT_TYPE_TIE;
                m_nBlue.ResultIDSplit1st = GVAR.RESULT_TYPE_TIE;
            }
        }

        public void Decision_MatchSplit()
        {
            if (HanteiSplit_A == 1)
            {
                Whowin_MatchSplit(1);
            }
            else if (HanteiSplit_B == 1)
            {
                Whowin_MatchSplit(2);
            }
            else
            {
                if (GVAR.g_matchSplitID == 1)
                {
                    if (PointsSplit1st_Red + PointsSplit1st_AddTime_Red > PointsSplit1st_Blue + PointsSplit1st_AddTime_Blue)
                    {
                        Whowin_MatchSplit(1);
                    }
                    else if (PointsSplit1st_Blue + PointsSplit1st_AddTime_Blue > PointsSplit1st_Red + PointsSplit1st_AddTime_Red)
                    {
                        Whowin_MatchSplit(2);
                    }
                }
                else if (GVAR.g_matchSplitID == 2)
                {
                    if (PointsSplit2nd_Red + PointsSplit2nd_AddTime_Red > PointsSplit2nd_Blue + PointsSplit2nd_AddTime_Blue)
                    {
                        Whowin_MatchSplit(1);
                    }
                    else if (PointsSplit2nd_Blue + PointsSplit2nd_AddTime_Blue > PointsSplit2nd_Red + PointsSplit2nd_AddTime_Red)
                    {
                        Whowin_MatchSplit(2);
                    }
                }
                else if (GVAR.g_matchSplitID == 3)
                {
                    if (PointsSplit3rd_Red + PointsSplit3rd_AddTime_Red > PointsSplit3rd_Blue + PointsSplit3rd_AddTime_Blue)
                    {
                        Whowin_MatchSplit(1);
                    }
                    else if (PointsSplit3rd_Blue + PointsSplit3rd_AddTime_Blue > PointsSplit3rd_Red + PointsSplit3rd_AddTime_Red)
                    {
                        Whowin_MatchSplit(2);
                    }
                }
            }

        }

        public void UpateMatchSplitResultAndWinsets()
        {
            m_nRed.UpdateMatchSplitResultIDandWinsets(1);
            m_nBlue.UpdateMatchSplitResultIDandWinsets(2);

            GetMatchResultPoints();
        }

        private void WhoWin(int nWho)
        {
            if (nWho == 1)
            {
                m_nRed.ResultID = GVAR.RESULT_TYPE_WIN;
                m_nRed.Rank = GVAR.RANK_TYPE_1ST;

                m_nBlue.ResultID = GVAR.RESULT_TYPE_LOSE;
                m_nBlue.Rank = GVAR.RANK_TYPE_2ND;

            }
            else if (2 == nWho)
            {
                m_nRed.ResultID = GVAR.RESULT_TYPE_LOSE;
                m_nRed.Rank = GVAR.RANK_TYPE_2ND;

                m_nBlue.ResultID = GVAR.RESULT_TYPE_WIN;
                m_nBlue.Rank = GVAR.RANK_TYPE_1ST;
            }
            else
            {
                m_nRed.ResultID = GVAR.RESULT_TYPE_TIE;
                m_nRed.Rank = GVAR.RANK_TYPE_TIE;

                m_nBlue.ResultID = GVAR.RESULT_TYPE_TIE;
                m_nBlue.Rank = GVAR.RANK_TYPE_TIE;
            }
        }

        public void Decision()
        {
            if (Hantei_A == 1 || IRMCode_Blue != "")
            {
                WhoWin(1);
            }
            else if (Hantei_B == 1 || IRMCode_Red != "")
            {
                WhoWin(2);
            }
            else if (Winset_A > Winset_B)
            {
                WhoWin(1);
            }
            else if (Winset_A < Winset_B)
            {
                WhoWin(2);
            }
            else if (PointsTotal_Red > PointsTotal_Blue)
            {
                WhoWin(1);
            }
            else if (PointsTotal_Red < PointsTotal_Blue)
            {
                WhoWin(2);
            }

            SetCalssidicationPoints();
        }

        public void SetCalssidicationPoints()
        {
            try
            {
                if (IRMCode_Red != "")
                {
                    m_nRed.ClassidicationPoints = 0;
                    m_nBlue.ClassidicationPoints = 5;
                    if (IRMCode_Red == "DSQ")
                    {
                        m_strDecisionCode = "EV";
                    }
                    else if (IRMCode_Red == "FALL")
                    {
                        m_strDecisionCode = "VT";
                    }
                    else if (IRMCode_Red == "WITHDRAWAL")
                    {
                        m_strDecisionCode = "VA";
                    }
                    else if (IRMCode_Red == "FORFEIT")
                    {
                        m_strDecisionCode = "VF";
                    }
                    else if (IRMCode_Red == "THREE \"0\"")
                    {
                        m_strDecisionCode = "EX";
                    }
                    else if (IRMCode_Red == "DNF")
                    {
                        m_strDecisionCode = "VB";
                    }
                    else
                        m_strDecisionCode = "VA";
                }
                else if (IRMCode_Blue != "")
                {
                    m_nRed.ClassidicationPoints = 5;
                    m_nBlue.ClassidicationPoints = 0;
                    if (IRMCode_Blue == "DSQ")
                    {
                        m_strDecisionCode = "EV";
                    }
                    else if (IRMCode_Blue == "FALL")
                    {
                        m_strDecisionCode = "VT";
                    }
                    else if (IRMCode_Blue == "WITHDRAWAL")
                    {
                        m_strDecisionCode = "VA";
                    }
                    else if (IRMCode_Blue == "FORFEIT")
                    {
                        m_strDecisionCode = "VF";
                    }
                    else if (IRMCode_Blue == "THREE \"0\"")
                    {
                        m_strDecisionCode = "EX";
                    }
                    else if (IRMCode_Blue == "DNF")
                    {
                        m_strDecisionCode = "VB";
                    }
                    else
                        m_strDecisionCode = "VA";
                }
                else if (IsTechnicalSuperiority(1))
                {
                    m_nRed.ClassidicationPoints = 4;
                    if (PointsTotal_Blue == 0)
                    {
                        m_nBlue.ClassidicationPoints = 0;
                        m_strDecisionCode = "ST";
                    }
                    else
                    {
                        m_nBlue.ClassidicationPoints = 1;
                        m_strDecisionCode = "SP";
                    }

                }
                else if (IsTechnicalSuperiority(2))
                {
                    m_nBlue.ClassidicationPoints = 4;
                    if (PointsTotal_Red == 0)
                    {
                        m_nRed.ClassidicationPoints = 0;
                        m_strDecisionCode = "ST";
                    }
                    else
                    {
                        m_nRed.ClassidicationPoints = 1;
                        m_strDecisionCode = "SP";
                    }
                }
                else if (m_nRed.ResultID == 1)
                {
                    m_nRed.ClassidicationPoints = 3;
                    m_nBlue.ClassidicationPoints = 1;
                    m_strDecisionCode = "PP";
                    if (PointsTotal_Blue == 0)
                    {
                        m_nBlue.ClassidicationPoints = 0;
                        m_strDecisionCode = "PO";
                    }
                }
                else if (m_nBlue.ResultID == 1)
                {
                    m_nBlue.ClassidicationPoints = 3;
                    m_nRed.ClassidicationPoints = 1;
                    m_strDecisionCode = "PP";
                    if (PointsTotal_Red == 0)
                    {
                        m_nRed.ClassidicationPoints = 0;
                        m_strDecisionCode = "PO";
                    }
                }
                //else if (PointsTotal_Red > PointsTotal_Blue)
                //{
                //    m_nRed.ClassidicationPoints = 3;
                //    m_nBlue.ClassidicationPoints = 1;
                //    m_strDecisionCode = "Points";
                //    if (PointsTotal_Blue == 0) m_nBlue.ClassidicationPoints = 0;
                //}
                //else if (PointsTotal_Blue > PointsTotal_Red)
                //{
                //    m_nBlue.ClassidicationPoints = 3;
                //    m_nRed.ClassidicationPoints = 1;
                //    m_strDecisionCode = "Points";
                //    if (PointsTotal_Red == 0) m_nRed.ClassidicationPoints = 0;
                //}
                //else if (m_nRed.ResultID == 1)
                //{
                //    m_nRed.ClassidicationPoints = 3;
                //    m_nBlue.ClassidicationPoints = 1;
                //    m_strDecisionCode = "Points";
                //}
                //else if (m_nBlue.ResultID == 1)
                //{
                //    m_nBlue.ClassidicationPoints = 3;
                //    m_nRed.ClassidicationPoints = 1;
                //    m_strDecisionCode = "Points";
                //}
            }
            catch (System.Exception ex)
            {

            }

        }

        private bool IsTechnicalSuperiority(int nColor)
        {


            if (nColor == 1)
            {
                //if (
                //    (PointsSplit1st_Red + PointsSplit1st_AddTime_Red - PointsSplit1st_Blue - PointsSplit1st_AddTime_Blue > 5 
                //    && PointsSplit2nd_Red + PointsSplit2nd_AddTime_Red - PointsSplit2nd_Blue - PointsSplit2nd_AddTime_Blue > 5)

                //    || (PointsSplit2nd_Red + PointsSplit2nd_AddTime_Red - PointsSplit2nd_Blue - PointsSplit2nd_AddTime_Blue > 5 
                //    && PointsSplit3rd_Red + PointsSplit3rd_AddTime_Red - PointsSplit3rd_Blue - PointsSplit3rd_AddTime_Blue > 5) 

                //    || (PointsSplit3rd_Red + PointsSplit3rd_AddTime_Red - PointsSplit3rd_Blue - PointsSplit3rd_AddTime_Blue > 5 
                //    && PointsSplit1st_Red + PointsSplit1st_AddTime_Red - PointsSplit1st_Blue - PointsSplit1st_AddTime_Blue > 5)
                //    )
                if (
                    PointsSplit1st_Red +
                    PointsSplit1st_AddTime_Red +
                    PointsSplit2nd_Red +
                    PointsSplit2nd_AddTime_Red -
                    PointsSplit1st_Blue -
                    PointsSplit2nd_Blue -
                    PointsSplit1st_AddTime_Blue -
                    PointsSplit2nd_AddTime_Blue > 6)
                    return true;
                else return false;
            }
            else
            {
                //if ((PointsSplit1st_Blue + PointsSplit1st_AddTime_Blue - PointsSplit1st_Red - PointsSplit1st_AddTime_Red > 5 && PointsSplit2nd_Blue + PointsSplit2nd_AddTime_Blue - PointsSplit2nd_Red - PointsSplit2nd_AddTime_Red > 5) || (PointsSplit2nd_Blue + PointsSplit2nd_AddTime_Blue - PointsSplit2nd_Red - PointsSplit2nd_AddTime_Red > 5 && PointsSplit3rd_Blue + PointsSplit3rd_AddTime_Blue - PointsSplit3rd_Red - PointsSplit3rd_AddTime_Red > 5) || (PointsSplit3rd_Blue + PointsSplit3rd_AddTime_Blue - PointsSplit3rd_Red - PointsSplit3rd_AddTime_Red > 5 && PointsSplit1st_Blue + PointsSplit1st_AddTime_Blue - PointsSplit1st_Red - PointsSplit1st_AddTime_Red > 5))
                if (PointsSplit1st_Blue +
                    PointsSplit2nd_Blue +
                    PointsSplit1st_AddTime_Blue +
                    PointsSplit2nd_AddTime_Blue -
                    PointsSplit1st_Red -
                   PointsSplit1st_AddTime_Red -
                   PointsSplit2nd_Red -
                   PointsSplit2nd_AddTime_Red > 6)
                    return true;
                else return false;
            }
        }


        #endregion
    }

}

