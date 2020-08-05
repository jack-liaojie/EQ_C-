using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using AutoSports.OVRCommon;
using System.Xml;
using System.Data.SqlClient;

namespace AutoSports.OVRVBPlugin
{
	public partial class frmScoreDetail : DevComponents.DotNetBar.Office2007Form
	{
		private string _teamNameA;
		private string _teamNameB;

		public frmScoreDetail(string teamNameA, string teamNameB)
		{
			_teamNameA = teamNameA;
			_teamNameB = teamNameB;

			InitializeComponent();
		}

		private void frmScoreDetail_Load(object sender, EventArgs e)
		{
			OVRDataBaseUtils.SetDataGridViewStyle(_dgvWinLose);

			dgvWinLoseInit();
			dgvWinLoseRefresh();

			_btnOK.Enabled = false;
		}

		private bool dgvWinLoseInit()
		{
			_dgvWinLose.RowHeadersVisible = false;
			_dgvWinLose.SelectionMode = DataGridViewSelectionMode.CellSelect;

			Font gridFont = new Font(new FontFamily("Arial"), 15, new FontStyle());
			Font gridTimeFont = new Font(new FontFamily("Arial"), 10, new FontStyle());
			Font gridFontSmall = new Font(new FontFamily("Arial"), 9, FontStyle.Bold);

			_dgvWinLose.Font = gridFont;
			_dgvWinLose.ColumnHeadersDefaultCellStyle.Font = new Font(new FontFamily("Arial"), 10, new FontStyle());
			_dgvWinLose.MultiSelect = false;
			_dgvWinLose.AllowUserToResizeColumns = false;
			_dgvWinLose.AllowUserToResizeRows = false;
			_dgvWinLose.AllowUserToOrderColumns = false;
			_dgvWinLose.AllowDrop = false;
			_dgvWinLose.AllowUserToAddRows = false;
			_dgvWinLose.AllowUserToDeleteRows = false;
			_dgvWinLose.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.None;

			_dgvWinLose.Rows.Clear();
			_dgvWinLose.Columns.Clear();

			_dgvWinLose.Columns.Add("NOC", "NOC");
			_dgvWinLose.Columns.Add("PtsWin", "PtsWin");
			_dgvWinLose.Columns.Add("PtsLose", "PtsLose");
			_dgvWinLose.Columns.Add("SetsWin", "SetsWin");
			_dgvWinLose.Columns.Add("SetsLose", "SetsLose");
			_dgvWinLose.Columns.Add("GroupPts", "GroupPts");

			_dgvWinLose.Columns[0].Width = 210;
			_dgvWinLose.Columns[1].Width = 70;	// Score Set1
			_dgvWinLose.Columns[2].Width = _dgvWinLose.Columns[1].Width;
			_dgvWinLose.Columns[3].Width = _dgvWinLose.Columns[1].Width;
			_dgvWinLose.Columns[4].Width = _dgvWinLose.Columns[1].Width;
			_dgvWinLose.Columns[5].Width = 90;

			_dgvWinLose.Columns[0].SortMode = DataGridViewColumnSortMode.NotSortable;
			_dgvWinLose.Columns[1].SortMode = DataGridViewColumnSortMode.NotSortable;
			_dgvWinLose.Columns[2].SortMode = DataGridViewColumnSortMode.NotSortable;
			_dgvWinLose.Columns[3].SortMode = DataGridViewColumnSortMode.NotSortable;
			_dgvWinLose.Columns[4].SortMode = DataGridViewColumnSortMode.NotSortable;
			_dgvWinLose.Columns[5].SortMode = DataGridViewColumnSortMode.NotSortable;

			_dgvWinLose.Rows.Add();
			_dgvWinLose.Rows.Add();
			_dgvWinLose.Rows[0].Height = 25;
			_dgvWinLose.Rows[1].Height = 25;

			_dgvWinLose.Columns[0].ReadOnly = true;		//NOC
			_dgvWinLose.Columns[1].ReadOnly = false;	//Score Set1
			_dgvWinLose.Columns[2].ReadOnly = false;
			_dgvWinLose.Columns[3].ReadOnly = false;
			_dgvWinLose.Columns[4].ReadOnly = false;
			_dgvWinLose.Columns[5].ReadOnly = false;

			_dgvWinLose[0, 0].Value = _teamNameA;
			_dgvWinLose[0, 1].Value = _teamNameB;

			return true;
		}

