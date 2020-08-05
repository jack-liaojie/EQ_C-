using System;
using System.Data;
using System.Windows.Forms;
using AutoSports.OVRCommon;
using DevComponents.DotNetBar;

namespace AutoSports.OVRWRPlugin
{
    public partial class frmOVRWRMatchJudgeConfig : Office2007Form
    {
        private bool m_bModifyFlag = false;
        public frmOVRWRMatchJudgeConfig()
        {
            InitializeComponent();
            //initial the text for more languages.
            Localization();
        }

        #region Initialize
        private int m_MatchID;
        public int MatchID
        {
            get { return m_MatchID; }
            set { m_MatchID = value; }
        }
        private int m_RegisterID;
        private int m_FunctionID;
        private int m_ServantNum;
        private int m_Order;
        private int m_ModifyState;//0,ADD;1,Delete;2,Update Judge and Function;3,Update Order;
        private string gvcMatchJudgeOrder;
        private string gvcMatchJudgeName;
        private string gvcMatchJudgeFunction;

        //initial the text for more languages.
        private string m_strSectionName = "OVRROPlugin";
        private void Localization()
        {
            this.Text = LocalizationRecourceManager.GetString(m_strSectionName, "frmOVRSPMatchJudgeConfig");
            this.lbJudgeName.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbJudgeName");
            this.lbJudgeFunction.Text = LocalizationRecourceManager.GetString(m_strSectionName, "lbJudgeFunction");

            this.gvcMatchJudgeOrder = LocalizationRecourceManager.GetString(m_strSectionName, "gvcMatchJudgeOrder");
            this.gvcMatchJudgeName = LocalizationRecourceManager.GetString(m_strSectionName, "gvcMatchJudgeName");
            this.gvcMatchJudgeFunction = LocalizationRecourceManager.GetString(m_strSectionName, "gvcMatchJudgeFunction");
        }

        protected override void OnShown(EventArgs e)
        {
            base.OnShown(e);
            InitForm();
        }
        //==========================><==============================
        private void InitForm()
        {
            SetMatchJudgeTitle();
            InitlistBoxJudgeName();
            InitlistBoxJudgeFunction();
            InitAllControls();
        }

        private DataTable tbJudgeName;//tabel JudgeName
        //Initialize the listBoxJudgeName(listBox)
        private void InitlistBoxJudgeName()
        {
            try
            {
                listBoxJudgeName.Items.Clear();
                tbJudgeName = GVAR.g_ManageDB.GetJudgeName(m_MatchID);
                if (tbJudgeName == null || tbJudgeName.Rows.Count == 0)
                {
                    listBoxJudgeName.Enabled = false;
                    textJudgeName.Enabled = false;
                    return;
                }

                foreach (DataRow row in tbJudgeName.Rows)
                {
                    listBoxJudgeName.Items.Add(row["NameWithNOC"].ToString());
                }

                //listBoxJudgeName.DataSource = tbJudgeName;
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
                return;
            }
        }

        private DataTable tbJudgeFunction;//tabel JudgeFunction
        //Initialize the listBoxJudgeFunction(listBox)
        private void InitlistBoxJudgeFunction()
        {
            try
            {
                listBoxJudgeFunction.Items.Clear();
                tbJudgeFunction = GVAR.g_ManageDB.GetJudgeFunction(m_MatchID);
                if (tbJudgeFunction == null || tbJudgeFunction.Rows.Count == 0)
                {
                    listBoxJudgeFunction.Enabled = false;
                    textJudgeFunction.Enabled = false;
                    return;
                }

                foreach (DataRow row in tbJudgeFunction.Rows)
                {
                    listBoxJudgeFunction.Items.Add(row["Function"].ToString());
                }
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
                return;
            }
        }

