using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Diagnostics;
using System.Data.SqlClient;
using System.Windows.Forms;
using AutoSports.OVRCommon;

namespace AutoSports.OVRVBPlugin
{
	public partial class frmTeamMemberEntry
	{
		//From LiYan
		public void ResetMemberGrid(int iMatchID, int iTeamID, int iTeamPos, ref DataGridView dgv, ref int iStartupNumber)
		{
			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}

			try
			{
				#region DML Command Setup for Get MatchMember
				SqlCommand cmd = new SqlCommand("Proc_VB_EXT_MatchMemberGetList", Common.g_DataBaseCon);
				cmd.CommandType = CommandType.StoredProcedure;

				SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
				SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
				SqlParameter cmdParameter3 = new SqlParameter("@TeamPos", SqlDbType.Int);

				cmdParameter1.Value = iMatchID;
				cmdParameter2.Value = Common.g_strLanguage;
				cmdParameter3.Value = iTeamPos;

				cmd.Parameters.Add(cmdParameter1);
				cmd.Parameters.Add(cmdParameter2);
				cmd.Parameters.Add(cmdParameter3);
				#endregion

				SqlDataReader dr = cmd.ExecuteReader();

				int iSelRowIndex = -1;
				if (dgv.Rows.Count > 0 && dgv.SelectedRows != null)
				{
					//	iSelRowIndex = dgv.SelectedRows[0].Index;
				}

				List<int> lstCmbColumns = new List<int>();
				lstCmbColumns.Add(3);
				lstCmbColumns.Add(5);
				lstCmbColumns.Add(6);

				List<OVRCheckBoxColumn> lstChkColumns = new List<OVRCheckBoxColumn>();
				lstChkColumns.Add(new OVRCheckBoxColumn(0, 1, 0));
				OVRDataBaseUtils.FillDataGridView(dgv, dr, lstCmbColumns, lstChkColumns);

				dr.Close();

				if (dgv.RowCount > 0)
				{
					dgv.Columns["F_MemberID"].Visible = false;
					dgv.Columns["F_StartupNum"].Visible = false;
					dgv.Columns["Order"].ReadOnly = false;
					dgv.Columns["ShirtNumber"].ReadOnly = false;
					dgv.Columns["DSQ"].ReadOnly = false;

					dgv.Columns["Startup"].Visible = false;
					dgv.Columns["MaxServeSpeed"].ReadOnly = false;

					iStartupNumber = Common.Str2Int(dgv.Rows[0].Cells["F_StartupNum"].Value);

					dgv.ClearSelection();
					if (iSelRowIndex > 0 && iSelRowIndex < dgv.Rows.Count)
					{
						dgv.Rows[iSelRowIndex].Selected = true;
					}
				}
			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}
		}

		public void AddMatchMember(int iMatchID, int iMemberID, int iTeamPos, int iFunctionID, int iShirtNumber)
		{
			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}

