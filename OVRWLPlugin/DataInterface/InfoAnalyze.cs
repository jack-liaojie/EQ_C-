using System;
using System.Text;
using System.Data;
using System.Linq;
using System.Windows.Forms;

namespace AutoSports.OVRWLPlugin
{
    public class InfoAnalyze
    {
        public static string GetReceiveString(byte[] data)
        {
            string reStr = string.Empty;
            int ilength = data.Length;
            if (ilength > 0)
            {
                byte[] receiveData = new byte[ilength];
                Array.Copy(data, 0, receiveData, 0, ilength);
                reStr = Encoding.Default.GetString(receiveData);
            }

            return reStr;
        }

        public static DataTable GetPlayerListData(byte[] data)
        {
            DataTable dt = CreatedTSDataTable();
            string strRecData = GetReceiveString(data);

            try
            {
                if (strRecData.StartsWith("ORDER"))
                {
                    string[] rowRecData = strRecData.Split(new char[] { '\n' });
                    for (int i = 1; i < rowRecData.Length; i++)
                    {

                        string strPlayer = rowRecData[i];
                        if (!string.IsNullOrEmpty(strPlayer))
                        {

                            string[] cols = strPlayer.Split(new char[] { '|' });
                            if (cols.Length > 27 && cols[0] != "PREVIOUS")
                            {
                                DataRow dr = dt.NewRow();
                                for (int colInx = 0; colInx < 27; colInx++)
                                {
                                    dr[colInx] = cols[colInx];
                                }
                                dr["Status"] = "";
                                dt.Rows.Add(dr);
                            }
                            else if (strPlayer.StartsWith("SheetN") && cols.Length > 5)
                            {
                                if (cols[1].Length > 0 && cols[5].Length > 0)
                                {
                                    DataRow curRow = dt.Rows.Find(cols[1]);
                                    if (curRow != null)
                                        curRow["Status"] = cols[5];
                                }
                                break;
                            }
                        }
                    }
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            return dt;
        }

        private static DataTable CreatedTSDataTable()
        {
            DataTable dt = new DataTable();

            dt.Columns.Add("Bib");
            dt.Columns.Add("LotNo");
            dt.Columns.Add("NOC");
            dt.Columns.Add("Name");
            dt.Columns.Add("BirthDay");
            dt.Columns.Add("Bodyweight");
            dt.Columns.Add("Snatch1stAttempt");
            dt.Columns.Add("Snatch1stRes");
            dt.Columns.Add("Snatch2ndAttempt");
            dt.Columns.Add("Snatch2ndRes");
            dt.Columns.Add("Snatch3rdAttempt");
            dt.Columns.Add("Snatch3rdRes");
            dt.Columns.Add("SnatchResult");
            dt.Columns.Add("SnatchRank");
            dt.Columns.Add("CJerk1stAttempt");
            dt.Columns.Add("CJerk1stRes");
            dt.Columns.Add("CJerk2ndAttempt");
            dt.Columns.Add("CJerk2ndRes");
            dt.Columns.Add("CJerk3rdAttempt");
            dt.Columns.Add("CJerk3rdRes");
            dt.Columns.Add("CJerkResult");
            dt.Columns.Add("CJerkRank");
            dt.Columns.Add("TotalResult");
            dt.Columns.Add("TotalRank");
            dt.Columns.Add("Group");
            dt.Columns.Add("Event");
            dt.Columns.Add("EntryTotal");
            dt.Columns.Add("Status");
            dt.PrimaryKey = new DataColumn[] { dt.Columns["LotNo"] };
            return dt;
        }


        public static void UpdatePlayerListData(byte[] data)
        {
            string strRecData = GetReceiveString(data);
            try
            {
                if (strRecData.StartsWith("ORDER"))
                {
                    string[] rowRecData = strRecData.Split(new char[] { '\n' });
                    for (int i = 1; i < rowRecData.Length; i++)
                    {
                        string strPlayer = rowRecData[i];
                        if (!string.IsNullOrEmpty(strPlayer))
                        {
                            string[] cols = strPlayer.Split(new char[] { '|' });
                            if (cols.Length < 27)
                            {
                                continue;
                            }
                            if (cols[0] == "PREVIOUS")
                            {
                                return;
                            }
                            GVWL.g_ManageDB.InterfaceUpdatePlayerResult(Convert.ToInt32(cols[1]), cols[5], cols[6], cols[7], cols[8], cols[9], cols[10], cols[11]
                                                , cols[12], cols[13], cols[14], cols[15], cols[16], cols[17], cols[18], cols[19], cols[20], cols[21], cols[22], cols[23]);
                        }
                    }
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

    }
}