        private DataTable tbMatchJudgeControlData;//tabel MatchJudgeControlData
        //Initialize All the controls' data
        private void InitAllControls()
        {
            try
            {
                tbMatchJudgeControlData = GVAR.g_ManageDB.GetMatchJudgeControlData(m_MatchID);
                if (tbMatchJudgeControlData == null)
                    return;

                //gvMatchJudges.DataSource = tbMatchJudgeControlData;

                //Get number of Intermediate points from DB 
                //gInterNum = GVAR.g_ManageDB.GetNumberOfSplit();


                //Clear the GridView
                gvMatchJudges.ContextMenuStrip = null;
                gvMatchJudges.Columns.Clear();
                //gvMatchJudges.Rows.Clear();
                if (tbMatchJudgeControlData != null)
                {
                    int gridColumnCount = 3;//Don't display IRM
                    int gridRowConut = tbMatchJudgeControlData.Rows.Count;
                    if (gridRowConut > 0)
                    {

                        #region Set Columns' name&headertext
                        //Get Columns from data table
                        gvMatchJudges.ColumnCount = gridColumnCount;

                        //Set gridview's columns' name
                        for (int i = 0; i < gridColumnCount; i++)
                        {
                            gvMatchJudges.Columns[i].Name = tbMatchJudgeControlData.Columns[i].ColumnName;
                        }
                        gvMatchJudges.Columns[0].Name = gvcMatchJudgeOrder;
                        gvMatchJudges.Columns[1].Name = gvcMatchJudgeName;
                        gvMatchJudges.Columns[2].Name = gvcMatchJudgeFunction;
                        #endregion Set Columns' name&headertext
                        #region Fill basic data to GridView, such as lane, boats.
                        //Get rows from data table
                        gvMatchJudges.Rows.Add(gridRowConut);
                        //Get data rows of basic information : Lane, boat, starttime
                        for (int r = 0; r < gridRowConut; r++)
                        {
                            gvMatchJudges.Rows[r].Cells[0].Value = tbMatchJudgeControlData.Rows[r]["Order"];
                            gvMatchJudges.Rows[r].Cells[1].Value = tbMatchJudgeControlData.Rows[r]["Name"];
                            gvMatchJudges.Rows[r].Cells[2].Value = tbMatchJudgeControlData.Rows[r]["Function"];
                            //Set row's height
                            gvMatchJudges.Rows[r].Height = GVAR.GRID_ROWHEIGHT;
                        }
                        #endregion Fill data to GridView
                        #region GridView Configuration
                        #region Set GridView contextMenu
                        //gvMatchJudges.ContextMenuStrip = contextMenuStripResults;
                        #endregion
                        #region Set Columns ReadOnly and NotSortable
                        //Set Columns NotSortable
                        for (int i = 0; i < gvMatchJudges.Columns.Count; i++)
                        {
                            gvMatchJudges.Columns[i].SortMode = DataGridViewColumnSortMode.NotSortable;
                        }
                        //Set Lane,Boat readonly
                        for (int i = 0; i < 3; i++)
                        {
                            gvMatchJudges.Columns[i].ReadOnly = true;
                        }
                        #endregion Set Columns NotSortable

                        #region Set columns' width
                        //Set Basic info's width
                        gvMatchJudges.Columns[gvcMatchJudgeOrder].Width = 40;
                        gvMatchJudges.Columns[gvcMatchJudgeName].Width = 250;
                        gvMatchJudges.Columns[gvcMatchJudgeFunction].Width = 250;
                        #endregion Set width

                        #region Config Styles
                        //Grid Cloumn Header
                        gvMatchJudges.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
                        gvMatchJudges.ColumnHeadersHeight = GVAR.GRID_HEADHEIGHT;
                        gvMatchJudges.ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
                        //Grid Row Header
                        gvMatchJudges.RowHeadersVisible = false;

                        //gvMatchJudges.RowsDefaultCellStyle.SelectionBackColor = Color.LightBlue;

                        gvMatchJudges.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;

                        gvMatchJudges.AllowUserToAddRows = false;
                        gvMatchJudges.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
                        //OVRDataBaseUtils.SetDataGridViewStyle(dataGridView);
                        gvMatchJudges.AlternatingRowsDefaultCellStyle.BackColor = System.Drawing.Color.FromArgb(202, 221, 238);
                        //dataGridView.AlternatingRowsDefaultCellStyle.Padding = new System.Windows.Forms.Padding(0, 0, 20, 0);
                        gvMatchJudges.DefaultCellStyle.BackColor = System.Drawing.Color.FromArgb(230, 239, 248);
                        //dataGridView.DefaultCellStyle.Padding = new System.Windows.Forms.Padding(0, 0, 20, 0);
                        //dataGridView.ColumnHeadersDefaultCellStyle.Padding = new System.Windows.Forms.Padding(2, 2, 2, 2);
                        gvMatchJudges.BackgroundColor = System.Drawing.Color.FromArgb(212, 228, 242);
                        gvMatchJudges.GridColor = System.Drawing.Color.FromArgb(208, 215, 229);
                        gvMatchJudges.BorderStyle = BorderStyle.Fixed3D;
                        //dataGridView.CellBorderStyle = DataGridViewCellBorderStyle.Single;

                        #endregion Config Styles
                        #region Set GridView's Height
                        gvMatchJudges.ScrollBars = ScrollBars.Vertical;

                        int rowsheight = gvMatchJudges.Rows.Count * GVAR.GRID_ROWHEIGHT;
                        int headHeight = 25;
                        gvMatchJudges.Height = headHeight * 2 + rowsheight;
                        #endregion Set GridView's Height
                        #endregion GridView Configuration
                    }
                }
                if (tbMatchJudgeControlData.Rows.Count > 0)
                {
                    //buttonAdd.Enabled = true;
                    buttonDelete.Enabled = true;
                    ButtonEdit.Enabled = true;
                    buttonOrderDown.Enabled = true;
                    buttonOrderUp.Enabled = true;
                    //gvMatchJudges.RowCount = tbMatchJudgeControlData.Rows.Count;
                }
                else
                {
                    //buttonAdd.Enabled = true;
                    buttonDelete.Enabled = false;
                    ButtonEdit.Enabled = false;
                    buttonOrderDown.Enabled = false;
                    buttonOrderUp.Enabled = false;
                }
                if ((tbJudgeFunction != null) && (tbJudgeName != null) && (tbJudgeName.Rows.Count != 0) && (tbJudgeFunction.Rows.Count != 0))
                    buttonAdd.Enabled = true;
                else
                {
                    buttonAdd.Enabled = false;
                    //buttonDelete.Enabled = false;
                    ButtonEdit.Enabled = false;
                    //buttonOrderDown.Enabled = false;
                    //buttonOrderUp.Enabled = false;
                }
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
                return;
            }
        }

