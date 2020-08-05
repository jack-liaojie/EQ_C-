using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DevComponents.DotNetBar;
using System.Data.SqlClient;
using AutoSports.OVRCommon;
using System.Xml;
using Sunny.UI;

namespace AutoSports.OVREQPlugin
{
    public class OVREQDBManager
    {
        private string m_strSportID;
        private string m_strDisciplineID; 
        private string m_strLanguageCode;

        #region Constructor
        public OVREQDBManager()
        {
            m_strSportID = "";
            m_strDisciplineID = "";
            m_strLanguageCode = "";
        }
        #endregion

        #region Base Info
        public void GetActiveSportInfo()
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }

            int iSportID = 0;
            int iDisciplineID = 0;

            OVRDataBaseUtils.GetActiveInfo(GVAR.g_adoDataBase.DBConnect, out iSportID, out iDisciplineID, out m_strLanguageCode);

            m_strSportID = string.Format("{0:D}", iSportID);
            m_strDisciplineID = string.Format("{0:D}", iDisciplineID);
        }

        public void GetMatchInfo(int iMatchID, ref String strEventName, ref String strMatchName, ref String strDateDes, ref String strVenueDes, ref int iDisciplineID, ref int iStatusID)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GVAR.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_EQ_GetMatchInfo";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strLanguageCode);

                oneSqlCommand.Parameters.Add(cmdParameter2);

                if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
                {
                    GVAR.g_adoDataBase.DBConnect.Open();
                }

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                if (sdr.HasRows)
                {
                    if (sdr.Read())
                    {
                        strEventName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "EventDes");
                        strMatchName = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "MatchDes");
                        strDateDes = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "DateDes");
                        strVenueDes = OVRDataBaseUtils.GetFieldValue2String(ref sdr, "F_VenueLongName");
                        iDisciplineID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_DisciplineID");
                        iStatusID = OVRDataBaseUtils.GetFieldValue2Int32(ref sdr, "F_MatchStatusID");
                    }
                }
                sdr.Close();
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
        }

        public Int32 GetMatchConfigID(Int32 iMatchID)
        {
            Int32 iResult = -1;
            try
            {
                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", iMatchID);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", DbType.Int32);
                cmdParameterResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_EQ_GetMatchConfigID", cmdParameter1, cmdParameterResult);
                iResult = (Int32)cmdParameterResult.Value;
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
            return iResult;

        }

        public Int32 GetIndividualMatchID(Int32 iMatchID)
        {
            Int32 iResult = -1;
            try
            {
                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", iMatchID);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", DbType.Int32);
                cmdParameterResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_EQ_GetIndividualMatchID", cmdParameter1, cmdParameterResult);
                iResult = (Int32)cmdParameterResult.Value;
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
            return iResult;
        }

        public Int32 GetTeamMatchID(Int32 iMatchID)
        {
            Int32 iResult = -1;
            try
            {
                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", iMatchID);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", DbType.Int32);
                cmdParameterResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_EQ_GetTeamMatchID", cmdParameter1, cmdParameterResult);
                iResult = (Int32)cmdParameterResult.Value;
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
            return iResult;
        }

        public bool IsMatchHasOfficial(int iMatchID)
        {
            bool bResult = false;

            try
            {
                #region DML Command Setup for GetDataEntryType

                string strSQL = string.Format("SELECT * FROM TS_Match_Servant WHERE F_MatchID = '{0}'", iMatchID);

                SqlCommand cmd = new SqlCommand(strSQL, GVAR.g_adoDataBase.DBConnect);

                SqlDataReader sdr = cmd.ExecuteReader();
                if (sdr.HasRows)
                {
                    bResult = true;
                }
                sdr.Close();
                #endregion
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
            return bResult;
        }
        #endregion

        #region MatchConfig
        //获取比赛配置信息
        public DataTable GetMatchConfig(int iMatchID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_EQ_GetMatchConfig", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, iMatchID));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
                da.Dispose();
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }

            return dt;
        }

        //更新TS_EQ_Match_Config指定column的值（int型）
        public void UpdateMatchConfig(Int32 iMatchConfigID, string columnName, Int32 iInputValue)
        {
            String strFmt, strSQL;

            try
            {
                #region DML Command Setup for Update MatchResultDetail
                strFmt = @"UPDATE TS_EQ_Match_Config SET {0} = {1} WHERE F_MatchConfigID = {2}";
                strSQL = String.Format(strFmt, columnName, iInputValue, iMatchConfigID);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);
                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        //更新TS_EQ_Match_Config指定column的值（decimal型）
        public void UpdateMatchConfig(Int32 iMatchConfigID, string columnName, decimal fInputValue)
        {
            String strFmt, strSQL;

            try
            {
                #region DML Command Setup for Update MatchResultDetail

                strFmt = @"UPDATE TS_EQ_Match_Config SET {0} = {1}
                                WHERE F_MatchConfigID = {2}";
                strSQL = String.Format(strFmt, columnName, fInputValue, iMatchConfigID);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);
                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        //更新TS_EQ_Match_Config指定column的值（string型）
        public void UpdateMatchConfig(Int32 iMatchConfigID, string columnName, string strInputString)
        {
            String strFmt, strSQL;

            try
            {
                #region DML Command Setup for Update MatchResultDetail
                strFmt = @"UPDATE TS_EQ_Match_Config SET {0} = {1} WHERE F_MatchConfigID = {2}";
                strSQL = String.Format(strFmt, columnName, strInputString, iMatchConfigID);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);
                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        public void UpdateMatchConfigNull(Int32 iMatchConfigID, string columnName)
        {
            String strFmt, strSQL;

            try
            {
                #region DML Command Setup for Update MatchResultDetail
                strFmt = @"UPDATE TS_EQ_Match_Config SET {0} = NULL WHERE F_MatchConfigID = {1}";
                strSQL = String.Format(strFmt, columnName, iMatchConfigID);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);
                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        public bool UpdateMatchMaxMovementScore(Int32 iMatchConfigID)
        {
            bool bResult = false;
            try
            {
                SqlParameter cmdParameter1 = new SqlParameter("@MatchConfigID", iMatchConfigID);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", DbType.Int32);
                cmdParameterResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_EQ_UpdateMatchMaxMovementScore", cmdParameter1, cmdParameterResult);
                if (int.Parse(cmdParameterResult.Value.ToString()) > 0)
                {
                    bResult = true;
                }
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
            return bResult;
        }
        #endregion

        #region MatchResult
        public bool IsAddMatchResultsRows(Int32 iMatchID)
        {
            bool bResult = false;
            try
            {
                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", iMatchID);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", DbType.Int32);
                cmdParameterResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_EQ_IsAddMatchResultsRows", cmdParameter1, cmdParameterResult);
                if (int.Parse(cmdParameterResult.Value.ToString()) > 0)
                {
                    bResult = true;
                }
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
            return bResult;
        }

        //获取比赛数据并填充dgv
        //当bShowAll为true时，将显示没有出场序的人员
        public void InitDgvMatchResultList(int iMatchID, bool bShowAll,ref UIDataGridView dgv)
        {
            int iShowFrom = 0;
            if (bShowAll)
                iShowFrom = 0;
            else
                iShowFrom = 1;

            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GVAR.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_EQ_GetMatchResultList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@ShowFrom", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iShowFrom);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, m_strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
                {
                    GVAR.g_adoDataBase.DBConnect.Open();
                }


                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                OVRDataBaseUtils.FillDataGridViewWithCmb(dgv, sdr, "F_CurIRM");
                sdr.Close();
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
        }

        //判断运动员是否已经安排好比赛位置，如果安排好，则添加当前比赛的成绩行，包括result和resultdetail
        public bool AddMatchResultsRows(int iMatchID)
        {
            bool bResult = false;
            try
            {
                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", iMatchID);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", DbType.Int32);
                cmdParameterResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_EQ_AddMatchResultRows", cmdParameter1, cmdParameterResult);
                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                {
                    bResult = true;
                }
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
            return bResult;

        }

        //当点击clear data按钮时删除TS_EQ_Match_Result，TS_EQ_Match_ResultDetail对应的比赛成绩行
        public bool RemoveMatchResultsRows(int iMatchID)
        {
            bool bResult = false;
            try
            {
                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", iMatchID);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", DbType.Int32);
                cmdParameterResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_EQ_RemoveMatchResultRows", cmdParameter1, cmdParameterResult);
                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                {
                    bResult = true;
                }
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
            return bResult;
        }

        //更新TS_EQ_Match_Result的运动员行的状态
        public bool UpdateRegisterStatus(Int32 iIndividualMatchID, Int32 iRegisterID, int iStatus)
        {
            bool bResult = false;
            try
            {
                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", iIndividualMatchID);
                SqlParameter cmdParameter2 = new SqlParameter("@RegisterID", iRegisterID);
                SqlParameter cmdParameter3 = new SqlParameter("@Status", iStatus);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", DbType.Int32);
                cmdParameterResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_EQ_UpdateRegisterStatus", cmdParameter1, cmdParameter2, cmdParameter3, cmdParameterResult);
                if (int.Parse(cmdParameterResult.Value.ToString()) > 0)
                {
                    bResult = true;
                }
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
            return bResult;
        }

        //更新TS_EQ_Match_Result的成绩和排名
        public bool UpdateRegisterRankAndResult(Int32 iMatchID)
        {
            bool bResult = false;
            try
            {
                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", iMatchID);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", DbType.Int32);
                cmdParameterResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_EQ_UpdateRankAndResult", cmdParameter1, cmdParameterResult);
                if (int.Parse(cmdParameterResult.Value.ToString()) > 0)
                {
                    bResult = true;
                }
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
            return bResult;
        }

        //更新团体的出场order
        public void UpdateTeamOrder(Int32 iMatchID, Int32 iTMatchID, Int32 iTeamRegisterID, Int32 iOrder)
        {
            try
            {
                #region DML Command Setup for SetActiveMember

                String strFmt, strSQL;

                strFmt = @"UPDATE TS_EQ_Match_Result SET F_TeamOrder = {3}
                                WHERE (F_MatchID = {0} AND F_TeamRegisterID = {2}) OR (F_MatchID = {1} AND F_RegisterID = {2})";
                strSQL = String.Format(strFmt, iMatchID, iTMatchID, iTeamRegisterID, iOrder);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);

                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        //更新团体的排名order
        public void UpdateTotTeamOrder(Int32 iMatchID, Int32 iTMatchID, Int32 iTeamRegisterID, Int32 iOrder)
        {
            try
            {
                #region DML Command Setup for SetActiveMember

                String strFmt, strSQL;

                strFmt = @"UPDATE TS_EQ_Match_Result SET F_TotTeamOrder = {3}
                                WHERE (F_MatchID = {0} AND F_TeamRegisterID = {2}) OR (F_MatchID = {1} AND F_RegisterID = {2})";
                strSQL = String.Format(strFmt, iMatchID, iTMatchID, iTeamRegisterID, iOrder);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);

                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        //更新骑手编号和马号
        public void UpdateRegisterBib(Int32 iRegisterID, string strBib)
        {
            try
            {
                #region DML Command Setup for SetActiveMember

                String strFmt, strSQL;

                strFmt = @"UPDATE TR_Register SET F_Bib = {1} WHERE F_RegisterID = {0}";
                strSQL = String.Format(strFmt, iRegisterID, strBib);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);

                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        //更新骑手编号和马号
        public void UpdateRegisterName(Int32 iRegisterID, string strName)
        {
            try
            {
                #region DML Command Setup for SetActiveMember

                String strFmt, strSQL;

                strFmt = @"UPDATE TR_Register_Des SET F_LongName = {1},F_ShortName = {1} WHERE F_RegisterID = {0}";
                strSQL = String.Format(strFmt, iRegisterID, strName);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);

                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        //直接更新TS_EQ_Match_Result指定column的分数
        public void UpdateColumnPoint(Int32 iMatchID, Int32 iRegisterID, string columnName, Int32 iScore)
        {
            try
            {
                #region DML Command Setup for SetActiveMember

                String strFmt, strSQL;

                strFmt = @"UPDATE TS_EQ_Match_Result SET {0} = {3}
                                WHERE F_MatchID = {1} AND F_RegisterID = {2}";
                strSQL = String.Format(strFmt, columnName, iMatchID, iRegisterID, iScore);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);

                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        public void UpdateColumnPoint(Int32 iMatchID, Int32 iRegisterID, string columnName, string strScore)
        {
            try
            {
                #region DML Command Setup for SetActiveMember

                String strFmt, strSQL;

                strFmt = @"UPDATE TS_EQ_Match_Result SET {0} = {3}
                                WHERE F_MatchID = {1} AND F_RegisterID = {2}";
                strSQL = String.Format(strFmt, columnName, iMatchID, iRegisterID, strScore);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);

                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        public void UpdateColumnPoint(Int32 iMatchID, Int32 iRegisterID, string columnName, decimal fScore)
        {
            try
            {
                #region DML Command Setup for SetActiveMember

                String strFmt, strSQL;

                strFmt = @"UPDATE TS_EQ_Match_Result SET {0} = {3}
                                WHERE F_MatchID = {1} AND F_RegisterID = {2}";
                strSQL = String.Format(strFmt, columnName, iMatchID, iRegisterID, fScore);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);

                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        
        //更新CurPoints
        public bool UpdateCurPointsWhenScoreChanged(Int32 iMatchID, Int32 iRegisterID,Int32 iFromDetail)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GVAR.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_EQ_UpdateCurPointsWhenScoreChanged";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iRegisterID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@FromDetail", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iFromDetail);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
                {
                    GVAR.g_adoDataBase.DBConnect.Open();
                }


                oneSqlCommand.ExecuteNonQuery();
                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;

            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
                return false;
            }


        }

        //更新CurPoints
        public bool UpdateTotPointsWhenCurPointsChanged(Int32 iMatchID, Int32 iRegisterID)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GVAR.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_EQ_UpdateTotPointsWhenCurPointsChanged";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iRegisterID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
                {
                    GVAR.g_adoDataBase.DBConnect.Open();
                }


                oneSqlCommand.ExecuteNonQuery();
                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;

            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
                return false;
            }


        }

        public bool UpdateCurTimePen(Int32 iMatchID, Int32 iRegisterID, Decimal fInputValue)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GVAR.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_EQ_UpdateCurTimePen";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iRegisterID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@Time", SqlDbType.Decimal, 8,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, fInputValue);
                oneSqlCommand.Parameters.Add(cmdParameter3);

                SqlParameter cmdParameterResult = new SqlParameter(
                            "@Result", SqlDbType.Int, 4,
                            ParameterDirection.Output, true, 0, 0, "",
                            DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
                {
                    GVAR.g_adoDataBase.DBConnect.Open();
                }


                oneSqlCommand.ExecuteNonQuery();
                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;

            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
                return false;
            }
        }

        //获取combobox列表
        public void InitIRMCombBox(ref UIDataGridView GridCtrl, Int32 iColumnIndex, Int32 iDisciplineID, String strLanguageCode)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GVAR.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_EQ_GetIRMList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@DisciplineID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iDisciplineID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                //往combobox添加item
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(sdr, 1, 0);
                sdr.Close();
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
        }

        public bool UpdateIRM(int iMatchID, int iRegisterID, string strIRM)
        {
            bool bResult = false;
            try
            {
                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", iMatchID);
                SqlParameter cmdParameter2 = new SqlParameter("@RegisterID", iRegisterID);
                SqlParameter cmdParameter3 = new SqlParameter("@IRM", strIRM);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", DbType.Int32);
                cmdParameterResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_EQ_UpdateIRM", cmdParameter1, cmdParameter2, cmdParameter3, cmdParameterResult);
                if (int.Parse(cmdParameterResult.Value.ToString()) > 0)
                {
                    bResult = true;
                }
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
            return bResult;

        }

        //更新当前比赛运动员的开始时间，间隔时间，完成时间
        public bool UpdateMatchTime(int nMatchID, int iRegisterID, string strStartTime, string strBreakTime, string strFinishTime)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GVAR.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_EQ_UpdateMatchTime";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                oneSqlCommand.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, nMatchID));
                oneSqlCommand.Parameters.Add(new SqlParameter("@RegisterID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RegisterID", DataRowVersion.Current, iRegisterID));
                if (strStartTime.Length != 0)
                    oneSqlCommand.Parameters.Add(new SqlParameter("@StartTime", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@StartTime", DataRowVersion.Current, strStartTime));
                else
                    oneSqlCommand.Parameters.Add(new SqlParameter("@StartTime", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@StartTime", DataRowVersion.Current, DBNull.Value));
                if (strBreakTime.Length != 0)
                    oneSqlCommand.Parameters.Add(new SqlParameter("@BreakTime", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@BreakTime", DataRowVersion.Current, strBreakTime));
                else
                    oneSqlCommand.Parameters.Add(new SqlParameter("@BreakTime", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@BreakTime", DataRowVersion.Current, DBNull.Value));
                if (strFinishTime.Length != 0)
                    oneSqlCommand.Parameters.Add(new SqlParameter("@FinishTime", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@FinishTime", DataRowVersion.Current, strFinishTime));
                else
                    oneSqlCommand.Parameters.Add(new SqlParameter("@FinishTime", SqlDbType.VarChar, 50, ParameterDirection.Input, true, 0, 0, "@FinishTime", DataRowVersion.Current, DBNull.Value));
                SqlParameter cmdParameterResult = new SqlParameter("@Return", SqlDbType.Int, 4, ParameterDirection.Output, true, 0, 0, "", DataRowVersion.Current, 0);
                oneSqlCommand.Parameters.Add(cmdParameterResult);

                if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
                {
                    GVAR.g_adoDataBase.DBConnect.Open();
                }


                oneSqlCommand.ExecuteNonQuery();
                if (cmdParameterResult.Value != null && (Int32)cmdParameterResult.Value > 0)
                    return true;
                else
                    return false;
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
                return false;
            }
        }

        //比赛进入Unofficial或Official时，将比赛总分，Rank，Q写入到TS_EQ_Match_Result
        public bool UpdateMatchResultQ(int iMatchID)
        {
            bool bResult = false;
            try
            {
                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", iMatchID);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", DbType.Int32);
                cmdParameterResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_EQ_UpdateMatchResultQ", cmdParameter1, cmdParameterResult);
                if (int.Parse(cmdParameterResult.Value.ToString()) > 0)
                {
                    bResult = true;
                }
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
            return bResult;


        }

        //比赛进入Official时且比赛产生奖牌，将比赛总分，Rank写入到TS_Event_Result
        public bool UpdateEventResult(int iMatchID)
        {
            bool bResult = false;
            try
            {
                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", iMatchID);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", DbType.Int32);
                cmdParameterResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_EQ_UpdateEventResult", cmdParameter1, cmdParameterResult);
                if (int.Parse(cmdParameterResult.Value.ToString()) > 0)
                {
                    bResult = true;
                }
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
            return bResult;

        }

        public Int32 GetRegisterIDFromBib(int iMatchID,string strBib)
        {
            String strSQL = @"SELECT A.F_RegisterID FROM TS_EQ_Match_Result AS A LEFT JOIN TR_Register AS B 
                            ON A.F_RegisterID = B.F_RegisterID AND A.F_MatchID = "+iMatchID.ToString()+" WHERE B.F_Bib ="+strBib;
            return (Int32)GVAR.g_adoDataBase.ExecuteScalar(strSQL);
        }

        public Int32 GetMatchIDFromMatchConfigCode(string strMatchConfigCode)
        {
            strMatchConfigCode = "'" + strMatchConfigCode + "'";
            String strSQL = @"SELECT dbo.Fun_EQ_GetMatchIDFromMatchConfigCode(" + strMatchConfigCode + ")";
            return (Int32)GVAR.g_adoDataBase.ExecuteScalar(strSQL);
        }

        public string GetMatchConfigCodeFromMatchID(int iMatchID)
        {
            String strSQL = @"SELECT dbo.Fun_EQ_GetMatchConfigCodeFromMatchID(" + iMatchID.ToString() + ")";
            return (string)GVAR.g_adoDataBase.ExecuteScalar(strSQL);
        }

        public string GetMatchRuleCodeFromMatchID(int iMatchID)
        {
            String strSQL = @"SELECT dbo.Fun_EQ_GetMatchRuleCodeFromMatchID(" + iMatchID.ToString() + ")";
            return (string)GVAR.g_adoDataBase.ExecuteScalar(strSQL);
        }
        #endregion

        #region MatchResultDetail
        //获取比赛细节数据并填充dgv
        public void InitDgvMatchResultDetailList(int iMatchID,  int iRegisterID, ref UIDataGridView dgv)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GVAR.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_EQ_GetMatchResultDetailList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);
                
                SqlParameter cmdParameter2 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iRegisterID);
                oneSqlCommand.Parameters.Add(cmdParameter2);


                if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
                {
                    GVAR.g_adoDataBase.DBConnect.Open();
                }


                SqlDataReader sdr = oneSqlCommand.ExecuteReader();

                OVRDataBaseUtils.FillDataGridView(dgv, sdr, null, null);
                sdr.Close();
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }

        }

        //更新TS_EQ_Match_ResultDetail表的细节分
        public void UpdateDetailScore(Int32 iMatchID, Int32 iRegisterID, Int32 iJudgePosition, string columnName, decimal fScore)
        {
            try
            {
                #region DML Command Setup for SetActiveMember

                String strFmt, strSQL;
                //如果收到扣分，更新所有点位的扣分
                if(columnName.Equals("F_0"))
                {
                    strFmt = @"UPDATE TS_EQ_Match_ResultDetail SET {0} = {1}
                                WHERE F_MatchID = {2} AND F_RegisterID = {3}";
                }
                else
                {
                     strFmt = @"UPDATE TS_EQ_Match_ResultDetail SET {0} = {1}
                                WHERE F_MatchID = {2} AND F_RegisterID = {3} AND F_JudgePosition = {4}";
                }
                strSQL = String.Format(strFmt, columnName, fScore, iMatchID, iRegisterID, iJudgePosition);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);

                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        public void UpdateDetailScore(Int32 iMatchID, Int32 iRegisterID, Int32 iJudgePosition, string columnName, string strScoreDes)
        {
            try
            {
                #region DML Command Setup for SetActiveMember

                String strFmt, strSQL;

                strFmt = @"UPDATE TS_EQ_Match_ResultDetail SET {0} = {1}
                                WHERE F_MatchID = {2} AND F_RegisterID = {3} AND F_JudgePosition = {4}";
                strSQL = String.Format(strFmt, columnName, strScoreDes, iMatchID, iRegisterID, iJudgePosition);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);

                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        public void UpdateDetailScoreNull(Int32 iMatchID, Int32 iRegisterID, Int32 iJudgePosition, string columnName)
        {
            try
            {
                #region DML Command Setup for SetActiveMember

                String strFmt, strSQL;

                //如果收到扣分为空，更新所有点位的扣分为空
                if (columnName.Equals("F_0"))
                {
                    strFmt = @"UPDATE TS_EQ_Match_ResultDetail SET {0} = null,{0}Des = null
                                WHERE F_MatchID = {1} AND F_RegisterID = {2}";
                }
                else
                {
                    strFmt = @"UPDATE TS_EQ_Match_ResultDetail SET {0} = null,{0}Des = null
                                WHERE F_MatchID = {1} AND F_RegisterID = {2} AND F_JudgePosition = {3}";
                }
                strSQL = String.Format(strFmt, columnName, iMatchID, iRegisterID, iJudgePosition);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);

                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        //障碍类可更新细节分的罚分描述代码
        public void UpdateDetailScoreDes(Int32 iMatchID, Int32 iRegisterID, Int32 iJudgePosition, string columnName, string strScoreDes)
        {
            try
            {
                #region DML Command Setup for SetActiveMember

                String strFmt, strSQL;

                strFmt = @"UPDATE TS_EQ_Match_ResultDetail SET {0}Des = {1}
                                WHERE F_MatchID = {2} AND F_RegisterID = {3} AND F_JudgePosition = {4}";
                strSQL = String.Format(strFmt, columnName, strScoreDes, iMatchID, iRegisterID, iJudgePosition);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);

                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

         //获取比赛的障碍简称列表
        public DataTable GetMatchFenceList(int iMatchConfigID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_EQ_GetMatchFenceList", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchConfigID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchConfigID", DataRowVersion.Current, iMatchConfigID));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
                da.Dispose();
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }

            return dt;
        }

        //当细节分更新时，盛装计算和更新裁判点的细节总分和百分比分（Points，Tec，Art），场地障碍总障碍罚分
        public void UpdateJudgePointsWhenDetailScoreChange(int iMatchID, int iRegisterID, int iJudgePositon)
        {
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GVAR.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_EQ_UpdateJudgePointsWhenDetailScoreChange";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@RegisterID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iRegisterID);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlParameter cmdParameter3 = new SqlParameter(
                            "@JudgePosition", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iJudgePositon);
                oneSqlCommand.Parameters.Add(cmdParameter3);


                if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
                {
                    GVAR.g_adoDataBase.DBConnect.Open();
                }
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
        }
        #endregion

        #region MatchMF
        public DataTable GetMatchMFs(int iMatchConfigID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_EQ_GetMatchMFs", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchConfigID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchConfigID", DataRowVersion.Current, iMatchConfigID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strLanguageCode));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
                da.Dispose();
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }

            return dt;
        }

        public void UpdateMatchMF(Int32 iMatchConfigID, Int32 iMFCode, string columnName, Int32 iInputValue)
        {
            String strFmt, strSQL;

            try
            {
                #region DML Command Setup for Update MatchResultDetail

                strFmt = @"UPDATE TS_EQ_Match_MF SET {0} = {1} WHERE F_MatchConfigID = {2} AND F_MFCode = {3}";
                strSQL = String.Format(strFmt, columnName, iInputValue, iMatchConfigID, iMFCode);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);
                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        public void UpdateMatchMF(Int32 iMatchConfigID, Int32 iMFCode, string columnName, String strInputValue)
        {
            String strFmt, strSQL;

            try
            {
                #region DML Command Setup for Update MatchResultDetail

                strFmt = @"UPDATE TS_EQ_Match_MF SET {0} = {1} WHERE F_MatchConfigID = {2} AND F_MFCode = {3}";
                strSQL = String.Format(strFmt, columnName, strInputValue, iMatchConfigID, iMFCode);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);
                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        //更新当前选择的舞步或障碍配置条目
        public void UpdateMatchMFLongName(int iMatchConfigID, int iMFCode, int iMFID)
        {
            String strSql;
            strSql = "UPDATE TS_EQ_Match_MF SET F_MFID = " + iMFID + " WHERE F_MatchConfigID = " + iMatchConfigID + " AND F_MFCode =" + iMFCode;
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GVAR.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = strSql;
                oneSqlCommand.CommandType = CommandType.Text;
                oneSqlCommand.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
        }
        //更新舞步类型，M或C
        public void UpdateMovementType(int iMatchConfigID, int iMFCode, String strMovementType)
        {
            try
            {
                #region DML Command Setup for SetActiveMember

                String strFmt, strSQL;

                strFmt = @"UPDATE TS_EQ_Match_MF SET F_MovementType = {0} WHERE F_MatchConfigID = {1} AND F_MFCode ={2}";
                strSQL = String.Format(strFmt, strMovementType, iMatchConfigID, iMFCode, iMFCode);

                GVAR.g_adoDataBase.ExecuteUpdateSQL(strSQL);

                #endregion
            }
            catch (System.Exception e)
            {
                GVAR.MsgBox(e.Message);
            }
        }

        public void InitMFLongNameCombBox(ref UIDataGridView GridCtrl, Int32 iColumnIndex, Int32 iMatchConfigID, String strLanguageCode)
        {
            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                SqlCommand oneSqlCommand = new SqlCommand();
                oneSqlCommand.Connection = GVAR.g_adoDataBase.DBConnect;
                oneSqlCommand.CommandText = "Proc_EQ_GetMFList";
                oneSqlCommand.CommandType = CommandType.StoredProcedure;

                SqlParameter cmdParameter1 = new SqlParameter(
                            "@MatchConfigID", SqlDbType.Int, 4,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, iMatchConfigID);
                oneSqlCommand.Parameters.Add(cmdParameter1);

                SqlParameter cmdParameter2 = new SqlParameter(
                            "@LanguageCode", SqlDbType.Char, 3,
                            ParameterDirection.Input, true, 0, 0, "",
                            DataRowVersion.Current, strLanguageCode);
                oneSqlCommand.Parameters.Add(cmdParameter2);

                SqlDataReader sdr = oneSqlCommand.ExecuteReader();
                //往combobox添加item
                (GridCtrl.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(sdr, 1, 0);
                sdr.Close();
            }
            catch (Exception ex)
            {
                DevComponents.DotNetBar.MessageBoxEx.Show(ex.Message);
            }
        }
        #endregion

        #region MatchPenTypeList

        public void InitDgvMatchPenTypeList(int iMatchRuleID, ref UIDataGridView dgv)
        {

            if (GVAR.g_adoDataBase.DBConnect.State == System.Data.ConnectionState.Closed)
            {
                GVAR.g_adoDataBase.DBConnect.Open();
            }
            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_EQ_GetMatchPenTypeList", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchRuleID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchRuleID", DataRowVersion.Current, iMatchRuleID));
                cmd.UpdatedRowSource = UpdateRowSource.None;

                SqlDataReader sdr = cmd.ExecuteReader();
                OVRDataBaseUtils.FillDataGridView(dgv, sdr);
                sdr.Close();
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }

        }
        #endregion

        #region IPADMark
        //调用存储过程返回当前运动员的打分列表，包含已经打过的分
        public DataTable GetIPadScoreList(int iMatchID, int iRegisterID, int iJudgeNum )
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_EQ_GetIPadScoreList", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, iMatchID));
                cmd.Parameters.Add(new SqlParameter("@RegisterID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RegisterID", DataRowVersion.Current, iRegisterID));
                cmd.Parameters.Add(new SqlParameter("@JudgeNum", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@JudgeNum", DataRowVersion.Current, iJudgeNum));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strLanguageCode));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
                da.Dispose();
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }

            return dt;
        }

        //获取比赛的舞步列表
        public DataTable GetMatchMovementList(int iMatchID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_EQ_GetMatchMovementList", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, iMatchID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strLanguageCode));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
                da.Dispose();
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }

            return dt;
        }

        public bool IsValidatedMovementScore(Int32 iMatchID,Int32 iRegisterID,Int32 iMovementID)
        {
            bool bResult = false;
            try
            {
                SqlParameter cmdParameter1 = new SqlParameter("@MatchID", iMatchID);
                SqlParameter cmdParameter2 = new SqlParameter("@RegisterID", iRegisterID);
                SqlParameter cmdParameter3 = new SqlParameter("@MovementID", iMovementID);
                SqlParameter cmdParameterResult = new SqlParameter("@Result", DbType.Int32);
                cmdParameterResult.Direction = ParameterDirection.Output;
                GVAR.g_adoDataBase.ExecuteProcNoQuery("Proc_EQ_IsValidatedMovementScore", cmdParameter1, cmdParameter2, cmdParameter3, cmdParameterResult);
                if (int.Parse(cmdParameterResult.Value.ToString()) > 0)
                {
                    bResult = true;
                }
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }
            return bResult;
        }

        public String GetMatchConfigJudge(Int32 iMatchConfigID)
        {
            String strSQL = "SELECT F_Judge FROM TS_EQ_Match_CONFIG WHERE F_MatchConfigID =" + iMatchConfigID.ToString();
            return (String)GVAR.g_adoDataBase.ExecuteScalar(strSQL);
        }
        #endregion

        #region Monitor
        //调用存储过程返回当前运动员的实时细节分
        public DataTable GetMonitorScoreList(int iMatchID, int iRegisterID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_EQ_GetMonitorScoreList", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, iMatchID));
                cmd.Parameters.Add(new SqlParameter("@RegisterID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@RegisterID", DataRowVersion.Current, iRegisterID));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
                da.Dispose();
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }

            return dt;
        }

        //调用存储过程返回当前运动员的实时细节分
        public DataTable GetMonitorJudgeList(int iMatchID)
        {
            System.Data.SqlClient.SqlDataAdapter da = new SqlDataAdapter();
            System.Data.DataTable dt = new DataTable();

            try
            {
                System.Data.SqlClient.SqlConnection con = GVAR.g_adoDataBase.DBConnect;
                if (con.State != ConnectionState.Open)
                    con.Open();

                SqlCommand cmd = new SqlCommand("Proc_EQ_GetMonitorJudgeList", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@MatchID", SqlDbType.Int, 4, ParameterDirection.Input, true, 0, 0, "@MatchID", DataRowVersion.Current, iMatchID));
                cmd.Parameters.Add(new SqlParameter("@LanguageCode", SqlDbType.Char, 3, ParameterDirection.Input, true, 0, 0, "@LanguageCode", DataRowVersion.Current, m_strLanguageCode));
                cmd.UpdatedRowSource = UpdateRowSource.None;
                da.SelectCommand = cmd;

                dt.Clear();
                da.Fill(dt);
                da.Dispose();
            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }

            return dt;
        }

        //调用存储过程返回当前运动员的打分列表，包含已经打过的分
        public ServiceReference1.BaseInfo GetMonitorBaseInfo(int iMatchID, int iRegisterID, int iMFCode)
        {
            ServiceReference1.BaseInfo baseInfo = new ServiceReference1.BaseInfo();
            STableRecordSet tb = new STableRecordSet();
            try
            {
                SqlParameter paramMatchID = new SqlParameter("@MatchID", iMatchID);
                SqlParameter param1 = new SqlParameter("@RegisterID", iRegisterID);
                SqlParameter param2 = new SqlParameter("@MFCode", iMFCode);
                SqlParameter param3 = new SqlParameter("@LanguageCode", m_strLanguageCode);
                GVAR.g_adoDataBase.ExecuteProc("Proc_EQ_GetMonitorBaseInfo", tb, paramMatchID, param1,param2,param3);

                baseInfo.EventName = tb.GetFieldValue(0, "EventName");
                baseInfo.MatchName = tb.GetFieldValue(0, "MatchName");
                baseInfo.RiderName = tb.GetFieldValue(0, "RiderName");
                baseInfo.Noc = tb.GetFieldValue(0, "Noc");
                baseInfo.HorseName = tb.GetFieldValue(0, "HorseName");
                baseInfo.MFName = tb.GetFieldValue(0, "MFName");

            }
            catch (Exception ex)
            {
                GVAR.MsgBox(ex.Message);
            }

            return baseInfo;
        }
        #endregion

    }
}