		private bool dgvWinLoseRefresh()
		{
			_dgvWinLose[1, 0].Value = "";
			_dgvWinLose[1, 1].Value = "";
			_dgvWinLose[2, 0].Value = "";
			_dgvWinLose[2, 1].Value = "";
			_dgvWinLose[3, 0].Value = "";
			_dgvWinLose[3, 1].Value = "";
			_dgvWinLose[4, 0].Value = "";
			_dgvWinLose[4, 1].Value = "";
			_dgvWinLose[5, 0].Value = "";
			_dgvWinLose[5, 1].Value = "";

			DataTable tbl = Common.dbMatchScoreWinLose();
			if (tbl == null || tbl.Rows.Count < 2 )
			{
				return false;
			}

			_dgvWinLose[1, 0].Value = tbl.Rows[0]["F_PtsWin"].ToString();
			_dgvWinLose[1, 1].Value = tbl.Rows[1]["F_PtsWin"].ToString();
			_dgvWinLose[2, 0].Value = tbl.Rows[0]["F_PtsLose"].ToString();
			_dgvWinLose[2, 1].Value = tbl.Rows[1]["F_PtsLose"].ToString();
			_dgvWinLose[3, 0].Value = tbl.Rows[0]["F_SetsWin"].ToString();
			_dgvWinLose[3, 1].Value = tbl.Rows[1]["F_SetsWin"].ToString();
			_dgvWinLose[4, 0].Value = tbl.Rows[0]["F_SetsLose"].ToString();
			_dgvWinLose[4, 1].Value = tbl.Rows[1]["F_SetsLose"].ToString();
			_dgvWinLose[5, 0].Value = tbl.Rows[0]["F_GroupPoints"].ToString();
			_dgvWinLose[5, 1].Value = tbl.Rows[1]["F_GroupPoints"].ToString();

			return true;
		}

		private void _dgvWinLose_CellEndEdit(object sender, DataGridViewCellEventArgs e)
		{
			_btnOK.Enabled = true;
		}

		private bool UpdateScoreToDB()
		{
			string strPtsWinA =   _dgvWinLose[1, 0].Value == null ? "" : _dgvWinLose[1, 0].Value.ToString();
			string strPtsWinB =   _dgvWinLose[1, 1].Value == null ? "" : _dgvWinLose[1, 1].Value.ToString();
			string strPtsLoseA =  _dgvWinLose[2, 0].Value == null ? "" : _dgvWinLose[2, 0].Value.ToString();
			string strPtsLoseB =  _dgvWinLose[2, 1].Value == null ? "" : _dgvWinLose[2, 1].Value.ToString();
			string strSetsWinA =  _dgvWinLose[3, 0].Value == null ? "" : _dgvWinLose[3, 0].Value.ToString();
			string strSetsWinB =  _dgvWinLose[3, 1].Value == null ? "" : _dgvWinLose[3, 1].Value.ToString();
			string strSetsLoseA = _dgvWinLose[4, 0].Value == null ? "" : _dgvWinLose[4, 0].Value.ToString();
			string strSetsLoseB = _dgvWinLose[4, 1].Value == null ? "" : _dgvWinLose[4, 1].Value.ToString();
			string strGrpPtsA =   _dgvWinLose[5, 0].Value == null ? "" : _dgvWinLose[5, 0].Value.ToString();
			string strGrpPtsB =   _dgvWinLose[5, 1].Value == null ? "" : _dgvWinLose[5, 1].Value.ToString();

			SqlCommand dbCmd = new SqlCommand("proc_VB_PRG_MatchSetScoreWinLose");
			dbCmd.CommandType = CommandType.StoredProcedure;
			dbCmd.Parameters.AddWithValue("@MatchID", Common.g_nMatchID);
			dbCmd.Parameters.AddWithValue("@PtsWinA",      strPtsWinA == "" ? (object)DBNull.Value : Common.Str2Int(strPtsWinA));
			dbCmd.Parameters.AddWithValue("@PtsWinB",      strPtsWinB == "" ? (object)DBNull.Value : Common.Str2Int(strPtsWinB));
			dbCmd.Parameters.AddWithValue("@PtsLoseA",    strPtsLoseA == "" ? (object)DBNull.Value : Common.Str2Int(strPtsLoseA));
			dbCmd.Parameters.AddWithValue("@PtsLoseB",    strPtsLoseB == "" ? (object)DBNull.Value : Common.Str2Int(strPtsLoseB));
			dbCmd.Parameters.AddWithValue("@SetsWinA",    strSetsWinA == "" ? (object)DBNull.Value : Common.Str2Int(strSetsWinA));
			dbCmd.Parameters.AddWithValue("@SetsWinB",    strSetsWinB == "" ? (object)DBNull.Value : Common.Str2Int(strSetsWinB));
			dbCmd.Parameters.AddWithValue("@SetsLoseA",  strSetsLoseA == "" ? (object)DBNull.Value : Common.Str2Int(strSetsLoseA));
			dbCmd.Parameters.AddWithValue("@SetsLoseB",  strSetsLoseB == "" ? (object)DBNull.Value : Common.Str2Int(strSetsLoseB));
			dbCmd.Parameters.AddWithValue("@GroupPointsA", strGrpPtsA == "" ? (object)DBNull.Value : Common.Str2Int(strGrpPtsA));
			dbCmd.Parameters.AddWithValue("@GroupPointsB", strGrpPtsB == "" ? (object)DBNull.Value : Common.Str2Int(strGrpPtsB));

			dbCmd.Parameters.AddWithValue("@Result", DBNull.Value);
			dbCmd.Parameters["@Result"].Size = 4;
			dbCmd.Parameters["@Result"].SqlDbType = SqlDbType.Int;
			dbCmd.Parameters["@Result"].Direction = ParameterDirection.Output;

			return Common.dbExecuteNonQuery(ref dbCmd);
		}

		private void _btnOK_Click(object sender, EventArgs e)
		{
			bool bOk = UpdateScoreToDB();
			if (!bOk)
			{
				MessageBox.Show("Modify database failed!");
				return;
			}

			this.Close();
		}

		private void _btnCancel_Click(object sender, EventArgs e)
		{
			this.Close();
		}
	}
}