        //Initialize MatchJudge's Title
        private void SetMatchJudgeTitle()
        {
            try
            {
				string Temp = GVAR.g_ManageDB.GetDataEntryTitle(m_MatchID);
                lbTitle.Text = Temp;
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
                return;
            }
        }
        //*****************************
        //Keep step with listbox
        //*****************************
        //private void cmbDescription_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    foreach (DataRow row in tbDescription.Rows)
        //    {
        //        if (row["WeatherTypeID"].ToString() == cmbDescription.SelectedValue.ToString())
        //            textDescription.Text = row["WeatherTypeLongDescription"].ToString();
        //    }
        //}
        //==========================><==============================
        #endregion

        #region Convenient For Inputting Match Judge Data
        private void addToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //this.panelEditJudge.Visible = true;
            this.listBoxJudgeFunction.Enabled = true;
            this.textJudgeFunction.Enabled = true;
            this.listBoxJudgeName.Enabled = true;
            this.textJudgeName.Enabled = true;
            this.m_ModifyState = 0;//ADD
        }

        private void changeJudgeToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //this.panelEditJudge.Visible = true;
            this.listBoxJudgeFunction.Enabled = false;
            this.textJudgeFunction.Enabled = false;
            this.listBoxJudgeName.Enabled = true;
            this.textJudgeName.Enabled = true;
            this.m_ModifyState = 1;//Update Judge
        }

        private void changeFunctionToolStripMenuItem_Click(object sender, EventArgs e)
        {
            //this.panelEditJudge.Visible = true;
            this.listBoxJudgeName.Enabled = false;
            this.textJudgeName.Enabled = false;
            this.listBoxJudgeFunction.Enabled = true;
            this.textJudgeFunction.Enabled = true;
            this.m_ModifyState = 2;//Update Function
        }

        private void textJudgeName_KeyPress(object sender, KeyPressEventArgs e)
        {
            string TempName = textJudgeName.Text + e.KeyChar.ToString();
            for (int i = 0; i < listBoxJudgeName.Items.Count; i++)
            {
                string temp = "";
                if (TempName.Length > listBoxJudgeName.Items[i].ToString().Length)
                    temp = textJudgeName.Text;
                else temp = listBoxJudgeName.Items[i].ToString().Substring(0, TempName.Length);
                if (temp.ToUpper() == TempName.ToUpper())
                {
                    listBoxJudgeName.SelectedIndex = i;
                    if (TempName.ToUpper() == tbJudgeName.Rows[i]["Name"].ToString().ToUpper())
                    {
                        textJudgeName.Text = tbJudgeName.Rows[i]["Name"].ToString();
                        m_RegisterID = (int)tbJudgeName.Rows[listBoxJudgeName.SelectedIndex]["RegisterID"];
                    }
                    return;
                }
            }
        }

        private void textJudgeName_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Up)
            {
                if (listBoxJudgeName.SelectedIndex - 1 >= 0)
                    listBoxJudgeName.SelectedIndex = listBoxJudgeName.SelectedIndex - 1;
                textJudgeName.Text = tbJudgeName.Rows[listBoxJudgeName.SelectedIndex]["Name"].ToString();
                listBoxJudgeName.SelectedIndex = listBoxJudgeName.SelectedIndex - 1;
                textJudgeName.Text = tbJudgeName.Rows[listBoxJudgeName.SelectedIndex]["Name"].ToString();
                m_RegisterID = (int)tbJudgeName.Rows[listBoxJudgeName.SelectedIndex]["RegisterID"];
            }
            if (e.KeyCode == Keys.Down)
            {
                if (listBoxJudgeName.SelectedIndex + 1 <= listBoxJudgeName.Items.Count - 1)
                    listBoxJudgeName.SelectedIndex = listBoxJudgeName.SelectedIndex + 1;
                textJudgeName.Text = tbJudgeName.Rows[listBoxJudgeName.SelectedIndex]["Name"].ToString();
                m_RegisterID = (int)tbJudgeName.Rows[listBoxJudgeName.SelectedIndex]["RegisterID"];
            }
        }

		private void listBoxJudgeFunction_Click(object sender, EventArgs e)
		{
			try
			{
				textJudgeFunction.Text = listBoxJudgeFunction.Items[listBoxJudgeFunction.SelectedIndex].ToString();
				m_FunctionID = (int)tbJudgeFunction.Rows[listBoxJudgeFunction.SelectedIndex]["FunctionID"];
			}
			catch
			{
				return;
			}
		}

		private void listBoxJudgeName_Click(object sender, EventArgs e)
		{
			try
			{
				textJudgeName.Text = listBoxJudgeName.Items[listBoxJudgeName.SelectedIndex].ToString();
				m_RegisterID = (int)tbJudgeName.Rows[listBoxJudgeName.SelectedIndex]["RegisterID"];
			}
			catch
			{
				return;
			}
		}

		private void listBoxJudgeName_DoubleClick(object sender, EventArgs e)
		{
			if (m_FunctionID > 0 && m_RegisterID > 0)
			{
				m_ModifyState = 0;//Add data
				SaveMatchJudgeData();//SaveFileDialog
				InitAllControls();
				//indictate the largest line
				if (tbMatchJudgeControlData.Rows.Count > 0)
				{
					gvMatchJudges.CurrentCell = gvMatchJudges.Rows[tbMatchJudgeControlData.Rows.Count - 1].Cells[0];
				}
			}
		}

		private void listBoxJudgeFunction_DoubleClick(object sender, EventArgs e)
		{
			if (m_FunctionID > 0 && m_RegisterID > 0)
			{
				m_ModifyState = 0;//Add data
				SaveMatchJudgeData();//SaveFileDialog
				InitAllControls();
				//indictate the largest line
				if (tbMatchJudgeControlData.Rows.Count > 0)
				{
					gvMatchJudges.CurrentCell = gvMatchJudges.Rows[tbMatchJudgeControlData.Rows.Count - 1].Cells[0];
				}
			}
		}

        private void textJudgeFunction_KeyPress(object sender, KeyPressEventArgs e)
        {
            string TempJudgeFunction = textJudgeFunction.Text + e.KeyChar.ToString();
            for (int i = 0; i < listBoxJudgeFunction.Items.Count; i++)
            {
                string temp = "";
                if (TempJudgeFunction.Length > listBoxJudgeFunction.Items[i].ToString().Length)
                    temp = textJudgeFunction.Text;
                else temp = listBoxJudgeFunction.Items[i].ToString().Substring(0, TempJudgeFunction.Length);
                if (temp.ToUpper() == TempJudgeFunction.ToUpper())
                {
                    listBoxJudgeFunction.SelectedIndex = i;
                    if (TempJudgeFunction.ToUpper() == tbJudgeFunction.Rows[i]["Function"].ToString().ToUpper())
                    {
                        textJudgeName.Text = tbJudgeFunction.Rows[i]["Function"].ToString();
                        m_FunctionID = (int)tbJudgeFunction.Rows[listBoxJudgeFunction.SelectedIndex]["FunctionID"];
                    }
                    return;
                }
            }
        }

        private void textJudgeFunction_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Up)
            {
                if (listBoxJudgeFunction.SelectedIndex - 1 >= 0)
                    listBoxJudgeFunction.SelectedIndex = listBoxJudgeFunction.SelectedIndex - 1;
                textJudgeFunction.Text = tbJudgeFunction.Rows[listBoxJudgeFunction.SelectedIndex]["Function"].ToString();
                m_FunctionID = (int)tbJudgeFunction.Rows[listBoxJudgeFunction.SelectedIndex]["FunctionID"];
            }
            if (e.KeyCode == Keys.Down)
            {
                if (listBoxJudgeFunction.SelectedIndex + 1 <= listBoxJudgeFunction.Items.Count - 1)
                    listBoxJudgeFunction.SelectedIndex = listBoxJudgeFunction.SelectedIndex + 1;
                textJudgeFunction.Text = tbJudgeFunction.Rows[listBoxJudgeFunction.SelectedIndex]["Function"].ToString();
                m_FunctionID = (int)tbJudgeFunction.Rows[listBoxJudgeFunction.SelectedIndex]["FunctionID"];
            }
        }

        private void ButtonEdit_Click(object sender, EventArgs e)
        {
            m_ModifyState = 2;//Update data
            SaveMatchJudgeData();//SaveFileDialog
            int Temp = gvMatchJudges.CurrentRow.Index;
            InitAllControls();
            gvMatchJudges.CurrentCell = gvMatchJudges.Rows[Temp].Cells[0];
        }

        private void buttonAdd_Click(object sender, EventArgs e)
        {
            m_ModifyState = 0;//Add data
            SaveMatchJudgeData();//SaveFileDialog
            InitAllControls();
            //indictate the largest line
			if (tbMatchJudgeControlData.Rows.Count > 0)
			{
				gvMatchJudges.CurrentCell = gvMatchJudges.Rows[tbMatchJudgeControlData.Rows.Count - 1].Cells[0];
			}
        }

        private void buttonDelete_Click(object sender, EventArgs e)
        {
            m_ModifyState = 1;//Delete data
            m_ServantNum = (int)tbMatchJudgeControlData.Rows[gvMatchJudges.CurrentRow.Index]["ServantNum"];
            SaveMatchJudgeData();//SaveFileDialog
            int Temp = gvMatchJudges.CurrentRow.Index;//get the current row's index 
            InitAllControls();

            //indictate the largest line or the current line
            if (Temp < tbMatchJudgeControlData.Rows.Count)
                gvMatchJudges.CurrentCell = gvMatchJudges.Rows[Temp].Cells[0];
            else
            {
                if (tbMatchJudgeControlData.Rows.Count > 0)
                    gvMatchJudges.CurrentCell = gvMatchJudges.Rows[tbMatchJudgeControlData.Rows.Count - 1].Cells[0];
            }
        }

        private void buttonOrderUp_Click(object sender, EventArgs e)
        {
            m_ModifyState = 3;//Update Order data
            m_Order = ((int)tbMatchJudgeControlData.Rows[gvMatchJudges.CurrentRow.Index]["Order"]) - 1;
            if (m_Order < 1)
                m_Order = 1;
            SaveMatchJudgeData();//SaveFileDialog

            string str = tbMatchJudgeControlData.Rows[gvMatchJudges.CurrentRow.Index]["ServantNum"].ToString();
            InitAllControls();
            for (int i = 0; i < tbMatchJudgeControlData.Rows.Count; i++)
            {
                if (tbMatchJudgeControlData.Rows[i]["ServantNum"].ToString().Equals(str))
                {
                    gvMatchJudges.CurrentCell = gvMatchJudges.Rows[i].Cells[0];
                    break;
                }
            }
        }

        private void buttonOrderDown_Click(object sender, EventArgs e)
        {
            m_ModifyState = 3;//Update Order data
            m_Order = ((int)tbMatchJudgeControlData.Rows[gvMatchJudges.CurrentRow.Index]["Order"]) + 1;
            if (m_Order > tbMatchJudgeControlData.Rows.Count)
                m_Order = tbMatchJudgeControlData.Rows.Count;
            SaveMatchJudgeData();//SaveFileDialog

            string str = tbMatchJudgeControlData.Rows[gvMatchJudges.CurrentRow.Index]["ServantNum"].ToString();
            InitAllControls();
            for (int i = 0; i < tbMatchJudgeControlData.Rows.Count; i++)
            {
                if (tbMatchJudgeControlData.Rows[i]["ServantNum"].ToString().Equals(str))
                {
                    gvMatchJudges.CurrentCell = gvMatchJudges.Rows[i].Cells[0];
                    break;
                }
            }
        }

        private void gvMatchJudges_Click(object sender, EventArgs e)
        {
            if (tbMatchJudgeControlData.Rows.Count > 0)
            {
                m_FunctionID = (int)tbMatchJudgeControlData.Rows[gvMatchJudges.CurrentRow.Index]["FunctionID"];
                m_RegisterID = (int)tbMatchJudgeControlData.Rows[gvMatchJudges.CurrentRow.Index]["RegisterID"];

                string TempName = tbMatchJudgeControlData.Rows[gvMatchJudges.CurrentRow.Index]["NameWithNOC"].ToString();
                for (int i = 0; i < listBoxJudgeName.Items.Count; i++)
                {
                    string temp = listBoxJudgeName.Items[i].ToString();
                    if (temp.ToUpper() == TempName.ToUpper())
                    {
                        listBoxJudgeName.SelectedIndex = i;
                        textJudgeName.Text = tbMatchJudgeControlData.Rows[gvMatchJudges.CurrentRow.Index]["Name"].ToString(); ;
                        continue;
                    }
                }

                string TempJudgeFunction = tbMatchJudgeControlData.Rows[gvMatchJudges.CurrentRow.Index]["Function"].ToString();
                for (int i = 0; i < listBoxJudgeFunction.Items.Count; i++)
                {
                    string temp = listBoxJudgeFunction.Items[i].ToString();
                    if (temp.ToUpper() == TempJudgeFunction.ToUpper())
                    {
                        listBoxJudgeFunction.SelectedIndex = i;
                        textJudgeFunction.Text = TempJudgeFunction;
                        return;
                    }
                }
            }
        }

		private void gvMatchJudges_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
		{
			/*
			if (e.RowIndex > gvMatchJudges.RowCount - 1 || e.RowIndex < 0)
				return;

			int iSelRowIdx = e.RowIndex;

			m_ModifyState = 1;//Delete data
			m_ServantNum = (int)tbMatchJudgeControlData.Rows[iSelRowIdx]["ServantNum"];
			SaveMatchJudgeData();//SaveFileDialog
			int Temp = gvMatchJudges.CurrentRow.Index;//get the current row's index 
			InitAllControls();

			//indictate the largest line or the current line
			if (Temp < tbMatchJudgeControlData.Rows.Count)
				gvMatchJudges.CurrentCell = gvMatchJudges.Rows[Temp].Cells[0];
			else
			{
				if (tbMatchJudgeControlData.Rows.Count > 0)
					gvMatchJudges.CurrentCell = gvMatchJudges.Rows[tbMatchJudgeControlData.Rows.Count - 1].Cells[0];
			}
			*/
		}
        #endregion

        #region Form Close and Save Data

        private void SaveMatchJudgeData()
        {
            try
            {
                if (m_ModifyState == 0)
                {
                    if ((m_FunctionID > 0) && (m_RegisterID > 0))
                        GVAR.g_ManageDB.UpdateMatchJudgeDataToDB(m_MatchID, null, m_RegisterID.ToString(), m_FunctionID.ToString(), null, m_ModifyState);
                }
                if (m_ModifyState == 1)//delete
                    GVAR.g_ManageDB.UpdateMatchJudgeDataToDB(m_MatchID, m_ServantNum.ToString(), m_RegisterID.ToString(), null, null, 1);
                if (m_ModifyState == 2)
                {
                    m_ServantNum = (int)tbMatchJudgeControlData.Rows[gvMatchJudges.CurrentRow.Index]["ServantNum"];
                    m_Order = (int)tbMatchJudgeControlData.Rows[gvMatchJudges.CurrentRow.Index]["Order"];

                    GVAR.g_ManageDB.UpdateMatchJudgeDataToDB(m_MatchID, m_ServantNum.ToString(), m_RegisterID.ToString(), m_FunctionID.ToString(), m_Order.ToString(), m_ModifyState);
                }
                if (m_ModifyState == 3)
                {
                    m_ServantNum = (int)tbMatchJudgeControlData.Rows[gvMatchJudges.CurrentRow.Index]["ServantNum"];

                    GVAR.g_ManageDB.UpdateMatchJudgeDataToDB(m_MatchID, m_ServantNum.ToString(), m_RegisterID.ToString(), m_FunctionID.ToString(), m_Order.ToString(), m_ModifyState);
                }
                m_bModifyFlag = true;
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
                return;
            }
        }
        #endregion

        private void frmOVRWRMatchJudgeConfig_FormClosed(object sender, FormClosedEventArgs e)
        {
            if (m_bModifyFlag == true)
            {
                GVAR.g_WRPlugin.DataChangedNotify(AutoSports.OVRCommon.OVRDataChangedType.emMatchOfficials,
                    -1, -1, -1, MatchID, MatchID, null);
            }
        }
    }
}
