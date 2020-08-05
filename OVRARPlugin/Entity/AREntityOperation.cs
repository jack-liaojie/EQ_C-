using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Collections;
using System.Data;
using DevComponents.DotNetBar;
using AutoSports.OVRCommon;

namespace AutoSports.OVRARPlugin
{
    public class AREntityOperation
    {
        #region 获得比赛的局、箭
        public static List<AR_Archer> GetCompetitionPlayersInfo(int nMatchID)
        {
            List<AR_Archer> Archers = new List<AR_Archer>();

            Archers = GetCompetitionPlayers(nMatchID);

            foreach (AR_Archer ar in Archers)
            {
                List<AR_Archer> members = AREntityOperation.GetCompetitionTeamMembers(nMatchID, ar.RegisterID);
                ar.Members = members;
                List<AR_End> myEnds = new List<AR_End>();
                myEnds = GetPlayerEnds(nMatchID, ar.CompetitionPosition);
                foreach (AR_End end in myEnds)
                {
                    List<AR_Arrow> arrows = new List<AR_Arrow>();
                    arrows = GetPlayerArrows(nMatchID, end.SplitID, end.CompetitionPosition);

                    end.Arrows = arrows;
                }

                ar.Ends = myEnds;

                List<AR_End> myShootEnds = new List<AR_End>();
                myShootEnds = GetPlayerShootEnds(nMatchID, ar.CompetitionPosition);
                foreach (AR_End end in myShootEnds)
                {
                    List<AR_Arrow> arrows = new List<AR_Arrow>();
                    arrows = GetPlayerShootArrows(nMatchID, end.SplitID, end.CompetitionPosition);

                    end.Arrows = arrows;
                }

                ar.ShootEnds = myShootEnds;
            }

            return Archers;
        }

        public static List<AR_Archer> GetCompetitionPlayers(int nMatchID)
        {
            List<AR_Archer> Archers = new List<AR_Archer>();

            DataTable dt = GVAR.g_ManageDB.GetCompetitionPlayers(nMatchID);
            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                string strFieldName = "";
                object obj = null;
                AR_Archer onePlayer = new AR_Archer();

                strFieldName = "F_CompetitionPosition";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.CompetitionPosition = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_RegisterID";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.RegisterID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "Bib";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.Bib = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Name";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.Name = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "NOC";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.Noc = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Rank";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.QRank = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Total";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.Total = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Point";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.Result = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "IRM";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.IRM = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "10s";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.Num10S = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Xs";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.NumXS = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Remark";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.Remark = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Target";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.Target = ARFunctions.ConvertToStringFromObject(obj);

                Archers.Add(onePlayer);

            }
            return Archers;
        }