			try
			{
				#region DML Command Setup for Add MatchMember

				SqlCommand cmd = new SqlCommand("Proc_VB_EXT_MatchMemberAdd", Common.g_DataBaseCon);
				cmd.CommandType = CommandType.StoredProcedure;
				SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
				SqlParameter cmdParameter1 = new SqlParameter("@MemberID", SqlDbType.Int);
				SqlParameter cmdParameter2 = new SqlParameter("@TeamPos", SqlDbType.Int);
				SqlParameter cmdParameter3 = new SqlParameter("@FunctionID", SqlDbType.Int);
				SqlParameter cmdParameter4 = new SqlParameter("@ShirtNumber", SqlDbType.Int);
				SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

				cmdParameter0.Value = iMatchID;
				cmdParameter1.Value = iMemberID;
				cmdParameter2.Value = iTeamPos;
				cmdParameter3.Value = iFunctionID;
				cmdParameter4.Value = iShirtNumber;
				cmdParameterResult.Direction = ParameterDirection.Output;

				cmd.Parameters.Add(cmdParameter0);
				cmd.Parameters.Add(cmdParameter1);
				cmd.Parameters.Add(cmdParameter2);
				cmd.Parameters.Add(cmdParameter3);
				cmd.Parameters.Add(cmdParameter4);
				cmd.Parameters.Add(cmdParameterResult);
				cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

				cmd.ExecuteNonQuery();
				int nRetValue = (int)cmdParameterResult.Value;
				#endregion
			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}
		}
		public void RemoveMatchMember(int iMatchID, int iMemberID, int iTeamPos)
		{
			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}

			try
			{
				#region DML Command Setup for Remove MatchMember

				SqlCommand cmd = new SqlCommand("Proc_VB_EXT_MatchMemberRemove", Common.g_DataBaseCon);
				cmd.CommandType = CommandType.StoredProcedure;
				SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
				SqlParameter cmdParameter1 = new SqlParameter("@MemberID", SqlDbType.Int);
				SqlParameter cmdParameter2 = new SqlParameter("@TeamPos", SqlDbType.Int);
				SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

				cmdParameter0.Value = iMatchID;
				cmdParameter1.Value = iMemberID;
				cmdParameter2.Value = iTeamPos;
				cmdParameterResult.Direction = ParameterDirection.Output;

				cmd.Parameters.Add(cmdParameter0);
				cmd.Parameters.Add(cmdParameter1);
				cmd.Parameters.Add(cmdParameter2);
				cmd.Parameters.Add(cmdParameterResult);
				cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

				cmd.ExecuteNonQuery();
				int nRetValue = (int)cmdParameterResult.Value;
				#endregion
			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}
		}

		public void UpdateMatchMemberFunction(int iMatchID, int iMemberID, int iTeamPos, int iFunctionID)
		{
			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}

			try
			{
				#region DML Command Setup for Update MatchMember Function

				SqlCommand cmd = new SqlCommand("Proc_VB_EXT_MatchMemberFunctionUpdate", Common.g_DataBaseCon);
				cmd.CommandType = CommandType.StoredProcedure;
				SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
				SqlParameter cmdParameter1 = new SqlParameter("@MemberID", SqlDbType.Int);
				SqlParameter cmdParameter2 = new SqlParameter("@FunctionID", SqlDbType.Int);
				SqlParameter cmdParameter3 = new SqlParameter("@TeamPos", SqlDbType.Int);
				SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

				cmdParameter0.Value = iMatchID;
				cmdParameter1.Value = iMemberID;
				cmdParameter2.Value = iFunctionID;
				cmdParameter3.Value = iTeamPos;
				cmdParameterResult.Direction = ParameterDirection.Output;

				cmd.Parameters.Add(cmdParameter0);
				cmd.Parameters.Add(cmdParameter1);
				cmd.Parameters.Add(cmdParameter2);
				cmd.Parameters.Add(cmdParameter3);
				cmd.Parameters.Add(cmdParameterResult);
				cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

				cmd.ExecuteNonQuery();
				int nRetValue = (int)cmdParameterResult.Value;
				#endregion

			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}
		}

		public void UpdateMatchMembePosition(int iMatchID, int iMemberID, int iTeamPos, int iPositionID)
		{
			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}

			try
			{
				#region DML Command Setup for Update MatchMember Function

				SqlCommand cmd = new SqlCommand("Proc_VB_EXT_MatchMemberPositionUpdate", Common.g_DataBaseCon);
				cmd.CommandType = CommandType.StoredProcedure;
				SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
				SqlParameter cmdParameter1 = new SqlParameter("@MemberID", SqlDbType.Int);
				SqlParameter cmdParameter2 = new SqlParameter("@PositionID", SqlDbType.Int);
				SqlParameter cmdParameter3 = new SqlParameter("@TeamPos", SqlDbType.Int);
				SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

				cmdParameter0.Value = iMatchID;
				cmdParameter1.Value = iMemberID;
				cmdParameter2.Value = iPositionID;
				cmdParameter3.Value = iTeamPos;
				cmdParameterResult.Direction = ParameterDirection.Output;

				cmd.Parameters.Add(cmdParameter0);
				cmd.Parameters.Add(cmdParameter1);
				cmd.Parameters.Add(cmdParameter2);
				cmd.Parameters.Add(cmdParameter3);
				cmd.Parameters.Add(cmdParameterResult);
				cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

				cmd.ExecuteNonQuery();
				int nRetValue = (int)cmdParameterResult.Value;
				#endregion

			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}
		}

		public void UpdateMatchMemberSrvSpeed(int iMatchID, int iMemberID, int iTeamPos, int? nMaxSpeed)
		{
			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}
			
			try
			{
				#region DML Command Setup for Update MatchMember Function

				SqlCommand cmd = new SqlCommand("Proc_VB_EXT_MatchMemberMaxSrvSpeedUpdate", Common.g_DataBaseCon);
				cmd.CommandType = CommandType.StoredProcedure;
				SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
				SqlParameter cmdParameter1 = new SqlParameter("@MemberID", SqlDbType.Int);
				SqlParameter cmdParameter2 = new SqlParameter("@SrvSpeed", SqlDbType.Int);
				SqlParameter cmdParameter3 = new SqlParameter("@TeamPos", SqlDbType.Int);
				SqlParameter cmdParameterResult = new SqlParameter("@Result", SqlDbType.Int);

				cmdParameter0.Value = iMatchID;
				cmdParameter1.Value = iMemberID;
				cmdParameter2.Value = nMaxSpeed == null ? (object)DBNull.Value : (object)nMaxSpeed;
				cmdParameter3.Value = iTeamPos;
				cmdParameterResult.Direction = ParameterDirection.Output;

				cmd.Parameters.Add(cmdParameter0);
				cmd.Parameters.Add(cmdParameter1);
				cmd.Parameters.Add(cmdParameter2);
				cmd.Parameters.Add(cmdParameter3);
				cmd.Parameters.Add(cmdParameterResult);
				cmd.UpdatedRowSource = UpdateRowSource.OutputParameters;

				cmd.ExecuteNonQuery();
				int nRetValue = (int)cmdParameterResult.Value;
				#endregion

			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}
		}
		
		public void UpdateMatchMemberShirtNumber(int iMatchID, int iMemberID, int iTeamPos, string strShirtNumber)
		{
			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}

			try
			{
				#region DML Command Setup for Update MatchMember ShirtNumber
				string strSQL;
				if (strShirtNumber.Length == 0)
				{
					strSQL = String.Format("UPDATE TS_Match_Member SET F_ShirtNumber = NULL WHERE F_RegisterID = {0} AND F_CompetitionPosition = {1}  AND F_MatchID = {2}", iMemberID, iTeamPos, iMatchID);
				}
				else
				{
					strSQL = String.Format("UPDATE TS_Match_Member SET F_ShirtNumber = '{0}' WHERE F_RegisterID = {1} AND F_CompetitionPosition = {2}  AND F_MatchID = {3}", strShirtNumber, iMemberID, iTeamPos, iMatchID);
				}
				SqlCommand cmd = new SqlCommand(strSQL, Common.g_DataBaseCon);
				cmd.ExecuteNonQuery();
				#endregion
			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}
		}

		public void UpdateMemberDSQ(int iRegisterID, int iMemberID, int iIRMID)
		{
			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}

			try
			{
				#region DML Command Setup for Update MatchMember IRM
				string strSQL;
				if (iIRMID == -1)
				{
					strSQL = String.Format("UPDATE TR_Register_Member SET F_Comment = NULL WHERE F_RegisterID = {0} AND F_MemberRegisterID = {1}", iRegisterID, iMemberID);
				}
				else
				{
					strSQL = String.Format("UPDATE TR_Register_Member SET F_Comment = '{0}' WHERE F_RegisterID = {1} AND F_MemberRegisterID = {2}", iIRMID, iRegisterID, iMemberID);
				}
				SqlCommand cmd = new SqlCommand(strSQL, Common.g_DataBaseCon);
				cmd.ExecuteNonQuery();
				#endregion
			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}
		}

		public void GetMatchUniform(int iMatchID, int iTeamPos, ref int iUniformID)
		{
			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}

			try
			{
				#region DML Command Setup for Get TeamUniform
				string strSQL;
				strSQL = string.Format("SELECT F_UniformID FROM TS_Match_Result WHERE F_MatchID = {0} AND F_CompetitionPosition = {1}", iMatchID, iTeamPos);
				SqlCommand cmd = new SqlCommand(strSQL, Common.g_DataBaseCon);

				SqlDataReader dr = cmd.ExecuteReader();
				if (dr.HasRows)
				{
					while (dr.Read())
					{
						iUniformID = OVRDataBaseUtils.GetFieldValue2Int32(ref dr, 0);
					}
				}
				dr.Close();
				#endregion
			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}
		}

		public void GetTeamUniform(int iTeamID, ref DataTable dtUniform)
		{
			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}

			try
			{
				#region DML Command Setup for Get TeamUniform

				SqlCommand cmd = new SqlCommand("Proc_VB_EXT_GetUniform", Common.g_DataBaseCon);
				cmd.CommandType = CommandType.StoredProcedure;

				SqlParameter cmdParameter1 = new SqlParameter("@TeamID", SqlDbType.Int);
				SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

				cmdParameter1.Value = iTeamID;
				cmdParameter2.Value = Common.g_strLanguage;

				cmd.Parameters.Add(cmdParameter1);
				cmd.Parameters.Add(cmdParameter2);
				#endregion

				SqlDataReader dr = cmd.ExecuteReader();
				dtUniform.Load(dr);
				dr.Close();
			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}
		}

		public void UpdatePlayerOrder(string strMatchID, int iPlayerID, int iBatOrder)
		{
			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}

			try
			{
				#region DML Command Setup for Update BatOrder
				string strSQL;

				if (iBatOrder == 0)
				{
					strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Order = NULL WHERE F_MatchID = {0} AND F_RegisterID = {1}", strMatchID, iPlayerID);

				}
				else
				{
					strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Order = {0} WHERE F_MatchID = {1} AND F_RegisterID = {2}", iBatOrder, strMatchID, iPlayerID);

				}
				SqlCommand cmd = new SqlCommand(strSQL, Common.g_DataBaseCon);
				cmd.ExecuteNonQuery();

				#endregion

			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}

		}

		public void UpdateMemberStartup(int iMatchID, int iTeamPos, string strPlayerID, bool bStartup)
		{
			int iActive = bStartup ? 1 : 0;

			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}

			try
			{
				#region DML Command Setup for Update BatOrder
				string strSQL;
				strSQL = string.Format(@"UPDATE TS_Match_Member SET F_Startup = {0} WHERE F_MatchID = {1} AND F_RegisterID = {2}", iActive, iMatchID, Common.Str2Int(strPlayerID));
				SqlCommand cmd = new SqlCommand(strSQL, Common.g_DataBaseCon);
				cmd.ExecuteNonQuery();

				#endregion

			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}
		}

		public void ResetAvailableGrid(int iMatchID, int iTeamID, int iTeamPos, ref DataGridView dgv)
		{
			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}

			try
			{
				#region DML Command Setup for Get AvailbleTeamMember
				SqlCommand cmd = new SqlCommand("Proc_VB_EXT_GetTeamAvailable", Common.g_DataBaseCon);
				cmd.CommandType = CommandType.StoredProcedure;

				SqlParameter cmdParameter0 = new SqlParameter("@RegisterID", SqlDbType.Int);
				SqlParameter cmdParameter1 = new SqlParameter("@MatchID", SqlDbType.Int);
				SqlParameter cmdParameter2 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
				SqlParameter cmdParameter3 = new SqlParameter("@TeamPos", SqlDbType.Int);

				cmdParameter0.Value = iTeamID;
				cmdParameter1.Value = iMatchID;
				cmdParameter2.Value = Common.g_strLanguage;
				cmdParameter3.Value = iTeamPos;

				cmd.Parameters.Add(cmdParameter0);
				cmd.Parameters.Add(cmdParameter1);
				cmd.Parameters.Add(cmdParameter2);
				cmd.Parameters.Add(cmdParameter3);
				#endregion

				SqlDataReader dr = cmd.ExecuteReader();
				OVRDataBaseUtils.FillDataGridView(dgv, dr, null, null);

				if (dgv.RowCount >= 0)
				{
					dgv.Columns["F_MemberID"].Visible = false;
					dgv.Columns["F_FunctionID"].Visible = false;
					

					for (int i = 0; i < dgv.RowCount; i++)
					{
						int iDSQ = Common.Str2Int(dgv.Rows[i].Cells["DSQ"].Value);
						if (iDSQ == 1)
						{
							dgv.Rows[i].ReadOnly = true;
							dgv.Rows[i].DefaultCellStyle.BackColor = System.Drawing.Color.DarkGray;
						}
					}
				}
				dr.Close();
			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}
		}


		public void InitPositionCombBox(ref DataGridView dgv, int iColumnIndex)
		{
			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}

			try
			{
				#region DML Command Setup for Fill Function combo

				SqlCommand cmd = new SqlCommand("proc_VB_RPG_PositionList", Common.g_DataBaseCon);
				cmd.CommandType = CommandType.StoredProcedure;
				SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
				SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

				cmdParameter0.Value = Common.g_nDiscID;
				cmdParameter1.Value = Common.g_strLanguage;

				cmd.Parameters.Add(cmdParameter0);
				cmd.Parameters.Add(cmdParameter1);
				SqlDataReader dr = cmd.ExecuteReader();
				#endregion

				DataTable table = new DataTable();
				table.Columns.Add("F_PositionLongName", typeof(string));
				table.Columns.Add("F_PositionID", typeof(int));
				table.Rows.Add("", "-1");
				table.Load(dr);

				(dgv.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(table, "F_PositionLongName", "F_PositionID");
				dr.Close();
			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}
		}

		public void InitIRMCombBox(ref DataGridView dgv, int iColumnIndex, int nMatchID)
		{
			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}

			try
			{
				#region DML Command Setup for Get IRM
				SqlCommand cmd = new SqlCommand("Proc_VB_RPG_IrmList", Common.g_DataBaseCon);
				cmd.CommandType = CommandType.StoredProcedure;

				SqlParameter cmdParameter0 = new SqlParameter("@MatchID", SqlDbType.Int);
				SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);

				cmdParameter0.Value = nMatchID;
				cmdParameter1.Value = Common.g_strLanguage;

				cmd.Parameters.Add(cmdParameter0);
				cmd.Parameters.Add(cmdParameter1);
				#endregion

				SqlDataReader dr = cmd.ExecuteReader();
				(dgv.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(dr, 0, 1);
				dr.Close();
			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}
		}


		public void InitFunctionCombBox(ref DataGridView dgv, int iColumnIndex, string strFunType)
		{
			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}

			try
			{
				#region DML Command Setup for Fill Function combo

				SqlCommand cmd = new SqlCommand("Proc_VB_RPG_FunctionList", Common.g_DataBaseCon);
				cmd.CommandType = CommandType.StoredProcedure;
				SqlParameter cmdParameter0 = new SqlParameter("@DisciplineID", SqlDbType.Int);
				SqlParameter cmdParameter1 = new SqlParameter("@LanguageCode", SqlDbType.NVarChar, 3);
				SqlParameter cmdParameter2 = new SqlParameter("@CategoryCode", SqlDbType.NVarChar, 20);

				cmdParameter0.Value = Common.g_nDiscID;
				cmdParameter1.Value = Common.g_strLanguage;
				cmdParameter2.Value = strFunType;

				cmd.Parameters.Add(cmdParameter0);
				cmd.Parameters.Add(cmdParameter1);
				cmd.Parameters.Add(cmdParameter2);
				SqlDataReader dr = cmd.ExecuteReader();
				#endregion

				DataTable table = new DataTable();
				table.Columns.Add("F_FunctionLongName", typeof(string));
				table.Columns.Add("F_FunctionID", typeof(int));
				table.Rows.Add("", "-1");
				table.Load(dr);

				(dgv.Columns[iColumnIndex] as DGVCustomComboBoxColumn).FillComboBoxItems(table, "F_FunctionLongName", "F_FunctionID");
				dr.Close();
			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}
		}


		public void UpdateMatchUniform(int iMatchID, int iTeamPos, int iUniformID)
		{
			if (Common.g_DataBaseCon.State == System.Data.ConnectionState.Closed)
			{
				Common.g_DataBaseCon.Open();
			}

			try
			{
				#region DML Command Setup for Update TeamMatchUniform
				string strSQL;
				strSQL = string.Format("UPDATE TS_Match_Result SET F_UniformID = {0} WHERE F_MatchID = {1} AND F_CompetitionPosition = {2}", iUniformID, iMatchID, iTeamPos);
				SqlCommand cmd = new SqlCommand(strSQL, Common.g_DataBaseCon);

				cmd.ExecuteNonQuery();
				#endregion
			}
			catch (System.Exception e)
			{
				DevComponents.DotNetBar.MessageBoxEx.Show(e.Message);
			}
		}

	}
}