        public static List<AR_Archer> GetCompetitionTeamMembers(int nMatchID, int nRegisterID)
        {
            List<AR_Archer> Archers = new List<AR_Archer>();

            DataTable dt = GVAR.g_ManageDB.GetCompetitionTeamMembers(nMatchID, nRegisterID);
            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                string strFieldName = "";
                object obj = null;
                AR_Archer onePlayer = new AR_Archer();

                strFieldName = "F_CompetitionPosition";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.CompetitionPosition = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_RegisterID";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.RegisterID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "Bib";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.Bib = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Name";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.Name = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "NOC";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.Noc = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Rank";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.QRank = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Total";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.Total = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Point";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.Result = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "IRM";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.IRM = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "10s";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.Num10S = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Xs";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.NumXS = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Remark";
                obj = dt.Rows[nRow][strFieldName];
                onePlayer.Remark = ARFunctions.ConvertToStringFromObject(obj);

                Archers.Add(onePlayer);

            }
            return Archers;
        }

        public static List<AR_End> GetPlayerEnds(int nMatchID, int nCompetitionPosition)
        {
            List<AR_End> myEnds = new List<AR_End>();
            DataTable dt = GVAR.g_ManageDB.GetPlayerEnds(nMatchID, 1, nCompetitionPosition, "-1");

            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                string strFieldName = "";
                object obj = null;
                AR_End oneEnd = new AR_End();

                strFieldName = "F_CompetitionPosition";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.CompetitionPosition = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "Total";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Total = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "EndIndex";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.EndIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "EndCode";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.EndIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_MatchID";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.MatchID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_MatchSplitID";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.SplitID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "SetPoints";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Point = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Num10s";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.R10Num = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "NumXs";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Xnum = ARFunctions.ConvertToStringFromObject(obj);

                myEnds.Add(oneEnd);
            }
            return myEnds;
        }

        public static AR_End GetPlayerOneEnd(int nMatchID, int nCompetitionPosition, string nEndIndex)
        {
            List<AR_End> myEnds = new List<AR_End>();
            DataTable dt = GVAR.g_ManageDB.GetPlayerEnds(nMatchID, 1, nCompetitionPosition, nEndIndex);

            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                string strFieldName = "";
                object obj = null;
                AR_End oneEnd = new AR_End();

                strFieldName = "F_CompetitionPosition";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.CompetitionPosition = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_Points";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Total = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "EndIndex";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.EndIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "EndCode";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.EndIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_MatchID";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.MatchID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_MatchSplitID";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.SplitID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "SetPoints";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Point = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Num10s";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.R10Num = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "NumXs";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Xnum = ARFunctions.ConvertToStringFromObject(obj);

                myEnds.Add(oneEnd);
            }
            AR_End ar = new AR_End();
            if (myEnds.Count > 0)
                ar = myEnds[0];
            return ar;
        }

        public static List<AR_Arrow> GetPlayerArrows(int nMatchID, int nSplitID, int nCompetitionPosition)
        {
            List<AR_Arrow> Arrows = new List<AR_Arrow>();
            DataTable dt = GVAR.g_ManageDB.GetPlayerArrows(nMatchID, nSplitID, nCompetitionPosition, "-1");

            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                string strFieldName = "";
                object obj = null;
                AR_Arrow oneAR = new AR_Arrow();

                strFieldName = "F_CompetitionPosition";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.CompetitionPosition = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_Points";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.Ring = ARFunctions.ConvertToStringFromObject(obj);

                //strFieldName = "F_Order";
                //obj = dt.Rows[nRow][strFieldName];
                //oneAR.ArrowIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_MatchSplitCode";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.ArrowIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_MatchID";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.MatchID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_MatchSplitID";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.SplitID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_FatherMatchSplitID";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.FatherSplitID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "FaterCode";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.EndIndex = ARFunctions.ConvertToStringFromObject(obj);


                Arrows.Add(oneAR);
            }
            return Arrows;
        }

        public static AR_Arrow GetPlayerOneArrow(int nMatchID, int nSplitID, int nCompetitionPosition, string nArrowIndex)
        {
            List<AR_Arrow> Arrows = new List<AR_Arrow>();
            DataTable dt = GVAR.g_ManageDB.GetPlayerArrows(nMatchID, nSplitID, nCompetitionPosition, nArrowIndex);

            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                string strFieldName = "";
                object obj = null;
                AR_Arrow oneAR = new AR_Arrow();

                strFieldName = "F_CompetitionPosition";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.CompetitionPosition = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_Points";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.Ring = ARFunctions.ConvertToStringFromObject(obj);

                //strFieldName = "F_Order";
                //obj = dt.Rows[nRow][strFieldName];
                //oneAR.ArrowIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_MatchSplitCode";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.ArrowIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_MatchID";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.MatchID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_MatchSplitID";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.SplitID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_FatherMatchSplitID";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.FatherSplitID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "FaterCode";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.EndIndex = ARFunctions.ConvertToStringFromObject(obj);


                Arrows.Add(oneAR);
            }
            AR_Arrow AA = new AR_Arrow();
            if (Arrows.Count > 0)
                AA = Arrows[0];
            return AA;
        }
        #endregion

        #region 获得某人的局、箭
        public static AR_Archer GetCompetitionPlayerInfo(int nMatchID, AR_Archer player, int nDistince)
        {

            AR_Archer Archer = player;
            if (Archer != null)
            {
                List<AR_End> myEnds = new List<AR_End>();
                myEnds = GetPlayerEndsByDistince(nMatchID, nDistince, Archer.CompetitionPosition);
                foreach (AR_End end in myEnds)
                {
                    List<AR_Arrow> arrows = new List<AR_Arrow>();
                    arrows = GetPlayerArrows(nMatchID, end.SplitID, end.CompetitionPosition);

                    end.Arrows = arrows;
                }

                Archer.Ends = myEnds;
            }

            return Archer;
        }
        public static AR_Archer GetCompetitionOnePlayerByRegisterID(int nMatchID, int nRegisterID)
        {
            AR_Archer player = new AR_Archer();
            List<AR_Archer> Archers = new List<AR_Archer>();

            Archers = GetCompetitionPlayers(nMatchID);
            foreach (AR_Archer ar in Archers)
            {
                if (ar.RegisterID == nRegisterID)
                    player = ar;
            }
            return player;
        }
        public static List<AR_End> GetPlayerEndsByDistince(int nMatchID, int nDistince, int nCompetitionPosition)
        {
            List<AR_End> myEnds = new List<AR_End>();
            DataTable dt = GVAR.g_ManageDB.GetPlayerEnds(nMatchID, nDistince, nCompetitionPosition, "-1");

            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                string strFieldName = "";
                object obj = null;
                AR_End oneEnd = new AR_End();

                strFieldName = "F_CompetitionPosition";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.CompetitionPosition = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "Total";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Total = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "EndIndex";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.EndIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "EndCode";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.EndIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_MatchID";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.MatchID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_MatchSplitID";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.SplitID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "SetPoints";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Point = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Num10s";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.R10Num = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "NumXs";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Xnum = ARFunctions.ConvertToStringFromObject(obj);

                myEnds.Add(oneEnd);
            }
            return myEnds;
        }
        public static AR_End GetPlayerOneEndByDistince(int nMatchID, int nDistince, int nCompetitionPosition, string nEndIndex)
        {
            List<AR_End> myEnds = new List<AR_End>();
            DataTable dt = GVAR.g_ManageDB.GetPlayerEnds(nMatchID, nDistince, nCompetitionPosition, nEndIndex);

            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                string strFieldName = "";
                object obj = null;
                AR_End oneEnd = new AR_End();

                strFieldName = "F_CompetitionPosition";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.CompetitionPosition = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_Points";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Total = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "EndIndex";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.EndIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "EndCode";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.EndIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_MatchID";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.MatchID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_MatchSplitID";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.SplitID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "SetPoints";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Point = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Num10s";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.R10Num = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "NumXs";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Xnum = ARFunctions.ConvertToStringFromObject(obj);

                myEnds.Add(oneEnd);
            }
            AR_End ar = new AR_End();
            if (myEnds.Count > 0)
                ar = myEnds[0];
            return ar;
        }

        #endregion

        #region 加赛

        public static List<AR_End> GetPlayerShootEnds(int nMatchID, int nCompetitionPosition)
        {
            List<AR_End> myEnds = new List<AR_End>();
            DataTable dt = GVAR.g_ManageDB.GetPlayerShootEnds(nMatchID, 1, nCompetitionPosition, "-1");

            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                string strFieldName = "";
                object obj = null;
                AR_End oneEnd = new AR_End();

                strFieldName = "F_CompetitionPosition";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.CompetitionPosition = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "Total";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Total = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "EndIndex";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.EndIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "EndCode";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.EndIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_MatchID";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.MatchID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_MatchSplitID";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.SplitID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "SetPoints";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Point = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Num10s";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.R10Num = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "NumXs";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Xnum = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "EndComment";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.EndComment = ARFunctions.ConvertToStringFromObject(obj);

                myEnds.Add(oneEnd);
            }
            return myEnds;
        }

        public static AR_End GetPlayerOneShootEnd(int nMatchID, int nCompetitionPosition, string nEndIndex)
        {
            List<AR_End> myEnds = new List<AR_End>();
            DataTable dt = GVAR.g_ManageDB.GetPlayerShootEnds(nMatchID, 1, nCompetitionPosition, nEndIndex);

            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                string strFieldName = "";
                object obj = null;
                AR_End oneEnd = new AR_End();

                strFieldName = "F_CompetitionPosition";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.CompetitionPosition = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_Points";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Total = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "EndIndex";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.EndIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "EndCode";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.EndIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_MatchID";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.MatchID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_MatchSplitID";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.SplitID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "SetPoints";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Point = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "Num10s";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.R10Num = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "NumXs";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.Xnum = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "EndComment";
                obj = dt.Rows[nRow][strFieldName];
                oneEnd.EndComment = ARFunctions.ConvertToStringFromObject(obj);

                myEnds.Add(oneEnd);
            }
            AR_End ar = new AR_End();
            if (myEnds.Count > 0)
                ar = myEnds[0];
            return ar;
        }

        public static List<AR_Arrow> GetPlayerShootArrows(int nMatchID, int nSplitID, int nCompetitionPosition)
        {
            List<AR_Arrow> Arrows = new List<AR_Arrow>();
            DataTable dt = GVAR.g_ManageDB.GetPlayerShootArrows(nMatchID, nSplitID, nCompetitionPosition, "-1");

            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                string strFieldName = "";
                object obj = null;
                AR_Arrow oneAR = new AR_Arrow();

                strFieldName = "F_CompetitionPosition";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.CompetitionPosition = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_Points";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.Ring = ARFunctions.ConvertToStringFromObject(obj);

                //strFieldName = "F_Order";
                //obj = dt.Rows[nRow][strFieldName];
                //oneAR.ArrowIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_MatchSplitCode";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.ArrowIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_MatchID";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.MatchID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_MatchSplitID";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.SplitID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_FatherMatchSplitID";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.FatherSplitID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "FaterCode";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.EndIndex = ARFunctions.ConvertToStringFromObject(obj);


                Arrows.Add(oneAR);
            }
            return Arrows;
        }

        public static AR_Arrow GetPlayerOneShootArrow(int nMatchID, int nSplitID, int nCompetitionPosition, string nArrowIndex)
        {
            List<AR_Arrow> Arrows = new List<AR_Arrow>();
            DataTable dt = GVAR.g_ManageDB.GetPlayerShootArrows(nMatchID, nSplitID, nCompetitionPosition, nArrowIndex);

            for (int nRow = 0; nRow < dt.Rows.Count; nRow++)
            {
                string strFieldName = "";
                object obj = null;
                AR_Arrow oneAR = new AR_Arrow();

                strFieldName = "F_CompetitionPosition";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.CompetitionPosition = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_Points";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.Ring = ARFunctions.ConvertToStringFromObject(obj);

                //strFieldName = "F_Order";
                //obj = dt.Rows[nRow][strFieldName];
                //oneAR.ArrowIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_MatchSplitCode";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.ArrowIndex = ARFunctions.ConvertToStringFromObject(obj);

                strFieldName = "F_MatchID";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.MatchID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_MatchSplitID";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.SplitID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "F_FatherMatchSplitID";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.FatherSplitID = ARFunctions.ConvertToIntFromObject(obj);

                strFieldName = "FaterCode";
                obj = dt.Rows[nRow][strFieldName];
                oneAR.EndIndex = ARFunctions.ConvertToStringFromObject(obj);


                Arrows.Add(oneAR);
            }
            AR_Arrow AA = new AR_Arrow();
            if (Arrows.Count > 0)
                AA = Arrows[0];
            return AA;
        }    

        #endregion

        public static AR_MatchInfo GetCurMatchInfo(int nMatchID)
        {
            AR_MatchInfo CurMatchInfo = new AR_MatchInfo();
            GVAR.g_ARPlugin.SetReportContext("MatchID", nMatchID.ToString());

            System.Data.DataTable dt = GVAR.g_ManageDB.GetMatchInfo(nMatchID);
            CurMatchInfo.MatchID = nMatchID;

            #region 比赛参数
            if (dt.Rows.Count > 0)
            { 
                if (dt.Rows[0]["F_PhaseID"] != DBNull.Value)
                    CurMatchInfo.PhaseID = int.Parse(dt.Rows[0]["F_PhaseID"].ToString());
                else
                    CurMatchInfo.PhaseID = -1;

                if (dt.Rows[0]["F_EventID"] != DBNull.Value)
                    CurMatchInfo.EventID = int.Parse(dt.Rows[0]["F_EventID"].ToString());
                else
                    CurMatchInfo.EventID = -1;

                if (dt.Rows[0]["F_PhaseID"] != DBNull.Value)
                    CurMatchInfo.PhaseID = int.Parse(dt.Rows[0]["F_PhaseID"].ToString());
                else
                    CurMatchInfo.PhaseID = -1;

                if (dt.Rows[0]["F_PlayerA"] != DBNull.Value)
                    CurMatchInfo.PlayerA = int.Parse(dt.Rows[0]["F_PlayerA"].ToString());
                else
                    CurMatchInfo.PlayerA = -1;
                if (dt.Rows[0]["F_PlayerB"] != DBNull.Value)
                    CurMatchInfo.PlayerB = int.Parse(dt.Rows[0]["F_PlayerB"].ToString());
                else
                    CurMatchInfo.PlayerB = -1;
                if (dt.Rows[0]["F_TargetA"] != DBNull.Value)
                    CurMatchInfo.TargetA = dt.Rows[0]["F_TargetA"].ToString();
                else
                    CurMatchInfo.TargetA = "";
                if (dt.Rows[0]["F_TargetB"] != DBNull.Value)
                    CurMatchInfo.TargetB = dt.Rows[0]["F_TargetB"].ToString();
                else
                    CurMatchInfo.TargetB = ""; 

                if (dt.Rows[0]["EventCode"] != DBNull.Value)
                    CurMatchInfo.EventCode = dt.Rows[0]["EventCode"].ToString();
                else
                    CurMatchInfo.EventCode = "";
                if (dt.Rows[0]["PhaseCode"] != DBNull.Value)
                    CurMatchInfo.PhaseCode = dt.Rows[0]["PhaseCode"].ToString();
                else
                    CurMatchInfo.PhaseCode = "";

                if (dt.Rows[0]["MatchCode"] != DBNull.Value)
                    CurMatchInfo.MatchCode = dt.Rows[0]["MatchCode"].ToString();
                else
                    CurMatchInfo.MatchCode = "";

                if (dt.Rows[0]["SexCode"] != DBNull.Value)
                    CurMatchInfo.SexCode = dt.Rows[0]["SexCode"].ToString();
                else
                    CurMatchInfo.SexCode = "";

                if (dt.Rows[0]["EventName"] != DBNull.Value)
                    CurMatchInfo.EventName = dt.Rows[0]["EventName"].ToString();
                else
                    CurMatchInfo.EventName = "";
                if (dt.Rows[0]["PhaseName"] != DBNull.Value)
                    CurMatchInfo.PhaseName = dt.Rows[0]["PhaseName"].ToString();
                else
                    CurMatchInfo.PhaseName = "";
                if (dt.Rows[0]["MatchName"] != DBNull.Value)
                    CurMatchInfo.MatchName = dt.Rows[0]["MatchName"].ToString();
                else
                    CurMatchInfo.MatchName = "";

                #region 局、箭数
                if (dt.Rows[0]["EndCount"] != DBNull.Value)
                    CurMatchInfo.EndCount = int.Parse(dt.Rows[0]["EndCount"].ToString());
                else
                    CurMatchInfo.EndCount = 0;
                if (dt.Rows[0]["ArrowCount"] != DBNull.Value)
                    CurMatchInfo.ArrowCount = int.Parse(dt.Rows[0]["ArrowCount"].ToString());
                else
                    CurMatchInfo.ArrowCount = 0;

                if (dt.Rows[0]["IsSetPoints"] != DBNull.Value)
                    CurMatchInfo.IsSetPoints = int.Parse(dt.Rows[0]["IsSetPoints"].ToString());
                else
                    CurMatchInfo.IsSetPoints = 0;

                if (dt.Rows[0]["WinPoints"] != DBNull.Value)
                    CurMatchInfo.WinPoints = int.Parse(dt.Rows[0]["WinPoints"].ToString());
                else
                    CurMatchInfo.WinPoints = 0;

                if (dt.Rows[0]["Distince"] != DBNull.Value)
                    CurMatchInfo.Distince = int.Parse(dt.Rows[0]["Distince"].ToString());
                else
                    CurMatchInfo.WinPoints = 0;
                #endregion

                if (dt.Rows[0]["CompetitionRuleID"] != DBNull.Value)
                    CurMatchInfo.CurMatchRuleID = int.Parse(dt.Rows[0]["CompetitionRuleID"].ToString());
                else
                    CurMatchInfo.CurMatchRuleID = -1;

                if (dt.Rows[0]["MatchStatusID"] != DBNull.Value)
                    CurMatchInfo.MatchStatusID = int.Parse(dt.Rows[0]["MatchStatusID"].ToString());
                else
                    CurMatchInfo.MatchStatusID = -1;


            #endregion

            }

            return CurMatchInfo;
        }
    }
}

